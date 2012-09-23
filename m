Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51387 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab2IWT3E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 15:29:04 -0400
Received: by weyx8 with SMTP id x8so2978759wey.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 12:29:03 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: g.liakhovetski@gmx.de
Cc: maramaopercheseimorto@gmail.com, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 1/3] ov2640: select sensor register bank before applying h/v-flip settings
Date: Sun, 23 Sep 2012 21:28:44 +0300
Message-Id: <1348424926-12864-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We currently don't select the register bank in ov2640_s_ctrl, so we can end up
writing to DSP register 0x04 instead of sensor register 0x04.
This happens for example when calling ov2640_s_ctrl after ov2640_s_fmt.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Cc: stable@kernel.org
---
 drivers/media/i2c/soc_camera/ov2640.c |    8 ++++++++
 1 Datei geändert, 8 Zeilen hinzugefügt(+)

diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 78ac574..e4fc79e 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -683,8 +683,16 @@ static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct v4l2_subdev *sd =
 		&container_of(ctrl->handler, struct ov2640_priv, hdl)->subdev;
 	struct i2c_client  *client = v4l2_get_subdevdata(sd);
+	struct regval_list regval;
+	int ret;
 	u8 val;
 
+	regval.reg_num = BANK_SEL;
+	regval.value = BANK_SEL_SENS;
+	ret = ov2640_write_array(client, &regval);
+	if (ret < 0)
+		return ret;
+
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
 		val = ctrl->val ? REG04_VFLIP_IMG : 0x00;
-- 
1.7.10.4

