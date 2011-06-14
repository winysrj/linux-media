Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1417 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab1FNPW5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 11:22:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 7/8] v4l2-ctrls: split try_or_set_ext_ctrls()
Date: Tue, 14 Jun 2011 17:22:32 +0200
Message-Id: <ae53dfddb21b89c41544153f3b98678409a13644.1308063857.git.hans.verkuil@cisco.com>
In-Reply-To: <1308064953-11156-1-git-send-email-hverkuil@xs4all.nl>
References: <1308064953-11156-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1308063857.git.hans.verkuil@cisco.com>
References: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1308063857.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Split try_or_set_ext_ctrls() into a validate_ctrls() part ('Phase 1')
and merge the second part ('Phase 2') into try_set_ext_ctrls().

This makes a lot more sense and it also does the validation before
trying to try/set the controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |   88 ++++++++++++++++++--------------------
 1 files changed, 41 insertions(+), 47 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 8fe4e47..040d5c9 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1800,8 +1800,8 @@ EXPORT_SYMBOL(v4l2_ctrl_g_ctrl);
 /* Core function that calls try/s_ctrl and ensures that the new value is
    copied to the current value on a set.
    Must be called with ctrl->handler->lock held. */
-static int try_or_set_control_cluster(struct v4l2_fh *fh,
-					struct v4l2_ctrl *master, bool set)
+static int try_or_set_cluster(struct v4l2_fh *fh,
+			      struct v4l2_ctrl *master, bool set)
 {
 	bool update_flag;
 	int ret;
@@ -1843,23 +1843,18 @@ static int try_or_set_control_cluster(struct v4l2_fh *fh,
 	return 0;
 }
 
-/* Try or set controls. */
-static int try_or_set_ext_ctrls(struct v4l2_fh *fh,
-				struct v4l2_ctrl_handler *hdl,
-				struct v4l2_ext_controls *cs,
-				struct v4l2_ctrl_helper *helpers,
-				bool set)
+/* Validate controls. */
+static int validate_ctrls(struct v4l2_ext_controls *cs,
+			  struct v4l2_ctrl_helper *helpers, bool set)
 {
-	unsigned i, j;
+	unsigned i;
 	int ret = 0;
 
-	/* Phase 1: validation */
 	cs->error_idx = cs->count;
 	for (i = 0; i < cs->count; i++) {
 		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
 
-		if (!set)
-			cs->error_idx = i;
+		cs->error_idx = i;
 
 		if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
 			return -EACCES;
@@ -1875,8 +1870,38 @@ static int try_or_set_ext_ctrls(struct v4l2_fh *fh,
 		if (ret)
 			return ret;
 	}
+	return 0;
+}
+
+/* Try or try-and-set controls */
+static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
+			     struct v4l2_ext_controls *cs,
+			     bool set)
+{
+	struct v4l2_ctrl_helper helper[4];
+	struct v4l2_ctrl_helper *helpers = helper;
+	unsigned i, j;
+	int ret;
+
+	cs->error_idx = cs->count;
+	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+
+	if (hdl == NULL)
+		return -EINVAL;
+
+	if (cs->count == 0)
+		return class_check(hdl, cs->ctrl_class);
 
-	/* Phase 2: set/try controls */
+	if (cs->count > ARRAY_SIZE(helper)) {
+		helpers = kmalloc(sizeof(helper[0]) * cs->count, GFP_KERNEL);
+		if (!helpers)
+			return -ENOMEM;
+	}
+	ret = prepare_ext_ctrls(hdl, cs, helpers);
+	if (!ret)
+		ret = validate_ctrls(cs, helpers, set);
+	if (ret && set)
+		cs->error_idx = cs->count;
 	for (i = 0; !ret && i < cs->count; i++) {
 		struct v4l2_ctrl *master;
 		u32 idx = i;
@@ -1901,50 +1926,19 @@ static int try_or_set_ext_ctrls(struct v4l2_fh *fh,
 		} while (!ret && idx);
 
 		if (!ret)
-			ret = try_or_set_control_cluster(fh, master, set);
+			ret = try_or_set_cluster(fh, master, set);
 
 		/* Copy the new values back to userspace. */
 		if (!ret) {
 			idx = i;
 			do {
 				ret = user_to_new(cs->controls + idx,
-						  helpers[idx].ctrl);
+						helpers[idx].ctrl);
 				idx = helpers[idx].next;
 			} while (!ret && idx);
 		}
 		v4l2_ctrl_unlock(master);
 	}
-	return ret;
-}
-
-/* Try or try-and-set controls */
-static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
-			     struct v4l2_ext_controls *cs,
-			     bool set)
-{
-	struct v4l2_ctrl_helper helper[4];
-	struct v4l2_ctrl_helper *helpers = helper;
-	int ret;
-
-	cs->error_idx = cs->count;
-	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
-
-	if (hdl == NULL)
-		return -EINVAL;
-
-	if (cs->count == 0)
-		return class_check(hdl, cs->ctrl_class);
-
-	if (cs->count > ARRAY_SIZE(helper)) {
-		helpers = kmalloc(sizeof(helper[0]) * cs->count, GFP_KERNEL);
-		if (!helpers)
-			return -ENOMEM;
-	}
-	ret = prepare_ext_ctrls(hdl, cs, helpers);
-	if (!ret)
-		ret = try_or_set_ext_ctrls(fh, hdl, cs, helpers, set);
-	else if (set)
-		cs->error_idx = cs->count;
 
 	if (cs->count > ARRAY_SIZE(helper))
 		kfree(helpers);
@@ -1996,7 +1990,7 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
 
 	ctrl->val = *val;
 	ctrl->is_new = 1;
-	ret = try_or_set_control_cluster(fh, master, true);
+	ret = try_or_set_cluster(fh, master, true);
 	*val = ctrl->cur.val;
 	v4l2_ctrl_unlock(ctrl);
 	return ret;
-- 
1.7.1

