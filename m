Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:35024 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbZFMMgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Jun 2009 08:36:49 -0400
Received: by bwz9 with SMTP id 9so2531970bwz.37
        for <linux-media@vger.kernel.org>; Sat, 13 Jun 2009 05:36:50 -0700 (PDT)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <c68f135e0906130502l42476a1ctd4cd7710d461199e@mail.gmail.com>
References: <c68f135e0906130502l42476a1ctd4cd7710d461199e@mail.gmail.com>
Date: Sat, 13 Jun 2009 14:30:29 +0200
Message-ID: <c68f135e0906130530g68b42491sf453ca7c846b8ab8@mail.gmail.com>
Subject: Re: Em28xx Log as requested
From: Andrea Merello <andrea.merello@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I got it work only one time, and I cannot reproduce it anymore. I
loaded forcing card=7

When worked it could find the philips video decoder IC. Other times,
when it does not work, it does not claim to find that IC (see previous
mail with log)

Maybe you are interested in the log..
It worked by setting input 1 (the second starting by 0) as video composite.
I suppose input 0 is the svideo

Andrea

 9600.380769] em28xx: New device @ 480 Mbps (eb1a:2800, interface 0,
class 0)
[ 9600.380773] em28xx #0: Identified as Leadtek Winfast USB II
(card=7)
[ 9600.380854] em28xx #0: em28xx chip ID = 7
[ 9600.532233] em28xx #0: board has no eeprom
[ 9601.276363] saa7115 2-0025: saa7113 found (1f7113d0e100000) @ 0x4a
(em28xx #0)
[ 9602.872361] em28xx #0: Config register raw data: 0x45
[ 9602.872365] em28xx #0: No AC97 audio processor
[ 9603.044235] em28xx #0: v4l2 driver version 0.1.2
[ 9603.336200] em28xx #0: V4L2 device registered as /dev/video1 and
/dev/vbi1

On Sat, Jun 13, 2009 at 2:02 PM, Andrea Merello<andrea.merello@gmail.com> wrote:
> As requested in the log, I send it to the ML.
>
> The usb card is a "Xpert DVD Maker usb 2.0" VS-USB2800D
>
> I am not able to get proper video from it yet..
>
> Andrea
>
>
>  8282.776728] em28xx: New device @ 480 Mbps (eb1a:2800, interface 0,
> class 0)
> [ 8282.776732] em28xx #0: Identified as Unknown EM2800 video grabber
> (card=0)
> [ 8282.776806] em28xx #0: em28xx chip ID = 7
> [ 8283.072027] em28xx #0: board has no eeprom
> [ 8292.296541] em28xx #0: Your board has no unique USB ID and thus
> need a hint to be detected.
> [ 8292.296547] em28xx #0: You may try to use card=<n> insmod option to
> workaround that.
> [ 8292.296550] em28xx #0: Please send an email with this log to:
> [ 8292.296552] em28xx #0:       V4L Mailing List
> <linux-media@vger.kernel.org>
> [ 8292.296555] em28xx #0: Board eeprom hash is 0x00000000
> [ 8292.296557] em28xx #0: Board i2c devicelist hash is 0x1b800080
> [ 8292.296560] em28xx #0: Here is a list of valid choices for the
> card=<n> insmod option:
> [ 8292.296563] em28xx #0:     card=0 -> Unknown EM2800 video grabber
> [ 8292.296566] em28xx #0:     card=1 -> Unknown EM2750/28xx video
> grabber
> [ 8292.296569] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
> [ 8292.296572] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
> [ 8292.296575] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
> [ 8292.296577] em28xx #0:     card=5 -> MSI VOX USB 2.0
> [ 8292.296580] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
> [ 8292.296583] em28xx #0:     card=7 -> Leadtek Winfast USB II
> [ 8292.296586] em28xx #0:     card=8 -> Kworld USB2800
> [ 8292.296588] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
> 90/100/101/107 / Kaiser Baas Video to DVD maker
> [ 8292.296592] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
> [ 8292.296595] em28xx #0:     card=11 -> Terratec Hybrid XS
> [ 8292.296597] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
> [ 8292.296600] em28xx #0:     card=13 -> Terratec Prodigy XS
> [ 8292.296603] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
> Prolink PlayTV USB 2.0
> [ 8292.296606] em28xx #0:     card=15 -> V-Gear PocketTV
> [ 8292.296609] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
> [ 8292.296611] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
> [ 8292.296614] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
> [ 8292.296617] em28xx #0:     card=19 -> PointNix Intra-Oral Camera
> [ 8292.296620] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
> [ 8292.296623] em28xx #0:     card=21 -> eMPIA Technology, Inc.
> GrabBeeX+ Video Encoder
> [ 8292.296626] em28xx #0:     card=22 -> Unknown EM2750/EM2751 webcam grabber
> [ 8292.296629] em28xx #0:     card=23 -> Huaqi DLCW-130
> [ 8292.296631] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
> [ 8292.296634] em28xx #0:     card=25 -> Gadmei UTV310
> [ 8292.296637] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
> [ 8292.296640] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
> [ 8292.296643] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
> [ 8292.296646] em28xx #0:     card=29 -> <NULL>
> [ 8292.296648] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
> [ 8292.296651] em28xx #0:     card=31 -> Usbgear VD204v9
> [ 8292.296654] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
> [ 8292.296656] em28xx #0:     card=33 -> <NULL>
> [ 8292.296659] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
> [ 8292.296662] em28xx #0:     card=35 -> Typhoon DVD Maker
> [ 8292.296664] em28xx #0:     card=36 -> NetGMBH Cam
> [ 8292.296667] em28xx #0:     card=37 -> Gadmei UTV330
> [ 8292.296669] em28xx #0:     card=38 -> Yakumo MovieMixer
> [ 8292.296672] em28xx #0:     card=39 -> KWorld PVRTV 300U
> [ 8292.296675] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
> [ 8292.296678] em28xx #0:     card=41 -> Kworld 350 U DVB-T
> [ 8292.296680] em28xx #0:     card=42 -> Kworld 355 U DVB-T
> [ 8292.296683] em28xx #0:     card=43 -> Terratec Cinergy T XS
> [ 8292.296686] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
> [ 8292.296689] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
> [ 8292.296696] em28xx #0:     card=46 -> Compro, VideoMate U3
> [ 8292.296698] em28xx #0:     card=47 -> KWorld DVB-T 305U
> [ 8292.296700] em28xx #0:     card=48 -> KWorld DVB-T 310U
> [ 8292.296701] em28xx #0:     card=49 -> MSI DigiVox A/D
> [ 8292.296703] em28xx #0:     card=50 -> MSI DigiVox A/D II
> [ 8292.296704] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
> [ 8292.296706] em28xx #0:     card=52 -> DNT DA2 Hybrid
> [ 8292.296707] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
> [ 8292.296709] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
> [ 8292.296711] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
> [ 8292.296712] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
> [ 8292.296714] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
> [ 8292.296716] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
> [ 8292.296717] em28xx #0:     card=59 -> <NULL>
> [ 8292.296719] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
> [ 8292.296720] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
> [ 8292.296722] em28xx #0:     card=62 -> Gadmei TVR200
> [ 8292.296724] em28xx #0:     card=63 -> Kaiomy TVnPC U2
> [ 8292.296725] em28xx #0:     card=64 -> Easy Cap Capture DC-60
> [ 8292.296727] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
> [ 8292.584197] em28xx #0: Config register raw data: 0x4d
> [ 8292.584199] em28xx #0: No AC97 audio processor
> [ 8292.648033] em28xx #0: v4l2 driver version 0.1.2
> [ 8292.940185] em28xx #0: V4L2 device registered as /dev/video1 and /dev/vbi1
>
