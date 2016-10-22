Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:37888 "EHLO
        elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935664AbcJVR3g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Oct 2016 13:29:36 -0400
Received: from [24.144.93.62] (helo=localhost.localdomain)
        by elasmtp-banded.atl.sa.earthlink.net with esmtpa (Exim 4.67)
        (envelope-from <jonathan.625266@earthlink.net>)
        id 1by06s-0007w2-FE
        for linux-media@vger.kernel.org; Sat, 22 Oct 2016 13:29:30 -0400
Date: Sat, 22 Oct 2016 13:29:30 -0400
From: Jonathan Sims <jonathan.625266@earthlink.net>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH 1/1] hdpvr: fix interrupted recording
Message-ID: <20161022132930.4bc79a7a@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a reworking of a patch originally submitted by Ryley Angus, modified by Hans Verkuil and then seemingly forgotten before changes suggested by Keith Pyle here:

http://linux-media.vger.kernel.narkive.com/vkxuOKwi/patch-hdpvr-fix-interrupted-recording#post3

were made and tested.

I have implemented the suggested changes and have been testing for the last 2 months. I am no longer experiencing lockups while recording (with blue light on, requiring power cycling) which had been a long standing problem with the HD-PVR. I have not noticed any other problems since applying the patch.

- Jon

--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -454,6 +454,7 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 
 		if (buf->status != BUFSTAT_READY &&
 		    dev->status != STATUS_DISCONNECTED) {
+			int err;
 			/* return nonblocking */
 			if (file->f_flags & O_NONBLOCK) {
 				if (!ret)
@@ -461,9 +462,24 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 				goto err;
 			}
 
-			if (wait_event_interruptible(dev->wait_data,
-					      buf->status == BUFSTAT_READY))
-				return -ERESTARTSYS;
+			err = wait_event_interruptible_timeout(dev->wait_data,
+				buf->status == BUFSTAT_READY,
+				msecs_to_jiffies(1000));
+			if (err < 0) {
+				ret = err;
+				goto err;
+			}
+			if (!err) {
+				v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
+					"timeout: restart streaming\n");
+				hdpvr_stop_streaming(dev);
+				msecs_to_jiffies(4000);
+				err = hdpvr_start_streaming(dev);
+				if (err) {
+					ret = err;
+					goto err;
+				}
+			}
 		}
 
 		if (buf->status != BUFSTAT_READY)
-- 
2.10.0
