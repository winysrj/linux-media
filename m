Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8JLc2DW008571
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 17:38:02 -0400
Received: from d1.scratchtelecom.com (69.42.52.179.scratchtelecom.com
	[69.42.52.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8JLblba032460
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 17:37:47 -0400
Received: from vegas (CPE00a02477ff82-CM001225d885d8.cpe.net.cable.rogers.com
	[99.249.154.65])
	by d1.scratchtelecom.com (8.13.8/8.13.8/Debian-3) with ESMTP id
	m8JLbk5x020139
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 17:37:46 -0400
Received: from lawsonk (helo=localhost)
	by vegas with local-esmtp (Exim 3.36 #1 (Debian)) id 1Kgnfa-0005or-00
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 17:37:42 -0400
Date: Fri, 19 Sep 2008 17:37:42 -0400 (EDT)
From: Keith Lawson <lawsonk@lawson-tech.com>
To: video4linux-list@redhat.com
Message-ID: <alpine.DEB.1.10.0809191733380.22306@vegas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Subject: TM5600 chipset device (diamond vc500) problems
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

Hello,

Okay I've got the tm6000 module loaded but it doesn't seem to see my 
device at all. dmesg output from loading module:

tm6000 v4l2 driver version 0.0.1 loaded
usbcore: registered new interface driver tm6000

I've also tried "modprobe tm6000 card=1" which gives the same results. I 
haven't found the firmware for the device yet, does that have to be in 
place before the kernel module will see the card?

The following posting seems to indicate that the TM5600 chipset works with 
this module but I seem to be missing something.

http://tiagovaz.wordpress.com/2007/11/24/pixelview-play-tv-405-dvd-makerusb-tv-tuner/

The device I'm trying to get working is a Diamond VC500 
(http://www.diamondmm.com/VC500.php), lsusb output is below.

lappy:/opt/src/tm5600/tm6010-65494895cacc/v4l# lsusb -d 07de:2820 -v

Bus 005 Device 008: ID 07de:2820 Diamond Multimedia VC500 Video Capture Dongle
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x07de Diamond Multimedia
   idProduct          0x2820 VC500 Video Capture Dongle
   bcdDevice            0.01
   iManufacturer          16 Diamond
   iProduct               32 USB Device
   iSerial                64 USB Device
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           78
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration         48 2.0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           2
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
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       1
       bNumEndpoints           2
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
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       2
       bNumEndpoints           2
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
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0002
   (Bus Powered)
   Remote Wakeup Enabled

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
