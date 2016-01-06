Return-path: <linux-media-owner@vger.kernel.org>
Received: from NDMSVNPF103.ndc.nasa.gov ([198.117.0.153]:39886 "EHLO
	ndmsvnpf103.ndc.nasa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbcAFSzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2016 13:55:43 -0500
Received: from ndjsppt102.ndc.nasa.gov (ndjsppt102.ndc.nasa.gov [198.117.1.196])
	by ndmsvnpf103.ndc.nasa.gov (Postfix) with ESMTP id 037C4409D660
	for <linux-media@vger.kernel.org>; Wed,  6 Jan 2016 12:27:46 -0600 (CST)
Received: from NDJSCHT113.ndc.nasa.gov (ndjscht113-pub.ndc.nasa.gov [198.117.1.213])
	by ndjsppt102.ndc.nasa.gov (8.15.0.59/8.15.0.59) with ESMTP id u06IRkZk020999
	for <linux-media@vger.kernel.org>; Wed, 6 Jan 2016 12:27:46 -0600
From: "Schubert, Matthew R. (LARC-D319)[TEAMS2]"
	<matthew.r.schubert@nasa.gov>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: em28xx driver for StarTech SVID2USB2
Date: Wed, 6 Jan 2016 18:27:45 +0000
Message-ID: <D98DB3C2FD3AF74BBBFA4EB47841381511C140B9@NDJSMBX104.ndc.nasa.gov>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

We are attempting to use a StarTech Video Capture cable (Part# SVID2USB2) with our CentOS 6.7 machine with no success. The em28xx driver seems to load but cannot properly ID the capture cable. Below are the outputs from "dmesg" and "lsusb -v" run after plugging in the device. Any advice is appreciated.

Thanks,

Matt R. Schubert
Programmer | Analyst
Analytical Mechanics Associates
NASA Langley Computational Vision Lab

==========================================================================
dmesg

em28xx: New device USB 2821 Device @ 480 Mbps (eb1a:2821, interface 0, class 0)
em28xx #0: chip ID is em2820 (or em2710)
IR NEC protocol handler initialized
IR RC5(x) protocol handler initialized
IR RC6 protocol handler initialized
IR JVC protocol handler initialized
IR Sony protocol handler initialized
lirc_dev: IR Remote Control driver registered, major 245
IR LIRC bridge handler initialized
em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 21 28 90 00 11 03 6a 22 00 00
em28xx #0: i2c eeprom 10: 00 00 04 57 06 21 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 20: 02 00 01 01 f0 10 00 00 00 00 00 00 5b 00 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 03 01 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 32 00 31 00 20 00 44 00
em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x26da7a8a
em28xx #0: EEPROM info:
em28xx #0:      AC97 audio (5 sample rates)
em28xx #0:      500mA max power
em28xx #0:      Table at 0x04, strings=0x226a, 0x0000, 0x0000
em28xx #0: found i2c device @ 0x4a [saa7113h]
em28xx #0: found i2c device @ 0xa0 [eeprom]
em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
em28xx #0: You may try to use card=<n> insmod option to workaround that.
em28xx #0: Please send an email with this log to:
em28xx #0:      V4L Mailing List <linux-media@vger.kernel.org>
em28xx #0: Board eeprom hash is 0x26da7a8a
em28xx #0: Board i2c devicelist hash is 0x6ba50080
em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
em28xx #0:     card=0 -> Unknown EM2800 video grabber
em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
em28xx #0:     card=2 -> Terratec Cinergy 250 USB
em28xx #0:     card=3 -> Pinnacle PCTV USB 2
em28xx #0:     card=4 -> Hauppauge WinTV USB 2
em28xx #0:     card=5 -> MSI VOX USB 2.0
em28xx #0:     card=6 -> Terratec Cinergy 200 USB
em28xx #0:     card=7 -> Leadtek Winfast USB II
em28xx #0:     card=8 -> Kworld USB2800
em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
em28xx #0:     card=11 -> Terratec Hybrid XS
em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
em28xx #0:     card=13 -> Terratec Prodigy XS
em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
em28xx #0:     card=15 -> V-Gear PocketTV
em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
em28xx #0:     card=23 -> Huaqi DLCW-130
em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
em28xx #0:     card=25 -> Gadmei UTV310
em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
em28xx #0:     card=31 -> Usbgear VD204v9
em28xx #0:     card=32 -> Supercomp USB 2.0 TV
em28xx #0:     card=33 -> Elgato Video Capture
em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
em28xx #0:     card=35 -> Typhoon DVD Maker
em28xx #0:     card=36 -> NetGMBH Cam
em28xx #0:     card=37 -> Gadmei UTV330
em28xx #0:     card=38 -> Yakumo MovieMixer
em28xx #0:     card=39 -> KWorld PVRTV 300U
em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
em28xx #0:     card=41 -> Kworld 350 U DVB-T
em28xx #0:     card=42 -> Kworld 355 U DVB-T
em28xx #0:     card=43 -> Terratec Cinergy T XS
em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
em28xx #0:     card=46 -> Compro, VideoMate U3
em28xx #0:     card=47 -> KWorld DVB-T 305U
em28xx #0:     card=48 -> KWorld DVB-T 310U
em28xx #0:     card=49 -> MSI DigiVox A/D
em28xx #0:     card=50 -> MSI DigiVox A/D II
em28xx #0:     card=51 -> Terratec Hybrid XS Secam
em28xx #0:     card=52 -> DNT DA2 Hybrid
em28xx #0:     card=53 -> Pinnacle Hybrid Pro
em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T USB XS (em2882)
em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
em28xx #0:     card=59 -> (null)
em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
em28xx #0:     card=62 -> Gadmei TVR200
em28xx #0:     card=63 -> Kaiomy TVnPC U2
em28xx #0:     card=64 -> Easy Cap Capture DC-60
em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
em28xx #0:     card=66 -> Empire dual TV
em28xx #0:     card=67 -> Terratec Grabby
em28xx #0:     card=68 -> Terratec AV350
em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
em28xx #0:     card=70 -> Evga inDtube
em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
em28xx #0:     card=72 -> Gadmei UTV330+
em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
em28xx #0:     card=75 -> Dikom DK300
em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
em28xx #0:     card=77 -> EM2874 Leadership ISDBT
em28xx #0: Board not discovered
em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
em28xx #0: You may try to use card=<n> insmod option to workaround that.
em28xx #0: Please send an email with this log to:
em28xx #0:      V4L Mailing List <linux-media@vger.kernel.org>
em28xx #0: Board eeprom hash is 0x26da7a8a
em28xx #0: Board i2c devicelist hash is 0x6ba50080
em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
em28xx #0:     card=0 -> Unknown EM2800 video grabber
em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
em28xx #0:     card=2 -> Terratec Cinergy 250 USB
em28xx #0:     card=3 -> Pinnacle PCTV USB 2
em28xx #0:     card=4 -> Hauppauge WinTV USB 2
em28xx #0:     card=5 -> MSI VOX USB 2.0
em28xx #0:     card=6 -> Terratec Cinergy 200 USB
em28xx #0:     card=7 -> Leadtek Winfast USB II
em28xx #0:     card=8 -> Kworld USB2800
em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
em28xx #0:     card=11 -> Terratec Hybrid XS
em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
em28xx #0:     card=13 -> Terratec Prodigy XS
em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
em28xx #0:     card=15 -> V-Gear PocketTV
em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
em28xx #0:     card=23 -> Huaqi DLCW-130
em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
em28xx #0:     card=25 -> Gadmei UTV310
em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
em28xx #0:     card=31 -> Usbgear VD204v9
em28xx #0:     card=32 -> Supercomp USB 2.0 TV
em28xx #0:     card=33 -> Elgato Video Capture
em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
em28xx #0:     card=35 -> Typhoon DVD Maker
em28xx #0:     card=36 -> NetGMBH Cam
em28xx #0:     card=37 -> Gadmei UTV330
em28xx #0:     card=38 -> Yakumo MovieMixer
em28xx #0:     card=39 -> KWorld PVRTV 300U
em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
em28xx #0:     card=41 -> Kworld 350 U DVB-T
em28xx #0:     card=42 -> Kworld 355 U DVB-T
em28xx #0:     card=43 -> Terratec Cinergy T XS
em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
em28xx #0:     card=46 -> Compro, VideoMate U3
em28xx #0:     card=47 -> KWorld DVB-T 305U
em28xx #0:     card=48 -> KWorld DVB-T 310U
em28xx #0:     card=49 -> MSI DigiVox A/D
em28xx #0:     card=50 -> MSI DigiVox A/D II
em28xx #0:     card=51 -> Terratec Hybrid XS Secam
em28xx #0:     card=52 -> DNT DA2 Hybrid
em28xx #0:     card=53 -> Pinnacle Hybrid Pro
em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T USB XS (em2882)
em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
em28xx #0:     card=59 -> (null)
em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
em28xx #0:     card=62 -> Gadmei TVR200
em28xx #0:     card=63 -> Kaiomy TVnPC U2
em28xx #0:     card=64 -> Easy Cap Capture DC-60
em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
em28xx #0:     card=66 -> Empire dual TV
em28xx #0:     card=67 -> Terratec Grabby
em28xx #0:     card=68 -> Terratec AV350
em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
em28xx #0:     card=70 -> Evga inDtube
em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
em28xx #0:     card=72 -> Gadmei UTV330+
em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
em28xx #0:     card=75 -> Dikom DK300
em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
em28xx #0:     card=77 -> EM2874 Leadership ISDBT
em28xx #0: Config register raw data: 0x90
em28xx #0: AC97 vendor ID = 0x83847650
em28xx #0: AC97 features = 0x6a90
em28xx #0: Sigmatel audio processor detected(stac 9750)
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 video device registered as video0
usbcore: registered new interface driver em28xx
em28xx driver loaded

==========================================================================
lsusb -v

Bus 002 Device 019: ID eb1a:2821 eMPIA Technology, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0xeb1a eMPIA Technology, Inc.
  idProduct          0x2821
  bcdDevice            1.00
  iManufacturer           0
  iProduct                1
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          521
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       2
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0ad4  2x 724 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       3
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0c00  2x 1024 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       4
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1300  3x 768 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       5
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x135c  3x 860 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       6
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x13c4  3x 964 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       7
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      1 Control Device
      bInterfaceProtocol      0
      iInterface              0
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdADC               1.00
        wTotalLength           39
        bInCollection           1
        baInterfaceNr( 0)       2
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0603 Line Connector
        bAssocTerminal          0
        bNrChannels             2
        wChannelConfig     0x0003
          Left Front (L)
          Right Front (R)
        iChannelNames           0
        iTerminal               0
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 2
        bSourceID               1
        bControlSize            1
        bmaControls( 0)      0x03
          Mute Control
          Volume Control
        bmaControls( 1)      0x00
        iFeature                0
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               2
        iTerminal               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        48000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x001c  1x 28 bytes
        bInterval               1
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        44100
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0018  1x 24 bytes
        bInterval               1
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        32000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0014  1x 20 bytes
        bInterval               1
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       4
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        22050
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x000c  1x 12 bytes
        bInterval               1
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       5
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]         8000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               1
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined