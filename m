Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3467 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab1FGPFe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 11:05:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 07/18] v4l2-controls.txt: update to latest v4l2-ctrl.c changes.
Date: Tue,  7 Jun 2011 17:05:12 +0200
Message-Id: <356649ff805124b91220e313cfe4975804d73afc.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
References: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-controls.txt |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 881e7f4..95a3813 100644
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
 
@@ -636,9 +633,7 @@ button controls are write-only controls.
 -EINVAL as the spec says.
 
 5) The spec does not mention what should happen when you try to set/get a
-control class controls. ivtv currently returns -EINVAL (indicating that the
-control ID does not exist) while the framework will return -EACCES, which
-makes more sense.
+control class controls. The framework will return -EACCES.
 
 
 Proposals for Extensions
-- 
1.7.1

