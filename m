Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx4.tellabs.com ([204.154.129.57])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <amy.overmyer@tellabs.com>) id 1LZq9f-0000b6-92
	for linux-dvb@linuxtv.org; Wed, 18 Feb 2009 18:24:18 +0100
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Wed, 18 Feb 2009 11:20:11 -0600
Message-ID: <A6A3FD22234C5A4EA8131B6CBA2986C909D4DCB0@USNVEX3.tellabs-west.tellabsinc.net>
From: "Overmyer, Amy I." <amy.overmyer@tellabs.com>
To: <linux-dvb@linuxtv.org>
Subject: [linux-dvb] vbox cat's eye 3560 usb
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1916733912=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1916733912==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C991ED.9F115954"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C991ED.9F115954
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I'm trying to write a driver for the device, just as a learning
exercise. So far, I've got the firmware in intel hex format (from
usbsnoop on windows, then a couple perl scripts to mutate it) and am
able to use fxload to load it with -t fx2 and there are 2 separate
files, a short one (the loader) and the firmware proper; so in fxload I
have a -s and a -I.=20

=20

I'm able to take it from cold to warm that way.=20

=20

The device itself has a cypress CY7C68013A fx2 chip and a large tin can
tuner/demod stamped with Thomson that has a sticker on it identifying it
as 8601A. Helpfully, the 3560 opens up easily with the removal of two
screws on the shell.

=20

It's cold boot usb id is 14f3:3560 and its warm boot is 14f3:a560.

=20

I have taken that hex file and created a binary file out of the 2nd file
(-I in fxload speak). I think, correct me if I'm wrong, there is already
a fx2 loader available, thus I will not need the loader file.

=20

One of the stranger things I saw in the usbsnoop trace in windows was
when it came to reset of the CPUCS, the driver sent down both a poke at
x0e600 and a poke at 7f92. One is the fx CPUCS register, I believe the
other is a fx2 CPUCS register.=20

=20

Currently I am mutating dibusb-mc just to see if I can get it to the
point of going from cold to warm in the driver.=20

=20

I have taken usb sniffs from windows of doing things such as scanning
for channels, watching a channel, etc. so I can try to figure out if
anything else in the v4l-dvb collection behaves similarly.

=20

I guess what I'm looking for is any hints that might be useful to
figuring this out.=20

=20

Like I said, it's a learning exercise, I already have enough tuners, and
anyway, the cost of buying a supported tuner is far cheaper than the
time needed to develop this!

=20

Thanks for any info! I've pretty much devoured everything available on
the wiki.

=20

Amy

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The information contained in this message may be privileged
and confidential and protected from disclosure. If the reader
of this message is not the intended recipient, or an employee
or agent responsible for delivering this message to the
intended recipient, you are hereby notified that any reproduction,
dissemination or distribution of this communication is strictly
prohibited. If you have received this communication in error,
please notify us immediately by replying to the message and
deleting it from your computer. Thank you. Tellabs
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

------_=_NextPart_001_01C991ED.9F115954
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered)">
<style>
<!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{font-family:Arial;
	color:windowtext;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>I&#8217;m trying to write a driver for the device, just =
as a
learning exercise. So far, I&#8217;ve got the firmware in intel hex format
(from usbsnoop on windows, then a couple perl scripts to mutate it) and am =
able
to use fxload to load it with &#8211;t fx2 and there are 2 separate files, a
short one (the loader) and the firmware proper; so in fxload I have a &#821=
1;s and
a &#8211;I. </span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>I&#8217;m able to take it from cold to warm that way. </=
span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>The device itself has a cypress </span></font>CY7C68013A=
 fx2
chip and a large tin can tuner/demod stamped with Thomson that has a sticke=
r on
it identifying it as 8601A. Helpfully, the 3560 opens up easily with the
removal of two screws on the shell.</p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>It&#8217;s cold boot usb id is 14f3:3560 and its warm boot is
14f3:a560.</span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>I have taken that hex file and created a binary file out=
 of
the 2<sup>nd</sup> file (-I in fxload speak). I think, correct me if I&#821=
7;m
wrong, there is already a fx2 loader available, thus I will not need the lo=
ader
file.</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>One of the stranger things I saw in the usbsnoop trace in
windows was when it came to reset of the CPUCS, the driver sent down both a
poke at x0e600 and a poke at 7f92. One is the fx CPUCS register, I believe =
the
other is a fx2 CPUCS register. </span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>Currently I am mutating dibusb-mc just to see if I can g=
et
it to the point of going from cold to warm in the driver. </span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>I have taken usb sniffs from windows of doing things suc=
h as
scanning for channels, watching a channel, etc. so I can try to figure out =
if
anything else in the v4l-dvb collection behaves similarly.</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>I guess what I&#8217;m looking for is any hints that mig=
ht
be useful to figuring this out. </span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>Like I said, it&#8217;s a learning exercise, I already h=
ave
enough tuners, and anyway, the cost of buying a supported tuner is far chea=
per
than the time needed to develop this!</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>Thanks for any info! I&#8217;ve pretty much devoured eve=
rything
available on the wiki.</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>Amy</span></font></p>

</div>

<pre>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The information contained in this message may be privileged
and confidential and protected from disclosure. If the reader
of this message is not the intended recipient, or an employee
or agent responsible for delivering this message to the
intended recipient, you are hereby notified that any reproduction,
dissemination or distribution of this communication is strictly
prohibited. If you have received this communication in error,
please notify us immediately by replying to the message and
deleting it from your computer. Thank you. Tellabs
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
</pre></body>

</html>

------_=_NextPart_001_01C991ED.9F115954--


--===============1916733912==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1916733912==--
