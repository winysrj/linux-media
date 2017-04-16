Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36590 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756567AbdDPRgF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 13:36:05 -0400
Received: by mail-wr0-f194.google.com with SMTP id o21so18012488wrb.3
        for <linux-media@vger.kernel.org>; Sun, 16 Apr 2017 10:36:05 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: guennadi.liakhovetski@intel.com, hans.verkuil@cisco.com,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 7/7] ov2640: add support for MEDIA_BUS_FMT_YVYU8_2X8 and MEDIA_BUS_FMT_VYUY8_2X8
Date: Sun, 16 Apr 2017 19:35:46 +0200
Message-Id: <20170416173546.4317-8-fschaefer.oss@googlemail.com>
In-Reply-To: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
References: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/i2c/ov2640.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 6aba0ffe486d..618230e782e7 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -634,6 +634,8 @@ static const struct regval_list ov2640_rgb565_le_regs[] = {
 static u32 ov2640_codes[] = {
 	MEDIA_BUS_FMT_YUYV8_2X8,
 	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_YVYU8_2X8,
+	MEDIA_BUS_FMT_VYUY8_2X8,
 	MEDIA_BUS_FMT_RGB565_2X8_BE,
 	MEDIA_BUS_FMT_RGB565_2X8_LE,
 };
@@ -795,6 +797,7 @@ static int ov2640_set_params(struct i2c_client *client,
 {
 	struct ov2640_priv       *priv = to_ov2640(client);
 	const struct regval_list *selected_cfmt_regs;
+	u8 val;
 	int ret;
 
 	/* select win */
@@ -820,6 +823,14 @@ static int ov2640_set_params(struct i2c_client *client,
 		dev_dbg(&client->dev, "%s: Selected cfmt UYVY", __func__);
 		selected_cfmt_regs = ov2640_uyvy_regs;
 		break;
+	case MEDIA_BUS_FMT_YVYU8_2X8:
+		dev_dbg(&client->dev, "%s: Selected cfmt YVYU", __func__);
+		selected_cfmt_regs = ov2640_yuyv_regs;
+		break;
+	case MEDIA_BUS_FMT_VYUY8_2X8:
+		dev_dbg(&client->dev, "%s: Selected cfmt VYUY", __func__);
+		selected_cfmt_regs = ov2640_uyvy_regs;
+		break;
 	}
 
 	/* reset hardware */
@@ -852,6 +863,11 @@ static int ov2640_set_params(struct i2c_client *client,
 	ret = ov2640_write_array(client, selected_cfmt_regs);
 	if (ret < 0)
 		goto err;
+	val = (code == MEDIA_BUS_FMT_YVYU8_2X8)
+	      || (code == MEDIA_BUS_FMT_VYUY8_2X8) ? CTRL0_VFIRST : 0x00;
+	ret = ov2640_mask_set(client, CTRL0, CTRL0_VFIRST, val);
+	if (ret < 0)
+		goto err;
 
 	priv->cfmt_code = code;
 
@@ -914,6 +930,8 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
 	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 	case MEDIA_BUS_FMT_YUYV8_2X8:
 	case MEDIA_BUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_YVYU8_2X8:
+	case MEDIA_BUS_FMT_VYUY8_2X8:
 		break;
 	default:
 		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
-- 
2.12.2
