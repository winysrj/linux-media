Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4906 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab0EIT1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 15:27:34 -0400
Received: from localhost (cm-84.208.87.21.getinternet.no [84.208.87.21])
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id o49JRWUH037432
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 9 May 2010 21:27:33 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <995b321ab2b5df48dd204bd1915bc79e19a118e2.1273432986.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1273432986.git.hverkuil@xs4all.nl>
References: <cover.1273432986.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 09 May 2010 21:29:07 +0200
Subject: [PATCH 1/7] [RFC] v4l2_prio: move from v4l2-common to v4l2-device.
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We are going to move priority handling into the v4l2 core. As a consequence
the v4l2_prio helper functions need to be moved into the core videodev
module as well to prevent circular dependencies.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/cpia2/cpia2.h          |    1 +
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c |    1 +
 drivers/media/video/v4l2-common.c          |   59 ---------------------------
 drivers/media/video/v4l2-device.c          |   61 ++++++++++++++++++++++++++++
 include/media/v4l2-common.h                |   15 -------
 include/media/v4l2-device.h                |   15 +++++++
 6 files changed, 78 insertions(+), 74 deletions(-)

diff --git a/drivers/media/video/cpia2/cpia2.h b/drivers/media/video/cpia2/cpia2.h
index 8d2dfc1..4e2f623 100644
--- a/drivers/media/video/cpia2/cpia2.h
+++ b/drivers/media/video/cpia2/cpia2.h
@@ -33,6 +33,7 @@
 
 #include <linux/version.h>
 #include <linux/videodev.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <linux/usb.h>
 #include <linux/poll.h>
diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index 338bcc6..9b521f2 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -29,6 +29,7 @@
 #include "pvrusb2-ioread.h"
 #include <linux/videodev2.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 4e53b0b..b53c497 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -81,65 +81,6 @@ MODULE_LICENSE("GPL");
  */
 
 
-/* ----------------------------------------------------------------- */
-/* priority handling                                                 */
-
-#define V4L2_PRIO_VALID(val) (val == V4L2_PRIORITY_BACKGROUND   || \
-			      val == V4L2_PRIORITY_INTERACTIVE  || \
-			      val == V4L2_PRIORITY_RECORD)
-
-void v4l2_prio_init(struct v4l2_prio_state *global)
-{
-	memset(global, 0, sizeof(*global));
-}
-EXPORT_SYMBOL(v4l2_prio_init);
-
-int v4l2_prio_change(struct v4l2_prio_state *global, enum v4l2_priority *local,
-		     enum v4l2_priority new)
-{
-	if (!V4L2_PRIO_VALID(new))
-		return -EINVAL;
-	if (*local == new)
-		return 0;
-
-	atomic_inc(&global->prios[new]);
-	if (V4L2_PRIO_VALID(*local))
-		atomic_dec(&global->prios[*local]);
-	*local = new;
-	return 0;
-}
-EXPORT_SYMBOL(v4l2_prio_change);
-
-void v4l2_prio_open(struct v4l2_prio_state *global, enum v4l2_priority *local)
-{
-	v4l2_prio_change(global, local, V4L2_PRIORITY_DEFAULT);
-}
-EXPORT_SYMBOL(v4l2_prio_open);
-
-void v4l2_prio_close(struct v4l2_prio_state *global, enum v4l2_priority local)
-{
-	if (V4L2_PRIO_VALID(local))
-		atomic_dec(&global->prios[local]);
-}
-EXPORT_SYMBOL(v4l2_prio_close);
-
-enum v4l2_priority v4l2_prio_max(struct v4l2_prio_state *global)
-{
-	if (atomic_read(&global->prios[V4L2_PRIORITY_RECORD]) > 0)
-		return V4L2_PRIORITY_RECORD;
-	if (atomic_read(&global->prios[V4L2_PRIORITY_INTERACTIVE]) > 0)
-		return V4L2_PRIORITY_INTERACTIVE;
-	if (atomic_read(&global->prios[V4L2_PRIORITY_BACKGROUND]) > 0)
-		return V4L2_PRIORITY_BACKGROUND;
-	return V4L2_PRIORITY_UNSET;
-}
-EXPORT_SYMBOL(v4l2_prio_max);
-
-int v4l2_prio_check(struct v4l2_prio_state *global, enum v4l2_priority local)
-{
-	return (local < v4l2_prio_max(global)) ? -EBUSY : 0;
-}
-EXPORT_SYMBOL(v4l2_prio_check);
 
 /* ----------------------------------------------------------------- */
 
diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 5a7dc4a..2386ae6 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -142,3 +142,64 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 	module_put(sd->owner);
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
+
+/* ----------------------------------------------------------------- */
+
+/* priority handling helper functions */
+
+#define V4L2_PRIO_VALID(val) (val == V4L2_PRIORITY_BACKGROUND   || \
+			      val == V4L2_PRIORITY_INTERACTIVE  || \
+			      val == V4L2_PRIORITY_RECORD)
+
+void v4l2_prio_init(struct v4l2_prio_state *global)
+{
+	memset(global, 0, sizeof(*global));
+}
+EXPORT_SYMBOL(v4l2_prio_init);
+
+int v4l2_prio_change(struct v4l2_prio_state *global, enum v4l2_priority *local,
+		     enum v4l2_priority new)
+{
+	if (!V4L2_PRIO_VALID(new))
+		return -EINVAL;
+	if (*local == new)
+		return 0;
+
+	atomic_inc(&global->prios[new]);
+	if (V4L2_PRIO_VALID(*local))
+		atomic_dec(&global->prios[*local]);
+	*local = new;
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_prio_change);
+
+void v4l2_prio_open(struct v4l2_prio_state *global, enum v4l2_priority *local)
+{
+	v4l2_prio_change(global, local, V4L2_PRIORITY_DEFAULT);
+}
+EXPORT_SYMBOL(v4l2_prio_open);
+
+void v4l2_prio_close(struct v4l2_prio_state *global, enum v4l2_priority local)
+{
+	if (V4L2_PRIO_VALID(local))
+		atomic_dec(&global->prios[local]);
+}
+EXPORT_SYMBOL(v4l2_prio_close);
+
+enum v4l2_priority v4l2_prio_max(struct v4l2_prio_state *global)
+{
+	if (atomic_read(&global->prios[V4L2_PRIORITY_RECORD]) > 0)
+		return V4L2_PRIORITY_RECORD;
+	if (atomic_read(&global->prios[V4L2_PRIORITY_INTERACTIVE]) > 0)
+		return V4L2_PRIORITY_INTERACTIVE;
+	if (atomic_read(&global->prios[V4L2_PRIORITY_BACKGROUND]) > 0)
+		return V4L2_PRIORITY_BACKGROUND;
+	return V4L2_PRIORITY_UNSET;
+}
+EXPORT_SYMBOL(v4l2_prio_max);
+
+int v4l2_prio_check(struct v4l2_prio_state *global, enum v4l2_priority local)
+{
+	return (local < v4l2_prio_max(global)) ? -EBUSY : 0;
+}
+EXPORT_SYMBOL(v4l2_prio_check);
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 98b3264..e086917 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -80,21 +80,6 @@
 
 /* ------------------------------------------------------------------------- */
 
-/* Priority helper functions */
-
-struct v4l2_prio_state {
-	atomic_t prios[4];
-};
-void v4l2_prio_init(struct v4l2_prio_state *global);
-int v4l2_prio_change(struct v4l2_prio_state *global, enum v4l2_priority *local,
-		     enum v4l2_priority new);
-void v4l2_prio_open(struct v4l2_prio_state *global, enum v4l2_priority *local);
-void v4l2_prio_close(struct v4l2_prio_state *global, enum v4l2_priority local);
-enum v4l2_priority v4l2_prio_max(struct v4l2_prio_state *global);
-int v4l2_prio_check(struct v4l2_prio_state *global, enum v4l2_priority local);
-
-/* ------------------------------------------------------------------------- */
-
 /* Control helper functions */
 
 int v4l2_ctrl_check(struct v4l2_ext_control *ctrl, struct v4l2_queryctrl *qctrl,
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 5d5d550..b497e53 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -23,6 +23,11 @@
 
 #include <media/v4l2-subdev.h>
 
+/* struct to keep track of the access priority state */
+struct v4l2_prio_state {
+	atomic_t prios[4];
+};
+
 /* Each instance of a V4L2 device should create the v4l2_device struct,
    either stand-alone or embedded in a larger struct.
 
@@ -49,6 +54,16 @@ struct v4l2_device {
 			unsigned int notification, void *arg);
 };
 
+/* Priority helper functions */
+
+void v4l2_prio_init(struct v4l2_prio_state *global);
+int v4l2_prio_change(struct v4l2_prio_state *global, enum v4l2_priority *local,
+		     enum v4l2_priority new);
+void v4l2_prio_open(struct v4l2_prio_state *global, enum v4l2_priority *local);
+void v4l2_prio_close(struct v4l2_prio_state *global, enum v4l2_priority local);
+enum v4l2_priority v4l2_prio_max(struct v4l2_prio_state *global);
+int v4l2_prio_check(struct v4l2_prio_state *global, enum v4l2_priority local);
+
 /* Initialize v4l2_dev and make dev->driver_data point to v4l2_dev.
    dev may be NULL in rare cases (ISA devices). In that case you
    must fill in the v4l2_dev->name field before calling this function. */
-- 
1.6.4.2

