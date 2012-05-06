Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:35782 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab2EFKPP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 May 2012 06:15:15 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-input@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH v2 3/3] gspca - ov534: Add Hue control
Date: Sun,  6 May 2012 12:14:58 +0200
Message-Id: <1336299298-17517-4-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1336299298-17517-1-git-send-email-ospite@studenti.unina.it>
References: <20120505102614.31395c2979f0b7aac0c8a107@studenti.unina.it>
 <1336299298-17517-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---

Changes since version 1:

  - Disabled the HUE control for SENSOR_OV767x

 drivers/media/video/gspca/ov534.c |   65 +++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/gspca/ov534.c b/drivers/media/video/gspca/ov534.c
index c15cf23..b5acb1e 100644
--- a/drivers/media/video/gspca/ov534.c
+++ b/drivers/media/video/gspca/ov534.c
@@ -34,6 +34,8 @@
 
 #include "gspca.h"
 
+#include <linux/fixp-arith.h>
+
 #define OV534_REG_ADDRESS	0xf1	/* sensor address */
 #define OV534_REG_SUBADDR	0xf2
 #define OV534_REG_WRITE		0xf3
@@ -53,6 +55,7 @@ MODULE_LICENSE("GPL");
 
 /* controls */
 enum e_ctrl {
+	HUE,
 	SATURATION,
 	BRIGHTNESS,
 	CONTRAST,
@@ -87,6 +90,7 @@ enum sensors {
 };
 
 /* V4L2 controls supported by the driver */
+static void sethue(struct gspca_dev *gspca_dev);
 static void setsaturation(struct gspca_dev *gspca_dev);
 static void setbrightness(struct gspca_dev *gspca_dev);
 static void setcontrast(struct gspca_dev *gspca_dev);
@@ -103,6 +107,18 @@ static int sd_start(struct gspca_dev *gspca_dev);
 static void sd_stopN(struct gspca_devSENSOR_OV767x *gspca_dev);
 
 static const struct ctrl sd_ctrls[] = {
+[HUE] = {
+		{
+			.id      = V4L2_CID_HUE,
+			.type    = V4L2_CTRL_TYPE_INTEGER,
+			.name    = "Hue",
+			.minimum = -90,
+			.maximum = 90,
+			.step    = 1,
+			.default_value = 0,
+		},
+		.set_control = sethue
+	},
 [SATURATION] = {
 		{
 			.id      = V4L2_CID_SATURATION,
@@ -684,7 +700,7 @@ static const u8 sensor_init_772x[][2] = {
 	{ 0x9c, 0x20 },
 	{ 0x9e, 0x81 },
 
-	{ 0xa6, 0x06 },
+	{ 0xa6, 0x07 },
 	{ 0x7e, 0x0c },
 	{ 0x7f, 0x16 },
 	{ 0x80, 0x2a },
@@ -955,6 +971,48 @@ static void set_frame_rate(struct gspca_dev *gspca_dev)
 	PDEBUG(D_PROBE, "frame_rate: %d", r->fps);
 }
 
+static void sethue(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int val;
+
+	val = sd->ctrls[HUE].val;
+	if (sd->sensor == SENSOR_OV767x) {
+		/* TBD */
+	} else {
+		s16 huesin;
+		s16 huecos;
+
+		/* fixp_sin and fixp_cos accept only positive values, while
+		 * our val is between -90 and 90
+		 */
+		val += 360;
+
+		/* According to the datasheet the registers expect HUESIN and
+		 * HUECOS to be the result of the trigonometric functions,
+		 * scaled by 0x80.
+		 *
+		 * The 0x100 here represents the maximun absolute value
+		 * returned byt fixp_sin and fixp_cos, so the scaling will
+		 * consider the result like in the interval [-1.0, 1.0].
+		 */
+		huesin = fixp_sin(val) * 0x80 / 0x100;
+		huecos = fixp_cos(val) * 0x80 / 0x100;
+
+		if (huesin < 0) {
+			sccb_reg_write(gspca_dev, 0xab,
+				sccb_reg_read(gspca_dev, 0xab) | 0x2);
+			huesin = -huesin;
+		} else {
+			sccb_reg_write(gspca_dev, 0xab,
+				sccb_reg_read(gspca_dev, 0xab) & ~0x2);
+
+		}
+		sccb_reg_write(gspca_dev, 0xa9, (u8)huecos);
+		sccb_reg_write(gspca_dev, 0xaa, (u8)huesin);
+	}
+}
+
 static void setsaturation(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -1231,7 +1289,8 @@ static int sd_init(struct gspca_dev *gspca_dev)
 
 	if ((sensor_id & 0xfff0) == 0x7670) {
 		sd->sensor = SENSOR_OV767x;
-		gspca_dev->ctrl_dis = (1 << GAIN) |
+		gspca_dev->ctrl_dis = (1 << HUE) |
+					(1 << GAIN) |
 					(1 << AGC) |
 					(1 << SHARPNESS);	/* auto */
 		sd->ctrls[SATURATION].min = 0,
@@ -1310,6 +1369,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	set_frame_rate(gspca_dev);
 
+	if (!(gspca_dev->ctrl_dis & (1 << HUE)))
+		sethue(gspca_dev);
 	setsaturation(gspca_dev);
 	if (!(gspca_dev->ctrl_dis & (1 << AGC)))
 		setagc(gspca_dev);
-- 
1.7.10

