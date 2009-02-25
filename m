Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2f.orange.fr ([80.12.242.151])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <catimimi@libertysurf.fr>) id 1LcLh6-00031S-4g
	for linux-dvb@linuxtv.org; Wed, 25 Feb 2009 16:29:08 +0100
Message-ID: <49A563A1.2000704@libertysurf.fr>
Date: Wed, 25 Feb 2009 16:28:33 +0100
From: Catimimi <catimimi@libertysurf.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
References: <f6ae13650902250413k4b3e4feag296b4270327fd944@mail.gmail.com>
In-Reply-To: <f6ae13650902250413k4b3e4feag296b4270327fd944@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle PCTV 310i
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0576506691=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0576506691==
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content=3D"text/html;charset=3DISO-8859-15"
 http-equiv=3D"Content-Type">
  <title></title>
</head>
<body bgcolor=3D"#ffffff" text=3D"#000000">
Fredrik Persson a =E9crit=A0:
<blockquote
 cite=3D"mid:f6ae13650902250413k4b3e4feag296b4270327fd944@mail.gmail.com"
 type=3D"cite">Hi<br>
  <br>
I have a Pinnacle PCTV Hybrid Pro310i card which I use on a MythBuntu
8.10 installation with a 2.6.27-11 Kernel. The installation works great
out of the box except for one thing.<br>
  <br>
It often happens that I can't use the dvb part of the card. When this
happens i get this from dmesg:<br>
  <br>
Feb 19 06:56:51 mythtv kernel: [=A0 828.597021] tda1004x: setting up plls
for 48MHz sampling clock<br>
Feb 19 06:56:53 mythtv kernel: [=A0 830.841022] tda1004x: timeout waiting
for DSP ready<br>
Feb 19 06:56:53 mythtv kernel: [=A0 830.880022] tda1004x: found firmware
revision 0 -- invalid<br>
Feb 19 06:56:53 mythtv kernel: [=A0 830.880026] tda1004x: trying to boot
from eeprom<br>
Feb 19 06:56:56 mythtv kernel: [=A0 833.209021] tda1004x: timeout waiting
for DSP ready<br>
Feb 19 06:56:56 mythtv kernel: [=A0 833.248022] tda1004x: found firmware
revision 0 -- invalid<br>
Feb 19 06:56:56 mythtv kernel: [=A0 833.248025] tda1004x: waiting for
firmware upload...<br>
Feb 19 06:56:56 mythtv kernel: [=A0 833.248029] firmware: requesting
dvb-fe-tda10046.fw<br>
Feb 19 06:57:10 mythtv kernel: [=A0 847.772029] tda1004x: timeout waiting
for DSP ready<br>
Feb 19 06:57:10 mythtv kernel: [=A0 847.812019] tda1004x: found firmware
revision 0 -- invalid<br>
Feb 19 06:57:10 mythtv kernel: [=A0 847.812024] tda1004x: firmware upload
failed<br>
Feb 19 06:57:42 mythtv kernel: [=A0 879.832020] tda1004x: setting up plls
for 48MHz sampling clock<br>
Feb 19 06:57:45 mythtv kernel: [=A0 882.076020] tda1004x: timeout waiting
for DSP ready<br>
Feb 19 06:57:45 mythtv kernel: [=A0 882.116016] tda1004x: found firmware
revision 0 -- invalid<br>
Feb 19 06:57:45 mythtv kernel: [=A0 882.116021] tda1004x: trying to boot
from eeprom<br>
Feb 19 06:57:47 mythtv kernel: [=A0 884.444022] tda1004x: timeout waiting
for DSP ready<br>
Feb 19 06:57:47 mythtv kernel: [=A0 884.484019] tda1004x: found firmware
revision 0 -- invalid<br>
Feb 19 06:57:47 mythtv kernel: [=A0 884.484024] tda1004x: waiting for
firmware upload...<br>
Feb 19 06:57:47 mythtv kernel: [=A0 884.484027] firmware: requesting
dvb-fe-tda10046.fw<br>
Feb 19 06:58:02 mythtv kernel: [=A0 899.164015] tda1004x: timeout waiting
for DSP ready<br>
Feb 19 06:58:02 mythtv kernel: [=A0 899.204168] tda1004x: found firmware
revision 0 -- invalid<br>
Feb 19 06:58:02 mythtv kernel: [=A0 899.204175] tda1004x: firmware upload
failed<br>
Feb 19 07:14:31 mythtv kernel: [ 1888.392018] tda1004x: setting up plls
for 48MHz sampling clock<br>
Feb 19 07:14:33 mythtv kernel: [ 1890.636018] tda1004x: timeout waiting
for DSP ready<br>
Feb 19 07:14:33 mythtv kernel: [ 1890.676016] tda1004x: found firmware
revision 0 -- invalid<br>
Feb 19 07:14:33 mythtv kernel: [ 1890.676020] tda1004x: trying to boot
from eeprom<br>
Feb 19 07:14:36 mythtv kernel: [ 1893.005014] tda1004x: timeout waiting
for DSP ready<br>
Feb 19 07:14:36 mythtv kernel: [ 1893.045014] tda1004x: found firmware
revision 0 -- invalid<br>
Feb 19 07:14:36 mythtv kernel: [ 1893.045017] tda1004x: waiting for
firmware upload...<br>
Feb 19 07:14:36 mythtv kernel: [ 1893.045021] firmware: requesting
dvb-fe-tda10046.fw<br>
Feb 19 07:14:50 mythtv kernel: [ 1907.516019] tda1004x: timeout waiting
for DSP ready<br>
Feb 19 07:14:50 mythtv kernel: [ 1907.556021] tda1004x: found firmware
revision 0 -- invalid<br>
Feb 19 07:14:50 mythtv kernel: [ 1907.556029] tda1004x: firmware upload
failed<br>
  <br>
  <br>
It does however not happen every time. I can't make out a clear pattern
for when this occurs. When i diff the output from dmesg from when
everything works with the output when i fails I can't find any
significant difference. I hope someone recognizes this problem and can
help me.<br>
  <br>
  <br>
Best regards<br>
  <br>
/Fredrik<br>
</blockquote>
<br>
Hi,<br>
Did you upload firmware "dvb-fe-tda10046.fw" in folder /lib/firmware ?<br=
>
<br>
Regards.<br>
Michel.<br>
<br>
<br>
<blockquote
 cite=3D"mid:f6ae13650902250413k4b3e4feag296b4270327fd944@mail.gmail.com"
 type=3D"cite">
  <pre wrap=3D"">
<hr size=3D"4" width=3D"90%">
_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead <a class=3D"moz-txt-link-abbr=
eviated" href=3D"mailto:linux-media@vger.kernel.org">linux-media@vger.ker=
nel.org</a>
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:linux-dvb@linuxtv.or=
g">linux-dvb@linuxtv.org</a>
<a class=3D"moz-txt-link-freetext" href=3D"http://www.linuxtv.org/cgi-bin=
/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listi=
nfo/linux-dvb</a></pre>
</blockquote>
<br>
</body>
</html>



--===============0576506691==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0576506691==--
