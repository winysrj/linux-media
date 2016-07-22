Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40448 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbcGVPDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 11:03:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 05/11] [media] v4l2-fh.h: add documentation for it
Date: Fri, 22 Jul 2016 12:03:01 -0300
Message-Id: <270ea961b9908dba032c696da6172ccb2cc86907.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This header file was undocumented. Add documentation for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-core.rst |   1 +
 Documentation/media/kapi/v4l2-fh.rst   |   3 +
 include/media/v4l2-fh.h                | 128 ++++++++++++++++++++++++---------
 3 files changed, 100 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/media/kapi/v4l2-fh.rst

diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
index 6fa30f8908dd..67eaf0c0b6b6 100644
--- a/Documentation/media/kapi/v4l2-core.rst
+++ b/Documentation/media/kapi/v4l2-core.rst
@@ -8,6 +8,7 @@ Video2Linux devices
     v4l2-dev
     v4l2-controls
     v4l2-device
+    v4l2-fh
     v4l2-dv-timings
     v4l2-event
     v4l2-flash-led-class
diff --git a/Documentation/media/kapi/v4l2-fh.rst b/Documentation/media/kapi/v4l2-fh.rst
new file mode 100644
index 000000000000..9309c18e967a
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-fh.rst
@@ -0,0 +1,3 @@
+V4L2 File Handler kAPI
+^^^^^^^^^^^^^^^^^^^^^^
+.. kernel-doc:: include/media/v4l2-fh.h
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 803516775162..e19e6246e21c 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -33,6 +33,21 @@
 struct video_device;
 struct v4l2_ctrl_handler;
 
+/**
+ * struct v4l2_fh - Describes a V4L2 file handler
+ *
+ * @list: list of file handlers
+ * @vdev: pointer to &struct video_device
+ * @ctrl_handler: pointer to &struct v4l2_ctrl_handler
+ * @prio: priority of the file handler, as defined by &enum v4l2_priority
+ *
+ * @wait: event' s wait queue
+ * @subscribed: list of subscribed events
+ * @available: list of events waiting to be dequeued
+ * @navailable: number of available events at @available list
+ * @sequence: event sequence number
+ * @m2m_ctx: pointer to &struct v4l2_m2m_ctx
+ */
 struct v4l2_fh {
 	struct list_head	list;
 	struct video_device	*vdev;
@@ -41,8 +56,8 @@ struct v4l2_fh {
 
 	/* Events */
 	wait_queue_head_t	wait;
-	struct list_head	subscribed; /* Subscribed events */
-	struct list_head	available; /* Dequeueable event */
+	struct list_head	subscribed;
+	struct list_head	available;
 	unsigned int		navailable;
 	u32			sequence;
 
@@ -51,53 +66,102 @@ struct v4l2_fh {
 #endif
 };
 
-/*
- * Initialise the file handle. Parts of the V4L2 framework using the
+/**
+ * v4l2_fh_init - Initialise the file handle.
+ *
+ * @fh: pointer to &struct v4l2_fh
+ * @vdev: pointer to &struct video_device
+ *
+ * Parts of the V4L2 framework using the
  * file handles should be initialised in this function. Must be called
- * from driver's v4l2_file_operations->open() handler if the driver
- * uses v4l2_fh.
+ * from driver's v4l2_file_operations->open\(\) handler if the driver
+ * uses &struct v4l2_fh.
  */
 void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev);
-/*
- * Add the fh to the list of file handles on a video_device. The file
- * handle must be initialised first.
+
+/**
+ * v4l2_fh_add - Add the fh to the list of file handles on a video_device.
+ *
+ * @fh: pointer to &struct v4l2_fh
+ *
+ * .. note::
+ *    The @fh file handle must be initialised first.
  */
 void v4l2_fh_add(struct v4l2_fh *fh);
-/*
- * Can be used as the open() op of v4l2_file_operations.
- * It allocates a v4l2_fh and inits and adds it to the video_device associated
- * with the file pointer.
+
+/**
+ * v4l2_fh_open - Ancillary routine that can be used as the open\(\) op
+ *	of v4l2_file_operations.
+ *
+ * @filp: pointer to struct file
+ *
+ * It allocates a v4l2_fh and inits and adds it to the &struct video_device
+ * associated with the file pointer.
  */
 int v4l2_fh_open(struct file *filp);
-/*
- * Remove file handle from the list of file handles. Must be called in
- * v4l2_file_operations->release() handler if the driver uses v4l2_fh.
- * On error filp->private_data will be NULL, otherwise it will point to
- * the v4l2_fh struct.
+
+/**
+ * v4l2_fh_del - Remove file handle from the list of file handles.
+ *
+ * @fh: pointer to &struct v4l2_fh
+ *
+ * On error filp->private_data will be %NULL, otherwise it will point to
+ * the &struct v4l2_fh.
+ *
+ * .. note::
+ *    Must be called in v4l2_file_operations->release\(\) handler if the driver
+ *    uses &struct v4l2_fh.
  */
 void v4l2_fh_del(struct v4l2_fh *fh);
-/*
- * Release resources related to a file handle. Parts of the V4L2
- * framework using the v4l2_fh must release their resources here, too.
- * Must be called in v4l2_file_operations->release() handler if the
- * driver uses v4l2_fh.
+
+/**
+ * v4l2_fh_exit - Release resources related to a file handle.
+ *
+ * @fh: pointer to &struct v4l2_fh
+ *
+ * Parts of the V4L2 framework using the v4l2_fh must release their
+ * resources here, too.
+ *
+ * .. note::
+ *    Must be called in v4l2_file_operations->release\(\) handler if the
+ *    driver uses &struct v4l2_fh.
  */
 void v4l2_fh_exit(struct v4l2_fh *fh);
-/*
- * Can be used as the release() op of v4l2_file_operations.
+
+/**
+ * v4l2_fh_release - Ancillary routine that can be used as the release\(\) op
+ *	of v4l2_file_operations.
+ *
+ * @filp: pointer to struct file
+ *
  * It deletes and exits the v4l2_fh associated with the file pointer and
  * frees it. It will do nothing if filp->private_data (the pointer to the
- * v4l2_fh struct) is NULL. This function always returns 0.
+ * v4l2_fh struct) is %NULL.
+ *
+ * This function always returns 0.
  */
 int v4l2_fh_release(struct file *filp);
-/*
- * Returns 1 if this filehandle is the only filehandle opened for the
- * associated video_device. If fh is NULL, then it returns 0.
+
+/**
+ * v4l2_fh_is_singular - Returns 1 if this filehandle is the only filehandle
+ *	 opened for the associated video_device.
+ *
+ * @fh: pointer to &struct v4l2_fh
+ *
+ * If @fh is NULL, then it returns 0.
  */
 int v4l2_fh_is_singular(struct v4l2_fh *fh);
-/*
- * Helper function with struct file as argument. If filp->private_data is
- * NULL, then it will return 0.
+
+/**
+ * v4l2_fh_is_singular_file - Returns 1 if this filehandle is the only
+ *	filehandle opened for the associated video_device.
+ *
+ * @filp: pointer to struct file
+ *
+ * This is a helper function variant of v4l2_fh_is_singular() with uses
+ * struct file as argument.
+ *
+ * If filp->private_data is %NULL, then it will return 0.
  */
 static inline int v4l2_fh_is_singular_file(struct file *filp)
 {
-- 
2.7.4

