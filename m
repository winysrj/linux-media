Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5PLpkdj017715
	for <video4linux-list@redhat.com>; Wed, 25 Jun 2008 17:51:46 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5PLpXNt007797
	for <video4linux-list@redhat.com>; Wed, 25 Jun 2008 17:51:34 -0400
Message-ID: <4862BF41.9090208@hhs.nl>
Date: Wed, 25 Jun 2008 23:57:21 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: v4l2 library <v4l2-library@linuxtv.org>, video4linux-list@redhat.com,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Announcing libv4l 0.1
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

Hi All,

As most of you know I've been working on a userspace library which can be used 
to (very) easily add support for all kind of pixelformats to v4l2 applications.

Just replace open("dev/video0", ...) with v4l2_open("dev/video0", ...), ioctl 
with v4l2_ioctl, etc. libv4l2 will then do conversion of any known (webcam) 
pixelformats to bgr24 or yuv420.

Also included is libv4l1, which offer v4l1_open, v4l1_ioctl, etc. which can be 
used to make v4l1 applications work with v4l2 devices, including the necessary 
format conversion.

The functionality provided by libv4l1 for v4l1 apps and libv4l2 for v4l2 apps
can also be used by existing apps without modifying them. For this purpose
2 wrapper libraries are provided which can be preloaded before starting the
application using the LD_PRELOAD environment variable.

For those interested you can get libv4l1 here:
http://people.atrpms.net/~hdegoede/libv4l-0.1.tar.gz

Below is the full README of libv4l-0.1 :


Introduction
------------

libv4l is a collection of libraries which adds a thin abstraction layer on
top of video4linux2 devices. The purpose of this (thin) layer is to make it
easy for application writers to support a wide variety of devices without
having to write seperate code for different devices in the same class.

All libv4l components are licensed under the GNU Library General Publishing
License version 2 or (at your option) any later version.

libv4l consists of 3 different libraries:


libv4lconvert
-------------

libv4lconvert offers functions to convert from any (known) pixelformat
to V4l2_PIX_FMT_BGR24 or V4l2_PIX_FMT_YUV420.

Currently the following source formats are supported:
jpeg, mjpeg, bayer (all 4 variants: bggr, rggb, gbrg, grbg),
spca501 (chip specific yuv 420 with interlaced components),
spca561 (chip specific compressed gbrg bayer)
For more details on the v4lconvert_ functions see libv4lconvert.h .


libv4l1
-------

This offers functions like v4l1_open, v4l1_ioctl, etc. which can by used to
quickly make v4l1 applications work with v4l2 devices. These functions work
exactly like the normal open/close/etc, except that libv4l1 does full emulation
of the v4l1 api on top of v4l2 drivers, in case of v4l1 drivers it will just
pass calls through. For more details on the v4l1_ functions see libv4l1.h .


libv4l2
-------

This offers functions like v4l2_open, v4l2_ioctl, etc. which can by used to
quickly make v4l2 applications work with v4l2 devices with weird formats.
libv4l2 mostly passes calls directly through to the v4l2 driver. When the
app does a TRY_FMT / S_FMT with a not supported format libv4l2 will get in
the middle and emulate the format (if an app wants to know which formats the
hardware can _really_ do it should use ENUM_FMT, not randomly try a bunch of
S_FMT's). For more details on the v4l2_ functions see libv4l2.h .


wrappers
--------

The functionality provided by libv4l1 for v4l1 apps and libv4l2 for v4l2 apps
can also be used by existing apps without modifying them. For this purpose
2 wrapper libraries are provided which can be preloaded before starting the
application using the LD_PRELOAD environment variable. These wrappers will
then intercept calls to open/close/ioctl/etc. and if these calls directed
towards a video device the wrapper will redirect the call to the libv4lX
counterparts.

The preloadable libv4l1 wrapper which adds v4l2 device compatibility to v4l1
applications is called v4l1compat.so. The preloadable libv4l1 wrapper which
adds v4l2 device compatibility to v4l1 applications is called v4l2convert.so

Example usage:
$ export LD_LIBRARY_PATH=`pwd`/lib
$ export LD_PRELOAD=`pwd`/lib/v4l1compat.so
$ camorama


FAQ
---

Q: Why libv4l, whats wrong with directly accessing v4l2 devices ?
Q: Do we really need yet another library ?
A: Current webcam using applications like ekiga contain code to handle many
different specific pixelformats webcam's use, but that code only supports a
small subset of all native webcam (compressed) pixelformats. Other current
v4l2 applications do not support anything but rgb pixelformats (xawtv for
example) and this will not work with most webcams at all.

With gspca being ported to v4l2 and thus decoding to normal formats being
removed from the device driver as this really belongs in userspace, ekiga
would need to be extended with many more often chip dependent formats, like
the bayer compression used by the spca561 and the (different) compression used
by the pac207 and the (again different) compression used by the sn9c102. Adding
support for all these formats should not be done at the application level, as
then it needs to be written for each application seperately. Licensing issues
with the decompressors will then also become a problem as just cut and pasting
from one application to another is bound to hit license incompatibilities.

So clearly this belongs in a library, and in a library with a license which
allows this code to be used from as many different applications as possible.
Hence libv4l was born.

Q: Under which license may I use and distribute libv4l?
A: All libv4l components are licensed under the GNU Library General Publishing
License version 2 or (at your option) any later version. See the included
COPYING.LIB file.

Q: Okay so I get the use of having a libv4lconvert, but why libv4l1 ?
A: Many v4l2 drivers do not offer full v4l1 compatibility. They often do not
implemented the CGMBUF ioctl and v4l1 style mmap call. Adding support to all
these drivers for this is a lot of work and more importantly unnecessary
adds code to kernel space.

Also even if the CGMBUF ioctl and v4l1 style mmap are supported, then most
cams still deliver pixelformats which v4l1 applications do not understand.

This libv4l1 was born as an easy way to get v4l1 applications to work with
v4l2 devices without requiring full v4l1 emulation (including format
conversion) in the kernel, and without requiring major changes to the
applications.


Q: Why should I use libv4l2 in my app instead of direct device access
combined with libv4lconvert?

libv4l2 is mainly meant for quickly and easily adding support for more
pixelformats to existing v4l2 applications. So if you feel better directly
accessing the device in combination with libv4lconvert thats fine too.

Notice that libv4l2 also does emulation of the read() call on devices which
do not support it in the driver. In the background this uses mmap buffers
(even on devices which do support the read call). This mmap gives libv4lconvert
zero-copy access to the captured frame, and then it can write the converted
data directly to the buffer the application provided to v4l2_read(). Thus
another reason to use liv4l2 is to get the no memcpy advantage of the mmap
capture method combined with the simplicity of making a simple read() call.


Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
