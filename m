Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:41162 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbbFGKc6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 06:32:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/6] adv7604: log infoframes
Date: Sun,  7 Jun 2015 12:32:33 +0200
Message-Id: <1433673155-20179-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433673155-20179-1-git-send-email-hverkuil@xs4all.nl>
References: <1433673155-20179-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig   |  1 +
 drivers/media/i2c/adv7604.c | 87 ++++++++++++++++++++++++++++++---------------
 2 files changed, 59 insertions(+), 29 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index c92180d..71ee8f5 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -197,6 +197,7 @@ config VIDEO_ADV7183
 config VIDEO_ADV7604
 	tristate "Analog Devices ADV7604 decoder"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && GPIOLIB
+	select HDMI
 	---help---
 	  Support for the Analog Devices ADV7604 video decoder.
 
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index aaa37b0..757b6b5 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -29,6 +29,7 @@
 
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
+#include <linux/hdmi.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -95,6 +96,13 @@ struct adv76xx_format_info {
 	u8 op_format_sel;
 };
 
+struct adv76xx_cfg_read_infoframe {
+	const char *desc;
+	u8 present_mask;
+	u8 head_addr;
+	u8 payload_addr;
+};
+
 struct adv76xx_chip_info {
 	enum adv76xx_type type;
 
@@ -2127,46 +2135,67 @@ static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 
 /*********** avi info frame CEA-861-E **************/
 
-static void print_avi_infoframe(struct v4l2_subdev *sd)
+static const struct adv76xx_cfg_read_infoframe adv76xx_cri[] = {
+	{ "AVI", 0x01, 0xe0, 0x00 },
+	{ "Audio", 0x02, 0xe3, 0x1c },
+	{ "SDP", 0x04, 0xe6, 0x2a },
+	{ "Vendor", 0x10, 0xec, 0x54 }
+};
+
+static int adv76xx_read_infoframe(struct v4l2_subdev *sd, int index,
+				  union hdmi_infoframe *frame)
 {
+	uint8_t buffer[32];
+	u8 len;
 	int i;
-	u8 buf[14];
-	u8 avi_len;
-	u8 avi_ver;
 
-	if (!is_hdmi(sd)) {
-		v4l2_info(sd, "receive DVI-D signal (AVI infoframe not supported)\n");
-		return;
+	if (!(io_read(sd, 0x60) & adv76xx_cri[index].present_mask)) {
+		v4l2_info(sd, "%s infoframe not received\n",
+			  adv76xx_cri[index].desc);
+		return -ENOENT;
 	}
-	if (!(io_read(sd, 0x60) & 0x01)) {
-		v4l2_info(sd, "AVI infoframe not received\n");
-		return;
+
+	for (i = 0; i < 3; i++)
+		buffer[i] = infoframe_read(sd,
+					   adv76xx_cri[index].head_addr + i);
+
+	len = buffer[2] + 1;
+
+	if (len + 3 > sizeof(buffer)) {
+		v4l2_err(sd, "%s: invalid %s infoframe length %d\n", __func__,
+			 adv76xx_cri[index].desc, len);
+		return -ENOENT;
 	}
 
-	if (io_read(sd, 0x83) & 0x01) {
-		v4l2_info(sd, "AVI infoframe checksum error has occurred earlier\n");
-		io_write(sd, 0x85, 0x01); /* clear AVI_INF_CKS_ERR_RAW */
-		if (io_read(sd, 0x83) & 0x01) {
-			v4l2_info(sd, "AVI infoframe checksum error still present\n");
-			io_write(sd, 0x85, 0x01); /* clear AVI_INF_CKS_ERR_RAW */
-		}
+	for (i = 0; i < len; i++)
+		buffer[i + 3] = infoframe_read(sd,
+				       adv76xx_cri[index].payload_addr + i);
+
+	if (hdmi_infoframe_unpack(frame, buffer) < 0) {
+		v4l2_err(sd, "%s: unpack of %s infoframe failed\n", __func__,
+			 adv76xx_cri[index].desc);
+		return -ENOENT;
 	}
+	return 0;
+}
 
-	avi_len = infoframe_read(sd, 0xe2);
-	avi_ver = infoframe_read(sd, 0xe1);
-	v4l2_info(sd, "AVI infoframe version %d (%d byte)\n",
-			avi_ver, avi_len);
+static void adv76xx_log_infoframes(struct v4l2_subdev *sd)
+{
+	int i;
 
-	if (avi_ver != 0x02)
+	if (!is_hdmi(sd)) {
+		v4l2_info(sd, "receive DVI-D signal, no infoframes\n");
 		return;
+	}
 
-	for (i = 0; i < 14; i++)
-		buf[i] = infoframe_read(sd, i);
+	for (i = 0; i < ARRAY_SIZE(adv76xx_cri); i++) {
+		union hdmi_infoframe frame;
+		struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	v4l2_info(sd,
-		"\t%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
-		buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7],
-		buf[8], buf[9], buf[10], buf[11], buf[12], buf[13]);
+		if (adv76xx_read_infoframe(sd, i, &frame))
+			return;
+		hdmi_infoframe_log(KERN_INFO, &client->dev, &frame);
+	}
 }
 
 static int adv76xx_log_status(struct v4l2_subdev *sd)
@@ -2302,7 +2331,7 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
 
 		v4l2_info(sd, "Deep color mode: %s\n", deep_color_mode_txt[(hdmi_read(sd, 0x0b) & 0x60) >> 5]);
 
-		print_avi_infoframe(sd);
+		adv76xx_log_infoframes(sd);
 	}
 
 	return 0;
-- 
2.1.4

