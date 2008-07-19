Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6JNFemp032655
	for <video4linux-list@redhat.com>; Sat, 19 Jul 2008 19:15:40 -0400
Received: from interpont.hu (qmailr@gandalf.interpont.hu [87.229.73.114])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6JNF1lc007895
	for <video4linux-list@redhat.com>; Sat, 19 Jul 2008 19:15:02 -0400
Message-ID: <34984.89.135.34.134.1216509305.squirrel@webmail.interpont.hu>
In-Reply-To: <d9def9db0807191505s300b06cdr94c94e81a3e8d57f@mail.gmail.com>
References: <40552.89.135.34.134.1216498656.squirrel@webmail.interpont.hu>
	<d9def9db0807191505s300b06cdr94c94e81a3e8d57f@mail.gmail.com>
Date: Sun, 20 Jul 2008 01:15:05 +0200 (CEST)
From: interpont@interpont.hu
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8bit
Subject: Re: New em2821 based tv tuner ... how will it work?
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



Hello Markus,



Thanks for the fast reply.



I downloaded & installed the mcentral.de version of the drivers but
the result is the same.... no /dev/video0 device.



Here is the interesting part of my dmesg:



[  110.925688] em28xx v4l2 driver version 0.0.1 loaded

[  110.925760] usbcore: registered new interface driver em28xx

[  118.809228] em28xx new video device (eb1a:2821): interface 0,
class 255

[  118.809237] em28xx: device is attached to a USB 2.0 bus

[  118.809241] em28xx: you're using the experimental/unstable tree
from mcentral.de

[  118.809245] em28xx: there's also a stable tree available but which
is limited to

[  118.809249] em28xx: linux <=2.6.19.2

[  118.809252] em28xx: it's fine to use this driver but keep in mind
that it will move

[  118.809256] em28xx: to http://mcentral.de/hg/~mrec/v4l-dvb-kernel
as soon as it's

[  118.809260] em28xx: proved to be stable

[  118.809265] em28xx #0: Alternate settings: 8

[  118.809269] em28xx #0: Alternate setting 0, max size= 0

[  118.809273] em28xx #0: Alternate setting 1, max size= 1024

[  118.809277] em28xx #0: Alternate setting 2, max size= 1448

[  118.809280] em28xx #0: Alternate setting 3, max size= 2048

[  118.809284] em28xx #0: Alternate setting 4, max size= 2304

[  118.809288] em28xx #0: Alternate setting 5, max size= 2580

[  118.809291] em28xx #0: Alternate setting 6, max size= 2892

[  118.809295] em28xx #0: Alternate setting 7, max size= 3072

[  118.823446] em28xx #0: Your board has no eeprom inside it and thus
can't

[  118.823449] em28xx #0: be autodetected.  Please pass
card=<n> insmod option to

[  118.823451] em28xx #0: workaround that.  Redirect complaints
to the vendor of

[  118.823454] em28xx #0: the TV card. Generic type will be used.

[  118.823456] em28xx #0: Best regards,

[  118.823457] em28xx
#0:         -- tux

[  118.823464] em28xx #0: em28xx #0: Here is a list of valid choices
for the card=<n> insmod option:

[  118.823470] em28xx #0:     card=0 ->
Generic EM2800 video grabber

[  118.823474] em28xx #0:     card=1 ->
Generic EM2820 video grabber

[  118.823478] em28xx #0:     card=2 ->
Generic EM2821 video grabber

[  118.823483] em28xx #0:     card=3 ->
Generic EM2870 video grabber

[  118.823487] em28xx #0:     card=4 ->
Generic EM2881 video grabber

[  118.823492] em28xx #0:     card=5 ->
Generic EM2860 video grabber

[  118.823496] em28xx #0:     card=6 ->
Generic EM2861 video grabber

[  118.823500] em28xx #0:     card=7 ->
Terratec Cinergy 250 USB

[  118.823505] em28xx #0:     card=8 ->
Pinnacle PCTV USB 2

[  118.823509] em28xx #0:     card=9 ->
Hauppauge WinTV USB 2

[  118.823513] em28xx #0:     card=10 -> MSI
VOX USB 2.0

[  118.823517] em28xx #0:     card=11 ->
Terratec Cinergy 200 USB

[  118.823521] em28xx #0:     card=12 ->
Leadtek Winfast USB II

[  118.823525] em28xx #0:     card=13 ->
Kworld USB2800

[  118.823529] em28xx #0:     card=14 ->
Pinnacle Dazzle DVC 90

[  118.823533] em28xx #0:     card=15 ->
Hauppauge WinTV HVR 900

[  118.823537] em28xx #0:     card=16 ->
Terratec Hybrid XS

[  118.823541] em28xx #0:     card=17 ->
Terratec Hybrid XS Secam

[  118.823546] em28xx #0:     card=18 ->
Kworld PVR TV 2800 RF

[  118.823550] em28xx #0:     card=19 ->
Terratec Prodigy XS

[  118.823554] em28xx #0:     card=20 ->
Videology 20K14XUSB USB2.0

[  118.823558] em28xx #0:     card=21 ->
Usbgear VD204v9

[  118.823562] em28xx #0:     card=22 ->
Terratec Cinergy T XS

[  118.823566] em28xx #0:     card=23 ->
Pinnacle PCTV DVB-T

[  118.823570] em28xx #0:     card=24 -> DNT
DA2 Hybrid

[  118.823574] em28xx #0:     card=25 ->
Pinnacle Hybrid Pro

[  118.823578] em28xx #0:     card=26 ->
Hercules Smart TV USB 2.0

[  118.823582] em28xx #0:     card=27 ->
Compro, VideoMate U3

[  118.823586] em28xx #0:     card=28 ->
KWorld DVB-T 310U

[  118.823591] em28xx #0:     card=29 -> SIIG
AVTuner-PVR/Prolink PlayTV USB 2.0

[  118.823595] em28xx #0:     card=30 ->
Terratec Cinergy T XS (MT2060)

[  118.823600] em28xx #0:     card=31 -> MSI
DigiVox A/D

[  118.823604] em28xx #0:     card=32 ->
D-Link DUB-T210 TV Tuner

[  118.823608] em28xx #0:     card=33 ->
Gadmei UTV310

[  118.823612] em28xx #0:     card=34 ->
Kworld 355 U DVB-T

[  118.823616] em28xx #0:     card=35 ->
Supercomp USB 2.0 TV

[  118.823620] em28xx #0:     card=36 ->
Hauppauge WinTV HVR Rev. 1.2

[  118.823624] em28xx #0:     card=37 ->
Gadmei UTV330

[  118.823628] em28xx #0:     card=38 ->
V-Gear PocketTV

[  118.823632] em28xx #0:     card=39 ->
Kworld 350 U DVB-T

[  118.823636] em28xx #0:     card=40 ->
Terratec Hybrid XS (em2882)

[  118.823640] em28xx #0:     card=41 ->
Pinnacle Dazzle DVC 100

[  118.823644] em28xx #0:     card=42 ->
Generic EM2750 video grabber

[  118.823649] em28xx #0:     card=43 ->
Yakumo MovieMixer

[  118.823653] em28xx #0:     card=44 -> Huaqi
DLCW-130

[  118.823657] em28xx #0:     card=45 ->
Generic EM2883 video grabber

[  118.823661] em28xx #0:     card=46 ->
Hauppauge WinTV HVR 950

[  118.823665] em28xx #0:     card=47 ->
Pinnacle PCTV HD Pro

[  118.823669] em28xx #0:     card=48 ->
Pinnacle Hybrid Pro (2)

[  118.823674] em28xx #0:     card=49 ->
Hauppauge WinTV USB 2 (R2)

[  118.823678] em28xx #0:     card=50 ->
NetGMBH Cam

[  118.823682] em28xx #0:     card=51 ->
Leadtek Winfast USB II Deluxe

[  118.823686] em28xx #0:     card=52 -> MSI
DigiVox A/D II

[  118.823690] em28xx #0:     card=53 ->
Typhoon DVD Maker

[  118.823694] em28xx #0:     card=54 ->
Pinnacle PCTV USB 2 (Philips FM1216ME)

[  118.823699] em28xx #0:     card=55 ->
EM2751 Webcam + Audio

[  118.823703] em28xx #0:     card=56 ->
KWorld DVB-T 305U

[  118.823707] em28xx #0:     card=57 ->
KWorld PVRTV 300U

[  118.823711] em28xx #0:     card=58 ->
Kworld PlusTV HD Hybrid 330

[  118.823715] em28xx #0:     card=59 ->
Terratec Cinergy A Hybrid XS

[  118.823719] em28xx #0:     card=60 ->
Plextor ConvertX PX-TV100U

[  118.823723] em28xx #0:     card=61 ->
Kworld VS-DVB-T 323UR

[  118.920891] em28xx #0: found i2c device @ 0x4a [saa7113h]

[  118.925916] em28xx #0: found i2c device @ 0x60 [remote IR
sensor]

[  118.933817] em28xx #0: found i2c device @ 0x86 [tda9887]

[  118.945761] em28xx #0: found i2c device @ 0xc6 [tuner (analog)]

[  118.956264] em28xx #0: Found Generic EM2821 video grabber

[  118.956411] em28xx audio device (eb1a:2821): interface 1, class
1

[  118.956441] em28xx audio device (eb1a:2821): interface 2, class
1





And here is the info that Devin requested:



Right now I cannot take a photo but here is what I see



A Philips silver box :) with these numbers:

3139 147 18291N#

FQ1216ME/I   H-3



On the board there is this code:

STV-3008P REV 2.0



There is a SONIX chip with this number:

SN8P1602BS018

049PAAC2



There is a Philips chip with so small numbers that I cannot read.



There is a small Empia chips with so small numbers that I cannot read.



And there is the bigger Empia chip :

EMP2820

DIM12-011

200506-02



What else do you need?





Greetings,



David

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
