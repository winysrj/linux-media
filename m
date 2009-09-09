Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.221.181]:37084 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbZIIVnu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 17:43:50 -0400
Received: by qyk11 with SMTP id 11so4206679qyk.1
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 14:43:53 -0700 (PDT)
Date: Wed, 9 Sep 2009 17:43:51 -0400
From: James Blanford <jhblanford@gmail.com>
To: linux-media@vger.kernel.org,
	Erik =?ISO-8859-1?Q?Andr=E9n?= <erik.andren@gmail.com>
Subject: [Patch 2/2] stv06xx webcams with HDCS 1xxx sensors
Message-ID: <20090909174351.39b8f88f@blackbart.localnet.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quickcam Express 046d:0840 and maybe others

Driver version:  v 2.60 from 2.6.31-rc7

Due to rounding and clipping, exposure and gain settings do not map to
unique register values.  Rather than read the registers and report gain
and exposure that may be different than the values that were set, just
cache the latest values that were set and report them.  Reduce exposure
range from 0-65535 to 0-255 so libv4l's autogain doesn't take forever.
Remove vestiges of driver signal processing that is now handled by
libv4l.

Signed-off-by: James Blanford <jhblanford@gmail.com>
diff -upr a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c b/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c
--- a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c	2009-09-09 14:59:35.000000000 -0400
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c	2009-09-09 16:30:08.000000000 -0400
@@ -37,7 +37,7 @@ static const struct ctrl hdcs1x00_ctrl[]
 			.type		= V4L2_CTRL_TYPE_INTEGER,
 			.name		= "exposure",
 			.minimum	= 0x00,
-			.maximum	= 0xffff,
+			.maximum	= 0xff,
 			.step		= 0x1,
 			.default_value 	= HDCS_DEFAULT_EXPOSURE,
 			.flags         	= V4L2_CTRL_FLAG_SLIDER
@@ -120,6 +120,7 @@ struct hdcs {
 	} exp;
 
 	int psmp;
+	u8 exp_cache, gain_cache;
 };
 
 static int hdcs_reg_write_seq(struct sd *sd, u8 reg, u8 *vals, u8 len)
@@ -205,34 +206,8 @@ static int hdcs_get_exposure(struct gspc
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct hdcs *hdcs = sd->sensor_priv;
 
-	/* Column time period */
-	int ct;
-	/* Column processing period */
-	int cp;
-	/* Row processing period */
-	int rp;
-	int cycles;
-	int err;
-	int rowexp;
-	u16 data[2];
-
-	err = stv06xx_read_sensor(sd, HDCS_ROWEXPL, &data[0]);
-	if (err < 0)
-		return err;
-
-	err = stv06xx_read_sensor(sd, HDCS_ROWEXPH, &data[1]);
-	if (err < 0)
-		return err;
-
-	rowexp = (data[1] << 8) | data[0];
+	*val = hdcs->exp_cache;
 
-	ct = hdcs->exp.cto + hdcs->psmp + (HDCS_ADC_START_SIG_DUR + 2);
-	cp = hdcs->exp.cto + (hdcs->w * ct / 2);
-	rp = hdcs->exp.rs + cp;
-
-	cycles = rp * rowexp;
-	*val = cycles / HDCS_CLK_FREQ_MHZ;
-	PDEBUG(D_V4L2, "Read exposure %d", *val);
 	return 0;
 }
 
@@ -254,7 +229,10 @@ static int hdcs_set_exposure(struct gspc
 	int cycles, err;
 	u8 exp[14];
 
-	cycles = val * HDCS_CLK_FREQ_MHZ;
+	val &= 0xff;
+	hdcs->exp_cache = val;
+
+	cycles = val * HDCS_CLK_FREQ_MHZ * 257;
 
 	ct = hdcs->exp.cto + hdcs->psmp + (HDCS_ADC_START_SIG_DUR + 2);
 	cp = hdcs->exp.cto + (hdcs->w * ct / 2);
@@ -325,49 +303,42 @@ static int hdcs_set_exposure(struct gspc
 	return err;
 }
 
-static int hdcs_set_gains(struct sd *sd, u8 r, u8 g, u8 b)
+static int hdcs_set_gains(struct sd *sd, u8 g)
 {
+	struct hdcs *hdcs = sd->sensor_priv;
+	int err;
 	u8 gains[4];
 
+	hdcs->gain_cache = g;
+
 	/* the voltage gain Av = (1 + 19 * val / 127) * (1 + bit7) */
-	if (r > 127)
-		r = 0x80 | (r / 2);
 	if (g > 127)
 		g = 0x80 | (g / 2);
-	if (b > 127)
-		b = 0x80 | (b / 2);
 
 	gains[0] = g;
-	gains[1] = r;
-	gains[2] = b;
+	gains[1] = g;
+	gains[2] = g;
 	gains[3] = g;
 
-	return hdcs_reg_write_seq(sd, HDCS_ERECPGA, gains, 4);
+	err = hdcs_reg_write_seq(sd, HDCS_ERECPGA, gains, 4);
+		return err;
 }
 
 static int hdcs_get_gain(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	int err;
-	u16 data;
+	struct hdcs *hdcs = sd->sensor_priv;
 
-	err = stv06xx_read_sensor(sd, HDCS_ERECPGA, &data);
+	*val = hdcs->gain_cache;
 
-	/* Bit 7 doubles the gain */
-	if (data & 0x80)
-		*val = (data & 0x7f) * 2;
-	else
-		*val = data;
-
-	PDEBUG(D_V4L2, "Read gain %d", *val);
-	return err;
+	return 0;
 }
 
 static int hdcs_set_gain(struct gspca_dev *gspca_dev, __s32 val)
 {
 	PDEBUG(D_V4L2, "Writing gain %d", val);
 	return hdcs_set_gains((struct sd *) gspca_dev,
-			       val & 0xff, val & 0xff, val & 0xff);
+			       val & 0xff);
 }
 
 static int hdcs_set_size(struct sd *sd,
@@ -585,8 +556,7 @@ static int hdcs_init(struct sd *sd)
 	if (err < 0)
 		return err;
 
-	err = hdcs_set_gains(sd, HDCS_DEFAULT_GAIN, HDCS_DEFAULT_GAIN,
-			     HDCS_DEFAULT_GAIN);
+	err = hdcs_set_gains(sd, HDCS_DEFAULT_GAIN);
 	if (err < 0)
 		return err;
 
diff -upr a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h b/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h
--- a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h	2009-09-01 13:36:04.000000000 -0400
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h	2009-09-09 16:05:43.000000000 -0400
@@ -124,7 +124,7 @@
 #define HDCS_RUN_ENABLE		(1 << 2)
 #define HDCS_SLEEP_MODE		(1 << 1)
 
-#define HDCS_DEFAULT_EXPOSURE	5000
+#define HDCS_DEFAULT_EXPOSURE	48
 #define HDCS_DEFAULT_GAIN	128
 
 static int hdcs_probe_1x00(struct sd *sd);
