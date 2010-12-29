Return-path: <mchehab@gaivota>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2816 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab0L2VnJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 16:43:09 -0500
Received: from localhost (marune.xs4all.nl [82.95.89.49])
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBTLh7Os086308
	for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 22:43:08 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <d8e4dd6dd3321cdbca90dca98c05ff44f57f2d58.1293657717.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1293657717.git.hverkuil@xs4all.nl>
References: <cover.1293657717.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 29 Dec 2010 22:43:07 +0100
Subject: [PATCH 01/10] [RFC] v4l2_prio: move from v4l2-common to v4l2-dev.
To: linux-media@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

We are going to move priority handling into the v4l2 core. As a consequence
the v4l2_prio helper functions need to be moved into the core videodev
module as well to prevent circular dependencies.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-common.c |   63 ------------------------------------
 drivers/media/video/v4l2-dev.c    |   64 +++++++++++++++++++++++++++++++++++++
 include/media/v4l2-common.h       |   15 ---------
 include/media/v4l2-dev.h          |   15 +++++++++
 4 files changed, 79 insertions(+), 78 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index b5eb1f3..c3ccd47 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -81,69 +81,6 @@ MODULE_LICENSE("GPL");
  *  Video Standard Operations (contributed by Michael Schimek)
  */
 
-
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
-
-/* ----------------------------------------------------------------- */
-
 /* Helper functions for control handling			     */
 
 /* Check for correctness of the ctrl's value based on the data from
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 359e232..8698fe4 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -182,6 +182,70 @@ struct video_device *video_devdata(struct file *file)
 }
 EXPORT_SYMBOL(video_devdata);
 
+
+/* Priority handling */
+
+static inline bool prio_is_valid(enum v4l2_priority prio)
+{
+	return prio == V4L2_PRIORITY_BACKGROUND ||
+	       prio == V4L2_PRIORITY_INTERACTIVE ||
+	       prio == V4L2_PRIORITY_RECORD;
+}
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
+	if (!prio_is_valid(new))
+		return -EINVAL;
+	if (*local == new)
+		return 0;
+
+	atomic_inc(&global->prios[new]);
+	if (prio_is_valid(*local))
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
+	if (prio_is_valid(local))
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
+
+
 static ssize_t v4l2_read(struct file *filp, char __user *buf,
 		size_t sz, loff_t *off)
 {
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 239125a..4c70d15 100644
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
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 15802a0..861f323 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -34,6 +34,21 @@ struct v4l2_ctrl_handler;
 #define V4L2_FL_REGISTERED	(0)
 #define V4L2_FL_USES_V4L2_FH	(1)
 
+/* Priority helper functions */
+
+struct v4l2_prio_state {
+	atomic_t prios[4];
+};
+
+void v4l2_prio_init(struct v4l2_prio_state *global);
+int v4l2_prio_change(struct v4l2_prio_state *global, enum v4l2_priority *local,
+		     enum v4l2_priority new);
+void v4l2_prio_open(struct v4l2_prio_state *global, enum v4l2_priority *local);
+void v4l2_prio_close(struct v4l2_prio_state *global, enum v4l2_priority local);
+enum v4l2_priority v4l2_prio_max(struct v4l2_prio_state *global);
+int v4l2_prio_check(struct v4l2_prio_state *global, enum v4l2_priority local);
+
+
 struct v4l2_file_operations {
 	struct module *owner;
 	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
-- 
1.6.4.2

