Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:37611 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbZFDRgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2009 13:36:16 -0400
Date: Thu, 4 Jun 2009 12:50:45 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Erik de Castro Lopo <erik@bcode.com>
cc: linux-media@vger.kernel.org
Subject: Re: Creating a V4L driver for a USB camera
In-Reply-To: <20090604153328.4a3f2a6f.erik@bcode.com>
Message-ID: <alpine.LNX.2.00.0906041234230.18205@banach.math.auburn.edu>
References: <20090603141350.04cde59b.erik@bcode.com> <62e5edd40906022318l230992b7n34e5178b7e1a7d46@mail.gmail.com> <20090604100110.c837c3df.erik@bcode.com> <alpine.LNX.2.00.0906032014530.17538@banach.math.auburn.edu> <20090604115216.513cc41c.erik@bcode.com>
 <alpine.LNX.2.00.0906032213001.17620@banach.math.auburn.edu> <20090604153328.4a3f2a6f.erik@bcode.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 4 Jun 2009, Erik de Castro Lopo wrote:

> On Thu, 4 Jun 2009 14:02:37 +1000
> Theodore Kilgore <kilgota@banach.math.auburn.edu> wrote:
>
>> Well, if you are interested in using the camera as a still camera, then
>> probably you ought also to send an inquiry over to
>>
>> gphoto-devel@lists.sourceforge.net
>>
>> because that is, basically, where the still camera support is done, not
>> here.
>
> Well our current camera has a V4L based driver so we'd like to stick
> to that :-).

As I explained, it is a matter of what one wants to do with the camera 
which kind of driver one wants to construct. Also it is a matter of what 
exactly that the particular camera will do. To take the two extreme cases:

-- if you have a camera which will not act as a webcam, a V4L driver will 
probably not materialize.

-- if you have a webcam which has no ability to act as a still camera, 
then no Gphoto driver will materialize.

And if the camera can do both of the above, then it is possible (and it 
occurs, too) that the camera has a Gphoto driver for its still camera 
functionality and it has a V4L driver for its webcam functionality. But 
the still camera and webcam functions are conceptually different and 
require distinct methodologies to support them in Linux.

In other words, the kind of software support which is required by new 
camera X is determined by the properties of camera X alone. That was my 
point.

> Ok, to the lsusb -v info:
>
>    Bus 001 Device 011: ID 0547:8031 Anchor Chips, Inc.
>    Device Descriptor:
>      bLength                18
>      bDescriptorType         1
>      bcdUSB               2.00
>      bDeviceClass            0 (Defined at Interface level)
>      bDeviceSubClass         0
>      bDeviceProtocol         0
>      bMaxPacketSize0        64
>      idVendor           0x0547 Anchor Chips, Inc.
>      idProduct          0x8031
>      bcdDevice            0.00
>      iManufacturer           1
>      iProduct                2
>      iSerial                 0
>      bNumConfigurations      1
>      Configuration Descriptor:
>        bLength                 9
>        bDescriptorType         2
>        wTotalLength           32
>        bNumInterfaces          1
>        bConfigurationValue     1
>        iConfiguration          0
>        bmAttributes         0x80
>          (Bus Powered)
>        MaxPower              100mA
>        Interface Descriptor:
>          bLength                 9
>          bDescriptorType         4
>          bInterfaceNumber        0
>          bAlternateSetting       0
>          bNumEndpoints           2
>          bInterfaceClass       255 Vendor Specific Class
>          bInterfaceSubClass      0
>          bInterfaceProtocol      0
>          iInterface              0
>          Endpoint Descriptor:
>            bLength                 7
>            bDescriptorType         5
>            bEndpointAddress     0x81  EP 1 IN
>            bmAttributes            3
>              Transfer Type            Interrupt
>              Synch Type               None
>              Usage Type               Data
>            wMaxPacketSize     0x0004  1x 4 bytes
>            bInterval               0
>          Endpoint Descriptor:
>            bLength                 7
>            bDescriptorType         5
>            bEndpointAddress     0x82  EP 2 IN
>            bmAttributes            2
>              Transfer Type            Bulk
>              Synch Type               None
>              Usage Type               Data
>            wMaxPacketSize     0x0200  1x 512 bytes
>            bInterval               0
>
>
> The "Vendor Specific Class" above suggests that this camera does not
> behave like a proper USV video or still camera, but rather uses its
> own protocol (just like the camera we are replacing).

Yes. That seems quite clear.

>
> I have managed to convince the manufactuer of the fact that its a
> good idea to provide some information and/or windows source code,
> but as yet I can't predict how good that information will be.

If the manufacturer truly provides meaningful information, that would be 
very good. Therefore, I restrain myself from expressing general pessimism 
about the prospects.

Theodore Kilgore
