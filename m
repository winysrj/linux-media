Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1219 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1AVLGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 06:06:22 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id p0MB69ia074561
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 22 Jan 2011 12:06:21 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 2/3] v4l2-ctrls: add v4l2_ctrl_auto_cluster to simplify autogain/gain scenarios
Date: Sat, 22 Jan 2011 12:06:00 +0100
Message-Id: <ad0ec022eea20f19d3936a10268d429b1be57980.1295693790.git.hverkuil@xs4all.nl>
In-Reply-To: <1295694361-23237-1-git-send-email-hverkuil@xs4all.nl>
References: <1295694361-23237-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <828e9980aa0934596a85e5a1b83c0bdd52ecc9d0.1295693790.git.hverkuil@xs4all.nl>
References: <828e9980aa0934596a85e5a1b83c0bdd52ecc9d0.1295693790.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It is a bit tricky to handle autogain/gain type scenerios correctly. Such
controls need to be clustered and the V4L2_CTRL_FLAG_UPDATE should be set on
the non-auto controls. If you set a non-auto control without setting the
auto control at the same time, then the auto control should switch to manual
mode. And usually the non-auto controls must be marked volatile, but this should
only be in effect if the auto control is set to auto.

The chances of drivers doing all these things correctly are pretty remote.
So a new v4l2_ctrl_auto_cluster function was added that takes care of these
issues.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-ctrls.c |   27 ++++++++++++++++++++-
 include/media/v4l2-ctrls.h       |   48 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 983e287..b5da617 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1178,6 +1178,25 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 }
 EXPORT_SYMBOL(v4l2_ctrl_cluster);
 
+void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
+			    u8 manual_val, bool set_volatile)
+{
+	int i;
+
+	v4l2_ctrl_cluster(ncontrols, controls);
+	controls[0]->is_auto = true;
+	controls[0]->manual_mode_value = manual_val;
+
+	for (i = 1; i < ncontrols; i++) {
+		if (controls[i]) {
+			controls[i]->flags |= V4L2_CTRL_FLAG_UPDATE;
+			if (set_volatile)
+				controls[i]->is_volatile = true;
+		}
+	}
+}
+EXPORT_SYMBOL(v4l2_ctrl_auto_cluster);
+
 /* Activate/deactivate a control. */
 void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active)
 {
@@ -1605,7 +1624,8 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 
 		v4l2_ctrl_lock(master);
 		/* g_volatile_ctrl will update the current control values */
-		if (ctrl->is_volatile && master->ops->g_volatile_ctrl)
+		if (ctrl->is_volatile && master->ops->g_volatile_ctrl &&
+		    (!master->is_auto || master->cur.val != master->manual_mode_value))
 			ret = master->ops->g_volatile_ctrl(master);
 		/* If OK, then copy the current control values to the caller */
 		if (!ret)
@@ -1717,6 +1737,11 @@ static int try_or_set_control_cluster(struct v4l2_ctrl *master, bool set)
 
 	/* Don't set if there is no change */
 	if (!ret && set && cluster_changed(master)) {
+		if (master->is_auto && !master->is_new &&
+		    master->cur.val != master->manual_mode_value) {
+			master->is_new = 1;
+			master->val = master->manual_mode_value;
+		}
 		ret = master->ops->s_ctrl(master);
 		/* If OK, then make the new values permanent. */
 		if (!ret)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index a2b2d58..e715f4e 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -66,7 +66,16 @@ struct v4l2_ctrl_ops {
   *		retrieved through the g_volatile_ctrl op. Drivers can set
   *		this flag.
   * @is_enabled: If 0, then this control is disabled and will be hidden for
-  *		applications. Controls are always enabled by default.
+  *		applications. Controls are always enabled by default. Drivers
+  *		should never set this flag.
+  * @is_auto:   If set, then this control selects whether the other cluster
+  *		members are in 'automatic' mode or 'manual' mode. This is
+  *		used for autogain/gain type clusters. Drivers should never
+  *		set this flag.
+  * @manual_mode_value: If the is_auto flag is set, then this is the value
+  *		of the auto control that determines if that control is in
+  *		manual mode. So if the value of the auto control equals this
+  *		value, then the whole cluster is in manual mode.
   * @ops:	The control ops.
   * @id:	The control ID.
   * @name:	The control name.
@@ -108,6 +117,8 @@ struct v4l2_ctrl {
 	unsigned int is_private:1;
 	unsigned int is_volatile:1;
 	unsigned int is_enabled:1;
+	unsigned int is_auto:1;
+	unsigned int manual_mode_value:5;
 
 	const struct v4l2_ctrl_ops *ops;
 	u32 id;
@@ -366,6 +377,41 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
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
+  * Using this function lets the framework take care of some of the actions
+  * related to such controls: whenever one of the manual controls are set
+  * without touching the auto control, then the auto control is set to
+  * manual mode. So in the s_ctrl op you can just set the new values. Also,
+  * g_volatile_ctrl is never called when in manual mode, since in that case
+  * the current control value can just be returned as is.
+  *
+  * This function also makes it easy to set all non-auto controls to volatile
+  * by setting the last argument to true. In most cases non-auto controls are
+  * volatile when in auto mode. E.g. if autogain is set, then the gain register
+  * usually reports the current automatically selected gain.
+  *
+  * This function also sets the V4L2_CTRL_FLAG_UPDATE for all the non-auto
+  * controls.
+  */
+void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
+			u8 manual_val, bool set_volatile);
+
+
 /** v4l2_ctrl_find() - Find a control with the given ID.
   * @hdl:	The control handler.
   * @id:	The control ID to find.
-- 
1.7.0.4

