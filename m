Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:60300 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbbGXKXA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 06:23:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 5/7] vb2: _vb2_fop_release returns if this was the last fh.
Date: Fri, 24 Jul 2015 12:21:34 +0200
Message-Id: <1437733296-38198-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
References: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

_vb2_fop_release now returns true if this was the last open fh.
This will simplify drivers that call it and that need to check if it
was the last close.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 7 ++++---
 include/media/videobuf2-core.h           | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index b866a6b..f348b8a 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -3452,7 +3452,7 @@ int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
 }
 EXPORT_SYMBOL_GPL(vb2_fop_mmap);
 
-int _vb2_fop_release(struct file *file, struct mutex *lock)
+bool _vb2_fop_release(struct file *file, struct mutex *lock)
 {
 	struct video_device *vdev = video_devdata(file);
 
@@ -3464,7 +3464,7 @@ int _vb2_fop_release(struct file *file, struct mutex *lock)
 	}
 	if (lock)
 		mutex_unlock(lock);
-	return v4l2_fh_release(file);
+	return v4l2_fh_release_is_last(file);
 }
 EXPORT_SYMBOL_GPL(_vb2_fop_release);
 
@@ -3473,7 +3473,8 @@ int vb2_fop_release(struct file *file)
 	struct video_device *vdev = video_devdata(file);
 	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
 
-	return _vb2_fop_release(file, lock);
+	_vb2_fop_release(file, lock);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_fop_release);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 22a44c2..7ed4c37 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -644,7 +644,7 @@ int vb2_ioctl_expbuf(struct file *file, void *priv,
 
 int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma);
 int vb2_fop_release(struct file *file);
-int _vb2_fop_release(struct file *file, struct mutex *lock);
+bool _vb2_fop_release(struct file *file, struct mutex *lock);
 ssize_t vb2_fop_write(struct file *file, const char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vb2_fop_read(struct file *file, char __user *buf,
-- 
2.1.4

