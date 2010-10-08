Return-path: <mchehab@pedra>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:22980 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759611Ab0JHVFm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Oct 2010 17:05:42 -0400
From: Daniel Drake <dsd@laptop.org>
To: corbet@lwn.net
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH 3/3] ov7670: Support customization of clock speed
Message-Id: <20101008210433.126649D401B@zog.reactivated.net>
Date: Fri,  8 Oct 2010 22:04:32 +0100 (BST)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

For accurate frame rate limiting, we need to know the speed of the external
clock wired into the ov7670 chip.

Add a module parameter so that the user can specify this information.
And add DMI detection for appropriate clock speeds on the OLPC XO-1 and
XO-1.5 laptops. If specified, the module parameter wins over whatever we
might have set through the DMI table.

Based on earlier work by Jonathan Corbet.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/ov7670.c |   71 ++++++++++++++++++++++++++++++++++++-----
 1 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 9fffcdd..c4d9ed0 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -16,6 +16,7 @@
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
+#include <linux/dmi.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-mediabus.h>
@@ -30,6 +31,19 @@ module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
 /*
+ * What is our fastest frame rate?  It's a function of how the chip
+ * is clocked, and this is an external clock, so we don't know. If we have
+ * a DMI entry describing the platform, use it. If not, assume 30. In both
+ * cases, accept override from a module parameter.
+ */
+static int clock_speed = 30;
+static bool clock_speed_from_param = false;
+static int set_clock_speed_from_param(const char *val, struct kernel_param *kp);
+module_param_call(clock_speed, set_clock_speed_from_param, param_get_int,
+		  &clock_speed, 0440);
+MODULE_PARM_DESC(clock_speed, "External clock speed (Hz)");
+
+/*
  * Basic window sizes.  These probably belong somewhere more globally
  * useful.
  */
@@ -43,11 +57,6 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 #define	QCIF_HEIGHT	144
 
 /*
- * Our nominal (default) frame rate.
- */
-#define OV7670_FRAME_RATE 30
-
-/*
  * The 7670 sits on i2c with ID 0x42
  */
 #define OV7670_I2C_ADDR 0x42
@@ -188,6 +197,44 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 #define REG_HAECC7	0xaa	/* Hist AEC/AGC control 7 */
 #define REG_BD60MAX	0xab	/* 60hz banding step limit */
 
+static int set_clock_speed_from_param(const char *val, struct kernel_param *kp)
+{
+	int ret = param_set_int(val, kp);
+	if (ret == 0)
+		clock_speed_from_param = true;
+	return ret;
+}
+
+static int __init set_clock_speed_from_dmi(const struct dmi_system_id *dmi)
+{
+	if (clock_speed_from_param)
+		return 0; /* module param beats DMI */
+
+	clock_speed = (int) dmi->driver_data;
+	return 0;
+}
+
+static const struct dmi_system_id __initconst dmi_clock_speeds[] = {
+	{
+		.callback = set_clock_speed_from_dmi,
+		.driver_data = (void *) 45,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "OLPC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "1"),
+		},
+	},
+	{
+		.callback = set_clock_speed_from_dmi,
+		.driver_data = (void *) 90,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "OLPC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "1.5"),
+		},
+	},
+	{ }
+};
 
 /*
  * Information we maintain about a known sensor.
@@ -861,7 +908,7 @@ static int ov7670_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
 	memset(cp, 0, sizeof(struct v4l2_captureparm));
 	cp->capability = V4L2_CAP_TIMEPERFRAME;
 	cp->timeperframe.numerator = 1;
-	cp->timeperframe.denominator = OV7670_FRAME_RATE;
+	cp->timeperframe.denominator = clock_speed;
 	if ((info->clkrc & CLK_EXT) == 0 && (info->clkrc & CLK_SCALE) > 1)
 		cp->timeperframe.denominator /= (info->clkrc & CLK_SCALE);
 	return 0;
@@ -882,14 +929,14 @@ static int ov7670_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
 	if (tpf->numerator == 0 || tpf->denominator == 0)
 		div = 1;  /* Reset to full rate */
 	else
-		div = (tpf->numerator*OV7670_FRAME_RATE)/tpf->denominator;
+		div = (tpf->numerator*clock_speed)/tpf->denominator;
 	if (div == 0)
 		div = 1;
 	else if (div > CLK_SCALE)
 		div = CLK_SCALE;
 	info->clkrc = (info->clkrc & 0x80) | div;
 	tpf->numerator = 1;
-	tpf->denominator = OV7670_FRAME_RATE/div;
+	tpf->denominator = clock_speed/div;
 	return ov7670_write(sd, REG_CLKRC, info->clkrc);
 }
 
@@ -1510,10 +1557,15 @@ static int ov7670_probe(struct i2c_client *client,
 	}
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
 			client->addr << 1, client->adapter->name);
+	/*
+	 * Make sure the clock speed is rational.
+	 */
+	if (clock_speed < 1 || clock_speed > 100)
+		clock_speed = 30;
 
 	info->fmt = &ov7670_formats[0];
 	info->sat = 128;	/* Review this */
-	info->clkrc = 1;	/* 30fps */
+	info->clkrc = clock_speed / 30;
 
 	return 0;
 }
@@ -1546,6 +1598,7 @@ static struct i2c_driver ov7670_driver = {
 
 static __init int init_ov7670(void)
 {
+	dmi_check_system(dmi_clock_speeds);
 	return i2c_add_driver(&ov7670_driver);
 }
 
-- 
1.7.2.3

