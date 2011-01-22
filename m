Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4457 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab1AVLGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 06:06:22 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id p0MB69ib074561
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 22 Jan 2011 12:06:21 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 3/3] v4l2-ctrls: update control framework documentation
Date: Sat, 22 Jan 2011 12:06:01 +0100
Message-Id: <ebb5547e48e2d7e6e620d7218c6543d6dc7b06b1.1295693790.git.hverkuil@xs4all.nl>
In-Reply-To: <1295694361-23237-1-git-send-email-hverkuil@xs4all.nl>
References: <1295694361-23237-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <828e9980aa0934596a85e5a1b83c0bdd52ecc9d0.1295693790.git.hverkuil@xs4all.nl>
References: <828e9980aa0934596a85e5a1b83c0bdd52ecc9d0.1295693790.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Document how to enable/disable controls.
Document the new v4l2_ctrl_auto_cluster function.
Document the practical method of using anonymous structs to 'cluster'
controls instead of using cumbersome control pointer arrays.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 Documentation/video4linux/v4l2-controls.txt |   94 +++++++++++++++++++++++++++
 1 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 881e7f4..78b6674 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -453,6 +453,25 @@ In the example above the following are equivalent for the VOLUME case:
 	ctrl == ctrl->cluster[AUDIO_CL_VOLUME] == state->audio_cluster[AUDIO_CL_VOLUME]
 	ctrl->cluster[AUDIO_CL_MUTE] == state->audio_cluster[AUDIO_CL_MUTE]
 
+In practice using cluster arrays like this becomes very tiresome. So instead
+the following equivalent method is used:
+
+	struct {
+		/* audio cluster */
+		struct v4l2_ctrl *volume;
+		struct v4l2_ctrl *mute;
+	};
+
+The anonymous struct is used to clearly 'cluster' these two control pointers,
+but it serves no other purpose. The effect is the same as creating an
+array with two control pointers. So you can just do:
+
+	state->volume = v4l2_ctrl_new_std(&state->ctrl_handler, ...);
+	state->mute = v4l2_ctrl_new_std(&state->ctrl_handler, ...);
+	v4l2_ctrl_cluster(2, &state->volume);
+
+And in foo_s_ctrl you can use these pointers directly: state->mute->val.
+
 Note that controls in a cluster may be NULL. For example, if for some
 reason mute was never added (because the hardware doesn't support that
 particular feature), then mute will be NULL. So in that case we have a
@@ -475,6 +494,55 @@ controls, then the 'is_new' flag would be 1 for both controls.
 The 'is_new' flag is always 1 when called from v4l2_ctrl_handler_setup().
 
 
+Handling autogain/gain-type Controls with Auto Clusters
+=======================================================
+
+A common type of control cluster is one that handles 'auto-foo/foo'-type
+controls. Typical examples are autogain/gain, autoexposure/exposure,
+autowhitebalance/red balance/blue balance. In all cases you have one controls
+that determines whether another control is handled automatically by the hardware,
+or whether it is under manual control from the user.
+
+The way these are supposed to be handled is that if you set one of the 'foo'
+controls, then the 'auto-foo' control should automatically switch to manual
+mode, except when you set the 'auto-foo' control at the same time, in which
+case it will depend on the new 'auto-foo' setting whether the new 'foo' value
+is actually ignored or set in the hardware.
+
+The reasoning is that if you explicitly set a manual control, then it makes
+sense to assume that you want to switch to manual mode as well. Whereas if you
+set both the auto and manual control at the same time, then you should follow
+whatever the new value for the auto control is.
+
+Usually the 'foo' control is also volatile, since if the automatic mode is
+enabled, then the reported value for 'foo' is the value that the automatic
+mode has determined is the best at that given time. However, if manual mode
+is selected, then it is just the last stored value. So g_volatile_ctrl should
+only be called when we are in automatic mode.
+
+Finally the V4L2_CTRL_FLAG_UPDATE should also be set for the non-auto controls
+since changing one of them might affect the auto control.
+
+In order to simplify this a special variation of v4l2_ctrl_cluster was
+introduced:
+
+void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
+			u8 manual_val, bool set_volatile);
+
+The first two arguments are identical to v4l2_ctrl_cluster. The third argument
+tells the framework which value switches the cluster into manual mode. The
+last argument will optionally set is_volatile flag for the non-auto controls.
+
+The first control of the cluster is assumed to be the 'auto' control.
+
+Using this function will ensure that:
+
+- the right flags are set.
+- when a 'foo' control is set explicitly the 'auto-foo' control is set to
+  the manual mode before s_ctrl is called.
+- g_volatile_ctrl is never called when in manual mode.
+
+
 VIDIOC_LOG_STATUS Support
 =========================
 
@@ -535,6 +603,32 @@ control. The rule is to have one control for each hardware 'knob' that you
 can twiddle.
 
 
+Different Handlers for Different Inputs/Outputs
+===============================================
+
+Sometimes the available controls will change depending on which input or output
+was chosen. This can happen if input 0 handles SDTV and is hooked up to a SDTV
+video receiver and if input 1 handles HDTV and is hooked up to a HDTV receiver.
+
+Each will typically have their own controls. Which means that in this case
+changing inputs or outputs requires some work. To make this easy it is possible
+to enable or disable specific controls or all controls from one control handler:
+
+void v4l2_ctrl_enable(struct v4l2_ctrl *ctrl, bool enabled);
+void v4l2_ctrl_handler_enable(struct v4l2_ctrl_handler *hdl, bool enabled);
+
+So in this scenario you would typically disable the control handler of the
+inputs that are not in use and enable the control handler of the active input.
+
+For example, if the user selects input 1, then the driver should do something
+like this:
+
+	v4l2_ctrl_handler_enable(sdtv_subdev->ctrl_handler, false);
+	v4l2_ctrl_handler_enable(hdtv_subdev->ctrl_handler, true);
+
+By default all controls are enabled when they are first created.
+
+
 Finding Controls
 ================
 
-- 
1.7.0.4

