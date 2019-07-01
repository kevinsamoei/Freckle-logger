# Freckle-logger
Batch logging time entries in freckle

## Usage

To make use of this script, ensure you have cloned the project.

For now this is most things need to be done. Hopefully this will change soon

To use:
- open the file `freckle-logger.rb`
- Create an instance of  the class at the end of the file

    ```
    freckle = FreckleLogger.new(token, hours, client_name, days)
    freackle.log_hours
    ```

That is all

- Example


        freckle = FreckleLogger.new("somereallylong tokenacquiredfromfreckleapiauthtokens", 8, namely, 20)
        freckle.log_hours
- Then run the logger

        ruby freckle-logger.rb

Enjoy

#### Requirements

You might be wondering what token is, what hours is or even what is the project name
Worry no more.

- **Token** - this is the authentication token from freckle. To get the token, login to your freckle account. Navigate to: Connected apps on the sidebar. Then click the Freckle APi tab and then on Personal Access Tokens. You will be provided with a long string. Copy and use it in the class
- **Hours** - The number of hours you want to log
- **client_name** - This is the name of your project/client on freckle. If you work for github you will use, github as the client name.
- **days** - This is the number of days back you want to log. If you want to log time from one month ago till now, enter 30 as the days.

Right now the tags are hardcorded for billable hours for people on partner engagement. The hardcorded tags are #parnerEngagement and #clientEngagement. Hopefully this willl change soon.

### TODO

- Make it a CLI or a chrome extension??
- Not hardcode tags/description
- Consider non ruby users - probably by making it a chrome extension or anything else that will make it easy to use.