Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:43640 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbZIIWR1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 18:17:27 -0400
Received: by qyk30 with SMTP id 30so4052109qyk.5
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 15:17:30 -0700 (PDT)
Date: Wed, 9 Sep 2009 18:11:39 -0400
From: James Blanford <jhblanford@gmail.com>
To: linux-media@vger.kernel.org
Subject: gspca stv06xx performance regression - request for testing
Message-ID: <20090909181139.06ab4ed5@blackbart.localnet.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Howdy folks,

Now that I have my old quickcam express working, I can confirm that the
frame rate is half what it was with the old out-of-tree driver.  The
gspca driver is throwing out every other frame.  When a frame is
completed, a new frame is started with a new frame buffer that passes
the test for being properly queued.  But after the first packet is
analysed by the subdriver, the exact same test fails and the entire
frame is marked for discard.

I'm not having any luck tracking the problem down.  I would like to
find out if it's just my sensor, my subdriver or the entire gspca
family.  I have some printks that can be added to gspca.c that easily
and quickly illustrate the problem.

--- gspca.c.orig	2009-09-04 00:58:26.000000000 -0400
+++ gspca.c	2009-09-09 16:27:10.000000000 -0400
@@ -268,9 +268,11 @@
 	/* when start of a new frame, if the current frame buffer
 	 * is not queued, discard the whole frame */
 	if (packet_type == FIRST_PACKET) {
+			printk(KERN_DEBUG "New frame - first packet\n");
 		if ((frame->v4l2_buf.flags & BUF_ALL_FLAGS)
 						!= V4L2_BUF_FLAG_QUEUED) {
 			gspca_dev->last_packet_type = DISCARD_PACKET;
+			printk(KERN_DEBUG "Frame marked for discard\n");
 			return frame;
 		}
 		frame->data_end = frame->data;
@@ -306,6 +308,7 @@
 		wake_up_interruptible(&gspca_dev->wq);	/* event = new frame */
 		i = (gspca_dev->fr_i + 1) % gspca_dev->nframes;
 		gspca_dev->fr_i = i;
+		printk(KERN_DEBUG "Frame completed\n");
 		PDEBUG(D_FRAM, "frame complete len:%d q:%d i:%d o:%d",
 			frame->v4l2_buf.bytesused,
 			gspca_dev->fr_q,
@@ -396,6 +399,7 @@
 	}
 	gspca_dev->fr_i = gspca_dev->fr_o = gspca_dev->fr_q = 0;
 	gspca_dev->last_packet_type = DISCARD_PACKET;
+	printk(KERN_DEBUG "Frame alloc\n");
 	gspca_dev->sequence = 0;
 	return 0;
 }


When I test, I get:

Sep  8 10:27:48 blackbart kernel: Frame alloc
Sep  8 10:27:48 blackbart kernel: New frame - first packet
Sep  8 10:27:49 blackbart kernel: Frame completed
Sep  8 10:27:49 blackbart kernel: New frame - first packet
Sep  8 10:27:49 blackbart kernel: Frame marked for discard
Sep  8 10:27:49 blackbart kernel: New frame - first packet
Sep  8 10:27:49 blackbart kernel: Frame completed
Sep  8 10:27:49 blackbart kernel: New frame - first packet
Sep  8 10:27:49 blackbart kernel: Frame marked for discard
Sep  8 10:27:49 blackbart kernel: New frame - first packet
Sep  8 10:27:49 blackbart kernel: Frame completed
Sep  8 10:27:49 blackbart kernel: New frame - first packet
Sep  8 10:27:49 blackbart kernel: Frame marked for discard
Sep  8 10:27:49 blackbart kernel: New frame - first packet
Sep  8 10:27:49 blackbart kernel: Frame completed

Of course, I shouldn't be getting every other frame marked for
discard.  Note that this marking takes place when the first packet
comes across, _before_ any image data is passed.

I'm hoping someone has a few minutes to make a little patch, run the
cam for a couple seconds and look at the debug log.  Any comments are
welcome as well.

Thanks,

   -  Jim

-- 
There are two kinds of people.  The innocent and the living.
