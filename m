Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5SA0PR1024331
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 06:00:25 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5SA0Dkv004436
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 06:00:14 -0400
Message-ID: <48660D13.9040004@hhs.nl>
Date: Sat, 28 Jun 2008 12:06:11 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: v4l2 library <v4l2-library@linuxtv.org>, video4linux-list@redhat.com,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Announcing libv4l 0.2
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

I'm happy to announce version 0.2 of libv4l, this release has the following 
changes (mostly bugfixes):

libv4l-0.2
----------
*** API change ***
* Change v4lconvert api so that the v4lconvert struct always gets allocated
   by the library, this to make it opaque, so that we can avoid future API
   and ABI changes
* Add support for yuv420 -> bgr24 conversion
* When converting from v4l2 pixelformat to v4l12 palette return
   VIDEO_PALETTE_YUV420P instead of VIDEO_PALETTE_YUV420 for
   V4L2_PIX_FMT_YUV420 as that is what most apps seem to expect
* override kernel v4l1 compat min / max size with our own more accurate values
* fix v4l1 munmap bug where it didn't recognise the buffer being unmapped was
   our fake buffer (fixes gstreamer v4l1 support, checked with cheese)
* add support for reporting the emulated pixelformats with ENUM_FMT, this
   defaults to off, and can be activated by passing a flag to enable it to
   v4l2_fd_open. This gets enabled by default the wrappers.
* v4l2: mmap the real device buffers before doing conversion when DQBUF gets
   called before the application has called mmap (avoid crash).


The big improvement here is that gstreamer using applications now work as long 
as they use v4l1, you can force this by [re]moving 
/usr/lib[64]/gstreamer-0.10/libgstvideo4linux2.so

Getting gstreamer v4l2 working is planned for 0.3, this requires adding a 
v4l2_dup function (and catching dup() in the wrapper), and probably also making 
things threadsafe.

Regards,

Hans


p.s.

Thierry I know you're still working on getting 0.1 into the v4l-dvb no worries, 
I can split the work from 0.1 in a few seperate patches and submit those once 
0.1 is in the v4l1-dvb tree.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
