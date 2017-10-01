Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35202 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751043AbdJAKXA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 1 Oct 2017 06:23:00 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mchehab@kernel.org,
        vladimir_zapolskiy@mentor.com, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, lolivei@synopsys.com,
        p.zabel@pengutronix.de, Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH v3 2/2] media: i2c: OV5647: change to use macro for the registers
Date: Sun,  1 Oct 2017 18:22:38 +0800
Message-Id: <20171001102238.21585-2-jacob-chen@iotwrt.com>
In-Reply-To: <20171001102238.21585-1-jacob-chen@iotwrt.com>
References: <20171001102238.21585-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ref docuemnt:
  ov5647-datasheet-v1.00-2009

Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
---
 drivers/media/i2c/ov5647.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index 247302d01f53..34179d232a35 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -35,9 +35,18 @@
 
 #define SENSOR_NAME "ov5647"
 
-#define OV5647_SW_RESET		0x0103
-#define OV5647_REG_CHIPID_H	0x300A
-#define OV5647_REG_CHIPID_L	0x300B
+#define MIPI_CTRL00_CLOCK_LANE_GATE		BIT(5)
+#define MIPI_CTRL00_BUS_IDLE			BIT(2)
+#define MIPI_CTRL00_CLOCK_LANE_DISABLE		BIT(0)
+
+#define OV5647_SW_STANDBY		0x0100
+#define OV5647_SW_RESET			0x0103
+#define OV5647_REG_CHIPID_H		0x300A
+#define OV5647_REG_CHIPID_L		0x300B
+#define OV5640_REG_PAD_OUT		0x300D
+#define OV5647_REG_FRAME_OFF_NUMBER	0x4202
+#define OV5647_REG_MIPI_CTRL00		0x4800
+#define OV5647_REG_MIPI_CTRL14		0x4814
 
 #define REG_TERM 0xfffe
 #define VAL_TERM 0xfe
@@ -241,42 +250,43 @@ static int ov5647_set_virtual_channel(struct v4l2_subdev *sd, int channel)
 	u8 channel_id;
 	int ret;
 
-	ret = ov5647_read(sd, 0x4814, &channel_id);
+	ret = ov5647_read(sd, OV5647_REG_MIPI_CTRL14, &channel_id);
 	if (ret < 0)
 		return ret;
 
 	channel_id &= ~(3 << 6);
-	return ov5647_write(sd, 0x4814, channel_id | (channel << 6));
+	return ov5647_write(sd, OV5647_REG_MIPI_CTRL14, channel_id | (channel << 6));
 }
 
 static int ov5647_stream_on(struct v4l2_subdev *sd)
 {
 	int ret;
 
-	ret = ov5647_write(sd, 0x4800, 0x04);
+	ret = ov5647_write(sd, OV5647_REG_MIPI_CTRL00, MIPI_CTRL00_BUS_IDLE);
 	if (ret < 0)
 		return ret;
 
-	ret = ov5647_write(sd, 0x4202, 0x00);
+	ret = ov5647_write(sd, OV5647_REG_FRAME_OFF_NUMBER, 0x00);
 	if (ret < 0)
 		return ret;
 
-	return ov5647_write(sd, 0x300D, 0x00);
+	return ov5647_write(sd, OV5640_REG_PAD_OUT, 0x00);
 }
 
 static int ov5647_stream_off(struct v4l2_subdev *sd)
 {
 	int ret;
 
-	ret = ov5647_write(sd, 0x4800, 0x25);
+	ret = ov5647_write(sd, OV5647_REG_MIPI_CTRL00, MIPI_CTRL00_CLOCK_LANE_GATE
+			   | MIPI_CTRL00_BUS_IDLE | MIPI_CTRL00_CLOCK_LANE_DISABLE);
 	if (ret < 0)
 		return ret;
 
-	ret = ov5647_write(sd, 0x4202, 0x0f);
+	ret = ov5647_write(sd, OV5647_REG_FRAME_OFF_NUMBER, 0x0f);
 	if (ret < 0)
 		return ret;
 
-	return ov5647_write(sd, 0x300D, 0x01);
+	return ov5647_write(sd, OV5640_REG_PAD_OUT, 0x01);
 }
 
 static int set_sw_standby(struct v4l2_subdev *sd, bool standby)
@@ -284,7 +294,7 @@ static int set_sw_standby(struct v4l2_subdev *sd, bool standby)
 	int ret;
 	u8 rdval;
 
-	ret = ov5647_read(sd, 0x0100, &rdval);
+	ret = ov5647_read(sd, OV5647_SW_STANDBY, &rdval);
 	if (ret < 0)
 		return ret;
 
@@ -293,7 +303,7 @@ static int set_sw_standby(struct v4l2_subdev *sd, bool standby)
 	else
 		rdval |= 0x01;
 
-	return ov5647_write(sd, 0x0100, rdval);
+	return ov5647_write(sd, OV5647_SW_STANDBY, rdval);
 }
 
 static int __sensor_init(struct v4l2_subdev *sd)
@@ -302,7 +312,7 @@ static int __sensor_init(struct v4l2_subdev *sd)
 	u8 resetval, rdval;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	ret = ov5647_read(sd, 0x0100, &rdval);
+	ret = ov5647_read(sd, OV5647_SW_STANDBY, &rdval);
 	if (ret < 0)
 		return ret;
 
@@ -317,13 +327,13 @@ static int __sensor_init(struct v4l2_subdev *sd)
 	if (ret < 0)
 		return ret;
 
-	ret = ov5647_read(sd, 0x0100, &resetval);
+	ret = ov5647_read(sd, OV5647_SW_STANDBY, &resetval);
 	if (ret < 0)
 		return ret;
 
 	if (!(resetval & 0x01)) {
 		dev_err(&client->dev, "Device was in SW standby");
-		ret = ov5647_write(sd, 0x0100, 0x01);
+		ret = ov5647_write(sd, OV5647_SW_STANDBY, 0x01);
 		if (ret < 0)
 			return ret;
 	}
-- 
2.14.1
