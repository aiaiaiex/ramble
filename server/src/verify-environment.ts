import 'dotenv/config';

/**
 * This ensures that that the required environment variables for the server is present before 
 * execution of other code. If the variables are missing, they will be specified and then the process
 * will end.
 */
function verifyEnvironmentVariables() {
    const requiredVariables: (keyof typeof process.env)[] = [ 
        // 'MYSQL_PASSWORD', this is now optional
        // 'SERVER_PORT', is also optional
        // 'CLIENT_URL', is gone due to CORs
        'MYSQL_HOST', 
        'MYSQL_USER', 
        'MYSQL_DATABASE', 
        'SERVER_JWT_KEY', 
        'COOKIE_SAME_SITE', 
        'COOKIE_SECURE',
        'AWS_ACCESS_KEY',
        'AWS_SECRET_ACCESS_KEY',
        'AMAZON_S3_REGION',
        'AMAZON_S3_BUCKET'
    ].filter(key => process.env[key] === undefined);

    if (requiredVariables.length === 0) return;

    // we don't want to start the program when the required environment variables are missing
    console.error(`Missing environment variables. Please define these: ${requiredVariables.join(', ')}`);
    process.exit();
}

export default verifyEnvironmentVariables();
    