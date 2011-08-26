Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2928 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1HZMA3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 08:00:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 2/8] v4l2-ctrls: replace is_volatile with V4L2_CTRL_FLAG_VOLATILE.
Date: Fri, 26 Aug 2011 14:00:07 +0200
Message-Id: <deb7c0e859edc7b0eb7bcbc4d70311bc81e5b83b.1314359706.git.hans.verkuil@cisco.com>
In-Reply-To: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
References: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c30383666acc85a530fba5b1a14189670dfb8bb3.1314359706.git.hans.verkuil@cisco.com>
References: <c30383666acc85a530fba5b1a14189670dfb8bb3.1314359706.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

With the new flag there is no need anymore to have a separate is_volatile
field. Modify all users to use the new flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-controls.txt |   13 ++++-----
 drivers/media/radio/radio-wl1273.c          |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c     |    2 +-
 drivers/media/video/adp1653.c               |    2 +-
 drivers/media/video/pwc/pwc-v4l.c           |   10 +++---
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c   |    4 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c   |    2 +-
 drivers/media/video/saa7115.c               |    2 +-
 drivers/media/video/v4l2-ctrls.c            |   36 ++++++++++++--------------
 include/media/v4l2-ctrls.h                  |   12 +--------
 10 files changed, 36 insertions(+), 49 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 9346fc8..f92ee30 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -285,11 +285,11 @@ implement g_volatile_ctrl like this:
 Note that you use the 'new value' union as well in g_volatile_ctrl. In general
 controls that need to implement g_volatile_ctrl are read-only controls.
 
-To mark a control as volatile you have to set the is_volatile flag:
+To mark a control as volatile you have to set V4L2_CTRL_FLAG_VOLATILE:
 
 	ctrl = v4l2_ctrl_new_std(&sd->ctrl_handler, ...);
 	if (ctrl)
-		ctrl->is_volatile = 1;
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
 
 For try/s_ctrl the new values (i.e. as passed by the user) are filled in and
 you can modify them in try_ctrl or set them in s_ctrl. The 'cur' union
@@ -367,8 +367,7 @@ Driver specific controls can be created using v4l2_ctrl_new_custom():
 The last argument is the priv pointer which can be set to driver-specific
 private data.
 
-The v4l2_ctrl_config struct also has fields to set the is_private and is_volatile
-flags.
+The v4l2_ctrl_config struct also has a field to set the is_private flag.
 
 If the name field is not set, then the framework will assume this is a standard
 control and will fill in the name, type and flags fields accordingly.
@@ -506,8 +505,8 @@ operation should return the value that the hardware's automatic mode set up
 automatically.
 
 If the cluster is put in manual mode, then the manual controls should become
-active again and the is_volatile flag should be ignored (so g_volatile_ctrl is
-no longer called while in manual mode).
+active again and V4L2_CTRL_FLAG_VOLATILE should be ignored (so g_volatile_ctrl
+is no longer called while in manual mode).
 
 Finally the V4L2_CTRL_FLAG_UPDATE should be set for the auto control since
 changing that control affects the control flags of the manual controls.
@@ -520,7 +519,7 @@ void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
 
 The first two arguments are identical to v4l2_ctrl_cluster. The third argument
 tells the framework which value switches the cluster into manual mode. The
-last argument will optionally set the is_volatile flag for the non-auto controls.
+last argument will optionally set V4L2_CTRL_FLAG_VOLATILE for the non-auto controls.
 
 The first control of the cluster is assumed to be the 'auto' control.
 
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 46cacf8..6d1e4e7 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -2109,7 +2109,7 @@ static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
 				 V4L2_CID_TUNE_ANTENNA_CAPACITOR,
 				 0, 255, 1, 255);
 	if (ctrl)
-		ctrl->is_volatile = 1;
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
 
 	if (radio->ctrl_handler.error) {
 		r = radio->ctrl_handler.error;
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 8c0e192..54b34e5 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -557,7 +557,7 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 			255, 1, 255);
 
 	if (ctrl)
-		ctrl->is_volatile = 1;
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
 
 	return 0;
 }
diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
index 279d75d..d0e8ac1 100644
--- a/drivers/media/video/adp1653.c
+++ b/drivers/media/video/adp1653.c
@@ -258,7 +258,7 @@ static int adp1653_init_controls(struct adp1653_flash *flash)
 	if (flash->ctrls.error)
 		return flash->ctrls.error;
 
-	fault->is_volatile = 1;
+	fault->flags |= V4L2_CTRL_FLAG_VOLATILE;
 
 	flash->subdev.ctrl_handler = &flash->ctrls;
 	return 0;
diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
index e9a0e94..b6c20aa 100644
--- a/drivers/media/video/pwc/pwc-v4l.c
+++ b/drivers/media/video/pwc/pwc-v4l.c
@@ -640,7 +640,7 @@ static int pwc_set_awb(struct pwc_device *pdev)
 			return ret;
 
 		/* Update val when coming from auto or going to a preset */
-		if (pdev->red_balance->is_volatile ||
+		if ((pdev->red_balance->flags & V4L2_CTRL_FLAG_VOLATILE) ||
 		    pdev->auto_white_balance->val == awb_indoor ||
 		    pdev->auto_white_balance->val == awb_outdoor ||
 		    pdev->auto_white_balance->val == awb_fl) {
@@ -654,12 +654,12 @@ static int pwc_set_awb(struct pwc_device *pdev)
 					&pdev->blue_balance->val);
 		}
 		if (pdev->auto_white_balance->val == awb_auto) {
-			pdev->red_balance->is_volatile = true;
-			pdev->blue_balance->is_volatile = true;
+			pdev->red_balance->flags |= V4L2_CTRL_FLAG_VOLATILE;
+			pdev->blue_balance->flags |= V4L2_CTRL_FLAG_VOLATILE;
 			pdev->color_bal_valid = false; /* Force cache update */
 		} else {
-			pdev->red_balance->is_volatile = false;
-			pdev->blue_balance->is_volatile = false;
+			pdev->red_balance->flags &= ~V4L2_CTRL_FLAG_VOLATILE;
+			pdev->blue_balance->flags &= ~V4L2_CTRL_FLAG_VOLATILE;
 		}
 	}
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index b2c5052..bbf8ac7 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -165,7 +165,7 @@ static struct mfc_control controls[] = {
 		.maximum = 32,
 		.step = 1,
 		.default_value = 1,
-		.is_volatile = 1,
+		.flags = V4L2_CTRL_FLAG_VOLATILE,
 	},
 };
 
@@ -1020,7 +1020,7 @@ int s5p_mfc_dec_ctrls_setup(struct s5p_mfc_ctx *ctx)
 			return ctx->ctrl_handler.error;
 		}
 		if (controls[i].is_volatile && ctx->ctrls[i])
-			ctx->ctrls[i]->is_volatile = 1;
+			ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_VOLATILE;
 	}
 	return 0;
 }
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index fee094a..59ef5da 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -1814,7 +1814,7 @@ int s5p_mfc_enc_ctrls_setup(struct s5p_mfc_ctx *ctx)
 			return ctx->ctrl_handler.error;
 		}
 		if (controls[i].is_volatile && ctx->ctrls[i])
-			ctx->ctrls[i]->is_volatile = 1;
+			ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_VOLATILE;
 	}
 	return 0;
 }
diff --git a/drivers/media/video/saa7115.c b/drivers/media/video/saa7115.c
index f2ae405..e443d0d 100644
--- a/drivers/media/video/saa7115.c
+++ b/drivers/media/video/saa7115.c
@@ -1601,7 +1601,7 @@ static int saa711x_probe(struct i2c_client *client,
 			V4L2_CID_CHROMA_AGC, 0, 1, 1, 1);
 	state->gain = v4l2_ctrl_new_std(hdl, &saa711x_ctrl_ops,
 			V4L2_CID_CHROMA_GAIN, 0, 127, 1, 40);
-	state->gain->is_volatile = 1;
+	state->gain->flags |= V4L2_CTRL_FLAG_VOLATILE;
 	sd->ctrl_handler = hdl;
 	if (hdl->error) {
 		int err = hdl->error;
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 06b6014..1667621 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -43,7 +43,7 @@ struct v4l2_ctrl_helper {
 };
 
 /* Small helper function to determine if the autocluster is set to manual
-   mode. In that case the is_volatile flag should be ignored. */
+   mode. */
 static bool is_cur_manual(const struct v4l2_ctrl *master)
 {
 	return master->is_auto && master->cur.val == master->manual_mode_value;
@@ -1394,10 +1394,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 			type, min, max,
 			is_menu ? cfg->menu_skip_mask : step,
 			def, flags, qmenu, priv);
-	if (ctrl) {
+	if (ctrl)
 		ctrl->is_private = cfg->is_private;
-		ctrl->is_volatile = cfg->is_volatile;
-	}
 	return ctrl;
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_custom);
@@ -1519,12 +1517,12 @@ void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
 	master->manual_mode_value = manual_val;
 	master->flags |= V4L2_CTRL_FLAG_UPDATE;
 	flag = is_cur_manual(master) ? 0 : V4L2_CTRL_FLAG_INACTIVE;
+	if (set_volatile)
+		flag |= V4L2_CTRL_FLAG_VOLATILE;
 
 	for (i = 1; i < ncontrols; i++)
-		if (controls[i]) {
-			controls[i]->is_volatile = set_volatile;
+		if (controls[i])
 			controls[i]->flags |= flag;
-		}
 }
 EXPORT_SYMBOL(v4l2_ctrl_auto_cluster);
 
@@ -1579,9 +1577,6 @@ EXPORT_SYMBOL(v4l2_ctrl_grab);
 static void log_ctrl(const struct v4l2_ctrl *ctrl,
 		     const char *prefix, const char *colon)
 {
-	int fl_inact = ctrl->flags & V4L2_CTRL_FLAG_INACTIVE;
-	int fl_grabbed = ctrl->flags & V4L2_CTRL_FLAG_GRABBED;
-
 	if (ctrl->flags & (V4L2_CTRL_FLAG_DISABLED | V4L2_CTRL_FLAG_WRITE_ONLY))
 		return;
 	if (ctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
@@ -1612,14 +1607,17 @@ static void log_ctrl(const struct v4l2_ctrl *ctrl,
 		printk(KERN_CONT "unknown type %d", ctrl->type);
 		break;
 	}
-	if (fl_inact && fl_grabbed)
-		printk(KERN_CONT " (inactive, grabbed)\n");
-	else if (fl_inact)
-		printk(KERN_CONT " (inactive)\n");
-	else if (fl_grabbed)
-		printk(KERN_CONT " (grabbed)\n");
-	else
-		printk(KERN_CONT "\n");
+	if (ctrl->flags & (V4L2_CTRL_FLAG_INACTIVE |
+			   V4L2_CTRL_FLAG_GRABBED |
+			   V4L2_CTRL_FLAG_VOLATILE)) {
+		if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
+			printk(KERN_CONT " inactive");
+		if (ctrl->flags & V4L2_CTRL_FLAG_GRABBED)
+			printk(KERN_CONT " grabbed");
+		if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE)
+			printk(KERN_CONT " volatile");
+	}
+	printk(KERN_CONT "\n");
 }
 
 /* Log all controls owned by the handler */
@@ -2004,7 +2002,7 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
 
 	v4l2_ctrl_lock(master);
 	/* g_volatile_ctrl will update the current control values */
-	if (ctrl->is_volatile && !is_cur_manual(master)) {
+	if ((ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) && !is_cur_manual(master)) {
 		for (i = 0; i < master->ncontrols; i++)
 			cur_to_new(master->cluster[i]);
 		ret = call_op(master, g_volatile_ctrl);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 13fe4d7..bd6a4a7 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -65,10 +65,6 @@ struct v4l2_ctrl_ops {
   * @is_private: If set, then this control is private to its handler and it
   *		will not be added to any other handlers. Drivers can set
   *		this flag.
-  * @is_volatile: If set, then this control is volatile. This means that the
-  *		control's current value cannot be cached and needs to be
-  *		retrieved through the g_volatile_ctrl op. Drivers can set
-  *		this flag.
   * @is_auto:   If set, then this control selects whether the other cluster
   *		members are in 'automatic' mode or 'manual' mode. This is
   *		used for autogain/gain type clusters. Drivers should never
@@ -118,7 +114,6 @@ struct v4l2_ctrl {
 
 	unsigned int is_new:1;
 	unsigned int is_private:1;
-	unsigned int is_volatile:1;
 	unsigned int is_auto:1;
 	unsigned int manual_mode_value:8;
 
@@ -208,9 +203,6 @@ struct v4l2_ctrl_handler {
   *		must be NULL.
   * @is_private: If set, then this control is private to its handler and it
   *		will not be added to any other handlers.
-  * @is_volatile: If set, then this control is volatile. This means that the
-  *		control's current value cannot be cached and needs to be
-  *		retrieved through the g_volatile_ctrl op.
   */
 struct v4l2_ctrl_config {
 	const struct v4l2_ctrl_ops *ops;
@@ -225,7 +217,6 @@ struct v4l2_ctrl_config {
 	u32 menu_skip_mask;
 	const char * const *qmenu;
 	unsigned int is_private:1;
-	unsigned int is_volatile:1;
 };
 
 /** v4l2_ctrl_fill() - Fill in the control fields based on the control ID.
@@ -389,8 +380,7 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls);
   * @manual_val: The value for the first control in the cluster that equals the
   *		manual setting.
   * @set_volatile: If true, then all controls except the first auto control will
-  *		have is_volatile set to true. If false, then is_volatile will not
-  *		be touched.
+  *		be volatile.
   *
   * Use for control groups where one control selects some automatic feature and
   * the other controls are only active whenever the automatic feature is turned
-- 
1.7.5.4

