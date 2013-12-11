Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43870 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3LKOlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 09:41:00 -0500
Received: by mail-we0-f174.google.com with SMTP id q58so6523746wes.19
        for <linux-media@vger.kernel.org>; Wed, 11 Dec 2013 06:40:59 -0800 (PST)
Received: from [192.168.0.3] ([109.174.168.73])
        by mx.google.com with ESMTPSA id n6sm15485559wix.3.2013.12.11.06.40.57
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 11 Dec 2013 06:40:58 -0800 (PST)
Message-ID: <52A87980.1050603@chamonix.reportlab.co.uk>
Date: Wed, 11 Dec 2013 14:41:04 +0000
From: Robin Becker <robin@reportlab.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: pctv 290e fails with kernel 3.12.3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Apologies if this is the wrong place to report this. I am running arch linux on 
a 64 bit machine. Currently I am stuck on

Linux bunyip 3.12.2-1-ARCH #1 SMP PREEMPT Fri Nov 29 21:14:15 CET 2013 x86_64 
GNU/Linux

If I upgrade to the next kernel in line linux-3.12.3-1-x86_64.pkg.tar.xz I see 
failures during boot and my two usb tv devices fail.

 From lsusb -v

> Bus 002 Device 005: ID 2013:024f PCTV Systems nanoStick T2 290e
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x2013 PCTV Systems
>   idProduct          0x024f nanoStick T2 290e
>   bcdDevice            1.00
>   iManufacturer           1 PCTV Systems
>   iProduct                2 PCTV 290e
>   iSerial                 3 00000010V0M9
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           55
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       1
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x03ac  1x 940 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>        bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x03ac  1x 940 bytes
>         bInterval               1
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0000
>   (Bus Powered)
>
> Bus 002 Device 004: ID 2013:024f PCTV Systems nanoStick T2 290e
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x2013 PCTV Systems
>   idProduct          0x024f nanoStick T2 290e
>   bcdDevice            1.00
>   iManufacturer           1 PCTV Systems
>   iProduct                2 PCTV 290e
>   iSerial                 3 000000101286
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           55
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       1
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x03ac  1x 940 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x03ac  1x 940 bytes
>         bInterval               1
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0000
>   (Bus Powered)


when booting with linux-3.12.3 I see the following in my systemd journal
> Dec 07 18:33:35 bunyip kernel: media: Linux media interface: v0.10
> Dec 07 18:33:35 bunyip systemd[1]: Found device Hitachi_HTS543216L9A300.
> Dec 07 18:33:35 bunyip systemd[1]: Activating swap /dev/disk/by-uuid/6ea19458-0015-4b1f-b2f5-8f3dea92a88a...
> Dec 07 18:33:35 bunyip kernel: Linux video capture interface: v2.00
> Dec 07 18:33:35 bunyip kernel: ath: EEPROM regdomain: 0x65
> Dec 07 18:33:35 bunyip kernel: ath: EEPROM indicates we should expect a direct regpair map
> Dec 07 18:33:35 bunyip kernel: ath: Country alpha2 being used: 00
> Dec 07 18:33:35 bunyip kernel: ath: Regpair used: 0x65
> Dec 07 18:33:35 bunyip kernel: ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> Dec 07 18:33:35 bunyip kernel: ath5k: phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
> Dec 07 18:33:35 bunyip kernel: em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps (2013:024f, interface 0, class 0)
> Dec 07 18:33:35 bunyip kernel: em28xx: DVB interface 0 found: isoc
> Dec 07 18:33:35 bunyip kernel: em28xx: chip ID is em28174
> Dec 07 18:33:35 bunyip kernel: usbcore: registered new interface driver usbserial
> Dec 07 18:33:35 bunyip kernel: usbcore: registered new interface driver usbserial_generic
> Dec 07 18:33:35 bunyip kernel: usbserial: USB Serial support registered for generic
> Dec 07 18:33:35 bunyip kernel: usbcore: registered new interface driver ftdi_sio
> Dec 07 18:33:35 bunyip kernel: usbserial: USB Serial support registered for FTDI USB Serial Device
> Dec 07 18:33:35 bunyip kernel: usb 2-4: Ignoring serial port reserved for JTAG
> Dec 07 18:33:35 bunyip kernel: ftdi_sio 2-4:1.1: FTDI USB Serial Device converter detected
> Dec 07 18:33:35 bunyip kernel: usb 2-4: Detected FT2232C
> Dec 07 18:33:35 bunyip kernel: usb 2-4: Number of endpoints 2
> Dec 07 18:33:35 bunyip kernel: usb 2-4: Endpoint 1 MaxPacketSize 64
> Dec 07 18:33:35 bunyip kernel: usb 2-4: Endpoint 2 MaxPacketSize 64
> Dec 07 18:33:35 bunyip kernel: usb 2-4: Setting MaxPacketSize 64
> Dec 07 18:33:35 bunyip kernel: usb 2-4: FTDI USB Serial Device converter now attached to ttyUSB0
> Dec 07 18:33:35 bunyip kernel: usb 2-4: Ignoring serial port reserved for JTAG
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 0000: 26 00 01 00 02 09 d8 85 80 80 e5 80 f4 f5 94 90
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 0010: 78 0d e4 f0 f5 46 12 00 5a c2 eb c2 e8 30 e9 03
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 0020: 12 09 de 30 eb 03 12 09 10 30 ec f1 12 07 72 80
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 0030: ec 00 60 00 e5 f5 64 01 60 09 e5 f5 64 09 60 03
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 0040: c2 c6 22 e5 f7 b4 03 13 e5 f6 b4 87 03 02 09 92
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 0050: e5 f6 b4 93 03 02 07 e6 c2 c6 22 c2 c6 22 12 09
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 0060: cf 02 06 19 1a eb 67 95 13 20 4f 02 c0 13 6b 10
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 0070: a0 1a ba 14 ce 1a 39 57 00 5c 18 00 00 00 00 00
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 0080: 00 00 00 00 44 36 00 00 f0 10 02 00 00 00 00 00
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 0090: 5b 23 c0 00 00 00 20 40 20 80 02 20 01 01 00 00
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 00b0: c6 40 00 00 00 00 a7 00 00 00 00 00 00 00 00 00
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 32
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 00d0: 34 31 30 31 31 36 36 30 31 37 31 31 33 35 31 32
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 00e0: 38 36 00 4f 53 49 30 30 33 30 38 44 30 31 31 30
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 00f0: 31 32 38 36 00 00 00 00 00 00 00 00 00 00 31 30
> Dec 07 18:33:35 bunyip kernel: em28174 #0: i2c eeprom 0100: ... (skipped)
> Dec 07 18:33:35 bunyip kernel: em28174 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x9de637c6
> Dec 07 18:33:35 bunyip kernel: em28174 #0: EEPROM info:
> Dec 07 18:33:35 bunyip kernel: em28174 #0:         microcode start address = 0x0004, boot configuration = 0x01
> Dec 07 18:33:35 bunyip kernel: em28174 #0:         No audio on board.
> Dec 07 18:33:35 bunyip kernel: em28174 #0:         500mA max power
> Dec 07 18:33:35 bunyip kernel: em28174 #0:         Table at offset 0x39, strings=0x1aa0, 0x14ba, 0x1ace
> Dec 07 18:33:35 bunyip kernel: em28174 #0: Identified as PCTV nanoStick T2 290e (card=78)
> Dec 07 18:33:35 bunyip kernel: em28174 #0: v4l2 driver version 0.2.0
> Dec 07 18:33:35 bunyip kernel: em28174 #0: V4L2 video device registered as video0
> Dec 07 18:33:35 bunyip kernel: em28174 #0: dvb set to isoc mode.
> Dec 07 18:33:35 bunyip kernel: em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps (2013:024f, interface 0, class 0)
> Dec 07 18:33:35 bunyip kernel: em28xx: DVB interface 0 found: isoc
> Dec 07 18:33:35 bunyip kernel: em28xx: chip ID is em28174
> Dec 07 18:33:35 bunyip kernel: input: HDA NVidia HDMI/DP,pcm=3 Phantom as /devices/pci0000:00/0000:00:08.0/sound/card0/input9
> Dec 07 18:33:35 bunyip kernel: input: HDA NVidia Headphone as /devices/pci0000:00/0000:00:08.0/sound/card0/input8
> Dec 07 18:33:35 bunyip kernel: input: HDA NVidia Mic as /devices/pci0000:00/0000:00:08.0/sound/card0/input7
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 0000: 26 00 01 00 02 09 d8 85 80 80 e5 80 f4 f5 94 90
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 0010: 78 0d e4 f0 f5 46 12 00 5a c2 eb c2 e8 30 e9 03
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 0020: 12 09 de 30 eb 03 12 09 10 30 ec f1 12 07 72 80
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 0030: ec 00 60 00 e5 f5 64 01 60 09 e5 f5 64 09 60 03
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 0040: c2 c6 22 e5 f7 b4 03 13 e5 f6 b4 87 03 02 09 92
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 0050: e5 f6 b4 93 03 02 07 e6 c2 c6 22 c2 c6 22 12 09
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 0060: cf 02 06 19 1a eb 67 95 13 20 4f 02 c0 13 6b 10
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 0070: a0 1a ba 14 ce 1a 39 57 00 5c 18 00 00 00 00 00
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 0080: 00 00 00 00 44 36 00 00 f0 10 02 00 00 00 00 00
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 0090: 5b 23 c0 00 00 00 20 40 20 80 02 20 01 01 00 00
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 00b0: c6 40 00 00 00 00 a7 00 00 00 00 00 00 00 00 00
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 32
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 00d0: 34 31 30 31 31 36 36 30 31 37 31 32 34 37 56 30
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 00e0: 4d 39 00 4f 53 49 30 30 33 30 38 44 30 31 31 30
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 00f0: 56 30 4d 39 00 00 00 00 00 00 00 00 00 00 31 30
> Dec 07 18:33:35 bunyip kernel: em28174 #1: i2c eeprom 0100: ... (skipped)
> Dec 07 18:33:35 bunyip kernel: em28174 #1: EEPROM ID = 26 00 01 00, EEPROM hash = 0x924125c8
> Dec 07 18:33:35 bunyip kernel: em28174 #1: EEPROM info:
> Dec 07 18:33:35 bunyip kernel: em28174 #1:         microcode start address = 0x0004, boot configuration = 0x01
> Dec 07 18:33:35 bunyip kernel: em28174 #1:         No audio on board.
> Dec 07 18:33:35 bunyip kernel: em28174 #1:         500mA max power
> Dec 07 18:33:35 bunyip kernel: em28174 #1:         Table at offset 0x39, strings=0x1aa0, 0x14ba, 0x1ace
> Dec 07 18:33:35 bunyip kernel: em28174 #1: Identified as PCTV nanoStick T2 290e (card=78)
> Dec 07 18:33:35 bunyip kernel: em28174 #1: v4l2 driver version 0.2.0
> Dec 07 18:33:35 bunyip kernel: em28174 #1: V4L2 video device registered as video1
> Dec 07 18:33:35 bunyip kernel: em28174 #1: dvb set to isoc mode.
> Dec 07 18:33:35 bunyip kernel: usbcore: registered new interface driver em28xx
> Dec 07 18:33:35 bunyip kernel: tda18271 3-0060: creating new instance
> Dec 07 18:33:35 bunyip kernel: tda18271_read_regs: [3-0060|M] ERROR: i2c_transfer returned: -19
> Dec 07 18:33:35 bunyip kernel: Error reading device ID @ 3-0060, bailing out.
> Dec 07 18:33:35 bunyip kernel: tda18271_attach: [3-0060|M] error -5 on line 1285
> Dec 07 18:33:35 bunyip kernel: tda18271 3-0060: destroying instance
> Dec 07 18:33:35 bunyip systemd[1]: Activated swap /dev/disk/by-uuid/6ea19458-0015-4b1f-b2f5-8f3dea92a88a.
> Dec 07 18:33:35 bunyip systemd[1]: Starting Swap.
> Dec 07 18:33:35 bunyip systemd[1]: Reached target Swap.
> Dec 07 18:33:35 bunyip systemd[1]: Starting System Initialization.
> Dec 07 18:33:35 bunyip kernel: tda18271 5-0060: creating new instance
> Dec 07 18:33:35 bunyip kernel: tda18271_read_regs: [5-0060|M] ERROR: i2c_transfer returned: -19
> Dec 07 18:33:35 bunyip kernel: Error reading device ID @ 5-0060, bailing out.
> Dec 07 18:33:35 bunyip kernel: tda18271_attach: [5-0060|M] error -5 on line 1285
> Dec 07 18:33:35 bunyip kernel: tda18271 5-0060: destroying instance
> Dec 07 18:33:35 bunyip kernel: Em28xx: Initialized (Em28xx dvb Extension) extension
> Dec 07 18:33:35 bunyip kernel: Registered IR keymap rc-pinnacle-pctv-hd
> Dec 07 18:33:35 bunyip kernel: input: em28xx IR (em28174 #0) as /devices/pci0000:00/0000:00:04.1/usb1/1-3/1-3.1/rc/rc0/input10
> Dec 07 18:33:35 bunyip kernel: rc0: em28xx IR (em28174 #0) as /devices/pci0000:00/0000:00:04.1/usb1/1-3/1-3.1/rc/rc0
> Dec 07 18:33:35 bunyip kernel: Registered IR keymap rc-pinnacle-pctv-hd
> Dec 07 18:33:35 bunyip kernel: input: em28xx IR (em28174 #1) as /devices/pci0000:00/0000:00:04.1/usb1/1-3/1-3.2/rc/rc1/input11
> Dec 07 18:33:35 bunyip kernel: rc1: em28xx IR (em28174 #1) as /devices/pci0000:00/0000:00:04.1/usb1/1-3/1-3.2/rc/rc1
> Dec 07 18:33:35 bunyip kernel: Em28xx: Initialized (Em28xx Input Extension) extension

two other users of Arch linux report the same or similar issue.
-- 
Robin Becker
