Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:19226 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934994AbdKPNmS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 08:42:18 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v1 3/4] media: ov5640: add support of DVP parallel interface
Date: Thu, 16 Nov 2017 14:41:41 +0100
Message-ID: <1510839702-2454-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1510839702-2454-1-git-send-email-hugues.fruchet@st.com>
References: <1510839702-2454-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support of DVP parallel mode in addition of
existing MIPI CSI mode. The choice between two modes
and configuration is made through device tree.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 112 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 94 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index a576d11..fb519ad 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -34,14 +34,20 @@
 
 #define OV5640_DEFAULT_SLAVE_ID 0x3c
 
+#define OV5640_REG_SYS_CTRL0		0x3008
 #define OV5640_REG_CHIP_ID_HIGH		0x300a
 #define OV5640_REG_CHIP_ID_LOW		0x300b
+#define OV5640_REG_IO_MIPI_CTRL00	0x300e
+#define OV5640_REG_PAD_OUTPUT_ENABLE01	0x3017
+#define OV5640_REG_PAD_OUTPUT_ENABLE02	0x3018
 #define OV5640_REG_PAD_OUTPUT00		0x3019
+#define OV5640_REG_SYSTEM_CONTROL1	0x302e
 #define OV5640_REG_SC_PLL_CTRL0		0x3034
 #define OV5640_REG_SC_PLL_CTRL1		0x3035
 #define OV5640_REG_SC_PLL_CTRL2		0x3036
 #define OV5640_REG_SC_PLL_CTRL3		0x3037
 #define OV5640_REG_SLAVE_ID		0x3100
+#define OV5640_REG_SCCB_SYS_CTRL1	0x3103
 #define OV5640_REG_SYS_ROOT_DIVIDER	0x3108
 #define OV5640_REG_AWB_R_GAIN		0x3400
 #define OV5640_REG_AWB_G_GAIN		0x3402
@@ -1006,7 +1012,71 @@ static int ov5640_get_gain(struct ov5640_dev *sensor)
 	return gain & 0x3ff;
 }
 
-static int ov5640_set_stream(struct ov5640_dev *sensor, bool on)
+static int ov5640_set_stream_dvp(struct ov5640_dev *sensor)
+{
+	int ret;
+
+	/*
+	 * MIPI CONTROL 00
+	 * 6:mipi lane debug
+	 * 4:PWDN PHY TX
+	 * 3:PWDN PHY RX
+	 */
+	ret = ov5640_write_reg(sensor, OV5640_REG_IO_MIPI_CTRL00, 0x58);
+	if (ret)
+		return ret;
+
+	/* SYSTEM CONTROL, not recommended... */
+	ret = ov5640_write_reg(sensor, OV5640_REG_SYSTEM_CONTROL1, 0x00);
+	if (ret)
+		return ret;
+
+	/* SCCB SYSTEM CTRL1 1:system input clk from PLL, 0:debug enable */
+	ret = ov5640_write_reg(sensor, OV5640_REG_SCCB_SYS_CTRL1, 0x03);
+	if (ret)
+		return ret;
+
+	/* SYSTEM CTRL0 1:debug enable */
+	ret = ov5640_write_reg(sensor, OV5640_REG_SYS_CTRL0, 0x02);
+	if (ret)
+		return ret;
+
+	/*
+	 * SC PLL CONTRL1 0
+	 * - [7..4]:	System clock divider = 4
+	 * - [3..0]:	MIPI PCLK/SERCLK divider = 1
+	 */
+	ret = ov5640_write_reg(sensor, OV5640_REG_SC_PLL_CTRL1, 0x41);
+	if (ret)
+		return ret;
+
+	/* OV5640_REG_SC_PLL_CTRL2 [7:0]: PLL multiplier (4~252) = 0x60 */
+	ret = ov5640_write_reg(sensor, OV5640_REG_SC_PLL_CTRL2, 0x60);
+	if (ret)
+		return ret;
+
+	/*
+	 * PAD OUTPUT ENABLE 01:
+	 * - 6:		VSYNC output enable
+	 * - 5:		HREF output enable
+	 * - 4:		PCLK output enable
+	 * - [3:0]:	D[9:6] output enable
+	 */
+	ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT_ENABLE01, 0x7f);
+	if (ret)
+		return ret;
+
+	/*
+	 * PAD OUTPUT ENABLE 02:
+	 * - [7:4]:	D[5:2] output enable
+	 *		0:1 are unused with 8 bits
+	 *		parallel mode (8 bits output
+	 *		are on D[9:2])
+	 */
+	return ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT_ENABLE02, 0xf0);
+}
+
+static int ov5640_set_stream_mipi(struct ov5640_dev *sensor, bool on)
 {
 	int ret;
 
@@ -1598,17 +1668,24 @@ static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
 		if (ret)
 			goto power_off;
 
-		/*
-		 * start streaming briefly followed by stream off in
-		 * order to coax the clock lane into LP-11 state.
-		 */
-		ret = ov5640_set_stream(sensor, true);
-		if (ret)
-			goto power_off;
-		usleep_range(1000, 2000);
-		ret = ov5640_set_stream(sensor, false);
-		if (ret)
-			goto power_off;
+		if (sensor->ep.bus_type == V4L2_MBUS_CSI2) {
+			/*
+			 * start streaming briefly followed by stream off in
+			 * order to coax the clock lane into LP-11 state.
+			 */
+			ret = ov5640_set_stream_mipi(sensor, true);
+			if (ret)
+				goto power_off;
+			usleep_range(1000, 2000);
+			ret = ov5640_set_stream_mipi(sensor, false);
+			if (ret)
+				goto power_off;
+		} else {
+			ret = ov5640_set_stream_dvp(sensor);
+			if (ret)
+				goto power_off;
+			usleep_range(40000, 60000);
+		}
 
 		return 0;
 	}
@@ -2185,7 +2262,11 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
 				goto out;
 		}
 
-		ret = ov5640_set_stream(sensor, enable);
+		if (sensor->ep.bus_type == V4L2_MBUS_CSI2)
+			ret = ov5640_set_stream_mipi(sensor, enable);
+		else
+			ret = ov5640_set_stream_dvp(sensor);
+
 		if (!ret)
 			sensor->streaming = enable;
 	}
@@ -2270,11 +2351,6 @@ static int ov5640_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	if (sensor->ep.bus_type != V4L2_MBUS_CSI2) {
-		dev_err(dev, "invalid bus type, must be MIPI CSI2\n");
-		return -EINVAL;
-	}
-
 	/* get system clock (xclk) */
 	sensor->xclk = devm_clk_get(dev, "xclk");
 	if (IS_ERR(sensor->xclk)) {
-- 
1.9.1
