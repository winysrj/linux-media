Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:37790 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab2DWNV3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 09:21:29 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: [PATCH 1/3] [media] gspca - ov534: Add Saturation control
Date: Mon, 23 Apr 2012 15:21:05 +0200
Message-Id: <1335187267-27940-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1335187267-27940-1-git-send-email-ospite@studenti.unina.it>
References: <1335187267-27940-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/video/gspca/ov534.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/gspca/ov534.c b/drivers/media/video/gspca/ov534.c
index 0475339..45139b5 100644
--- a/drivers/media/video/gspca/ov534.c
+++ b/drivers/media/video/gspca/ov534.c
@@ -53,6 +53,7 @@ MODULE_LICENSE("GPL");
 
 /* controls */
 enum e_ctrl {
+	SATURATION,
 	BRIGHTNESS,
 	CONTRAST,
 	GAIN,
@@ -87,6 +88,7 @@ enum sensors {
 };
 
 /* V4L2 controls supported by the driver */
+static void setsaturation(struct gspca_dev *gspca_dev);
 static void setbrightness(struct gspca_dev *gspca_dev);
 static void setcontrast(struct gspca_dev *gspca_dev);
 static void setgain(struct gspca_dev *gspca_dev);
@@ -103,6 +105,18 @@ static int sd_start(struct gspca_dev *gspca_dev);
 static void sd_stopN(struct gspca_dev *gspca_dev);
 
 static const struct ctrl sd_ctrls[] = {
+[SATURATION] = {
+		{
+			.id      = V4L2_CID_SATURATION,
+			.type    = V4L2_CTRL_TYPE_INTEGER,
+			.name    = "Saturation",
+			.minimum = 0,
+			.maximum = 255,
+			.step    = 1,
+			.default_value = 64,
+		},
+		.set_control = setsaturation
+	},
 [BRIGHTNESS] = {
 		{
 			.id      = V4L2_CID_BRIGHTNESS,
@@ -684,7 +698,7 @@ static const u8 sensor_init_772x[][2] = {
 	{ 0x9c, 0x20 },
 	{ 0x9e, 0x81 },
 
-	{ 0xa6, 0x04 },
+	{ 0xa6, 0x06 },
 	{ 0x7e, 0x0c },
 	{ 0x7f, 0x16 },
 	{ 0x80, 0x2a },
@@ -955,6 +969,20 @@ static void set_frame_rate(struct gspca_dev *gspca_dev)
 	PDEBUG(D_PROBE, "frame_rate: %d", r->fps);
 }
 
+static void setsaturation(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int val;
+
+	val = sd->ctrls[SATURATION].val;
+	if (sd->sensor == SENSOR_OV767x) {
+		/* TBD */
+	} else {
+		sccb_reg_write(gspca_dev, 0xa7, val); /* U saturation */
+		sccb_reg_write(gspca_dev, 0xa8, val); /* V saturation */
+	}
+}
+
 static void setbrightness(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -1309,6 +1337,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	if (!(gspca_dev->ctrl_dis & (1 << GAIN)))
 		setgain(gspca_dev);
 	setexposure(gspca_dev);
+	setsaturation(gspca_dev);
 	setbrightness(gspca_dev);
 	setcontrast(gspca_dev);
 	if (!(gspca_dev->ctrl_dis & (1 << SHARPNESS)))
-- 
1.7.10

