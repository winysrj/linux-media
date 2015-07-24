Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:48261 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526AbbGXKW5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 06:22:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/7] v4l2-fh: add v4l2_fh_open_is_first and v4l2_fh_release_is_last
Date: Fri, 24 Jul 2015 12:21:32 +0200
Message-Id: <1437733296-38198-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
References: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add new helper functions that report back if this was the first open
or last close.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-fh.c | 25 ++++++++++++++-----------
 include/media/v4l2-fh.h           | 27 +++++++++++++++++++++++++--
 2 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
index 325e378..ac9c028 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -66,19 +66,21 @@ bool v4l2_fh_add(struct v4l2_fh *fh)
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_add);
 
-int v4l2_fh_open(struct file *filp)
+bool v4l2_fh_open_is_first(struct file *filp, int *err)
 {
 	struct video_device *vdev = video_devdata(filp);
 	struct v4l2_fh *fh = kzalloc(sizeof(*fh), GFP_KERNEL);
 
+	*err = fh ? -ENOMEM : 0;
+
 	filp->private_data = fh;
-	if (fh == NULL)
-		return -ENOMEM;
-	v4l2_fh_init(fh, vdev);
-	v4l2_fh_add(fh);
-	return 0;
+	if (fh) {
+		v4l2_fh_init(fh, vdev);
+		return v4l2_fh_add(fh);
+	}
+	return false;
 }
-EXPORT_SYMBOL_GPL(v4l2_fh_open);
+EXPORT_SYMBOL_GPL(v4l2_fh_open_is_first);
 
 bool v4l2_fh_del(struct v4l2_fh *fh)
 {
@@ -103,18 +105,19 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_exit);
 
-int v4l2_fh_release(struct file *filp)
+bool v4l2_fh_release_is_last(struct file *filp)
 {
 	struct v4l2_fh *fh = filp->private_data;
+	bool is_last = false;
 
 	if (fh) {
-		v4l2_fh_del(fh);
+		is_last = v4l2_fh_del(fh);
 		v4l2_fh_exit(fh);
 		kfree(fh);
 	}
-	return 0;
+	return is_last;
 }
-EXPORT_SYMBOL_GPL(v4l2_fh_release);
+EXPORT_SYMBOL_GPL(v4l2_fh_release_is_last);
 
 bool v4l2_fh_is_singular(struct v4l2_fh *fh)
 {
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 17215fc..e937866 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -65,11 +65,23 @@ void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev);
  */
 bool v4l2_fh_add(struct v4l2_fh *fh);
 /*
+ * It allocates a v4l2_fh and inits and adds it to the video_device associated
+ * with the file pointer. In addition it returns true if this was the first
+ * open and false otherwise. The error code is returned in *err.
+ */
+bool v4l2_fh_open_is_first(struct file *filp, int *err);
+/*
  * Can be used as the open() op of v4l2_file_operations.
  * It allocates a v4l2_fh and inits and adds it to the video_device associated
  * with the file pointer.
  */
-int v4l2_fh_open(struct file *filp);
+static inline int v4l2_fh_open(struct file *filp)
+{
+	int err;
+
+	v4l2_fh_open_is_first(filp, &err);
+	return err;
+}
 /*
  * Remove file handle from the list of file handles. Must be called in
  * v4l2_file_operations->release() handler if the driver uses v4l2_fh.
@@ -86,12 +98,23 @@ bool v4l2_fh_del(struct v4l2_fh *fh);
  */
 void v4l2_fh_exit(struct v4l2_fh *fh);
 /*
+ * It deletes and exits the v4l2_fh associated with the file pointer and
+ * frees it. It will do nothing if filp->private_data (the pointer to the
+ * v4l2_fh struct) is NULL. This function returns true if this was the
+ * last open file handle and false otherwise.
+ */
+bool v4l2_fh_release_is_last(struct file *filp);
+/*
  * Can be used as the release() op of v4l2_file_operations.
  * It deletes and exits the v4l2_fh associated with the file pointer and
  * frees it. It will do nothing if filp->private_data (the pointer to the
  * v4l2_fh struct) is NULL. This function always returns 0.
  */
-int v4l2_fh_release(struct file *filp);
+static inline int v4l2_fh_release(struct file *filp)
+{
+	v4l2_fh_release_is_last(filp);
+	return 0;
+}
 /*
  * Returns true if this filehandle is the only filehandle opened for the
  * associated video_device. If fh is NULL, then it returns false.
-- 
2.1.4

