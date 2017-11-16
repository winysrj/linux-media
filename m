Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:52687 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934991AbdKPNmQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 08:42:16 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v1 2/4] media: ov5640: check chip id
Date: Thu, 16 Nov 2017 14:41:40 +0100
Message-ID: <1510839702-2454-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1510839702-2454-1-git-send-email-hugues.fruchet@st.com>
References: <1510839702-2454-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Verify that chip identifier is correct before starting streaming

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 61071f5..a576d11 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -34,7 +34,8 @@
 
 #define OV5640_DEFAULT_SLAVE_ID 0x3c
 
-#define OV5640_REG_CHIP_ID		0x300a
+#define OV5640_REG_CHIP_ID_HIGH		0x300a
+#define OV5640_REG_CHIP_ID_LOW		0x300b
 #define OV5640_REG_PAD_OUTPUT00		0x3019
 #define OV5640_REG_SC_PLL_CTRL0		0x3034
 #define OV5640_REG_SC_PLL_CTRL1		0x3035
@@ -926,6 +927,29 @@ static int ov5640_load_regs(struct ov5640_dev *sensor,
 	return ret;
 }
 
+static int ov5640_check_chip_id(struct ov5640_dev *sensor)
+{
+	struct i2c_client *client = sensor->i2c_client;
+	int ret;
+	u8 chip_id_h, chip_id_l;
+
+	ret = ov5640_read_reg(sensor, OV5640_REG_CHIP_ID_HIGH, &chip_id_h);
+	if (ret)
+		return ret;
+
+	ret = ov5640_read_reg(sensor, OV5640_REG_CHIP_ID_LOW, &chip_id_l);
+	if (ret)
+		return ret;
+
+	if (!(chip_id_h == 0x56 && chip_id_l == 0x40)) {
+		dev_err(&client->dev, "%s: wrong chip identifier, expected 0x5640, got 0x%x%x\n",
+			__func__, chip_id_h, chip_id_l);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* read exposure, in number of line periods */
 static int ov5640_get_exposure(struct ov5640_dev *sensor)
 {
@@ -1562,6 +1586,10 @@ static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
 		ov5640_reset(sensor);
 		ov5640_power(sensor, true);
 
+		ret = ov5640_check_chip_id(sensor);
+		if (ret)
+			goto power_off;
+
 		ret = ov5640_init_slave_id(sensor);
 		if (ret)
 			goto power_off;
-- 
1.9.1
