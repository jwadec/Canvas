# Supercharge your LMS Administration through Automation with the Canvas APIs

## Getting Started

- Import [Canvas-Power-Automate-Custom-Connector-Swagger.json](https://raw.githubusercontent.com/jwadec/Canvas/main/InstructureCon2021/Canvas-Power-Automate-Custom-Connector-Swagger.json) into Microsoft Power Automate as a custom connector using "Import an OpenAPI from a URL"
- Set a Connector name
- Paste the URL for the swagger code
- Select Import
- Select Continue

## Special Note

For best practices, you may want to set up a separate production and test connector.

## Setting up developer key in Canvas

- Navigate to Developer Keys from Admin screen
- Select the + Developer Key and choose + API Key
- Set a name (Ex: Microsoft Power Automate)
- Set an owner email 
- Set redirect URI to https://global.consent.azure-apim.net/redirect
- Keep Client Credentials Audience as Canvas
- Optionally enforce scoping (This has not been tested - You may have to supply the scopes on the Power Automate side when the connector is set up.
- Select Save
- Make a note of the Client ID and Client Secret.

## Setting up the Custom Connector in Microsoft Power Automate

- Optionally upload an icon
- Optionally set a background color
- Update the description
- Update the host to your Instructure subaccount
- Select Security to move to the next part of the setup
- Keep Authentication Type as OAuth 2.0 and Identify provider as Generic OAuth 2
- Provide the Client ID and Client Secret from the Canvas Developer Key steps above
- Ensure that the Authorization URL points to your Canvas subaccount: https://canvas.instructure.com/login/oauth2/auth
- Ensure that the Token URL points to your Canvas URL: https://canvas.instructure.com/login/oauth2/token
- Ensure that the Refresh URL points to your Canvas URL: https://canvas.instructure.com/login/oauth2/token
- Supply the scope information if you set specific endpoints when the developer key was created in Canvas
- Make note of the Redirect URL. My instance of Microsoft Power Automate produced this URL: https://global.consent.azure-apim.net/redirect If your URL is different, ensure that the correct one is loaded into the developer keys redirect URL. This URL will not generate until you save the connector.
- Select Definitions to move to the next part of the set up

## Checking  Definitions 

- The Open API file loaded 13 Canvas API Endpoints:
-  Create Page
-  Create Module
-  Add contents to a module
-  Update Module
-  Course Menu Tools (Tabs positioning)
-  Create course
-  Create section
-  Create users
-  Get section information
-  Copy a Course
-  Get User Information
-  Check progress of a job

Note: If you need additional endpoints, you can add them Under Actions -> New Actions -> Import from Sample. Set the verb GET, PUT, POST, or DELETE. Provide the JSON body and select import. Repeat these steps for the response.

## Test the Connection

- Prior to moving to Step 5, save the connector by select the Create connect button. If you previously saved, this button will be called Updte connector.
- With the connector saved, navigate to Step 5 - Test. 
- Create a new connection. This will launch Canvas and have a familiar workflow to other apps where it requests permission to continue. 
- With a connection established, you can check to see if the connector was successful. Use a get operation like USER-CREATE to see if a user search appears.


With these steps complete, the connector can now be used in Microsoft Power Automate.
