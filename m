Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47154 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S936143Ab0GPJej (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 05:34:39 -0400
Date: Fri, 16 Jul 2010 11:34:29 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-media@vger.kernel.org
Message-ID: <20100716093429.GA2709@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

I recently purchased a Delock USB 2.0 Video Grabber
http://www.delock.de/produkte/gruppen/Multimedia/Delock_USB_20_Video_Grabber_61534.html
which windows recognises as a USB PVR-TV device. The drivers on the
cdrom which came with the device seem to be from 2009 whereas the ones 
on the website are from 2008.

On Ubuntu Lucid and Debian Sid plugging it into the host it
produces the following dmesg output:

[  301.050914] usb 1-7: new high speed USB device using ehci_hcd and address 5
[  301.201825] usb 1-7: configuration #1 chosen from 1 choice
[  301.412395] Linux video capture interface: v2.00
[  301.469956] em28xx: New device @ 480 Mbps (eb1a:2861, interface 0, class 0)
[  301.470129] em28xx #0: chip ID is em2860
[  301.636076] em28xx #0: i2c eeprom 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636112] em28xx #0: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636144] em28xx #0: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636173] em28xx #0: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636203] em28xx #0: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636232] em28xx #0: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636262] em28xx #0: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636292] em28xx #0: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636323] em28xx #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636354] em28xx #0: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636385] em28xx #0: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636417] em28xx #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636449] em28xx #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636482] em28xx #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636513] em28xx #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636543] em28xx #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  301.636575] em28xx #0: EEPROM ID= 0xffffffff, EEPROM hash = 0x00000000
[  301.636582] em28xx #0: EEPROM info:
[  301.636588] em28xx #0:	I2S audio, 3 sample rates
[  301.636593] em28xx #0:	USB Remote wakeup capable
[  301.636599] em28xx #0:	USB Self power capable
[  301.636605] em28xx #0:	200mA max power
[  301.636613] em28xx #0:	Table at 0xff, strings=0xffff, 0xffff, 0xffff
[  301.650582] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
[  301.664828] em28xx #0: found i2c device @ 0x4a [saa7113h]
[  301.681079] em28xx #0: found i2c device @ 0xa0 [eeprom]
[  301.681452] em28xx #0: found i2c device @ 0xa2 [???]
[  301.681825] em28xx #0: found i2c device @ 0xa4 [???]
[  301.682200] em28xx #0: found i2c device @ 0xa6 [???]
[  301.682574] em28xx #0: found i2c device @ 0xa8 [???]
[  301.682950] em28xx #0: found i2c device @ 0xaa [???]
[  301.683324] em28xx #0: found i2c device @ 0xac [???]
[  301.683698] em28xx #0: found i2c device @ 0xae [???]
[  301.699705] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[  301.699719] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[  301.699727] em28xx #0: Please send an email with this log to:
[  301.699734] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[  301.699741] em28xx #0: Board eeprom hash is 0x00000000
[  301.699749] em28xx #0: Board i2c devicelist hash is 0x83ec0484
[  301.699757] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[  301.699766] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[  301.699775] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[  301.699784] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[  301.699792] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[  301.699800] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[  301.699808] em28xx #0:     card=5 -> MSI VOX USB 2.0
[  301.699816] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[  301.699824] em28xx #0:     card=7 -> Leadtek Winfast USB II
[  301.699832] em28xx #0:     card=8 -> Kworld USB2800
[  301.699841] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[  301.699852] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[  301.699859] em28xx #0:     card=11 -> Terratec Hybrid XS
[  301.699866] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[  301.699873] em28xx #0:     card=13 -> Terratec Prodigy XS
[  301.699881] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[  301.699889] em28xx #0:     card=15 -> V-Gear PocketTV
[  301.699897] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[  301.699905] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[  301.699913] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[  301.699921] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[  301.699928] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[  301.699937] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[  301.699946] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[  301.699953] em28xx #0:     card=23 -> Huaqi DLCW-130
[  301.699960] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[  301.699968] em28xx #0:     card=25 -> Gadmei UTV310
[  301.699976] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[  301.699984] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[  301.699993] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[  301.700001] em28xx #0:     card=29 -> <NULL>
[  301.700062] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[  301.700074] em28xx #0:     card=31 -> Usbgear VD204v9
[  301.700097] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[  301.700119] em28xx #0:     card=33 -> <NULL>
[  301.700139] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[  301.700163] em28xx #0:     card=35 -> Typhoon DVD Maker
[  301.700185] em28xx #0:     card=36 -> NetGMBH Cam
[  301.700206] em28xx #0:     card=37 -> Gadmei UTV330
[  301.700226] em28xx #0:     card=38 -> Yakumo MovieMixer
[  301.700246] em28xx #0:     card=39 -> KWorld PVRTV 300U
[  301.700267] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[  301.700290] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[  301.700313] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[  301.700335] em28xx #0:     card=43 -> Terratec Cinergy T XS
[  301.700358] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[  301.700383] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[  301.700406] em28xx #0:     card=46 -> Compro, VideoMate U3
[  301.700428] em28xx #0:     card=47 -> KWorld DVB-T 305U
[  301.700450] em28xx #0:     card=48 -> KWorld DVB-T 310U
[  301.700472] em28xx #0:     card=49 -> MSI DigiVox A/D
[  301.700494] em28xx #0:     card=50 -> MSI DigiVox A/D II
[  301.700515] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[  301.700539] em28xx #0:     card=52 -> DNT DA2 Hybrid
[  301.700560] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[  301.700582] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  301.700604] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[  301.700629] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[  301.700652] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  301.700674] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  301.700697] em28xx #0:     card=59 -> <NULL>
[  301.700716] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  301.700739] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  301.700763] em28xx #0:     card=62 -> Gadmei TVR200
[  301.700784] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  301.700806] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  301.700830] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  301.700852] em28xx #0:     card=66 -> Empire dual TV
[  301.700874] em28xx #0:     card=67 -> Terratec Grabby
[  301.700896] em28xx #0:     card=68 -> Terratec AV350
[  301.700918] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  301.700942] em28xx #0:     card=70 -> Evga inDtube
[  301.700964] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  301.700986] em28xx #0:     card=72 -> Gadmei UTV330+
[  301.701007] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[  301.701222] em28xx #0: Config register raw data: 0x10
[  301.760330] em28xx #0: AC97 vendor ID = 0x83847652
[  301.786449] em28xx #0: AC97 features = 0x6a90
[  301.786457] em28xx #0: Sigmatel audio processor detected(stac 9752)
[  302.510045] em28xx #0: v4l2 driver version 0.1.2
[  304.130342] em28xx #0: V4L2 video device registered as /dev/video0
[  304.130352] em28xx #0: V4L2 VBI device registered as /dev/vbi0
[  304.135660] usbcore: registered new interface driver snd-usb-audio
[  304.139501] usbcore: registered new interface driver em28xx
[  304.139517] em28xx driver loaded


lsusb reports the following:

Bus 001 Device 005: ID eb1a:2861 eMPIA Technology, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0xeb1a eMPIA Technology, Inc.
  idProduct          0x2861 
  bcdDevice            1.00
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          555
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 0
      bDescriptorType         0
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 0
      bDescriptorType         0
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 0
      bDescriptorType         0
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 0
      bDescriptorType         0
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 0
      bDescriptorType         0
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 0
      bDescriptorType         0
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 0
      bDescriptorType         0
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
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
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
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
          Mute
          Volume
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
      bLength                 0
      bDescriptorType         0
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 0
      bDescriptorType         0
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 0
      bDescriptorType         0
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 0
      bDescriptorType         0
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 0
      bDescriptorType         0
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
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
        wMaxPacketSize     0x0024  1x 36 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

I tested with card=1 which crashed my box while playing aroung (sorry, did not capture
the oops), card=19 seemed so work a bit (vlc was able to open the device
but not show anything).

If required I am able to test patches or generate usbmon traces for
the windows drivers from a kvm guest.

Regards, Eric
