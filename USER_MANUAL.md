# CustoFlow System User Guide

## 1. Overview

CustoFlow is an automated customer feedback management system designed to streamline the collection, categorization, and analysis of customer feedback. The platform provides a comprehensive solution for businesses to integrate feedback forms into their websites, automatically process incoming feedback, and gain actionable insights through sentiment analysis and analytics.

The system leverages Firebase for authentication and data storage, integrates with N8N for workflow automation, and provides ready-to-use code snippets for seamless website integration. CustoFlow eliminates manual feedback management by automating email responses, categorizing feedback by sentiment, escalating negative feedback to support teams, and generating regular reports.

Key capabilities include multi-department support, API-based integration, AI-powered sentiment analysis, automated email notifications, and real-time analytics dashboards. The platform is accessible via web browsers and supports responsive design for desktop, tablet, and mobile devices.

## 2. Target Audience

### 2.1 Primary Users

The primary users of CustoFlow are:

- **Business Owners and Managers**: Individuals responsible for monitoring customer satisfaction and feedback across their organization
- **Customer Support Teams**: Teams that need to track, respond to, and escalate customer feedback efficiently
- **Marketing and Product Teams**: Professionals who analyze customer sentiment and feedback to improve products and services
- **Department Heads**: Leaders managing feedback for specific departments (Sales, Support, Technical, etc.)
- **Web Developers**: Technical staff responsible for integrating feedback forms into company websites

### 2.2 System Administrators

System administrators include:

- **Company Account Administrators**: Users who create and manage the company account, generate API keys, and configure system settings
- **Department Managers**: Users with permissions to create departments, manage webhook URLs, and view department-specific feedback
- **Integration Specialists**: Technical personnel responsible for implementing feedback forms on external websites using provided integration code

## 3. Getting Started

### 3.1 System Requirements

**Supported Platforms:**

- Web browsers (Chrome, Firefox, Safari, Edge - latest versions recommended)
- Windows desktop application
- macOS desktop application
- Linux desktop application
- Android mobile application
- iOS mobile application

**Technical Requirements:**

- Active internet connection for cloud synchronization
- Modern web browser with JavaScript enabled
- Firebase account (configured by system administrators)
- N8N automation platform (for workflow automation)

**Recommended Specifications:**

- Screen resolution: 1024x768 or higher
- RAM: 4GB minimum, 8GB recommended
- Stable internet connection with minimum 1 Mbps speed

### 3.2 Installing the Application

**Web Application:**
The CustoFlow web application requires no installation. Simply navigate to the application URL using your preferred web browser.

**Desktop Application:**

1. Download the appropriate installer for your operating system (Windows, macOS, or Linux)
2. Run the installer and follow the on-screen instructions
3. Launch CustoFlow from your applications folder or start menu
4. The application will automatically check for updates on startup

**Mobile Application:**

1. Download CustoFlow from Google Play Store (Android) or App Store (iOS)
2. Install the application on your device
3. Grant necessary permissions when prompted
4. Launch the application and proceed to login

**Development Setup:**
For developers setting up the application from source:

1. Install Flutter SDK version 3.10.7 or higher
2. Clone the repository from version control
3. Run `flutter pub get` to install dependencies
4. Configure Firebase credentials in `lib/main.dart`
5. Run `flutter run -d chrome` for web or specify target device

## 4. Logging into the System

**Initial Access:**

1. Navigate to the CustoFlow application URL or launch the desktop/mobile application
2. On the landing page, click the **Login** button in the top navigation bar or the **Get Started Free** button to create a new account

**Creating a New Account (Sign Up):**

1. Click **Get Started Free** or navigate to the Sign Up tab
2. Complete the registration form with the following information:
   - **Company Name**: Enter your organization's name
   - **Email Address**: Provide a valid business email address
   - **Password**: Create a secure password (minimum 6 characters)
   - **Confirm Password**: Re-enter your password for verification
3. Click the **Sign Up** button
4. The system will:
   - Create your company account in the Firebase database
   - Generate a unique API key for your organization
   - Generate a unique Company ID
   - Send account credentials and setup instructions to your email via N8N webhook
5. Upon successful registration, you will be redirected to the Dashboard with a Welcome onboarding dialog

**Logging into an Existing Account:**

1. Navigate to the Login tab on the authentication page
2. Enter your registered **Email Address**
3. Enter your **Password**
4. Click the **Login** button
5. If credentials are valid, you will be redirected to your company Dashboard

**Password Reset:**

If you forget your password:

1. Click the **Forgot Password?** link on the login form
2. Enter your registered email address
3. Click **Send Reset Link**
4. Check your email for password reset instructions from Firebase Authentication
5. Follow the link in the email to create a new password
6. Return to the login page and sign in with your new password

**Sign Out:**

To log out of your account:

1. Navigate to the Dashboard
2. Click the **Sign Out** button (logout icon) in the top-right corner of the app bar
3. You will be redirected to the landing page

## 5. Core Features & How to Use Them

**Dashboard Overview:**

The Dashboard is the central hub for managing your feedback system. It displays:

- Company information (name, admin email, API key)
- Analytics overview (total feedback, positive feedback, negative feedback)
- List of departments with webhook URLs
- Quick access to integration guide and help resources

**Company Information Section:**

Located at the top of the Dashboard, this section displays:

- **Company Name**: Your organization's name as registered
- **Admin Email**: The email address associated with your account
- **API Key**: Your unique API key for integration purposes
  - Click the **Copy** icon next to the API key to copy it to your clipboard
  - This key is required for authenticating feedback submissions from your website

**Analytics Overview:**

The analytics section displays three key metrics in card format:

- **Total Feedback**: Total number of feedback submissions received
- **Positive Feedback**: Count of feedback items categorized as positive sentiment
- **Negative Feedback**: Count of feedback items categorized as negative sentiment

Each metric is displayed with a corresponding icon and color coding for easy visualization.

**Department Management:**

Departments allow you to organize feedback by different areas of your business (e.g., Sales, Support, Technical, Billing).

**Creating a Department:**

1. Click the **+ Add Department** button (desktop) or the floating action button (mobile)
2. In the dialog that appears, enter the **Department Name** (e.g., "Customer Support", "Sales Team")
3. Click **Create**
4. The system automatically generates a webhook URL for the new department
5. The department appears in the Departments list with its associated webhook URL

**Viewing Departments:**

The Departments section lists all created departments, displaying:

- Department name
- Webhook URL (truncated for display)
- Copy button to copy the webhook URL to clipboard

**Copying Webhook URLs:**

1. Locate the department in the Departments list
2. Click the **Copy** icon next to the webhook URL
3. A confirmation message appears: "Webhook URL copied!"
4. Use this URL in your integration code to route feedback to the specific department

**Integration Guide:**

The Integration Guide provides complete instructions and code for adding feedback forms to your website.

**Accessing the Integration Guide:**

1. Click the **Integration Instructions** icon in the app bar
2. A dialog opens displaying the integration guide

**Integration Methods:**

The guide provides three methods to integrate CustoFlow:

**Method 1: Copy HTML Code**

1. Review the step-by-step instructions in the blue "How to Integrate" box
2. Scroll to the "Integration Code" section
3. Click the **Copy** button to copy the complete HTML and JavaScript code
4. Paste the code into your website's HTML file
5. The code includes a pre-configured feedback button and submission function

**Method 2: View Full Code**

1. The code is displayed in a scrollable text area with monospace font
2. You can select specific portions of the code if needed
3. The code includes:
   - HTML button element with onclick handler
   - JavaScript async function for collecting feedback
   - Fetch API call to send data to webhook
   - User prompts for message and email
   - Email validation logic
   - Success/error message handling

**Method 3: VS Code Copilot Integration**

1. Scroll to the "OR" divider in the integration guide
2. Locate Step 4 with the AI sparkle icon
3. Review the Copilot prompt that includes:
   - Instructions for creating a feedback button
   - Webhook URL with your credentials
   - JSON body structure with required fields
   - Validation requirements
4. Click **Copy Prompt** button
5. Open VS Code and paste the prompt into GitHub Copilot
6. Copilot will automatically generate the feedback integration code for you

**Generated Code Features:**

The integration code automatically includes:

- Prompt for customer feedback message
- Prompt for customer email address
- Email format validation using regex
- Submission to the correct webhook URL
- Your Company ID embedded in the request
- Your API Key embedded in the request
- Admin email included in the payload
- Timestamp in ISO format
- Success and error message alerts
- Try-catch error handling

## 6. Step-by-Step User Workflows

**Workflow 1: Setting Up a New Company Account**

1. Navigate to the CustoFlow landing page
2. Click **Get Started Free**
3. Fill in the Sign Up form:
   - Company Name: "ABC Corporation"
   - Email: "admin@abccorp.com"
   - Password: Create a secure password
   - Confirm Password: Re-enter password
4. Click **Sign Up**
5. Wait for account creation (system processes in background)
6. Review the Welcome onboarding dialog
7. Note your API key displayed in the dialog
8. Click **Create First Department** or **Got it!**
9. If creating first department, enter name (e.g., "Customer Support")
10. Click **Create**
11. Your account is now ready for integration

**Workflow 2: Integrating Feedback Form on Website**

1. Log into your CustoFlow Dashboard
2. Click the **Integration Instructions** icon
3. Review the "How to Integrate" instructions
4. Click **Copy** button in the Integration Code section
5. Open your website's HTML file in a code editor
6. Paste the copied code into the `<body>` section where you want the feedback button
7. Save the HTML file
8. Upload the updated file to your web server
9. Test the feedback button on your live website:
   - Click "Send Feedback" button
   - Enter a test message when prompted
   - Enter a test email when prompted
   - Verify success message appears
10. Return to CustoFlow Dashboard to verify feedback was received (check Total Feedback count)

**Workflow 3: Using VS Code Copilot for Integration**

1. Log into your CustoFlow Dashboard
2. Click the **Integration Instructions** icon
3. Scroll to the "OR" section with the AI icon
4. Click **Copy Prompt** button under the Copilot instructions
5. Open Visual Studio Code
6. Open the HTML file where you want to add feedback functionality
7. Activate GitHub Copilot (Ctrl+I or Cmd+I)
8. Paste the copied prompt into Copilot chat
9. Review the code generated by Copilot
10. Insert the generated code into your HTML file
11. Save and deploy to your website
12. Test the feedback functionality

**Workflow 4: Managing Multiple Departments**

1. Log into your CustoFlow Dashboard
2. Click **+ Add Department** button
3. Enter "Sales Team" and click **Create**
4. Repeat for additional departments:
   - "Technical Support"
   - "Billing Department"
   - "Product Feedback"
5. Each department now has a unique webhook URL
6. Copy the webhook URL for "Sales Team"
7. Integrate this specific webhook into your sales page
8. Copy the webhook URL for "Technical Support"
9. Integrate this webhook into your support portal
10. Feedback from each page will be categorized by department

**Workflow 5: Monitoring Feedback Analytics**

1. Log into your CustoFlow Dashboard
2. Review the Analytics Overview section
3. Note the Total Feedback count
4. Compare Positive vs Negative feedback ratios
5. If Negative Feedback is high:
   - Contact your support team
   - Review recent customer interactions
   - Implement improvements based on feedback themes
6. If Positive Feedback is high:
   - Share success metrics with team
   - Identify what customers appreciate
   - Amplify successful practices

**Workflow 6: Recovering a Forgotten Password**

1. Navigate to the CustoFlow login page
2. Click **Forgot Password?** link
3. Enter your registered email address
4. Click **Send Reset Link**
5. Check your email inbox for the password reset message
6. Click the reset link in the email
7. Enter your new password
8. Confirm your new password
9. Click **Reset Password**
10. Return to login page and sign in with new credentials

## 7. System Status & Notifications

**In-App Notifications:**

CustoFlow displays temporary notifications (SnackBars) for various system events:

- **Success Notifications** (green background):
  - "Department created successfully!"
  - "Code copied to clipboard!"
  - "API Key copied!"
  - "Webhook URL copied!"
  - "Copilot prompt copied to clipboard!"

- **Information Notifications** (blue background):
  - Account creation confirmations
  - Data synchronization messages

- **Error Notifications** (red background):
  - "Error creating department: [error details]"
  - Login failures
  - Network connectivity issues
  - Invalid form submissions

**Loading States:**

The application displays loading indicators during:

- Initial dashboard data loading (circular progress indicator with gradient background)
- Authentication operations (overlay with loading message)
- Department creation
- Firebase data fetching

**Email Notifications:**

Users receive email notifications via the N8N webhook system for:

- Account creation and welcome message
- API key delivery
- Setup instructions
- Weekly feedback reports (when configured)
- Negative feedback escalations (when configured)

**System Status Indicators:**

- **Firebase Connection**: Automatic background connection status
- **Authentication State**: Maintained throughout session
- **Data Synchronization**: Real-time updates from Firestore

## 8. Administrator Functions

### 8.1 Managing Records/Entries

**Department Management:**

Administrators can create and manage departments to organize feedback collection:

**Creating Departments:**

1. Access the Dashboard
2. Click **+ Add Department** (or floating action button on mobile)
3. Enter a descriptive department name
4. System validates the name is not empty
5. Click **Create** to save the department
6. System automatically generates webhook URL
7. Department appears in the list with copy functionality

**Viewing Department List:**

- All departments are displayed in the main Dashboard
- Each department card shows name and webhook URL
- Departments are stored in Firestore under `companies/{userId}/departments`

**Copying Department Webhooks:**

- Click copy icon next to any department's webhook URL
- URL is copied to clipboard for integration purposes

### 8.2 Managing System Settings

**API Key Management:**

Every company account has a unique API key generated at registration:

- Format: `cfk_[timestamp]_[random6digits]`
- Example: `cfk_1769673888338_289906`
- Display location: Dashboard company information section
- Copy functionality: Click copy icon to copy API key

**Company Profile:**

Administrators can view company information on the Dashboard:

- Company Name (set during registration)
- Admin Email (account email address)
- Company ID (Firebase user ID)
- Created date (stored in Firestore)

**Firebase Configuration:**

System administrators with code access can configure:

- Firebase project credentials in `lib/main.dart`
- Authentication providers (currently Email/Password enabled)
- Firestore security rules
- N8N webhook URLs for automation

**Webhook Configuration:**

Default webhook URL structure:

- Test webhook: `http://localhost:5678/webhook-test/[webhook-id]`
- Production: Configure N8N instance with appropriate endpoints
- Each department receives a unique webhook ID

### 8.3 Viewing Reports & Results

**Analytics Dashboard:**

The main Dashboard provides real-time analytics:

**Total Feedback Metric:**

- Displays count of all feedback submissions
- Data source: Firestore `companies/{userId}/feedback` collection
- Updates in real-time as new feedback arrives
- Icon: Assessment icon with purple color scheme

**Positive Feedback Metric:**

- Count of feedback items with "positive" sentiment
- Sentiment analysis performed by N8N workflow
- Icon: Thumbs up with green color scheme
- Useful for measuring customer satisfaction

**Negative Feedback Metric:**

- Count of feedback items with "negative" sentiment
- Critical for identifying customer issues
- Icon: Thumbs down with red color scheme
- Triggers escalation notifications when configured

**Department-Level Reporting:**

While not yet implemented in the UI, feedback data structure supports:

- Filtering feedback by department
- Department-specific analytics
- Custom reporting queries via Firestore

**Data Structure:**

Feedback records stored in Firestore contain:

- `message`: Customer feedback text
- `email`: Customer email address
- `adminEmail`: Company admin email
- `timestamp`: ISO 8601 timestamp
- `companyId`: Company identifier
- `apiKey`: Authentication key
- `sentiment`: "positive" or "negative" (set by N8N)
- `department`: Associated department (when configured)

**Exporting Data:**

Administrators can access raw data through:

- Firebase Console: Navigate to Firestore Database
- Query the `companies/{userId}/feedback` collection
- Export to JSON or CSV format using Firebase tools
- Integrate with reporting tools via Firebase REST API

## 9. Frequently Asked Questions (FAQ)

**Q1: What is CustoFlow?**  
A: CustoFlow is an automated customer feedback management system that helps businesses collect, categorize, and analyze customer feedback through integrated forms, automated workflows, and real-time analytics.

**Q2: How much does CustoFlow cost?**  
A: The landing page indicates a free trial is available with no credit card required. Specific pricing tiers are not defined in the current implementation.

**Q3: What is an API key and where do I find it?**  
A: An API key is a unique identifier that authenticates feedback submissions from your website to your CustoFlow account. You can find your API key on the Dashboard in the Company Information section. Click the copy icon to copy it to your clipboard.

**Q4: How do I add a feedback form to my website?**  
A: Click the Integration Instructions icon on your Dashboard, copy the provided HTML/JavaScript code, and paste it into your website's HTML file where you want the feedback button to appear.

**Q5: What is a webhook URL?**  
A: A webhook URL is an endpoint that receives feedback data from your website and processes it through the CustoFlow system. Each department has its own webhook URL for organizing feedback.

**Q6: Can I have multiple departments?**  
A: Yes, you can create unlimited departments to organize feedback by different areas of your business such as Sales, Support, Technical, Billing, etc.

**Q7: How does sentiment analysis work?**  
A: CustoFlow uses AI-powered analysis through N8N workflows to automatically categorize feedback as positive or negative based on the message content.

**Q8: What happens to negative feedback?**  
A: Negative feedback is automatically flagged in the system and can be configured to trigger immediate notifications to your support team for rapid response.

**Q9: Can I customize the feedback form?**  
A: The provided integration code can be customized to match your website's design. The feedback button text, styling, and prompts can be modified in the HTML and JavaScript code.

**Q10: What data does the feedback form collect?**  
A: The standard feedback form collects the customer's message, email address, submission timestamp, and automatically includes your company ID, API key, and admin email.

**Q11: Is my data secure?**  
A: Yes, CustoFlow uses Firebase Authentication and Firestore with security rules that ensure only authenticated users can access their own company data.

**Q12: Can I export my feedback data?**  
A: Yes, administrators can access and export feedback data through the Firebase Console or by using Firebase's API integration capabilities.

**Q13: What is VS Code Copilot integration?**  
A: This feature provides a pre-written prompt that you can paste into GitHub Copilot in Visual Studio Code to automatically generate feedback integration code customized for your account.

**Q14: Do I need N8N to use CustoFlow?**  
A: While CustoFlow is designed to work with N8N for advanced automation features (email notifications, sentiment analysis, reporting), the basic feedback collection functionality works independently.

**Q15: Can I delete departments?**  
A: The current version does not include a delete function in the UI. Department management can be performed directly in the Firebase Console if needed.

**Q16: What browsers are supported?**  
A: CustoFlow supports all modern browsers including Chrome, Firefox, Safari, and Edge in their latest versions.

**Q17: Can I access CustoFlow on mobile devices?**  
A: Yes, CustoFlow has a responsive design that works on mobile browsers and dedicated mobile applications for Android and iOS.

**Q18: How do I reset my password?**  
A: Click the "Forgot Password?" link on the login page, enter your email address, and follow the instructions sent to your email to reset your password.

**Q19: Can multiple users manage the same company account?**  
A: The current implementation supports single-user accounts. Multi-user access would need to be configured through Firebase Authentication roles.

**Q20: What should I do if feedback isn't showing up in my Dashboard?**  
A: Verify that: (1) the integration code includes the correct API key and Company ID, (2) your website is loading the JavaScript code properly, (3) the N8N webhook is running and accessible, and (4) Firebase security rules allow data writes.

## 10. System Messages and Their Meanings

| Message                                        | Type                 | Meaning                                | Action Required                                     |
| ---------------------------------------------- | -------------------- | -------------------------------------- | --------------------------------------------------- |
| "Welcome to CustoFlow!"                        | Information          | Account successfully created           | Review onboarding steps and create first department |
| "Department created successfully!"             | Success              | New department added to system         | Copy webhook URL and integrate into website         |
| "Code copied to clipboard!"                    | Success              | Integration code copied                | Paste code into your website HTML file              |
| "API Key copied!"                              | Success              | API key copied to clipboard            | Use in integration or store securely                |
| "Webhook URL copied!"                          | Success              | Department webhook URL copied          | Use in website integration code                     |
| "Copilot prompt copied to clipboard!"          | Success              | VS Code prompt ready to use            | Paste into GitHub Copilot in VS Code                |
| "Please enter department name"                 | Validation Error     | Form submitted without department name | Enter a valid department name and retry             |
| "Error creating department: [details]"         | Error                | Department creation failed             | Check network connection and retry                  |
| "Invalid email or password"                    | Authentication Error | Login credentials incorrect            | Verify email and password are correct               |
| "Email is required"                            | Validation Error     | Email field is empty                   | Enter a valid email address                         |
| "Password is required"                         | Validation Error     | Password field is empty                | Enter your password                                 |
| "Passwords don't match"                        | Validation Error     | Password confirmation mismatch         | Re-enter matching passwords                         |
| "Password must be at least 6 characters"       | Validation Error     | Password too short                     | Create a longer password                            |
| "Email sent! Check your inbox"                 | Success              | Password reset email sent              | Check email for reset instructions                  |
| "Sign out successful"                          | Information          | User logged out                        | Login again to access dashboard                     |
| "Please enter your feedback before submitting" | Validation Error     | Empty feedback submission              | Enter feedback message in the prompt                |
| "Thank you for your feedback!"                 | Success              | Feedback successfully submitted        | No action needed                                    |
| "Failed to send feedback. Please try again."   | Error                | Feedback submission failed             | Check internet connection and retry                 |
| "An error occurred. Please try again later."   | Error                | General system error                   | Wait and retry; contact support if persists         |
| "Loading..."                                   | Information          | Data being fetched from server         | Wait for operation to complete                      |
| "API Key copied to clipboard!"                 | Success              | API key successfully copied            | Use key for integration                             |

## 11. Troubleshooting

**Problem: Cannot log in to my account**

_Symptoms:_ Error message appears when attempting to login

_Possible Causes:_

- Incorrect email or password
- Account does not exist
- Network connectivity issues
- Firebase authentication service unavailable

_Solutions:_

1. Verify you are using the correct email address (check for typos)
2. Ensure password is entered correctly (check Caps Lock)
3. Try the "Forgot Password" feature to reset your password
4. Check your internet connection
5. Try a different browser or device
6. Wait a few minutes and retry if Firebase services are experiencing issues

**Problem: Dashboard not loading or stuck on loading screen**

_Symptoms:_ Circular progress indicator displays indefinitely

_Possible Causes:_

- Poor internet connection
- Firebase Firestore connection issues
- Missing company data in database
- Browser caching issues

_Solutions:_

1. Refresh the browser page (F5 or Ctrl+R)
2. Check your internet connection speed and stability
3. Clear browser cache and cookies
4. Try logging out and back in
5. Verify Firebase project is properly configured
6. Check browser console for error messages (F12)

**Problem: Cannot create a new department**

_Symptoms:_ Error message when clicking Create button

_Possible Causes:_

- Empty department name field
- Network connection lost
- Firestore write permission denied
- Duplicate department name (not enforced but may cause confusion)

_Solutions:_

1. Ensure department name field is not empty
2. Enter a descriptive, unique name for the department
3. Check internet connection
4. Refresh the page and try again
5. Verify Firestore security rules allow writes for authenticated users

**Problem: Integration code not working on website**

_Symptoms:_ Feedback button doesn't respond or shows errors

_Possible Causes:_

- JavaScript code not properly inserted
- Incorrect API key or Company ID in code
- N8N webhook URL not accessible
- Browser blocking cross-origin requests
- JavaScript execution errors

_Solutions:_

1. Verify the code was pasted completely into the HTML file
2. Check that API key and Company ID match your Dashboard values
3. Open browser developer tools (F12) and check Console for errors
4. Verify N8N webhook service is running (should be accessible at localhost:5678)
5. Test webhook URL directly using tools like Postman
6. Ensure your website allows JavaScript execution
7. Check for CORS issues in browser console

**Problem: Feedback not appearing in analytics**

_Symptoms:_ Total Feedback count remains at zero despite submissions

_Possible Causes:_

- Feedback not successfully sent to webhook
- N8N workflow not saving to Firestore
- Incorrect Firestore collection path
- Security rules blocking writes

_Solutions:_

1. Test the feedback form and check browser console for errors
2. Verify success message appears after submitting feedback
3. Check N8N workflow is active and processing requests
4. Review N8N execution logs for errors
5. Verify N8N has correct Firebase credentials
6. Check Firestore database directly in Firebase Console
7. Ensure Firestore security rules allow N8N to write data

**Problem: Email validation failing on valid email addresses**

_Symptoms:_ "Please enter a valid email address" message for correct emails

_Possible Causes:_

- Special characters in email domain
- Regex pattern too restrictive
- Unexpected email format

_Solutions:_

1. Verify email has format: text@domain.extension
2. Try a standard email format (Gmail, Outlook, etc.)
3. If using custom integration, review email validation regex
4. Update regex pattern in integration code if needed

**Problem: Cannot copy API key or webhook URLs**

_Symptoms:_ Copy button does nothing or no confirmation message

_Possible Causes:_

- Clipboard access denied by browser
- Browser security settings blocking clipboard
- JavaScript error preventing copy operation

_Solutions:_

1. Grant clipboard permissions when browser prompts
2. Check browser settings for clipboard access permissions
3. Manually select and copy the API key text
4. Try a different browser
5. Check browser console (F12) for JavaScript errors

**Problem: VS Code Copilot not generating correct code**

_Symptoms:_ Generated code missing credentials or incorrect structure

_Possible Causes:_

- Prompt copied incompletely
- Copilot interpreting instructions differently
- Missing context in the prompt

_Solutions:_

1. Ensure entire prompt was copied using "Copy Prompt" button
2. Paste the complete prompt into Copilot
3. Review generated code and manually insert API key and Company ID if needed
4. Use the standard HTML integration method as an alternative
5. Provide additional context to Copilot if needed

**Problem: Password reset email not received**

_Symptoms:_ No email arrives after requesting password reset

_Possible Causes:_

- Email in spam/junk folder
- Incorrect email address entered
- Email delivery delay
- Firebase email service not configured

_Solutions:_

1. Check spam, junk, and promotions folders
2. Verify you entered the correct email address
3. Wait up to 10 minutes for email delivery
4. Retry the password reset process
5. Contact system administrator if issue persists

**Problem: Application not responsive on mobile device**

_Symptoms:_ Layout appears broken or elements overlap

_Possible Causes:_

- Browser zoom level incorrect
- Unsupported mobile browser
- Network issues causing incomplete page load

_Solutions:_

1. Reset browser zoom to 100%
2. Use a modern mobile browser (Chrome, Safari)
3. Rotate device to portrait orientation
4. Clear browser cache
5. Try the dedicated mobile application instead of web browser

## 12. Glossary

**Admin Email**: The email address associated with the company administrator's account, used for notifications and authentication.

**Analytics**: Statistical data showing feedback metrics including total submissions, positive feedback count, and negative feedback count.

**API Key**: Application Programming Interface key - a unique identifier (format: cfk_timestamp_randomdigits) that authenticates feedback submissions from external websites to CustoFlow.

**Authentication**: The process of verifying user identity through email and password credentials using Firebase Authentication service.

**Company ID**: A unique identifier assigned to each company account, generated by Firebase as the user ID (UID) during registration.

**Dashboard**: The main interface displayed after login, showing company information, analytics, departments, and access to system features.

**Department**: An organizational unit within a company (e.g., Sales, Support, Technical) used to categorize and route feedback to specific teams.

**Feedback**: Customer input collected through integrated forms, consisting of a message, email address, timestamp, and associated metadata.

**Firebase**: A Google cloud platform providing backend services including authentication, real-time database (Firestore), and hosting used by CustoFlow.

**Firestore**: Firebase's NoSQL cloud database used to store company information, departments, feedback submissions, and analytics data.

**Integration Code**: Pre-generated HTML and JavaScript code snippets provided to users for embedding feedback forms into their websites.

**Landing Page**: The initial public-facing page of CustoFlow that provides information about features and access to sign-up and login functions.

**N8N**: An open-source workflow automation platform integrated with CustoFlow for processing feedback, sending emails, performing sentiment analysis, and generating reports.

**Onboarding**: The guided initial setup process presented to new users after account creation, explaining key features and next steps.

**Sentiment Analysis**: AI-powered automated categorization of feedback as "positive" or "negative" based on message content analysis.

**Sign Up**: The account creation process where new users register their company by providing company name, email, and password.

**SnackBar**: A temporary notification message that appears at the bottom of the screen to confirm actions or display brief information.

**VS Code Copilot**: GitHub's AI pair programmer integrated with Visual Studio Code, for which CustoFlow provides ready-to-use prompts for code generation.

**Webhook**: An HTTP endpoint URL that receives real-time data when events occur (e.g., feedback submissions), enabling automated processing through N8N.

**Webhook URL**: The specific web address assigned to each department where feedback data is sent for processing (format: http://localhost:5678/webhook-test/[id]).
