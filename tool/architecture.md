![architecture][1]

The whole app is divided into three Containers:

1. nginx is running in `nginx` Container, which handles requests and makes responses.
2. PHP or PHP-FPM is put in `PHP-FPM` Container, it retrieves php scripts from host, interprets, executes then responses to Nginx. If necessary, it will connect to `MySQL` as well.
3. MySQL lies in `MySQL` Container, 

Our app scripts are located on host, you can edit files directly without rebuilding/restarting whole images/containers.

