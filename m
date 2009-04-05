Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 87-194-101-244.bethere.co.uk ([87.194.101.244] helo=marcm.co.uk)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marcmltd@marcm.co.uk>) id 1LqRyJ-0002vt-KK
	for linux-dvb@linuxtv.org; Sun, 05 Apr 2009 15:01:13 +0200
Content-class: urn:content-classes:message
Date: Sun, 5 Apr 2009 14:00:27 +0100
MIME-Version: 1.0
Message-ID: <6F732ACED223C5478F0C244EF5D6BA31030685@marcm-serv01.MARCM.local>
From: "Marc Murphy" <marcmltd@marcm.co.uk>
To: <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Writing a new driver help please
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1485215849=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1485215849==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C9B5EE.8C09456F"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C9B5EE.8C09456F
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi All,
I'm new to DVB and attempting to write a driver to use on an embedded =
platform that I am developing.
I have used the current micronas demod with a kernel driver that I wrote =
to enable my system to tune and stream live TS.
=20
However I thought it would be good to bring my driver up to the spec of =
DVB and need a few pointers.  I have taken an example driver but they =
all seem to be working off either USB or PCI, my system uses neither.  I =
have the standard i2c for microcode initialisation and control but the =
TS comes directly into my micro.
=20
Is there a simple way to write a basic driver that uses the standard DVB =
framework so that I can register a device without having to use PCI or =
USB ?  What I have tried so far it to add an adaptor and then add a =
device.
=20
It seems to be working up to the point of the second call to sysfs to =
create the symbolic link to video0.
I don't fully understand what is going on or whether there is anything I =
need to initialise before attempting to create the device but I can post =
code snippets if that would help.
=20
I hope somebody out there understands what I am going on about.
=20
Thanks
Marc.
=20

------_=_NextPart_001_01C9B5EE.8C09456F
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML dir=3Dltr><HEAD>=0A=
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dunicode">=0A=
<META content=3D"MSHTML 6.00.6001.18203" name=3DGENERATOR></HEAD>=0A=
<BODY>=0A=
<DIV id=3DidOWAReplyText9494 dir=3Dltr>=0A=
<DIV dir=3Dltr><FONT face=3DArial color=3D#000000 size=3D2>Hi =
All,</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2>I'm new to DVB and attempting =
to write a driver to use on an embedded platform that I am =
developing.</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2>I have used the current =
micronas&nbsp;demod with a kernel driver that I wrote to enable my =
system to tune and stream live TS.</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2>However I thought it would be =
good to bring my driver up to the spec of DVB and need a few =
pointers.&nbsp; I have taken an example driver but they all seem to be =
working off either USB or PCI, my system uses neither.&nbsp; I have the =
standard i2c for microcode initialisation and control but the TS comes =
directly into my micro.</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2>Is there a simple way to =
write a basic driver that uses the standard DVB framework so that I can =
register a device without having to use PCI or USB ?&nbsp; What I have =
tried so far it to add an adaptor and then add a device.</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2>It seems to be working up to =
the point of the second call to sysfs to create the symbolic link to =
video0.</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2>I don't fully understand what =
is going on or whether there is anything I need to initialise before =
attempting to create the device but I can post code snippets if that =
would help.</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2>I hope somebody out there =
understands what I am going on about.</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2>Thanks</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2>Marc.</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial color=3D#000000 size=3D2><SPAN =
style=3D"FONT-SIZE: 10pt"></SPAN>&nbsp;</DIV></DIV></FONT></BODY></HTML>
------_=_NextPart_001_01C9B5EE.8C09456F--


--===============1485215849==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1485215849==--
