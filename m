Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48511 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab2IWVQn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 17:16:43 -0400
Received: by wgbfm10 with SMTP id fm10so2315088wgb.1
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 14:16:42 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: g.liakhovetski@gmx.de
Cc: maramaopercheseimorto@gmail.com, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] ov2640: select sensor register bank before applying h/v-flip settings
Date: Sun, 23 Sep 2012 23:16:34 +0300
Message-Id: <1348431394-30951-1-git-send-email-fschaefer.oss@googlemail.com>
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
 drivers/media/i2c/soc_camera/ov2640.c |    5 +++++
 1 Datei geändert, 5 Zeilen hinzugefügt(+)

diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 78ac574..d2d298b 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -684,6 +684,11 @@ static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
 		&container_of(ctrl->handler, struct ov2640_priv, hdl)->subdev;
 	struct i2c_client  *client = v4l2_get_subdevdata(sd);
 	u8 val;
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(client, BANK_SEL, BANK_SEL_SENS);
+	if (ret < 0)
+		return ret;
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-- 
1.7.10.4

