Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2350 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1AHLCD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 06:02:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFCv2 PATCH 3/5] v4l2-ctrls: v4l2_ctrl_handler_setup must set is_new to 1
Date: Sat,  8 Jan 2011 12:01:46 +0100
Message-Id: <5d7ced8dcd4844d0af67d0e60f14828817294f64.1294484338.git.hverkuil@xs4all.nl>
In-Reply-To: <1294484508-14820-1-git-send-email-hverkuil@xs4all.nl>
References: <1294484508-14820-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c17e89942fa7c2a1928f0dadc676f39a7e34e54c.1294484338.git.hverkuil@xs4all.nl>
References: <c17e89942fa7c2a1928f0dadc676f39a7e34e54c.1294484338.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Renamed has_new to is_new.

Drivers can use the is_new field to determine if a new value was specified
for a control. The v4l2_ctrl_handler_setup() must always set this to 1 since
the setup has to force a full update of all controls.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 Documentation/video4linux/v4l2-controls.txt |   12 ++++++++++++
 drivers/media/video/v4l2-ctrls.c            |   20 +++++++++++---------
 include/media/v4l2-ctrls.h                  |    6 ++++--
 3 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 8773778..881e7f4 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -285,6 +285,9 @@ implement g_volatile_ctrl like this:
 The 'new value' union is not used in g_volatile_ctrl. In general controls
 that need to implement g_volatile_ctrl are read-only controls.
 
+Note that if one or more controls in a control cluster are marked as volatile,
+then all the controls in the cluster are seen as volatile.
+
 To mark a control as volatile you have to set the is_volatile flag:
 
 	ctrl = v4l2_ctrl_new_std(&sd->ctrl_handler, ...);
@@ -462,6 +465,15 @@ pointer to the v4l2_ctrl_ops struct that is used for that cluster.
 Obviously, all controls in the cluster array must be initialized to either
 a valid control or to NULL.
 
+In rare cases you might want to know which controls of a cluster actually
+were set explicitly by the user. For this you can check the 'is_new' flag of
+each control. For example, in the case of a volume/mute cluster the 'is_new'
+flag of the mute control would be set if the user called VIDIOC_S_CTRL for
+mute only. If the user would call VIDIOC_S_EXT_CTRLS for both mute and volume
+controls, then the 'is_new' flag would be 1 for both controls.
+
+The 'is_new' flag is always 1 when called from v4l2_ctrl_handler_setup().
+
 
 VIDIOC_LOG_STATUS Support
 =========================
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 8f81efc..15c6d04 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -569,7 +569,7 @@ static int user_to_new(struct v4l2_ext_control *c,
 	int ret;
 	u32 size;
 
-	ctrl->has_new = 1;
+	ctrl->is_new = 1;
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER64:
 		ctrl->val64 = c->value64;
@@ -1280,8 +1280,10 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 		if (ctrl->done)
 			continue;
 
-		for (i = 0; i < master->ncontrols; i++)
+		for (i = 0; i < master->ncontrols; i++) {
 			cur_to_new(master->cluster[i]);
+			master->cluster[i]->is_new = 1;
+		}
 
 		/* Skip button controls and read-only controls. */
 		if (ctrl->type == V4L2_CTRL_TYPE_BUTTON ||
@@ -1645,7 +1647,7 @@ static int try_or_set_control_cluster(struct v4l2_ctrl *master, bool set)
 		if (ctrl == NULL)
 			continue;
 
-		if (ctrl->has_new) {
+		if (ctrl->is_new) {
 			/* Double check this: it may have changed since the
 			   last check in try_or_set_ext_ctrls(). */
 			if (set && (ctrl->flags & V4L2_CTRL_FLAG_GRABBED))
@@ -1719,13 +1721,13 @@ static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 
 		v4l2_ctrl_lock(ctrl);
 
-		/* Reset the 'has_new' flags of the cluster */
+		/* Reset the 'is_new' flags of the cluster */
 		for (j = 0; j < master->ncontrols; j++)
 			if (master->cluster[j])
-				master->cluster[j]->has_new = 0;
+				master->cluster[j]->is_new = 0;
 
 		/* Copy the new caller-supplied control values.
-		   user_to_new() sets 'has_new' to 1. */
+		   user_to_new() sets 'is_new' to 1. */
 		ret = cluster_walk(i, cs, helpers, user_to_new);
 
 		if (!ret)
@@ -1822,13 +1824,13 @@ static int set_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
 
 	v4l2_ctrl_lock(ctrl);
 
-	/* Reset the 'has_new' flags of the cluster */
+	/* Reset the 'is_new' flags of the cluster */
 	for (i = 0; i < master->ncontrols; i++)
 		if (master->cluster[i])
-			master->cluster[i]->has_new = 0;
+			master->cluster[i]->is_new = 0;
 
 	ctrl->val = *val;
-	ctrl->has_new = 1;
+	ctrl->is_new = 1;
 	ret = try_or_set_control_cluster(master, false);
 	if (!ret)
 		ret = try_or_set_control_cluster(master, true);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index d69ab4a..fcc9a0c 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -53,8 +53,10 @@ struct v4l2_ctrl_ops {
   * @handler:	The handler that owns the control.
   * @cluster:	Point to start of cluster array.
   * @ncontrols:	Number of controls in cluster array.
-  * @has_new:	Internal flag: set when there is a valid new value.
   * @done:	Internal flag: set for each processed control.
+  * @is_new:	Set when the user specified a new value for this control. It
+  *		is also set when called from v4l2_ctrl_handler_setup. Drivers
+  *		should never set this flag.
   * @is_private: If set, then this control is private to its handler and it
   *		will not be added to any other handlers. Drivers can set
   *		this flag.
@@ -97,9 +99,9 @@ struct v4l2_ctrl {
 	struct v4l2_ctrl_handler *handler;
 	struct v4l2_ctrl **cluster;
 	unsigned ncontrols;
-	unsigned int has_new:1;
 	unsigned int done:1;
 
+	unsigned int is_new:1;
 	unsigned int is_private:1;
 	unsigned int is_volatile:1;
 
-- 
1.7.0.4

