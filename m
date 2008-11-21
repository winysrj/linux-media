Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALAnBtQ029362
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 05:49:11 -0500
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALAmwTJ000325
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 05:48:59 -0500
Message-ID: <49269369.90805@hhs.nl>
Date: Fri, 21 Nov 2008 11:54:33 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<Pine.LNX.4.64.0811181216270.2778@banach.math.auburn.edu>
	<200811190020.15663.linux@baker-net.org.uk>
	<4923D159.9070204@hhs.nl>
	<alpine.LNX.1.10.0811192005020.2980@banach.math.auburn.edu>
	<49253004.4010504@hhs.nl>
	<Pine.LNX.4.64.0811201130410.3570@banach.math.auburn.edu>
	<4925BC94.7090008@hhs.nl>
	<Pine.LNX.4.64.0811202306360.3930@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0811202306360.3930@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [sqcam-devel] Advice wanted on producing an in kernel sq905
	driver
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

kilgota@banach.math.auburn.edu wrote:
> 
> Hans,
> 
> Two topics.
> 
> First one:
> I tried out some simplification and shortening of the code in 
> ahd_bayer.c and I managed to cut down on the time a bit. The time for it 
> to run on a 320x240 image (from a Sonix SN9C2028) that I keep around for 
> testing is
> 
> Total time of AHD :     40 ms (time before doing the algorithm changes)
> 
> Total time of AHD :     20 ms (after doing the algorithm simplification)
> 

Uhg, with 352x288 @ 30 fps (and yes some cams can do 30 fps at 352x288) this 
translates to 792 ms of each second being used just for the demosaic phase.

> Total time of bilin :     10 ms (done with the old algorithm that Lutz 
> M. wrote for libgphoto2 before the "accrue" edge detection was added)
> 
> Total time of accrue :  10 ms  (done with the "accrue" edge detection 
> which is found at present in ahd_bayer.c)
> 

Hmm, still not too good, using an spca561 based cam, which sends compressed 
bayer, displaying 352x288 @ 30 fps, takes 35% CPU load, with my CPU running at 
1Ghz. Note this includes everything, decompression, demosaic and actually 
displaying the pictures.

Could you drop in the bilinear code from libv4l bayer.c and see how that 
performs on your file ?

> What was timed is the interpolation function only;

So these times do not include the spread out ? Hmm.

> Relative image quality of the methods:
> 
> 1. straight bilinear interpolation is lousy on this image. Lots of 
> zippering.
> 

Ok, then maybe we do need to get something better.

> 2. accrue is not much better. Cures zippering but leaves stripes of 
> color artifacting beside vertical or horizontal edges.
> 

Are those "stripes of color artifacting" also present with plain bilinear

> 3. Very simplified AHD (choice algorithm at each pixel tossed, only an 
> average of the vertical and horizontal approximation used at each color 
> in each pixel). Zippering, again, but the rest of the image leaves a 
> much better impression.
> 
> 4. The simplified AHD which is found in ahd_bayer.c (joint work with 
> Eero Salminen at H.U.T.) gives of course far the best quality, but 
> probably it is just too slow for webcam type of stuff.
> 
> It would probably be possible further to streamline the code for the 
> very simplified AHD and then I suspect it would run a little bit faster. 

It might just be that your system is slow, but if it turns out that bayer.c 
from libv4l is much faster then the bilinear code from libgphoto2, then IMHO 
going to AHD is speedwise not a good idea.

> Second item:
> 
> I notice that you intend for the kernel modules which support webcams to 
> do only basic stuff, and then to pass everything over to userspace. 
> Specifically, you intend to pass everything over to libv4l2, and various 
> apps for doing stuff with webcam output are then envisioned to sit on 
> top of libv4l2 and use it. Therefore some dumb, or, for all I know, not 
> so dumb questions:
> 
> 1. What is to prevent the kernel module from interacting with (for 
> example) both libv4l2 and libusb? Why could not the kernel module (for 
> example) pass isochronous stuff through libv4l2 and bulk stuff through 
> libusb?
> 

Erm, when you have a kernel module there is no need to use libusb, the kernel 
has its own functions for usb.

Basicly whenever we have a video input device, we want to have a kernel driver, 
so as to present a standard /dev/videoX device to userspace, so that all apps 
written for v4l can use the device.

However we do not want to do video format conversion (let alone decompression) 
in kernel space, so if the data is in an exotic format we simply indicate this 
in the pixelformat member of the exchanged structs, and let userspace deal with it.

This is where libv4l comes in into play, libv4l is a convenience lib for 
applications, which can do conversion for them so that the app writers do not 
have to add support for each exotic webcam format themselves.

Currently we are planning on improving the format conversion by adding 
additional steps like whitebalance and normalizing.

> 2. What prevents libusb, in turn, from interacting with a kernel module. 
> Or, if something does prevent it, then what is preventing something like 
> libgphoto2 from interacting with the kernel module?
> 

libusb does not interact with a kernel module for a specific device, it 
interacts directly with the device through the usb subsystem, here in lies a 
problem for the sq905 as only an in kernel driver, or libusb can access the 
device at a time. I've understood from others in this thread there are 
solutions for this, but I'm not familiar with them.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
