import { FC, FormEventHandler, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

import useAccount from './hooks/account';

/**
 * This is the log-in component which allows us to login 
 * through an existing account.
 */
const LogIn: FC = () => {
    const navigate = useNavigate();
    const { setUsername: setGlobalUserName, setUserCommonName, setIsLoggedIn } = useAccount();

    const [ username, setUsername ] = useState<string>('');
    const [ password, setPassword ] = useState<string>('');
    const [ error, setError ] = useState<string>('');

    const gotoSignUp = () => navigate('/welcome/signup');

    const onInputUsername: FormEventHandler<HTMLInputElement> = (event) => {
        const value = (event.target as HTMLInputElement).value.trim();
        setUsername(value);
    }

    const onInputPassword: FormEventHandler<HTMLInputElement> = (event) => {
        const value = (event.target as HTMLInputElement).value.trim();
        setPassword(value);
    }

    const login = async () => {
        try {
            // we do a log-in and retrieval of information through another route
            await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/login`, { username, password }, { withCredentials: true });
            const account = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/view`, {}, { withCredentials: true });
            const data = account.data as { username: string, userCommonName: string };
            
            // when we successfully get the data, we are then logged-in
            setGlobalUserName(data.username);
            setUserCommonName(data.userCommonName);
            setIsLoggedIn(true);
        } catch {
            setError('Username or password is incorrect!');
        }
    }

    return (
        <form>
            <div className="mb-4">
                <label className="block text-sm mb-2" htmlFor="username">Username</label>
                <input value={username} onInput={onInputUsername} className="shadow border rounded-md w-full py-2 px-3" type="text" autoComplete="username" placeholder="Username" />
            </div>
            <div className="mb-4">
                <label className="block text-sm mb-2" htmlFor="password">Password</label>
                <input value={password} onInput={onInputPassword} onKeyDown={event => event.key === 'Enter' && login()} className="shadow border rounded w-full py-2 px-3 mb-3" type="password" autoComplete="current-password" placeholder="Password" />
                <p className="text-red-500 text-xs italic">{error}</p>
            </div>
            <div className="flex items-center justify-between">
                <a onClick={gotoSignUp} className="inline-block align-baseline text-sm text-slate-600 hover:text-slate-950 cursor-pointer underline">Create an account?</a>
                <button onClick={login} className="bg-slate-800 hover:bg-slate-950 text-white py-2 px-10 rounded-full" type="button">
                    Log In
                </button>
            </div>
        </form>
    )
};

export default LogIn;