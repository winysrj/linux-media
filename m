Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3993 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2AMN3R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 08:29:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: Two devices, same USB ID: one needs HID, the other doesn't. How to solve this?
Date: Fri, 13 Jan 2012 14:29:03 +0100
Cc: linux-input@vger.kernel.org,
	"linux-media" <linux-media@vger.kernel.org>
References: <201201131142.33779.hverkuil@xs4all.nl> <0ce7bf77-b04f-49e2-8cbe-9c01d17a5cf1@email.android.com>
In-Reply-To: <0ce7bf77-b04f-49e2-8cbe-9c01d17a5cf1@email.android.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_fGDEPbXmw1zSbb0"
Message-Id: <201201131429.03417.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_fGDEPbXmw1zSbb0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Friday, January 13, 2012 12:16:51 Andy Walls wrote:
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> >Hi!
> >
> >I've made a video4linux driver for the USB Keene FM Transmitter. See:
> >
> >http://www.amazon.co.uk/Keene-Electronics-USB-FM-Transmitter/dp/B003GCHPDY/ref=sr_1_1?ie=UTF8&qid=1326450476&sr=8-1
> >
> >The driver code is here:
> >
> >http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/keene
> >
> >Unfortunately this device has exactly the same USB ID as the Logitech
> >AudioHub
> >USB speaker (http://www.logitech.com/en-us/439/3503).
> >
> >The AudioHub has HID support for volume keys, but the FM transmitter
> >needs
> >a custom V4L2 driver instead.
> >
> >I've attached the full lsusb -v output of both devices, but this is the
> >diff of
> >the two:
> >
> >$ diff keene.txt audiohub.txt -u
> >--- keene.txt   2012-01-13 11:10:48.265399953 +0100
> >+++ audiohub.txt        2012-01-13 11:09:45.185398935 +0100
> >@@ -1,5 +1,5 @@
> > 
> >-Bus 007 Device 009: ID 046d:0a0e Logitech, Inc. 
> >+Bus 003 Device 004: ID 046d:0a0e Logitech, Inc. 
> > Device Descriptor:
> >   bLength                18
> >   bDescriptorType         1
> >@@ -12,7 +12,7 @@
> >   idProduct          0x0a0e 
> >   bcdDevice            1.00
> >   iManufacturer           1 HOLTEK 
> >-  iProduct                2 B-LINK USB Audio  
> >+  iProduct                2 AudioHub Speaker
> >   iSerial                 0 
> >   bNumConfigurations      1
> >   Configuration Descriptor:
> >@@ -22,9 +22,8 @@
> >     bNumInterfaces          3
> >     bConfigurationValue     1
> >     iConfiguration          0 
> >-    bmAttributes         0xa0
> >+    bmAttributes         0x80
> >       (Bus Powered)
> >-      Remote Wakeup
> >     MaxPower              500mA
> >     Interface Descriptor:
> >       bLength                 9
> >@@ -152,7 +151,7 @@
> >           bCountryCode            0 Not supported
> >           bNumDescriptors         1
> >           bDescriptorType        34 Report
> >-          wDescriptorLength      22
> >+          wDescriptorLength      31
> >          Report Descriptors: 
> >            ** UNAVAILABLE **
> >       Endpoint Descriptor:
> >
> >As you can see, the differences are very small.
> >
> >In my git tree I worked around it by adding the USB ID to the ignore
> >list
> >if the Keene driver is enabled, and ensuring that the Keene driver is
> >disabled by default.
> >
> >But is there a better method to do this? At least the iProduct strings
> >are
> >different, is that something that can be tested in hid-core.c?
> >
> >Regards,
> >
> >	Hans
> 
> Maybe it doesn't matter, but what do the Report Descriptors look like?
> 
> http://www.slashdev.ca/2010/05/08/get-usb-report-descriptor-with-linux/

Attached the new lsusb outputs, this time with the report descriptor.

Note that if I plug in the Keene transmitter, then no input device is
created:

Jan 13 14:25:12 tschai kernel: [ 1686.020166] usb 7-4: new full-speed USB device number 3 using ohci_hcd
Jan 13 14:25:12 tschai kernel: [ 1686.248735] generic-usb 0003:046D:0A0E.0009: hiddev0,hidraw4: USB HID v1.10 Device [HOLTEK  B-LINK USB Audio  ] on usb-0000:00:16.0-4/input2

Compare that to what happens when the audiohub is plugged in:

Jan 13 14:25:49 tschai kernel: [ 1722.820125] usb 3-4: new high-speed USB device number 6 using ehci_hcd
Jan 13 14:25:49 tschai kernel: [ 1722.973529] hub 3-4:1.0: USB hub found
Jan 13 14:25:49 tschai kernel: [ 1722.973960] hub 3-4:1.0: 4 ports detected
Jan 13 14:25:49 tschai kernel: [ 1723.250629] usb 3-4.4: new full-speed USB device number 7 using ehci_hcd
Jan 13 14:25:49 tschai kernel: [ 1723.390888] input: HOLTEK  AudioHub Speaker as /devices/pci0000:00/0000:00:16.2/usb3/3-4/3-4.4/3-4.4:1.2/input/input12
Jan 13 14:25:49 tschai kernel: [ 1723.391176] generic-usb 0003:046D:0A0E.000A: input,hidraw4: USB HID v1.10 Device [HOLTEK  AudioHub Speaker] on usb-0000:00:16.2-4.4/input2

I'm no expert on usb and HID, so I hope someone can point me to a better solution.

Regards,

	Hans

--Boundary-00=_fGDEPbXmw1zSbb0
Content-Type: text/plain;
  charset="UTF-8";
  name="audiohub.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="audiohub.txt"


Bus 003 Device 004: ID 046d:0a0e Logitech, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0x0a0e 
  bcdDevice            1.00
  iManufacturer           1 HOLTEK 
  iProduct                2 AudioHub Speaker
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          135
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
        wTotalLength           40
        bInCollection           1
        baInterfaceNr( 0)       1
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bNrChannels             2
        wChannelConfig     0x0003
          Left Front (L)
          Right Front (R)
        iChannelNames           0 
        iTerminal               0 
      AudioControl Interface Descriptor:
        bLength                10
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                13
        bSourceID               1
        bControlSize            1
        bmaControls( 0)      0x03
          Mute Control
          Volume Control
        bmaControls( 1)      0x00
        bmaControls( 2)      0x00
        iFeature                0 
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0301 Speaker
        bAssocTerminal          0
        bSourceID              13
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
        bTerminalLink           1
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
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            9
          Transfer Type            Isochronous
          Synch Type               Adaptive
          Usage Type               Data
        wMaxPacketSize     0x00c0  1x 192 bytes
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
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      31
          Report Descriptor: (length is 31)
            Item(Global): Usage Page, data= [ 0x0c ] 12
                            Consumer
            Item(Local ): Usage, data= [ 0x01 ] 1
                            Consumer Control
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0x01 ] 1
            Item(Local ): Usage, data= [ 0xe9 ] 233
                            Volume Increment
            Item(Local ): Usage, data= [ 0xea ] 234
                            Volume Decrement
            Item(Global): Report Size, data= [ 0x01 ] 1
            Item(Global): Report Count, data= [ 0x02 ] 2
            Item(Main  ): Input, data= [ 0x2a ] 42
                            Data Variable Absolute Wrap Linear
                            No_Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Local ): Usage, data= [ 0xe2 ] 226
                            Mute
            Item(Global): Report Count, data= [ 0x01 ] 1
            Item(Main  ): Input, data= [ 0x2e ] 46
                            Data Variable Relative Wrap Linear
                            No_Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report Count, data= [ 0x05 ] 5
            Item(Main  ): Input, data= [ 0x01 ] 1
                            Constant Array Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Main  ): End Collection, data=none
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              48
Device Status:     0x0000
  (Bus Powered)

--Boundary-00=_fGDEPbXmw1zSbb0
Content-Type: text/plain;
  charset="UTF-8";
  name="keene.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="keene.txt"


Bus 007 Device 002: ID 046d:0a0e Logitech, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0x0a0e 
  bcdDevice            1.00
  iManufacturer           1 HOLTEK 
  iProduct                2 B-LINK USB Audio  
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          135
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
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
        wTotalLength           40
        bInCollection           1
        baInterfaceNr( 0)       1
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bNrChannels             2
        wChannelConfig     0x0003
          Left Front (L)
          Right Front (R)
        iChannelNames           0 
        iTerminal               0 
      AudioControl Interface Descriptor:
        bLength                10
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                13
        bSourceID               1
        bControlSize            1
        bmaControls( 0)      0x03
          Mute Control
          Volume Control
        bmaControls( 1)      0x00
        bmaControls( 2)      0x00
        iFeature                0 
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0301 Speaker
        bAssocTerminal          0
        bSourceID              13
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
        bTerminalLink           1
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
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            9
          Transfer Type            Isochronous
          Synch Type               Adaptive
          Usage Type               Data
        wMaxPacketSize     0x00c0  1x 192 bytes
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
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      22
          Report Descriptor: (length is 22)
            Item(Global): Usage Page, data= [ 0x00 0xff ] 65280
                            (null)
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0xff ] 255
            Item(Local ): Usage Minimum, data= [ 0x00 ] 0
                            (null)
            Item(Local ): Usage Maximum, data= [ 0x01 ] 1
                            (null)
            Item(Global): Report Count, data= [ 0x08 ] 8
            Item(Global): Report Size, data= [ 0x08 ] 8
            Item(Main  ): Output, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Main  ): End Collection, data=none
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              48
Device Status:     0x0000
  (Bus Powered)

--Boundary-00=_fGDEPbXmw1zSbb0--
