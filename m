Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n19NpvLL026802
	for <video4linux-list@redhat.com>; Mon, 9 Feb 2009 18:51:57 -0500
Received: from eastrmmtao105.cox.net (eastrmmtao105.cox.net [68.230.240.47])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n19NoUIg002904
	for <video4linux-list@redhat.com>; Mon, 9 Feb 2009 18:50:41 -0500
Received: from eastrmimpo03.cox.net ([68.1.16.126]) by eastrmmtao105.cox.net
	(InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
	id <20090209235030.WQVK4139.eastrmmtao105.cox.net@eastrmimpo03.cox.net>
	for <video4linux-list@redhat.com>; Mon, 9 Feb 2009 18:50:30 -0500
Message-ID: <3148792E84E9450D9E2AF67899BF7D00@lynxwebdesign>
From: "Wayne Bragg" <wlbragg@cox.net>
To: <video4linux-list@redhat.com>
Date: Mon, 9 Feb 2009 17:51:05 -0600
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Subject: Fw: compiling and installing driver
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

I found this out there on the web
http://n2.nabble.com/Kworld-315U-help--td2110595.html#a2110682
and wondered if you were still on this list Douglas Landgraf or Franklin 
Meng? If so did you get this device working and can you help me do the same?

-----Original Message ----- 
From: "Wayne Bragg" <wlbragg@cox.net>
To: <video4linux-list@redhat.com>
Sent: Sunday, February 08, 2009 12:02 AM
Subject: Re: compiling and installing driver


On Fri, Feb 6, 2009 at 2:25 PM, Wayne Bragg <wlbragg@cox.net> wrote:
> Can someone point me to docs on compiling and installing the v4l drivers 
> in Ubuntu. I
> am a total dweeb newbe and need a good tutorial.

http://linuxtv.org/repo/

Devin

--------------------------


Thank's Devin,

I am trying to get Kworld ATSC USB 315U TV device working in linux (Ubuntu)
I think I needed the v4l-dvb drivers so I followed the proceedures at

http://linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers

but hit a snag right off the bat and don't know what to do next.
Specifically the line about

>"Provided that the drivers were loaded, you should now have a non-empty 
>/dev/dvb directory"

which I didn't have. So I tried the rest of the instructions and installed 
the v4l-dvb drivers, rebooted and still no /dev/dvb directories.
Linux is not seeing the usb device at all except with
lsusb
I get the same output as
http://linuxtv.org/wiki/index.php/KWorld_ATSC_315U
which is
Bus 001 Device 002: ID eb1a:a313 eMPIA Technology, Inc.
Device Descriptor:
 bLength                18
 bDescriptorType         1
 bcdUSB               2.00
 bDeviceClass            0 (Defined at Interface level)
 bDeviceSubClass         0
 bDeviceProtocol         0
 bMaxPacketSize0        64
 idVendor           0xeb1a eMPIA Technology, Inc.
 idProduct          0xa313
 bcdDevice            1.10
 iManufacturer           0
 iProduct                1
 iSerial                 0
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
       wMaxPacketSize     0x02f0  1x 752 bytes
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
       wMaxPacketSize     0x02f0  1x 752 bytes
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
       wMaxPacketSize     0x0c00  2x 0 bytes
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
       wMaxPacketSize     0x02f0  1x 752 bytes
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
       wMaxPacketSize     0x02f0  1x 752 bytes
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
       wMaxPacketSize     0x02f0  1x 752 bytes
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
       wMaxPacketSize     0x02f0  1x 752 bytes
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
       wMaxPacketSize     0x1400  3x 0 bytes
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
       wMaxPacketSize     0x02f0  1x 752 bytes
       bInterval               1
I have no idea where to go from here. Can anyone steer me in the right 
direction?Thanks
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=subscribe
https://www.redhat.com/mailman/listinfo/video4linux-list


--------------------------------------------------------------------------------



No virus found in this incoming message.
Checked by AVG - www.avg.com
Version: 8.0.233 / Virus Database: 270.10.19/1939 - Release Date: 02/06/09 
17:28:00

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
