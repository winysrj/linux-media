Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.itb.ac.id ([167.205.1.67]:58183 "EHLO mx2.ITB.ac.id"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab2EFLeJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 May 2012 07:34:09 -0400
Received: from av1.itb.ac.id (av1.itb.ac.id [167.205.1.71])
	by mx2.ITB.ac.id (Postfix) with ESMTP id D8FC025D9E
	for <linux-media@vger.kernel.org>; Sun,  6 May 2012 18:35:24 +0700 (WIT)
Received: from mx2.ITB.ac.id ([167.205.1.67])
	by av1.itb.ac.id (av1.itb.ac.id [167.205.1.73]) (amavisd-new, port 10002)
	with ESMTP id whJDqe6qE4hq for <linux-media@vger.kernel.org>;
	Sun,  6 May 2012 18:33:55 +0700 (WIT)
Received: from mx6.ITB.ac.id (mx6.itb.ac.id [167.205.23.26])
	by mx2.ITB.ac.id (Postfix) with ESMTP id B567325D8C
	for <linux-media@vger.kernel.org>; Sun,  6 May 2012 18:35:14 +0700 (WIT)
Received: from [192.168.1.124] (hme-133.ee.itb.ac.id [167.205.64.133])
	(Authenticated sender: rizal.m.nur@ITB.ac.id)
	by mx6.ITB.ac.id (Postfix) with ESMTPSA id 5AC0722823
	for <linux-media@vger.kernel.org>; Sun,  6 May 2012 18:38:51 +0700 (WIT)
Message-ID: <4FA661A3.3000303@arc.itb.ac.id>
Date: Sun, 06 May 2012 18:33:55 +0700
From: Rizal <rizal.m.nur@arc.itb.ac.id>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problems with USBTVTunner Gadmei UTV380New [id=1f71:3301]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Model = Gadmei UTV380New
Vendor/ProductID = 1f71:3301
Test =
- I follow instruction on link
http://www.linuxtv.org/wiki/index.php?title=Gadmei_USB_TVBox_UTV380
- I change "SB_DEVICE(0xeb1a, 0x50a3)" with "SB_DEVICE(0x1f71, 0x3301)"
- after i compile ("make distsclean", "make menuconfig", "make", and "make
install") then connect tvTunner to my PC
- I get error like this
#dmesg
...
...
[ 9643.782870] usb 2-1: USB disconnect, address 5
[ 9819.912068] usb 2-1: new high speed USB device using ehci_hcd and
address 6
[ 9820.047446] usb 2-1: config 1 interface 0 altsetting 1 bulk endpoint
0x83 has invalid maxpacket 256
[ 9820.063627] v4l2_common: disagrees about version of symbol
v4l2_device_register_subdev
[ 9820.063635] v4l2_common: Unknown symbol v4l2_device_register_subdev
(err -22)
[ 9820.063813] v4l2_common: disagrees about version of symbol
v4l2_device_unregister_subdev
[ 9820.063818] v4l2_common: Unknown symbol v4l2_device_unregister_subdev
(err -22)

- Here output from "lsusb"
#lsusb
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 005: ID 1f71:3301
Bus 002 Device 002: ID 04f2:b044 Chicony Electronics Co., Ltd Acer
CrystalEye Webcam
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

(1f71:3301<- my tvTunner ID)

#lsusb -v -d 1f71:3301
Bus 002 Device 006: ID 1f71:3301
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x1f71
   idProduct          0x3301
   bcdDevice            1.00
   iManufacturer           3 Gadmei
   iProduct                4 USB TV Box
   iSerial                 2 330000000009
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           83
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
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0000  1x 0 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               4
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
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x1400  3x 1024 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0100  1x 256 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               4
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

###########################
i dont know how to solve it. anyone know?

regards,

-- 
Rizal Muhammad Nur

