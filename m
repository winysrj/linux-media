Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53135 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab3HERwi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 13:52:38 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v6 04/10] media: vb2: Take queue or device lock in vb2_fop_mmap()
Date: Mon,  5 Aug 2013 19:53:23 +0200
Message-Id: <1375725209-2674-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1375725209-2674-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1375725209-2674-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2_fop_mmap() function is a plug-in implementation of the mmap()
file operation that calls vb2_mmap() on the queue associated with the
video device. Neither the vb2_fop_mmap() function nor the v4l2_mmap()
mmap handler in the V4L2 core take any lock, leading to race conditions
between mmap() and other buffer-related ioctls such as VIDIOC_REQBUFS.

Fix it by taking the queue or device lock around the vb2_mmap() call.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 9fc4bab..bd4bade 100644
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
 
-- 
1.8.1.5

