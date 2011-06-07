Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2406 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab1FGPFf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 11:05:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 09/18] DocBook: Improve cluster documentation and document the new autoclusters.
Date: Tue,  7 Jun 2011 17:05:14 +0200
Message-Id: <2edabc864571f91a44a12bb6c8b136efb777eb12.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
References: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-controls.txt |   56 +++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 95a3813..9346fc8 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -450,6 +450,25 @@ In the example above the following are equivalent for the VOLUME case:
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
@@ -472,6 +491,43 @@ controls, then the 'is_new' flag would be 1 for both controls.
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
+If the cluster is in automatic mode, then the manual controls should be
+marked inactive. When the volatile controls are read the g_volatile_ctrl
+operation should return the value that the hardware's automatic mode set up
+automatically.
+
+If the cluster is put in manual mode, then the manual controls should become
+active again and the is_volatile flag should be ignored (so g_volatile_ctrl is
+no longer called while in manual mode).
+
+Finally the V4L2_CTRL_FLAG_UPDATE should be set for the auto control since
+changing that control affects the control flags of the manual controls.
+
+In order to simplify this a special variation of v4l2_ctrl_cluster was
+introduced:
+
+void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
+			u8 manual_val, bool set_volatile);
+
+The first two arguments are identical to v4l2_ctrl_cluster. The third argument
+tells the framework which value switches the cluster into manual mode. The
+last argument will optionally set the is_volatile flag for the non-auto controls.
+
+The first control of the cluster is assumed to be the 'auto' control.
+
+Using this function will ensure that you don't need to handle all the complex
+flag and volatile handling.
+
+
 VIDIOC_LOG_STATUS Support
 =========================
 
-- 
1.7.1

