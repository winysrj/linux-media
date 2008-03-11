Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@ianliverton.co.uk>) id 1JZ7uW-0008IR-Gh
	for linux-dvb@linuxtv.org; Tue, 11 Mar 2008 18:05:09 +0100
Received: from aamtaout02-winn.ispmail.ntl.com ([81.103.221.35])
	by mtaout01-winn.ispmail.ntl.com with ESMTP id
	<20080311170643.RSGB16169.mtaout01-winn.ispmail.ntl.com@aamtaout02-winn.ispmail.ntl.com>
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 17:06:43 +0000
Received: from molly.ianliverton.co.uk ([80.1.111.25])
	by aamtaout02-winn.ispmail.ntl.com with ESMTP id
	<20080311170607.JTDJ17393.aamtaout02-winn.ispmail.ntl.com@molly.ianliverton.co.uk>
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 17:06:07 +0000
Received: from [192.168.1.65] (helo=ians)
	by molly.ianliverton.co.uk with esmtp (Exim 4.69)
	(envelope-from <linux-dvb@ianliverton.co.uk>) id 1JZ7tk-0004El-43
	for linux-dvb@linuxtv.org; Tue, 11 Mar 2008 17:04:22 +0000
From: "Ian Liverton" <linux-dvb@ianliverton.co.uk>
To: <linux-dvb@linuxtv.org>
Date: Tue, 11 Mar 2008 17:06:08 -0000
Message-ID: <004601c8839a$365ac620$4101a8c0@ians>
MIME-Version: 1.0
Subject: [linux-dvb] Nova T-500 detection problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0615895140=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0615895140==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0047_01C8839A.365AC620"

This is a multi-part message in MIME format.

------=_NextPart_000_0047_01C8839A.365AC620
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: quoted-printable

Hi,

=20

I recently purchased two Nova T-500 (as far as I can tell it=92s not one =
of
the diversity range) cards one is the 99101 LF rev D8B5 and one is the =
99102
LF rev C1B5.  The 99101 LF is detected, the other is not.  The only
difference I can see is the postfix of the Dib 0700 chips.  The working =
one
is the Dib0700C-XCXXa-G and the other is Dib0700-1211b-G.  With only the
undetected card in, there is no mention of the dib0700 in dmesg and =
lspci
shows:

=20

02:05.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 61)

02:05.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 61)

02:05.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 63)

=20

Which I presume is the VT6212L on the cards.

=20

Is there something different I need to do for the second card or is it =
just
not supported? Since I can get them both to work with the supplied =
Hauppauge
software under Windows I am assuming it is not a faulty card.

=20

Any help is very much appreciated.  Many thanks,

=20

Ian

=20

---

Ian Liverton

ICT Technician


Internal Virus Database is out-of-date.
Checked by AVG Free Edition.=20
Version: 7.5.516 / Virus Database: 269.21.4 - Release Date: 03/03/2008 =
00:00
=20

------=_NextPart_000_0047_01C8839A.365AC620
Content-Type: text/html;
	charset="windows-1250"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dwindows-1250">


<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
p
	{mso-margin-top-alt:auto;
	margin-right:0cm;
	mso-margin-bottom-alt:auto;
	margin-left:0cm;
	font-size:12.0pt;
	font-family:"Times New Roman";}
span.EmailStyle18
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;}
@page Section1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Hi,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I recently purchased two Nova T-500 (as far as I can =
tell it&#8217;s
not one of the diversity range) cards one is the 99101 LF rev D8B5 and =
one is
the 99102 LF rev C1B5.&nbsp; The 99101 LF is detected, the other is =
not.&nbsp;
The only difference I can see is the postfix of the Dib 0700 =
chips.&nbsp; The
working one is the Dib0700C-XCXXa-G and the other is =
Dib0700-1211b-G.&nbsp; With
only the undetected card in, there is no mention of the dib0700 in dmesg =
and
lspci shows:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>02:05.0 USB Controller: VIA Technologies, Inc. =
VT82xxxxx
UHCI USB 1.1 Controller (rev 61)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>02:05.1 USB Controller: VIA Technologies, Inc. =
VT82xxxxx
UHCI USB 1.1 Controller (rev 61)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>02:05.2 USB Controller: VIA Technologies, Inc. USB =
2.0 (rev
63)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Which I presume is the VT6212L on the =
cards.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Is there something different I need to do for the =
second
card or is it just not supported? Since I can get them both to work with =
the
supplied Hauppauge software under Windows I am assuming it is not a =
faulty
card.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Any help is very much appreciated.&nbsp; Many =
thanks,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Ian<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>---<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>Ian Liverton<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>ICT Technician<o:p></o:p></span></font></p>

</div>

</body>

</html>
<BR>

<P><FONT SIZE=3D2>Internal Virus Database is out-of-date.<BR>
Checked by AVG Free Edition.<BR>
Version: 7.5.516 / Virus Database: 269.21.4 - Release Date: 03/03/2008 =
00:00<BR>
</FONT> </P>

------=_NextPart_000_0047_01C8839A.365AC620--



--===============0615895140==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0615895140==--
