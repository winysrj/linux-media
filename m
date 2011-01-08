Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2762 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab1AHNhD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 08:37:03 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p08Dalk1015112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 8 Jan 2011 14:37:01 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 04/16] v4l2-fh: add v4l2_fh_open and v4l2_fh_release helper functions
Date: Sat,  8 Jan 2011 14:36:29 +0100
Message-Id: <17f432ce5aa3d1f7a995cd8fc2e1bd30893e36c9.1294493428.git.hverkuil@xs4all.nl>
In-Reply-To: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
References: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
References: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add two new functions: v4l2_fh_open allocates and initializes a struct v4l2_fh
based on a struct file pointer and v4l2_fh_release releases and frees a struct
v4l2_fh.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-fh.c |   28 ++++++++++++++++++++++++++++
 include/media/v4l2-fh.h       |   15 +++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index 78a1608..27242e5 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/slab.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
@@ -60,6 +61,20 @@ void v4l2_fh_add(struct v4l2_fh *fh)
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_add);
 
+int v4l2_fh_open(struct file *filp)
+{
+	struct video_device *vdev = video_devdata(filp);
+	struct v4l2_fh *fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+
+	filp->private_data = fh;
+	if (fh == NULL)
+		return -ENOMEM;
+	v4l2_fh_init(fh, vdev);
+	v4l2_fh_add(fh);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_fh_open);
+
 void v4l2_fh_del(struct v4l2_fh *fh)
 {
 	unsigned long flags;
@@ -81,3 +96,16 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 	v4l2_event_free(fh);
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_exit);
+
+int v4l2_fh_release(struct file *filp)
+{
+	struct v4l2_fh *fh = filp->private_data;
+
+	if (fh) {
+		v4l2_fh_del(fh);
+		v4l2_fh_exit(fh);
+		kfree(fh);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_fh_release);
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 5fc5ba9..5657881 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -51,8 +51,16 @@ int v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev);
  */
 void v4l2_fh_add(struct v4l2_fh *fh);
 /*
+ * Can be used as the open() op of v4l2_file_operations.
+ * It allocates a v4l2_fh and inits and adds it to the video_device associated
+ * with the file pointer.
+ */
+int v4l2_fh_open(struct file *filp);
+/*
  * Remove file handle from the list of file handles. Must be called in
  * v4l2_file_operations->release() handler if the driver uses v4l2_fh.
+ * On error filp->private_data will be NULL, otherwise it will point to
+ * the v4l2_fh struct.
  */
 void v4l2_fh_del(struct v4l2_fh *fh);
 /*
@@ -62,5 +70,12 @@ void v4l2_fh_del(struct v4l2_fh *fh);
  * driver uses v4l2_fh.
  */
 void v4l2_fh_exit(struct v4l2_fh *fh);
+/*
+ * Can be used as the release() op of v4l2_file_operations.
+ * It deletes and exits the v4l2_fh associated with the file pointer and
+ * frees it. It will do nothing if filp->private_data (the pointer to the
+ * v4l2_fh struct) is NULL. This function always returns 0.
+ */
+int v4l2_fh_release(struct file *filp);
 
 #endif /* V4L2_EVENT_H */
-- 
1.7.0.4

