Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from email.brin.com ([208.89.164.15])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <lanceb@brin.com>) id 1MdRPd-0005lL-KV
	for linux-dvb@linuxtv.org; Tue, 18 Aug 2009 18:19:54 +0200
Received: from email.brin.com (email.brin.com [172.19.1.12])
	by email.brin.com (Postfix) with ESMTP id 3AADD7D0001
	for <linux-dvb@linuxtv.org>; Tue, 18 Aug 2009 10:19:19 -0600 (MDT)
From: "Lance Badger" <lanceb@brin.com>
To: <linux-dvb@linuxtv.org>
Date: Tue, 18 Aug 2009 10:19:19 -0600 (MDT)
Message-ID: <005501ca201f$a4596f00$ed0c4d00$@com>
MIME-Version: 1.0
Content-Language: en-us
Subject: [linux-dvb] SIOCSIFFLAGS: Cannot assign requested address
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2031873163=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============2031873163==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0056_01CA1FED.59BEFF00"
Content-Language: en-us

This is a multi-part message in MIME format.

------=_NextPart_000_0056_01CA1FED.59BEFF00
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

I have been using DVB-S with the old Hauppauge NOVA-S card and everything
has been working great. I was forced to move to Hauppauge new card
Nova-S-Plus 92001 Rev C1B1 using Fedora 10 2.6.27.24-170.2.68.fc10.i686.

 

Using the linux dvbapps. Here is my dvbnet script 

 

PID=0x40E

DEV_NAME=dvb0_0

IP_ADDR=10.30.3.80

 

/root/dvbapps/util/dvbnet/dvbnet -p $PID

/sbin/ifconfig dvb0_0 10.30.3.80 promisc;

 

When I execute it my interface (dvb0_0) is created, but I get an error
(SIOCSIFFLAGS: Cannot assign requested address

) when it binds an address to the interfance.

 

DVB Network Interface Manager

Version 1.1.0-TVF (Build Wed Mar 11 10:24:03 PM 2009)

Copyright (C) 2003, TV Files S.p.A

 

Device: /dev/dvb/adapter0/net0

Status: device dvb0_0 for pid 1038 created successfully.

SIOCSIFFLAGS: Cannot assign requested address

 

Why would this script work fine with my old Nova-S card, but not with the
new Nova-S-Plus card.  

 

Has anyone else run in to this problem? 


------=_NextPart_000_0056_01CA1FED.59BEFF00
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal>I have been using DVB-S with the old Hauppauge =
NOVA-S card
and everything has been working great. I was forced to move to Hauppauge =
new
card Nova-S-Plus 92001 Rev C1B1 using Fedora 10 =
2.6.27.24-170.2.68.fc10.i686.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Using the linux dvbapps. Here is my dvbnet script =
<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>PID=3D0x40E<o:p></o:p></p>

<p class=3DMsoNormal>DEV_NAME=3Ddvb0_0<o:p></o:p></p>

<p class=3DMsoNormal>IP_ADDR=3D10.30.3.80<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>/root/dvbapps/util/dvbnet/dvbnet -p =
$PID<o:p></o:p></p>

<p class=3DMsoNormal>/sbin/ifconfig dvb0_0 10.30.3.80 =
promisc;<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>When I execute it my interface (dvb0_0) is created, =
but I
get an error (SIOCSIFFLAGS: Cannot assign requested =
address<o:p></o:p></p>

<p class=3DMsoNormal>) when it binds an address to the =
interfance.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>DVB Network Interface Manager<o:p></o:p></p>

<p class=3DMsoNormal>Version 1.1.0-TVF (Build Wed Mar 11 10:24:03 PM =
2009)<o:p></o:p></p>

<p class=3DMsoNormal>Copyright (C) 2003, TV Files S.p.A<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Device: /dev/dvb/adapter0/net0<o:p></o:p></p>

<p class=3DMsoNormal>Status: device dvb0_0 for pid 1038 created =
successfully.<o:p></o:p></p>

<p class=3DMsoNormal>SIOCSIFFLAGS: Cannot assign requested =
address<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Why would this script work fine with my old Nova-S =
card, but
not with the new Nova-S-Plus card.&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Has anyone else run in to this problem? =
<o:p></o:p></p>

</div>

</body>

</html>

------=_NextPart_000_0056_01CA1FED.59BEFF00--


--===============2031873163==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2031873163==--
