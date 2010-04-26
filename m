Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2330 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab0DZHdl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 03:33:41 -0400
Message-Id: <6f82d49ed27478ed94b2d5487993d101152f687c.1272267137.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1272267136.git.hverkuil@xs4all.nl>
References: <cover.1272267136.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 26 Apr 2010 09:33:38 +0200
Subject: [PATCH 03/15] [RFC] Documentation: add v4l2-controls.txt documenting the new controls API.
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 Documentation/video4linux/v4l2-controls.txt |  543 +++++++++++++++++++++++++++
 1 files changed, 543 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/video4linux/v4l2-controls.txt

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
new file mode 100644
index 0000000..29a92b4
--- /dev/null
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -0,0 +1,543 @@
+Introduction
+============
+
+The V4L2 control API seems simple enough, but quickly becomes very hard to
+implement correctly in drivers. But much of the code needed to handle controls
+is actually not driver specific and can be moved to the V4L core framework.
+
+After all, the only part that a driver developer is interested in is:
+
+1) How do I add a control?
+2) How do I set the control? (i.e. s_ctrl)
+
+And occasionally:
+
+3) How do I update the control's value? (i.e. g_ctrl)
+4) How do I validate the user's proposed control value? (i.e. try_ctrl)
+
+All the rest is something that can be done centrally.
+
+The control framework was created in order to implement all the rules of the
+V4L2 specification with respect to controls in a central place. And to make
+life as easy as possible for the driver developer.
+
+
+Objects in the framework
+========================
+
+There are two main objects:
+
+The v4l2_ctrl object describes the control properties and keeps track of the
+control's value (both the current value and the proposed new value).
+
+v4l2_ctrl_handler is the object that keeps track of controls. It maintains a
+list of v4l2_ctrl objects that it owns and another list of references to
+controls, possibly to controls owned by other handlers.
+
+
+Basic usage
+===========
+
+1) Prepare the driver:
+
+- Add the handler to your main bridge driver or sub-device driver top-level
+  struct:
+
+	struct foo_dev {
+		...
+		struct v4l2_ctrl_handler hdl;
+		...
+	};
+
+	struct foo_dev *foo;
+
+- Initialize handler:
+
+	v4l2_ctrl_handler_init(&foo->hdl, nr_of_controls);
+
+  The second argument is a hint telling the function how many controls this
+  handled is expected to handle. It will allocate a hashtable based on this
+  information. It is a hint only.
+
+- Hooking the control handler into a driver:
+
+  When a subdevice is being registered with a bridge driver and the
+  ctrl_handler fields of both v4l2_subdev and v4l2_device are set, then the
+  controls of the subdev will become automatically available in the bridge
+  driver as well. If the subdev driver contains controls that already exist in
+  the bridge driver, then those will be skipped (so a bridge driver can always
+  override a subdev control).
+
+  How to hook the handler into a bridge driver:
+
+	foo->v4l2_dev.ctrl_handler = &foo->hdl;
+
+  And whenever you call video_register_device() you must set the
+  ctrl_handler field of struct video_device as well:
+
+	vdev->ctrl_handler = &foo->hdl;
+
+  Finally, remove all control functions from your v4l2_ioctl_ops:
+  vidioc_queryctrl, vidioc_querymenu, vidioc_g_ctrl, vidioc_s_ctrl,
+  vidioc_g_ext_ctrls, vidioc_try_ext_ctrls and vidioc_s_ext_ctrls.
+  Those are now no longer needed.
+
+  How to hook the control handler into a subdev driver:
+
+	foo->sd.ctrl_handler = &foo->hdl;
+
+  And set all core control ops in your struct v4l2_subdev_core_ops to these
+  helpers:
+
+	.queryctrl = v4l2_sd_queryctrl,
+	.querymenu = v4l2_sd_querymenu,
+	.g_ctrl = v4l2_sd_g_ctrl,
+	.s_ctrl = v4l2_sd_s_ctrl,
+	.g_ext_ctrls = v4l2_sd_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_sd_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_sd_s_ext_ctrls,
+
+  This is for backwards compatibility. Once all bridge drivers are converted
+  these control ops can be removed just as they are already for bridge drivers.
+
+- Clean up the handler at the end:
+
+	v4l2_ctrl_handler_free(&foo->hdl);
+
+
+2) Add controls:
+
+Typically done right after the handler_init:
+
+	v4l2_ctrl_handler_init(&foo->hdl, nr_of_controls);
+	v4l2_ctrl_new_std(&foo->hdl, &foo_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&foo->hdl, &foo_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 255, 1, 128);
+	...
+	if (foo->hdl.error) {
+		int err = foo->hdl.error;
+
+		v4l2_ctrl_handler_free(&foo->hdl);
+		return err;
+	}
+
+The v4l2_ctrl_new_std function returns the v4l2_ctrl pointer to the new
+control, but if you do not need to access the pointer outside the control ops,
+then there is no need to store it.
+
+Note that if something fails, the function will return NULL or an error and
+set hdl->error to the error code. If hdl->error was already set, then it
+will just return and do nothing. This is also true for v4l2_ctrl_handler_init
+if it cannot allocate the internal data structure.
+
+This makes it easy to init the handler and just add all controls and only check
+the error code at the end. Saves a lot of repetitive error checking.
+
+It is recommended to add controls in ascending control ID order: it will be
+a bit faster that way.
+
+3) Optionally force initial control setup:
+
+	v4l2_ctrl_handler_setup(&foo->hdl);
+
+This will call s_ctrl for all controls unconditionally. Effectively this
+initializes the hardware to the default control values. It is recommended
+that you do this.
+
+4) Finally: implement the v4l2_ctrl_ops
+
+	static const struct v4l2_ctrl_ops foo_ctrl_ops = {
+		.s_ctrl = foo_s_ctrl,
+	};
+
+Usually all you need is s_ctrl:
+
+	static int foo_s_ctrl(struct v4l2_ctrl *ctrl)
+	{
+		struct foo *state = container_of(ctrl->handler, struct foo, hdl);
+
+		switch (ctrl->id) {
+		case V4L2_CID_BRIGHTNESS:
+			write_reg(0x123, ctrl->val);
+			break;
+		case V4L2_CID_CONTRAST:
+			write_reg(0x456, ctrl->val);
+			break;
+		}
+		return 0;
+	}
+
+The control ops are called with the v4l2_ctrl pointer as argument.
+The new control value has already been validated, so all you need to do is
+to actually update the hardware registers.
+
+You're done! And this is sufficient for most of the drivers we have. No need
+to do any validation of control values, or implement QUERYCTRL/QUERYMENU. And
+G/S_CTRL as well as G/TRY/S_EXT_CTRLS are automatically supported.
+
+
+===============================================================================
+
+The remainder of this document deals with more advanced topics and scenarios.
+In practice the basic usage as described above is sufficient for most drivers.
+
+===============================================================================
+
+
+Accessing Control Values
+========================
+
+The v4l2_ctrl struct contains these two unions:
+
+	/* The current control value. */
+	union {
+		s32 val;
+		s64 val64;
+		char *string;
+	} cur;
+
+	/* The new control value. */
+	union {
+		s32 val;
+		s64 val64;
+		char *string;
+	};
+
+Within the control ops you can freely use these. The val and val64 speak for
+themselves. The string pointers point to character buffers of length
+ctrl->maximum + 1, and are always 0-terminated.
+
+For g_ctrl you have to update the current control values like this:
+
+	ctrl->cur.val = read_reg(0x123);
+
+The 'new value' union is not relevant in g_ctrl.
+
+For try/s_ctrl the new values (i.e. as passed by the user) are filled in and
+you can modify them in try_ctrl or set them in s_ctrl. The 'cur' union
+contains the current value, which you can use (but not change!) as well.
+
+If s_ctrl returns 0 (OK), then the control framework will copy the new final
+values to the 'cur' union.
+
+While in g/s/try_ctrl you can access the value of all controls owned by the
+same handler since the handler's lock is held. Do not attempt to access
+the value of controls owned by other handlers, though.
+
+Elsewhere in the driver you have to be more careful. You cannot just refer
+to the current control values without locking.
+
+There are two simple helper functions defined that will get or set a single
+control value safely:
+
+	s32 v4l2_ctrl_g(struct v4l2_ctrl *ctrl);
+	int v4l2_ctrl_s(struct v4l2_ctrl *ctrl, s32 val);
+
+Don't use these inside the control ops g/s/try_ctrl, though, that will fail.
+
+You can also take the handler lock yourself:
+
+	mutex_lock(&state->hdl.lock);
+	printk(KERN_INFO "String value is '%s'\n", ctrl1->cur.string);
+	printk(KERN_INFO "Integer value is '%s'\n", ctrl2->cur.val);
+	mutex_unlock(&state->hdl.lock);
+
+
+Menu Controls
+=============
+
+Menu controls use the 'step' value differently compared to other control
+types. The v4l2_ctrl struct contains this union:
+
+	union {
+		u32 step;
+		u32 menu_skip_mask;
+	};
+
+For menu controls menu_skip_mask is used. What it does is that it allows you
+to easily exclude certain menu items. This is used in the VIDIOC_QUERYMENU
+implementation where you can return -EINVAL if a certain menu item is not
+present. Note that VIDIOC_QUERYCTRL always returns a step value of 1 for
+menu controls.
+
+A good example is the MPEG Audio Layer II Bitrate menu control where the
+menu is a list of standardized possible bitrates. But in practice hardware
+implementations will only support a subset of those. By setting the skip
+mask you can tell the framework which menu items should be skipped. Setting
+it to 0 means that all menu items are supported.
+
+So when using v4l2_ctrl_new_std or v4l2_ctrl_new_custom you need to remember
+that 'step' means 'skip mask' for menu controls. If you put in '1' by mistake,
+then the first menu item will be skipped.
+
+The v4l2_ctrl_new_std_menu can be used to add menu controls more easily: it
+will calculate the min and max values automatically based on the size of the
+menu, and it has a proper 'mask' argument instead of 'step'.
+
+
+Active and Grabbed Controls
+===========================
+
+If you get more complex relationships between controls, then you may have to
+activate and deactivate controls. For example, if the Chroma AGC control is
+on, then the Chroma Gain control is inactive. That is, you may set it, but
+the value will not be used by the hardware as long as the automatic gain
+control is on. Typically user interfaces can disable such input fields.
+
+You can set the 'active' status using v4l2_ctrl_activate(). By default all
+controls are active. Note that the framework does not check for this flag.
+It is meant purely for GUIs. The function is typically called from within
+s_ctrl.
+
+The other flag is the grabbed flag. A grabbed control means that you cannot
+change it because it is in use by some resource. Typical examples are MPEG
+bitrate controls that cannot be changed while capturing is in progress.
+
+If a control is set to 'grabbed' using v4l2_ctrl_grab(), then the framework
+will return -EBUSY if an attempt is made to set this control.
+
+Since this flag is used by the framework the v4l2_ctrl_grab function will
+take the control handler's lock. So it cannot be called from within the
+control ops. Instead this is typically called from the driver when it
+starts streaming.
+
+
+Control Clusters
+================
+
+By default all controls are independent from the others. But in more
+complex scenarios you can get dependencies from one control to another.
+In that case you need to 'cluster' them:
+
+	struct foo {
+		struct v4l2_ctrl_handler hdl;
+		struct v4l2_ctrl *volume;
+		struct v4l2_ctrl *mute;
+		...
+	};
+
+	state->volume = v4l2_ctrl_new_std(&state->hdl, ...);
+	state->mute = v4l2_ctrl_new_std(&state->hdl, ...);
+	v4l2_ctrl_cluster(2, &state->volume);
+
+From now on whenever one or more of the controls belonging to the same
+cluster is set (or 'gotten', or 'tried'), only the control ops of the first
+control ('volume' in this example) is called. You effectively create a new
+composite control. Similar to how a 'struct' works in C.
+
+So when s_ctrl is called with V4L2_CID_AUDIO_VOLUME as argument, you should set
+all two controls belonging to the 'volume' cluster:
+
+	static int foo_s_ctrl(struct v4l2_ctrl *ctrl)
+	{
+		struct foo *state = container_of(ctrl->handler, struct foo, hdl);
+
+		switch (ctrl->id) {
+		case V4L2_CID_AUDIO_VOLUME:
+			/* volume cluster */
+			write_reg(0x123, state->mute->val ? 0 : ctrl->val);
+			break;
+		case V4L2_CID_CONTRAST:
+			write_reg(0x456, ctrl->val);
+			break;
+		}
+		return 0;
+	}
+
+In the example above the following are equivalent for the VOLUME case:
+
+	ctrl == state->volume == ctrl->cluster[0]
+	state->mute == ctrl->cluster[1]
+
+Note that controls in a cluster may be NULL. For example, if for some
+reason mute was never added (because the hardware doesn't support that
+particular feature), then mute will be NULL. So in that case we have a
+cluster of 2 controls, of which only 1 is actually instantiated. The
+only restriction is that the first control of the cluster must already be
+present, since that is the 'master' control of the cluster. The master
+control is the one that identifies the cluster and that provides the
+pointer to the v4l2_ctrl_ops struct that is used for that cluster.
+
+
+VIDIOC_LOG_STATUS Support
+=========================
+
+This ioctl allow you to dump the current status of a driver to the kernel log.
+The v4l2_ctrl_handler_log_status(hdl, prefix) can be used to dump the value of
+the controls owned by the given handler to the log. You can supply a prefix
+as well. If the prefix didn't end with a space, then ': ' will be added for
+you.
+
+
+Different Handlers for Different Video Nodes
+============================================
+
+Usually the bridge driver has just one control handler that is global for
+all video nodes. But you can also specify different control handlers for
+different video nodes. It's no problem if there are no subdevs involved.
+But if there are, then you need to block the automatic merging of subdev
+controls to the global control handler. You do that by simply setting the
+ctrl_handler field in struct v4l2_device to NULL.
+
+After each subdev was added, you will then have to call v4l2_ctrl_add_handler
+manually to add the subdev's control handler (sd->ctrl_handler) to the desired
+bridge control handler.
+
+If you want to have one handler (e.g. for a radio device node) have a subset
+of another handler (e.g. for a video device node), then you can first add
+the controls to the first handler, add the other controls to the second
+handler and finally add the first handler to the second. For example:
+
+	v4l2_ctrl_new_std(&radio_hdl, &radio_ops, V4L2_CID_AUDIO_VOLUME, ...);
+	v4l2_ctrl_new_std(&radio_hdl, &radio_ops, V4L2_CID_AUDIO_MUTE, ...);
+	v4l2_ctrl_new_std(&video_hdl, &video_ops, V4L2_CID_BRIGHTNESS, ...);
+	v4l2_ctrl_new_std(&video_hdl, &video_ops, V4L2_CID_CONTRAST, ...);
+	v4l2_ctrl_add_handler(&video_hdl, &radio_hdl);
+
+Or you can add specific controls to a handler:
+
+	volume = v4l2_ctrl_new_std(&video_hdl, &ops, V4L2_CID_AUDIO_VOLUME, ...);
+	v4l2_ctrl_new_std(&video_hdl, &ops, V4L2_CID_BRIGHTNESS, ...);
+	v4l2_ctrl_new_std(&video_hdl, &ops, V4L2_CID_CONTRAST, ...);
+	v4l2_ctrl_add_ctrl(&radio_hdl, volume);
+
+What you should not do is make two identical controls for two handlers.
+For example:
+
+	v4l2_ctrl_new_std(&radio_hdl, &radio_ops, V4L2_CID_AUDIO_MUTE, ...);
+	v4l2_ctrl_new_std(&video_hdl, &video_ops, V4L2_CID_AUDIO_MUTE, ...);
+
+This would be bad since muting the radio would not change the video mute
+control. The rule is to have one control for each hardware 'knob' that you
+can twiddle.
+
+
+Finding Controls
+================
+
+Normally you have created the controls yourself and you can store the struct
+v4l2_ctrl pointer into your own struct.
+
+But sometimes you need to find a control from another handler that you do
+not own. For example, if you have to find a volume control from a subdev.
+
+You can do that by calling v4l2_ctrl_find:
+
+	struct v4l2_ctrl *volume;
+
+	volume = v4l2_ctrl_find(sd->ctrl_handler, V4L2_CID_AUDIO_VOLUME);
+
+Since v4l2_ctrl_find will lock the handler you have to be careful where you
+use it. For example, this is not a good idea:
+
+	struct v4l2_ctrl_handler hdl;
+
+	v4l2_ctrl_new_std(&hdl, &video_ops, V4L2_CID_BRIGHTNESS, ...);
+	v4l2_ctrl_new_std(&hdl, &video_ops, V4L2_CID_CONTRAST, ...);
+
+...and in video_ops.s_ctrl:
+
+	case V4L2_CID_BRIGHTNESS:
+		contrast = v4l2_find_ctrl(&hdl, V4L2_CID_CONTRAST);
+		...
+
+When s_ctrl is called by the framework the hdl.lock is already taken, so
+attempting to find another control from the same handler will deadlock.
+
+It is recommended not to use this function from inside the control ops.
+
+
+Inheriting Controls
+===================
+
+When one control handler is added to another using v4l2_ctrl_add_handler, then
+by default all controls from one are merged to the other. But a subdev might
+have low-level controls that make sense for some advanced embedded system, but
+not when it is used in consumer-level hardware. In that case you want to keep
+those low-level controls local to the subdev. You can do this by simply
+setting the 'is_private' flag of the control to 1:
+
+	ctrl = v4l2_ctrl_new_custom(&sd->hdl, &sd_ctrl_ops, ...);
+	if (ctrl)
+		ctrl->is_private = 1;
+
+These controls will now be skipped when v4l2_ctrl_add_handler is called.
+
+
+Strict Control Validation
+=========================
+
+By default when the application wants to change an integer control the value
+passed to the framework will automatically be modified to map to the provided
+minimum, maximum and step values of the control. If instead you just want to
+validate the value and not modify it, then set the 'strict_validation' flag of
+the control:
+
+	ctrl->strict_validation = 1;
+
+Now -ERANGE will be returned if the new value does not match the control's
+requirements.
+
+This is currently specific to integer controls. The value for boolean controls
+is always mapped to 0 or 1, menu and string controls are already validated
+strictly, and integer64 controls are not validated at all.
+
+
+V4L2_CTRL_TYPE_CTRL_CLASS Controls
+==================================
+
+Controls of this type can be used by GUIs to get the name of the control class.
+A fully featured GUI can make a dialog with multiple tabs with each tab
+containing the controls belonging to a particular control class. The name of
+each tab can be found by querying a special control with ID <control class | 1>.
+
+Drivers do not have to care about this. The framework will automatically add
+a control of this type whenever the first control belonging to a new control
+class is added.
+
+
+Differences from the Spec
+=========================
+
+There are a few places where the framework acts slightly differently from the
+V4L2 Specification. Those differences are described in this section. We will
+have to see whether we need to adjust the spec or not.
+
+1) It is no longer required to have all controls contained in a
+v4l2_ext_control array be from the same control class. The framework will be
+able to handle any type of control in the array. You need to set ctrl_class
+to 0 in order to enable this. If ctrl_class is non-zero, then it will still
+check that all controls belong to that control class.
+
+If you set ctrl_class to 0 and count to 0, then it will only return an error
+if there are no controls at all.
+
+2) Clarified the way error_idx works. For get and set it will be equal to
+count if nothing was done yet. If it is less than count then only the controls
+up to error_idx-1 were successfully applied.
+
+3) When attempting to read a button control the framework will return -EACCES
+instead of -EINVAL as stated in the spec. It seems to make more sense since
+button controls are write-only controls.
+
+4) Attempting to write to a read-only control will return -EACCES instead of
+-EINVAL as the spec says.
+
+5) The spec does not mention what should happen when you try to set/get a
+control class controls. ivtv currently returns -EINVAL (indicating that the
+control ID does not exist) while the framework will return -EACCES, which
+makes more sense.
+
+
+Proposals for Extensions
+========================
+
+Some ideas for future extensions to the spec:
+
+1) Add a V4L2_CTRL_FLAG_HEX to have values shown as hexadecimal instead of
+decimal. Useful for e.g. video_mute_yuv.
+
+2) It is possible to mark in the controls array which controls have been
+successfully written and which failed by for example adding a bit to the
+control ID. Not sure if it is worth the effort, though.
-- 
1.6.4.2

