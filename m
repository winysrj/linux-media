Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0P2p5Wb000631
	for <video4linux-list@redhat.com>; Sat, 24 Jan 2009 21:51:05 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.237])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0P2ooLL020414
	for <video4linux-list@redhat.com>; Sat, 24 Jan 2009 21:50:50 -0500
Received: by rv-out-0506.google.com with SMTP id f6so5864102rvb.51
	for <video4linux-list@redhat.com>; Sat, 24 Jan 2009 18:50:50 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 24 Jan 2009 21:50:50 -0500
Message-ID: <4a40dbd40901241850i3a27fe52s85a02b2f085371e3@mail.gmail.com>
From: Rob Maurer <robmaurer@gmail.com>
To: V4L Mailing List <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: ADS Tech USB Instant TV (Model USBAV-704N)
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

[ 1683.990637] type=1503 audit(1232848927.305:6):
operation="inode_permission" requested_mask="::rw" denied_mask="::rw"
fsuid=7 name="/dev/tty" pid=14668 profile="/usr/sbin/cupsd"
[ 4424.396045] usb 1-2: new high speed USB device using ehci_hcd and address
4
[ 4424.529842] usb 1-2: configuration #1 chosen from 1 choice
[ 4424.892978] Linux video capture interface: v2.00
[ 4424.967872] usbcore: registered new interface driver snd-usb-audio
[ 4424.992974] em28xx: New device @ 480 Mbps (eb1a:2821, interface 0, class
0)
[ 4424.992994] em28xx #0: Identified as Unknown EM2750/28xx video grabber
(card=1)
[ 4424.993848] em28xx #0: chip ID is em2820
[ 4425.088830] em28xx #0: board has no eeprom
[ 4425.103713] em28xx #0: found i2c device @ 0x4a [saa7113h]
[ 4425.108711] em28xx #0: found i2c device @ 0x60 [remote IR sensor]
[ 4425.116836] em28xx #0: found i2c device @ 0x86 [tda9887]
[ 4425.129712] em28xx #0: found i2c device @ 0xc6 [tuner (analog)]
[ 4425.140962] em28xx #0: Your board has no unique USB ID and thus need a
hint to be detected.
[ 4425.140973] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[ 4425.140978] em28xx #0: Please send an email with this log to:
[ 4425.140983] em28xx #0:     V4L Mailing List <video4linux-list@redhat.com>
[ 4425.140988] em28xx #0: Board eeprom hash is 0x00000000
[ 4425.140993] em28xx #0: Board i2c devicelist hash is 0x8cad00a0
[ 4425.140998] em28xx #0: Here is a list of valid choices for the card=<n>
insmod option:
[ 4425.141018] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[ 4425.141023] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[ 4425.141028] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[ 4425.141033] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[ 4425.141038] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[ 4425.141043] em28xx #0:     card=5 -> MSI VOX USB 2.0
[ 4425.141048] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[ 4425.141053] em28xx #0:     card=7 -> Leadtek Winfast USB II
[ 4425.141058] em28xx #0:     card=8 -> Kworld USB2800
[ 4425.141063] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/DVC 100
[ 4425.141068] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[ 4425.141073] em28xx #0:     card=11 -> Terratec Hybrid XS
[ 4425.141078] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[ 4425.141083] em28xx #0:     card=13 -> Terratec Prodigy XS
[ 4425.141088] em28xx #0:     card=14 -> Pixelview Prolink PlayTV USB 2.0
[ 4425.141093] em28xx #0:     card=15 -> V-Gear PocketTV
[ 4425.141098] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[ 4425.141102] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 4425.141107] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 4425.141113] em28xx #0:     card=19 -> PointNix Intra-Oral Camera
[ 4425.141118] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[ 4425.141123] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+
Video Encoder
[ 4425.141129] em28xx #0:     card=22 -> Unknown EM2750/EM2751 webcam
grabber
[ 4425.141134] em28xx #0:     card=23 -> Huaqi DLCW-130
[ 4425.141139] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[ 4425.141144] em28xx #0:     card=25 -> Gadmei UTV310
[ 4425.141148] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[ 4425.141153] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)
[ 4425.141159] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[ 4425.141164] em28xx #0:     card=29 -> <NULL>
[ 4425.141169] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[ 4425.141174] em28xx #0:     card=31 -> Usbgear VD204v9
[ 4425.141179] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[ 4425.141184] em28xx #0:     card=33 -> SIIG AVTuner-PVR/Prolink PlayTV USB
2.0
[ 4425.141189] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[ 4425.141194] em28xx #0:     card=35 -> Typhoon DVD Maker
[ 4425.141199] em28xx #0:     card=36 -> NetGMBH Cam
[ 4425.141204] em28xx #0:     card=37 -> Gadmei UTV330
[ 4425.141208] em28xx #0:     card=38 -> Yakumo MovieMixer
[ 4425.141213] em28xx #0:     card=39 -> KWorld PVRTV 300U
[ 4425.141218] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[ 4425.141223] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[ 4425.141228] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[ 4425.141233] em28xx #0:     card=43 -> Terratec Cinergy T XS
[ 4425.141238] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[ 4425.141243] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[ 4425.141248] em28xx #0:     card=46 -> Compro, VideoMate U3
[ 4425.141253] em28xx #0:     card=47 -> KWorld DVB-T 305U
[ 4425.141258] em28xx #0:     card=48 -> KWorld DVB-T 310U
[ 4425.141262] em28xx #0:     card=49 -> MSI DigiVox A/D
[ 4425.141267] em28xx #0:     card=50 -> MSI DigiVox A/D II
[ 4425.141272] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[ 4425.141277] em28xx #0:     card=52 -> DNT DA2 Hybrid
[ 4425.141281] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[ 4425.141286] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[ 4425.141292] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[ 4425.141297] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[ 4425.141302] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 4425.141307] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[ 4425.141312] em28xx #0:     card=59 -> <NULL>
[ 4425.141316] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[ 4425.141321] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 4425.148715] em28xx #0: Config register raw data: 0x10
[ 4425.172715] em28xx #0: AC97 vendor ID = 0xffffffff
[ 4425.185713] em28xx #0: AC97 features = 0x6a90
[ 4425.185723] em28xx #0: Empia 202 AC97 audio processor detected
[ 4425.596043] em28xx #0: v4l2 driver version 0.1.1
[ 4426.260314] em28xx #0: V4L2 device registered as /dev/video0 and
/dev/vbi0
[ 4426.260367] usbcore: registered new interface driver em28xx
[ 4426.260375] em28xx driver loaded

-- 
*     *     *     *
Rob Maurer
508.648.5254 voice
508.833.0945 work
253.276.5340 fax
robmaurer@gmail.com
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
