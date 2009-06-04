Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:52329 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbZFDDsK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2009 23:48:10 -0400
Date: Wed, 3 Jun 2009 23:02:37 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Erik de Castro Lopo <erik@bcode.com>
cc: linux-media@vger.kernel.org,
	=?ISO-8859-15?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
Subject: Re: Creating a V4L driver for a USB camera
In-Reply-To: <20090604115216.513cc41c.erik@bcode.com>
Message-ID: <alpine.LNX.2.00.0906032213001.17620@banach.math.auburn.edu>
References: <20090603141350.04cde59b.erik@bcode.com> <62e5edd40906022318l230992b7n34e5178b7e1a7d46@mail.gmail.com> <20090604100110.c837c3df.erik@bcode.com> <alpine.LNX.2.00.0906032014530.17538@banach.math.auburn.edu>
 <20090604115216.513cc41c.erik@bcode.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 4 Jun 2009, Erik de Castro Lopo wrote:

> On Thu, 4 Jun 2009 11:28:38 +1000
> Theodore Kilgore <kilgota@banach.math.auburn.edu> wrote:
>
>> If this is the case, then it ought not to be terribly difficult to write a
>> basic driver. If you wanted still camera support, with which I have a bit
>> more experience than with streaming support,
>
> Yep, only interested in still images ATM.
>
>> Of course, I said above "basic" driver. That does not include things like
>> color balance, contrast, or brightness controls. Such would probably take
>> a little bit longer.
>
> Als need contol over things like this. We have pretty good control
> over the lighting the camera works under so we tweak contrast/brightness/
> whatever in the camera to provide the bext possible image to the image
> processing.

Well, if you are interested in using the camera as a still camera, then 
probably you ought also to send an inquiry over to

gphoto-devel@lists.sourceforge.net

because that is, basically, where the still camera support is done, not 
here. At the same time, though, you have gotten some responses here from 
some pretty clever folks who have volunteered to help. So if I were you I 
would certainly not want to drop those offers into the sea.

The reason for the distinction between V4L  type of things and Gphoto type 
of things is the old and time-honored rigid distinction between 
kernelspace and userspace in Linux. Basically, the idea is that a video 
device or a streaming camera (webcam) requires a kernel device to be 
created, usually named /dev/videoX where X is a number, and if you have 
just one such device hooked up then X=0, of course. But userspace 
applications do not require that, and a device can be communicated with 
through libusb, for example, or even can be communicated with directly.

So, Gphoto is a project which supports still cameras, using libusb as its 
infrastructure. It was conceived and intended to support proprietary 
cameras, which do not use any standard communication protocol. More 
recently, it has also evolved into supporting the cameras which use the 
PTP protocol. If your camera is proprietary or uses PTP and you want to 
get still photos off it, then Gphoto is the way to go. If it can also 
stream and you want _that_ supported, then here is the right place.

Many still cameras, though, are not using a proprietary or a PTP 
communication protocol, but instead are using Mass Storage, usually with 
protocol Transparent SCSI, and with Bulk Transport. Such still cameras do 
not in general need any particular driver software at all. Rather, one 
gets access to such a camera by mounting it. For, as a USB device it acts 
just like any USB external hard drive or flash drive and the photos on it 
are files ready to download.

Unfortunately, if you have mentioned what are the characteristics of your 
camera as a USB device, then that mention did not register on me. What 
might really help in getting started (whichever way this is going) is the 
full output of lsusb. Here, for example, is part of the output from a 
camera, from lsusb -v:

Bus 005 Device 002: ID 093a:010f Pixart Imaging, Inc. Argus 
DC-1610/DC-1620/Emprex PCD3600/Philips P44417B keychain camera/Precision 
Mini,Model HA513A/Vivitar Vivicam 55
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass          255 Vendor Specific Class
   bDeviceSubClass       255 Vendor Specific Subclass
   bDeviceProtocol       255 Vendor Specific Protocol
   bMaxPacketSize0         8
   idVendor           0x093a Pixart Imaging, Inc.
   idProduct          0x010f Argus DC-1610/DC-1620/Emprex PCD3600/Philips 
P44417B keychain camera/Precision Mini,Model HA513A/Vivitar Vivicam 55
   bcdDevice            1.00
   iManufacturer           0
   iProduct                2 USB Dual-mode Camera

Note in particular these lines

   bDeviceClass          255 Vendor Specific Class
   bDeviceSubClass       255 Vendor Specific Subclass
   bDeviceProtocol       255 Vendor Specific Protocol

which tell that, whatever else, this camera needs to have a driver 
provided or else one can do nothing at all with it. It does have a 
stillcam driver, in fact, in libgphoto2. A webcam driver for it is under 
development, too, over here, since the camera is "Dual-mode" and can be 
used both as a still camera and as a webcam.

Now, here is another camera:

Bus 005 Device 003: ID 2770:915d NHJ, Ltd Cyberpix S-210S / Little Tikes 
My Real Digital Camera
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x2770 NHJ, Ltd
   idProduct          0x915d Cyberpix S-210S / Little Tikes My Real Digital 
Camera

So, the note says "Defined at Interface level" so we can scroll down a bit 
and we see

       bInterfaceClass         8 Mass Storage
       bInterfaceSubClass      6 SCSI
       bInterfaceProtocol     80 Bulk (Zip)

so in other words, to get access to this camera one must mount it. Period. 
No particular additional support is needed for this second camera, and, as 
a matter of fact, no additional support is possible, either, neither from 
the kernel nor from a project like libgphoto.

So the reason for these examples is, it is this kind of information which 
one must use to judge the situation, and it is this kind of information 
which one would have to provide in order to begin to get definitive 
answers. This, in fact, is where one must start.

Hope this helps.

Theodore Kilgore
