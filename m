Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59774 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319AbaLAUNT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 15:13:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>
Subject: [PATCH v4 07/10] v4l: vb2: Fix race condition in _vb2_fop_release
Date: Mon,  1 Dec 2014 22:13:37 +0200
Message-Id: <1417464820-6718-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1417464820-6718-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1417464820-6718-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function releases the queue if the file being released is the queue
owner. The check reads the queue->owner field without taking the queue
lock, creating a race condition with functions that set the queue owner,
such as vb2_ioctl_reqbufs() for instance.

Fix this by moving the queue->owner check within the mutex protected
section.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 2685670..d09a891 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -3389,14 +3389,14 @@ int _vb2_fop_release(struct file *file, struct mutex *lock)
 {
 	struct video_device *vdev = video_devdata(file);
 
+	if (lock)
+		mutex_lock(lock);
 	if (file->private_data == vdev->queue->owner) {
-		if (lock)
-			mutex_lock(lock);
 		vb2_queue_release(vdev->queue);
 		vdev->queue->owner = NULL;
-		if (lock)
-			mutex_unlock(lock);
 	}
+	if (lock)
+		mutex_unlock(lock);
 	return v4l2_fh_release(file);
 }
 EXPORT_SYMBOL_GPL(_vb2_fop_release);
-- 
2.0.4

