Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:41861 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbZFSC2W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 22:28:22 -0400
Date: Thu, 18 Jun 2009 21:43:11 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Andy Walls <awalls@radix.net>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Sakar 57379 USB Digital Video Camera...
In-Reply-To: <1245375652.20630.6.camel@palomino.walls.org>
Message-ID: <alpine.LNX.2.00.0906182113010.17417@banach.math.auburn.edu>
References: <1245375652.20630.6.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 18 Jun 2009, Andy Walls wrote:

> My daughter just got one of these toy digital video recorder & webcam
> unit.
>
> It normally shows up as a mass storage drive.
>
> If I hold down the shutter button while connecting the USB cable, the
> camera LCD show a "webcam mode" icon and it shows up as a different USB
> device.
>
> Any chance of this working as a webcam under linux?
>
> Regards,
> Andy
>
>
> lsusb -vvv output:
>
> Mass storage mode:
>
> Bus 003 Device 003: ID 0979:0371 Jeilin Technology Corp., Ltd
> Device Descriptor:
>  bLength                18
>  bDescriptorType         1
>  bcdUSB               1.10
>  bDeviceClass            0 (Defined at Interface level)
>  bDeviceSubClass         0
>  bDeviceProtocol         0
>  bMaxPacketSize0         8
>  idVendor           0x0979 Jeilin Technology Corp., Ltd
>  idProduct          0x0371
>  bcdDevice            1.00
>  iManufacturer           1 Jeilin
>  iProduct                2 USB 1.1 Device
>  iSerial                 3 09790
>  bNumConfigurations      1
>  Configuration Descriptor:
>    bLength                 9
>    bDescriptorType         2
>    wTotalLength           46
>    bNumInterfaces          1
>    bConfigurationValue     1
>    iConfiguration          0
>    bmAttributes         0x80
>      (Bus Powered)
>    MaxPower              500mA
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       0
>      bNumEndpoints           4
>      bInterfaceClass         8 Mass Storage
>      bInterfaceSubClass      6 SCSI
>      bInterfaceProtocol     80 Bulk (Zip)
>      iInterface              4 SMC CF SD
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x01  EP 1 OUT
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0040  1x 64 bytes
>        bInterval               0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x82  EP 2 IN
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0040  1x 64 bytes
>        bInterval               0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x03  EP 3 OUT
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0008  1x 8 bytes
>        bInterval               0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x84  EP 4 IN
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0008  1x 8 bytes
>        bInterval               0
> Device Status:     0x0000
>  (Bus Powered)
>
>
>
> Webcam mode:
>
> Bus 003 Device 005: ID 0979:0280 Jeilin Technology Corp., Ltd
> Device Descriptor:
>  bLength                18
>  bDescriptorType         1
>  bcdUSB               1.10
>  bDeviceClass            0 (Defined at Interface level)
>  bDeviceSubClass         0
>  bDeviceProtocol         0
>  bMaxPacketSize0         8
>  idVendor           0x0979 Jeilin Technology Corp., Ltd
>  idProduct          0x0280
>  bcdDevice            1.00
>  iManufacturer           1 Jeilin
>  iProduct                2 USB 1.1 Device
>  iSerial                 0
>  bNumConfigurations      1
>  Configuration Descriptor:
>    bLength                 9
>    bDescriptorType         2
>    wTotalLength           46
>    bNumInterfaces          1
>    bConfigurationValue     1
>    iConfiguration          0
>    bmAttributes         0x80
>      (Bus Powered)
>    MaxPower              500mA
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       0
>      bNumEndpoints           4
>      bInterfaceClass         0 (Defined at Interface level)
>      bInterfaceSubClass      0
>      bInterfaceProtocol      0
>      iInterface              4 SMC CF SD
>     Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x01  EP 1 OUT
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0040  1x 64 bytes
>        bInterval               0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x82  EP 2 IN
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0040  1x 64 bytes
>        bInterval               0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x03  EP 3 OUT
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0008  1x 8 bytes
>        bInterval               0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x84  EP 4 IN
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0008  1x 8 bytes
>        bInterval               0
> Device Status:     0x0000
>  (Bus Powered)
>
>
>

Interesting. To answer your question, I have no idea off the top of my 
head. I do have what seems to be a similar camera. It is

Bus 005 Device 006: ID 0979:0371 Jeilin Technology Corp., Ltd

and the rest of the lsusb output looks quite similar. I do not know, 
though, if it has any chance of working as a webcam. Somehow, the thought 
never occurred to me back when I got the thing. I would have to hunt some 
stuff down even to know if it is claimed to work as a webcam.

You did say that it comes up as a different USB device when it is a 
webcam? You mean, a different product ID or so?

Some history about my camera, which will perhaps make you smile:

I got it a couple of years ago, at about the same time that someone in 
Germany got a similar camera, and he wanted to get it supported. He wanted 
to stick it on a model airplane, IIRC, and take pictures. Well, it says it 
is a mass storage device. But it wouldn't work with the mass storage 
driver. So I got on the mass-storage mailing list about the camera. Alan 
Stern was the one who figured out first what was the problem. I was right 
behind him, and it made me feel stupid that I was slower than he was. But 
you do have to be mighty good to keep up with Alan, so I really don't feel 
bad. What was the problem? Well, notice that there are two pairs of bulk 
endpoints. The camera uses one pair for data, and the other pair for 
commands. But which pair? Well, the mass storage driver at the time was 
choosing the wrong pair. And it was the camera which was in spec, not the 
mass storage stack. Needless to say, that got fixed, pronto. And all 
because of one of these pesky cameras.

Another general comment about Jeilin is probably not relevant here, 
but I will make it anyway:

Some of their cameras (the 0979:0227 cameras) use a really nasty 
compression algorithm. These are also dual-mode still and web cams. There 
is no hope of supporting them unless the compression is figured out. I 
hope some clever guy reads this comment.

Probably what is happening with your camera is, it is using something like 
JPEG in stillcam mode? If so, it might possibly send down JPEG frames in 
webcam mode, too. Perhaps with the use of SnoopyPro or such, it is 
possible to find out?

Theodore Kilgore
