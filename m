Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3226 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab1E0O6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 10:58:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 2/5] v4l2-controls.txt: update to latest v4l2-ctrl.c changes.
Date: Fri, 27 May 2011 16:57:52 +0200
Message-Id: <29e131f3a44d9c1a875fad8309cce6be4ed13365.1306507763.git.hans.verkuil@cisco.com>
In-Reply-To: <1306508275-9228-1-git-send-email-hverkuil@xs4all.nl>
References: <1306508275-9228-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <287bab4f54ddce64458a69e0407d5866158fda0a.1306507763.git.hans.verkuil@cisco.com>
References: <287bab4f54ddce64458a69e0407d5866158fda0a.1306507763.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-controls.txt |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index bc24be4..65d4652 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -277,16 +277,13 @@ implement g_volatile_ctrl like this:
 	{
 		switch (ctrl->id) {
 		case V4L2_CID_BRIGHTNESS:
-			ctrl->cur.val = read_reg(0x123);
+			ctrl->val = read_reg(0x123);
 			break;
 		}
 	}
 
-The 'new value' union is not used in g_volatile_ctrl. In general controls
-that need to implement g_volatile_ctrl are read-only controls.
-
-Note that if one or more controls in a control cluster are marked as volatile,
-then all the controls in the cluster are seen as volatile.
+Note that you use the 'new value' union as well in g_volatile_ctrl. In general
+controls that need to implement g_volatile_ctrl are read-only controls.
 
 To mark a control as volatile you have to set the is_volatile flag:
 
@@ -638,9 +635,7 @@ button controls are write-only controls.
 -EINVAL as the spec says.
 
 5) The spec does not mention what should happen when you try to set/get a
-control class controls. ivtv currently returns -EINVAL (indicating that the
-control ID does not exist) while the framework will return -EACCES, which
-makes more sense.
+control class controls. The framework will return -EACCES.
 
 
 Proposals for Extensions
-- 
1.7.1

