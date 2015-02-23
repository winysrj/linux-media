Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42922 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbbBWUTo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 15:19:44 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 3/3] media: omap3isp: ispvideo: use vb2_fop_mmap/poll
Date: Mon, 23 Feb 2015 20:19:33 +0000
Message-Id: <1424722773-20131-4-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424722773-20131-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1424722773-20131-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

No need to reinvent the wheel. Just use the already existing
functions provided v4l-core.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index b648176..5dd5ffc 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1277,37 +1277,13 @@ static int isp_video_release(struct file *file)
 	return ret;
 }
 
-static unsigned int isp_video_poll(struct file *file, poll_table *wait)
-{
-	struct isp_video *video = video_drvdata(file);
-	int ret;
-
-	mutex_lock(&video->queue_lock);
-	ret = vb2_poll(&video->queue, file, wait);
-	mutex_unlock(&video->queue_lock);
-
-	return ret;
-}
-
-static int isp_video_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct isp_video *video = video_drvdata(file);
-	int ret;
-
-	mutex_lock(&video->queue_lock);
-	ret = vb2_mmap(&video->queue, vma);
-	mutex_unlock(&video->queue_lock);
-
-	return ret;
-}
-
 static struct v4l2_file_operations isp_video_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = video_ioctl2,
 	.open = isp_video_open,
 	.release = isp_video_release,
-	.poll = isp_video_poll,
-	.mmap = isp_video_mmap,
+	.poll = vb2_fop_poll,
+	.mmap = vb2_fop_mmap,
 };
 
 /* -----------------------------------------------------------------------------
@@ -1389,6 +1365,8 @@ int omap3isp_video_register(struct isp_video *video, struct v4l2_device *vdev)
 
 	video->video.v4l2_dev = vdev;
 
+	/* queue isnt initalized */
+	video->video.queue = &video->queue;
 	ret = video_register_device(&video->video, VFL_TYPE_GRABBER, -1);
 	if (ret < 0)
 		dev_err(video->isp->dev,
-- 
2.1.0

