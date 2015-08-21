Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:36108 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbbHUJ3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 05:29:55 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Isely <isely@pobox.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vincent Palatin <vpalatin@chromium.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 3/8] media/v4l2-core: struct struct v4l2_ext_controls param which
Date: Fri, 21 Aug 2015 11:29:41 +0200
Message-Id: <1440149386-19783-4-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1440149386-19783-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1440149386-19783-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for new field which on v4l2_ext_controls, used to get the
default value of one or more controls.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b6b7dcc1b77d..23a69f637f6d 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1489,6 +1489,17 @@ static int new_to_user(struct v4l2_ext_control *c,
 	return ptr_to_user(c, ctrl, ctrl->p_new);
 }
 
+/* Helper function: copy the initial control value back to the caller */
+static int def_to_user(struct v4l2_ext_control *c, struct v4l2_ctrl *ctrl)
+{
+	int idx;
+
+	for (idx = 0; idx < ctrl->elems; idx++)
+		ctrl->type_ops->init(ctrl, idx, ctrl->p_new);
+
+	return ptr_to_user(c, ctrl, ctrl->p_new);
+}
+
 /* Helper function: copy the caller-provider value to the given control value */
 static int user_to_ptr(struct v4l2_ext_control *c,
 		       struct v4l2_ctrl *ctrl,
@@ -2708,7 +2719,9 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 
 		cs->error_idx = i;
 
-		if (cs->ctrl_class && V4L2_CTRL_ID2CLASS(id) != cs->ctrl_class)
+		if (cs->ctrl_class &&
+		    cs->which != V4L2_CTRL_WHICH_DEF_VAL &&
+		    V4L2_CTRL_ID2CLASS(id) != cs->ctrl_class)
 			return -EINVAL;
 
 		/* Old-style private controls are not allowed for
@@ -2787,7 +2800,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
    whether there are any controls at all. */
 static int class_check(struct v4l2_ctrl_handler *hdl, u32 ctrl_class)
 {
-	if (ctrl_class == 0)
+	if (ctrl_class == 0 || ctrl_class == V4L2_CTRL_WHICH_DEF_VAL)
 		return list_empty(&hdl->ctrl_refs) ? -EINVAL : 0;
 	return find_ref_lock(hdl, ctrl_class | 1) ? 0 : -EINVAL;
 }
@@ -2801,10 +2814,14 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 	struct v4l2_ctrl_helper *helpers = helper;
 	int ret;
 	int i, j;
+	bool def_value = false;
 
 	cs->error_idx = cs->count;
 	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
 
+	if (cs->which == V4L2_CTRL_WHICH_DEF_VAL)
+		def_value = true;
+
 	if (hdl == NULL)
 		return -EINVAL;
 
@@ -2827,9 +2844,11 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 
 	for (i = 0; !ret && i < cs->count; i++) {
 		int (*ctrl_to_user)(struct v4l2_ext_control *c,
-				    struct v4l2_ctrl *ctrl) = cur_to_user;
+				    struct v4l2_ctrl *ctrl);
 		struct v4l2_ctrl *master;
 
+		ctrl_to_user = def_value ? def_to_user : cur_to_user;
+
 		if (helpers[i].mref == NULL)
 			continue;
 
@@ -2839,8 +2858,9 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		v4l2_ctrl_lock(master);
 
 		/* g_volatile_ctrl will update the new control values */
-		if ((master->flags & V4L2_CTRL_FLAG_VOLATILE) ||
-			(master->has_volatiles && !is_cur_manual(master))) {
+		if (!def_value &&
+		    ((master->flags & V4L2_CTRL_FLAG_VOLATILE) ||
+		    (master->has_volatiles && !is_cur_manual(master)))) {
 			for (j = 0; j < master->ncontrols; j++)
 				cur_to_new(master->cluster[j]);
 			ret = call_op(master, g_volatile_ctrl);
@@ -3062,6 +3082,11 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	int ret;
 
 	cs->error_idx = cs->count;
+
+	/* Default value cannot be changed */
+	if (cs->which == V4L2_CTRL_WHICH_DEF_VAL)
+		return -EINVAL;
+
 	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
 
 	if (hdl == NULL)
-- 
2.5.0

