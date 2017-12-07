Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:37389 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753348AbdLGMll (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Dec 2017 07:41:41 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 4/5] media: ov5640: add support of DVP parallel interface
Date: Thu, 7 Dec 2017 13:40:52 +0100
Message-ID: <1512650453-24476-5-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1512650453-24476-1-git-send-email-hugues.fruchet@st.com>
References: <1512650453-24476-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support of DVP parallel mode in addition of
existing MIPI CSI mode. The choice between two modes
and configuration is made through device tree.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 114 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 96 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 9f031f3..c791a67 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -34,13 +34,19 @@
 
 #define OV5640_DEFAULT_SLAVE_ID 0x3c
 
+#define OV5640_REG_SYS_CTRL0		0x3008
 #define OV5640_REG_CHIP_ID		0x300a
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
@@ -982,7 +988,78 @@ static int ov5640_get_gain(struct ov5640_dev *sensor)
 	return gain & 0x3ff;
 }
 
-static int ov5640_set_stream(struct ov5640_dev *sensor, bool on)
+static int ov5640_set_stream_dvp(struct ov5640_dev *sensor, bool on)
+{
+	int ret;
+
+	/*
+	 * Note about parallel port configuration.
+	 *
+	 * When configured in parallel mode, the OV5640 will
+	 * output 10 bits data on DVP data lines [9:0].
+	 * If only 8 bits data are wanted, the 8 bits data lines
+	 * of the camera interface must be physically connected
+	 * on the DVP data lines [9:2].
+	 *
+	 * The init sequence initializes control lines as defined below:
+	 * - VSYNC:	active high
+	 * - HREF:	active low
+	 * - PCLK:	active high
+	 */
+
+	if (on) {
+		/*
+		 * reset MIPI PCLK/SERCLK divider
+		 *
+		 * SC PLL CONTRL1 0
+		 * - [3..0]:	MIPI PCLK/SERCLK divider
+		 */
+		ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1, 0x0f, 0);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * powerdown MIPI TX/RX PHY & disable MIPI
+	 *
+	 * MIPI CONTROL 00
+	 * 4:	 PWDN PHY TX
+	 * 3:	 PWDN PHY RX
+	 * 2:	 MIPI enable
+	 */
+	ret = ov5640_write_reg(sensor,
+			       OV5640_REG_IO_MIPI_CTRL00, on ? 0x18 : 0);
+	if (ret)
+		return ret;
+
+	/*
+	 * enable VSYNC/HREF/PCLK DVP control lines
+	 * & D[9:6] DVP data lines
+	 *
+	 * PAD OUTPUT ENABLE 01
+	 * - 6:		VSYNC output enable
+	 * - 5:		HREF output enable
+	 * - 4:		PCLK output enable
+	 * - [3:0]:	D[9:6] output enable
+	 */
+	ret = ov5640_write_reg(sensor,
+			       OV5640_REG_PAD_OUTPUT_ENABLE01,
+			       on ? 0x7f : 0);
+	if (ret)
+		return ret;
+
+	/*
+	 * enable D[5:0] DVP data lines
+	 *
+	 * PAD OUTPUT ENABLE 02
+	 * - [7:2]:	D[5:0] output enable
+	 */
+	return ov5640_write_reg(sensor,
+				OV5640_REG_PAD_OUTPUT_ENABLE02,
+				on ? 0xfc : 0);
+}
+
+static int ov5640_set_stream_mipi(struct ov5640_dev *sensor, bool on)
 {
 	int ret;
 
@@ -1604,17 +1681,19 @@ static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
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
+		}
 
 		return 0;
 	}
@@ -2188,7 +2267,11 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
 				goto out;
 		}
 
-		ret = ov5640_set_stream(sensor, enable);
+		if (sensor->ep.bus_type == V4L2_MBUS_CSI2)
+			ret = ov5640_set_stream_mipi(sensor, enable);
+		else
+			ret = ov5640_set_stream_dvp(sensor, enable);
+
 		if (!ret)
 			sensor->streaming = enable;
 	}
@@ -2301,11 +2384,6 @@ static int ov5640_probe(struct i2c_client *client,
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
