Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37700 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab0INQTd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 12:19:33 -0400
Received: by bwz11 with SMTP id 11so5658148bwz.19
        for <linux-media@vger.kernel.org>; Tue, 14 Sep 2010 09:19:30 -0700 (PDT)
Received: by bwz11 with SMTP id 11so5658105bwz.19
        for <linux-media@vger.kernel.org>; Tue, 14 Sep 2010 09:19:27 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 14 Sep 2010 18:19:27 +0200
Message-ID: <AANLkTinSB_ChWLnR=hQ6jAuRtgeLm0dze6f4mTy5buNt@mail.gmail.com>
Subject: Videomed Videosmart VX-3001
From: =?ISO-8859-2?Q?Pawe=B3_Ku=BCniar?= <pawel@kuzniar.com.pl>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I've just got my hands on Videosmart VX-3001 medical video-grabber. It
seems it has some common hardware under the hood, but I only managed
to get dark-green screen in Cheese.  I include some of my specs,
dmesg and lsub. Being completely green in driver development I'd like
to get some help in figuring out  how to make it work.


 2.6.35-20-generic #29-Ubuntu SMP Fri Sep 3 14:55:28 UTC 2010 x86_64 GNU/Linux

Bus 001 Device 004: ID eb1a:2861 eMPIA Technology, Inc.
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
       bmAttributes            1
         Transfer Type            Isochronous
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0000  1x 0 bytes
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
       wMaxPacketSize     0x0000  1x 0 bytes
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
       bmAttributes            1
         Transfer Type            Isochronous
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0000  1x 0 bytes
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
       bmAttributes            1
         Transfer Type            Isochronous
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0000  1x 0 bytes
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
       bmAttributes            1
         Transfer Type            Isochronous
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0000  1x 0 bytes
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
       bmAttributes            1
         Transfer Type            Isochronous
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0000  1x 0 bytes
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
       bmAttributes            1
         Transfer Type            Isochronous
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0000  1x 0 bytes
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
     bLength                 9
     bDescriptorType         4
     bInterfaceNumber        2
     bAlternateSetting       0
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
       tSamFreq[ 0]            0
     Endpoint Descriptor:
       bLength                 9
       bDescriptorType         5
       bEndpointAddress     0x83  EP 3 IN
       bmAttributes            1
         Transfer Type            Isochronous
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0000  1x 0 bytes
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
       wMaxPacketSize     0x00c4  1x 196 bytes
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
       wMaxPacketSize     0x00b4  1x 180 bytes
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
       wMaxPacketSize     0x0084  1x 132 bytes
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
       tSamFreq[ 0]        16000
     Endpoint Descriptor:
       bLength                 9
       bDescriptorType         5
       bEndpointAddress     0x83  EP 3 IN
       bmAttributes            1
         Transfer Type            Isochronous
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0044  1x 68 bytes
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

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
 bLength                18
 bDescriptorType         1
 bcdUSB               2.00
 bDeviceClass            9 Hub
 bDeviceSubClass         0 Unused
 bDeviceProtocol         0 Full speed (or root) hub
 bMaxPacketSize0        64
 idVendor           0x1d6b Linux Foundation
 idProduct          0x0002 2.0 root hub
 bcdDevice            2.06
 iManufacturer           3
 iProduct                2
 iSerial                 1
 bNumConfigurations      1
 Configuration Descriptor:
   bLength                 9
   bDescriptorType         2
   wTotalLength           25
   bNumInterfaces          1
   bConfigurationValue     1
   iConfiguration          0
   bmAttributes         0xe0
     Self Powered
     Remote Wakeup
   MaxPower                0mA
   Interface Descriptor:
     bLength                 9
     bDescriptorType         4
     bInterfaceNumber        0
     bAlternateSetting       0
     bNumEndpoints           1
     bInterfaceClass         9 Hub
     bInterfaceSubClass      0 Unused
     bInterfaceProtocol      0 Full speed (or root) hub
     iInterface              0
     Endpoint Descriptor:
       bLength                 7
       bDescriptorType         5
       bEndpointAddress     0x81  EP 1 IN
       bmAttributes            3
         Transfer Type            Interrupt
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0004  1x 4 bytes
       bInterval              12



[  177.200295] usb 1-3: new high speed USB device using ehci_hcd and address 4
[  177.492308] Linux video capture interface: v2.00
[  177.493907] IR NEC protocol handler initialized
[  177.499529] IR RC5(x) protocol handler initialized
[  177.564668] IR RC6 protocol handler initialized
[  177.570875] em28xx: New device @ 480 Mbps (eb1a:2861, interface 0, class 0)
[  177.571060] em28xx #0: chip ID is em2860
[  177.618639] IR JVC protocol handler initialized
[  177.621594] IR Sony protocol handler initialized
[  177.667519] lirc_dev: IR Remote Control driver registered, major 250
[  177.669829] IR LIRC bridge handler initialized
[  177.741359] em28xx #0: i2c eeprom 00: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741386] em28xx #0: i2c eeprom 10: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741409] em28xx #0: i2c eeprom 20: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741431] em28xx #0: i2c eeprom 30: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741453] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741476] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741498] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741520] em28xx #0: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741542] em28xx #0: i2c eeprom 80: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741564] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741586] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741608] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741630] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741652] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741674] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741696] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  177.741719] em28xx #0: EEPROM ID= 0x00000000, EEPROM hash = 0x00000000
[  177.741724] em28xx #0: EEPROM info:
[  177.741728] em28xx #0:       No audio on board.
[  177.741732] em28xx #0:       500mA max power
[  177.741737] em28xx #0:       Table at 0x00, strings=0x0000, 0x0000, 0x0000
[  177.763662] Unknown Micron Sensor 0x0000
[  177.763672] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[  177.764416] em28xx #0: found i2c device @ 0x0 [???]
[  177.765167] em28xx #0: found i2c device @ 0x2 [???]
[  177.765912] em28xx #0: found i2c device @ 0x4 [???]
[  177.766667] em28xx #0: found i2c device @ 0x6 [???]
[  177.767414] em28xx #0: found i2c device @ 0x8 [???]
[  177.768164] em28xx #0: found i2c device @ 0xa [???]
[  177.768572] em28xx #0: found i2c device @ 0xc [???]
[  177.768948] em28xx #0: found i2c device @ 0xe [???]
[  177.769319] em28xx #0: found i2c device @ 0x10 [???]
[  177.769695] em28xx #0: found i2c device @ 0x12 [???]
[  177.770129] em28xx #0: found i2c device @ 0x14 [???]
[  177.770588] em28xx #0: found i2c device @ 0x16 [???]
[  177.770964] em28xx #0: found i2c device @ 0x18 [???]
[  177.771338] em28xx #0: found i2c device @ 0x1a [???]
[  177.771712] em28xx #0: found i2c device @ 0x1c [???]
[  177.772089] em28xx #0: found i2c device @ 0x1e [???]
[  177.772441] em28xx #0: found i2c device @ 0x20 [???]
[  177.774193] em28xx #0: found i2c device @ 0x22 [???]
[  177.774574] em28xx #0: found i2c device @ 0x24 [???]
[  177.774946] em28xx #0: found i2c device @ 0x26 [???]
[  177.775322] em28xx #0: found i2c device @ 0x28 [???]
[  177.775696] em28xx #0: found i2c device @ 0x2a [???]
[  177.776071] em28xx #0: found i2c device @ 0x2c [???]
[  177.776445] em28xx #0: found i2c device @ 0x2e [???]
[  177.776820] em28xx #0: found i2c device @ 0x30 [???]
[  177.777195] em28xx #0: found i2c device @ 0x32 [???]
[  177.777570] em28xx #0: found i2c device @ 0x34 [???]
[  177.777943] em28xx #0: found i2c device @ 0x36 [???]
[  177.778320] em28xx #0: found i2c device @ 0x38 [???]
[  177.778695] em28xx #0: found i2c device @ 0x3a [???]
[  177.779070] em28xx #0: found i2c device @ 0x3c [???]
[  177.779443] em28xx #0: found i2c device @ 0x3e [???]
[  177.779821] em28xx #0: found i2c device @ 0x40 [???]
[  177.780190] em28xx #0: found i2c device @ 0x42 [???]
[  177.780568] em28xx #0: found i2c device @ 0x44 [???]
[  177.780940] em28xx #0: found i2c device @ 0x46 [???]
[  177.781313] em28xx #0: found i2c device @ 0x48 [???]
[  177.781697] em28xx #0: found i2c device @ 0x4a [saa7113h]
[  177.782071] em28xx #0: found i2c device @ 0x4c [???]
[  177.782445] em28xx #0: found i2c device @ 0x4e [???]
[  177.783199] em28xx #0: found i2c device @ 0x50 [???]
[  177.783573] em28xx #0: found i2c device @ 0x52 [???]
[  177.783948] em28xx #0: found i2c device @ 0x54 [???]
[  177.784321] em28xx #0: found i2c device @ 0x56 [???]
[  177.784695] em28xx #0: found i2c device @ 0x58 [???]
[  177.785070] em28xx #0: found i2c device @ 0x5a [???]
[  177.785444] em28xx #0: found i2c device @ 0x5c [???]
[  177.785820] em28xx #0: found i2c device @ 0x5e [???]
[  177.786194] em28xx #0: found i2c device @ 0x60 [remote IR sensor]
[  177.786572] em28xx #0: found i2c device @ 0x62 [???]
[  177.786943] em28xx #0: found i2c device @ 0x64 [???]
[  177.787319] em28xx #0: found i2c device @ 0x66 [???]
[  177.787692] em28xx #0: found i2c device @ 0x68 [???]
[  177.788070] em28xx #0: found i2c device @ 0x6a [???]
[  177.788446] em28xx #0: found i2c device @ 0x6c [???]
[  177.788818] em28xx #0: found i2c device @ 0x6e [???]
[  177.789190] em28xx #0: found i2c device @ 0x70 [???]
[  177.789570] em28xx #0: found i2c device @ 0x72 [???]
[  177.789945] em28xx #0: found i2c device @ 0x74 [???]
[  177.791697] em28xx #0: found i2c device @ 0x76 [???]
[  177.792073] em28xx #0: found i2c device @ 0x78 [???]
[  177.792446] em28xx #0: found i2c device @ 0x7a [???]
[  177.792816] em28xx #0: found i2c device @ 0x7c [???]
[  177.793197] em28xx #0: found i2c device @ 0x7e [???]
[  177.793571] em28xx #0: found i2c device @ 0x80 [msp34xx]
[  177.793943] em28xx #0: found i2c device @ 0x82 [???]
[  177.794320] em28xx #0: found i2c device @ 0x84 [???]
[  177.794695] em28xx #0: found i2c device @ 0x86 [tda9887]
[  177.795072] em28xx #0: found i2c device @ 0x88 [msp34xx]
[  177.795447] em28xx #0: found i2c device @ 0x8a [???]
[  177.795822] em28xx #0: found i2c device @ 0x8c [???]
[  177.796195] em28xx #0: found i2c device @ 0x8e [remote IR sensor]
[  177.796570] em28xx #0: found i2c device @ 0x90 [???]
[  177.796947] em28xx #0: found i2c device @ 0x92 [???]
[  177.797318] em28xx #0: found i2c device @ 0x94 [???]
[  177.797695] em28xx #0: found i2c device @ 0x96 [???]
[  177.798069] em28xx #0: found i2c device @ 0x98 [???]
[  177.798445] em28xx #0: found i2c device @ 0x9a [???]
[  177.798821] em28xx #0: found i2c device @ 0x9c [???]
[  177.799195] em28xx #0: found i2c device @ 0x9e [???]
[  177.799569] em28xx #0: found i2c device @ 0xa0 [eeprom]
[  177.799944] em28xx #0: found i2c device @ 0xa2 [???]
[  177.801327] em28xx #0: found i2c device @ 0xa4 [???]
[  177.801691] em28xx #0: found i2c device @ 0xa6 [???]
[  177.802070] em28xx #0: found i2c device @ 0xa8 [???]
[  177.802445] em28xx #0: found i2c device @ 0xaa [???]
[  177.802818] em28xx #0: found i2c device @ 0xac [???]
[  177.803195] em28xx #0: found i2c device @ 0xae [???]
[  177.803569] em28xx #0: found i2c device @ 0xb0 [tda9874]
[  177.803943] em28xx #0: found i2c device @ 0xb2 [???]
[  177.804322] em28xx #0: found i2c device @ 0xb4 [???]
[  177.804695] em28xx #0: found i2c device @ 0xb6 [???]
[  177.805070] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[  177.805445] em28xx #0: found i2c device @ 0xba [webcam sensor or tvp5150a]
[  177.805817] em28xx #0: found i2c device @ 0xbc [???]
[  177.806199] em28xx #0: found i2c device @ 0xbe [???]
[  177.806571] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[  177.806947] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[  177.807321] em28xx #0: found i2c device @ 0xc4 [tuner (analog)]
[  177.807693] em28xx #0: found i2c device @ 0xc6 [tuner (analog)]
[  177.808070] em28xx #0: found i2c device @ 0xc8 [???]
[  177.808447] em28xx #0: found i2c device @ 0xca [???]
[  177.808819] em28xx #0: found i2c device @ 0xcc [???]
[  177.809197] em28xx #0: found i2c device @ 0xce [???]
[  177.809568] em28xx #0: found i2c device @ 0xd0 [???]
[  177.809947] em28xx #0: found i2c device @ 0xd2 [???]
[  177.810623] em28xx #0: found i2c device @ 0xd4 [???]
[  177.811068] em28xx #0: found i2c device @ 0xd6 [???]
[  177.811441] em28xx #0: found i2c device @ 0xd8 [???]
[  177.811817] em28xx #0: found i2c device @ 0xda [???]
[  177.812196] em28xx #0: found i2c device @ 0xdc [???]
[  177.812692] em28xx #0: found i2c device @ 0xde [???]
[  177.813067] em28xx #0: found i2c device @ 0xe0 [???]
[  177.813443] em28xx #0: found i2c device @ 0xe2 [???]
[  177.813819] em28xx #0: found i2c device @ 0xe4 [???]
[  177.814193] em28xx #0: found i2c device @ 0xe6 [???]
[  177.814568] em28xx #0: found i2c device @ 0xe8 [???]
[  177.814945] em28xx #0: found i2c device @ 0xea [???]
[  177.815319] em28xx #0: found i2c device @ 0xec [???]
[  177.815694] em28xx #0: found i2c device @ 0xee [???]
[  177.816071] em28xx #0: found i2c device @ 0xf0 [???]
[  177.816442] em28xx #0: found i2c device @ 0xf2 [???]
[  177.816818] em28xx #0: found i2c device @ 0xf4 [???]
[  177.817195] em28xx #0: found i2c device @ 0xf6 [???]
[  177.817572] em28xx #0: found i2c device @ 0xf8 [???]
[  177.817942] em28xx #0: found i2c device @ 0xfa [???]
[  177.818318] em28xx #0: found i2c device @ 0xfc [???]
[  177.818696] em28xx #0: found i2c device @ 0xfe [???]
[  177.818703] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
[  177.818710] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[  177.818714] em28xx #0: Please send an email with this log to:
[  177.818719] em28xx #0:       V4L Mailing List <linux-media@vger.kernel.org>
[  177.818724] em28xx #0: Board eeprom hash is 0x00000000
[  177.818729] em28xx #0: Board i2c devicelist hash is 0x7d2e7f80
[  177.818734] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[  177.818740] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[  177.818746] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[  177.818752] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[  177.818757] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[  177.818762] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[  177.818767] em28xx #0:     card=5 -> MSI VOX USB 2.0
[  177.818772] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[  177.818777] em28xx #0:     card=7 -> Leadtek Winfast USB II
[  177.818783] em28xx #0:     card=8 -> Kworld USB2800
[  177.818788] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[  177.818794] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[  177.818800] em28xx #0:     card=11 -> Terratec Hybrid XS
[  177.818806] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[  177.818811] em28xx #0:     card=13 -> Terratec Prodigy XS
[  177.818816] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[  177.818822] em28xx #0:     card=15 -> V-Gear PocketTV
[  177.818827] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[  177.818832] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[  177.818838] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[  177.818843] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[  177.818849] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[  177.818854] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[  177.818860] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[  177.818865] em28xx #0:     card=23 -> Huaqi DLCW-130
[  177.818870] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[  177.818875] em28xx #0:     card=25 -> Gadmei UTV310
[  177.818880] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[  177.818886] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[  177.818892] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[  177.818897] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[  177.818902] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[  177.818908] em28xx #0:     card=31 -> Usbgear VD204v9
[  177.818913] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[  177.818918] em28xx #0:     card=33 -> (null)
[  177.818923] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[  177.818928] em28xx #0:     card=35 -> Typhoon DVD Maker
[  177.818933] em28xx #0:     card=36 -> NetGMBH Cam
[  177.818938] em28xx #0:     card=37 -> Gadmei UTV330
[  177.818943] em28xx #0:     card=38 -> Yakumo MovieMixer
[  177.818948] em28xx #0:     card=39 -> KWorld PVRTV 300U
[  177.818953] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[  177.818959] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[  177.818964] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[  177.818969] em28xx #0:     card=43 -> Terratec Cinergy T XS
[  177.818974] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[  177.818979] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[  177.818985] em28xx #0:     card=46 -> Compro, VideoMate U3
[  177.818990] em28xx #0:     card=47 -> KWorld DVB-T 305U
[  177.818995] em28xx #0:     card=48 -> KWorld DVB-T 310U
[  177.819000] em28xx #0:     card=49 -> MSI DigiVox A/D
[  177.819005] em28xx #0:     card=50 -> MSI DigiVox A/D II
[  177.819010] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[  177.819015] em28xx #0:     card=52 -> DNT DA2 Hybrid
[  177.819020] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[  177.819025] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  177.819030] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[  177.819036] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[  177.819041] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  177.819047] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  177.819052] em28xx #0:     card=59 -> (null)
[  177.819056] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  177.819062] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  177.819067] em28xx #0:     card=62 -> Gadmei TVR200
[  177.819072] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  177.819077] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  177.819082] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  177.819087] em28xx #0:     card=66 -> Empire dual TV
[  177.819092] em28xx #0:     card=67 -> Terratec Grabby
[  177.819097] em28xx #0:     card=68 -> Terratec AV350
[  177.819102] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  177.819108] em28xx #0:     card=70 -> Evga inDtube
[  177.819113] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  177.819118] em28xx #0:     card=72 -> Gadmei UTV330+
[  177.819123] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[  177.819129] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[  177.819134] em28xx #0:     card=75 -> Dikom DK300
[  177.819319] em28xx #0: Config register raw data: 0x10
[  177.850385] em28xx #0: AC97 vendor ID = 0x64346434
[  177.870386] em28xx #0: AC97 features = 0x6434
[  177.870392] em28xx #0: Unknown AC97 audio processor detected!
[  178.550137] em28xx #0: v4l2 driver version 0.1.2
[  180.090390] em28xx #0: V4L2 video device registered as video0
[  180.090399] em28xx #0: V4L2 VBI device registered as vbi0
[  180.090443] em28xx audio device (eb1a:2861): interface 1, class 1
[  180.090468] em28xx audio device (eb1a:2861): interface 2, class 1
[  180.090521] usbcore: registered new interface driver em28xx
[  180.090526] em28xx driver loaded
[  180.220449] 4:2:1: endpoint lacks sample rate attribute bit, cannot set.
[  180.220561] 4:2:2: endpoint lacks sample rate attribute bit, cannot set.
[  180.220684] 4:2:3: endpoint lacks sample rate attribute bit, cannot set.
[  180.220808] 4:2:4: endpoint lacks sample rate attribute bit, cannot set.
[  180.220936] 4:2:5: endpoint lacks sample rate attribute bit, cannot set.
[  180.224764] usbcore: registered new interface driver snd-usb-audio
[  180.311098] 4:2:2: endpoint lacks sample rate attribute bit, cannot set.
[  180.313775] 4:2:2: endpoint lacks sample rate attribute bit, cannot set.

Paweł Kuźniar
