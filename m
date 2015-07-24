Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:54518 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526AbbGXKW4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 06:22:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/7] v4l2-fh: v4l2_fh_add/del now return whether it was the first or last fh.
Date: Fri, 24 Jul 2015 12:21:31 +0200
Message-Id: <1437733296-38198-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
References: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplify driver code by letting v4l2_fh_add/del return true if the
filehandle was the first open or the last close.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-fh.c | 10 ++++++++--
 include/media/v4l2-fh.h           | 10 ++++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
index 20c0a0c..325e378 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -52,14 +52,17 @@ void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_init);
 
-void v4l2_fh_add(struct v4l2_fh *fh)
+bool v4l2_fh_add(struct v4l2_fh *fh)
 {
 	unsigned long flags;
+	bool is_first;
 
 	v4l2_prio_open(fh->vdev->prio, &fh->prio);
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+	is_first = list_empty(&fh->vdev->fh_list);
 	list_add(&fh->list, &fh->vdev->fh_list);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+	return is_first;
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_add);
 
@@ -77,14 +80,17 @@ int v4l2_fh_open(struct file *filp)
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_open);
 
-void v4l2_fh_del(struct v4l2_fh *fh)
+bool v4l2_fh_del(struct v4l2_fh *fh)
 {
 	unsigned long flags;
+	bool is_last;
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	list_del_init(&fh->list);
+	is_last = list_empty(&fh->vdev->fh_list);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 	v4l2_prio_close(fh->vdev->prio, fh->prio);
+	return is_last;
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_del);
 
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 13dcaae..17215fc 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -60,9 +60,10 @@ struct v4l2_fh {
 void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev);
 /*
  * Add the fh to the list of file handles on a video_device. The file
- * handle must be initialised first.
+ * handle must be initialised first. This function will return true
+ * if the new filehandle was the first filehandle added and false otherwise.
  */
-void v4l2_fh_add(struct v4l2_fh *fh);
+bool v4l2_fh_add(struct v4l2_fh *fh);
 /*
  * Can be used as the open() op of v4l2_file_operations.
  * It allocates a v4l2_fh and inits and adds it to the video_device associated
@@ -73,9 +74,10 @@ int v4l2_fh_open(struct file *filp);
  * Remove file handle from the list of file handles. Must be called in
  * v4l2_file_operations->release() handler if the driver uses v4l2_fh.
  * On error filp->private_data will be NULL, otherwise it will point to
- * the v4l2_fh struct.
+ * the v4l2_fh struct. This function will return true if this was the
+ * last open filehandle and false otherwise.
  */
-void v4l2_fh_del(struct v4l2_fh *fh);
+bool v4l2_fh_del(struct v4l2_fh *fh);
 /*
  * Release resources related to a file handle. Parts of the V4L2
  * framework using the v4l2_fh must release their resources here, too.
-- 
2.1.4

