Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1AHIf9H021508
	for <video4linux-list@redhat.com>; Tue, 10 Feb 2009 12:19:16 -0500
Received: from web32701.mail.mud.yahoo.com (web32701.mail.mud.yahoo.com
	[68.142.207.245])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n1AGNXEb015249
	for <video4linux-list@redhat.com>; Tue, 10 Feb 2009 11:23:33 -0500
Date: Tue, 10 Feb 2009 08:23:32 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
To: video4linux-list@redhat.com, Wayne Bragg <wlbragg@cox.net>
In-Reply-To: <3148792E84E9450D9E2AF67899BF7D00@lynxwebdesign>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <231787.73150.qm@web32701.mail.mud.yahoo.com>
Cc: 
Subject: Re: Fw: compiling and installing driver
Reply-To: fmeng2002@yahoo.com
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

Wayne, 

I'm also trying to get the device to work.  Unfortunately I don't have a working patch yet.  I'm working on the driver modifications slowly as I have time.  

Thanks,
Franklin


--- On Mon, 2/9/09, Wayne Bragg <wlbragg@cox.net> wrote:

> From: Wayne Bragg <wlbragg@cox.net>
> Subject: Fw: compiling and installing driver
> To: video4linux-list@redhat.com
> Date: Monday, February 9, 2009, 3:51 PM
> I found this out there on the web
> http://n2.nabble.com/Kworld-315U-help--td2110595.html#a2110682
> and wondered if you were still on this list Douglas
> Landgraf or Franklin Meng? If so did you get this device
> working and can you help me do the same?
> 
> -----Original Message ----- From: "Wayne Bragg"
> <wlbragg@cox.net>
> To: <video4linux-list@redhat.com>
> Sent: Sunday, February 08, 2009 12:02 AM
> Subject: Re: compiling and installing driver
> 
> 
> On Fri, Feb 6, 2009 at 2:25 PM, Wayne Bragg
> <wlbragg@cox.net> wrote:
> > Can someone point me to docs on compiling and
> installing the v4l drivers in Ubuntu. I
> > am a total dweeb newbe and need a good tutorial.
> 
> http://linuxtv.org/repo/
> 
> Devin
> 
> --------------------------
> 
> 
> Thank's Devin,
> 
> I am trying to get Kworld ATSC USB 315U TV device working
> in linux (Ubuntu)
> I think I needed the v4l-dvb drivers so I followed the
> proceedures at
> 
> http://linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers
> 
> but hit a snag right off the bat and don't know what to
> do next.
> Specifically the line about
> 
> > "Provided that the drivers were loaded, you
> should now have a non-empty /dev/dvb directory"
> 
> which I didn't have. So I tried the rest of the
> instructions and installed the v4l-dvb drivers, rebooted and
> still no /dev/dvb directories.
> Linux is not seeing the usb device at all except with
> lsusb
> I get the same output as
> http://linuxtv.org/wiki/index.php/KWorld_ATSC_315U
> which is
> Bus 001 Device 002: ID eb1a:a313 eMPIA Technology, Inc.
> Device Descriptor:
> bLength                18
> bDescriptorType         1
> bcdUSB               2.00
> bDeviceClass            0 (Defined at Interface level)
> bDeviceSubClass         0
> bDeviceProtocol         0
> bMaxPacketSize0        64
> idVendor           0xeb1a eMPIA Technology, Inc.
> idProduct          0xa313
> bcdDevice            1.10
> iManufacturer           0
> iProduct                1
> iSerial                 0
> bNumConfigurations      1
> Configuration Descriptor:
>   bLength                 9
>   bDescriptorType         2
>   wTotalLength          305
>   bNumInterfaces          1
>   bConfigurationValue     1
>   iConfiguration          0
>   bmAttributes         0x80
>     (Bus Powered)
>   MaxPower              500mA
>   Interface Descriptor:
>     bLength                 9
>     bDescriptorType         4
>     bInterfaceNumber        0
>     bAlternateSetting       0
>     bNumEndpoints           4
>     bInterfaceClass       255 Vendor Specific Class
>     bInterfaceSubClass      0
>     bInterfaceProtocol    255
>     iInterface              0
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x81  EP 1 IN
>       bmAttributes            3
>         Transfer Type            Interrupt
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x0001  1x 1 bytes
>       bInterval              11
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x82  EP 2 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x0000  1x 0 bytes
>       bInterval               1
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x83  EP 3 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x0000  1x 0 bytes
>       bInterval               4
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x84  EP 4 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x0000  1x 0 bytes
>       bInterval               1
>   Interface Descriptor:
>     bLength                 9
>     bDescriptorType         4
>     bInterfaceNumber        0
>     bAlternateSetting       1
>     bNumEndpoints           4
>     bInterfaceClass       255 Vendor Specific Class
>     bInterfaceSubClass      0
>     bInterfaceProtocol    255
>     iInterface              0
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x81  EP 1 IN
>       bmAttributes            3
>         Transfer Type            Interrupt
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x0001  1x 1 bytes
>       bInterval              11
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x82  EP 2 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x0000  1x 0 bytes
>       bInterval               1
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x83  EP 3 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x00c4  1x 196 bytes
>       bInterval               4
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x84  EP 4 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x02f0  1x 752 bytes
>       bInterval               1
>   Interface Descriptor:
>     bLength                 9
>     bDescriptorType         4
>     bInterfaceNumber        0
>     bAlternateSetting       2
>     bNumEndpoints           4
>     bInterfaceClass       255 Vendor Specific Class
>     bInterfaceSubClass      0
>     bInterfaceProtocol    255
>     iInterface              0
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x81  EP 1 IN
>       bmAttributes            3
>         Transfer Type            Interrupt
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x0001  1x 1 bytes
>       bInterval              11
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x82  EP 2 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x0ad4  2x 724 bytes
>       bInterval               1
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x83  EP 3 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x00c4  1x 196 bytes
>       bInterval               4
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x84  EP 4 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x02f0  1x 752 bytes
>       bInterval               1
>   Interface Descriptor:
>     bLength                 9
>     bDescriptorType         4
>     bInterfaceNumber        0
>     bAlternateSetting       3
>     bNumEndpoints           4
>     bInterfaceClass       255 Vendor Specific Class
>     bInterfaceSubClass      0
>     bInterfaceProtocol    255
>     iInterface              0
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x81  EP 1 IN
>       bmAttributes            3
>         Transfer Type            Interrupt
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x0001  1x 1 bytes
>       bInterval              11
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x82  EP 2 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x0c00  2x 0 bytes
>       bInterval               1
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x83  EP 3 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x00c4  1x 196 bytes
>       bInterval               4
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x84  EP 4 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x02f0  1x 752 bytes
>       bInterval               1
>   Interface Descriptor:
>     bLength                 9
>     bDescriptorType         4
>     bInterfaceNumber        0
>     bAlternateSetting       4
>     bNumEndpoints           4
>     bInterfaceClass       255 Vendor Specific Class
>     bInterfaceSubClass      0
>     bInterfaceProtocol    255
>     iInterface              0
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x81  EP 1 IN
>       bmAttributes            3
>         Transfer Type            Interrupt
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x0001  1x 1 bytes
>       bInterval              11
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x82  EP 2 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x1300  3x 768 bytes
>       bInterval               1
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x83  EP 3 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x00c4  1x 196 bytes
>       bInterval               4
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x84  EP 4 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x02f0  1x 752 bytes
>       bInterval               1
>   Interface Descriptor:
>     bLength                 9
>     bDescriptorType         4
>     bInterfaceNumber        0
>     bAlternateSetting       5
>     bNumEndpoints           4
>     bInterfaceClass       255 Vendor Specific Class
>     bInterfaceSubClass      0
>     bInterfaceProtocol    255
>     iInterface              0
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x81  EP 1 IN
>       bmAttributes            3
>         Transfer Type            Interrupt
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x0001  1x 1 bytes
>       bInterval              11
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x82  EP 2 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x135c  3x 860 bytes
>       bInterval               1
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x83  EP 3 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x00c4  1x 196 bytes
>       bInterval               4
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x84  EP 4 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x02f0  1x 752 bytes
>       bInterval               1
>   Interface Descriptor:
>     bLength                 9
>     bDescriptorType         4
>     bInterfaceNumber        0
>     bAlternateSetting       6
>     bNumEndpoints           4
>     bInterfaceClass       255 Vendor Specific Class
>     bInterfaceSubClass      0
>     bInterfaceProtocol    255
>     iInterface              0
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x81  EP 1 IN
>       bmAttributes            3
>         Transfer Type            Interrupt
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x0001  1x 1 bytes
>       bInterval              11
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x82  EP 2 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x13c4  3x 964 bytes
>       bInterval               1
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x83  EP 3 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x00c4  1x 196 bytes
>       bInterval               4
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x84  EP 4 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x02f0  1x 752 bytes
>       bInterval               1
>   Interface Descriptor:
>     bLength                 9
>     bDescriptorType         4
>     bInterfaceNumber        0
>     bAlternateSetting       7
>     bNumEndpoints           4
>     bInterfaceClass       255 Vendor Specific Class
>     bInterfaceSubClass      0
>     bInterfaceProtocol    255
>     iInterface              0
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x81  EP 1 IN
>       bmAttributes            3
>         Transfer Type            Interrupt
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x0001  1x 1 bytes
>       bInterval              11
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x82  EP 2 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x1400  3x 0 bytes
>       bInterval               1
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x83  EP 3 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x00c4  1x 196 bytes
>       bInterval               4
>     Endpoint Descriptor:
>       bLength                 7
>       bDescriptorType         5
>       bEndpointAddress     0x84  EP 4 IN
>       bmAttributes            1
>         Transfer Type            Isochronous
>         Synch Type               None
>         Usage Type               Data
>       wMaxPacketSize     0x02f0  1x 752 bytes
>       bInterval               1
> I have no idea where to go from here. Can anyone steer me
> in the right direction?Thanks
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=subscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 
> 
> --------------------------------------------------------------------------------
> 
> 
> 
> No virus found in this incoming message.
> Checked by AVG - www.avg.com
> Version: 8.0.233 / Virus Database: 270.10.19/1939 - Release
> Date: 02/06/09 17:28:00
> 
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
