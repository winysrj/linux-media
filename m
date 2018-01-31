Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:44624 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751834AbeAaJIf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 04:08:35 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3] media: ov5640: add JPEG support
Date: Wed, 31 Jan 2018 10:08:10 +0100
Message-ID: <1517389690-3138-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add YUV422 encoded JPEG support.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
version 2:
  - Revisit code as per Sakari suggestions:
    - fix lock scheme
    - fix switch back to non-JPEG output while sensor powered
    See https://www.mail-archive.com/linux-media@vger.kernel.org/msg124979.html

version 3:
  - After discussion with Sakari, drop get/set_frame_desc
    code for JPEG max length estimation, ISP side will
    allocate buffer on WxH basis, no special information
    is needed to be conveyed from sensor to ISP.

 drivers/media/i2c/ov5640.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index e2dd352..99a5902 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -34,6 +34,8 @@
 
 #define OV5640_DEFAULT_SLAVE_ID 0x3c
 
+#define OV5640_REG_SYS_RESET02		0x3002
+#define OV5640_REG_SYS_CLOCK_ENABLE02	0x3006
 #define OV5640_REG_SYS_CTRL0		0x3008
 #define OV5640_REG_CHIP_ID		0x300a
 #define OV5640_REG_IO_MIPI_CTRL00	0x300e
@@ -114,6 +116,7 @@ struct ov5640_pixfmt {
 };
 
 static const struct ov5640_pixfmt ov5640_formats[] = {
+	{ MEDIA_BUS_FMT_JPEG_1X8, V4L2_COLORSPACE_JPEG, },
 	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_SRGB, },
 	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_SRGB, },
 	{ MEDIA_BUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB, },
@@ -1915,6 +1918,7 @@ static int ov5640_set_framefmt(struct ov5640_dev *sensor,
 {
 	int ret = 0;
 	bool is_rgb = false;
+	bool is_jpeg = false;
 	u8 val;
 
 	switch (format->code) {
@@ -1936,6 +1940,11 @@ static int ov5640_set_framefmt(struct ov5640_dev *sensor,
 		val = 0x61;
 		is_rgb = true;
 		break;
+	case MEDIA_BUS_FMT_JPEG_1X8:
+		/* YUV422, YUYV */
+		val = 0x30;
+		is_jpeg = true;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1946,8 +1955,40 @@ static int ov5640_set_framefmt(struct ov5640_dev *sensor,
 		return ret;
 
 	/* FORMAT MUX CONTROL: ISP YUV or RGB */
-	return ov5640_write_reg(sensor, OV5640_REG_ISP_FORMAT_MUX_CTRL,
-				is_rgb ? 0x01 : 0x00);
+	ret = ov5640_write_reg(sensor, OV5640_REG_ISP_FORMAT_MUX_CTRL,
+			       is_rgb ? 0x01 : 0x00);
+	if (ret)
+		return ret;
+
+	/*
+	 * TIMING TC REG21:
+	 * - [5]:	JPEG enable
+	 */
+	ret = ov5640_mod_reg(sensor, OV5640_REG_TIMING_TC_REG21,
+			     BIT(5), is_jpeg ? BIT(5) : 0);
+	if (ret)
+		return ret;
+
+	/*
+	 * SYSTEM RESET02:
+	 * - [4]:	Reset JFIFO
+	 * - [3]:	Reset SFIFO
+	 * - [2]:	Reset JPEG
+	 */
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SYS_RESET02,
+			     BIT(4) | BIT(3) | BIT(2),
+			     is_jpeg ? 0 : (BIT(4) | BIT(3) | BIT(2)));
+	if (ret)
+		return ret;
+
+	/*
+	 * CLOCK ENABLE02:
+	 * - [5]:	Enable JPEG 2x clock
+	 * - [3]:	Enable JPEG clock
+	 */
+	return ov5640_mod_reg(sensor, OV5640_REG_SYS_CLOCK_ENABLE02,
+			      BIT(5) | BIT(3),
+			      is_jpeg ? (BIT(5) | BIT(3)) : 0);
 }
 
 /*
-- 
1.9.1
