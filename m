Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45793 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbcGRB41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Vladimir Zapolskiy <vz@mleia.com>, linux-doc@vger.kernel.org
Subject: [PATCH 06/36] [media] doc-rst: move videobuf documentation to media/kapi
Date: Sun, 17 Jul 2016 22:55:49 -0300
Message-Id: <9488fed623eff249273b83503abfc8a20409f6b1.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This document describes a kapi framework. Move it to the right
place.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-controls.rst         | 169 +++++++++++++++------
 .../videobuf => media/kapi/videobuf.rst}           |   0
 2 files changed, 122 insertions(+), 47 deletions(-)
 rename Documentation/{video4linux/videobuf => media/kapi/videobuf.rst} (100%)

diff --git a/Documentation/media/kapi/v4l2-controls.rst b/Documentation/media/kapi/v4l2-controls.rst
index 5e759cab4538..8ff9ee806042 100644
--- a/Documentation/media/kapi/v4l2-controls.rst
+++ b/Documentation/media/kapi/v4l2-controls.rst
@@ -1,5 +1,8 @@
+V4L2 Controls
+=============
+
 Introduction
-============
+------------
 
 The V4L2 control API seems simple enough, but quickly becomes very hard to
 implement correctly in drivers. But much of the code needed to handle controls
@@ -26,7 +29,7 @@ for V4L2 drivers and struct v4l2_subdev for sub-device drivers.
 
 
 Objects in the framework
-========================
+------------------------
 
 There are two main objects:
 
@@ -39,12 +42,14 @@ controls, possibly to controls owned by other handlers.
 
 
 Basic usage for V4L2 and sub-device drivers
-===========================================
+-------------------------------------------
 
 1) Prepare the driver:
 
 1.1) Add the handler to your driver's top-level struct:
 
+.. code-block:: none
+
 	struct foo_dev {
 		...
 		struct v4l2_ctrl_handler ctrl_handler;
@@ -55,16 +60,20 @@ Basic usage for V4L2 and sub-device drivers
 
 1.2) Initialize the handler:
 
+.. code-block:: none
+
 	v4l2_ctrl_handler_init(&foo->ctrl_handler, nr_of_controls);
 
-  The second argument is a hint telling the function how many controls this
-  handler is expected to handle. It will allocate a hashtable based on this
-  information. It is a hint only.
+The second argument is a hint telling the function how many controls this
+handler is expected to handle. It will allocate a hashtable based on this
+information. It is a hint only.
 
 1.3) Hook the control handler into the driver:
 
 1.3.1) For V4L2 drivers do this:
 
+.. code-block:: none
+
 	struct foo_dev {
 		...
 		struct v4l2_device v4l2_dev;
@@ -75,15 +84,17 @@ Basic usage for V4L2 and sub-device drivers
 
 	foo->v4l2_dev.ctrl_handler = &foo->ctrl_handler;
 
-  Where foo->v4l2_dev is of type struct v4l2_device.
+Where foo->v4l2_dev is of type struct v4l2_device.
 
-  Finally, remove all control functions from your v4l2_ioctl_ops (if any):
-  vidioc_queryctrl, vidioc_query_ext_ctrl, vidioc_querymenu, vidioc_g_ctrl,
-  vidioc_s_ctrl, vidioc_g_ext_ctrls, vidioc_try_ext_ctrls and vidioc_s_ext_ctrls.
-  Those are now no longer needed.
+Finally, remove all control functions from your v4l2_ioctl_ops (if any):
+vidioc_queryctrl, vidioc_query_ext_ctrl, vidioc_querymenu, vidioc_g_ctrl,
+vidioc_s_ctrl, vidioc_g_ext_ctrls, vidioc_try_ext_ctrls and vidioc_s_ext_ctrls.
+Those are now no longer needed.
 
 1.3.2) For sub-device drivers do this:
 
+.. code-block:: none
+
 	struct foo_dev {
 		...
 		struct v4l2_subdev sd;
@@ -94,10 +105,12 @@ Basic usage for V4L2 and sub-device drivers
 
 	foo->sd.ctrl_handler = &foo->ctrl_handler;
 
-  Where foo->sd is of type struct v4l2_subdev.
+Where foo->sd is of type struct v4l2_subdev.
 
-  And set all core control ops in your struct v4l2_subdev_core_ops to these
-  helpers:
+And set all core control ops in your struct v4l2_subdev_core_ops to these
+helpers:
+
+.. code-block:: none
 
 	.queryctrl = v4l2_subdev_queryctrl,
 	.querymenu = v4l2_subdev_querymenu,
@@ -107,12 +120,14 @@ Basic usage for V4L2 and sub-device drivers
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
 
-  Note: this is a temporary solution only. Once all V4L2 drivers that depend
-  on subdev drivers are converted to the control framework these helpers will
-  no longer be needed.
+Note: this is a temporary solution only. Once all V4L2 drivers that depend
+on subdev drivers are converted to the control framework these helpers will
+no longer be needed.
 
 1.4) Clean up the handler at the end:
 
+.. code-block:: none
+
 	v4l2_ctrl_handler_free(&foo->ctrl_handler);
 
 
@@ -120,12 +135,16 @@ Basic usage for V4L2 and sub-device drivers
 
 You add non-menu controls by calling v4l2_ctrl_new_std:
 
+.. code-block:: none
+
 	struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, s32 min, s32 max, u32 step, s32 def);
 
 Menu and integer menu controls are added by calling v4l2_ctrl_new_std_menu:
 
+.. code-block:: none
+
 	struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, s32 max, s32 skip_mask, s32 def);
@@ -133,6 +152,8 @@ Menu and integer menu controls are added by calling v4l2_ctrl_new_std_menu:
 Menu controls with a driver specific menu are added by calling
 v4l2_ctrl_new_std_menu_items:
 
+.. code-block:: none
+
        struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(
                        struct v4l2_ctrl_handler *hdl,
                        const struct v4l2_ctrl_ops *ops, u32 id, s32 max,
@@ -141,12 +162,16 @@ v4l2_ctrl_new_std_menu_items:
 Integer menu controls with a driver specific menu can be added by calling
 v4l2_ctrl_new_int_menu:
 
+.. code-block:: none
+
 	struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, s32 max, s32 def, const s64 *qmenu_int);
 
 These functions are typically called right after the v4l2_ctrl_handler_init:
 
+.. code-block:: none
+
 	static const s64 exp_bias_qmenu[] = {
 	       -2, -1, 0, 1, 2
 	};
@@ -223,6 +248,8 @@ a bit faster that way.
 
 3) Optionally force initial control setup:
 
+.. code-block:: none
+
 	v4l2_ctrl_handler_setup(&foo->ctrl_handler);
 
 This will call s_ctrl for all controls unconditionally. Effectively this
@@ -232,12 +259,16 @@ the hardware are in sync.
 
 4) Finally: implement the v4l2_ctrl_ops
 
+.. code-block:: none
+
 	static const struct v4l2_ctrl_ops foo_ctrl_ops = {
 		.s_ctrl = foo_s_ctrl,
 	};
 
 Usually all you need is s_ctrl:
 
+.. code-block:: none
+
 	static int foo_s_ctrl(struct v4l2_ctrl *ctrl)
 	{
 		struct foo *state = container_of(ctrl->handler, struct foo, ctrl_handler);
@@ -262,16 +293,14 @@ to do any validation of control values, or implement QUERYCTRL, QUERY_EXT_CTRL
 and QUERYMENU. And G/S_CTRL as well as G/TRY/S_EXT_CTRLS are automatically supported.
 
 
-==============================================================================
+.. note::
 
-The remainder of this document deals with more advanced topics and scenarios.
-In practice the basic usage as described above is sufficient for most drivers.
-
-===============================================================================
+   The remainder sections deal with more advanced controls topics and scenarios.
+   In practice the basic usage as described above is sufficient for most drivers.
 
 
 Inheriting Controls
-===================
+-------------------
 
 When a sub-device is registered with a V4L2 driver by calling
 v4l2_device_register_subdev() and the ctrl_handler fields of both v4l2_subdev
@@ -286,21 +315,25 @@ of v4l2_device.
 
 
 Accessing Control Values
-========================
+------------------------
 
 The following union is used inside the control framework to access control
 values:
 
-union v4l2_ctrl_ptr {
-	s32 *p_s32;
-	s64 *p_s64;
-	char *p_char;
-	void *p;
-};
+.. code-block:: none
+
+	union v4l2_ctrl_ptr {
+		s32 *p_s32;
+		s64 *p_s64;
+		char *p_char;
+		void *p;
+	};
 
 The v4l2_ctrl struct contains these fields that can be used to access both
 current and new values:
 
+.. code-block:: none
+
 	s32 val;
 	struct {
 		s32 val;
@@ -312,6 +345,8 @@ current and new values:
 
 If the control has a simple s32 type type, then:
 
+.. code-block:: none
+
 	&ctrl->val == ctrl->p_new.p_s32
 	&ctrl->cur.val == ctrl->p_cur.p_s32
 
@@ -334,6 +369,8 @@ exception is for controls that return a volatile register such as a signal
 strength read-out that changes continuously. In that case you will need to
 implement g_volatile_ctrl like this:
 
+.. code-block:: none
+
 	static int foo_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 	{
 		switch (ctrl->id) {
@@ -350,6 +387,8 @@ changes.
 
 To mark a control as volatile you have to set V4L2_CTRL_FLAG_VOLATILE:
 
+.. code-block:: none
+
 	ctrl = v4l2_ctrl_new_std(&sd->ctrl_handler, ...);
 	if (ctrl)
 		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
@@ -369,6 +408,8 @@ not to introduce deadlocks.
 Outside of the control ops you have to go through to helper functions to get
 or set a single control value safely in your driver:
 
+.. code-block:: none
+
 	s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
 	int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
 
@@ -378,6 +419,8 @@ will result in a deadlock since these helpers lock the handler as well.
 
 You can also take the handler lock yourself:
 
+.. code-block:: none
+
 	mutex_lock(&state->ctrl_handler.lock);
 	pr_info("String value is '%s'\n", ctrl1->p_cur.p_char);
 	pr_info("Integer value is '%s'\n", ctrl2->cur.val);
@@ -385,10 +428,12 @@ You can also take the handler lock yourself:
 
 
 Menu Controls
-=============
+-------------
 
 The v4l2_ctrl struct contains this union:
 
+.. code-block:: none
+
 	union {
 		u32 step;
 		u32 menu_skip_mask;
@@ -411,10 +456,12 @@ control, or by calling v4l2_ctrl_new_std_menu().
 
 
 Custom Controls
-===============
+---------------
 
 Driver specific controls can be created using v4l2_ctrl_new_custom():
 
+.. code-block:: none
+
 	static const struct v4l2_ctrl_config ctrl_filter = {
 		.ops = &ctrl_custom_ops,
 		.id = V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER,
@@ -437,7 +484,7 @@ control and will fill in the name, type and flags fields accordingly.
 
 
 Active and Grabbed Controls
-===========================
+---------------------------
 
 If you get more complex relationships between controls, then you may have to
 activate and deactivate controls. For example, if the Chroma AGC control is
@@ -461,16 +508,18 @@ starts or stops streaming.
 
 
 Control Clusters
-================
+----------------
 
 By default all controls are independent from the others. But in more
 complex scenarios you can get dependencies from one control to another.
 In that case you need to 'cluster' them:
 
+.. code-block:: none
+
 	struct foo {
 		struct v4l2_ctrl_handler ctrl_handler;
-#define AUDIO_CL_VOLUME (0)
-#define AUDIO_CL_MUTE   (1)
+	#define AUDIO_CL_VOLUME (0)
+	#define AUDIO_CL_MUTE   (1)
 		struct v4l2_ctrl *audio_cluster[2];
 		...
 	};
@@ -489,6 +538,8 @@ composite control. Similar to how a 'struct' works in C.
 So when s_ctrl is called with V4L2_CID_AUDIO_VOLUME as argument, you should set
 all two controls belonging to the audio_cluster:
 
+.. code-block:: none
+
 	static int foo_s_ctrl(struct v4l2_ctrl *ctrl)
 	{
 		struct foo *state = container_of(ctrl->handler, struct foo, ctrl_handler);
@@ -509,12 +560,16 @@ all two controls belonging to the audio_cluster:
 
 In the example above the following are equivalent for the VOLUME case:
 
+.. code-block:: none
+
 	ctrl == ctrl->cluster[AUDIO_CL_VOLUME] == state->audio_cluster[AUDIO_CL_VOLUME]
 	ctrl->cluster[AUDIO_CL_MUTE] == state->audio_cluster[AUDIO_CL_MUTE]
 
 In practice using cluster arrays like this becomes very tiresome. So instead
 the following equivalent method is used:
 
+.. code-block:: none
+
 	struct {
 		/* audio cluster */
 		struct v4l2_ctrl *volume;
@@ -525,6 +580,8 @@ The anonymous struct is used to clearly 'cluster' these two control pointers,
 but it serves no other purpose. The effect is the same as creating an
 array with two control pointers. So you can just do:
 
+.. code-block:: none
+
 	state->volume = v4l2_ctrl_new_std(&state->ctrl_handler, ...);
 	state->mute = v4l2_ctrl_new_std(&state->ctrl_handler, ...);
 	v4l2_ctrl_cluster(2, &state->volume);
@@ -554,7 +611,7 @@ The 'is_new' flag is always 1 when called from v4l2_ctrl_handler_setup().
 
 
 Handling autogain/gain-type Controls with Auto Clusters
-=======================================================
+-------------------------------------------------------
 
 A common type of control cluster is one that handles 'auto-foo/foo'-type
 controls. Typical examples are autogain/gain, autoexposure/exposure,
@@ -579,8 +636,10 @@ changing that control affects the control flags of the manual controls.
 In order to simplify this a special variation of v4l2_ctrl_cluster was
 introduced:
 
-void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
-			u8 manual_val, bool set_volatile);
+.. code-block:: none
+
+	void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
+				    u8 manual_val, bool set_volatile);
 
 The first two arguments are identical to v4l2_ctrl_cluster. The third argument
 tells the framework which value switches the cluster into manual mode. The
@@ -597,7 +656,7 @@ flag and volatile handling.
 
 
 VIDIOC_LOG_STATUS Support
-=========================
+-------------------------
 
 This ioctl allow you to dump the current status of a driver to the kernel log.
 The v4l2_ctrl_handler_log_status(ctrl_handler, prefix) can be used to dump the
@@ -607,7 +666,7 @@ for you.
 
 
 Different Handlers for Different Video Nodes
-============================================
+--------------------------------------------
 
 Usually the V4L2 driver has just one control handler that is global for
 all video nodes. But you can also specify different control handlers for
@@ -632,6 +691,8 @@ of another handler (e.g. for a video device node), then you should first add
 the controls to the first handler, add the other controls to the second
 handler and finally add the first handler to the second. For example:
 
+.. code-block:: none
+
 	v4l2_ctrl_new_std(&radio_ctrl_handler, &radio_ops, V4L2_CID_AUDIO_VOLUME, ...);
 	v4l2_ctrl_new_std(&radio_ctrl_handler, &radio_ops, V4L2_CID_AUDIO_MUTE, ...);
 	v4l2_ctrl_new_std(&video_ctrl_handler, &video_ops, V4L2_CID_BRIGHTNESS, ...);
@@ -644,6 +705,8 @@ all controls.
 
 Or you can add specific controls to a handler:
 
+.. code-block:: none
+
 	volume = v4l2_ctrl_new_std(&video_ctrl_handler, &ops, V4L2_CID_AUDIO_VOLUME, ...);
 	v4l2_ctrl_new_std(&video_ctrl_handler, &ops, V4L2_CID_BRIGHTNESS, ...);
 	v4l2_ctrl_new_std(&video_ctrl_handler, &ops, V4L2_CID_CONTRAST, ...);
@@ -651,6 +714,8 @@ Or you can add specific controls to a handler:
 What you should not do is make two identical controls for two handlers.
 For example:
 
+.. code-block:: none
+
 	v4l2_ctrl_new_std(&radio_ctrl_handler, &radio_ops, V4L2_CID_AUDIO_MUTE, ...);
 	v4l2_ctrl_new_std(&video_ctrl_handler, &video_ops, V4L2_CID_AUDIO_MUTE, ...);
 
@@ -660,7 +725,7 @@ can twiddle.
 
 
 Finding Controls
-================
+----------------
 
 Normally you have created the controls yourself and you can store the struct
 v4l2_ctrl pointer into your own struct.
@@ -670,6 +735,8 @@ not own. For example, if you have to find a volume control from a subdev.
 
 You can do that by calling v4l2_ctrl_find:
 
+.. code-block:: none
+
 	struct v4l2_ctrl *volume;
 
 	volume = v4l2_ctrl_find(sd->ctrl_handler, V4L2_CID_AUDIO_VOLUME);
@@ -677,6 +744,8 @@ You can do that by calling v4l2_ctrl_find:
 Since v4l2_ctrl_find will lock the handler you have to be careful where you
 use it. For example, this is not a good idea:
 
+.. code-block:: none
+
 	struct v4l2_ctrl_handler ctrl_handler;
 
 	v4l2_ctrl_new_std(&ctrl_handler, &video_ops, V4L2_CID_BRIGHTNESS, ...);
@@ -684,6 +753,8 @@ use it. For example, this is not a good idea:
 
 ...and in video_ops.s_ctrl:
 
+.. code-block:: none
+
 	case V4L2_CID_BRIGHTNESS:
 		contrast = v4l2_find_ctrl(&ctrl_handler, V4L2_CID_CONTRAST);
 		...
@@ -695,7 +766,7 @@ It is recommended not to use this function from inside the control ops.
 
 
 Inheriting Controls
-===================
+-------------------
 
 When one control handler is added to another using v4l2_ctrl_add_handler, then
 by default all controls from one are merged to the other. But a subdev might
@@ -704,6 +775,8 @@ not when it is used in consumer-level hardware. In that case you want to keep
 those low-level controls local to the subdev. You can do this by simply
 setting the 'is_private' flag of the control to 1:
 
+.. code-block:: none
+
 	static const struct v4l2_ctrl_config ctrl_private = {
 		.ops = &ctrl_custom_ops,
 		.id = V4L2_CID_...,
@@ -720,7 +793,7 @@ These controls will now be skipped when v4l2_ctrl_add_handler is called.
 
 
 V4L2_CTRL_TYPE_CTRL_CLASS Controls
-==================================
+----------------------------------
 
 Controls of this type can be used by GUIs to get the name of the control class.
 A fully featured GUI can make a dialog with multiple tabs with each tab
@@ -733,14 +806,16 @@ class is added.
 
 
 Adding Notify Callbacks
-=======================
+-----------------------
 
 Sometimes the platform or bridge driver needs to be notified when a control
 from a sub-device driver changes. You can set a notify callback by calling
 this function:
 
-void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl,
-	void (*notify)(struct v4l2_ctrl *ctrl, void *priv), void *priv);
+.. code-block:: none
+
+	void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl,
+		void (*notify)(struct v4l2_ctrl *ctrl, void *priv), void *priv);
 
 Whenever the give control changes value the notify callback will be called
 with a pointer to the control and the priv pointer that was passed with
diff --git a/Documentation/video4linux/videobuf b/Documentation/media/kapi/videobuf.rst
similarity index 100%
rename from Documentation/video4linux/videobuf
rename to Documentation/media/kapi/videobuf.rst
-- 
2.7.4

