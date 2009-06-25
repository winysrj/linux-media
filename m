Return-path: <linux-media-owner@vger.kernel.org>
Received: from col0-omc4-s15.col0.hotmail.com ([65.55.34.217]:17288 "EHLO
	col0-omc4-s15.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760155AbZFYFRX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 01:17:23 -0400
Message-ID: <COL103-W1055421B0E48007A57D79988340@phx.gbl>
From: George Adams <g_adams27@hotmail.com>
To: <dheitmueller@kernellabs.com>
CC: <linux-media@vger.kernel.org>, <video4linux-list@redhat.com>
Subject: RE: [PARTIALLY SOLVED] Can't use my Pinnacle PCTV HD Pro stick -
 what am I doing wrong?
Date: Thu, 25 Jun 2009 01:17:25 -0400
In-Reply-To: <829197380906221453pa0738b4j6fb7c4b045f6aa1@mail.gmail.com>
References: <COL103-W53605D85359D631FC60D0F88380@phx.gbl>
	 <COL103-W40B198179C2E84587DC71F88380@phx.gbl>
 	 <829197380906211429k7176a93fm49d49851e6d2df1e@mail.gmail.com>
 	 <COL103-W308B321250A646D788B25188390@phx.gbl>
 <829197380906221453pa0738b4j6fb7c4b045f6aa1@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello!  In a last ditch effort, I decided to try downloading a v4l driver snapshot from February back when I had my Pinnacle HD Pro Stick device working.  To my amazement, the old drivers worked!

By process of elimination (trying newer and newer drivers until my Pinnacle device was once again not recognized), it appears that changeset 11331 (http://linuxtv.org/hg/v4l-dvb/rev/00525b115901), from Mar. 31 2009, is the first one that causes my device to not be recognized.  This is the changeset that updated the em28xx driver from 0.1.1 to 0.1.2.  Here, again, is the dmesg output from a newer driver that does NOT work (this one from a driver set one day later, on Apr. 1, 2009):

[   50.028008] Vortex: init.... Linux video capture interface: v2.00
[   50.300176] em28xx: New device Pinnacle Systems PCTV 800e @ 480 Mbps (2304:0227, interface 0, class 0)
[   50.312863] em28xx #0: Identified as Pinnacle PCTV HD Pro Stick (card=17)
[   50.325625] em28xx #0: chip ID is em2882/em2883
[   50.539728] em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 27 02 d0 12 5c 03 8e 16 a4 1c
[   50.552582] em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00 00 00
[   50.565276] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
[   50.577939] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
[   50.590583] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   50.603076] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   50.615380] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00 69 00
[   50.627589] em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
[   50.639651] em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00 16 03
[   50.651573] em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00 38 00 30 00 30 00
[   50.663407] em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00 31 00 30 00 30 00
[   50.675144] em28xx #0: i2c eeprom b0: 31 00 30 00 33 00 39 00 34 00 34 00 32 00 00 00
[   50.686680] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   50.698183] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   50.698187] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   50.698193] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   50.698197] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x2de5abbf
[   50.698198] em28xx #0: EEPROM info:
[   50.698199] em28xx #0:       AC97 audio (5 sample rates)
[   50.698200] em28xx #0:       500mA max power
[   50.698201] em28xx #0:       Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
[   50.805990] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb7/7-3/input/input6
[   50.901902] em28xx #0: Config register raw data: 0xd0
[   50.913510] em28xx #0: AC97 vendor ID = 0xffffffff
[   50.924746] em28xx #0: AC97 features = 0x6a90
[   50.935543] em28xx #0: Empia 202 AC97 audio processor detected
[   51.034109] em28xx #0: v4l2 driver version 0.1.2
[   51.128411] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[   51.139183] usbcore: registered new interface driver em28xx
[   51.149961] em28xx driver loaded
[   51.496978] xc2028 0-0061: creating new instance
[   51.521582] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[   51.532725] em28xx #0/2: xc3028 attached
[   51.546910] DVB: registering new adapter (em28xx #0)
[   51.570086] DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
[   51.581731] Successfully loaded em28xx-dvb
[   51.593250] Em28xx: Initialized (Em28xx dvb Extension) extension

and here is a successful dmesg using the changeset 11330 drivers from early morning Mar. 31, 2009, right before the em28xx version bump from 0.1.1 to 0.1.2

[   48.484051] Linux video capture interface: v2.00
[   48.597772] em28xx: New device Pinnacle Systems PCTV 800e @ 480 Mbps (2304:0227, interface 0, class 0)
[   48.610698] em28xx #0: Identified as Pinnacle PCTV HD Pro Stick (card=17)
[   48.623638] ACPI: PCI Interrupt 0000:06:01.0[A] -> em28xx #0: chip ID is em2882/em2883
[   48.877223] em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 27 02 d0 12 5c 03 8e 16 a4 1c
[   48.889807] em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00 00 00
[   48.902235] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
[   48.914771] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
[   48.927131] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   48.939329] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   48.951368] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00 69 00
[   48.963320] em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
[   48.975173] em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00 16 03
[   48.986933] em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00 38 00 30 00 30 00
[   48.998563] em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00 31 00 30 00 30 00
[   49.010036] em28xx #0: i2c eeprom b0: 31 00 30 00 33 00 39 00 34 00 34 00 32 00 00 00
[   49.021412] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   49.032663] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   49.043684] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   49.054604] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   49.065433] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x2de5abbf
[   49.076067] em28xx #0: EEPROM info:
[   49.086543] em28xx #0:       AC97 audio (5 sample rates)
[   49.097031] em28xx #0:       500mA max power
[   49.107535] em28xx #0:       Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
[   49.133912] tvp5150' 0-005c: chip found @ 0xb8 (em28xx #0)
[   49.187077] Vortex: init.... tuner' 0-0061: chip found @ 0xc2 (em28xx #0)
[   49.339702] xc2028 0-0061: creating new instance
[   49.350347] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[   49.535114] xc2028 0-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[   49.607496] xc2028 0-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
[   50.562362] xc2028 0-0061: Loading firmware for type=MTS (4), id 000000000000b700.
[   50.588826] xc2028 0-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[   50.822296] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb7/7-3/input/input6
[   50.912302] em28xx #0: Config register raw data: 0xd0
[   50.925029] em28xx #0: AC97 vendor ID = 0xffffffff
[   50.937390] em28xx #0: AC97 features = 0x6a90
[   50.949396] em28xx #0: Empia 202 AC97 audio processor detected
[   51.112296] tvp5150' 0-005c: tvp5150am1 detected.
[   51.222535] em28xx #0: v4l2 driver version 0.1.1
[   51.338304] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[   51.350590] usbcore: registered new interface driver em28xx
[   51.362736] em28xx driver loaded
[   51.575368] xc2028 0-0061: attaching existing instance
[   51.587569] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[   51.599746] em28xx #0/2: xc3028 attached
[   51.611796] DVB: registering new adapter (em28xx #0)
[   51.623825] DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
[   51.636297] Successfully loaded em28xx-dvb
[   51.648448] Em28xx: Initialized (Em28xx dvb Extension) extension
[   77.339398] tvp5150' 0-005c: tvp5150am1 detected.

Notice that the tvp5150 device is being recognized and the firmware from /lib/firmware/xc3028-v27.fw is being loaded.

If need be, I guess I can continue to use this changeset, the last known revision of the em28xx drivers that work with my card.  But I thought I'd mention my discovery, in case someone more clever than I can discover what happened that caused the problem.  (Devin, I know you mentioned that you have the same Pinnacle device that I have, and yet yours still works even under the most recent drivers.  Could we have slightly different devices, with mine containing some "feature" that has caused it to stop functioning with the latest em28xx drivers?)

Again, thanks to everyone who helped.  If this should go in a bug report, I will happy to do so if someone indicates that.

(This is the "lsusb" info for my device, in case it needs to be more clearly identified):

> lsusb -v -s 7:2

Bus 007 Device 002: ID 2304:0227 Pinnacle Systems, Inc. [hex] 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x2304 Pinnacle Systems, Inc. [hex]
  idProduct          0x0227 
  bcdDevice            1.10
  iManufacturer           3 Pinnacle Systems
  iProduct                1 PCTV 800e
  iSerial                 2 061001039442
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          305
    bNumInterfaces          1
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
      bNumEndpoints           4
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
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               4
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
      bNumEndpoints           4
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
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       2
      bNumEndpoints           4
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
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       3
      bNumEndpoints           4
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
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       4
      bNumEndpoints           4
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
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       5
      bNumEndpoints           4
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
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       6
      bNumEndpoints           4
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
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       7
      bNumEndpoints           4
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
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
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

_________________________________________________________________
Insert movie times and more without leaving Hotmail®.
http://windowslive.com/Tutorial/Hotmail/QuickAdd?ocid=TXT_TAGLM_WL_HM_Tutorial_QuickAdd_062009