Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.211.174]:38501 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZINPR5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 11:17:57 -0400
Received: by ywh4 with SMTP id 4so4348777ywh.5
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 08:18:00 -0700 (PDT)
Date: Mon, 14 Sep 2009 11:17:57 -0400
From: James Blanford <jhblanford@gmail.com>
To: linux-media@vger.kernel.org, moinejf@free.fr
Subject: Race in gspca main or missing lock in stv06xx subdriver?
Message-ID: <20090914111757.543c7e77@blackbart.localnet.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Howdy folks,

I have my old quickcam express webcam working, with HDCS1000
sensor, 046d:840. It's clearly throwing away every other frame.  What
seems to be happening is, while the last packet of the previous frame
is being analyzed by the subdriver, the first packet of the next frame
is assigned to the current frame buffer.  By the time that packet is
analysed and sent back to the main driver, it's frame buffer has been
completely filled and marked as "DONE."  The entire frame is then
marked for "DISCARD."  This does _not_ happen with all cams using this
subdriver.

Here's a little patch, supplied only to help illustrate the problem,
that allows for the full, expected frame rate of the webcam.  What it
does is wait until the very last moment to assign a frame buffer to any
packet, but the last.  I also threw in a few printks so I can see where
failure takes place without wading through a swamp of debug output.

--- gspca/gspca.c.orig	2009-09-11 22:43:54.000000000 -0400
+++ gspca/gspca.c	2009-09-11 23:04:34.000000000 -0400
@@ -114,8 +114,10 @@ struct gspca_frame *gspca_get_i_frame(st
 	i = gspca_dev->fr_queue[i];
 	frame = &gspca_dev->frame[i];
 	if ((frame->v4l2_buf.flags & BUF_ALL_FLAGS)
-				!= V4L2_BUF_FLAG_QUEUED)
-		return NULL;
+				!= V4L2_BUF_FLAG_QUEUED){
+		printk(KERN_DEBUG "Shout NULL NULL NULL\n");
+		return frame;
+	}	
 	return frame;
 }
 EXPORT_SYMBOL(gspca_get_i_frame);
@@ -146,6 +148,7 @@ static void fill_frame(struct gspca_dev 
 		/* check the availability of the frame buffer */
 		frame = gspca_get_i_frame(gspca_dev);
 		if (!frame) {
+			printk(KERN_DEBUG "get_i_frame fails\n");
 			gspca_dev->last_packet_type = DISCARD_PACKET;
 			break;
 		}
@@ -268,9 +271,12 @@ struct gspca_frame *gspca_frame_add(stru
 	/* when start of a new frame, if the current frame buffer
 	 * is not queued, discard the whole frame */
 	if (packet_type == FIRST_PACKET) {
+		i = gspca_dev->fr_i;
+		frame = &gspca_dev->frame[i];
 		if ((frame->v4l2_buf.flags & BUF_ALL_FLAGS)
 						!= V4L2_BUF_FLAG_QUEUED) {
 			gspca_dev->last_packet_type = DISCARD_PACKET;
+		printk(KERN_DEBUG "Frame marked for discard\n");
 			return frame;
 		}
 		frame->data_end = frame->data;
@@ -285,8 +291,11 @@ struct gspca_frame *gspca_frame_add(stru
 
 	/* append the packet to the frame buffer */
 	if (len > 0) {
+		i = gspca_dev->fr_i;
+		frame = &gspca_dev->frame[i];
 		if (frame->data_end - frame->data + len
 						 > frame->v4l2_buf.length) {
+			printk(KERN_DEBUG "Frame overflow\n");
 			PDEBUG(D_ERR|D_PACK, "frame overflow %zd > %d",
 				frame->data_end - frame->data + len,
 				frame->v4l2_buf.length);


It works, at least until there is any disruption to the stream, such as
an exposure change, and then something gets out of sync and it starts
throwing out every other frame again.  It shows that the driver
framework and USB bus is capable of handling the full frame rate.

I'll keep looking for an actual solution, but there is a lot I don't
understand.  Any suggestions or ideas would be appreciated.  Several
questions come to mind.  Why bother assigning a frame buffer with
get_i_frame, before it's needed?  What purpose has frame_wait, when
it's not called until the frame is completed and the buffer is marked
as "DONE."  Why are there five, fr_i fr_q fr_o fr_queue index , buffer
indexing counters?  I'm sure I don't understand all the different tasks
this driver has to handle and all the different hardware it has to deal
with.  But I would be surprised if my cam is the only one this is
happening with.

Thanks,

   -  Jim

-- 
There are two kinds of people.  The innocent and the living.
