Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2KKFECs017251
	for <video4linux-list@redhat.com>; Fri, 20 Mar 2009 16:15:14 -0400
Received: from mail-gx0-f171.google.com (mail-gx0-f171.google.com
	[209.85.217.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2KKEtCJ007914
	for <video4linux-list@redhat.com>; Fri, 20 Mar 2009 16:14:56 -0400
Received: by gxk19 with SMTP id 19so3311107gxk.3
	for <video4linux-list@redhat.com>; Fri, 20 Mar 2009 13:14:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237579738.26159.16.camel@T60p>
References: <1237575285.26159.2.camel@T60p>
	<412bdbff0903201228t4cb4b6c8m17763c27878434ed@mail.gmail.com>
	<1237578912.26159.13.camel@T60p>
	<412bdbff0903201302ib6758a8ue76a8dd235cfa4cb@mail.gmail.com>
	<1237579738.26159.16.camel@T60p>
Date: Fri, 20 Mar 2009 16:14:54 -0400
Message-ID: <412bdbff0903201314r5105d373ofe6614ee08431d4b@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Mikhail Jiline <misha@epiphan.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	mchehab@infradead.org
Subject: Re: [PATCH] V4L: em28xx: add support for Digitus/Plextor PX-AV200U
	grabbers
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

On Fri, Mar 20, 2009 at 4:08 PM, Mikhail Jiline <misha@epiphan.com> wrote:
>
>>
>> Yeah, something still seems wrong here.  In cases where the device
>> uses one of the Empia generic USB ids, you need to have either an i2c
>> hash entry of an eeprom hash entry.  That's how it knows which device
>> to associate it with in those cases.
>>
>> Did you try this patch?  If so, can you send the full dmesg output
>> after connecting the device?
>
> If I don't force card id via module params, I get the following
>
> [   19.699849] em28xx 1-1.2:1.0: usb_probe_interface
> [   19.699867] em28xx 1-1.2:1.0: usb_probe_interface - got id
> [   19.699883] em28xx new video device (1aeb:2128): interface 0, class 255
> [   19.706528] em28xx Has usb audio class
> [   19.710319] em28xx #0: Alternate settings: 8
> [   19.714604] em28xx #0: Alternate setting 0, max size= 0
> [   19.719826] em28xx #0: Alternate setting 1, max size= 1024
> [   19.725302] em28xx #0: Alternate setting 2, max size= 1448
> [   19.730778] em28xx #0: Alternate setting 3, max size= 2048
> [   19.736255] em28xx #0: Alternate setting 4, max size= 2304
> [   19.741734] em28xx #0: Alternate setting 5, max size= 2580
> [   19.747211] em28xx #0: Alternate setting 6, max size= 2892
> [   19.752688] em28xx #0: Alternate setting 7, max size= 3072
> [   19.758498] em28xx #0: em28xx chip ID = 18
> [   20.357669] saa7115' 0-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
> [   21.109479] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 21 28 90 00 11 03 6a 22 00 00
> [   21.117619] em28xx #0: i2c eeprom 10: 00 00 04 57 06 21 01 00 00 00 00 00 00 00 00 00
> [   21.125767] em28xx #0: i2c eeprom 20: 02 00 01 01 f0 10 00 00 00 00 00 00 5b 00 00 00
> [   21.133870] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 03 01 00 00 00 00
> [   21.141974] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   21.150071] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   21.158184] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
> [   21.166296] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 32 00 31 00 20 00 44 00
> [   21.174487] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
> [   21.182600] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   21.190714] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   21.198826] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   21.206939] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   21.215043] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   21.223139] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   21.231243] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   21.239348] EEPROM ID= 0x1aeb6795, hash = 0x00000000
> [   21.244305] Vendor/Product ID= 1aeb:2128
> [   21.248218] No audio on board.
> [   21.251269] 500mA max power
> [   21.254062] Table at 0x04, strings=0x6a22, 0x0000, 0x0000
> [   21.273860] em28xx #0: found i2c device @ 0x4a [saa7113h]
> [   21.295311] em28xx #0: found i2c device @ 0xa0 [eeprom]
> [   21.318136] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
> [   21.326495] em28xx #0: You may try to use card=<n> insmod option to workaround that.
> [   21.334250] em28xx #0: Please send an email with this log to:
> [   21.339992] em28xx #0:       V4L Mailing List <video4linux-list@redhat.com>
> [   21.346500] em28xx #0: Board eeprom hash is 0x00000000
> [   21.351633] em28xx #0: Board i2c devicelist hash is 0x6ba50080
> [   21.357457] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
> [   21.365354] em28xx #0:     card=0 -> Unknown EM2800 video grabber
> [   21.371435] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
> [   21.377951] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
> [   21.383686] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
> [   21.389094] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
> [   21.394565] em28xx #0:     card=5 -> MSI VOX USB 2.0
> [   21.399524] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
> [   21.405264] em28xx #0:     card=7 -> Leadtek Winfast USB II
> [   21.410824] em28xx #0:     card=8 -> Kworld USB2800
> [   21.415689] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/DVC 100
> [   21.421945] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
> [   21.427681] em28xx #0:     card=11 -> Terratec Hybrid XS
> [   21.432977] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
> [   21.438534] em28xx #0:     card=13 -> Terratec Prodigy XS
> [   21.443925] em28xx #0:     card=14 -> Pixelview Prolink PlayTV USB 2.0
> [   21.450440] em28xx #0:     card=15 -> V-Gear PocketTV
> [   21.455485] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
> [   21.461222] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
> [   21.467218] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
> [   21.473388] em28xx #0:     card=19 -> PointNix Intra-Oral Camera
> [   21.479383] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
> [   21.485407] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
> [   21.493130] em28xx #0:     card=22 -> Unknown EM2750/EM2751 webcam grabber
> [   21.499989] em28xx #0:     card=23 -> Huaqi DLCW-130
> [   21.504940] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
> [   21.510764] em28xx #0:     card=25 -> Gadmei UTV310
> [   21.515636] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
> [   21.521548] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
> [   21.528580] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
> [   21.534835] em28xx #0:     card=29 -> Pinnacle Dazzle DVC 100
> [   21.540572] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
> [   21.546569] em28xx #0:     card=31 -> Usbgear VD204v9
> [   21.551613] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
> [   21.557083] em28xx #0:     card=33 -> SIIG AVTuner-PVR/Prolink PlayTV USB 2.0
> [   21.564202] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
> [   21.570371] em28xx #0:     card=35 -> Typhoon DVD Maker
> [   21.575589] em28xx #0:     card=36 -> NetGMBH Cam
> [   21.580280] em28xx #0:     card=37 -> Gadmei UTV330
> [   21.585145] em28xx #0:     card=38 -> Yakumo MovieMixer
> [   21.590547] em28xx #0:     card=39 -> KWorld PVRTV 300U
> [   21.595763] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
> [   21.601760] em28xx #0:     card=41 -> Kworld 350 U DVB-T
> [   21.607064] em28xx #0:     card=42 -> Kworld 355 U DVB-T
> [   21.612361] em28xx #0:     card=43 -> Terratec Cinergy T XS
> [   21.617926] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
> [   21.624267] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
> [   21.629650] em28xx #0:     card=46 -> Compro, VideoMate U3
> [   21.635128] em28xx #0:     card=47 -> KWorld DVB-T 305U
> [   21.640346] em28xx #0:     card=48 -> KWorld DVB-T 310U
> [   21.645566] em28xx #0:     card=49 -> MSI DigiVox A/D
> [   21.650611] em28xx #0:     card=50 -> MSI DigiVox A/D II
> [   21.655915] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
> [   21.661740] em28xx #0:     card=52 -> DNT DA2 Hybrid
> [   21.666698] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
> [   21.672089] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
> [   21.677654] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
> [   21.683736] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
> [   21.689655] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
> [   21.695737] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
> [   21.702079] em28xx #0:     card=59 -> Plextor PX-AV200U
> [   22.277385] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
> [   22.284272] em28xx #0: Found Unknown EM2750/28xx video grabber
>
>
>

Ok, here's the problem.  Yeah, please do not submit profiles that
require a card= specification.  Instead, please resubmit your patch
including an entry in the em28xx_i2c_hash[] table that includes your
device.  It probably needs to look something like the following:

{0x6ba50080, EM2820_BOARD_PLEXTOR_PX_AV200U, TUNER_LG_PAL_NEW_TAPC},

I am curious though why your eeprom hash is blank even though it
successfully dumped out the eeprom.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
