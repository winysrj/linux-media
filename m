Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.opticvideo.com ([62.193.209.183]:35687 "EHLO
	vds-837105.amen-pro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620Ab1LOQiu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 11:38:50 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Thu, 15 Dec 2011 18:31:50 +0200
To: linux-media@vger.kernel.org
Subject: GrabBeeX - empia 2800 USB 2.0 - problem
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Adrian Sergiu DARABANT" <adrian@opticvideo.com>
Message-ID: <op.v6jhjck4p295gi@corei7.site>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
    I've got these kind of old usb 2.0 grabbers (GrabBeex) based on some  
em28xx chipsets that are not correctly identified under linux. Here is the  
dmesg log.
A video device is created but there are no controls in v4l-info and dmesg  
seems to see that everything is probably not correctly detected. I have a  
few of the so I can send one for testing if needed - but I would be  
interested in making it working.Also there is no grab button as the dmesg  
log suggests !

In Windows 7 - the update system finds and installs an empia 2800 driver -  
appears as an USB 2800 device in the device list. On Windows the are  
controls and the device works as expected.

Thx
Adrian

[25966.853726] em28xx: New device @ 480 Mbps (eb1a:2800, interface 0,  
class 0)
[25966.853965] em28xx #0: chip ID is em2800
[25966.957709] em28xx #0: board has no eeprom
[25967.017502] em28xx #0: preparing read at i2c address 0x60 failed  
(error=-19)
[25967.053604] em28xx #0: Identified as Unknown EM2800 video grabber  
(card=0)
[25968.190585] em28xx #0: found i2c device @ 0x4a [saa7113h]
[25970.884130] em28xx #0: Your board has no unique USB ID.
[25970.884136] em28xx #0: A hint were successfully done, based on i2c  
devicelist hash.
[25970.884140] em28xx #0: This method is not 100% failproof.
[25970.884143] em28xx #0: If the board were missdetected, please email  
this log to:
[25970.884145] em28xx #0:       V4L Mailing List   
<linux-media@vger.kernel.org>
[25970.884149] em28xx #0: Board detected as EM2860/SAA711X Reference Design
[25970.884153] em28xx #0: Registering snapshot button...
[25970.884278] input: em28xx snapshot button as  
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/input/input19
[25970.888795] em28xx #0: Config register raw data: 0xa4
[25970.888800] em28xx #0: I2S Audio (3 sample rates)
[25970.888804] em28xx #0: No AC97 audio processor
[25970.939649] em28xx #0: v4l2 driver version 0.1.2
[25971.386698] em28xx #0: V4L2 video device registered as video1
[25971.386705] em28xx-audio.c: probing for em28x1 non standard usbaudio
[25971.386708] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger



lsusb -v -d eb1a:2800

Bus 002 Device 004: ID eb1a:2800 eMPIA Technology, Inc. Terratec Cinergy  
200
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0xeb1a eMPIA Technology, Inc.
   idProduct          0x2800 Terratec Cinergy 200
   bcdDevice            1.00
   iManufacturer           0
   iProduct                0
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength          129
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
         wMaxPacketSize     0x0284  1x 644 bytes
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
         wMaxPacketSize     0x0a84  2x 644 bytes
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
