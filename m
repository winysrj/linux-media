Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:50706 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbaLSMPD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 07:15:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, marbugge@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 4/4] adv7842: simplify InfoFrame logging
Date: Fri, 19 Dec 2014 13:14:23 +0100
Message-Id: <1418991263-17934-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418991263-17934-1-git-send-email-hverkuil@xs4all.nl>
References: <1418991263-17934-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Use the new logging functions from the hdmi module.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig   |   1 +
 drivers/media/i2c/adv7842.c | 174 ++++++++++++--------------------------------
 2 files changed, 47 insertions(+), 128 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 205d713..8eebfa9 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -209,6 +209,7 @@ config VIDEO_ADV7604
 config VIDEO_ADV7842
 	tristate "Analog Devices ADV7842 decoder"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
+	select HDMI
 	---help---
 	  Support for the Analog Devices ADV7842 video decoder.
 
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 75d26df..156d13d 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -38,6 +38,7 @@
 #include <linux/videodev2.h>
 #include <linux/workqueue.h>
 #include <linux/v4l2-dv-timings.h>
+#include <linux/hdmi.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-dv-timings.h>
@@ -2108,149 +2109,65 @@ static int adv7842_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *e)
 	return err;
 }
 
-/*********** avi info frame CEA-861-E **************/
-/* TODO move to common library */
-
-struct avi_info_frame {
-	uint8_t f17;
-	uint8_t y10;
-	uint8_t a0;
-	uint8_t b10;
-	uint8_t s10;
-	uint8_t c10;
-	uint8_t m10;
-	uint8_t r3210;
-	uint8_t itc;
-	uint8_t ec210;
-	uint8_t q10;
-	uint8_t sc10;
-	uint8_t f47;
-	uint8_t vic;
-	uint8_t yq10;
-	uint8_t cn10;
-	uint8_t pr3210;
-	uint16_t etb;
-	uint16_t sbb;
-	uint16_t elb;
-	uint16_t srb;
+struct adv7842_cfg_read_infoframe {
+	const char *desc;
+	u8 present_mask;
+	u8 head_addr;
+	u8 payload_addr;
 };
 
-static const char *y10_txt[4] = {
-	"RGB",
-	"YCbCr 4:2:2",
-	"YCbCr 4:4:4",
-	"Future",
-};
-
-static const char *c10_txt[4] = {
-	"No Data",
-	"SMPTE 170M",
-	"ITU-R 709",
-	"Extended Colorimetry information valied",
-};
-
-static const char *itc_txt[2] = {
-	"No Data",
-	"IT content",
-};
-
-static const char *ec210_txt[8] = {
-	"xvYCC601",
-	"xvYCC709",
-	"sYCC601",
-	"AdobeYCC601",
-	"AdobeRGB",
-	"5 reserved",
-	"6 reserved",
-	"7 reserved",
-};
-
-static const char *q10_txt[4] = {
-	"Default",
-	"Limited Range",
-	"Full Range",
-	"Reserved",
-};
-
-static void parse_avi_infoframe(struct v4l2_subdev *sd, uint8_t *buf,
-				struct avi_info_frame *avi)
-{
-	avi->f17 = (buf[1] >> 7) & 0x1;
-	avi->y10 = (buf[1] >> 5) & 0x3;
-	avi->a0 = (buf[1] >> 4) & 0x1;
-	avi->b10 = (buf[1] >> 2) & 0x3;
-	avi->s10 = buf[1] & 0x3;
-	avi->c10 = (buf[2] >> 6) & 0x3;
-	avi->m10 = (buf[2] >> 4) & 0x3;
-	avi->r3210 = buf[2] & 0xf;
-	avi->itc = (buf[3] >> 7) & 0x1;
-	avi->ec210 = (buf[3] >> 4) & 0x7;
-	avi->q10 = (buf[3] >> 2) & 0x3;
-	avi->sc10 = buf[3] & 0x3;
-	avi->f47 = (buf[4] >> 7) & 0x1;
-	avi->vic = buf[4] & 0x7f;
-	avi->yq10 = (buf[5] >> 6) & 0x3;
-	avi->cn10 = (buf[5] >> 4) & 0x3;
-	avi->pr3210 = buf[5] & 0xf;
-	avi->etb = buf[6] + 256*buf[7];
-	avi->sbb = buf[8] + 256*buf[9];
-	avi->elb = buf[10] + 256*buf[11];
-	avi->srb = buf[12] + 256*buf[13];
-}
-
-static void print_avi_infoframe(struct v4l2_subdev *sd)
+static void log_infoframe(struct v4l2_subdev *sd, struct adv7842_cfg_read_infoframe *cri)
 {
 	int i;
-	uint8_t buf[14];
-	u8 avi_len;
-	u8 avi_ver;
-	struct avi_info_frame avi;
+	uint8_t buffer[32];
+	union hdmi_infoframe frame;
+	u8 len;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *dev = &client->dev;
 
-	if (!(hdmi_read(sd, 0x05) & 0x80)) {
-		v4l2_info(sd, "receive DVI-D signal (AVI infoframe not supported)\n");
-		return;
-	}
-	if (!(io_read(sd, 0x60) & 0x01)) {
-		v4l2_info(sd, "AVI infoframe not received\n");
+	if (!(io_read(sd, 0x60) & cri->present_mask)) {
+		v4l2_info(sd, "%s infoframe not received\n", cri->desc);
 		return;
 	}
 
-	if (io_read(sd, 0x88) & 0x10) {
-		v4l2_info(sd, "AVI infoframe checksum error has occurred earlier\n");
-		io_write(sd, 0x8a, 0x10); /* clear AVI_INF_CKS_ERR_RAW */
-		if (io_read(sd, 0x88) & 0x10) {
-			v4l2_info(sd, "AVI infoframe checksum error still present\n");
-			io_write(sd, 0x8a, 0x10); /* clear AVI_INF_CKS_ERR_RAW */
-		}
-	}
+	for (i = 0; i < 3; i++)
+		buffer[i] = infoframe_read(sd, cri->head_addr + i);
 
-	avi_len = infoframe_read(sd, 0xe2);
-	avi_ver = infoframe_read(sd, 0xe1);
-	v4l2_info(sd, "AVI infoframe version %d (%d byte)\n",
-		  avi_ver, avi_len);
+	len = buffer[2] + 1;
 
-	if (avi_ver != 0x02)
+	if (len + 3 > sizeof(buffer)) {
+		v4l2_err(sd, "%s: invalid %s infoframe length %d\n", __func__, cri->desc, len);
 		return;
+	}
 
-	for (i = 0; i < 14; i++)
-		buf[i] = infoframe_read(sd, i);
+	for (i = 0; i < len; i++)
+		buffer[i + 3] = infoframe_read(sd, cri->payload_addr + i);
 
-	v4l2_info(sd, "\t%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
-		  buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7],
-		  buf[8], buf[9], buf[10], buf[11], buf[12], buf[13]);
+	if (hdmi_infoframe_unpack(&frame, buffer) < 0) {
+		v4l2_err(sd, "%s: unpack of %s infoframe failed\n", __func__, cri->desc);
+		return;
+	}
 
-	parse_avi_infoframe(sd, buf, &avi);
+	hdmi_infoframe_log(KERN_INFO, dev, &frame);
+}
 
-	if (avi.vic)
-		v4l2_info(sd, "\tVIC: %d\n", avi.vic);
-	if (avi.itc)
-		v4l2_info(sd, "\t%s\n", itc_txt[avi.itc]);
+static void adv7842_log_infoframes(struct v4l2_subdev *sd)
+{
+	int i;
+	struct adv7842_cfg_read_infoframe cri[] = {
+		{ "AVI", 0x01, 0xe0, 0x00 },
+		{ "Audio", 0x02, 0xe3, 0x1c },
+		{ "SDP", 0x04, 0xe6, 0x2a },
+		{ "Vendor", 0x10, 0xec, 0x54 }
+	};
 
-	if (avi.y10)
-		v4l2_info(sd, "\t%s %s\n", y10_txt[avi.y10], !avi.c10 ? "" :
-			(avi.c10 == 0x3 ? ec210_txt[avi.ec210] : c10_txt[avi.c10]));
-	else
-		v4l2_info(sd, "\t%s %s\n", y10_txt[avi.y10], q10_txt[avi.q10]);
+	if (!(hdmi_read(sd, 0x05) & 0x80)) {
+		v4l2_info(sd, "receive DVI-D signal, no infoframes\n");
+		return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(cri); i++)
+		log_infoframe(sd, &cri[i]);
 }
 
 static const char * const prim_mode_txt[] = {
@@ -2464,7 +2381,8 @@ static int adv7842_cp_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "Deep color mode: %s\n",
 			deep_color_mode_txt[hdmi_read(sd, 0x0b) >> 6]);
 
-	print_avi_infoframe(sd);
+	adv7842_log_infoframes(sd);
+
 	return 0;
 }
 
-- 
2.1.3

