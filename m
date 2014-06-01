Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59654 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200AbaFADj1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 May 2014 23:39:27 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 09/18] v4l: vsp1: sru: Fix the intensity control default value
Date: Sun,  1 Jun 2014 05:39:28 +0200
Message-Id: <1401593977-30660-10-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The default value isn't set and defaults to 0, which isn't in the 1-6
min-max range. Fix it by setting the default value to 1.

This shoud have been caught when checking the control handler error
field at initialization time, but the check was missing. Add it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_sru.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index aa0e04c..18e127a 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -67,6 +67,7 @@ static const struct v4l2_ctrl_config sru_intensity_control = {
 	.type = V4L2_CTRL_TYPE_INTEGER,
 	.min = 1,
 	.max = 6,
+	.def = 1,
 	.step = 1,
 };
 
@@ -348,8 +349,17 @@ struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
 	/* Initialize the control handler. */
 	v4l2_ctrl_handler_init(&sru->ctrls, 1);
 	v4l2_ctrl_new_custom(&sru->ctrls, &sru_intensity_control, NULL);
-	v4l2_ctrl_handler_setup(&sru->ctrls);
+
 	sru->entity.subdev.ctrl_handler = &sru->ctrls;
 
+	if (sru->ctrls.error) {
+		dev_err(vsp1->dev, "sru: failed to initialize controls\n");
+		ret = sru->ctrls.error;
+		vsp1_entity_destroy(&sru->entity);
+		return ERR_PTR(ret);
+	}
+
+	v4l2_ctrl_handler_setup(&sru->ctrls);
+
 	return sru;
 }
-- 
1.8.5.5

