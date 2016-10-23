Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:54131 "EHLO
        elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755088AbcJWSTO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 14:19:14 -0400
Date: Sun, 23 Oct 2016 14:19:07 -0400
From: Jonathan Sims <jonathan.625266@earthlink.net>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, kpyle@austin.rr.com,
        ryleyjangus@gmail.com
Subject: [RFCv2 PATCH RESEND 1/1] hdpvr: fix interrupted recording
Message-ID: <20161023141907.25693b37@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[ Correcting my earlier message - sorry, newbie here ]

This is a reworking of a patch originally submitted by Ryley Angus, modified by Hans Verkuil and then seemingly forgotten before changes suggested by Keith Pyle here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg75163.html

were made and tested.

I have implemented the suggested changes and have been testing for the last 2 months. I am no longer experiencing lockups while recording (with blue light on, requiring power cycling) which had been a long standing problem with the HD-PVR. I have not noticed any other problems since applying the patch.

Signed-off-by: Jonathan Sims <jonathan.625266@earthlink.net>
---
 drivers/media/usb/hdpvr/hdpvr-video.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 2a3a8b4..08e69dc 100644
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
