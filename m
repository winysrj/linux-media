Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB36rwhV021216
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 01:53:58 -0500
Received: from web24301.mail.ird.yahoo.com (web24301.mail.ird.yahoo.com
	[87.248.114.198])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB36rfdl005141
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 01:53:42 -0500
Date: Wed, 3 Dec 2008 06:53:41 +0000 (GMT)
From: Santiago Ruiz <non_praevalebunt@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <457159.60670.qm@web24301.mail.ird.yahoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: problems with Pinnacle 320e in debian lenny with 2.6.26-1 kernel
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi, i'm new in list. I 'll try not to break anything... :)=C2=A0 =0A=0A[war=
ning: poor english]=0A=0ARunning Debian lenny with 2.6.26-1 kernel with a P=
innacle Dazzle PCTV Hybrid Pro Stick (320e)=0A=0A[warning: linux newbie]=0A=
=0A[=C2=A0=C2=A0 15.040528] em28xx #0: Your board has no unique USB ID and =
thus need a hint to be detected.=0A[=C2=A0=C2=A0 15.040634] em28xx #0: You =
may try to use card=3D<n> insmod option to workaround that.=0A[=C2=A0=C2=A0=
 15.040746] em28xx #0: Please send an email with this log to:=0A[=C2=A0=C2=
=A0 15.040824] em28xx #0: =C2=A0=C2=A0=C2=A0 V4L Mailing List video4linux-l=
ist@redhat.com=0A=0Aas you ask, here is the full em28xx log=0A=0A[=C2=A0=C2=
=A0 14.899094] Linux video capture interface: v2.00=0A[=C2=A0=C2=A0 14.9622=
53] em28xx v4l2 driver version 0.1.0 loaded=0A[=C2=A0=C2=A0 14.962283] em28=
xx new video device (eb1a:2881): interface 0, class 255=0A[=C2=A0=C2=A0 14.=
962351] em28xx Has usb audio class=0A[=C2=A0=C2=A0 14.962353] em28xx #0: Al=
ternate settings: 8=0A[=C2=A0=C2=A0 14.962356] em28xx #0: Alternate setting=
 0, max size=3D 0=0A[=C2=A0=C2=A0 14.962358] em28xx #0: Alternate setting 1=
, max size=3D 0=0A[=C2=A0=C2=A0 14.962361] em28xx #0: Alternate setting 2, =
max size=3D 1448=0A[=C2=A0=C2=A0 14.962363] em28xx #0: Alternate setting 3,=
 max size=3D 2048=0A[=C2=A0=C2=A0 14.962366] em28xx #0: Alternate setting 4=
, max size=3D 2304=0A[=C2=A0=C2=A0 14.962368] em28xx #0: Alternate setting =
5, max size=3D 2580=0A[=C2=A0=C2=A0 14.962371] em28xx #0: Alternate setting=
 6, max size=3D 2892=0A[=C2=A0=C2=A0 14.962376] em28xx #0: Alternate settin=
g 7, max size=3D 3072=0A[=C2=A0=C2=A0 14.962550] em28xx #0: chip ID is em28=
82/em2883=0A[=C2=A0=C2=A0 14.991782] em28xx #0: i2c eeprom 00: 1a eb 67 95 =
1a eb 81 28 58 12 5c 00 6a 20 6a 00=0A[=C2=A0=C2=A0 14.991797] em28xx #0: i=
2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 00 00 02 02 00 00=0A[=C2=A0=C2=
=A0 14.991806] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 02 00 b8 00 00 0=
0 5b 1e 00 00=0A[=C2=A0=C2=A0 14.991819] em28xx #0: i2c eeprom 30: 00 00 20=
 40 20 80 02 20 10 02 00 00 00 00 00 00=0A[=C2=A0=C2=A0 14.991828] em28xx #=
0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=0A[=C2=A0=
=C2=A0 14.991840] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00=0A[=C2=A0=C2=A0 14.991848] em28xx #0: i2c eeprom 60: 00 00=
 00 00 00 00 00 00 00 00 20 03 55 00 53 00=0A[=C2=A0=C2=A0 14.991857] em28x=
x #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 56 00=0A[=C2=
=A0=C2=A0 14.991868] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 0=
0 00 00 00 00 00 00=0A[=C2=A0=C2=A0 14.991877] em28xx #0: i2c eeprom 90: 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=0A[=C2=A0=C2=A0 14.991885] em=
28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=0A[=
=C2=A0=C2=A0 14.991897] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00 00 00=0A[=C2=A0=C2=A0 14.991905] em28xx #0: i2c eeprom c0:=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=0A[=C2=A0=C2=A0 14.991918]=
 em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
=0A[=C2=A0=C2=A0 14.991927] em28xx #0: i2c eeprom e0: 5a 00 55 aa 79 55 54 =
03 00 17 98 01 00 00 00 00=0A[=C2=A0=C2=A0 14.991935] em28xx #0: i2c eeprom=
 f0: 0c 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00=0A[=C2=A0=C2=A0 14.991=
950] EEPROM ID=3D 0x9567eb1a, hash =3D 0xb8846b20=0A[=C2=A0=C2=A0 14.991952=
] Vendor/Product ID=3D eb1a:2881=0A[=C2=A0=C2=A0 14.991954] AC97 audio (5 s=
ample rates)=0A[=C2=A0=C2=A0 14.991956] USB Remote wakeup capable=0A[=C2=A0=
=C2=A0 14.991957] 500mA max power=0A[=C2=A0=C2=A0 14.991959] Table at 0x04,=
 strings=3D0x206a, 0x006a, 0x0000=0A[=C2=A0=C2=A0 15.022756] em28xx #0: fou=
nd i2c device @ 0xa0 [eeprom]=0A[=C2=A0=C2=A0 15.027088] em28xx #0: found i=
2c device @ 0xb8 [tvp5150a]=0A[=C2=A0=C2=A0 15.029126] em28xx #0: found i2c=
 device @ 0xc2 [tuner (analog)]=0A[=C2=A0=C2=A0 15.040528] em28xx #0: Your =
board has no unique USB ID and thus need a hint to be detected.=0A[=C2=A0=
=C2=A0 15.040634] em28xx #0: You may try to use card=3D<n> insmod option to=
 workaround that.=0A[=C2=A0=C2=A0 15.040746] em28xx #0: Please send an emai=
l with this log to:=0A[=C2=A0=C2=A0 15.040824] em28xx #0: =C2=A0=C2=A0=C2=
=A0 V4L Mailing List <video4linux-list@redhat.com>=0A[=C2=A0=C2=A0 15.04090=
4] em28xx #0: Board eeprom hash is 0xb8846b20=0A[=C2=A0=C2=A0 15.040982] em=
28xx #0: Board i2c devicelist hash is 0x27e10080=0A[=C2=A0=C2=A0 15.041061]=
 em28xx #0: Here is a list of valid choices for the card=3D<n> insmod optio=
n:=0A[=C2=A0=C2=A0 15.041166] em28xx #0:=C2=A0=C2=A0=C2=A0=C2=A0 card=3D0 -=
> Unknown EM2800 video grabber=0A[=C2=A0=C2=A0 15.041245] em28xx #0:=C2=A0=
=C2=A0=C2=A0=C2=A0 card=3D1 -> Unknown EM2750/28xx video grabber=0A[=C2=A0=
=C2=A0 15.041326] em28xx #0:=C2=A0=C2=A0=C2=A0=C2=A0 card=3D2 -> Terratec C=
inergy 250 USB=0A[=C2=A0=C2=A0 15.041405] em28xx #0:=C2=A0=C2=A0=C2=A0=C2=
=A0 card=3D3 -> Pinnacle PCTV USB 2=0A[=C2=A0=C2=A0 15.041483] em28xx #0:=
=C2=A0=C2=A0=C2=A0=C2=A0 card=3D4 -> Hauppauge WinTV USB 2=0A[=C2=A0=C2=A0 =
15.041560] em28xx #0:=C2=A0=C2=A0=C2=A0=C2=A0 card=3D5 -> MSI VOX USB 2.0=
=0A[=C2=A0=C2=A0 15.041637] em28xx #0:=C2=A0=C2=A0=C2=A0=C2=A0 card=3D6 -> =
Terratec Cinergy 200 USB=0A[=C2=A0=C2=A0 15.041717] em28xx #0:=C2=A0=C2=A0=
=C2=A0=C2=A0 card=3D7 -> Leadtek Winfast USB II=0A[=C2=A0=C2=A0 15.041793] =
em28xx #0:=C2=A0=C2=A0=C2=A0=C2=A0 card=3D8 -> Kworld USB2800=0A[=C2=A0=C2=
=A0 15.041869] em28xx #0:=C2=A0=C2=A0=C2=A0=C2=A0 card=3D9 -> Pinnacle Dazz=
le DVC 90/DVC 100=0A[=C2=A0=C2=A0 15.041947] em28xx #0:=C2=A0=C2=A0=C2=A0=
=C2=A0 card=3D10 -> Hauppauge WinTV HVR 900=0A[=C2=A0=C2=A0 15.042027] em28=
xx #0:=C2=A0=C2=A0=C2=A0=C2=A0 card=3D11 -> Terratec Hybrid XS=0A[=C2=A0=C2=
=A0 15.042105] em28xx #0:=C2=A0=C2=A0=C2=A0=C2=A0 card=3D12 -> Kworld PVR T=
V 2800 RF=0A[=C2=A0=C2=A0 15.042183] em28xx #0:=C2=A0=C2=A0=C2=A0=C2=A0 car=
d=3D13 -> Terratec Prodigy XS=0A[=C2=A0=C2=A0 15.042262] em28xx #0:=C2=A0=
=C2=A0=C2=A0=C2=A0 card=3D14 -> Pixelview Prolink PlayTV USB 2.0=0A[=C2=A0=
=C2=A0 15.042342] em28xx #0:=C2=A0=C2=A0=C2=A0=C2=A0 card=3D15 -> V-Gear Po=
cketTV=0A[=C2=A0=C2=A0 15.042420] em28xx #0:=C2=A0=C2=A0=C2=A0=C2=A0 card=
=3D16 -> Hauppauge WinTV HVR 950=0A=0AI've tried to install the firmware bu=
t the problem persist. Please tell me if I need to remove the firmware file=
s=0Acd /lib/firmware=0Awget http://konstantin.filtschew.de/v4l-firmware/fir=
mware_v3.tgz=0Atar xvzf firmware_v3.tgz=0A=0AI know now that there are two =
drivers. I prefer, if possible,=C2=A0to use yours, but i thougth firmware c=
ould be needed anyway=0A=0AI need your help. I can't execute windows. If th=
is card does not run on my linux laptop it will be donated=0A=0AThanks in a=
dvance=0A=0A=0A      
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
