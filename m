Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4141 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab1E0O6H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 10:58:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 3/5] v4l2-ctrls: add v4l2_ctrl_auto_cluster to simplify autogain/gain scenarios
Date: Fri, 27 May 2011 16:57:53 +0200
Message-Id: <59aa3a65ff133ddd87da1407306a36dbbede210b.1306507763.git.hans.verkuil@cisco.com>
In-Reply-To: <1306508275-9228-1-git-send-email-hverkuil@xs4all.nl>
References: <1306508275-9228-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <287bab4f54ddce64458a69e0407d5866158fda0a.1306507763.git.hans.verkuil@cisco.com>
References: <287bab4f54ddce64458a69e0407d5866158fda0a.1306507763.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

It is a bit tricky to handle autogain/gain type scenerios correctly. Such
controls need to be clustered and the V4L2_CTRL_FLAG_UPDATE should be set on
the autofoo controls. In addition, the manual controls should be marked
read-only or inactive when the automatic mode is on, and writable/active
when the manual mode is on. This also requires specialized volatile handling.

The chances of drivers doing all these things correctly are pretty remote.
So a new v4l2_ctrl_auto_cluster function was added that takes care of these
issues.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |   85 ++++++++++++++++++++++++++++++++------
 include/media/v4l2-ctrls.h       |   46 ++++++++++++++++++++
 2 files changed, 118 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 7fc6d3f..8ea60c6 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -40,6 +40,13 @@ struct ctrl_helper {
 	bool handled;
 };
 
+/* Small helper function to determine if the autocluster is set to manual
+   mode which means that the is_volatile flag should be ignored. */
+static bool ignore_volatile(const struct v4l2_ctrl *master)
+{
+	return master->is_auto && master->cur.val == master->manual_mode_value;
+}
+
 /* Returns NULL or a character pointer array containing the menu for
    the given control ID. The pointer array ends with a NULL pointer.
    An empty string signifies a menu entry that is invalid. This allows
@@ -682,7 +689,8 @@ static int ctrl_is_volatile(struct v4l2_ext_control *c,
 }
 
 /* Copy the new value to the current value. */
-static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl)
+static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
+					bool update_flag)
 {
 	bool changed = false;
 
@@ -706,8 +714,22 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl)
 		ctrl->cur.val = ctrl->val;
 		break;
 	}
-	if (changed)
-		send_event(fh, ctrl, V4L2_EVENT_CTRL_CH_VALUE);
+	if (update_flag) {
+		if (ctrl->is_volatile)
+			ctrl->flags &= ~V4L2_CTRL_FLAG_READ_ONLY;
+		else
+			ctrl->flags &= ~V4L2_CTRL_FLAG_INACTIVE;
+		if (!ignore_volatile(ctrl->cluster[0])) {
+			if (ctrl->is_volatile)
+				ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+			else
+				ctrl->flags |= V4L2_CTRL_FLAG_INACTIVE;
+		}
+	}
+	if (changed || update_flag)
+		send_event(fh, ctrl,
+			(changed ? V4L2_EVENT_CTRL_CH_VALUE : 0) |
+			(update_flag ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
 }
 
 /* Copy the current value to the new value */
@@ -1252,7 +1274,7 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 	int i;
 
 	/* The first control is the master control and it must not be NULL */
-	BUG_ON(controls[0] == NULL);
+	BUG_ON(ncontrols == 0 || controls[0] == NULL);
 
 	for (i = 0; i < ncontrols; i++) {
 		if (controls[i]) {
@@ -1263,6 +1285,31 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 }
 EXPORT_SYMBOL(v4l2_ctrl_cluster);
 
+void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
+			    u8 manual_val, bool set_volatile)
+{
+	struct v4l2_ctrl *master = controls[0];
+	u32 auto_flag = 0;
+	int i;
+
+	v4l2_ctrl_cluster(ncontrols, controls);
+	WARN_ON(ncontrols <= 1);
+	master->is_auto = true;
+	master->manual_mode_value = manual_val;
+	if (set_volatile)
+		master->flags |= V4L2_CTRL_FLAG_UPDATE;
+	if (master->cur.val != manual_val)
+		auto_flag = set_volatile ?
+			V4L2_CTRL_FLAG_READ_ONLY : V4L2_CTRL_FLAG_INACTIVE;
+
+	for (i = 1; i < ncontrols; i++)
+		if (controls[i]) {
+			controls[i]->is_volatile = set_volatile;
+			controls[i]->flags |= auto_flag;
+		}
+}
+EXPORT_SYMBOL(v4l2_ctrl_auto_cluster);
+
 void v4l2_ctrl_flags(struct v4l2_ctrl *ctrl, u32 clear_flags, u32 set_flags)
 {
 	u32 old_flags;
@@ -1673,7 +1720,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 						ctrl_is_volatile);
 
 		/* g_volatile_ctrl will update the new control values */
-		if (has_volatiles) {
+		if (has_volatiles && !ignore_volatile(master)) {
 			for (j = 0; j < master->ncontrols; j++)
 				cur_to_new(master->cluster[j]);
 			ret = call_op(master, g_volatile_ctrl);
@@ -1711,7 +1758,7 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
 
 	v4l2_ctrl_lock(master);
 	/* g_volatile_ctrl will update the current control values */
-	if (ctrl->is_volatile) {
+	if (ctrl->is_volatile && !ignore_volatile(master)) {
 		for (i = 0; i < master->ncontrols; i++)
 			cur_to_new(master->cluster[i]);
 		ret = call_op(master, g_volatile_ctrl);
@@ -1757,6 +1804,7 @@ EXPORT_SYMBOL(v4l2_ctrl_g_ctrl);
 static int try_or_set_control_cluster(struct v4l2_fh *fh,
 					struct v4l2_ctrl *master, bool set)
 {
+	bool update_flag;
 	bool try = !set;
 	int ret = 0;
 	int i;
@@ -1791,14 +1839,25 @@ static int try_or_set_control_cluster(struct v4l2_fh *fh,
 		ret = call_op(master, try_ctrl);
 
 	/* Don't set if there is no change */
-	if (!ret && set && cluster_changed(master)) {
-		ret = call_op(master, s_ctrl);
-		/* If OK, then make the new values permanent. */
-		if (!ret)
-			for (i = 0; i < master->ncontrols; i++)
-				new_to_cur(fh, master->cluster[i]);
+	if (ret || !set || !cluster_changed(master))
+		return ret;
+	ret = call_op(master, s_ctrl);
+	/* If OK, then make the new values permanent. */
+	if (ret)
+		return ret;
+
+	update_flag = false;
+	if (master->is_auto) {
+		bool old_is_manual =
+			master->cur.val == master->manual_mode_value;
+		bool new_is_manual =
+			master->val == master->manual_mode_value;
+
+		update_flag = old_is_manual != new_is_manual;
 	}
-	return ret;
+	for (i = 0; i < master->ncontrols; i++)
+		new_to_cur(fh, master->cluster[i], update_flag && i > 0);
+	return 0;
 }
 
 /* Check if the flags allow you to set the modified controls. */
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index e2b9053..dab9ed1 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -67,6 +67,15 @@ struct v4l2_ctrl_ops {
   *		control's current value cannot be cached and needs to be
   *		retrieved through the g_volatile_ctrl op. Drivers can set
   *		this flag.
+  * @is_auto:   If set, then this control selects whether the other cluster
+  *		members are in 'automatic' mode or 'manual' mode. This is
+  *		used for autogain/gain type clusters. Drivers should never
+  *		set this flag directly.
+  * @manual_mode_value: If the is_auto flag is set, then this is the value
+  *		of the auto control that determines if that control is in
+  *		manual mode. So if the value of the auto control equals this
+  *		value, then the whole cluster is in manual mode. Drivers should
+  *		never set this flag directly.
   * @ops:	The control ops.
   * @id:	The control ID.
   * @name:	The control name.
@@ -108,6 +117,8 @@ struct v4l2_ctrl {
 	unsigned int is_new:1;
 	unsigned int is_private:1;
 	unsigned int is_volatile:1;
+	unsigned int is_auto:1;
+	unsigned int manual_mode_value:5;
 
 	const struct v4l2_ctrl_ops *ops;
 	u32 id;
@@ -379,6 +390,41 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls);
 
 
+/** v4l2_ctrl_auto_cluster() - Mark all controls in the cluster as belonging to
+  * that cluster and set it up for autofoo/foo-type handling.
+  * @ncontrols:	The number of controls in this cluster.
+  * @controls:	The cluster control array of size @ncontrols. The first control
+  *		must be the 'auto' control (e.g. autogain, autoexposure, etc.)
+  * @manual_val: The value for the first control in the cluster that equals the
+  *		manual setting.
+  * @set_volatile: If true, then all controls except the first auto control will
+  *		have is_volatile set to true. If false, then is_volatile will not
+  *		be touched.
+  *
+  * Use for control groups where one control selects some automatic feature and
+  * the other controls are only active whenever the automatic feature is turned
+  * off (manual mode). Typical examples: autogain vs gain, auto-whitebalance vs
+  * red and blue balance, etc.
+  *
+  * The behavior of such controls is as follows:
+  *
+  * When the autofoo control is set to automatic, then any manual controls
+  * are set to read-only (if volatile) or inactive (if non-volatile) and any
+  * reads will call g_volatile_ctrl (if the control was marked volatile).
+  *
+  * When the autofoo control is set to manual, then any volatile manual
+  * controls will be marked writable and any non-volatile manual controls
+  * will be marked active, and any reads will just return the current value
+  * without going through g_volatile_ctrl.
+  *
+  * In addition, this function will set the V4L2_CTRL_FLAG_UPDATE flag
+  * on the autofoo control and either V4L2_CTRL_FLAG_READ_ONLY or
+  * V4L2_CTRL_FLAG_INACTIVE on the foo control(s).
+  */
+void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
+			u8 manual_val, bool set_volatile);
+
+
 /** v4l2_ctrl_find() - Find a control with the given ID.
   * @hdl:	The control handler.
   * @id:	The control ID to find.
-- 
1.7.1

