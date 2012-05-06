Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:35776 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122Ab2EFKPO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 May 2012 06:15:14 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-input@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH v2 1/3] gspca - ov534: Add Saturation control
Date: Sun,  6 May 2012 12:14:56 +0200
Message-Id: <1336299298-17517-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1336299298-17517-1-git-send-email-ospite@studenti.unina.it>
References: <20120505102614.31395c2979f0b7aac0c8a107@studenti.unina.it>
 <1336299298-17517-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also merge the "COLORS" control into it as it was V4L2_CID_SATURATION
anyway.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---

Changes since version 1:

  - Merged SATURATION and COLORS controls

 drivers/media/video/gspca/ov534.c |   83 ++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 38 deletions(-)

diff --git a/drivers/media/video/gspca/ov534.c b/drivers/media/video/gspca/ov534.c
index 0475339..c15cf23 100644
--- a/drivers/media/video/gspca/ov534.c
+++ b/drivers/media/video/gspca/ov534.c
@@ -53,6 +53,7 @@ MODULE_LICENSE("GPL");
 
 /* controls */
 enum e_ctrl {
+	SATURATION,
 	BRIGHTNESS,
 	CONTRAST,
 	GAIN,
@@ -63,7 +64,6 @@ enum e_ctrl {
 	SHARPNESS,
 	HFLIP,
 	VFLIP,
-	COLORS,
 	LIGHTFREQ,
 	NCTRLS		/* number of controls */
 };
@@ -87,6 +87,7 @@ enum sensors {
 };
 
 /* V4L2 controls supported by the driver */
+static void setsaturation(struct gspca_dev *gspca_dev);
 static void setbrightness(struct gspca_dev *gspca_dev);
 static void setcontrast(struct gspca_dev *gspca_dev);
 static void setgain(struct gspca_dev *gspca_dev);
@@ -96,13 +97,24 @@ static void setawb(struct gspca_dev *gspca_dev);
 static void setaec(struct gspca_dev *gspca_dev);
 static void setsharpness(struct gspca_dev *gspca_dev);
 static void sethvflip(struct gspca_dev *gspca_dev);
-static void setcolors(struct gspca_dev *gspca_dev);
 static void setlightfreq(struct gspca_dev *gspca_dev);
 
 static int sd_start(struct gspca_dev *gspca_dev);
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
@@ -223,18 +235,6 @@ static const struct ctrl sd_ctrls[] = {
 		},
 		.set_control = sethvflip
 	},
-[COLORS] = {
-		{
-			.id      = V4L2_CID_SATURATION,
-			.type    = V4L2_CTRL_TYPE_INTEGER,
-			.name    = "Saturation",
-			.minimum = 0,
-			.maximum = 6,
-			.step    = 1,
-			.default_value = 3,
-		},
-		.set_control = setcolors
-	},
 [LIGHTFREQ] = {
 		{
 			.id      = V4L2_CID_POWER_LINE_FREQUENCY,
@@ -684,7 +684,7 @@ static const u8 sensor_init_772x[][2] = {
 	{ 0x9c, 0x20 },
 	{ 0x9e, 0x81 },
 
-	{ 0xa6, 0x04 },
+	{ 0xa6, 0x06 },
 	{ 0x7e, 0x0c },
 	{ 0x7f, 0x16 },
 	{ 0x80, 0x2a },
@@ -955,6 +955,32 @@ static void set_frame_rate(struct gspca_dev *gspca_dev)
 	PDEBUG(D_PROBE, "frame_rate: %d", r->fps);
 }
 
+static void setsaturation(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int val;
+
+	val = sd->ctrls[SATURATION].val;
+	if (sd->sensor == SENSOR_OV767x) {
+		int i;
+		static u8 color_tb[][6] = {
+			{0x42, 0x42, 0x00, 0x11, 0x30, 0x41},
+			{0x52, 0x52, 0x00, 0x16, 0x3c, 0x52},
+			{0x66, 0x66, 0x00, 0x1b, 0x4b, 0x66},
+			{0x80, 0x80, 0x00, 0x22, 0x5e, 0x80},
+			{0x9a, 0x9a, 0x00, 0x29, 0x71, 0x9a},
+			{0xb8, 0xb8, 0x00, 0x31, 0x87, 0xb8},
+			{0xdd, 0xdd, 0x00, 0x3b, 0xa2, 0xdd},
+		};
+
+		for (i = 0; i < ARRAY_SIZE(color_tb[0]); i++)
+			sccb_reg_write(gspca_dev, 0x4f + i, color_tb[val][i]);
+	} else {
+		sccb_reg_write(gspca_dev, 0xa7, val); /* U saturation */
+		sccb_reg_write(gspca_dev, 0xa8, val); /* V saturation */
+	}
+}
+
 static void setbrightness(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -1132,26 +1158,6 @@ static void sethvflip(struct gspca_dev *gspca_dev)
 	}
 }
 
-static void setcolors(struct gspca_dev *gspca_dev)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	u8 val;
-	int i;
-	static u8 color_tb[][6] = {
-		{0x42, 0x42, 0x00, 0x11, 0x30, 0x41},
-		{0x52, 0x52, 0x00, 0x16, 0x3c, 0x52},
-		{0x66, 0x66, 0x00, 0x1b, 0x4b, 0x66},
-		{0x80, 0x80, 0x00, 0x22, 0x5e, 0x80},
-		{0x9a, 0x9a, 0x00, 0x29, 0x71, 0x9a},
-		{0xb8, 0xb8, 0x00, 0x31, 0x87, 0xb8},
-		{0xdd, 0xdd, 0x00, 0x3b, 0xa2, 0xdd},
-	};
-
-	val = sd->ctrls[COLORS].val;
-	for (i = 0; i < ARRAY_SIZE(color_tb[0]); i++)
-		sccb_reg_write(gspca_dev, 0x4f + i, color_tb[val][i]);
-}
-
 static void setlightfreq(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -1228,6 +1234,9 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		gspca_dev->ctrl_dis = (1 << GAIN) |
 					(1 << AGC) |
 					(1 << SHARPNESS);	/* auto */
+		sd->ctrls[SATURATION].min = 0,
+		sd->ctrls[SATURATION].max = 6,
+		sd->ctrls[SATURATION].def = 3,
 		sd->ctrls[BRIGHTNESS].min = -127;
 		sd->ctrls[BRIGHTNESS].max = 127;
 		sd->ctrls[BRIGHTNESS].def = 0;
@@ -1243,7 +1252,6 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		gspca_dev->cam.nmodes = ARRAY_SIZE(ov767x_mode);
 	} else {
 		sd->sensor = SENSOR_OV772x;
-		gspca_dev->ctrl_dis = (1 << COLORS);
 		gspca_dev->cam.bulk = 1;
 		gspca_dev->cam.bulk_size = 16384;
 		gspca_dev->cam.bulk_nurbs = 2;
@@ -1302,6 +1310,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	set_frame_rate(gspca_dev);
 
+	setsaturation(gspca_dev);
 	if (!(gspca_dev->ctrl_dis & (1 << AGC)))
 		setagc(gspca_dev);
 	setawb(gspca_dev);
@@ -1314,8 +1323,6 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	if (!(gspca_dev->ctrl_dis & (1 << SHARPNESS)))
 		setsharpness(gspca_dev);
 	sethvflip(gspca_dev);
-	if (!(gspca_dev->ctrl_dis & (1 << COLORS)))
-		setcolors(gspca_dev);
 	setlightfreq(gspca_dev);
 
 	ov534_set_led(gspca_dev, 1);
-- 
1.7.10

