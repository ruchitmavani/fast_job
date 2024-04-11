# flutter_web_demo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

# full name of query params

noc= name of company
nop= name of person
moNo1= mobile no1
mono2=mobile no2
email=email
jobPos=job position
nov=no. of vacancy
gov=gender of vacancy
eq=education qualification
je=job experience
keySkill=key skill
spm=salary per month
jobAdd=Job address
cpname=contact person name
cpmn=contact person mo. no
ctfcon=call timing for contact

DATE OF JOB VACANCY:
COMPANY NAME:
JOB LOCATION:
JOB POSITION:
NO. OF VACANCY:
EDUCATION QUALIFICATION:
EXPERIENCE:
REQUIRED SKILL:
SALARY PER MONTH:
CONTACT PERSON NAME:
CONTACT PERSON MOBILE NO:
CONTACT PERSON EMAIL:
TIMING OF CONTACT:


//sheet
=IF(A2="","",HYPERLINK( CONCATENATE("https://job-image-72fe6.web.app/?formType=","job", CONCATENATE("&noc=" ,B2),CONCATENATE("&nop=" ,C2),CONCATENATE("&moNo1=" ,D2),CONCATENATE("&mono2=" ,E2),CONCATENATE("&email=" ,F2),CONCATENATE("&jobPos=" ,G2),CONCATENATE("&nov=" ,H2),CONCATENATE("&gov=" ,I2),CONCATENATE("&eq=" ,J2),CONCATENATE("&je=" ,K2),CONCATENATE("&keySkill=" ,L2),CONCATENATE("&spm=" ,M2),CONCATENATE("&jobAdd=" ,N2),CONCATENATE("&cpname=" ,O2),CONCATENATE("&cpmn=" ,P2),CONCATENATE("&ctfcon=" ,Q2), CONCATENATE("&date=", A2)),B2))