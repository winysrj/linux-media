Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <froil.persson@gmail.com>) id 1LcIeZ-0003FT-MP
	for linux-dvb@linuxtv.org; Wed, 25 Feb 2009 13:14:20 +0100
Received: by fxm12 with SMTP id 12so3856493fxm.17
	for <linux-dvb@linuxtv.org>; Wed, 25 Feb 2009 04:13:46 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 25 Feb 2009 13:13:46 +0100
Message-ID: <f6ae13650902250413k4b3e4feag296b4270327fd944@mail.gmail.com>
From: Fredrik Persson <froil.persson@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Pinnacle PCTV 310i
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0389918910=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0389918910==
Content-Type: multipart/alternative; boundary=001636c5b422defc5f0463bd2a84

--001636c5b422defc5f0463bd2a84
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi

I have a Pinnacle PCTV Hybrid Pro310i card which I use on a MythBuntu 8.10
installation with a 2.6.27-11 Kernel. The installation works great out of
the box except for one thing.

It often happens that I can't use the dvb part of the card. When this
happens i get this from dmesg:

Feb 19 06:56:51 mythtv kernel: [  828.597021] tda1004x: setting up plls for
48MHz sampling clock
Feb 19 06:56:53 mythtv kernel: [  830.841022] tda1004x: timeout waiting for
DSP ready
Feb 19 06:56:53 mythtv kernel: [  830.880022] tda1004x: found firmware
revision 0 -- invalid
Feb 19 06:56:53 mythtv kernel: [  830.880026] tda1004x: trying to boot from
eeprom
Feb 19 06:56:56 mythtv kernel: [  833.209021] tda1004x: timeout waiting for
DSP ready
Feb 19 06:56:56 mythtv kernel: [  833.248022] tda1004x: found firmware
revision 0 -- invalid
Feb 19 06:56:56 mythtv kernel: [  833.248025] tda1004x: waiting for firmware
upload...
Feb 19 06:56:56 mythtv kernel: [  833.248029] firmware: requesting
dvb-fe-tda10046.fw
Feb 19 06:57:10 mythtv kernel: [  847.772029] tda1004x: timeout waiting for
DSP ready
Feb 19 06:57:10 mythtv kernel: [  847.812019] tda1004x: found firmware
revision 0 -- invalid
Feb 19 06:57:10 mythtv kernel: [  847.812024] tda1004x: firmware upload
failed
Feb 19 06:57:42 mythtv kernel: [  879.832020] tda1004x: setting up plls for
48MHz sampling clock
Feb 19 06:57:45 mythtv kernel: [  882.076020] tda1004x: timeout waiting for
DSP ready
Feb 19 06:57:45 mythtv kernel: [  882.116016] tda1004x: found firmware
revision 0 -- invalid
Feb 19 06:57:45 mythtv kernel: [  882.116021] tda1004x: trying to boot from
eeprom
Feb 19 06:57:47 mythtv kernel: [  884.444022] tda1004x: timeout waiting for
DSP ready
Feb 19 06:57:47 mythtv kernel: [  884.484019] tda1004x: found firmware
revision 0 -- invalid
Feb 19 06:57:47 mythtv kernel: [  884.484024] tda1004x: waiting for firmware
upload...
Feb 19 06:57:47 mythtv kernel: [  884.484027] firmware: requesting
dvb-fe-tda10046.fw
Feb 19 06:58:02 mythtv kernel: [  899.164015] tda1004x: timeout waiting for
DSP ready
Feb 19 06:58:02 mythtv kernel: [  899.204168] tda1004x: found firmware
revision 0 -- invalid
Feb 19 06:58:02 mythtv kernel: [  899.204175] tda1004x: firmware upload
failed
Feb 19 07:14:31 mythtv kernel: [ 1888.392018] tda1004x: setting up plls for
48MHz sampling clock
Feb 19 07:14:33 mythtv kernel: [ 1890.636018] tda1004x: timeout waiting for
DSP ready
Feb 19 07:14:33 mythtv kernel: [ 1890.676016] tda1004x: found firmware
revision 0 -- invalid
Feb 19 07:14:33 mythtv kernel: [ 1890.676020] tda1004x: trying to boot from
eeprom
Feb 19 07:14:36 mythtv kernel: [ 1893.005014] tda1004x: timeout waiting for
DSP ready
Feb 19 07:14:36 mythtv kernel: [ 1893.045014] tda1004x: found firmware
revision 0 -- invalid
Feb 19 07:14:36 mythtv kernel: [ 1893.045017] tda1004x: waiting for firmware
upload...
Feb 19 07:14:36 mythtv kernel: [ 1893.045021] firmware: requesting
dvb-fe-tda10046.fw
Feb 19 07:14:50 mythtv kernel: [ 1907.516019] tda1004x: timeout waiting for
DSP ready
Feb 19 07:14:50 mythtv kernel: [ 1907.556021] tda1004x: found firmware
revision 0 -- invalid
Feb 19 07:14:50 mythtv kernel: [ 1907.556029] tda1004x: firmware upload
failed


It does however not happen every time. I can't make out a clear pattern for
when this occurs. When i diff the output from dmesg from when everything
works with the output when i fails I can't find any significant difference.
I hope someone recognizes this problem and can help me.


Best regards

/Fredrik

--001636c5b422defc5f0463bd2a84
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi<br><br>I have a Pinnacle PCTV Hybrid Pro310i card which I use on a MythB=
untu 8.10 installation with a 2.6.27-11 Kernel. The installation works grea=
t out of the box except for one thing.<br><br>It often happens that I can&#=
39;t use the dvb part of the card. When this happens i get this from dmesg:=
<br>
<br>Feb 19 06:56:51 mythtv kernel: [=A0 828.597021] tda1004x: setting up pl=
ls for 48MHz sampling clock<br>Feb 19 06:56:53 mythtv kernel: [=A0 830.8410=
22] tda1004x: timeout waiting for DSP ready<br>Feb 19 06:56:53 mythtv kerne=
l: [=A0 830.880022] tda1004x: found firmware revision 0 -- invalid<br>
Feb 19 06:56:53 mythtv kernel: [=A0 830.880026] tda1004x: trying to boot fr=
om eeprom<br>Feb 19 06:56:56 mythtv kernel: [=A0 833.209021] tda1004x: time=
out waiting for DSP ready<br>Feb 19 06:56:56 mythtv kernel: [=A0 833.248022=
] tda1004x: found firmware revision 0 -- invalid<br>
Feb 19 06:56:56 mythtv kernel: [=A0 833.248025] tda1004x: waiting for firmw=
are upload...<br>Feb 19 06:56:56 mythtv kernel: [=A0 833.248029] firmware: =
requesting dvb-fe-tda10046.fw<br>Feb 19 06:57:10 mythtv kernel: [=A0 847.77=
2029] tda1004x: timeout waiting for DSP ready<br>
Feb 19 06:57:10 mythtv kernel: [=A0 847.812019] tda1004x: found firmware re=
vision 0 -- invalid<br>Feb 19 06:57:10 mythtv kernel: [=A0 847.812024] tda1=
004x: firmware upload failed<br>Feb 19 06:57:42 mythtv kernel: [=A0 879.832=
020] tda1004x: setting up plls for 48MHz sampling clock<br>
Feb 19 06:57:45 mythtv kernel: [=A0 882.076020] tda1004x: timeout waiting f=
or DSP ready<br>Feb 19 06:57:45 mythtv kernel: [=A0 882.116016] tda1004x: f=
ound firmware revision 0 -- invalid<br>Feb 19 06:57:45 mythtv kernel: [=A0 =
882.116021] tda1004x: trying to boot from eeprom<br>
Feb 19 06:57:47 mythtv kernel: [=A0 884.444022] tda1004x: timeout waiting f=
or DSP ready<br>Feb 19 06:57:47 mythtv kernel: [=A0 884.484019] tda1004x: f=
ound firmware revision 0 -- invalid<br>Feb 19 06:57:47 mythtv kernel: [=A0 =
884.484024] tda1004x: waiting for firmware upload...<br>
Feb 19 06:57:47 mythtv kernel: [=A0 884.484027] firmware: requesting dvb-fe=
-tda10046.fw<br>Feb 19 06:58:02 mythtv kernel: [=A0 899.164015] tda1004x: t=
imeout waiting for DSP ready<br>Feb 19 06:58:02 mythtv kernel: [=A0 899.204=
168] tda1004x: found firmware revision 0 -- invalid<br>
Feb 19 06:58:02 mythtv kernel: [=A0 899.204175] tda1004x: firmware upload f=
ailed<br>Feb 19 07:14:31 mythtv kernel: [ 1888.392018] tda1004x: setting up=
 plls for 48MHz sampling clock<br>Feb 19 07:14:33 mythtv kernel: [ 1890.636=
018] tda1004x: timeout waiting for DSP ready<br>
Feb 19 07:14:33 mythtv kernel: [ 1890.676016] tda1004x: found firmware revi=
sion 0 -- invalid<br>Feb 19 07:14:33 mythtv kernel: [ 1890.676020] tda1004x=
: trying to boot from eeprom<br>Feb 19 07:14:36 mythtv kernel: [ 1893.00501=
4] tda1004x: timeout waiting for DSP ready<br>
Feb 19 07:14:36 mythtv kernel: [ 1893.045014] tda1004x: found firmware revi=
sion 0 -- invalid<br>Feb 19 07:14:36 mythtv kernel: [ 1893.045017] tda1004x=
: waiting for firmware upload...<br>Feb 19 07:14:36 mythtv kernel: [ 1893.0=
45021] firmware: requesting dvb-fe-tda10046.fw<br>
Feb 19 07:14:50 mythtv kernel: [ 1907.516019] tda1004x: timeout waiting for=
 DSP ready<br>Feb 19 07:14:50 mythtv kernel: [ 1907.556021] tda1004x: found=
 firmware revision 0 -- invalid<br>Feb 19 07:14:50 mythtv kernel: [ 1907.55=
6029] tda1004x: firmware upload failed<br>
<br><br>It does however not happen every time. I can&#39;t make out a clear=
 pattern for when this occurs. When i diff the output from dmesg from when =
everything works with the output when i fails I can&#39;t find any signific=
ant difference. I hope someone recognizes this problem and can help me.<br>
<br><br>Best regards<br><br>/Fredrik<br>

--001636c5b422defc5f0463bd2a84--


--===============0389918910==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0389918910==--
