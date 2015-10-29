Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:36469 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853AbbJ2E7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 00:59:46 -0400
Received: from [10.35.130.50] (unknown [58.123.138.205])
	by tschai.lan (Postfix) with ESMTPSA id 1BF792A03F3
	for <linux-media@vger.kernel.org>; Thu, 29 Oct 2015 05:57:26 +0100 (CET)
To: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: fix compliance error
Message-ID: <5631A7B9.2080409@xs4all.nl>
Date: Thu, 29 Oct 2015 13:59:37 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If vivid is loaded with the no_error_inj=1 option, then v4l2-compliance will
fail for the video and vbi output nodes because the vivid control class has no
controls.

Don't add the control class for video and vbi output if no_error_inj is true.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index f41ac0b..ae88afc0 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -1340,11 +1340,13 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 	v4l2_ctrl_handler_init(hdl_vid_cap, 55);
 	v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_vid_out, 26);
-	v4l2_ctrl_new_custom(hdl_vid_out, &vivid_ctrl_class, NULL);
+	if (!no_error_inj)
+		v4l2_ctrl_new_custom(hdl_vid_out, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_vbi_cap, 21);
 	v4l2_ctrl_new_custom(hdl_vbi_cap, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_vbi_out, 19);
-	v4l2_ctrl_new_custom(hdl_vbi_out, &vivid_ctrl_class, NULL);
+	if (!no_error_inj)
+		v4l2_ctrl_new_custom(hdl_vbi_out, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_radio_rx, 17);
 	v4l2_ctrl_new_custom(hdl_radio_rx, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_radio_tx, 17);
