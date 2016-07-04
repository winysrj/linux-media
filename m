Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37255 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbcGDIfh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:35:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 14/14] v4l2-subdev.h: remove the control subdev ops
Date: Mon,  4 Jul 2016 10:35:10 +0200
Message-Id: <1467621310-8203-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These are no longer used (finally!), so remove them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-controls.txt | 15 ----------
 drivers/media/v4l2-core/v4l2-ctrls.c        | 45 -----------------------------
 include/media/v4l2-ctrls.h                  | 10 -------
 include/media/v4l2-subdev.h                 | 21 --------------
 4 files changed, 91 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 5e759ca..f930b80 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -96,21 +96,6 @@ Basic usage for V4L2 and sub-device drivers
 
   Where foo->sd is of type struct v4l2_subdev.
 
-  And set all core control ops in your struct v4l2_subdev_core_ops to these
-  helpers:
-
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-
-  Note: this is a temporary solution only. Once all V4L2 drivers that depend
-  on subdev drivers are converted to the control framework these helpers will
-  no longer be needed.
-
 1.4) Clean up the handler at the end:
 
 	v4l2_ctrl_handler_free(&foo->ctrl_handler);
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 8b321e0..f7abfad 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2606,14 +2606,6 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
 }
 EXPORT_SYMBOL(v4l2_queryctrl);
 
-int v4l2_subdev_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	if (qc->id & (V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_COMPOUND))
-		return -EINVAL;
-	return v4l2_queryctrl(sd->ctrl_handler, qc);
-}
-EXPORT_SYMBOL(v4l2_subdev_queryctrl);
-
 /* Implement VIDIOC_QUERYMENU */
 int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm)
 {
@@ -2657,13 +2649,6 @@ int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm)
 }
 EXPORT_SYMBOL(v4l2_querymenu);
 
-int v4l2_subdev_querymenu(struct v4l2_subdev *sd, struct v4l2_querymenu *qm)
-{
-	return v4l2_querymenu(sd->ctrl_handler, qm);
-}
-EXPORT_SYMBOL(v4l2_subdev_querymenu);
-
-
 
 /* Some general notes on the atomic requirements of VIDIOC_G/TRY/S_EXT_CTRLS:
 
@@ -2890,12 +2875,6 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 }
 EXPORT_SYMBOL(v4l2_g_ext_ctrls);
 
-int v4l2_subdev_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs)
-{
-	return v4l2_g_ext_ctrls(sd->ctrl_handler, cs);
-}
-EXPORT_SYMBOL(v4l2_subdev_g_ext_ctrls);
-
 /* Helper function to get a single control */
 static int get_ctrl(struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
 {
@@ -2941,12 +2920,6 @@ int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *control)
 }
 EXPORT_SYMBOL(v4l2_g_ctrl);
 
-int v4l2_subdev_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *control)
-{
-	return v4l2_g_ctrl(sd->ctrl_handler, control);
-}
-EXPORT_SYMBOL(v4l2_subdev_g_ctrl);
-
 s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_ext_control c;
@@ -3194,18 +3167,6 @@ int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 }
 EXPORT_SYMBOL(v4l2_s_ext_ctrls);
 
-int v4l2_subdev_try_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs)
-{
-	return try_set_ext_ctrls(NULL, sd->ctrl_handler, cs, false);
-}
-EXPORT_SYMBOL(v4l2_subdev_try_ext_ctrls);
-
-int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs)
-{
-	return try_set_ext_ctrls(NULL, sd->ctrl_handler, cs, true);
-}
-EXPORT_SYMBOL(v4l2_subdev_s_ext_ctrls);
-
 /* Helper function for VIDIOC_S_CTRL compatibility */
 static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 {
@@ -3268,12 +3229,6 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 }
 EXPORT_SYMBOL(v4l2_s_ctrl);
 
-int v4l2_subdev_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *control)
-{
-	return v4l2_s_ctrl(NULL, sd->ctrl_handler, control);
-}
-EXPORT_SYMBOL(v4l2_subdev_s_ctrl);
-
 int __v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 {
 	lockdep_assert_held(ctrl->handler->lock);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 5c2ed0c..8b59336 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -903,16 +903,6 @@ int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *
 int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 						struct v4l2_ext_controls *c);
 
-/* Helpers for subdevices. If the associated ctrl_handler == NULL then they
-   will all return -EINVAL. */
-int v4l2_subdev_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc);
-int v4l2_subdev_querymenu(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
-int v4l2_subdev_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs);
-int v4l2_subdev_try_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs);
-int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs);
-int v4l2_subdev_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
-int v4l2_subdev_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
-
 /* Can be used as a subscribe_event function that just subscribes control
    events. */
 int v4l2_ctrl_subdev_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 32fc7a4..c672efc 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -143,20 +143,6 @@ struct v4l2_subdev_io_pin_config {
  * @s_gpio: set GPIO pins. Very simple right now, might need to be extended with
  *	a direction argument if needed.
  *
- * @queryctrl: callback for VIDIOC_QUERYCTL ioctl handler code.
- *
- * @g_ctrl: callback for VIDIOC_G_CTRL ioctl handler code.
- *
- * @s_ctrl: callback for VIDIOC_S_CTRL ioctl handler code.
- *
- * @g_ext_ctrls: callback for VIDIOC_G_EXT_CTRLS ioctl handler code.
- *
- * @s_ext_ctrls: callback for VIDIOC_S_EXT_CTRLS ioctl handler code.
- *
- * @try_ext_ctrls: callback for VIDIOC_TRY_EXT_CTRLS ioctl handler code.
- *
- * @querymenu: callback for VIDIOC_QUERYMENU ioctl handler code.
- *
  * @ioctl: called at the end of ioctl() syscall handler at the V4L2 core.
  *	   used to provide support for private ioctls used on the driver.
  *
@@ -190,13 +176,6 @@ struct v4l2_subdev_core_ops {
 	int (*load_fw)(struct v4l2_subdev *sd);
 	int (*reset)(struct v4l2_subdev *sd, u32 val);
 	int (*s_gpio)(struct v4l2_subdev *sd, u32 val);
-	int (*queryctrl)(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc);
-	int (*g_ctrl)(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
-	int (*s_ctrl)(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
-	int (*g_ext_ctrls)(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls);
-	int (*s_ext_ctrls)(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls);
-	int (*try_ext_ctrls)(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls);
-	int (*querymenu)(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
 	long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
 #ifdef CONFIG_COMPAT
 	long (*compat_ioctl32)(struct v4l2_subdev *sd, unsigned int cmd,
-- 
2.8.1

