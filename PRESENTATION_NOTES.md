# CustoFlow — Assessor Presentation Notes

> **How to use this file:** These are your speaking notes. Bold text = things to say out loud. Bullet points = supporting details you can expand on if asked. All previously identified gaps have been resolved — see Section 10 for the updated answers.

---

## 1. What Is CustoFlow?

**"CustoFlow is an automated customer feedback management system. Businesses embed a small feedback button on their website, and from that moment CustoFlow takes over — it collects the feedback, analyses it, routes it to the right department, notifies the administrator by email and SMS, stores it, and presents everything in a real-time analytics dashboard."**

- Three integrated layers: a client-side JavaScript widget, an N8N automation server, and a Flutter web dashboard
- Cross-platform Flutter app (Web, Windows, macOS, Linux, Android, iOS)
- Backed by Firebase (Authentication + Firestore)

---

## 2. What Problem Does CustoFlow Solve?

**"Most small and medium businesses have no structured way to collect and act on customer feedback. Feedback arrives through WhatsApp, email, social media, or verbal complaints — it gets lost, ignored, or never reaches the right person."**

### Specific problems it fixes:
| Pain Point | How CustoFlow Solves It |
|---|---|
| Feedback is never collected systematically | Embeddable JS widget on any website |
| Nobody knows which department to forward a complaint to | Automatic department detection (Sales, Support, Technical, Billing) |
| Negative complaints go unnoticed for days | Instant email + SMS alert marked URGENT for negative feedback |
| No overview of how many complaints vs praises you're receiving | Real-time analytics dashboard with live positive/negative counts |
| Preparing feedback reports is manual and time-consuming | One-click downloadable HTML report (Weekly / Monthly / Yearly) |
| Developers don't know how to integrate the system | Auto-generated integration code + VS Code Copilot prompt |
| Feedback status is never tracked after receipt | Admins can mark each item Pending → Reviewed → Resolved directly on the dashboard |

---

## 3. What Is Unique About CustoFlow?

**"CustoFlow is unique because it combines five things that are normally separate tools — feedback collection, sentiment analysis, department routing, real-time reporting, and status tracking — into one automated pipeline that requires zero manual work from the moment a customer submits feedback."**

### Key differentiators:
1. **Automated sentiment analysis at the workflow level** — not just a label; it changes the email subject, SMS trigger, and storage collection
2. **Multilingual keyword detection** — English, Swahili, French, and Spanish keywords are all supported out of the box
3. **API key server-side validation** — the N8N JavaScript node rejects requests with invalid API keys before they touch email or the database
4. **Department-aware routing** — feedback is matched to Sales, Support, Technical, Billing, or General before a human ever sees it
5. **Dual notification** — positive feedback sends an email; negative feedback sends an email AND an SMS so the admin can't miss it
6. **Live real-time dashboard** — built on Firestore `snapshots()` streams; new feedback appears instantly without refreshing the page
7. **Status lifecycle tracking** — admins can update each feedback item from Pending → Reviewed → Resolved directly on the dashboard
8. **Flexible reporting** — download a Weekly (7-day), Monthly (30-day), or Yearly (365-day) HTML report with one click
9. **Self-service integration** — generates ready-to-paste code with embedded credentials; also generates a VS Code Copilot prompt
10. **Multi-tenant architecture** — each company gets a unique `companyId` and `apiKey`; data is always isolated

---

## 4. Who Benefits Most From CustoFlow?

**"The primary beneficiary is any business that has a customer-facing website and wants to understand what their customers are saying — without hiring a dedicated feedback analyst."**

### Target users:
- **Small & Medium Enterprises (SMEs)** — they often lack the staff to manually sort and act on feedback
- **E-commerce businesses** — high volume of customer interactions; knowing what's wrong fast is critical
- **SaaS companies** — need to track technical complaints and route them to engineering quickly
- **Financial services / Fintech** — demonstrated with an M-Pesa clone; billing and payment complaints need urgent handling
- **Customer Support Managers** — get an instant email + SMS when a negative complaint arrives, with the department already identified
- **Businesses serving multilingual customers** — Swahili, French, and Spanish feedback is detected correctly without any setup

---

## 5. What Reports Does CustoFlow Produce?

**"CustoFlow produces downloadable HTML reports — Weekly, Monthly, or Yearly — that the admin selects from a single button on the dashboard."**

### Report contents (same structure for all three periods):
- **Header**: Company name + date range
- **Summary statistics**:
  - Total feedback count
  - Total positive feedback count
  - Total negative feedback count
- **Visual sentiment distribution bar** — colour-coded bar showing positive vs negative proportion as a percentage
- **Department breakdown table** — feedback count per department (Sales, Support, Technical, Billing, General)
- **Complete feedback list** — every message with: customer email, department chip, sentiment label, and formatted date/time
- **Professional CSS styling** — ready to share with management or print as PDF

### Period options:
| Report Type | Date Window | File Name |
|---|---|---|
| Weekly | Last 7 days | `custoflow_weekly_report_[timestamp].html` |
| Monthly | Last 30 days | `custoflow_monthly_report_[timestamp].html` |
| Yearly | Last 365 days | `custoflow_yearly_report_[timestamp].html` |

### Dashboard analytics (live, real-time):
- Total Feedback card
- Positive Feedback card (green)
- Negative Feedback card (red)
- Feedback feed filterable by department, each item showing live status

---

## 6. What Computations Does CustoFlow Do?

**"The app performs several automatic computations — both in the N8N automation pipeline and inside the Flutter dashboard."**

### In the N8N Automation Layer:
| Computation | How |
|---|---|
| **API key validation** | N8N JavaScript node checks that `apiKey` starts with `cfk_`. Invalid keys return `sentiment: rejected` and bypass all downstream nodes |
| **Sentiment analysis** | Keyword matching across English, Swahili, French, and Spanish word lists. Negative takes priority if both match. Defaults to positive |
| **Department classification** | Keyword matching against 4 department dictionaries (multilingual). Defaults to General |
| **Conditional routing** | IF/ELSE branching: positive → email only; negative → email + SMS + separate Firestore collection |
| **SMS dispatch** | Africa's Talking HTTP API call on the negative branch, truncated to 100 characters |

### In the Flutter Dashboard:
| Computation | How |
|---|---|
| **Real-time feedback counts** | Firestore `snapshots()` streams update `_positiveFeedback` and `_negativeFeedback` instantly on every change |
| **Positive/Negative split** | Two stream subscriptions — one per collection — merged and recalculated in `_updateAnalytics()` |
| **Chronological sorting** | Merges both streams and sorts by `_getFeedbackDate()` (supports ISO 8601, Firestore Timestamp, milliseconds) |
| **Department filtering** | Client-side filter on `_selectedDepartmentFilter` state |
| **Report statistics** | Filters `_allFeedbackMessages` by chosen period (7 / 30 / 365 days), counts per department, calculates percentage bars |
| **Status update** | `_updateFeedbackStatus()` writes the new status to the correct Firestore collection; streams auto-refresh the UI |
| **API key generation** | On registration: `cfk_[current timestamp in ms]_[6 random digits]` |
| **Email format validation** | Regex: `/^[^\s@]+@[^\s@]+\.[^\s@]+$/` — applied in the JS widget and the Flutter auth form |
| **Integration code generation** | Dynamically substitutes `companyId`, `apiKey`, and `adminEmail` into an HTML/JS template string |

---

## 7. How Does the System Work? (Live Demo Flow)

> Use this as your demo script if you walk the assessor through the app.

1. **Show the M-Pesa clone website** → Click "Send Feedback" → type a complaint → submit
2. **Show N8N** → the webhook fires, the JS node validates the API key, runs sentiment + department detection, the IF node routes it
3. **Show the Gmail inbox** → email arrives with "URGENT: Negative Feedback — Technical" subject
4. **Open the CustoFlow dashboard** → log in → show the analytics cards updating **in real time** (no page refresh needed)
5. **Filter by department** → show "Technical" filter isolating the complaint
6. **Update the status** → tap the status chip on a feedback card → change from Pending to Reviewed
7. **Download a report** → click the report button → choose Weekly / Monthly / Yearly → open the HTML file
8. **Show Integration Guide** → copy the generated code, show the VS Code Copilot prompt

---

## 8. Technical Stack Summary

| Layer | Technology |
|---|---|
| Client widget | HTML, CSS, Vanilla JavaScript |
| Automation | N8N (self-hosted), JavaScript nodes, Gmail API (OAuth2), Africa's Talking SMS API, Google Cloud Firestore nodes |
| Database | Firebase Firestore (two projects: CustoFlow + M-Pesa clone) |
| Authentication | Firebase Auth (email/password) |
| Dashboard | Flutter 3.10.7+, Dart, `cloud_firestore` (streams), `firebase_auth` |
| Platforms | Web, Windows, macOS, Linux, Android, iOS |
| Report format | HTML with inline CSS (downloadable via `dart:html` Blob API, three period options) |

---

## 9. Security Considerations

- **API key server-side validation**: The N8N JavaScript node checks the `apiKey` prefix on every incoming webhook — invalid keys are rejected before touching email or Firestore
- **Multi-tenant isolation**: Every Firestore query and stream is filtered by `companyId` — one company cannot see another's feedback
- **Firebase Auth**: Dashboard requires login before accessing any data or streams
- **Email validation**: Applied at both the JS widget and the Flutter registration form using regex
- **Firestore Security Rules**: Collections are write-protected; only authenticated users can read their own company data

---

## 10. Questions & Answers

> All previously identified gaps have been resolved. Use these answers with confidence.

| Question | Answer |
|---|---|
| "Can it send SMS alerts?" | "Yes — the N8N automation sends an SMS via Africa's Talking on every negative feedback item, in addition to the email alert." |
| "Does it have monthly/annual reports?" | "Yes — the report button in the dashboard lets you choose Weekly (7 days), Monthly (30 days), or Yearly (365 days). Each downloads as a uniquely named HTML file." |
| "Is the sentiment analysis AI-powered?" | "It uses keyword-based detection across four languages — English, Swahili, French, and Spanish. This is fast, transparent, and explainable. A transformer-based model would be a future production upgrade." |
| "Can the client mark feedback as resolved?" | "Yes — each feedback card has a status dropdown. The admin can change the status from Pending to Reviewed or Resolved with one tap, and the change is written to Firestore immediately." |
| "Does it support multiple languages?" | "Yes — the sentiment and department keyword lists include English, Swahili, French, and Spanish, so customers writing in those languages are detected and routed correctly." |
| "Real-time updates on the dashboard?" | "Yes — the dashboard uses Firestore `snapshots()` streams. New feedback appears instantly without any page refresh, and the analytics cards update live." |
| "How is the API key validated?" | "Every incoming webhook request goes through a JavaScript node in N8N that checks the API key format. Requests with invalid keys are rejected and never reach the email or database nodes." |

---

## 11. One-Sentence Pitch

**"CustoFlow turns every customer complaint or compliment into structured, actionable data — automatically routed, stored, reported in three time ranges, and tracked from Pending to Resolved — so businesses spend time fixing problems instead of finding them."**

---

*Last updated: April 2026 — all six identified gaps have been implemented and resolved.*
