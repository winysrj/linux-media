Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50878 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaEZWqy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 18:46:54 -0400
Received: from avalon.ideasonboard.com (30.141-246-81.adsl-dyn.isp.belgacom.be [81.246.141.30])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id CF74835A00
	for <linux-media@vger.kernel.org>; Tue, 27 May 2014 00:46:42 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: vsp1: sru: Handle control handler initialization errors
Date: Tue, 27 May 2014 00:46:49 +0200
Message-Id: <1401144409-13217-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bail out when the SRU control handler fails to initialize.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_sru.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index aa0e04c..79efcaf 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -348,6 +348,14 @@ struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
 	/* Initialize the control handler. */
 	v4l2_ctrl_handler_init(&sru->ctrls, 1);
 	v4l2_ctrl_new_custom(&sru->ctrls, &sru_intensity_control, NULL);
+
+	if (sru->ctrls.error) {
+		dev_err(vsp1->dev, "sru: failed to initialize controls\n");
+		ret = sru->ctrls.error;
+		v4l2_ctrl_handler_free(&sru->ctrls);
+		return ERR_PTR(ret);
+	}
+
 	v4l2_ctrl_handler_setup(&sru->ctrls);
 	sru->entity.subdev.ctrl_handler = &sru->ctrls;
 
-- 
Regards,

Laurent Pinchart

