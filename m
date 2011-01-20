Return-path: <mchehab@pedra>
Received: from gate2.psi.de ([192.109.111.186]:33056 "EHLO gate2.psi.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab1ATIFz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 03:05:55 -0500
Received: from infra-abg-ex01.psi.de (IntServMail.psi.de [172.18.2.21])
	by gate2.psi.de (8.12.8/8.11.3) with ESMTP id p0K7pneX005953
	for <linux-media@vger.kernel.org>; Thu, 20 Jan 2011 08:51:50 +0100
Received: from ee-z1.ee.psi (localhost [127.0.0.1])
	by z1.eemail.abg.psi.de (Postfix) with ESMTP id 3923A1700B6
	for <linux-media@vger.kernel.org>; Thu, 20 Jan 2011 08:51:49 +0100 (CET)
Received: from ee-imail (unknown [192.168.238.3])
	by z1.eemail.abg.psi.de (Postfix) with ESMTP id 48BA6170070
	for <linux-media@vger.kernel.org>; Thu, 20 Jan 2011 08:51:36 +0100 (CET)
Received: from [172.19.1.1] (helo=mail-srv)
	by ee-imail with esmtp (Exim 4.60)
	(envelope-from <fneufingerl@psi.de>)
	id 1PfpIp-0007KB-47
	for linux-media@vger.kernel.org; Thu, 20 Jan 2011 08:51:31 +0100
Received: from [172.19.11.122] (helo=dev-ws122.localnet)
	by mail-srv with esmtp (Exim 4.69)
	(envelope-from <fneufingerl@psi.de>)
	id 1PfpIk-00010A-1Y
	for linux-media@vger.kernel.org; Thu, 20 Jan 2011 08:51:26 +0100
From: Frank Neufingerl <fneufingerl@psi.de>
To: linux-media@vger.kernel.org
Subject: radio-si470x 4-2:1.2 ADS Technologies, Inc
Date: Thu, 20 Jan 2011 08:51:25 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201101200851.25815.fneufingerl@psi.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

can you help me, the ADS fm radio stick bring no audio


[854383.168611] radio-si470x 4-2:1.2: DeviceID=0x1242 ChipID=0x0a0f
[854383.169034] radio-si470x 4-2:1.2: software version 1, hardware version 7
[854383.169036] radio-si470x 4-2:1.2: This driver is known to work with software version 7,
[854383.169038] radio-si470x 4-2:1.2: but the device has software version 1.
[854383.169039] radio-si470x 4-2:1.2: If you have some trouble using this driver,
[854383.169040] radio-si470x 4-2:1.2: please report to V4L ML at linux-media@vger.kernel.org

#####################################################################

uname -a
Linux dev-ws122 2.6.32-27-generic #49-Ubuntu SMP Wed Dec 1 23:52:12 UTC 2010 i686 GNU/Linux

#####################################################################

Bus 004 Device 003: ID 06e1:a155 ADS Technologies, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x06e1 ADS Technologies, Inc.
  idProduct          0xa155 
  bcdDevice            1.00
  iManufacturer           1 ADS TECH
  iProduct                2 ADS InstantFM Music
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          145
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
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
        wTotalLength           43
        bInCollection           1
        baInterfaceNr( 0)       1
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0710 Radio Receiver
        bAssocTerminal          0
        bNrChannels             2
        wChannelConfig     0x0003
          Left Front (L)
          Right Front (R)
        iChannelNames           0 
        iTerminal               0 
      AudioControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 2
        bSourceID               1
        bControlSize            2
        bmaControls( 0)      0x01
        bmaControls( 0)      0x00
          Mute
        bmaControls( 1)      0x00
        bmaControls( 1)      0x00
        bmaControls( 2)      0x00
        bmaControls( 2)      0x00
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
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
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
        bDelay                  0 frames
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
        tSamFreq[ 0]        96000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         2 Decoded PCM samples
          wLockDelay              0 Decoded PCM samples
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     203
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              10
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
Device Status:     0x0000
  (Bus Powered)

########################################################

mplayer-checkout-2011-01-19$ ./mplayer -radio driver=v4l radio://103.0
MPlayer SVN-r32796-4.4.3 (C) 2000-2011 MPlayer Team
161 audio & 351 video codecs

Playing radio://103.0.
[radio] Using V4Lv1 radio interface.
[radio] ioctl set mute failed: Invalid argument
[radio] ioctl set volume failed: Invalid argument
[radio] Radio frequency parameter detected.
[radio] Using frequency: 103.00.
[radio] ioctl set mute failed: Invalid argument
[radio] ioctl set volume failed: Invalid argument
rawaudio file format detected.
==========================================================================
Opening audio decoder: [pcm] Uncompressed PCM audio decoder
AUDIO: 44100 Hz, 2 ch, s16le, 1411.2 kbit/100.00% (ratio: 176400->176400)
Selected audio codec: [pcm] afm: pcm (Uncompressed PCM)
==========================================================================
AO: [oss] 44100Hz 2ch s16le (2 bytes per sample)
Video: no video
Starting playback...
A: 151.9 (02:31.9) of 0.0 (unknown)  0.0% 


MPlayer interrupted by signal 2 in module: play_audio
A: 152.0 (02:31.9) of 0.0 (unknown)  0.0% 
[radio] ioctl set mute failed: Invalid argument
[radio] ioctl set volume failed: Invalid argument

Exiting... (Quit)





