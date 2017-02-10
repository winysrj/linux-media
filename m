Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:42865 "EHLO
        elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750990AbdBJAzm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Feb 2017 19:55:42 -0500
Date: Thu, 9 Feb 2017 19:54:39 -0500
From: Jonathan Sims <jonathan.625266@earthlink.net>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, kpyle@austin.rr.com, ryleyjangus@gmail.com
Subject: [RFCv4 PATCH 1/1] hdpvr: fix interrupted recording
Message-ID: <20170209195439.4e9f89d1@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a reworking of a patch originally submitted by Ryley Angus, modified by Hans Verkuil and then seemingly forgotten before changes suggested by Keith Pyle here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg75163.html

were made and tested.

I have implemented the suggested changes and have been testing for several months. I am no longer experiencing lockups while recording (with blue light on, requiring power cycling) which had been a long standing problem with the HD-PVR. I have not noticed any other problems since applying the patch.

Signed-off-by: Jonathan Sims <jonathan.625266@earthlink.net>
---

Changes in v4:
- Code cleanups.

 drivers/media/usb/hdpvr/hdpvr-video.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 474c11e1d495..f8ba28cb40eb 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -458,9 +458,20 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 				goto err;
 			}
 
-			if (wait_event_interruptible(dev->wait_data,
-					      buf->status == BUFSTAT_READY))
-				return -ERESTARTSYS;
+			ret = wait_event_interruptible_timeout(dev->wait_data,
+				buf->status == BUFSTAT_READY,
+				msecs_to_jiffies(1000));
+			if (ret < 0)
+				goto err;
+			if (!ret) {
+				v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
+					"timeout: restart streaming\n");
+				hdpvr_stop_streaming(dev);
+				msleep(4000);
+				ret = hdpvr_start_streaming(dev);
+				if (ret)
+					goto err;
+			}
 		}
 
 		if (buf->status != BUFSTAT_READY)
-- 
2.11.1
