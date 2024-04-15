import { FC, useEffect, useState } from 'react';
import { useInView } from 'react-intersection-observer';
import axios from 'axios';

import Post from './Post';

/**
 * This is where the posts are, by following or trending.
 */
const Home: FC = () => {
    const [posts, setPosts] = useState<{ postId: string }[]>([]);

    const [category, setCategory] = useState<'following' | 'trending'>('following');
    const [page, setPage] = useState<number>(0);
    const [hasNextPage, setHasNextPage] = useState<boolean>(true);

    const [moreButtonReference, inView ] = useInView({ root: document.querySelector('#dashboard-outlet'), threshold: 1.0 });

    /**
     * Use this to get the posts at category and page
     * @param category the category of the post
     * @param page the current page
     * @returns the postIds in an array
     */
    const getPosts = async (category: 'following' | 'trending', page: number) => {
        const response = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/list`, { category, page }, { withCredentials: true });
        return response.data.posts as { postId: string }[];
    }

    /**
     * Load category resets the page state.
     * @param category 
     */
    const loadCategory = async (category: 'following' | 'trending') => {
        setCategory(category);

        setPage(0);
        setPosts([]);
        setHasNextPage(true);

        // this becomes unnecessary due to the observer
        // setPosts(await getPosts(category, 0)); 
    }

    /**
     * This is the logic to load more posts through
     * infinite scrolling. Had wasted time figuring out a lot of things here.
     */
    const loadMorePosts = async () => {
        if (!hasNextPage) return;

        const more = await getPosts(category, page);
    
        if (more.length > 0) {
            setPosts([...posts, ...more]);
            setPage(page + 1);
        } else {
            setHasNextPage(false);
        }
    }

    // when the next button is inView (initially it is) we load more posts
    useEffect(() => {
        if (inView) 
            loadMorePosts();
    }, [ category, inView ]);

    return (
        <div className='sm:p-2 sm:w-3/4 sm:mx-auto rounded-lg'>
            <div className='flex'>
                <button className='px-5 py-3 me-2 rounded-t-lg hover:bg-neutral-200' style={{ backgroundColor: category === 'following' ? 'white' : undefined, fontWeight: category === 'following' ? 'bold' : undefined }} onClick={() => loadCategory('following')}>Following</button>
                <button className='px-5 py-3 me-2 rounded-t-lg hover:bg-neutral-200' style={{ backgroundColor: category === 'trending' ? 'white' : undefined, fontWeight: category === 'trending' ? 'bold' : undefined }} onClick={() => loadCategory('trending')}>Trending</button>
            </div>
            <div className='bg-white rounded-tl-none rounded-lg'>   
                {
                    posts.map(post => {
                        const { postId } = post;
                        return <Post key={postId} postId={postId} className='hover:bg-neutral-100' />
                    })
                }
                <div className='w-full text-center p-5 hover:bg-neutral-200' ref={moreButtonReference}>{hasNextPage ? 'Loading' : 'No more posts'}</div>
            </div>
        </div>
    )
};

export default Home;