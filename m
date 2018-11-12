Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40689 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbeKMBzK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 20:55:10 -0500
Received: by mail-pl1-f195.google.com with SMTP id q19-v6so4544623pll.7
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 08:01:19 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 3/7] media: ov2640: add V4L2_CID_TEST_PATTERN control
Date: Tue, 13 Nov 2018 01:00:50 +0900
Message-Id: <1542038454-20066-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
References: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov2640 has the test pattern generator features.  This makes use of
it through V4L2_CID_TEST_PATTERN control.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov2640.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 20a8853..4992d77 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -705,6 +705,11 @@ static int ov2640_reset(struct i2c_client *client)
 	return ret;
 }
 
+static const char * const ov2640_test_pattern_menu[] = {
+	"Disabled",
+	"Color bar",
+};
+
 /*
  * functions
  */
@@ -740,6 +745,9 @@ static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_HFLIP:
 		val = ctrl->val ? REG04_HFLIP_IMG : 0x00;
 		return ov2640_mask_set(client, REG04, REG04_HFLIP_IMG, val);
+	case V4L2_CID_TEST_PATTERN:
+		val = ctrl->val ? COM7_COLOR_BAR_TEST : 0x00;
+		return ov2640_mask_set(client, COM7, COM7_COLOR_BAR_TEST, val);
 	}
 
 	return -EINVAL;
@@ -1184,12 +1192,16 @@ static int ov2640_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
 	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	mutex_init(&priv->lock);
-	v4l2_ctrl_handler_init(&priv->hdl, 2);
+	v4l2_ctrl_handler_init(&priv->hdl, 3);
 	priv->hdl.lock = &priv->lock;
 	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
 			V4L2_CID_VFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
 			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std_menu_items(&priv->hdl, &ov2640_ctrl_ops,
+			V4L2_CID_TEST_PATTERN,
+			ARRAY_SIZE(ov2640_test_pattern_menu) - 1, 0, 0,
+			ov2640_test_pattern_menu);
 	priv->subdev.ctrl_handler = &priv->hdl;
 	if (priv->hdl.error) {
 		ret = priv->hdl.error;
-- 
2.7.4
