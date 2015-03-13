Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40787 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbbCMAdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 20:33:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media: omap3isp: video: Don't call vb2 mmap with queue lock held
Date: Fri, 13 Mar 2015 02:33:35 +0200
Message-Id: <1426206815-15503-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf2 has long been subject to AB-BA style deadlocks due to the
queue lock and mmap_sem being taken in different orders for the mmap
operation. The problem has been fixed by making this operation callable
without taking the queue lock, using an mmap_lock internal to videobuf2.

The omap3isp driver still calls the mmap operation with the queue lock
held, resulting in a potential deadlock. As the operation can now be
called without locking the queue, fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 3fe9047..89ef31b 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1326,14 +1326,8 @@ static unsigned int isp_video_poll(struct file *file, poll_table *wait)
 static int isp_video_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(file->private_data);
-	struct isp_video *video = video_drvdata(file);
-	int ret;
-
-	mutex_lock(&video->queue_lock);
-	ret = vb2_mmap(&vfh->queue, vma);
-	mutex_unlock(&video->queue_lock);
 
-	return ret;
+	return vb2_mmap(&vfh->queue, vma);
 }
 
 static struct v4l2_file_operations isp_video_fops = {
-- 
Regards,

Laurent Pinchart

