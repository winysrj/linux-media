Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate02.web.de ([217.72.192.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Christoph.Honermann@web.de>) id 1JjKo5-0000cS-MV
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 22:52:42 +0200
Message-ID: <47FBDAF7.9080309@web.de>
Date: Tue, 08 Apr 2008 22:52:07 +0200
From: Christoph Honermann <Christoph.Honermann@web.de>
MIME-Version: 1.0
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
References: <1206652564.6924.22.camel@ubuntu> <47EC1668.5000608@t-online.de>
	<47FA70C3.5040808@web.de> <47FA875F.1060404@t-online.de>
In-Reply-To: <47FA875F.1060404@t-online.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134: fixed pointer in tuner callback
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1123032035=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1123032035==
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content=3D"text/html;charset=3DUTF-8" http-equiv=3D"Content-Type"=
>
  <title></title>
</head>
<body bgcolor=3D"#ffffff" text=3D"#000000">
Hi Hartmut=EF=BF=BD<br>
<br>
Hartmut Hackmann schrieb:
<blockquote cite=3D"mid:47FA875F.1060404@t-online.de" type=3D"cite">HI, <=
br>
  <br>
Christoph Honermann schrieb: <br>
  <blockquote type=3D"cite">Hi, Hartmund <br>
    <br>
    <br>
Hartmut Hackmann schrieb: <br>
    <blockquote type=3D"cite">Hi, Christoph <br>
      <br>
Christoph Honermann schrieb: <br>
=C2=A0
      <blockquote type=3D"cite">Hi, Hartmund <br>
        <br>
I have tested the following archives with my MD8800 und the DVB-S Card.
        <br>
        <br>
v4l-dvb-912856e2a0ce.tar.bz2 --&gt; The DVB-S Input 1 works. <br>
The module of the following archives are loaded with the option <br>
"use_frontend=3D1,1" at the Shell or automatically: <br>
=C2=A0=C2=A0=C2=A0 /etc/modprobe.d/saa7134-dvb=C2=A0=C2=A0 with the follo=
wing line <br>
=C2=A0=C2=A0 "options saa7134-dvb use_frontend=3D1,1" <br>
v4l-dvb-1e295a94038e.tar.bz2; <br>
        <br>
=C2=A0=C2=A0=C2=A0 FATAL: Error inserting saa7134_dvb <br>
=C2=A0=C2=A0=C2=A0
(/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/saa7134/saa713=
4-dvb.ko):
        <br>
=C2=A0=C2=A0=C2=A0 Unknown symbol in module, or unknown parameter (see dm=
esg) <br>
        <br>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: disagrees about version of symbol saa7134=
_ts_register <br>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: Unknown symbol saa7134_ts_register <br>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: Unknown symbol videobuf_queue_sg_init <br=
>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: disagrees about version of symbol saa7134=
_set_gpio <br>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: Unknown symbol saa7134_set_gpio <br>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: disagrees about version of symbol
saa7134_i2c_call_client <br>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: Unknown symbol saa7134_i2c_call_clients <=
br>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: disagrees about version of symbol
saa7134_ts_unregister <br>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: Unknown symbol saa7134_ts_unregister <br>
        <br>
        <br>
v4l-dvb-f98d28c21389.tar.bz2=C2=A0 and v4l-dvb-a06ac2bdeb3c.tar.bz2 --&gt=
; <br>
        <br>
=C2=A0=C2=A0=C2=A0 FATAL: Error inserting saa7134_dvb <br>
=C2=A0=C2=A0=C2=A0
(/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/saa7134/saa713=
4-dvb.ko):
        <br>
=C2=A0=C2=A0=C2=A0 Unknown symbol in module, or unknown parameter (see dm=
esg) <br>
        <br>
=C2=A0=C2=A0=C2=A0 dmesg | grep saa7134 <br>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: Unknown symbol saa7134_tuner_callback <br=
>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: disagrees about version of symbol saa7134=
_ts_register <br>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: Unknown symbol saa7134_ts_register <br>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: Unknown symbol videobuf_queue_sg_init <br=
>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: disagrees about version of symbol saa7134=
_set_gpio <br>
=C2=A0=C2=A0=C2=A0 saa7134_dvb: Unknown symbol saa7134_set_gpio <br>
        <br>
The Hardware ist working with Windows XP with both Input channels. <br>
        <br>
=C2=A0=C2=A0=C2=A0 </blockquote>
This occurs when you mix modules of different driver versions. You need
to <br>
replace all modules of the v4l-dvb subsystem. <br>
So after you compiled and installed with <br>
=C2=A0 make; make install <br>
you need to unload all modules of the subsystem either with <br>
=C2=A0 make rmmod <br>
or reboot. <br>
Afterwards, you can unload and reload a single module as you tried to
do. <br>
      <br>
Hartmut <br>
      <br>
=C2=A0 </blockquote>
the second DVB-S Channel is working. <br>
But there is one thing that makes Problems. <br>
I have the effect that the devices /dev/dvb/adapter0/dvr0 and
/dev/dvb/adapter1/dvr0 are missed from kaffeine. Therefore it wont work
(no TV-picture, no sound, no channel scanning). <br>
If i look with Nautilus (file manager) therefore the whole Section
/dev/dvb is switching off. <br>
Can that be an effect of the module? <br>
The Problem is sometimes not there but i don't find the reason
(changing the Modules, reboots, ..). If I solve the Problem, should I
test the kombination between DVB-S and DVB-T? <br>
    <br>
Best regards <br>
Christoph <br>
    <br>
    <br>
  </blockquote>
The device files in /dev/dvb are created by the dvb subsystem after
successful <br>
initialization. So if module loading fails as you describe above, you
won't have <br>
the devices. <br>
Your problem still is the mismatching module versions. <br>
Could it be that you have the saa7134.ko module twice in the
/lib/modules tree? <br>
You need to use the new versions of the modules. *Don't* try to mix
them. <br>
  <br>
Best Regards <br>
=C2=A0 Hartmut <br>
</blockquote>
I have checkt the devices. If I unload the Module they are not avible.<br=
>
The modules are once in the tree and the devices are switching on and
off bye<br>
looking with the File Manager. I can send you an probe of the messages
from<br>
the Programm kaffeine with an interesting follow of reaction:<br>
<br>
@kaffeine<br>
kbuildsycoca running...<br>
0<br>
/dev/dvb/adapter0/frontend0 : opened ( Philips TDA10086 DVB-S )<br>
/dev/dvb/0/frontend1 : : No such file or directory<br>
Loaded epg data : 9904 events (141 msecs)<br>
kio (KIOConnection): ERROR: Could not write data<br>
eltern@ubuntu:~$ Tuning to: arte / autocount: 0<br>
DvbCam::probe(): /dev/dvb/adapter0/ca0: : No such file or directory<br>
Using DVB device 0:0 "Philips TDA10086 DVB-S"<br>
tuning DVB-S to 10743000 h 22000000<br>
inv:2 fecH:5<br>
DiSEqC: switch pos 0, 18V, loband (index 1)<br>
DiSEqC: e0 10 38 f2 00 00<br>
...............<br>
<br>
Not able to lock to the signal on the given frequency<br>
Frontend closed<br>
Tuning delay: 3637 ms<br>
Tuning to: 3sat / autocount: 0<br>
Using DVB device 0:0 "Philips TDA10086 DVB-S"<br>
tuning DVB-S to 11953000 h 27500000<br>
inv:2 fecH:3<br>
DiSEqC: switch pos 0, 18V, hiband (index 3)<br>
DiSEqC: e0 10 38 f3 00 00<br>
. LOCKED.<br>
<b>DVR DEVICE: : No such device</b><br>
Frontend closed<br>
Tuning delay: 976 ms<br>
eltern@ubuntu:~$ <br>
<br>
It is the original text from the console.<br>
You can see that the DVB DEVICE is at once missing.<br>
I have no idea why that happens. And that seem to be the cause of the
Problem.<br>
To be sure for the new module i have once more build them
(v4l-dvb-a06ac2bdeb3c.tar.bz2). <br>
- make all<br>
- make rmmod<br>
- make install<br>
- rmmod saa7134-dvb<br>
- modprobe saa7134-dvb use_frontend=3D1,1<br>
<br>
<br>
For your information in addition a copy from dmesg:<br>
[=C2=A0 720.868119] DVB: registering new adapter (saa7133[1])<br>
[=C2=A0 720.868129] DVB: registering frontend 0 (Philips TDA10086 DVB-S).=
..<br>
[=C2=A0 731.320958] saa7133[0]/dvb: frontend initialization failed<br>
[=C2=A0 731.368002] DVB: registering new adapter (saa7133[1])<br>
[=C2=A0 731.368149] DVB: registering frontend 0 (Philips TDA10086 DVB-S).=
..<br>
[=C2=A0 741.833698] saa7133[0]/dvb: frontend initialization failed<br>
[=C2=A0 741.886609] DVB: registering new adapter (saa7133[1])<br>
[=C2=A0 741.886766] DVB: registering frontend 0 (Philips TDA10086 DVB-S).=
..<br>
[=C2=A0 752.433333] DVB: registering new adapter (saa7133[0])<br>
[=C2=A0 752.433343] DVB: registering frontend 0 (Philips TDA10086 DVB-S).=
..<br>
[=C2=A0 752.521148] DVB: registering new adapter (saa7133[1])<br>
[=C2=A0 752.521158] DVB: registering frontend 1 (Philips TDA10086 DVB-S).=
..<br>
[=C2=A0 762.946368] saa7133[0]/dvb: frontend initialization failed<br>
[=C2=A0 762.983815] saa7133[1]/dvb: dvb_init: Medion Quadro, no tda826x
found !<br>
[=C2=A0 762.984121] DVB: registering new adapter (saa7133[1])<br>
[=C2=A0 762.984306] DVB: registering frontend 0 (Philips TDA10086 DVB-S).=
..<br>
[=C2=A0 773.392403] saa7133[0]/dvb: frontend initialization failed<br>
[=C2=A0 773.422954] DVB: registering new adapter (saa7133[1])<br>
[=C2=A0 773.423163] DVB: registering frontend 0 (Philips TDA10086 DVB-S).=
..<br>
[=C2=A0 783.857495] saa7133[0]/dvb: frontend initialization failed<br>
<br>
and so on ....<br>
<br>
Best regards<br>
Christoph<br>
<br>
</body>
</html>


--===============1123032035==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1123032035==--
