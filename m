Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51387 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab2IWT3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 15:29:07 -0400
Received: by mail-we0-f174.google.com with SMTP id x8so2978759wey.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 12:29:07 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: g.liakhovetski@gmx.de
Cc: maramaopercheseimorto@gmail.com, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 3/3] ov2640: simplify single register writes
Date: Sun, 23 Sep 2012 21:28:46 +0300
Message-Id: <1348424926-12864-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1348424926-12864-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1348424926-12864-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/i2c/soc_camera/ov2640.c |   17 ++++++++---------
 1 Datei geändert, 8 Zeilen hinzugefügt(+), 9 Zeilen entfernt(-)

diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 182d5a1..e71bf4c 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -639,17 +639,19 @@ static struct ov2640_priv *to_ov2640(const struct i2c_client *client)
 			    subdev);
 }
 
+static int ov2640_write_single(struct i2c_client *client, u8  reg, u8 val)
+{
+	dev_vdbg(&client->dev, "write: 0x%02x, 0x%02x", reg, val);
+	return i2c_smbus_write_byte_data(client, reg, val);
+}
+
 static int ov2640_write_array(struct i2c_client *client,
 			      const struct regval_list *vals)
 {
 	int ret;
 
 	while ((vals->reg_num != 0xff) || (vals->value != 0xff)) {
-		ret = i2c_smbus_write_byte_data(client,
-						vals->reg_num, vals->value);
-		dev_vdbg(&client->dev, "array: 0x%02x, 0x%02x",
-			 vals->reg_num, vals->value);
-
+		ret = ov2640_write_single(client, vals->reg_num, vals->value);
 		if (ret < 0)
 			return ret;
 		vals++;
@@ -704,13 +706,10 @@ static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct v4l2_subdev *sd =
 		&container_of(ctrl->handler, struct ov2640_priv, hdl)->subdev;
 	struct i2c_client  *client = v4l2_get_subdevdata(sd);
-	struct regval_list regval;
 	int ret;
 	u8 val;
 
-	regval.reg_num = BANK_SEL;
-	regval.value = BANK_SEL_SENS;
-	ret = ov2640_write_array(client, &regval);
+	ret = ov2640_write_single(client, BANK_SEL, BANK_SEL_SENS);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.10.4

