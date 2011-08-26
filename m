Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1029 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab1HZMA2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 08:00:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 3/8] v4l2-ctrls: implement new volatile autocluster scheme.
Date: Fri, 26 Aug 2011 14:00:08 +0200
Message-Id: <bfbdb3871a975b20d13c8585cd829af9bdf07916.1314359706.git.hans.verkuil@cisco.com>
In-Reply-To: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
References: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c30383666acc85a530fba5b1a14189670dfb8bb3.1314359706.git.hans.verkuil@cisco.com>
References: <c30383666acc85a530fba5b1a14189670dfb8bb3.1314359706.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The problem tackled in this patch is how to handle volatile autoclusters
correctly. A volatile autocluster is a cluster of related controls where one
control is the control that toggles between manual and auto mode and the other
controls are the values for the manual mode. For example autogain and gain,
autoexposure and exposure, etc.

If the hardware lets you read out the automatically calculated manual values
while in automode, then those manual controls should be marked volatile.

E.g.: if autogain is on, and the hardware allows you to read out the current
gain value as calculated by the autogain circuitry, then you would mark the
gain control as volatile (i.e. continuously changing).

The question in such use cases is what to do when switching from the auto
mode to the manual mode. Should we switch to the last set manual values or
should the volatile values be copied and used as the initial manual values.

For example: suppose the mode is manual gain and gain is set to 5. Then
autogain is turned on and the gain is set by the hardware to 2. Finally
the user switches back to manual gain. What should the gain be? 2 or 5?

After a long discussion the decisions was made to keep the last value as
calculated by the auto mode (so 2 in the example above).

The reason is that webcams that do such things will adapt themselves to
the current light conditions and when you switch back to manual mode you
expect that you keep the same picture. If you would switch back to old
manual values, then that would give you a suddenly different picture,
which is jarring for the user.

Additionally, this would be difficult to implement in applications that
store and restore the control values at application exit and start.

If you want to keep the old manual values when you switch from auto to
manual, then there would have to be a way for applications to get hold
of those old values while in auto mode, but there isn't.

So this patch will do all the heavy lifting in v4l2-ctrls.c: if you go
from auto mode to manual mode and the manual controls are volatile, then
g_volatile_ctrl will be called to get the current values for the manual
controls before switching to manual mode.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |   74 +++++++++++++++++++++++++++++++++----
 include/media/v4l2-ctrls.h       |    3 ++
 2 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 1667621..fc8666a 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -937,9 +937,14 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 		break;
 	}
 	if (update_inactive) {
-		ctrl->flags &= ~V4L2_CTRL_FLAG_INACTIVE;
-		if (!is_cur_manual(ctrl->cluster[0]))
+		/* Note: update_inactive can only be true for auto clusters. */
+		ctrl->flags &=
+			~(V4L2_CTRL_FLAG_INACTIVE | V4L2_CTRL_FLAG_VOLATILE);
+		if (!is_cur_manual(ctrl->cluster[0])) {
 			ctrl->flags |= V4L2_CTRL_FLAG_INACTIVE;
+			if (ctrl->cluster[0]->has_volatiles)
+				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+		}
 	}
 	if (changed || update_inactive) {
 		/* If a control was changed that was not one of the controls
@@ -1489,6 +1494,7 @@ EXPORT_SYMBOL(v4l2_ctrl_add_handler);
 /* Cluster controls */
 void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 {
+	bool has_volatiles = false;
 	int i;
 
 	/* The first control is the master control and it must not be NULL */
@@ -1498,8 +1504,11 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 		if (controls[i]) {
 			controls[i]->cluster = controls;
 			controls[i]->ncontrols = ncontrols;
+			if (controls[i]->flags & V4L2_CTRL_FLAG_VOLATILE)
+				has_volatiles = true;
 		}
 	}
+	controls[0]->has_volatiles = has_volatiles;
 }
 EXPORT_SYMBOL(v4l2_ctrl_cluster);
 
@@ -1507,18 +1516,21 @@ void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
 			    u8 manual_val, bool set_volatile)
 {
 	struct v4l2_ctrl *master = controls[0];
-	u32 flag;
+	u32 flag = 0;
 	int i;
 
 	v4l2_ctrl_cluster(ncontrols, controls);
 	WARN_ON(ncontrols <= 1);
 	WARN_ON(manual_val < master->minimum || manual_val > master->maximum);
+	WARN_ON(set_volatile && !has_op(master, g_volatile_ctrl));
 	master->is_auto = true;
+	master->has_volatiles = set_volatile;
 	master->manual_mode_value = manual_val;
 	master->flags |= V4L2_CTRL_FLAG_UPDATE;
-	flag = is_cur_manual(master) ? 0 : V4L2_CTRL_FLAG_INACTIVE;
-	if (set_volatile)
-		flag |= V4L2_CTRL_FLAG_VOLATILE;
+
+	if (!is_cur_manual(master))
+		flag = V4L2_CTRL_FLAG_INACTIVE |
+			(set_volatile ? V4L2_CTRL_FLAG_VOLATILE : 0);
 
 	for (i = 1; i < ncontrols; i++)
 		if (controls[i])
@@ -1957,7 +1969,8 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		v4l2_ctrl_lock(master);
 
 		/* g_volatile_ctrl will update the new control values */
-		if (has_op(master, g_volatile_ctrl) && !is_cur_manual(master)) {
+		if ((master->flags & V4L2_CTRL_FLAG_VOLATILE) ||
+			(master->has_volatiles && !is_cur_manual(master))) {
 			for (j = 0; j < master->ncontrols; j++)
 				cur_to_new(master->cluster[j]);
 			ret = call_op(master, g_volatile_ctrl);
@@ -2002,7 +2015,7 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
 
 	v4l2_ctrl_lock(master);
 	/* g_volatile_ctrl will update the current control values */
-	if ((ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) && !is_cur_manual(master)) {
+	if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
 		for (i = 0; i < master->ncontrols; i++)
 			cur_to_new(master->cluster[i]);
 		ret = call_op(master, g_volatile_ctrl);
@@ -2118,6 +2131,20 @@ static int validate_ctrls(struct v4l2_ext_controls *cs,
 	return 0;
 }
 
+/* Obtain the current volatile values of an autocluster and mark them
+   as new. */
+static void update_from_auto_cluster(struct v4l2_ctrl *master)
+{
+	int i;
+
+	for (i = 0; i < master->ncontrols; i++)
+		cur_to_new(master->cluster[i]);
+	if (!call_op(master, g_volatile_ctrl))
+		for (i = 1; i < master->ncontrols; i++)
+			if (master->cluster[i])
+				master->cluster[i]->is_new = 1;
+}
+
 /* Try or try-and-set controls */
 static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 			     struct v4l2_ext_controls *cs,
@@ -2163,6 +2190,31 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 			if (master->cluster[j])
 				master->cluster[j]->is_new = 0;
 
+		/* For volatile autoclusters that are currently in auto mode
+		   we need to discover if it will be set to manual mode.
+		   If so, then we have to copy the current volatile values
+		   first since those will become the new manual values (which
+		   may be overwritten by explicit new values from this set
+		   of controls). */
+		if (master->is_auto && master->has_volatiles &&
+						!is_cur_manual(master)) {
+			/* Pick an initial non-manual value */
+			s32 new_auto_val = master->manual_mode_value + 1;
+			u32 tmp_idx = idx;
+
+			do {
+				/* Check if the auto control is part of the
+				   list, and remember the new value. */
+				if (helpers[tmp_idx].ctrl == master)
+					new_auto_val = cs->controls[tmp_idx].value;
+				tmp_idx = helpers[tmp_idx].next;
+			} while (tmp_idx);
+			/* If the new value == the manual value, then copy
+			   the current volatile values. */
+			if (new_auto_val == master->manual_mode_value)
+				update_from_auto_cluster(master);
+		}
+
 		/* Copy the new caller-supplied control values.
 		   user_to_new() sets 'is_new' to 1. */
 		do {
@@ -2233,6 +2285,12 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
 		if (master->cluster[i])
 			master->cluster[i]->is_new = 0;
 
+	/* For autoclusters with volatiles that are switched from auto to
+	   manual mode we have to update the current volatile values since
+	   those will become the initial manual values after such a switch. */
+	if (master->is_auto && master->has_volatiles && ctrl == master &&
+	    !is_cur_manual(master) && *val == master->manual_mode_value)
+		update_from_auto_cluster(master);
 	ctrl->val = *val;
 	ctrl->is_new = 1;
 	ret = try_or_set_cluster(fh, master, true);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index bd6a4a7..eeb3df6 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -69,6 +69,8 @@ struct v4l2_ctrl_ops {
   *		members are in 'automatic' mode or 'manual' mode. This is
   *		used for autogain/gain type clusters. Drivers should never
   *		set this flag directly.
+  * @has_volatiles: If set, then one or more members of the cluster are volatile.
+  *		Drivers should never touch this flag.
   * @manual_mode_value: If the is_auto flag is set, then this is the value
   *		of the auto control that determines if that control is in
   *		manual mode. So if the value of the auto control equals this
@@ -115,6 +117,7 @@ struct v4l2_ctrl {
 	unsigned int is_new:1;
 	unsigned int is_private:1;
 	unsigned int is_auto:1;
+	unsigned int has_volatiles:1;
 	unsigned int manual_mode_value:8;
 
 	const struct v4l2_ctrl_ops *ops;
-- 
1.7.5.4

