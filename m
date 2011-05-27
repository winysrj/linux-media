Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4202 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab1E0O6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 10:58:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 1/5] v4l2-ctrls: fix and improve volatile control handling.
Date: Fri, 27 May 2011 16:57:51 +0200
Message-Id: <287bab4f54ddce64458a69e0407d5866158fda0a.1306507763.git.hans.verkuil@cisco.com>
In-Reply-To: <1306508275-9228-1-git-send-email-hverkuil@xs4all.nl>
References: <1306508275-9228-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

If you have a cluster of controls that is a mix of volatile and non-volatile
controls, then requesting the value of the volatile control would fail if the
master control of that cluster was non-volatile. The code assumed that the
volatile state of the master control was the same for all other controls in
the cluster.

This is now fixed.

In addition, it was clear from bugs in some drivers that it was confusing that
the ctrl->cur union had to be used in g_volatile_ctrl. Several drivers used the
'new' values instead. The framework was changed so that drivers now set the new
value instead of the current value.

This has an additional benefit as well: the volatile values are now only stored
in the 'new' value, leaving the current value alone. This is useful for
autofoo/foo control clusters where you want to have a 'foo' control act like a
volatile control if 'autofoo' is on, but as a normal control when it is off.

Since with this change the cur value is no longer overwritten when g_volatile_ctrl
is called, you can use it to remember the original 'foo' value. For example:

autofoo = 0, foo = 10 and foo is non-volatile.

Now autofoo is set to 1 and foo is marked volatile. Retrieving the foo value
will get the volatile value. Set autofoo back to 0, which marks foo as non-
volatile again, and retrieving foo will get the old current value of 10.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/saa7115.c    |    4 +-
 drivers/media/video/v4l2-ctrls.c |   52 ++++++++++++++++++++++++++++++++------
 2 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/saa7115.c b/drivers/media/video/saa7115.c
index ae4b299..dc8710d 100644
--- a/drivers/media/video/saa7115.c
+++ b/drivers/media/video/saa7115.c
@@ -757,8 +757,8 @@ static int saa711x_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 	switch (ctrl->id) {
 	case V4L2_CID_CHROMA_AGC:
 		/* chroma gain cluster */
-		if (state->agc->cur.val)
-			state->gain->cur.val =
+		if (state->agc->val)
+			state->gain->val =
 				saa711x_read(sd, R_0F_CHROMA_GAIN_CNTL) & 0x7f;
 		break;
 	}
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 9807a20..7fc6d3f 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -26,8 +26,10 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-dev.h>
 
+#define has_op(master, op) \
+	(master->ops && master->ops->op)
 #define call_op(master, op) \
-	((master->ops && master->ops->op) ? master->ops->op(master) : 0)
+	(has_op(master, op) ? master->ops->op(master) : 0)
 
 /* Internal temporary helper struct, one for each v4l2_ext_control */
 struct ctrl_helper {
@@ -665,6 +667,20 @@ static int new_to_user(struct v4l2_ext_control *c,
 	return 0;
 }
 
+static int ctrl_to_user(struct v4l2_ext_control *c,
+		       struct v4l2_ctrl *ctrl)
+{
+	if (ctrl->is_volatile)
+		return new_to_user(c, ctrl);
+	return cur_to_user(c, ctrl);
+}
+
+static int ctrl_is_volatile(struct v4l2_ext_control *c,
+		       struct v4l2_ctrl *ctrl)
+{
+	return ctrl->is_volatile;
+}
+
 /* Copy the new value to the current value. */
 static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl)
 {
@@ -1614,7 +1630,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 	struct ctrl_helper helper[4];
 	struct ctrl_helper *helpers = helper;
 	int ret;
-	int i;
+	int i, j;
 
 	cs->error_idx = cs->count;
 	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
@@ -1640,6 +1656,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 	for (i = 0; !ret && i < cs->count; i++) {
 		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
 		struct v4l2_ctrl *master = ctrl->cluster[0];
+		bool has_volatiles;
 
 		if (helpers[i].handled)
 			continue;
@@ -1647,12 +1664,25 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		cs->error_idx = i;
 
 		v4l2_ctrl_lock(master);
-		/* g_volatile_ctrl will update the current control values */
-		if (ctrl->is_volatile)
+
+		/* Any volatile controls requested from this cluster? */
+		has_volatiles = ctrl->is_volatile;
+		if (!has_volatiles && has_op(master, g_volatile_ctrl) &&
+				master->ncontrols > 1)
+			has_volatiles = cluster_walk(i + 1, cs, helpers,
+						ctrl_is_volatile);
+
+		/* g_volatile_ctrl will update the new control values */
+		if (has_volatiles) {
+			for (j = 0; j < master->ncontrols; j++)
+				cur_to_new(master->cluster[j]);
 			ret = call_op(master, g_volatile_ctrl);
-		/* If OK, then copy the current control values to the caller */
+		}
+		/* If OK, then copy the current (for non-volatile controls)
+		   or the new (for volatile controls) control values to the
+		   caller */
 		if (!ret)
-			ret = cluster_walk(i, cs, helpers, cur_to_user);
+			ret = cluster_walk(i, cs, helpers, ctrl_to_user);
 		v4l2_ctrl_unlock(master);
 		cluster_done(i, cs, helpers);
 	}
@@ -1674,15 +1704,21 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
 {
 	struct v4l2_ctrl *master = ctrl->cluster[0];
 	int ret = 0;
+	int i;
 
 	if (ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
 		return -EACCES;
 
 	v4l2_ctrl_lock(master);
 	/* g_volatile_ctrl will update the current control values */
-	if (ctrl->is_volatile)
+	if (ctrl->is_volatile) {
+		for (i = 0; i < master->ncontrols; i++)
+			cur_to_new(master->cluster[i]);
 		ret = call_op(master, g_volatile_ctrl);
-	*val = ctrl->cur.val;
+		*val = ctrl->val;
+	} else {
+		*val = ctrl->cur.val;
+	}
 	v4l2_ctrl_unlock(master);
 	return ret;
 }
-- 
1.7.1

