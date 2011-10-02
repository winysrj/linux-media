Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:56013 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab1JBS0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Oct 2011 14:26:06 -0400
Date: Sun, 2 Oct 2011 13:31:28 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: linux-media@vger.kernel.org
cc: Ilya Chernykh <anixxsus@gmail.com>
Subject: Fly 110 TV camera
Message-ID: <alpine.LNX.2.00.1110021317550.23306@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Ilya contacted the gphoto-devel list about this camera. In spite of the 
name with "TV" in it, I understand that the camera is in fact installed in 
a cell phone. 

In stillcam mode, the camera is, I understand, a mass storage device. But 
when in webcam mode it comes up with a different ID and is a proprietary 
device. 

Some basic relevant information can be seen in the forwarded message, 
below. Most particularly, the lsusb output is there.

Ilya is willing to cooperate in developing support for the camera. Since I 
pointed out that the first thing one needs is a record of the camera at 
work, he tried to get some log files. He is running Win 7, and the old 
snoop programs do not work. Thus, today he sent me two log files which are 
in an unknown format (file suffix .ulz) which I cannot even seem to find 
in a Google search (seems to get redirected to .alz). These log files are 
supposed to be openable if one uses the tool that he used to create them, 
which is available in a "30-day trial version."

Thus two questions:

1. How are other people managing to create USB log files in Win 7?

2. What is a .ulz file, and how does one get opened, other than with some 
30-day trial version of some program?

Oh, yes, and to the above we can definitely add that there is surely 
enough fun for all in this. Does anyone else want to play? If so, go right 
ahead and contact me or Ilya.

Theodore Kilgore

(message with some relevant background information in it follows)

---------- Forwarded message ----------
Date: Sun, 2 Oct 2011 00:02:54 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Ilya Chernykh <anixxsus@gmail.com>
Cc: gphoto-devel@lists.sourceforge.net
Subject: Re: [gphoto-devel] Fly 110 TV camera



On Sun, 2 Oct 2011, Ilya Chernykh wrote:

> On Sunday 02 October 2011 01:35:08 you wrote:
> 
> > Now, look at that output. You ought to see information about Class and 
> > Subclass and Protocol. You can compare what you get to the list of the 
> > standard ones which you can find in lots of places, for example in the 
> > usb.ids file which is probably somewhere in your /usr/share directory. 
> 
> > If you see Class ff and Subclass ff and Protocol ff it means proprietary, 
> > proprietary, proprietary and there is a bit of work to do. 
> 
> It's 0, 0, 0.

Not exactly. Says "Defined at interface level"

But at the interface level it says 255, 255, 255 which is ff, ff, ff.

Which as I said last time means Proprietary, Proprietary, Proprietary.

So, OK. These are not "standard ones." 

> > You can give the "dmesg" command. If it "sees" and reports the webcam and 
> > says a module got loaded, it ought to work. You can also check whether
> > 
> > ls -l /dev/video*
> 
> No such file or directory.

OK. there would not be.

> 
> > Finally, I would conjecture that the lsusb output for the camera would be 
> > of sufficiently general interest that you should go ahead and post it 
> > here. 
> 
> Here it is:
> ===
> Bus 003 Device 005: ID 114d:8000 Alpha Imaging Technology Corp.
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               1.10
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x114d Alpha Imaging Technology Corp.
>   idProduct          0x8000
>   bcdDevice            1.00
>   iManufacturer           0
>   iProduct                0
>   iSerial                 0
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           32
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
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               0
> Device Status:     0x0000
>   (Bus Powered)
> 
> ===

This is the end? There are only two "pipes"? Both of them bulk and one of 
them going in and the other one going out? And this creature is actually a 
webcam? Amazing. Really amazing.


What we will need, I am afraid, is a UsbSnoop log, done with the camera 
doing its streaming thing while hooked up in Windows.

So if you do not have the logging program and do not know where to get 
it then let me know and I will try to help.


I am still somewhat optimistic, though. I suspect that the camera in the 
phone is probably taking JPEG photos, and then very likely it is sending 
down JPEG compressed frames, too. If that is the case we got lucky as the 
frame data should be easy to decompress. If they are using some other 
compression it might get pretty bad. They _will_ be using some kind of 
compression, of course, because otherwise they could not get any decent 
frame rate at all out of bulk transport.

OK, let's take this off list from now on. This is the gphoto-devel list, 
not linux-media list, after all.

Ilya, please write just to me, unless anyone else here wants to join the 
fun, and anyone who does should mail me or Ilya to let us know.

Next thing needed is a snoop log, as stated above.

Cheers, and wish for luck for ourselves.

Theodore Kilgore
