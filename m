Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAHMrmlK023969
	for <video4linux-list@redhat.com>; Mon, 17 Nov 2008 17:53:48 -0500
Received: from mk-outboundfilter-6.mail.uk.tiscali.com
	(mk-outboundfilter-6.mail.uk.tiscali.com [212.74.114.14])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAHMrZDA029387
	for <video4linux-list@redhat.com>; Mon, 17 Nov 2008 17:53:36 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: video4linux-list@redhat.com
Date: Mon, 17 Nov 2008 22:53:33 +0000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811172253.33396.linux@baker-net.org.uk>
Cc: sqcam-devel@lists.sourceforge.net
Subject: Advice wanted on producing an in kernel sq905 driver
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

Hi V4L readers,

There currently exists an out of kernel driver for the SQ technologies sq905 
USB webcam chipset used by a number of low cost webcams. This driver has a 
number of issues which would count against it being included in kernel as is 
but I'm considering trying to create something that could be suitable. I have 
a number of questions on how best to proceed.

Note that this refers only to the sq905, USB ID 0x2770:0x9120 the sq905c is a 
substantially different chip.

(If anyone wants to check out the current driver it is at 
http://sqcam.cvs.sourceforge.net/viewvc/sqcam/sqcam26/ )

First off some thoughts on how I'd like to proceed.

The chip exposes the Bayer sensor output directly to the driver so the current 
driver uses code borrowed from libgphoto2 to do the Bayer decode in kernel. 
Obviously this is wrong and now we have libv4l it should use that instead.

I don't have masses of time to work on this so I need an approach that isn't 
going to require writing loads of code. Considering the mess the current 
driver is in it is probably going to be better to make it a sub driver of 
gspca rather than try to re-use the existing code (which should also make 
life easier from a long term maintenance PoV).

Now my questions

1) What kernel should I base any patches I produce on? The obvious choice 
would seem to be 
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git but it 
seems as if Linus's 2.6 tree is more up to date for gspca.

2) The existing driver needed to perform a gamma adjustment after performing 
the Bayer decode. I couldn't find anything in libv4l that obviously did that 
so I'm guessing it isn't needed for existing devices - should that be added 
to libv4l if needed and if so how should the driver indicate it is needed - 
could it be indicated with a new value for v4l2_colorspace?

3) The current driver needs to do some up/down and left/right flips of the 
data to get it in the right order to do the Bayer decode that depend on the 
version info the camera returns to its init sequence. Should that code remain 
in the driver and if not how should the driver communicate what is needed.

4) The current driver doesn't support streaming mode for V4L2 (only V4L1) and 
libv4l doesn't support cameras that don't support streaming so is there an 
easy way to test out if the camera output will work well with libv4l before 
starting work?

5) Is there anything else I should know before starting.

Adam Baker

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
