Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m84JTXaP021017
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 15:29:33 -0400
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.236])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m84JTTTK030310
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 15:29:29 -0400
Received: by wx-out-0506.google.com with SMTP id i27so27774wxd.6
	for <video4linux-list@redhat.com>; Thu, 04 Sep 2008 12:29:29 -0700 (PDT)
Message-ID: <d9def9db0809041229q407634a6x83b962ea0db0fc54@mail.gmail.com>
Date: Thu, 4 Sep 2008 21:29:29 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Romain Aviolat" <r.aviolat@gmail.com>, em28xx@mcentral.de
In-Reply-To: <f646a2190809041223t7c09302fr5ad7107eeb9d9fe1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f646a2190809041223t7c09302fr5ad7107eeb9d9fe1@mail.gmail.com>
Cc: cavedon@sssup.it, video4linux-list@redhat.com
Subject: Re: em28xx and Pinnacle pctv USB on 2.6.27-2-generic
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

On Thu, Sep 4, 2008 at 9:23 PM, Romain Aviolat <r.aviolat@gmail.com> wrote:
> Hello, I've got a problem with my DVB-T USB stick Pinnacle PCTV. I'm runing
> 2.6.27-2-generic ubuntu kernel.
>
> Thanks
>
> [  216.208164] usb 7-4: new high speed USB device using ehci_hcd and address
> 4
> [  216.345148] usb 7-4: configuration #1 chosen from 1 choice
> [  216.497269] Linux video capture interface: v2.00
> [  216.516215] em28xx v4l2 driver version 0.1.0 loaded
> [  216.516270] em28xx new video device (eb1a:2870): interface 0, class 255
> [  216.516280] em28xx Doesn't have usb audio class
> [  216.516283] em28xx #0: Alternate settings: 8
> [  216.516286] em28xx #0: Alternate setting 0, max size= 0
> [  216.516291] em28xx #0: Alternate setting 1, max size= 0
> [  216.516294] em28xx #0: Alternate setting 2, max size= 1448
> [  216.516298] em28xx #0: Alternate setting 3, max size= 2048
> [  216.516301] em28xx #0: Alternate setting 4, max size= 2304
> [  216.516306] em28xx #0: Alternate setting 5, max size= 2580
> [  216.516309] em28xx #0: Alternate setting 6, max size= 2892
> [  216.516313] em28xx #0: Alternate setting 7, max size= 3072
> [  216.516514] em28xx #0: em28xx chip ID = 35
> [  216.785315] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12 81 00
> 6a 22 00 00
> [  216.785349] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00 00 00
> 00 00 00 00
> [  216.785375] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00 00 00
> 5b 00 00 00
> [  216.785399] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00
> 67 27 9c 49
> [  216.785424] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  216.785448] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  216.785472] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03
> 55 00 53 00
> [  216.785496] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 30 00
> 20 00 44 00
> [  216.785521] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00
> 00 00 00 00
> [  216.785545] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  216.785569] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  216.785593] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  216.785617] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  216.785641] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  216.785665] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  216.785689] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  216.785716] EEPROM ID= 0x9567eb1a, hash = 0x4b4626c0
> [  216.785721] Vendor/Product ID= eb1a:2870
> [  216.785724] No audio on board.
> [  216.785728] 500mA max power
> [  216.785733] Table at 0x04, strings=0x226a, 0x0000, 0x0000
> [  216.816132] em28xx #0: found i2c device @ 0xa0 [eeprom]
> [  216.822129] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
> [  216.835162] em28xx #0: Your board has no unique USB ID and thus need a
> hint to be detected.
> [  216.835177] em28xx #0: You may try to use card=<n> insmod option to
> workaround that.
> [  216.835183] em28xx #0: Please send an email with this log to:
> [  216.835188] em28xx #0:     V4L Mailing List <video4linux-list@redhat.com>
> [  216.835193] em28xx #0: Board eeprom hash is 0x4b4626c0
> [  216.835197] em28xx #0: Board i2c devicelist hash is 0x4b800080
> [  216.835202] em28xx #0: Here is a list of valid choices for the card=<n>
> insmod option:
> [  216.835209] em28xx #0:     card=0 -> Unknown EM2800 video grabber
> [  216.835214] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
> [  216.835222] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
> [  216.835226] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
> [  216.835231] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
> [  216.835236] em28xx #0:     card=5 -> MSI VOX USB 2.0
> [  216.835241] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
> [  216.835246] em28xx #0:     card=7 -> Leadtek Winfast USB II
> [  216.835251] em28xx #0:     card=8 -> Kworld USB2800
> [  216.835256] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/DVC 100
> [  216.835261] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
> [  216.835266] em28xx #0:     card=11 -> Terratec Hybrid XS
> [  216.835273] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
> [  216.835278] em28xx #0:     card=13 -> Terratec Prodigy XS
> [  216.835283] em28xx #0:     card=14 -> Pixelview Prolink PlayTV USB 2.0
> [  216.835288] em28xx #0:     card=15 -> V-Gear PocketTV
> [  216.835293] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
> [  216.835299] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
> [  216.835304] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
> [  216.835309] em28xx #0:     card=19 -> PointNix Intra-Oral Camera
> [  216.835316] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
> [  216.835321] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+
> Video Encoder
> [  216.835327] em28xx #0:     card=22 -> Unknown EM2750/EM2751 webcam
> grabber
> [  216.835332] em28xx #0:     card=23 -> Huaqi DLCW-130
> [  216.835338] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
> [  216.835343] em28xx #0:     card=25 -> Gadmei UTV310
> [  216.835348] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
> [  216.835353] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
> FM1216ME)
> [  216.835360] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
> [  216.835365] em28xx #0:     card=29 -> Pinnacle Dazzle DVC 100
> [  216.835370] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
> [  216.835375] em28xx #0:     card=31 -> Usbgear VD204v9
> [  216.835382] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
> [  216.835387] em28xx #0:     card=33 -> SIIG AVTuner-PVR/Prolink PlayTV USB
> 2.0
> [  216.835393] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
> [  216.835398] em28xx #0:     card=35 -> Typhoon DVD Maker
> [  216.835404] em28xx #0:     card=36 -> NetGMBH Cam
> [  216.835409] em28xx #0:     card=37 -> Gadmei UTV330
> [  216.835413] em28xx #0:     card=38 -> Yakumo MovieMixer
> [  216.835418] em28xx #0:     card=39 -> KWorld PVRTV 300U
> [  216.835423] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
> [  216.835428] em28xx #0:     card=41 -> Kworld 350 U DVB-T
> [  216.835433] em28xx #0:     card=42 -> Kworld 355 U DVB-T
> [  216.835438] em28xx #0:     card=43 -> Terratec Cinergy T XS
> [  216.835445] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
> [  216.835450] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
> [  216.835455] em28xx #0:     card=46 -> Compro, VideoMate U3
> [  216.835460] em28xx #0:     card=47 -> KWorld DVB-T 305U
> [  216.835466] em28xx #0:     card=48 -> KWorld DVB-T 310U
> [  216.835471] em28xx #0:     card=49 -> MSI DigiVox A/D
> [  216.835476] em28xx #0:     card=50 -> MSI DigiVox A/D II
> [  216.835480] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
> [  216.835487] em28xx #0:     card=52 -> DNT DA2 Hybrid
> [  216.835491] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
> [  216.835496] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
> [  216.835501] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
> [  216.835508] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
> [  216.835513] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
> [  216.835518] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
> [  217.392349] em28xx #0: V4L2 device registered as /dev/video0 and
> /dev/vbi0
> [  217.392898] em28xx #0: Found Unknown EM2750/28xx video grabber
> [  217.420636] usbcore: registered new interface driver em28xx
> [  217.443538] em28xx-audio.c: probing for em28x1 non standard usbaudio
> [  217.443553] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> [  217.449231] Em28xx: Initialized (Em28xx Audio Extension) extension
>
>

those mt2060 based devices need a little bit finetuning, I'll send you
an email when I'm done with it....

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
