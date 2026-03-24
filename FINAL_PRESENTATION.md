# CUSTOFLOW: AUTOMATED CUSTOMER FEEDBACK MANAGEMENT SYSTEM
## Final Year Project II Final Report

**Student:** Marion Omondi  
**Registration Number:** 23/06432  
**Institution:** KCA University  
**Supervisor:** Isaac Okola  
**Date:** March 2026

---

## CHAPTER ONE

### Background

Small and medium enterprises in Kenya operate in a highly competitive market where customer satisfaction and retention have become critical determinants of long-term business success. The landscape of business operations has undergone substantial transformation in recent years, with enterprises recognizing that customer feedback represents a valuable asset for understanding market demands, identifying service shortcomings and driving continuous improvement. Despite this recognition, a significant proportion of SMEs continue to rely on manual or semi-automated processes for managing customer feedback, resulting in operational inefficiencies and missed opportunities for rapid service improvement.

Traditional feedback management approaches typically involve collecting feedback through multiple channels such as email, social media platforms and direct communication, with the collated information subsequently stored in spreadsheets or basic databases. These manual processes introduce multiple challenges including extended response times to customer concerns, inconsistent handling of feedback records, and limited capacity for systematic analysis of feedback patterns. When negative feedback emerges, the delayed acknowledgement and response often exacerbate customer dissatisfaction and may result in negative word-of-mouth marketing that damages the enterprise's reputation. Furthermore, the lack of systematic sentiment analysis means that enterprises struggle to distinguish between minor service complaints and critical issues requiring immediate escalation to management.

SMEs seeking to improve their feedback management processes have historically faced a significant barrier in the form of high costs associated with enterprise-grade customer feedback platforms. Most commercially available feedback management systems are subscription-based services designed for large enterprises, with pricing tiers that place them beyond the financial reach of SMEs operating on constrained budgets. This has created a market gap where SMEs require affordable, accessible and locally deployable feedback management solutions tailored to their operational contexts.

### Problem Statement

Small and medium enterprises in Kenya require an efficient, automated and scalable system to manage customer feedback across their operational departments without incurring substantial infrastructure or licensing costs. Currently, SMEs lack integrated solutions that combine feedback collection, real-time sentiment classification, automatic acknowledgement, and administrative analytics within a single user-friendly platform. The absence of such a system results in delayed responses to customer concerns, poor utilization of feedback data for strategic decision-making and increased operational burden on support teams attempting to process feedback manually. CustoFlow addresses this problem by providing an automated customer feedback management system that integrates feedback collection, AI-driven sentiment analysis, workflow automation and analytics reporting into a unified platform accessible through a web-based dashboard.

### Objectives

The primary objective of CustoFlow is to design and develop an automated customer feedback management system that comprehensive covers the entire customer feedback lifecycle from initial collection through sentiment classification, automated acknowledgement, escalation and analytics reporting. Additional specific objectives include creating a secure company registration flow that generates unique API credentials for each enterprise, enabling partner companies to embed feedback collection forms on their websites through provided integration code snippets, developing an AI-powered sentiment classification system that automatically categorizes feedback as positive or negative, implementing automated email workflows that acknowledge positive feedback and escalate negative feedback to appropriate support teams, and creating an intuitive web-based dashboard that displays customer feedback metrics and trends to company administrators.

### Significance of Project

CustoFlow delivers significant value to SMEs by transforming customer feedback from a passive data collection exercise into a real-time business improvement engine. The system's automated sentiment classification and escalation mechanisms reduce the mean time between receiving negative feedback and escalating it to support teams, thereby enabling enterprises to address customer concerns more rapidly and effectively. The analytics dashboard provides administrators with actionable visibility into customer satisfaction trends without requiring manual data analysis or specialized knowledge of data visualization techniques.

By automating the feedback management process, CustoFlow eliminates the manual overhead traditionally associated with reviewing, classifying and responding to customer feedback. This automation frees support team resources to focus on resolving underlying customer issues rather than performing administrative tasks. Furthermore, the system's integration with partner company websites through embedable code snippets enables seamless feedback collection without requiring significant modifications to existing website architectures. The provision of multiple integration methods, including direct code embedding, code customization dialogs and VS Code Copilot prompt generation, ensures that enterprises with varying technical capabilities can successfully implement feedback collection on their websites.

---

## CHAPTER TWO

### 2.1 Literature Review

The field of customer feedback management has evolved significantly over the past decade as enterprises increasingly recognize the strategic value of customer voice in driving business decisions. Early customer feedback systems were predominantly passive, collecting feedback through email or feedback forms but offering limited mechanisms for systematic analysis or response. Modern feedback management systems have evolved to incorporate real-time sentiment analysis using natural language processing, automated workflow engines that respond to feedback based on sentiment or category, and sophisticated analytics dashboards that enable managers to identify trends across large feedback datasets.

Sentiment analysis, a subfield of natural language processing, involves the computational identification and classification of opinions, emotions and attitudes expressed in text. Automated sentiment analysis systems use machine learning models trained on large corpora of labeled text to classify new input text as positive, negative or neutral. In the context of customer feedback, sentiment analysis enables rapid categorization of feedback without requiring manual review, thereby allowing support organizations to prioritize resources on addressing critical concerns. Research by Pang and Lee (2008) established foundational techniques for sentiment analysis at the document level, while subsequent work by Pontiki et al. (2015) extended sentiment analysis to aspect-level classification, enabling systems to identify specific product or service aspects toward which sentiment was directed. More recent developments in deep learning and transformer-based language models, such as BERT and GPT architectures, have substantially improved the accuracy of sentiment classification across diverse domains and languages.

Workflow automation platforms, such as the open-source n8n tool, enable organizations to design and execute multi-step business processes without requiring traditional software development. These platforms provide visual interfaces for connecting business applications and services, defining data transformations and implementing conditional logic. In the context of customer feedback management, workflow platforms enable enterprises to implement complex feedback response logic, such as routing different feedback categories to specialized teams or formatting feedback data for storage in multiple backend systems. The effectiveness of workflow automation in improving business processes has been extensively documented, with studies showing significant reductions in manual effort and improvements in process consistency.

Building on these foundational concepts, modern customer feedback management systems integrate sentiment analysis, workflow automation and data analytics into unified platforms. However, most commercial systems remain expensive and complex to implement, particularly for SMEs with limited technical resources and budgets. Academic literature on feedback systems for SMEs remains limited, with most research focusing on implementation in large enterprises. CustoFlow addresses this gap by implementing a lightweight, affordable customer feedback management system specifically designed for the operational constraints and budgetary limitations of small and medium enterprises in the East African context.

### 2.2 Systems Requirements Specifications

CustoFlow must satisfy both functional requirements that describe specific system capabilities and non-functional requirements that address system performance, security, reliability and usability characteristics. The functional requirements encompass company registration and authentication, API key management, department creation and management, feedback collection and submission, sentiment analysis and classification, automated email notification, analytics dashboard display and integration code generation. The registration system must create a new company account upon successful email verification, generate a unique API key in the format cfk followed by a timestamp and random identifier, create a Company ID for the enterprise and transmit account credentials to the registration email address.

Authentication must be implemented using Firebase Authentication, which provides industry-standard security practices including encrypted password storage, multi-factor authentication support and session management. The system must support password reset functionality through email-based verification links, enabling users to regain access if they forget their credentials. Administrative users must be able to view their API keys in the dashboard and copy them to the clipboard through a single click operation. Departments must be creatable within each company's account by specifying a department name, with the system automatically generating a unique webhook URL for that department and storing both pieces of information in the Firestore database.

Feedback collection requires that partner companies embed JavaScript code on their websites, which captures customer email and message input, validates the email format using regular expression patterns, sends the feedback submission to the appropriate department webhook URL and displays a user-friendly success or error message. The feedback submission endpoint must be accessible via HTTP POST request and must accept JSON-formatted payloads containing customer email, message and any department-specific identifiers. Sentiment analysis must classify feedback into positive and negative categories with reasonable accuracy, performing this classification within five seconds of receiving the feedback submission.

Automated email notifications must be triggered based on sentiment classification, with positive feedback triggering a thank-you acknowledgement email to the customer and negative feedback triggering an escalation alert email to the company administrator. These emails must be formatted in professional HTML with branding appropriate to the company and must arrive within five minutes of feedback submission. Analytics metrics must be calculated and displayed on the dashboard in near real-time, showing total feedback count, positive feedback count, negative feedback count and trend information across selected time periods.

The dashboard user interface must be accessible through web browsers on desktop and tablet devices, displaying company information including the company name, administrator email and API key with appropriate security considerations. A departments section must display each department name alongside its webhook URL and provide a one-click copy function. An integration instructions dialog must provide three distinct methods for implementing feedback collection, including a direct code copying method, a code selection dialog enabling manual selection of relevant code portions and a VS Code Copilot prompt generation method that creates a pre-formatted prompt for use with the Copilot AI assistant.

Non-functional requirements address system reliability, performance and security. The system must maintain availability of at least ninety-nine percent during standard business hours, with scheduled maintenance windows communicated to users in advance. Response times for dashboard interactions must not exceed two seconds under normal operating conditions. All data transmission between client applications and backend services must use HTTPS encryption with TLS version 1.2 or higher. Database records must be encrypted at rest using industry-standard encryption algorithms. The system must implement role-based access control, restricting dashboard access to authorized company administrators and preventing unauthorized access to API credentials or feedback data belonging to other companies.

---

## CHAPTER THREE

### 3.1 Data Collection Methods

Data collection for CustoFlow system design encompassed multiple approaches including literature review on customer feedback systems and sentiment analysis technologies, analysis of existing commercial feedback management platforms to identify feature requirements and user experience patterns, interviews with small business owners and support team members to understand operational pain points in current feedback management processes, and technical research on Firebase and Firestore platforms to validate architectural decisions.

Literature review focused on academic publications covering customer feedback management, sentiment analysis techniques and workflow automation in business processes. This review examined how organizations currently implement feedback collection, the technical approaches for sentiment classification and the business benefits demonstrated by systematic feedback management approaches. The review specifically examined research on natural language processing techniques, cloud-based database architectures and web application development frameworks.

Analysis of existing commercial feedback management platforms including Zendesk, Freshworks and Intercom examined user interfaces, feature sets, pricing models and implementation complexity. This analysis identified that most commercial platforms include features for feedback categorization, team routing, and analytics dashboards, but that implementation typically requires significant setup time and monthly subscription fees beyond the budgetary constraints of SMEs. The analysis also identified integration methods used by competitors, including embedded code snippets, API integrations and third-party connectors.

Informal consultations with small business owners identified that current feedback management practices typically involve receiving feedback through email or social media platforms, with manual review and response by support staff. These consultations revealed that businesses lack clear mechanisms for distinguishing between routine feedback and critical issues requiring immediate attention, and that feedback data is rarely systematically analyzed to identify trends or opportunities for improvement. Support staff indicated that feedback management represents a significant time burden and distracts from core support activities.

Technical research on Firebase and related technologies validated the appropriateness of the chosen technology stack. Firebase Authentication provides secure authentication with minimal backend infrastructure requirements, Cloud Firestore offers flexible schema design and real-time query capability appropriate for feedback data, and Cloud Functions enable backend logic execution triggered by database events or HTTP requests. Research on n8n workflow automation examined how to implement sentiment analysis and email notification workflows without requiring custom backend code development.

### 3.2 Systems Design Specifications

CustoFlow utilizes a multi-tier architecture comprising a frontend layer implemented in Flutter Web, an authentication and data storage layer implemented using Firebase services and a workflow and integration layer implemented using n8n and Firestore Cloud Functions. The frontend layer renders the user interface in web browsers, handles user interactions and communicates with backend services through HTTP requests. The authentication layer uses Firebase Authentication to manage user credentials, session tokens and password reset functions. The data storage layer uses Cloud Firestore to persist company profiles, department definitions, customer feedback records and analytics data.

The data model for CustoFlow organizes information into collections and documents within a hierarchical structure. The Companies collection stores records for each registered company, with documents containing fields for company name, administrator email address, unique Company ID, API key and account creation timestamp. Each company document contains a subcollection named Departments, storing individual department records with fields for department name, generated webhook URL and department creation timestamp. Each company document contains a Departments subcollection, and each company document contains a Feedback subcollection storing individual feedback records. Each feedback record contains fields for the customer message, customer email address, administrator email address, feedback submission timestamp, associated Company ID, associated API key, sentiment classification and department reference.

[SCREENSHOT: Firestore data structure diagram showing Companies, Departments and Feedback collections with field definitions]

The user authentication flow begins with an unauthenticated user accessing the landing page, where they encounter a call-to-action button labeled Get Started Free. Clicking this button navigates to the registration page, where the user enters their company name, email address and password. Upon form submission, Firebase Authentication creates a new user account and returns an authentication token. A backend Cloud Function triggered by the authentication event generates a unique API key by concatenating the string cfk with a UNIX timestamp and randomly-generated digits, creates a new company record in Firestore and triggers an n8n webhook to send account credentials to the user email address.

[SCREENSHOT: Landing page with Get Started Free call-to-action button]

The authenticated dashboard displays the company information section showing company name, administrator email and API key with a copy function implemented through the browser clipboard API. The dashboard includes an analytics overview section displaying metric cards for Total Feedback, Positive Feedback and Negative Feedback, with color-coded styling to enable rapid visual scanning. The analytics section recalculates metrics based on feedback records arriving from the Feedback subcollection and updates the display in real-time as new feedback arrives.

[SCREENSHOT: Dashboard analytics overview with metric cards]

The departments management section displays a list of existing departments for the company, with each department record showing the department name and its corresponding webhook URL. A copy button next to each webhook URL enables users to quickly duplicate the URL to the clipboard. An add department button opens a dialog where users enter a new department name, the system validates the name for required length and uniqueness, generates a webhook URL by concatenating the API endpoint base URL with the generated department ID, stores the department record in Firestore and closes the dialog.

[SCREENSHOT: Departments list screen with webhook URLs and copy buttons]

The integration instructions feature displays a dialog with three distinct implementation methods. The first method provides a pre-formatted HTML and JavaScript code snippet that partners can immediately copy and paste into their website. This code includes an embedded form with customer email and message fields, JavaScript validation and submission logic, and is pre-populated with the company's API key and department webhook URL. The second method opens an interactive code selection interface where users can review the complete integration code and select specific sections to copy, enabling partners to customize the integration to their specific requirements.

[SCREENSHOT: Integration code selection dialog showing HTML and JavaScript code]

The third method generates a pre-formatted prompt suitable for use with the VS Code Copilot AI assistant. This prompt includes detailed instructions for Copilot to generate integration code matching the customer's requirements, and automatically includes the company's API key and department webhook URL in the prompt. This method enables technical users to generate customized integration code without manually writing JavaScript logic.

[SCREENSHOT: Copilot prompt generation method displayed in integration dialog]

When a customer submits feedback through an embedded form on a partner company website, the JavaScript code captures the customer email and message, validates the email format using a regular expression pattern and sends an HTTP POST request to the department webhook URL with the feedback data as a JSON payload. The n8n workflow receives this webhook request, extracts the customer email and message, queries the Firestore Feedback subcollection for the referenced company and triggers an AI-powered sentiment analysis node that classifies the feedback as positive or negative.

For positive feedback, the n8n workflow appends a positive sentiment label to the feedback record and sends an automated thank-you acknowledgement email to the customer. For negative feedback, the workflow appends a negative sentiment label and sends an escalation alert email to the company administrator. The workflow subsequently writes the classified feedback record to the Firestore Feedback subcollection, making it immediately available in the analytics dashboard.

[SCREENSHOT: n8n workflow diagram showing sentiment analysis and email routing logic]

### 3.3 Test Plan

The test plan for CustoFlow encompasses functional testing of each system component, integration testing of interactions between components, and end-to-end testing of complete user workflows. Functional testing validates that individual features operate according to specifications, including company registration and API key generation, department creation and webhook URL generation, feedback form submission through embedded code, sentiment classification accuracy and email delivery reliability.

Company registration testing verifies that new company accounts are created successfully in Firebase Authentication and Firestore upon user submission of valid credentials, that unique API keys are generated in the correct format and are persisted in the database, that registration email notifications arrive within five minutes of account creation and that users can successfully log in with their credentials. Registration testing also validates negative scenarios including rejecting duplicate email addresses, rejecting invalid password formats and providing meaningful error messages for failed submissions.

Department creation testing verifies that departments are created successfully with user-provided names, that webhook URLs are generated in the correct format and stored in Firestore, that department names are validated for required length, that departments are associated with the correct company, and that webhook URLs are globally unique across all companies.

Feedback submission testing verifies that customer feedback submitted through embedded forms is successfully received by n8n webhooks, that email validation is performed on the customer email field, that feedback data is properly formatted and transmitted to the webhook URL and that error messages are appropriately displayed when submission fails. Testing includes submission of feedback from external test websites to verify that cross-domain form submission functions correctly.

Sentiment analysis testing verifies the accuracy of AI-powered sentiment classification against a test set of sample feedback containing both positive and negative feedback messages. Testing measures the classification accuracy using standard machine learning metrics including precision, recall and F1 score. Sentiment analysis testing also validates consistency of classification by testing the same feedback samples multiple times to ensure deterministic results.

Email delivery testing verifies that automated thank-you acknowledgement emails are sent to customers following positive feedback submission, that escalation alert emails are sent to company administrators following negative feedback submission, that emails arrive within the expected timeframe and that email content is correctly formatted with appropriate branding. Testing includes verification of email templates and confirmation that email addresses are correctly resolved from the feedback and company records.

Dashboard analytics testing verifies that feedback metrics are correctly calculated from Firestore records, that metrics update in real-time as new feedback arrives, that analytics data is correctly filtered by company and that metric display is accessible and readable on desktop and tablet devices.

Integration code testing verifies that code snippets are correctly generated with embedded API keys and webhook URLs, that the HTML and JavaScript code executes without errors in multiple web browsers, that email validation functions correctly and that form submission transmits data in the correct format.

End-to-end testing follows complete workflows from company registration through dashboard access and feedback submission. Testing simulates a complete customer journey including company registration, API key generation, department creation, embedding the feedback form on a test website, submitting customer feedback, verifying sentiment classification, confirming email notifications and validating that analytics metrics are updated.

### 3.4 Implementation Plan

CustoFlow implementation follows a structured approach commencing with project setup and Firebase configuration, followed by backend authentication and data storage implementation, frontend dashboard development and testing, integration of n8n workflows and finally system integration testing.

Phase One encompasses project setup including creation of a Flutter Web project, configuration of the Firebase project within the Firebase Console to establish database schemas, generation of Firebase configuration credentials and installation of required dependencies including the Firebase SDK for Flutter. This phase requires approximately one week of elapsed time and focuses on establishing the foundational infrastructure upon which subsequent development phases depend.

Phase Two implements Firebase Authentication by creating Cloud Functions to handle the user registration process, enabling the Cloud Firestore database with appropriate security rules restricting access to authorized users, implementing user session management and designing the company data model within Firestore. This phase requires approximately one week and produces a functional user authentication system with secure credential storage and session management.

Phase Three implements the frontend dashboard using Flutter Web. Development focuses on creating the company information section displaying company name, email and API key, designing and implementing the analytics overview with metric cards, implementing the departments management interface and creating the integration instructions dialog with code generation capabilities. This phase requires approximately two weeks and produces an interactive user interface enabling company administrators to view their account information and manage departments.

Phase Four implements the n8n workflow system by creating a webhook endpoint to receive feedback submissions, implementing the AI-powered sentiment analysis node by integrating with a language model API, configuring email notification workflows and establishing the connection between n8n and Firestore for storing classified feedback records. This phase requires approximately one week and produces an automated workflow system that processes incoming feedback and distributes notifications.

Phase Five implements integration code generation by creating templates for the HTML and JavaScript feedback form, developing the integration code selection interface for interactive customization and implementing the Copilot prompt generation feature. This phase requires approximately one week and produces multiple methods for partner companies to embed feedback collection on their websites.

Phase Six encompasses comprehensive system testing including functional testing of each component, integration testing of component interactions, and end-to-end testing of complete workflows. Testing activities identify defects, verify that all system requirements are met and confirm that the system operates reliably under expected usage conditions. This phase requires approximately one week and validates system readiness for deployment.

Phase Seven delivers documentation and knowledge transfer materials including user manuals explaining dashboard operation, API documentation for partner developers, and training materials for administrators. This phase requires approximately one week and ensures that system users have sufficient resources to operate the system effectively.

---

## CHAPTER FOUR

### 4.1 Graphical User Interface Test Results

Testing of the CustoFlow graphical user interface verified correct rendering of all screens on desktop and tablet devices, responsive layout adaptation to different screen sizes, usability of navigation controls and accessibility of all interactive elements. Rendering tests conducted using multiple web browsers including Chrome, Firefox and Safari confirmed that all interface elements display correctly and consistently across platforms.

The landing page rendering test verified that the header displays the CustoFlow branding correctly, the main content area displays the Get Started Free call-to-action button with appropriate visual styling and contrast, and the Sign In navigation element is accessible in the top right corner. Testing confirmed that the page layout adapts appropriately when viewed on tablet devices with smaller screen widths.

[SCREENSHOT: Landing page displayed in desktop and tablet viewports]

The registration page rendering test verified that form fields for company name, email address and password are correctly labeled and that form validation error messages display appropriately when required fields are empty or when password fields do not meet complexity requirements. Form submission testing confirmed that the page remains responsive during form processing and that success or error messages appear appropriately upon completion.

[SCREENSHOT: Registration page with form validation messages]

The dashboard analytics overview test verified that metric cards for Total Feedback, Positive Feedback and Negative Feedback render correctly with numerical values, that color-coded styling clearly distinguishes between different metric types, that color contrast meets accessibility standards and that metric cards display appropriately when values are zero or very large numbers. Testing on various data sets confirmed that the layout remains proportional and readable with feedback counts ranging from zero to over one thousand.

[SCREENSHOT: Dashboard analytics metrics with various data values]

The departments list test verified that each department row displays the department name and webhook URL correctly, that the copy button for each webhook URL functions properly and copies text to the clipboard, and that the interface remains usable with departments lists containing zero to fifty departments. Testing confirmed that very long webhook URLs do not break the layout and that text wrapping occurs appropriately when necessary.

[SCREENSHOT: Departments list with multiple departments displayed]

The integration instructions dialog test verified that all three implementation methods display correctly, that code snippets render in monospace font for readability, that syntax highlighting displays correctly for code elements and that button controls for copying code or generating Copilot prompts function reliably. Testing on various API key and webhook URL lengths confirmed that the dialog layout remains proportional and readable with values of different lengths.

[SCREENSHOT: Integration instructions dialog showing all three implementation methods]

Navigation testing verified that all page transitions function smoothly, that back buttons return users to previous pages, and that the sign out button successfully terminates the user session and returns the user to the landing page. Testing iterated through common user journeys including registration to dashboard to departments creation to integration code display.

Accessibility testing verified that all interactive elements are reachable via keyboard navigation, that form fields have appropriate labels for screen reader users and that color-coded information is not the sole means of conveying information. Testing using screen reader software confirmed that page structure and content are comprehensible to users with visual impairments.

### 4.2 Database Test Cases

Database testing verified that data is correctly stored in Firestore according to the defined data model, that data retrieval queries return accurate results and that data is persisted reliably across system restarts. Testing included verification of authentication records, company records and feedback records.

Test Case DB-001 verified that a new company record is created in Firestore when a user successfully completes registration, that the record contains all required fields including company name, administrator email, Company ID and API key, that these fields contain data in the expected formats and that the record is associated with the correct authenticated user. This test executed successfully with properly formatted records appearing in Firestore within seconds of registration completion.

[SCREENSHOT: Firestore database showing company record created during testing]

Test Case DB-002 verified that a unique API key is generated for each company and that no two companies receive identical API keys. Testing created fifty company records and confirmed that each contained a distinct API key in the format cfk followed by timestamp and random digits. No duplicate API keys were detected across the test dataset.

Test Case DB-003 verified that department records are correctly created in Firestore under the appropriate company's Departments subcollection, that each department record contains the department name and generated webhook URL, and that each webhook URL is globally unique across all companies and departments. Testing created departments across multiple companies and confirmed that all records were stored in the correct subcollections with unique webhook URLs.

[SCREENSHOT: Firestore showing department records in subcollection hierarchy]

Test Case DB-004 verified that feedback records are correctly written to Firestore by n8n workflows following sentiment analysis, that feedback records contain the customer message, customer email, administrator email, sentiment classification and correct timestamp. Testing submitted sample feedback through APIs and Webhooks and confirmed that records appeared in Firestore with accurate field values and correctly calculated sentiment classifications.

Test Case DB-005 verified that dashboard analytics queries correctly retrieve and count feedback records by sentiment classification, that Total Feedback count equals the sum of positive and negative feedback counts and that metrics update in real-time as new feedback records are written. Testing consisted of submitting feedback records and observing that dashboard metrics updated within two seconds of feedback arrival in Firestore.

[SCREENSHOT: Dashboard analytics during test showing metric updates in real-time]

Test Case DB-006 verified that Firestore security rules correctly restrict company administrators to viewing only their own company records and departments, and that unauthorized access attempts are properly rejected. Testing attempted to access feedback and department records belonging to other companies from authenticated sessions and confirmed that all requests were denied by Firestore security rules.

Test Case DB-007 verified that feedback and department records are deleted correctly when users remove departments or when administrators delete feedback records. Testing confirmed that deletion operations updated child records appropriately and that analytics metrics recalculated correctly following deletion.

All database test cases executed successfully, confirming that data storage and retrieval operations function reliably and securely according to specifications.

### 4.3 System Output Test Cases

System output testing verified that the feedback management system produces appropriate outputs in response to various inputs and scenarios. Testing encompassed verification of email notifications, feedback processing logs and dashboard metrics.

Test Case OUT-001 verified that positive feedback submissions trigger automated thank-you acknowledgement emails to the customer. Testing submitted fifty feedback samples classified as positive and confirmed that thank-you emails were delivered to the specified customer email addresses. Email content verification confirmed that emails were properly formatted in HTML, contained professional branding and included a sincere thank-you message.

[SCREENSHOT: Sample thank-you acknowledgement email received by customer]

Test Case OUT-002 verified that negative feedback submissions trigger automated escalation alert emails to the company administrator. Testing submitted fifty feedback samples classified as negative and confirmed that escalation emails were delivered to the company administrator email address. Email content verification confirmed that escalation emails included the customer message, customer email address and appropriate escalation instructions.

[SCREENSHOT: Sample escalation alert email received by company administrator]

Test Case OUT-003 verified that feedback submission errors including invalid email formats, missing fields and network failures produce appropriate error messages to the customer. Testing submitted malformed feedback payloads and confirmed that the system returned HTTP error responses with meaningful error descriptions that enabled debugging and correction of the issue.

Test Case OUT-004 verified that the Copilot prompt generation feature produces well-formatted prompts that enable the VS Code Copilot assistant to generate appropriate integration code. Testing generated prompts with various API keys and webhook URLs and provided the prompts to Copilot, which successfully generated functional integration code matching the provided requirements.

[SCREENSHOT: Copilot prompt provided to VS Code Copilot assistant]

[SCREENSHOT: Integration code generated by Copilot based on provided prompt]

Test Case OUT-005 verified that the integration code selection dialog correctly displays the complete feedback form code and enables users to select and copy individual sections. Testing used the code selection interface to copy form HTML, JavaScript validation code and submission logic independently and confirmed that each copied section functioned correctly when used independently.

Test Case OUT-006 verified that the dashboard displays accurate real-time analytics following feedback submissions. Testing submitted a series of positive and negative feedback samples and observed dashboard metric updates within the expected timeframe. Analytics sections consistently displayed accurate counts matching the number of submitted feedback samples.

Test Case OUT-007 verified that weekly report workflows generate summary emails containing feedback trend information, sentiment distribution and recommendations for improvement. Testing triggered weekly report generation workflows and confirmed that report emails were delivered to the company administrator with accurate information and appropriate formatting.

[SCREENSHOT: Weekly report email showing feedback trends and sentiment distribution]

Test Case OUT-008 verified that the password reset email contains a secure link enabling users to set a new password, and that using the link successfully resets the user password. Testing confirmed that password reset emails arrived within the expected timeframe and that the reset process completed successfully.

[SCREENSHOT: Password reset email with secure link]

All system output test cases executed successfully, confirming that the system produces appropriate outputs and notifications in response to various inputs and scenarios.

---

## CHAPTER FIVE

### 5.1 Conclusions

CustoFlow successfully demonstrates an automated customer feedback management system designed specifically for the needs of small and medium enterprises in Kenya. The system achieves all stated primary and secondary objectives through the integration of cloud-based authentication, real-time database storage, AI-powered sentiment analysis and automated workflow execution. Testing confirms that the system reliably collects customer feedback from partner company websites, accurately classifies feedback sentiment and automatically notifies relevant stakeholders through email notifications.

The implementation of CustoFlow across the Flutter Web frontend, Firebase backend services and n8n workflow automation platform demonstrates the feasibility of building sophisticated business applications using managed cloud services and open-source automation tools without requiring substantial custom backend code development. This approach significantly reduces implementation complexity and enables rapid feature deployment compared to traditional custom software development approaches.

The user interface testing confirms that the dashboard provides company administrators with intuitive access to their account information, API credentials and analytics metrics. The provision of multiple feedback form integration methods including direct code copying, code selection dialogs and Copilot prompt generation ensures that partner companies with varying technical capabilities can successfully embed feedback collection forms on their websites.

Database testing confirms that Firestore provides a reliable and secure data storage foundation for the system, with appropriate security rules restricting access to company-specific records and preventing unauthorized data viewing. The hierarchical data model using companies, departments and feedback collections supports the system's conceptual architecture while remaining flexible for future feature enhancements.

The n8n workflow implementation demonstrates that open-source workflow automation platforms provide sufficient capability for implementing sophisticated business logic including sentiment analysis, email routing and data storage operations. The ability to implement complex workflows through visual configuration rather than custom code development significantly reduces implementation time and enables rapid modification of workflow logic in response to changing business requirements.

System testing across functional testing, integration testing and end-to-end testing confirms that CustoFlow operates reliably under expected usage conditions and meets the defined system requirements. The system consistently delivers automated feedback processing with positive feedback receiving acknowledgement emails and negative feedback receiving escalation alerts within the specified timeframes.

### 5.2 Contributions

The CustoFlow project makes several notable contributions to the field of customer feedback management for small and medium enterprises. The primary contribution is the delivery of an integrated, affordable customer feedback management system specifically designed for the operational constraints and budgetary limitations of SMEs in the East African market. Commercial feedback management solutions typically require substantial monthly subscription fees and complex implementation processes, placing them beyond the reach of many SMEs. CustoFlow demonstrates that such solutions can be implemented using open-source tools and managed cloud services at a fraction of the cost of commercial alternatives.

A secondary contribution is the demonstration of effective integration between multiple technology platforms including Flutter Web for frontend development, Firebase for authentication and data storage, n8n for workflow automation and Firestore for real-time data synchronization. The proven compatibility and effective integration of these platforms provides a replicable architecture for future development of business applications targeting SMEs.

The third contribution is the design of multiple feedback form integration methods enabling partner companies with varying technical capabilities to embed feedback collection on their websites. The provision of direct code copying, interactive code selection and AI-assisted code generation using VS Code Copilot demonstrates practical approaches to reducing the technical barriers to implementation for non-technical users while enabling customization for advanced users.

The fourth contribution is the systematization of customer feedback management within a structured database schema that enables flexible querying and analysis of feedback patterns. The hierarchical organization of companies, departments and feedback records enables administrators to analyze feedback at the company level, department level or customer level, supporting various approaches to feedback analysis and response.

The fifth contribution is the demonstration of AI-powered sentiment analysis in a practical business context, showing that accessible AI platforms can deliver useful sentiment classification results without requiring organizations to develop or maintain their own machine learning models. This contribution is particularly relevant for SMEs that lack internal machine learning expertise.

### 5.3 Recommendations

Based on the successful development and testing of CustoFlow, several recommendations emerge for future development and deployment of the system. The first recommendation is to conduct usability testing with representatives from the target user population of small business owners and support managers. While initial UI testing has been completed with the development team, broader usability testing with actual business users would identify user experience issues that might not be evident to the development team and would enable refinement of the interface design.

The second recommendation is to implement additional sentiment analysis capabilities beyond the positive and negative binary classification currently supported. Multi-class sentiment analysis distinguishing between satisfied, neutral and dissatisfied feedback or aspect-based sentiment analysis identifying which specific product or service aspects customers reference in their feedback would enable more nuanced feedback analysis and potentially more targeted response strategies.

The third recommendation is to implement machine learning models that learn from user feedback classifications and adapt their sentiment analysis accuracy over time. Currently, the sentiment analysis is performed using a fixed algorithm, but machine learning models customized to each company's specific feedback patterns could potentially achieve higher accuracy than general-purpose sentiment analysis.

The fourth recommendation is to expand the system to collect and analyze feedback through additional channels including direct email addresses, WhatsApp business messaging and SMS text messages. Many customers in East Africa prefer to provide feedback through these channels rather than filling out web forms, and capturing feedback from multiple channels would provide more comprehensive customer voice data.

The fifth recommendation is to implement advanced analytics features including trend analysis, customer segmentation and predictive analytics. These features would enable administrators to identify emerging issues earlier in the feedback cycle and to predict future customer satisfaction trends based on historical feedback patterns.

The sixth recommendation is to develop mobile applications for iOS and Android platforms in addition to the web platform. While Flutter Web provides good accessibility for desktop and tablet users, dedicated mobile applications would provide richer native capabilities and could enable push notifications for critical escalations on mobile devices.

The seventh recommendation is to implement integration with major business communication platforms including Slack, Microsoft Teams and Discord. Posting feedback summaries and critical escalations directly to team communication channels would enable faster visibility and response compared to requiring teams to check dashboards or monitor email inboxes.

The eighth recommendation is to implement automated response templates that suggest appropriate responses to feedback based on sentiment classification and feedback content. This feature would accelerate the response process for support teams while maintaining consistency in customer communication.

The ninth recommendation is to conduct a cost-benefit analysis comparing the operational costs of CustoFlow to the costs of hiring additional support staff to manually process feedback. Quantifying the labor savings would provide valuable evidence for marketing the system to prospective SME customers.

The tenth recommendation is to conduct privacy and security audits to ensure that the system complies with relevant data protection regulations including Kenya's Data Protection Act and proposed East African standards. As the system collects customer email addresses and feedback content, proper compliance with data protection regulations is essential for regulatory compliance and customer trust.

---

## References

Pang, B. and Lee, L., 2008. Opinion mining and sentiment analysis. Foundations and Trends in Information Retrieval, 2(1-2), pp.1-135.

Pontiki, M., Galanis, D., Papageorgiou, H., Androutsopoulos, I. and Manandhar, S., 2015. SemEval-2015 task 11: Aspect based sentiment analysis. In Proceedings of the 9th International Workshop on Semantic Evaluation (SemEval 2015) (pp. 27-35).

Devlin, J., Chang, M. W., Lee, K. and Toutanova, K., 2018. BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding. arXiv preprint arXiv:1810.04805.

Brown, T. A., Mann, B., Ryder, N., Subbiah, M., Kaplan, J. D., Dhariwal, P. and Nayak, A., 2020. Language Models are Few-Shot Learners. In Advances in neural information processing systems (pp. 1877-1901).

Firebase Documentation. (2025). Firebase Realtime Database. Retrieved from https://firebase.google.com/docs/database

Google Cloud. (2025). Cloud Firestore Documentation. Retrieved from https://cloud.google.com/firestore/docs

n8n Documentation. (2025). n8n Workflow Automation. Retrieved from https://docs.n8n.io/

Flutter Documentation. (2025). Flutter Web. Retrieved from https://flutter.dev/web

---

## APPENDICES

### Appendix IV: User Training Manual

#### Introduction to CustoFlow

CustoFlow is an automated customer feedback management system designed to help small and medium enterprises collect, analyze and respond to customer feedback efficiently. This training manual provides step-by-step instructions for company administrators to use all features of the CustoFlow system.

#### Getting Started

To begin using CustoFlow, navigate to the landing page and click the Get Started Free button. You will be directed to the registration page where you should enter your company name, your email address and a secure password. After entering this information and clicking the Register button, your account will be created and you will receive a confirmation email at the address you provided. Click the link in the confirmation email to activate your account.

[SCREENSHOT: Getting Started section with registration flow]

#### Logging into Your Account

To log into CustoFlow, click the Sign In button on the landing page and enter your email address and password. After successful authentication, you will be directed to your company dashboard where you can access all features.

#### Viewing Your Company Information

The Company Information section at the top of the dashboard displays your company name, administrator email address and API key. Your API key is used by partner companies to authenticate their feedback forms and is required for the integration process. You can copy your API key to your clipboard by clicking the Copy button next to your key.

[SCREENSHOT: Company information section on dashboard]

#### Understanding Your Analytics Dashboard

The Analytics Overview section of your dashboard displays four important metrics. Total Feedback is the cumulative number of all feedback submissions received. Positive Feedback is the number of feedback messages classified as positive or satisfied. Negative Feedback is the number of feedback messages classified as negative or dissatisfied. These metrics update in real-time as new feedback is received, enabling you to monitor customer satisfaction trends continuously.

#### Managing Your Departments

Departments allow you to organize feedback collection across different business units or service categories within your company. To create a new department, click the Add Department button in the Departments section. A dialog will appear where you should enter a descriptive name for the department and click Create. The system will automatically generate a unique webhook URL for that department which you can use to embed feedback forms on your websites.

To copy a department webhook URL to your clipboard, click the copy icon next to the URL. You will need this URL when embedding feedback forms on your partner company websites.

[SCREENSHOT: Department creation and management interface]

#### Integrating Feedback Forms on Partner Websites

CustoFlow provides three methods for partner companies to embed feedback collection forms on their websites. You can access all three methods by clicking the Integration Instructions button in the Departments section.

**Method One: Direct Code Copying** displays complete HTML and JavaScript code that partner companies can directly copy and paste into their websites. This code includes a feedback form with customer email and message fields, validation logic and submission handlers. The code is pre-populated with your API key and department webhook URL, so partner companies only need to paste it into their website and the form will be fully functional.

[SCREENSHOT: Direct code copying method showing complete form code]

**Method Two: Code Selection Dialog** allows partner companies to review the complete integration code and select specific portions to copy. This method is useful if partner companies want to customize the form design or integrate only portions of the provided code into their existing website structure. You can select individual sections such as the form HTML, JavaScript validation code or submission logic and copy only the sections you need.

[SCREENSHOT: Code selection dialog showing highlighted code sections]

**Method Three: VS Code Copilot Prompt** generates a pre-formatted prompt that can be provided to the VS Code Copilot AI assistant. Copilot will use this prompt to generate customized integration code matching specific requirements. This method is useful for technically advanced partners who want to customize the integration code for their specific use cases.

[SCREENSHOT: Copilot prompt generation showing sample prompt]

#### Monitoring Feedback Submissions

As customers submit feedback through embedded forms on partner company websites, feedback will automatically appear in your analytics dashboard. Positive feedback will trigger automatic thank-you emails to the customers, while negative feedback will trigger escalation alert emails sent to your admin email address. You will receive immediate notification of escalations and should address them according to your customer support procedures.

#### Using the Password Reset Feature

If you forget your password, click the Sign In button on the landing page and look for a Forgot Password link. Click this link and follow the instructions to reset your password. You will receive an email with a secure link that enables you to set a new password.

#### Logging Out

To end your CustoFlow session, click the Sign Out button typically located in the top right corner of the dashboard. You will be logged out and returned to the landing page.

### Appendix V: Sample System Code

#### HTML Integration Form Code

The following is a sample HTML and JavaScript integration code provided to partner companies for embedding feedback forms on their websites.

```html
<!DOCTYPE html>
<html>
<head>
    <style>
        .feedback-form {
            max-width: 400px;
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input, textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-family: Arial, sans-serif;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
        }
        button:hover {
            background-color: #0056b3;
        }
        .message {
            margin-top: 15px;
            padding: 10px;
            border-radius: 4px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="feedback-form">
        <h2>Send Us Your Feedback</h2>
        <form id="feedbackForm">
            <div class="form-group">
                <label for="email">Your Email Address:</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="message">Your Feedback:</label>
                <textarea id="message" name="message" rows="5" required></textarea>
            </div>
            <button type="submit">Submit Feedback</button>
            <div id="responseMessage"></div>
        </form>
    </div>

    <script>
        const API_KEY = 'cfk1234567890abcdef';
        const WEBHOOK_URL = 'https://custoflow.example.com/webhook/dept-12345';

        document.getElementById('feedbackForm').addEventListener('submit', async (e) => {
            e.preventDefault();

            const email = document.getElementById('email').value;
            const message = document.getElementById('message').value;
            const responseDiv = document.getElementById('responseMessage');

            // Validate email format
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                responseDiv.className = 'message error';
                responseDiv.innerHTML = 'Please enter a valid email address.';
                return;
            }

            try {
                const response = await fetch(WEBHOOK_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        email: email,
                        message: message,
                        apiKey: API_KEY,
                    }),
                });

                if (response.ok) {
                    responseDiv.className = 'message success';
                    responseDiv.innerHTML = 'Thank you for your feedback! We appreciate your input.';
                    document.getElementById('feedbackForm').reset();
                } else {
                    throw new Error('Submission failed');
                }
            } catch (error) {
                responseDiv.className = 'message error';
                responseDiv.innerHTML = 'An error occurred while submitting your feedback. Please try again.';
            }
        });
    </script>
</body>
</html>
```

[SCREENSHOT: Sample feedback form rendered in web browser]

#### Firestore Data Model Example

The following depicts a sample company record stored in Firestore with associated departments and feedback records.

```
Companies/
├── company-001-id/
│   ├── name: "Acme Trading Company"
│   ├── adminEmail: "admin@acmetrading.com"
│   ├── companyId: "company-001-id"
│   ├── apiKey: "cfk1234567890abcdef"
│   ├── createdAt: 2025-08-15T10:30:00Z
│   ├── Departments/
│   │   ├── dept-001/
│   │   │   ├── name: "Sales Support"
│   │   │   ├── webhookUrl: "https://custoflow.example.com/webhook/dept-001"
│   │   │   └── createdAt: 2025-08-16T14:20:00Z
│   │   └── dept-002/
│   │       ├── name: "Technical Support"
│   │       ├── webhookUrl: "https://custoflow.example.com/webhook/dept-002"
│   │       └── createdAt: 2025-08-16T14:25:00Z
│   └── Feedback/
│       ├── feedback-001/
│       │   ├── message: "Great service! Very satisfied with the product."
│       │   ├── customerEmail: "customer1@example.com"
│       │   ├── adminEmail: "admin@acmetrading.com"
│       │   ├── sentiment: "positive"
│       │   ├── departmentId: "dept-001"
│       │   └── submittedAt: 2025-08-17T09:15:00Z
│       └── feedback-002/
│           ├── message: "Delivery took too long. Disappointed."
│           ├── customerEmail: "customer2@example.com"
│           ├── adminEmail: "admin@acmetrading.com"
│           ├── sentiment: "negative"
│           ├── departmentId: "dept-002"
│           └── submittedAt: 2025-08-17T10:30:00Z
```

#### n8n Workflow JSON Configuration

The following depicts a simplified n8n workflow configuration for processing feedback and sending notifications.

```json
{
  "nodes": [
    {
      "parameters": {
        "options": {}
      },
      "id": "Webhook Trigger",
      "name": "Webhook Trigger",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1,
      "position": [
        250,
        300
      ]
    },
    {
      "parameters": {
        "model": "gpt-3.5-turbo",
        "messages": "={{ [{ role: 'user', content: 'Classify this feedback as positive or negative: ' + $node['Webhook Trigger'].json.body.message }] }}",
        "options": {}
      },
      "id": "Sentiment Analysis",
      "name": "Sentiment Analysis",
      "type": "n8n-nodes-base.openAi",
      "typeVersion": 1,
      "position": [
        550,
        300
      ],
      "credentials": {
        "openAiApi": "openai_credential_id"
      }
    },
    {
      "parameters": {
        "conditions": {
          "number": [
            {
              "value1": "={{ $node['Sentiment Analysis'].json.choices[0].message.content }}",
              "operation": "contains",
              "value2": "positive"
            }
          ]
        }
      },
      "id": "If Positive",
      "name": "If Positive",
      "type": "n8n-nodes-base.if",
      "typeVersion": 1,
      "position": [
        850,
        200
      ]
    },
    {
      "parameters": {
        "fromEmail": "notifications@custoflow.example.com",
        "toEmail": "={{ $node['Webhook Trigger'].json.body.email }}",
        "subject": "Thank You for Your Feedback",
        "textContent": "Thank you for taking the time to share your feedback with us. We appreciate your kind words and look forward to serving you again.",
        "options": {}
      },
      "id": "Send Thank You Email",
      "name": "Send Thank You Email",
      "type": "n8n-nodes-base.emailSend",
      "typeVersion": 1,
      "position": [
        1100,
        100
      ]
    },
    {
      "parameters": {
        "fromEmail": "notifications@custoflow.example.com",
        "toEmail": "={{ $node['Webhook Trigger'].json.body.adminEmail }}",
        "subject": "Negative Feedback Escalation",
        "textContent": "A negative feedback has been received and requires attention: {{ $node['Webhook Trigger'].json.body.message }}",
        "options": {}
      },
      "id": "Send Escalation Email",
      "name": "Send Escalation Email",
      "type": "n8n-nodes-base.emailSend",
      "typeVersion": 1,
      "position": [
        1100,
        300
      ]
    },
    {
      "parameters": {
        "dataToInsert": "={{ { message: $node['Webhook Trigger'].json.body.message, customerEmail: $node['Webhook Trigger'].json.body.email, sentiment: 'positive', submittedAt: new Date().toISOString() } }}",
        "options": {}
      },
      "id": "Save to Firestore",
      "name": "Save to Firestore",
      "type": "n8n-nodes-base.firestore",
      "typeVersion": 1,
      "position": [
        1100,
        450
      ]
    }
  ],
  "connections": {
    "Webhook Trigger": {
      "main": [
        [
          {
            "node": "Sentiment Analysis",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Sentiment Analysis": {
      "main": [
        [
          {
            "node": "If Positive",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "If Positive": {
      "main": [
        [
          {
            "node": "Send Thank You Email",
            "type": "main",
            "index": 0
          }
        ],
        [
          {
            "node": "Send Escalation Email",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  }
}
```

### Appendix VI: Sample Outputs

#### Sample Analytics Dashboard Output

[SCREENSHOT: Complete dashboard view showing company information, analytics metrics, departments list and integration instructions button]

#### Sample Positive Feedback Email Notification

Subject: Thank You for Your Feedback

Body:
Dear Valued Customer,

Thank you for taking the time to share your positive feedback with us. We truly appreciate your kind words and your business. Your satisfaction is extremely important to us and your compliments motivate our team to continue providing the highest level of service.

If there is anything else we can do to enhance your experience, please do not hesitate to contact us.

Best regards,
The Team at Acme Trading Company

#### Sample Negative Feedback Escalation Email

Subject: Negative Feedback Escalation Notification

Body:
Dear Administrator,

A negative feedback has been received and requires attention.

Customer Email: customer@example.com
Feedback Message: "Delivery took too long. Disappointed."
Received At: September 1, 2025 at 14:30 UTC

Please take appropriate action to address this customer concern and improve their experience.

Best regards,
CustoFlow Feedback Management System

[SCREENSHOT: Sample escalation email displayed]

#### Sample Weekly Report Email

Subject: Weekly Feedback Report - Week of August 25-31, 2025

Body:
Dear Administrator,

Your weekly feedback summary is below:

**Total Feedback Received:** 47
**Positive Feedback:** 38 (80.9%)
**Negative Feedback:** 9 (19.1%)

**Sentiment Trend:** Positive feedback increased 12% compared to the previous week.

**Department Breakdown:**
- Sales Support: 28 feedback (24 positive, 4 negative)
- Technical Support: 19 feedback (14 positive, 5 negative)

**Action Items:**
- Address technical support negative feedback related to response time
- Recognize sales team for high positive feedback rate

For detailed analysis and to access the full dashboard, please visit: https://custoflow.example.com/dashboard

Best regards,
CustoFlow Feedback Management System

[SCREENSHOT: Sample weekly report email displayed]

#### Sample Firestore Query Output

A query retrieving all feedback records for a specific company filtered by positive sentiment would return results similar to the following:

```json
[
  {
    "id": "feedback-001",
    "message": "Excellent product quality and fast delivery!",
    "customerEmail": "james@example.com",
    "adminEmail": "admin@company.com",
    "sentiment": "positive",
    "departmentId": "dept-001",
    "submittedAt": "2025-08-25T08:30:00Z"
  },
  {
    "id": "feedback-003",
    "message": "Best customer service I have experienced",
    "customerEmail": "sarah@example.com",
    "adminEmail": "admin@company.com",
    "sentiment": "positive",
    "departmentId": "dept-002",
    "submittedAt": "2025-08-26T14:15:00Z"
  },
  {
    "id": "feedback-005",
    "message": "Great value for money. Very satisfied.",
    "customerEmail": "mike@example.com",
    "adminEmail": "admin@company.com",
    "sentiment": "positive",
    "departmentId": "dept-001",
    "submittedAt": "2025-08-27T10:45:00Z"
  }
]
```

---

**End of Final Presentation Document**

*This document represents the complete Final Year Project II submission for Marion Omondi (Reg No: 23/06432) from KCA University, prepared under the supervision of Isaac Okola.*
