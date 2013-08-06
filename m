Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60799 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab3HFUJy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 16:09:54 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org
Subject: [PATCH v7] media: vb2: Take queue or device lock in mmap-related vb2 ioctl handlers
Date: Tue,  6 Aug 2013 22:10:48 +0200
Message-Id: <1375819848-2658-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <201308061239.27188.hverkuil@xs4all.nl>
References: <201308061239.27188.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2_fop_mmap() and vb2_fop_get_unmapped_area() functions are plug-in
implementation of the mmap() and get_unmapped_area() file operations
that calls vb2_mmap() and vb2_get_unmapped_area() on the queue
associated with the video device. Neither the
vb2_fop_mmap/vb2_fop_get_unmapped_area nor the
v4l2_mmap/vb2_get_unmapped_area functions in the V4L2 core take any
lock, leading to race conditions between mmap/get_unmapped_area and
other buffer-related ioctls such as VIDIOC_REQBUFS.

Fix it by taking the queue or device lock around the vb2_mmap() and
vb2_get_unmapped_area() calls.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 9fc4bab..c9b50c7 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2578,8 +2578,15 @@ EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
 int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct video_device *vdev = video_devdata(file);
+	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
+	int err;
 
-	return vb2_mmap(vdev->queue, vma);
+	if (lock && mutex_lock_interruptible(lock))
+		return -ERESTARTSYS;
+	err = vb2_mmap(vdev->queue, vma);
+	if (lock)
+		mutex_unlock(lock);
+	return err;
 }
 EXPORT_SYMBOL_GPL(vb2_fop_mmap);
 
@@ -2685,8 +2692,15 @@ unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	struct video_device *vdev = video_devdata(file);
+	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
+	int ret;
 
-	return vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
+	if (lock && mutex_lock_interruptible(lock))
+		return -ERESTARTSYS;
+	ret = vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
+	if (lock)
+		mutex_unlock(lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
 #endif
-- 
Regards,

Laurent Pinchart

