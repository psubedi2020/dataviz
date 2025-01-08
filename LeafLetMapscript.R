library(leaflet)
library(htmltools)
library(sf)
library(dplyr)

cities <- read.csv(textConnection("
Company,Lat,Long,Years,Hourly
NVCC,38.6183312,-77.2944831,1,9
GMU,38.830665,-77.3088917,1,7
INLS,38.915618,-77.0501627,4,1
Walcoff Technologies (now DDL Omni Engineering),38.8595866,-77.365037,4,35
RCI (now Serco),38.8830157,-77.2281617,5,55
XeRox (now Conduit),39.2006021,-77.2628966,3,50
CareFirst of Maryland,39.4078582,-76.7969309,6,55
CSC with Maximus,39.185313,-76.8063225,1,62
LegalShield with SystemOne Remoted to Ada OK from Ellicott City MD,39.267196,-76.8153927,.25,70
CSRA with Modis,39.3264819,-76.7496914,.25,75
Freddie Mac with Experis,38.9327908,-77.2292522,.2,70
The Iron Yard,38.8985656,-77.0315957,1,69
PNC Bank with Mastech,40.4417929,-80.0030184,1.25,75
DCCA with Teksystems,39.246257,-76.8345331,.3,85
GEICO, 38.994915,-77.077202,3.6,80.5
StateFarm:  Remoted to Bloomington IL from Ellicott City MD, 39.2672,-76.8043,1.5,80
"))

# Adding the experiences field with sample content
cities$experiences <- c(
  "<br>•1992-1993: <br>• Wrote a GW BASIC program to quickly calculate weights of inventory of chemicals at Chemistry Lab and record (instead of usual paper notes!) ",
  "<br>•1995: Interviewed and collected text and photos of dept professors<br>• Designed and Developed Bio Dept home page using HTML and incorporated feedback<br>• Published to GMU web server.",
  "<br>•1994-1997: Designed and Developed INLS Home Page with collected contents from INLS officers and published; maintained updates.",
  "<br>•1997-2000:
  <br>• Administered NetScape SuiteSpot/Enterprise web servers - to ACL configurations user provisioning on NetScape LDAP Server.
  <br>• Automated Tasks using Perl/CGI
  <br>• Provided technical leadership to Augmented Staff from RoberHalf to revamp AITS-JPO (DARPA/DISA) web site. i.e. taught them enough HTML/CSS/Style Guide/Unix commands/FTP to help convert more than 500 docs to cohesive web pages and put them dev/test servers.
  <br>• Verbally delivered completion of AITS-JPO web site re-vamp project to the augmented staff.
  <br>• Received Supervisory Training and Certificate.
  <br>• Assessed and documented non-performance of an Oracle DBA hire at countrycool.com and verbally delivered termination message empathically
  <br>• Interviewed many candidates for suitable roles and recommend hires with valuable tech skills
  <br>• Trained on Recevied DISA-SA level II certificate to administer DISA web site.
  <br>• Trained on Oracle database, SQL, PL/SQL and received Oracle DBA certification.
  <br>• Provided tech talk/presentations on PHP, establishing Public Key Infrastructure using Netscape Certificate Server.
  <br>• Implemented AI logic in Cold Fusion matching soft goods (guitar lessons) on guitarcool.com when users are buying albums on countrycool.com. Integrated with INTERSHOP e-comm engine. Involved understanding Sybase stored proc and calling them with CFML.",
  "<br>•2002-2005:
  <br>•Full stack development of ACAP Web 2001 and 2003 Sybase ASE database design (DDL) forms design app security using HTML/CFML/SQL/JavaScript for form validations, query designs (DML/DRLs) for data reads and writes,  tested, feedbacks incorporated and deployed to prod.  Provided support and maintenance.  Received recognition letters from customer and Serco CEO.
  <br>•Active involvement to migrate ACAP XXI client server system to web based centralized system using Java/J2EE/WebSphere/secured app with AKO LDAP with JNDI; Wrote Custom Java for ETL to aggregate (ETL) from all Army units.  .Net vs Java criteria and Proof of Concepts, Centralized Transactional Database Design and Data Dictionary reviews.
  <br>•Received ACAP Coin No92, Sun Certified Java Programmer (SCJP) cert, and Masters degree in Computer Science from Marymount University. ",
  "<br>•2005-2008:
  <br>•Prototyped near real time plaza monitoring and lane command control system using HTML/CSS/AJAX and Common Controls JSP framework for EZ-PASS MdTA
  <br>•Architectural evaluation on messaging system to handle JMS messages from EZPass Lanes on WebSphere MQ; and to send lane commands from to UI to lanes. ICD established.
  <br>•Implemented Audit module to allow audits of lane transactions recorded on Oarcle database - used JSP common controls frameowrk, Hibernate, security tags to provide fine-grained permissions to RBAC features.
  <br>•Trained on IBM ClearCase and ClearQuest.  
  <br>•Guided augmented staff from Hexaware to use Common Controls framework to implement EZPass MdTA public web site and fine grained controls within the UI.
  <br>•Released one of the neatest systems yet in my career thus far - a near real-time browser based plaza monitoring dashboard that accumulated metrics on server side as toll transaction occur lanes.  Also provides supervisors ability to control lanes by sending lane commands.
  <br>    • Techs used RFID -> Payment Gateways -> Lane Messages to WebSphere MQ -> JMS Message Driven Beans, Java Singletons accumulating metrics, recent transactions on WAS -> AJAX/JSP/HTML/CSS ",
  "<br>•2008-2014
  <br>•Developing, Securing, Reviewing release artifacts, CI/CD (Jenkins and uDeploy) of Member Portal, Provider Portal, UAMS/UAAS, Associate Portal, PCMH.
  <br>•Trained on IBM WebSphere Portal Server, Java/Spring JSR 168/286 Portlet developments, uBuild, TIBCO ESB.
  <br>•Secured portlets, and portal pages via xmlaccess and provided production support administering a horizontal cluster of 4 portal servers.
  <br>•Guided augmented staff from Cognizant and InfoSys on packing deployment and preparing release artifacts for portal releases.
  <br>•Java/Maven/xmlaccess/HTML/CSS/LDAP/Interportlet communication/WAS/WPS/Jenkins/uBuild/uDeploy/RAD/Python/Confluence/JIRA",
  "<br>•2014-2015
  <br>•Oracle Business Intelligence Enterprise Edition - Timeliness report development and integration on DECC portal using Oracle ADF, JDeveloper
  <br>•DECC Architecture presentation to team members.  Oracle NetFusion, WebCenter, MagicDraw, SOAP Services - Data Layer and Service Layers, JAWS Section 508 review test results, usage of Federal Web Style Guide for CMS
  <br>•Brownbag tech talks on CISSP studies/topics",
  "<br>•2015: Java/JSR 286/Maven WPS, AngularJS Portlet development for Associate Portal that consumed FedEx API programmatically and rendered shipping labels to LegalShield Associates, instead of having to go to FexEx to print Shipping Labels.  Luhn's Algorithm to validate Credit Card input, used Base64 encoding to represent/process labels.  RBAC Security.",
  "<br>•2015-2016:  Site Reliability Engineering using NewRelic/Dynatrace of CMS's Enterprise Portal (WebSphere). Coordinate with CMS partners in terms on boarding features via JIRA/Confluence Agile boards/processes.  AWS CloudFormation template preps for Cloud Migrations.",
  "<br>•2016: Schedule Java ETL jobs using AutoSys jil commands for FreddieMac eMBS data. SQL Server, Java DAO's, Git, Fortify Scan (SAST/DAST).",
  "<br>•2016-2017: 
  <br>•As main Java instructor of NVCC Uncommon Coders Program, interviewed and formed Java bootcamp cohort; 
  <br>•Provided immersive hands-on instructions on Git/GitHub/Java/Spring/SpringBoot/Spring Security/Spring JPA/Spring Web/Console/Mobile(Android)
  <br>•/SQL/JavaScript(Angular/React)/AWS VPC/AWS BeanStalk/Heroku
  <br>•Taught/practiced Agile/Scrum methodology with Participants for their capstone projects
  <br>•Held 1:1s with participants and provided encouraging feedbacks to inspire timely progress.  
  <br>•Signed and conferred certificates of successful completion based on their bootcamp grades.",
  "<br>•2017-2018: PNC Edit Check implementation - Angular/SpringBoot - for Comprehensive Capital Analysis Review report generation by PNC Bank. that aggregates data from VENA templates using Informatica.  Show realtime visualization of informatica process flows using Tableau Visualization JavaScript library",
  "<br>•2018-2019: UCPI updates feature implementation using SpringBoot/Spring Security/SpringWeb (REST)/React front end following Federal Web Style guide.  Git/Eclipse.  Deployed to AWS environments",
  "<br>•2019-2022: GEICO, Sr. Software Engineer
   <br>•Proxmity repair shop search feature update of Integration Framework REST API.
   <br>•SAST/DAST CI/CD scanning of 130 or so IF Java/Spring REST/SOAP API's. 
   <br>•Identified code change necessary per Veracode/Secure Code Warrior and addressed and updated code based per security policy in place.
   <br>•Received Gold Rank certification by Secure Code Warrior assessment on Java/Spring.
   <br>•Created a number of Splunk dashboards to monitor IF API's and used Splunk/Dynatrace to triage issues being reported on those APIs.  Provided Reliable On-Call support.",
  "<br>•2023-2024: State Farm, Lead Software Engineer
  <br>•Developed reference implementation of Terraform IaC that creates resources for AWS Lambdas, SQS, Dynamo DB, Step Functions.
  <br>•Wrote Terraform script that adds Dynatrace layer on Lambdas of FSS (Field Service Scheduling) for lambdas activity monitoring on Fire claims Handlers).
  <br>•Developed Splunk and Dynatrace dashboard for monitoring and triaging FETD API's and FSS AWS components.
  <br>•Setup GitLab CI/CD to build/deploy four FETD SpringBoot API's on to TP2 (Pivotal Cloud Foundry) platform.
  <br>•Leveraged AI Assistant/GitHub Copilot to review and fine tune codes under code review and approved PR's accordingly or provided feedback for improvements gently.
  <br>•Recevied SalesForce ARC101:  Build and Integration training
  <br>•Java/SpringBoot/Spring Security/LDAP/Active Directory/EntraID/Maven/
  <br>•Pivotal Cloud Foundry/On-Prem/SalesForce - Apex, SOQL/AWS/Terraform/Git/GitLab Issues/GitLab Pipelines/BDD/Postman/Insomnia/
  <br>•GitHub Copilot/Agile Ceremonies/CI/CDSnyk SAST DAST/Automated Testing"
    # Add more sample bullets for other rows as needed
)

# Create the leaflet map
leaflet(data = cities) %>% 
  addTiles() %>%
  addCircles(lng = ~Long, lat = ~Lat, weight = 1, 
             radius = ~sqrt(Years * Hourly) * 500, 
             popup = ~paste(Company, ": ", experiences, sep = "")  # Show city name and experiences in the popup
  ) %>%  
  setView(lng = -77.25, lat = 38.85, zoom = 10)
  addLegend("bottomright", colors = "#ffa500", labels = "Size of bubbles indicate number of years.", title = "Prakash Subedi's Professional Experience Locations")
