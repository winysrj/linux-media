Return-path: <mchehab@gaivota>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1105 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab1ACSb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 13:31:29 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr18.xs4all.nl (8.13.8/8.13.8) with ESMTP id p03IVMuS006180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 3 Jan 2011 19:31:27 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH 01/10] v4l2_prio: move from v4l2-common to v4l2-dev.
Date: Mon,  3 Jan 2011 19:31:06 +0100
Message-Id: <6515cfbdde63364fd12bca1219870f38ff371145.1294078230.git.hverkuil@xs4all.nl>
In-Reply-To: <1294079475-13259-1-git-send-email-hverkuil@xs4all.nl>
References: <1294079475-13259-1-git-send-email-hverkuil@xs4all.nl>
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
index 3f0871b..b25d3e9 100644
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
index 2d65b35..e34993e 100644
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
1.7.0.4

