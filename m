Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39692 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbeIDGJC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2018 02:09:02 -0400
From: Guilherme Gallo <gagallo7@gmail.com>
To: hverkuil@xs4all.nl, Helen Koike <helen.koike@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: lkcamp@lists.libreplanetbr.org
Subject: [PATCH v2] media: vimc: implement basic v4l2-ctrls
Date: Mon,  3 Sep 2018 22:45:59 -0300
Message-Id: <20180904014559.15765-1-gagallo7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add brightness, contrast, hue and saturation controls in vimc-sensor

Signed-off-by: Guilherme Alcarde Gallo <gagallo7@gmail.com>
Signed-off-by: Guilherme Gallo <gagallo7@gmail.com>
---
 drivers/media/platform/vimc/vimc-sensor.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index b2b89315e7ba..edf4c85ae63d 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -317,6 +317,18 @@ static int vimc_sen_s_ctrl(struct v4l2_ctrl *ctrl)
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
+	case V4L2_CID_SATURATION:
+		tpg_s_saturation(&vsen->tpg, ctrl->val);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -378,6 +390,14 @@ static int vimc_sen_comp_bind(struct device *comp, struct device *master,
 			  V4L2_CID_VFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
 			  V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
+			  V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
+			  V4L2_CID_CONTRAST, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
+			  V4L2_CID_HUE, -128, 127, 1, 0);
+	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
+			  V4L2_CID_SATURATION, 0, 255, 1, 128);
 	vsen->sd.ctrl_handler = &vsen->hdl;
 	if (vsen->hdl.error) {
 		ret = vsen->hdl.error;
-- 
2.13.6

Changes in v2:
- Added brightness, hue and saturation controls.
- Fixed the standard values for hue control.
