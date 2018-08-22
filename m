Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35731 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbeHVEp2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 00:45:28 -0400
From: Guilherme Gallo <gagallo7@gmail.com>
To: lkcamp@lists.libreplanetbr.org, helen.koike@collabora.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, hverkuil@xs4all.nl
Subject: [PATCH] media: vimc: implement basic v4l2-ctrls
Date: Tue, 21 Aug 2018 22:22:19 -0300
Message-Id: <20180822012219.22946-1-gagallo7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement brightness, contrast and hue controls in vimc-sensor

Signed-off-by: Guilherme Alcarde Gallo <gagallo7@gmail.com>
---
 drivers/media/platform/vimc/vimc-sensor.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 605e2a2d5dd5..ecc82cd60900 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -316,6 +316,15 @@ static int vimc_sen_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_VFLIP:
 		tpg_s_vflip(&vsen->tpg, ctrl->val);
 		break;
+	case V4L2_CID_BRIGHTNESS:
+		tpg_s_brightness(&vsen->tpg, ctrl->val);
+		break;
+	case V4L2_CID_CONTRAST:
+		tpg_s_contrast(&vsen->tpg, ctrl->val);
+		break;
+	case V4L2_CID_HUE:
+		tpg_s_hue(&vsen->tpg, ctrl->val);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -377,6 +386,12 @@ static int vimc_sen_comp_bind(struct device *comp, struct device *master,
 			  V4L2_CID_VFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
 			  V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
+			  V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
+			  V4L2_CID_CONTRAST, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
+			  V4L2_CID_HUE, 0, 255, 1, 128);
 	vsen->sd.ctrl_handler = &vsen->hdl;
 	if (vsen->hdl.error) {
 		ret = vsen->hdl.error;
-- 
2.13.6
