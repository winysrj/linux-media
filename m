Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <BYU@maxlinear.com>) id 1OmKov-0005H3-KI
	for linux-dvb@linuxtv.org; Fri, 20 Aug 2010 08:11:18 +0200
Received: from exprod5og113.obsmtp.com ([64.18.0.26])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with smtp
	for <linux-dvb@linuxtv.org>
	id 1OmKou-0003Yl-9C; Fri, 20 Aug 2010 08:11:17 +0200
From: Bo Yu <BYU@maxlinear.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Date: Fri, 20 Aug 2010 06:11:04 +0000
Message-ID: <685714E31AB99345A1CD27447D3BF4D716EA7859@USMXLMBX02.maxlinear.com>
Content-Language: en-US
MIME-Version: 1.0
Subject: [linux-dvb] driver use reference count reaches a big weird number
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1205769080=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: Mauro Carvalho Chehab <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============1205769080==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_685714E31AB99345A1CD27447D3BF4D716EA7859USMXLMBX02maxli_"

--_000_685714E31AB99345A1CD27447D3BF4D716EA7859USMXLMBX02maxli_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,

I found that when I load the driver for vp7045 and unplug device from USB p=
ort, the driver's use reference count reaches a big weird number (Ex: 42949=
67291).
The Linux kernel version is 2.6.28. The source code of vp7045 is fetched fr=
om hg server lately.

Does anyone know this bug? I wonder whether the bug it is fixed.

Thank you!
Bob

--_000_685714E31AB99345A1CD27447D3BF4D716EA7859USMXLMBX02maxli_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" xmlns:w=3D"urn:sc=
hemas-microsoft-com:office:word" xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;}
 /* Page Definitions */
 @page Section1
	{size:595.3pt 841.9pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;
	layout-grid:15.6pt;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DZH-CN link=3Dblue vlink=3Dpurple style=3D'text-justify-trim:pu=
nctuation'>

<div class=3DSection1 style=3D'layout-grid:15.6pt'>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US style=
=3D'font-size:
9.0pt;font-family:Arial'>Hi all,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US style=
=3D'font-size:
9.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US style=
=3D'font-size:
9.0pt;font-family:Arial'>I found that when I load the driver for vp7045 and
unplug device from USB port, the driver&#8217;s use reference count reaches=
 a
big weird number (Ex: 4294967291).<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US style=
=3D'font-size:
9.0pt;font-family:Arial'>The Linux kernel version is 2.6.28. The source cod=
e of
vp7045 is fetched from hg server lately.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US style=
=3D'font-size:
9.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US style=
=3D'font-size:
9.0pt;font-family:Arial'>Does anyone know this bug? I wonder whether the bu=
g it
is fixed.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US style=
=3D'font-size:
9.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US style=
=3D'font-size:
9.0pt;font-family:Arial'>Thank you!<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US style=
=3D'font-size:
9.0pt;font-family:Arial'>Bob<o:p></o:p></span></font></p>

</div>

</body>

</html>

--_000_685714E31AB99345A1CD27447D3BF4D716EA7859USMXLMBX02maxli_--


--===============1205769080==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1205769080==--
