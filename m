Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:55134 "EHLO
        elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750930AbdBOBSl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 20:18:41 -0500
Date: Tue, 14 Feb 2017 20:18:32 -0500
From: Jonathan Sims <jonathan.625266@earthlink.net>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, kpyle@austin.rr.com, ryleyjangus@gmail.com
Subject: [PATCH 1/1] hdpvr: code cleanup
Message-ID: <20170214201832.7a418b5a@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a code cleanup after recent changes introduced by commit a503ff812430e104f591287b512aa4e3a83f20b1.

Signed-off-by: Jonathan Sims <jonathan.625266@earthlink.net>
---

 drivers/media/usb/hdpvr/hdpvr-video.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 7fb036d6a86e..b2ce5c0807fb 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -449,7 +449,7 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 
 		if (buf->status != BUFSTAT_READY &&
 		    dev->status != STATUS_DISCONNECTED) {
-			int err;
+
 			/* return nonblocking */
 			if (file->f_flags & O_NONBLOCK) {
 				if (!ret)
@@ -457,23 +457,19 @@ static ssize_t hdpvr_read(struct file *file, char
__user *buffer, size_t count, goto err;
 			}
 
-			err =
wait_event_interruptible_timeout(dev->wait_data,
+			ret =
wait_event_interruptible_timeout(dev->wait_data, buf->status ==
BUFSTAT_READY, msecs_to_jiffies(1000));
-			if (err < 0) {
-				ret = err;
+			if (ret < 0)
 				goto err;
-			}
-			if (!err) {
+			if (!ret) {
 				v4l2_dbg(MSG_INFO, hdpvr_debug,
&dev->v4l2_dev, "timeout: restart streaming\n");
 				hdpvr_stop_streaming(dev);
-				msecs_to_jiffies(4000);
-				err = hdpvr_start_streaming(dev);
-				if (err) {
-					ret = err;
+				msleep(4000);
+				ret = hdpvr_start_streaming(dev);
+				if (ret)
 					goto err;
-				}
 			}
 		}
 
-- 
2.11.1
