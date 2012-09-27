Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:60921 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab2I0WD4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 18:03:56 -0400
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 1/3] mt9v022: add v4l2 controls for blanking
Date: Fri, 28 Sep 2012 00:03:45 +0200
Message-Id: <1348783425-22934-1-git-send-email-agust@denx.de>
In-Reply-To: <1345799431-29426-2-git-send-email-agust@denx.de>
References: <1345799431-29426-2-git-send-email-agust@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add controls for horizontal and vertical blanking. Also add an error
message for case that the control handler init failed. Since setting
the blanking registers is done by controls now, we shouldn't change
these registers outside of the control function. Use v4l2_ctrl_s_ctrl()
to set them.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
Changes since first version:
 - drop analog and reg32 setting controls
 - use more descriptive error message for handler init error
 - revise commit log
 - rebase on staging/for_v3.7 branch

 drivers/media/i2c/soc_camera/mt9v022.c |   49 +++++++++++++++++++++++++++++--
 1 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index 350d0d8..3cb23c6 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -71,6 +71,13 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
 #define MT9V022_COLUMN_SKIP		1
 #define MT9V022_ROW_SKIP		4
 
+#define MT9V022_HORIZONTAL_BLANKING_MIN	43
+#define MT9V022_HORIZONTAL_BLANKING_MAX	1023
+#define MT9V022_HORIZONTAL_BLANKING_DEF	94
+#define MT9V022_VERTICAL_BLANKING_MIN	2
+#define MT9V022_VERTICAL_BLANKING_MAX	3000
+#define MT9V022_VERTICAL_BLANKING_DEF	45
+
 #define is_mt9v024(id) (id == 0x1324)
 
 /* MT9V022 has only one fixed colorspace per pixelcode */
@@ -136,6 +143,8 @@ struct mt9v022 {
 		struct v4l2_ctrl *autogain;
 		struct v4l2_ctrl *gain;
 	};
+	struct v4l2_ctrl *hblank;
+	struct v4l2_ctrl *vblank;
 	struct v4l2_rect rect;	/* Sensor window */
 	const struct mt9v022_datafmt *fmt;
 	const struct mt9v022_datafmt *fmts;
@@ -277,11 +286,10 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 		 * Default 94, Phytec driver says:
 		 * "width + horizontal blank >= 660"
 		 */
-		ret = reg_write(client, MT9V022_HORIZONTAL_BLANKING,
-				rect.width > 660 - 43 ? 43 :
-				660 - rect.width);
+		ret = v4l2_ctrl_s_ctrl(mt9v022->hblank,
+				rect.width > 660 - 43 ? 43 : 660 - rect.width);
 	if (!ret)
-		ret = reg_write(client, MT9V022_VERTICAL_BLANKING, 45);
+		ret = v4l2_ctrl_s_ctrl(mt9v022->vblank, 45);
 	if (!ret)
 		ret = reg_write(client, MT9V022_WINDOW_WIDTH, rect.width);
 	if (!ret)
@@ -504,6 +512,18 @@ static int mt9v022_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 		range = exp->maximum - exp->minimum;
 		exp->val = ((data - 1) * range + 239) / 479 + exp->minimum;
 		return 0;
+	case V4L2_CID_HBLANK:
+		data = reg_read(client, MT9V022_HORIZONTAL_BLANKING);
+		if (data < 0)
+			return -EIO;
+		ctrl->val = data;
+		return 0;
+	case V4L2_CID_VBLANK:
+		data = reg_read(client, MT9V022_VERTICAL_BLANKING);
+		if (data < 0)
+			return -EIO;
+		ctrl->val = data;
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -585,6 +605,16 @@ static int mt9v022_s_ctrl(struct v4l2_ctrl *ctrl)
 				return -EIO;
 		}
 		return 0;
+	case V4L2_CID_HBLANK:
+		if (reg_write(client, MT9V022_HORIZONTAL_BLANKING,
+				ctrl->val) < 0)
+			return -EIO;
+		return 0;
+	case V4L2_CID_VBLANK:
+		if (reg_write(client, MT9V022_VERTICAL_BLANKING,
+				ctrl->val) < 0)
+			return -EIO;
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -852,10 +882,21 @@ static int mt9v022_probe(struct i2c_client *client,
 	mt9v022->exposure = v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
 			V4L2_CID_EXPOSURE, 1, 255, 1, 255);
 
+	mt9v022->hblank = v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
+			V4L2_CID_HBLANK, MT9V022_HORIZONTAL_BLANKING_MIN,
+			MT9V022_HORIZONTAL_BLANKING_MAX, 1,
+			MT9V022_HORIZONTAL_BLANKING_DEF);
+
+	mt9v022->vblank = v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
+			V4L2_CID_VBLANK, MT9V022_VERTICAL_BLANKING_MIN,
+			MT9V022_VERTICAL_BLANKING_MAX, 1,
+			MT9V022_VERTICAL_BLANKING_DEF);
+
 	mt9v022->subdev.ctrl_handler = &mt9v022->hdl;
 	if (mt9v022->hdl.error) {
 		int err = mt9v022->hdl.error;
 
+		dev_err(&client->dev, "control initialisation err %d\n", err);
 		kfree(mt9v022);
 		return err;
 	}
-- 
1.7.1

