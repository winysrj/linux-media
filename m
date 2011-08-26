Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3462 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1HZMAa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 08:00:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 4/8] v4l2-controls.txt: update auto cluster documentation.
Date: Fri, 26 Aug 2011 14:00:09 +0200
Message-Id: <9f2781604a65ec30fdcf16e34be824e8b0e8c0ac.1314359706.git.hans.verkuil@cisco.com>
In-Reply-To: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
References: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c30383666acc85a530fba5b1a14189670dfb8bb3.1314359706.git.hans.verkuil@cisco.com>
References: <c30383666acc85a530fba5b1a14189670dfb8bb3.1314359706.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-controls.txt |   34 +++++++++-----------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index f92ee30..26aa057 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -495,18 +495,20 @@ Handling autogain/gain-type Controls with Auto Clusters
 
 A common type of control cluster is one that handles 'auto-foo/foo'-type
 controls. Typical examples are autogain/gain, autoexposure/exposure,
-autowhitebalance/red balance/blue balance. In all cases you have one controls
+autowhitebalance/red balance/blue balance. In all cases you have one control
 that determines whether another control is handled automatically by the hardware,
 or whether it is under manual control from the user.
 
 If the cluster is in automatic mode, then the manual controls should be
-marked inactive. When the volatile controls are read the g_volatile_ctrl
-operation should return the value that the hardware's automatic mode set up
-automatically.
+marked inactive and volatile. When the volatile controls are read the
+g_volatile_ctrl operation should return the value that the hardware's automatic
+mode set up automatically.
 
 If the cluster is put in manual mode, then the manual controls should become
-active again and V4L2_CTRL_FLAG_VOLATILE should be ignored (so g_volatile_ctrl
-is no longer called while in manual mode).
+active again and the volatile flag is cleared (so g_volatile_ctrl is no longer
+called while in manual mode). In addition just before switching to manual mode
+the current values as determined by the auto mode are copied as the new manual
+values.
 
 Finally the V4L2_CTRL_FLAG_UPDATE should be set for the auto control since
 changing that control affects the control flags of the manual controls.
@@ -520,6 +522,10 @@ void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
 The first two arguments are identical to v4l2_ctrl_cluster. The third argument
 tells the framework which value switches the cluster into manual mode. The
 last argument will optionally set V4L2_CTRL_FLAG_VOLATILE for the non-auto controls.
+If it is false, then the manual controls are never volatile. You would typically
+use that if the hardware does not give you the option to read back to values as
+determined by the auto mode (e.g. if autogain is on, the hardware doesn't allow
+you to obtain the current gain value).
 
 The first control of the cluster is assumed to be the 'auto' control.
 
@@ -680,16 +686,6 @@ if there are no controls at all.
 count if nothing was done yet. If it is less than count then only the controls
 up to error_idx-1 were successfully applied.
 
-3) When attempting to read a button control the framework will return -EACCES
-instead of -EINVAL as stated in the spec. It seems to make more sense since
-button controls are write-only controls.
-
-4) Attempting to write to a read-only control will return -EACCES instead of
--EINVAL as the spec says.
-
-5) The spec does not mention what should happen when you try to set/get a
-control class controls. The framework will return -EACCES.
-
 
 Proposals for Extensions
 ========================
@@ -702,9 +698,3 @@ decimal. Useful for e.g. video_mute_yuv.
 2) It is possible to mark in the controls array which controls have been
 successfully written and which failed by for example adding a bit to the
 control ID. Not sure if it is worth the effort, though.
-
-3) Trying to set volatile inactive controls should result in -EACCESS.
-
-4) Add a new flag to mark volatile controls. Any application that wants
-to store the state of the controls can then skip volatile inactive controls.
-Currently it is not possible to detect such controls.
-- 
1.7.5.4

