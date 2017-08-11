Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57155
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751373AbdHKAQ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 20:16:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Tomasz Figa <tfiga@chromium.org>
Subject: [PATCH 3/3] media: compat32: reimplement ctrl_is_pointer()
Date: Thu, 10 Aug 2017 21:16:52 -0300
Message-Id: <61aa2790f909de645a02f7bf5a91c68bff2b9076.1502409182.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1502409182.git.mchehab@s-opensource.com>
References: <f7340d67-cf7c-3407-e59a-aa0261185e82@xs4all.nl>
 <cover.1502409182.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1502409182.git.mchehab@s-opensource.com>
References: <cover.1502409182.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current way that this function works is subject to problems
as new controls gets added. Move it to v4l2-ctrls and use the
knowledge that v4l2_ctrl_fill() has about controls, in order to
detect if a given control is a pointer.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 18 +-----------------
 drivers/media/v4l2-core/v4l2-ctrls.c          | 18 ++++++++++++++++++
 include/media/v4l2-ctrls.h                    |  8 ++++++++
 3 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index af8b4c5b0efa..0adcc37280c8 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -19,6 +19,7 @@
 #include <linux/v4l2-subdev.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 
 static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
@@ -668,23 +669,6 @@ struct v4l2_ext_control32 {
 	};
 } __attribute__ ((packed));
 
-/* The following function really belong in v4l2-common, but that causes
-   a circular dependency between modules. We need to think about this, but
-   for now this will do. */
-
-/* Return non-zero if this control is a pointer type. Currently only
-   type STRING is a pointer type. */
-static inline int ctrl_is_pointer(u32 id)
-{
-	switch (id) {
-	case V4L2_CID_RDS_TX_PS_NAME:
-	case V4L2_CID_RDS_TX_RADIO_TEXT:
-		return 1;
-	default:
-		return 0;
-	}
-}
-
 static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext_controls32 __user *up)
 {
 	struct v4l2_ext_control32 __user *ucontrols;
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index c512b7539077..0d5dab485723 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1254,6 +1254,24 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 }
 EXPORT_SYMBOL(v4l2_ctrl_fill);
 
+bool ctrl_is_pointer(u32 id)
+{
+	enum v4l2_ctrl_type type;
+
+	v4l2_ctrl_fill(id, NULL, &type, NULL, NULL, NULL, NULL, NULL);
+
+	switch (type) {
+	case V4L2_CTRL_TYPE_STRING:
+	case V4L2_CTRL_TYPE_U8:
+	case V4L2_CTRL_TYPE_U16:
+	case V4L2_CTRL_TYPE_U32:
+		return true;
+	default:
+		return false;
+	}
+}
+EXPORT_SYMBOL(ctrl_is_pointer);
+
 static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 changes)
 {
 	memset(ev->reserved, 0, sizeof(ev->reserved));
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index e22dea218a4c..bc6772f50956 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -367,6 +367,14 @@ struct v4l2_ctrl_config {
 void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		    s64 *min, s64 *max, u64 *step, s64 *def, u32 *flags);
 
+/**
+ * ctrl_is_pointer - Returns non-zero if this control is a pointer type.
+ *
+ * @id: ID of the control
+ *
+ * Currently only STRING and compound types are pointers.
+ */
+bool ctrl_is_pointer(u32 id);
 
 /**
  * v4l2_ctrl_handler_init_class() - Initialize the control handler.
-- 
2.13.3
