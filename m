Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4926 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab1EYNeP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 09:34:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 01/11] v4l2-ctrls: introduce call_op define
Date: Wed, 25 May 2011 15:33:45 +0200
Message-Id: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
In-Reply-To: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the call_op define to safely call the control ops. This also allows
for controls without any ops such as the 'control class' controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 223e040..8b5f67f 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -25,6 +25,9 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-dev.h>
 
+#define call_op(master, op) \
+	((master->ops && master->ops->op) ? master->ops->op(master) : 0)
+
 /* Internal temporary helper struct, one for each v4l2_ext_control */
 struct ctrl_helper {
 	/* The control corresponding to the v4l2_ext_control ID field. */
@@ -1306,7 +1309,7 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 		if (ctrl->type == V4L2_CTRL_TYPE_BUTTON ||
 		    (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY))
 			continue;
-		ret = master->ops->s_ctrl(master);
+		ret = call_op(master, s_ctrl);
 		if (ret)
 			break;
 		for (i = 0; i < master->ncontrols; i++)
@@ -1583,8 +1586,8 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 
 		v4l2_ctrl_lock(master);
 		/* g_volatile_ctrl will update the current control values */
-		if (ctrl->is_volatile && master->ops->g_volatile_ctrl)
-			ret = master->ops->g_volatile_ctrl(master);
+		if (ctrl->is_volatile)
+			ret = call_op(master, g_volatile_ctrl);
 		/* If OK, then copy the current control values to the caller */
 		if (!ret)
 			ret = cluster_walk(i, cs, helpers, cur_to_user);
@@ -1615,8 +1618,8 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
 
 	v4l2_ctrl_lock(master);
 	/* g_volatile_ctrl will update the current control values */
-	if (ctrl->is_volatile && master->ops->g_volatile_ctrl)
-		ret = master->ops->g_volatile_ctrl(master);
+	if (ctrl->is_volatile)
+		ret = call_op(master, g_volatile_ctrl);
 	*val = ctrl->cur.val;
 	v4l2_ctrl_unlock(master);
 	return ret;
@@ -1690,12 +1693,12 @@ static int try_or_set_control_cluster(struct v4l2_ctrl *master, bool set)
 	/* For larger clusters you have to call try_ctrl again to
 	   verify that the controls are still valid after the
 	   'cur_to_new' above. */
-	if (!ret && master->ops->try_ctrl && try)
-		ret = master->ops->try_ctrl(master);
+	if (!ret && try)
+		ret = call_op(master, try_ctrl);
 
 	/* Don't set if there is no change */
 	if (!ret && set && cluster_changed(master)) {
-		ret = master->ops->s_ctrl(master);
+		ret = call_op(master, s_ctrl);
 		/* If OK, then make the new values permanent. */
 		if (!ret)
 			for (i = 0; i < master->ncontrols; i++)
-- 
1.7.1

