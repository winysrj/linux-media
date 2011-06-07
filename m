Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3275 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab1FGPFb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 11:05:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 03/18] v4l2-ctrls: drivers should be able to ignore the READ_ONLY flag
Date: Tue,  7 Jun 2011 17:05:08 +0200
Message-Id: <b38ec028df729d2f72f5da3edc7fa058f3ca7924.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
References: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

When applications try to set READ_ONLY controls an error should
be returned. However, when drivers do that it should be accepted.

Those controls could reflect some driver status which the application
can't change but the driver obviously has to be able to change it.

This is needed among others for future HDMI status controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index d9e0439..0b1b30f 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1826,9 +1826,6 @@ static int set_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
 	int ret;
 	int i;
 
-	if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
-		return -EACCES;
-
 	v4l2_ctrl_lock(ctrl);
 
 	/* Reset the 'is_new' flags of the cluster */
@@ -1853,6 +1850,9 @@ int v4l2_s_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *control)
 	if (ctrl == NULL || !type_is_int(ctrl))
 		return -EINVAL;
 
+	if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
+		return -EACCES;
+
 	return set_ctrl(ctrl, &control->value);
 }
 EXPORT_SYMBOL(v4l2_s_ctrl);
-- 
1.7.1

