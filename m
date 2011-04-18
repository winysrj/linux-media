Return-path: <mchehab@pedra>
Received: from smtp21.services.sfr.fr ([93.17.128.4]:59674 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1DRUpK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 16:45:10 -0400
Received: from smtp21.services.sfr.fr (msfrf2122 [10.18.25.36])
	by msfrf2115.sfr.fr (SMTP Server) with ESMTP id EB777700077B
	for <linux-media@vger.kernel.org>; Mon, 18 Apr 2011 22:45:08 +0200 (CEST)
Message-ID: <4DACA21E.3050509@sfr.fr>
Date: Mon, 18 Apr 2011 22:42:06 +0200
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: [PATCH 5/5] gspca - jeilinj: add SPORTSCAM specific controls
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Patrice CHOTARD <patricechotard@free.fr>
---
 drivers/media/video/gspca/jeilinj.c |  248 ++++++++++++++++++++++++++++++++++-
 1 files changed, 242 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/gspca/jeilinj.c b/drivers/media/video/gspca/jeilinj.c
index da92867..1bd9c4b 100644
--- a/drivers/media/video/gspca/jeilinj.c
+++ b/drivers/media/video/gspca/jeilinj.c
@@ -5,6 +5,8 @@
  * download raw JPEG data.
  *
  * Copyright (C) 2009 Theodore Kilgore
+ *
+ * Sportscam DV15 support and control settings are
  * Copyright (C) 2011 Patrice Chotard
  *
  * This program is free software; you can redistribute it and/or modify
@@ -46,14 +48,31 @@ enum {
 	SAKAR_57379,
 	SPORTSCAM_DV15,
 };
+
+#define CAMQUALITY_MIN 0	/* highest cam quality */
+#define CAMQUALITY_MAX 97	/* lowest cam quality  */
+
+enum e_ctrl {
+	LIGHTFREQ,
+	AUTOGAIN,
+	RED,
+	GREEN,
+	BLUE,
+	NCTRLS		/* number of controls */
+};
+
 /* Structure to hold all of our device specific stuff */
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
+	struct gspca_ctrl ctrls[NCTRLS];
 	int blocks_left;
 	const struct v4l2_pix_format *cap_mode;
 	/* Driver stuff */
 	u8 type;
 	u8 quality;				 /* image quality */
+#define QUALITY_MIN 35
+#define QUALITY_MAX 85
+#define QUALITY_DEF 85
 	u8 jpeg_hdr[JPEG_HDR_SZ];
 };
 
@@ -118,6 +137,162 @@ static void jlj_read1(struct gspca_dev *gspca_dev, unsigned char response)
 	}
 }
 
+static void setfreq(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 freq_commands[][2] = {
+		{0x71, 0x80},
+		{0x70, 0x07}
+	};
+
+	freq_commands[0][1] |= (sd->ctrls[LIGHTFREQ].val >> 1);
+
+	jlj_write2(gspca_dev, freq_commands[0]);
+	jlj_write2(gspca_dev, freq_commands[1]);
+}
+
+static void setcamquality(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 quality_commands[][2] = {
+		{0x71, 0x1E},
+		{0x70, 0x06}
+	};
+	u8 camquality;
+
+	/* adapt camera quality from jpeg quality */
+	camquality = ((QUALITY_MAX - sd->quality) * CAMQUALITY_MAX)
+		/ (QUALITY_MAX - QUALITY_MIN);
+	quality_commands[0][1] += camquality;
+
+	jlj_write2(gspca_dev, quality_commands[0]);
+	jlj_write2(gspca_dev, quality_commands[1]);
+}
+
+static void setautogain(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 autogain_commands[][2] = {
+		{0x94, 0x02},
+		{0xcf, 0x00}
+	};
+
+	autogain_commands[1][1] = (sd->ctrls[AUTOGAIN].val << 4);
+
+	jlj_write2(gspca_dev, autogain_commands[0]);
+	jlj_write2(gspca_dev, autogain_commands[1]);
+}
+
+static void setred(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 setred_commands[][2] = {
+		{0x94, 0x02},
+		{0xe6, 0x00}
+	};
+
+	setred_commands[1][1] = sd->ctrls[RED].val;
+
+	jlj_write2(gspca_dev, setred_commands[0]);
+	jlj_write2(gspca_dev, setred_commands[1]);
+}
+
+static void setgreen(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 setgreen_commands[][2] = {
+		{0x94, 0x02},
+		{0xe7, 0x00}
+	};
+
+	setgreen_commands[1][1] = sd->ctrls[GREEN].val;
+
+	jlj_write2(gspca_dev, setgreen_commands[0]);
+	jlj_write2(gspca_dev, setgreen_commands[1]);
+}
+
+static void setblue(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 setblue_commands[][2] = {
+		{0x94, 0x02},
+		{0xe9, 0x00}
+	};
+
+	setblue_commands[1][1] = sd->ctrls[BLUE].val;
+
+	jlj_write2(gspca_dev, setblue_commands[0]);
+	jlj_write2(gspca_dev, setblue_commands[1]);
+}
+
+static const struct ctrl sd_ctrls[NCTRLS] = {
+[LIGHTFREQ] = {
+	    {
+		.id      = V4L2_CID_POWER_LINE_FREQUENCY,
+		.type    = V4L2_CTRL_TYPE_MENU,
+		.name    = "Light frequency filter",
+		.minimum = V4L2_CID_POWER_LINE_FREQUENCY_DISABLED, /* 1 */
+		.maximum = V4L2_CID_POWER_LINE_FREQUENCY_60HZ, /* 2 */
+		.step    = 1,
+		.default_value = V4L2_CID_POWER_LINE_FREQUENCY_60HZ,
+	    },
+	    .set_control = setfreq
+	},
+[AUTOGAIN] = {
+	    {
+		.id = V4L2_CID_AUTOGAIN,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Automatic Gain (and Exposure)",
+		.minimum = 0,
+		.maximum = 3,
+		.step = 1,
+#define AUTOGAIN_DEF 0
+		.default_value = AUTOGAIN_DEF,
+	   },
+	   .set_control = setautogain
+	},
+[RED] = {
+	    {
+		.id = V4L2_CID_RED_BALANCE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "red balance",
+		.minimum = 0,
+		.maximum = 3,
+		.step = 1,
+#define RED_BALANCE_DEF 2
+		.default_value = RED_BALANCE_DEF,
+	   },
+	   .set_control = setred
+	},
+
+[GREEN]	= {
+	    {
+		.id = V4L2_CID_GAIN,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "green balance",
+		.minimum = 0,
+		.maximum = 3,
+		.step = 1,
+#define GREEN_BALANCE_DEF 2
+		.default_value = GREEN_BALANCE_DEF,
+	   },
+	   .set_control = setgreen
+	},
+[BLUE] = {
+	    {
+		.id = V4L2_CID_BLUE_BALANCE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "blue balance",
+		.minimum = 0,
+		.maximum = 3,
+		.step = 1,
+#define BLUE_BALANCE_DEF 2
+		.default_value = BLUE_BALANCE_DEF,
+	   },
+	   .set_control = setblue
+	},
+};
+
 static int jlj_start(struct gspca_dev *gspca_dev)
 {
 	int i;
@@ -148,11 +323,7 @@ static int jlj_start(struct gspca_dev *gspca_dev)
 		{{0x94, 0x02}, 0, 0},
 		{{0xe6, 0x2c}, 0, 0},
 		{{0x94, 0x03}, 0, 0},
-		{{0xaa, 0x00}, 0, 0},
-		{{0x71, 0x1e}, 0, 0},
-		{{0x70, 0x06}, 0, 0},
-		{{0x71, 0x80}, 0, 0},
-		{{0x70, 0x07}, 0, 0}
+		{{0xaa, 0x00}, 0, 0}
 	};
 
 	sd->blocks_left = 0;
@@ -171,6 +342,9 @@ static int jlj_start(struct gspca_dev *gspca_dev)
 		if (start_commands[i].ack_wanted)
 			jlj_read1(gspca_dev, response);
 	}
+	setcamquality(gspca_dev);
+	msleep(2);
+	setfreq(gspca_dev);
 	if (gspca_dev->usb_err < 0)
 		PDEBUG(D_ERR, "Start streaming command failed");
 	return gspca_dev->usb_err;
@@ -227,7 +401,12 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	struct sd *dev  = (struct sd *) gspca_dev;
 
 	dev->type = id->driver_info;
-	dev->quality  = 85;
+	gspca_dev->cam.ctrls = dev->ctrls;
+	dev->quality = QUALITY_DEF;
+	dev->ctrls[LIGHTFREQ].def = V4L2_CID_POWER_LINE_FREQUENCY_60HZ;
+	dev->ctrls[RED].def = RED_BALANCE_DEF;
+	dev->ctrls[GREEN].def = GREEN_BALANCE_DEF;
+	dev->ctrls[BLUE].def = BLUE_BALANCE_DEF;
 	PDEBUG(D_PROBE,
 		"JEILINJ camera detected"
 		" (vid/pid 0x%04X:0x%04X)", id->idVendor, id->idProduct);
@@ -304,6 +483,58 @@ static const struct usb_device_id device_table[] = {
 
 MODULE_DEVICE_TABLE(usb, device_table);
 
+static int sd_querymenu(struct gspca_dev *gspca_dev,
+			struct v4l2_querymenu *menu)
+{
+	switch (menu->id) {
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		switch (menu->index) {
+		case 0:	/* V4L2_CID_POWER_LINE_FREQUENCY_DISABLED */
+			strcpy((char *) menu->name, "disable");
+			return 0;
+		case 1:	/* V4L2_CID_POWER_LINE_FREQUENCY_50HZ */
+			strcpy((char *) menu->name, "50 Hz");
+			return 0;
+		case 2:	/* V4L2_CID_POWER_LINE_FREQUENCY_60HZ */
+			strcpy((char *) menu->name, "60 Hz");
+			return 0;
+		}
+		break;
+	}
+	return -EINVAL;
+}
+
+static int sd_set_jcomp(struct gspca_dev *gspca_dev,
+			struct v4l2_jpegcompression *jcomp)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (jcomp->quality < QUALITY_MIN)
+		sd->quality = QUALITY_MIN;
+	else if (jcomp->quality > QUALITY_MAX)
+		sd->quality = QUALITY_MAX;
+	else
+		sd->quality = jcomp->quality;
+	if (gspca_dev->streaming) {
+		jpeg_set_qual(sd->jpeg_hdr, sd->quality);
+		setcamquality(gspca_dev);
+	}
+	return 0;
+}
+
+static int sd_get_jcomp(struct gspca_dev *gspca_dev,
+			struct v4l2_jpegcompression *jcomp)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	memset(jcomp, 0, sizeof *jcomp);
+	jcomp->quality = sd->quality;
+	jcomp->jpeg_markers = V4L2_JPEG_MARKER_DHT
+			| V4L2_JPEG_MARKER_DQT;
+	return 0;
+}
+
+
 /* sub-driver description */
 static const struct sd_desc sd_desc_sakar_57379 = {
 	.name   = MODULE_NAME,
@@ -322,6 +553,11 @@ static const struct sd_desc sd_desc_sportscam_dv15 = {
 	.start  = sd_start,
 	.stopN  = sd_stopN,
 	.pkt_scan = sd_pkt_scan,
+	.ctrls = sd_ctrls,
+	.nctrls = ARRAY_SIZE(sd_ctrls),
+	.querymenu = sd_querymenu,
+	.get_jcomp = sd_get_jcomp,
+	.set_jcomp = sd_set_jcomp,
 };
 
 static const struct sd_desc *sd_desc[2] = {
-- 
1.7.0.4

