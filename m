Return-Path: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <paulfinn81@gmail.com>) id 1Uouz7-0006yI-B6
	for linux-dvb@linuxtv.org; Tue, 18 Jun 2013 14:26:29 +0200
Received: from mail-wi0-f176.google.com ([209.85.212.176])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-8) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1Uouz5-00057J-mG; Tue, 18 Jun 2013 14:26:05 +0200
Received: by mail-wi0-f176.google.com with SMTP id ey16so3361992wid.3
	for <linux-dvb@linuxtv.org>; Tue, 18 Jun 2013 05:26:03 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 18 Jun 2013 13:26:03 +0100
Message-ID: <CAAOtjjwwBaJiFqo5tfbL-ZEPRSQ36VB=EmQbE4QDqHYi3NogMg@mail.gmail.com>
From: =?ISO-8859-1?B?Zu1u?= <paulfinn81@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] hi all
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1735451704=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1735451704==
Content-Type: multipart/alternative; boundary=f46d04426bbc07c10304df6cd115

--f46d04426bbc07c10304df6cd115
Content-Type: text/plain; charset=ISO-8859-1

i have a USB DVB dongle here:

WinfastDTV Dongle Gold BDA Device (this is what windows recognises it as)
Linux on the other see's it as a Keyboard.


im trying to connect it to an android, is this the place to look for help
regarding drivers?

<4>[28617.147589@0] HOST mode
<4>[28617.363317@0] Using Buffer DMA mode
<4>[28617.363344@0] OTG VER PARAM: 1, OTG VER FLAG: 1
<4>[28617.410265@0] Init: Port Power? op_state=1
<4>[28617.410289@0] Init: Power Port (0)
<4>[28617.412105@0] set usb port power on (board gpio 25)!
<4>[28617.757543@0] Indeed it is in host mode hprt0 = 00021501
<6>[28617.937544@0] usb 1-1: new high speed USB device number 3 using
dwc_otg
<4>[28617.939548@0] Indeed it is in host mode hprt0 = 00001101
<6>[28618.203838@0] Turbosight DTB03: Fixing fullspeed to highspeed
interval: 16 -> 8
<6>[28618.219686@0] input: Turbosight DTB03 as
/devices/lm0/usb1/1-1/1-1:1.1/input/input8
<6>[28618.258041@0] generic-usb 0003:15A4:9016.0002: input,hidraw0: USB HID
v1.01 Keyboard [Turbosight DTB03] on usb-lm0-1/input1
<4>[28628.736599@0] RTL871X: rtw_set_ps_mode: Leave 802.11 power save
<4>[28628.736934@0] RTL871X: rtl8188e_set_FwPwrMode_cmd: Mode=0 SmartPS=2
UAPSD=0
<4>[28631.097591@0] RTL871X: rtw_set_ps_mode: Enter 802.11 power save
<4>[28631.097928@0] RTL871X: rtl8188e_set_FwPwrMode_cmd: Mode=1 SmartPS=2
UAPSD=0
<4>[28633.778113@1] RTL871X: rtw_set_ps_mode: Leave 802.11 power save
<4>[28633.778556@1] RTL871X: rtl8188e_set_FwPwrMode_cmd: Mode=0 SmartPS=2
UAPSD=0
<4>[28635.097638@0] RTL871X: rtw_set_ps_mode: Enter 802.11 power save
<4>[28635.097967@0] RTL871X: rtl8188e_set_FwPwrMode_cmd: Mode=1 SmartPS=2
UAPSD=0
<4>[28640.077238@1] ERROR::dwc_otg_hcd_urb_enqueue:504: Not connected
<4>[28640.077253@1]
<4>[28640.107229@1] ERROR::dwc_otg_hcd_urb_enqueue:504: Not connected
<4>[28640.107244@1]
<4>[28640.167247@1] ERROR::dwc_otg_hcd_urb_enqueue:504: Not connected
<4>[28640.167262@1]
<4>[28640.247304@0] DEVICE mode
<4>[28640.247370@0] PortPower off
<4>[28640.247424@0] set usb port power off (board gpio 25)!
<4>[28640.252873@0] SRP: Device mode
<6>[28640.267394@0] usb 1-1: USB disconnect, device number 3

--f46d04426bbc07c10304df6cd115
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">i have a USB DVB dongle here:<div><br></div><div>WinfastDT=
V Dongle Gold BDA Device (this is what windows recognises it as)</div><div>=
Linux on the other see&#39;s it as a Keyboard.</div><div><br></div><div><br=
>
</div><div>im trying to connect it to an android, is this the place to look=
 for help regarding drivers?</div><div><br></div><div><span style=3D"color:=
rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[28617.147589@0] HOST mod=
e</span><br style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[286=
17.363317@0] Using Buffer DMA mode</span><br style=3D"color:rgb(0,0,0);font=
-family:arial,sans-serif"><span style=3D"color:rgb(0,0,0);font-family:arial=
,sans-serif">&lt;4&gt;[28617.363344@0] OTG VER PARAM: 1, OTG VER FLAG: 1</s=
pan><br style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[286=
17.410265@0] Init: Port Power? op_state=3D1</span><br style=3D"color:rgb(0,=
0,0);font-family:arial,sans-serif"><span style=3D"color:rgb(0,0,0);font-fam=
ily:arial,sans-serif">&lt;4&gt;[28617.410289@0] Init: Power Port (0)</span>=
<br style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[286=
17.412105@0] set usb port power on (board gpio 25)!</span><br style=3D"colo=
r:rgb(0,0,0);font-family:arial,sans-serif"><span style=3D"color:rgb(0,0,0);=
font-family:arial,sans-serif">&lt;4&gt;[28617.757543@0] Indeed it is in hos=
t mode hprt0 =3D 00021501</span><br style=3D"color:rgb(0,0,0);font-family:a=
rial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;6&gt;[286=
17.937544@0] usb 1-1: new high speed USB device number 3 using dwc_otg</spa=
n><br style=3D"color:rgb(0,0,0);font-family:arial,sans-serif"><span style=
=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[28617.939548@0=
] Indeed it is in host mode hprt0 =3D 00001101</span><br style=3D"color:rgb=
(0,0,0);font-family:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;6&gt;[286=
18.203838@0] Turbosight DTB03: Fixing fullspeed to highspeed interval: 16 -=
&gt; 8</span><br style=3D"color:rgb(0,0,0);font-family:arial,sans-serif"><s=
pan style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;6&gt;[28618=
.219686@0] input: Turbosight DTB03 as /devices/lm0/usb1/1-1/1-1:1.1/</span>=
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">input/input8<=
/span><br style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;6&gt;[286=
18.258041@0] generic-usb 0003:15A4:9016.0002: input,hidraw0: USB HID v1.01 =
Keyboard [Turbosight DTB03] on usb-lm0-1/input1</span><br style=3D"color:rg=
b(0,0,0);font-family:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[286=
28.736599@0] RTL871X: rtw_set_ps_mode: Leave 802.11 power save</span><br st=
yle=3D"color:rgb(0,0,0);font-family:arial,sans-serif"><span style=3D"color:=
rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[28628.736934@0] RTL871X:=
 rtl8188e_set_FwPwrMode_cmd: Mode=3D0 SmartPS=3D2 UAPSD=3D0</span><br style=
=3D"color:rgb(0,0,0);font-family:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[286=
31.097591@0] RTL871X: rtw_set_ps_mode: Enter 802.11 power save</span><br st=
yle=3D"color:rgb(0,0,0);font-family:arial,sans-serif"><span style=3D"color:=
rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[28631.097928@0] RTL871X:=
 rtl8188e_set_FwPwrMode_cmd: Mode=3D1 SmartPS=3D2 UAPSD=3D0</span><br style=
=3D"color:rgb(0,0,0);font-family:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[286=
33.778113@1] RTL871X: rtw_set_ps_mode: Leave 802.11 power save</span><br st=
yle=3D"color:rgb(0,0,0);font-family:arial,sans-serif"><span style=3D"color:=
rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[28633.778556@1] RTL871X:=
 rtl8188e_set_FwPwrMode_cmd: Mode=3D0 SmartPS=3D2 UAPSD=3D0</span><br style=
=3D"color:rgb(0,0,0);font-family:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[286=
35.097638@0] RTL871X: rtw_set_ps_mode: Enter 802.11 power save</span><br st=
yle=3D"color:rgb(0,0,0);font-family:arial,sans-serif"><span style=3D"color:=
rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[28635.097967@0] RTL871X:=
 rtl8188e_set_FwPwrMode_cmd: Mode=3D1 SmartPS=3D2 UAPSD=3D0</span><br style=
=3D"color:rgb(0,0,0);font-family:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[286=
40.077238@1] ERROR::dwc_otg_hcd_urb_</span><span style=3D"color:rgb(0,0,0);=
font-family:arial,sans-serif">enqueue:504: Not connected</span><br style=3D=
"color:rgb(0,0,0);font-family:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[286=
40.077253@1]</span><br style=3D"color:rgb(0,0,0);font-family:arial,sans-ser=
if"><span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;=
[28640.107229@1] ERROR::dwc_otg_hcd_urb_</span><span style=3D"color:rgb(0,0=
,0);font-family:arial,sans-serif">enqueue:504: Not connected</span><br styl=
e=3D"color:rgb(0,0,0);font-family:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[286=
40.107244@1]</span><br style=3D"color:rgb(0,0,0);font-family:arial,sans-ser=
if"><span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;=
[28640.167247@1] ERROR::dwc_otg_hcd_urb_</span><span style=3D"color:rgb(0,0=
,0);font-family:arial,sans-serif">enqueue:504: Not connected</span><br styl=
e=3D"color:rgb(0,0,0);font-family:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[286=
40.167262@1]</span><br style=3D"color:rgb(0,0,0);font-family:arial,sans-ser=
if"><span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;=
[28640.247304@0] DEVICE mode</span><br style=3D"color:rgb(0,0,0);font-famil=
y:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[286=
40.247370@0] PortPower off</span><br style=3D"color:rgb(0,0,0);font-family:=
arial,sans-serif"><span style=3D"color:rgb(0,0,0);font-family:arial,sans-se=
rif">&lt;4&gt;[28640.247424@0] set usb port power off (board gpio 25)!</spa=
n><br style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif">&lt;4&gt;[286=
40.252873@0] SRP: Device mode</span><br style=3D"color:rgb(0,0,0);font-fami=
ly:arial,sans-serif"><span style=3D"color:rgb(0,0,0);font-family:arial,sans=
-serif">&lt;6&gt;[28640.267394@0] usb 1-1: USB disconnect, device number 3<=
/span><br>
<div><br></div><div style><br></div></div></div>

--f46d04426bbc07c10304df6cd115--


--===============1735451704==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1735451704==--
