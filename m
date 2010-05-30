Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64087 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0E3WZ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 18:25:56 -0400
Received: by wwb28 with SMTP id 28so913962wwb.19
        for <linux-media@vger.kernel.org>; Sun, 30 May 2010 15:25:54 -0700 (PDT)
Subject: [PATCH 2/3] Gspca-gl860 - MI2030 sensor subdriver rewrite
From: Olivier Lorin <olorin75@gmail.com>
To: V4L Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain
Date: Mon, 31 May 2010 00:25:50 +0200
Message-Id: <1275258350.18267.25.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gspca - gl860: new driver for MI2020 sensor

From: Olivier Lorin <o.lorin@laposte.net>

- new MI2020 driver version made from a webcam given to me
- remove all previous flavors of this driver

Priority: normal

Signed-off-by: Olivier Lorin <o.lorin@laposte.net>

diff -urpN der_gl860i1/gl860.c gl860/gl860.c
--- der_gl860i1/gl860.c	2010-04-28 23:26:53.000000000 +0200
+++ gl860/gl860.c	2010-04-29 21:01:15.000000000 +0200
@@ -91,7 +91,6 @@ SD_SETGET(contrast)
 /* control table */
 static struct ctrl sd_ctrls_mi1320[GL860_NCTRLS];
 static struct ctrl sd_ctrls_mi2020[GL860_NCTRLS];
-static struct ctrl sd_ctrls_mi2020b[GL860_NCTRLS];
 static struct ctrl sd_ctrls_ov2640[GL860_NCTRLS];
 static struct ctrl sd_ctrls_ov9655[GL860_NCTRLS];
 
@@ -121,8 +120,6 @@ static int gl860_build_control_table(str
 		sd_ctrls = sd_ctrls_mi1320;
 	else if (_MI2020_)
 		sd_ctrls = sd_ctrls_mi2020;
-	else if (_MI2020b_)
-		sd_ctrls = sd_ctrls_mi2020b;
 	else if (_OV2640_)
 		sd_ctrls = sd_ctrls_ov2640;
 	else if (_OV9655_)
@@ -187,19 +184,6 @@ static const struct sd_desc sd_desc_mi20
 	.dq_callback = sd_callback,
 };
 
-static const struct sd_desc sd_desc_mi2020b = {
-	.name        = MODULE_NAME,
-	.ctrls       = sd_ctrls_mi2020b,
-	.nctrls      = GL860_NCTRLS,
-	.config      = sd_config,
-	.init        = sd_init,
-	.isoc_init   = sd_isoc_init,
-	.start       = sd_start,
-	.stop0       = sd_stop0,
-	.pkt_scan    = sd_pkt_scan,
-	.dq_callback = sd_callback,
-};
-
 static const struct sd_desc sd_desc_ov2640 = {
 	.name        = MODULE_NAME,
 	.ctrls       = sd_ctrls_ov2640,
@@ -344,8 +328,6 @@ static int sd_config(struct gspca_dev *g
 		sd->sensor = ID_OV9655;
 	else if (strcmp(sensor, "MI2020") == 0)
 		sd->sensor = ID_MI2020;
-	else if (strcmp(sensor, "MI2020b") == 0)
-		sd->sensor = ID_MI2020b;
 
 	/* Get sensor and set the suitable init/start/../stop functions */
 	if (gl860_guess_sensor(gspca_dev, vendor_id, product_id) == -1)
@@ -369,13 +351,6 @@ static int sd_config(struct gspca_dev *g
 		dev_init_settings   = mi2020_init_settings;
 		break;
 
-	case ID_MI2020b:
-		gspca_dev->sd_desc = &sd_desc_mi2020b;
-		cam->cam_mode = mi2020_mode;
-		cam->nmodes = ARRAY_SIZE(mi2020_mode);
-		dev_init_settings   = mi2020_init_settings;
-		break;
-
 	case ID_OV2640:
 		gspca_dev->sd_desc = &sd_desc_ov2640;
 		cam->cam_mode = ov2640_mode;
@@ -620,7 +595,7 @@ int gl860_RTx(struct gspca_dev *gspca_de
 	else if (len > 1 && r < len)
 		PDEBUG(D_ERR, "short ctrl transfer %d/%d", r, len);
 
-	if ((_MI2020_ || _MI2020b_ || _MI2020c_) && (val || index))
+	if (_MI2020_ && (val || index))
 		msleep(1);
 	if (_OV2640_)
 		msleep(1);
@@ -767,8 +742,6 @@ static int gl860_guess_sensor(struct gsp
 		PDEBUG(D_PROBE, "05e3:f191 sensor MI1320 (1.3M)");
 	} else if (_MI2020_) {
 		PDEBUG(D_PROBE, "05e3:0503 sensor MI2020 (2.0M)");
-	} else if (_MI2020b_) {
-		PDEBUG(D_PROBE, "05e3:0503 sensor MI2020 alt. driver (2.0M)");
 	} else if (_OV9655_) {
 		PDEBUG(D_PROBE, "05e3:0503 sensor OV9655 (1.3M)");
 	} else if (_OV2640_) {
diff -urpN der_gl860i1/gl860.h gl860/gl860.h
--- der_gl860i1/gl860.h	2010-04-28 13:56:51.000000000 +0200
+++ gl860/gl860.h	2010-04-28 13:36:36.000000000 +0200
@@ -32,12 +32,9 @@
 #define ID_OV2640   2
 #define ID_OV9655   4
 #define ID_MI2020   8
-#define ID_MI2020b 16
 
 #define _MI1320_  (((struct sd *) gspca_dev)->sensor == ID_MI1320)
 #define _MI2020_  (((struct sd *) gspca_dev)->sensor == ID_MI2020)
-#define _MI2020b_ (((struct sd *) gspca_dev)->sensor == ID_MI2020b)
-#define _MI2020c_ 0
 #define _OV2640_  (((struct sd *) gspca_dev)->sensor == ID_OV2640)
 #define _OV9655_  (((struct sd *) gspca_dev)->sensor == ID_OV9655)
 
diff -urpN der_gl860i1/gl860-mi2020.c gl860/gl860-mi2020.c
--- der_gl860i1/gl860-mi2020.c	2009-12-30 18:19:11.000000000 +0100
+++ gl860/gl860-mi2020.c	2010-05-30 23:41:56.000000000 +0200
@@ -1,6 +1,7 @@
 /* Subdriver for the GL860 chip with the MI2020 sensor
- * Author Olivier LORIN, from Ice/Soro2005's logs(A), Fret_saw/Hulkie's
- * logs(B) and Tricid"s logs(C). With the help of
Kytrix/BUGabundo/Blazercist.
+ * Author Olivier LORIN, from logs by Iceman/Soro2005 +
Fret_saw/Hulkie/Tricid
+ * with the help of Kytrix/BUGabundo/Blazercist.
+ * Driver achieved thanks to a webcam gift by Kytrix.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -20,47 +21,70 @@
 
 #include "gl860.h"
 
+static u8 dat_wbal1[] = {0x8c, 0xa2, 0x0c};
+
 static u8 dat_bright1[] = {0x8c, 0xa2, 0x06};
 static u8 dat_bright3[] = {0x8c, 0xa1, 0x02};
 static u8 dat_bright4[] = {0x90, 0x00, 0x0f};
 static u8 dat_bright5[] = {0x8c, 0xa1, 0x03};
 static u8 dat_bright6[] = {0x90, 0x00, 0x05};
 
-static u8 dat_dummy1[] = {0x90, 0x00, 0x06};
-/*static u8 dummy2[] = {0x8c, 0xa1, 0x02};*/
-/*static u8 dummy3[] = {0x90, 0x00, 0x1f};*/
-
 static u8 dat_hvflip1[] = {0x8c, 0x27, 0x19};
 static u8 dat_hvflip3[] = {0x8c, 0x27, 0x3b};
 static u8 dat_hvflip5[] = {0x8c, 0xa1, 0x03};
 static u8 dat_hvflip6[] = {0x90, 0x00, 0x06};
 
+static struct idxdata tbl_middle_hvflip_low[] = {
+	{0x33, "\x90\x00\x06"},
+	{6, "\xff\xff\xff"},
+	{0x33, "\x90\x00\x06"},
+	{6, "\xff\xff\xff"},
+	{0x33, "\x90\x00\x06"},
+	{6, "\xff\xff\xff"},
+	{0x33, "\x90\x00\x06"},
+	{6, "\xff\xff\xff"},
+};
+
+static struct idxdata tbl_middle_hvflip_big[] = {
+	{0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x01"}, {0x33, "\x8c\xa1
\x20"},
+	{0x33, "\x90\x00\x00"}, {0x33, "\x8c\xa7\x02"}, {0x33, "\x90\x00
\x00"},
+	{102, "\xff\xff\xff"},
+	{0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x02"}, {0x33, "\x8c\xa1
\x20"},
+	{0x33, "\x90\x00\x72"}, {0x33, "\x8c\xa7\x02"}, {0x33, "\x90\x00
\x01"},
+};
+
+static struct idxdata tbl_end_hvflip[] = {
+	{0x33, "\x8c\xa1\x02"}, {0x33, "\x90\x00\x1f"},
+	{6, "\xff\xff\xff"},
+	{0x33, "\x8c\xa1\x02"}, {0x33, "\x90\x00\x1f"},
+	{6, "\xff\xff\xff"},
+	{0x33, "\x8c\xa1\x02"}, {0x33, "\x90\x00\x1f"},
+	{6, "\xff\xff\xff"},
+	{0x33, "\x8c\xa1\x02"}, {0x33, "\x90\x00\x1f"},
+};
+
 static u8 dat_freq1[] = { 0x8c, 0xa4, 0x04 };
 
 static u8 dat_multi5[] = { 0x8c, 0xa1, 0x03 };
 static u8 dat_multi6[] = { 0x90, 0x00, 0x05 };
 
-static struct validx tbl_common1[] = {
-	{0x0000, 0x0000},
-	{1, 0xffff}, /* msleep(35); */
-	{0x006a, 0x0007}, {0x0063, 0x0006}, {0x006a, 0x000d}, {0x0000,
0x00c0},
-	{0x0010, 0x0010}, {0x0003, 0x00c1}, {0x0042, 0x00c2}, {0x0004,
0x00d8},
-	{0x0000, 0x0058}, {0x0002, 0x0004}, {0x0041, 0x0000},
+static struct validx tbl_init_at_startup[] = {
+	{0x0000, 0x0000}, {0x0010, 0x0010}, {0x0008, 0x00c0}, {0x0001,
0x00c1},
+	{0x0001, 0x00c2}, {0x0020, 0x0006}, {0x006a, 0x000d},
+	{53, 0xffff},
+	{0x0040, 0x0000}, {0x0063, 0x0006},
 };
 
-static struct validx tbl_common2[] = {
-	{0x006a, 0x0007},
-	{35, 0xffff},
-	{0x00ef, 0x0006},
-	{35, 0xffff},
-	{0x006a, 0x000d},
-	{35, 0xffff},
+static struct validx tbl_common_0B[] = {
+	{0x0002, 0x0004}, {0x006a, 0x0007}, {0x00ef, 0x0006}, {0x006a,
0x000d},
 	{0x0000, 0x00c0}, {0x0010, 0x0010}, {0x0003, 0x00c1}, {0x0042,
0x00c2},
 	{0x0004, 0x00d8}, {0x0000, 0x0058}, {0x0041, 0x0000},
 };
 
-static struct idxdata tbl_common3[] = {
-	{0x32, "\x02\x00\x08"}, {0x33, "\xf4\x03\x1d"},
+static struct idxdata tbl_common_3B[] = {
+	{0x33, "\x86\x25\x01"}, {0x33, "\x86\x25\x00"},
+	{2, "\xff\xff\xff"},
+	{0x30, "\x1a\x0a\xcc"}, {0x32, "\x02\x00\x08"}, {0x33, "\xf4\x03
\x1d"},
 	{6, "\xff\xff\xff"}, /* 12 */
 	{0x34, "\x1e\x8f\x09"}, {0x34, "\x1c\x01\x28"}, {0x34, "\x1e\x8f
\x09"},
 	{2, "\xff\xff\xff"}, /* - */
@@ -98,85 +122,58 @@ static struct idxdata tbl_common3[] = {
 	{0x35, "\x50\x00\x06"}, {0x35, "\x48\x07\xff"}, {0x35, "\x60\x05
\x89"},
 	{0x35, "\x58\x07\xff"}, {0x35, "\x40\x00\xa0"}, {0x35, "\x42\x00
\x00"},
 	{0x32, "\x10\x01\xfc"}, {0x33, "\x8c\xa1\x18"}, {0x33, "\x90\x00
\x3c"},
-	{1, "\xff\xff\xff"},
 	{0x33, "\x78\x00\x00"},
-	{1, "\xff\xff\xff"},
+	{2, "\xff\xff\xff"},
 	{0x35, "\xb8\x1f\x20"}, {0x33, "\x8c\xa2\x06"}, {0x33, "\x90\x00
\x10"},
 	{0x33, "\x8c\xa2\x07"}, {0x33, "\x90\x00\x08"}, {0x33, "\x8c\xa2
\x42"},
 	{0x33, "\x90\x00\x0b"}, {0x33, "\x8c\xa2\x4a"}, {0x33, "\x90\x00
\x8c"},
 	{0x35, "\xba\xfa\x08"}, {0x33, "\x8c\xa2\x02"}, {0x33, "\x90\x00
\x22"},
-	{0x33, "\x8c\xa2\x03"}, {0x33, "\x90\x00\xbb"},
-};
-
-static struct idxdata tbl_common4[] = {
-	{0x33, "\x8c\x22\x2e"}, {0x33, "\x90\x00\xa0"}, {0x33, "\x8c\xa4
\x08"},
+	{0x33, "\x8c\xa2\x03"}, {0x33, "\x90\x00\xbb"}, {0x33, "\x8c\xa4
\x04"},
+	{0x33, "\x90\x00\x80"}, {0x33, "\x8c\xa7\x9d"}, {0x33, "\x90\x00
\x00"},
+	{0x33, "\x8c\xa7\x9e"}, {0x33, "\x90\x00\x00"}, {0x33, "\x8c\xa2
\x0c"},
+	{0x33, "\x90\x00\x17"}, {0x33, "\x8c\xa2\x15"}, {0x33, "\x90\x00
\x04"},
+	{0x33, "\x8c\xa2\x14"}, {0x33, "\x90\x00\x20"}, {0x33, "\x8c\xa1
\x03"},
+	{0x33, "\x90\x00\x00"}, {0x33, "\x8c\x27\x17"}, {0x33, "\x90\x21
\x11"},
+	{0x33, "\x8c\x27\x1b"}, {0x33, "\x90\x02\x4f"}, {0x33, "\x8c\x27
\x25"},
+	{0x33, "\x90\x06\x0f"}, {0x33, "\x8c\x27\x39"}, {0x33, "\x90\x21
\x11"},
+	{0x33, "\x8c\x27\x3d"}, {0x33, "\x90\x01\x20"}, {0x33, "\x8c\x27
\x47"},
+	{0x33, "\x90\x09\x4c"}, {0x33, "\x8c\x27\x03"}, {0x33, "\x90\x02
\x84"},
+	{0x33, "\x8c\x27\x05"}, {0x33, "\x90\x01\xe2"}, {0x33, "\x8c\x27
\x07"},
+	{0x33, "\x90\x06\x40"}, {0x33, "\x8c\x27\x09"}, {0x33, "\x90\x04
\xb0"},
+	{0x33, "\x8c\x27\x0d"}, {0x33, "\x90\x00\x00"}, {0x33, "\x8c\x27
\x0f"},
+	{0x33, "\x90\x00\x00"}, {0x33, "\x8c\x27\x11"}, {0x33, "\x90\x04
\xbd"},
+	{0x33, "\x8c\x27\x13"}, {0x33, "\x90\x06\x4d"}, {0x33, "\x8c\x27
\x15"},
+	{0x33, "\x90\x00\x00"}, {0x33, "\x8c\x27\x17"}, {0x33, "\x90\x21
\x11"},
+	{0x33, "\x8c\x27\x19"}, {0x33, "\x90\x04\x6c"}, {0x33, "\x8c\x27
\x1b"},
+	{0x33, "\x90\x02\x4f"}, {0x33, "\x8c\x27\x1d"}, {0x33, "\x90\x01
\x02"},
+	{0x33, "\x8c\x27\x1f"}, {0x33, "\x90\x02\x79"}, {0x33, "\x8c\x27
\x21"},
+	{0x33, "\x90\x01\x55"}, {0x33, "\x8c\x27\x23"}, {0x33, "\x90\x02
\x85"},
+	{0x33, "\x8c\x27\x25"}, {0x33, "\x90\x06\x0f"}, {0x33, "\x8c\x27
\x27"},
+	{0x33, "\x90\x20\x20"}, {0x33, "\x8c\x27\x29"}, {0x33, "\x90\x20
\x20"},
+	{0x33, "\x8c\x27\x2b"}, {0x33, "\x90\x10\x20"}, {0x33, "\x8c\x27
\x2d"},
+	{0x33, "\x90\x20\x07"}, {0x33, "\x8c\x27\x2f"}, {0x33, "\x90\x00
\x04"},
+	{0x33, "\x8c\x27\x31"}, {0x33, "\x90\x00\x04"}, {0x33, "\x8c\x27
\x33"},
+	{0x33, "\x90\x04\xbb"}, {0x33, "\x8c\x27\x35"}, {0x33, "\x90\x06
\x4b"},
+	{0x33, "\x8c\x27\x37"}, {0x33, "\x90\x00\x00"}, {0x33, "\x8c\x27
\x39"},
+	{0x33, "\x90\x21\x11"}, {0x33, "\x8c\x27\x3b"}, {0x33, "\x90\x00
\x24"},
+	{0x33, "\x8c\x27\x3d"}, {0x33, "\x90\x01\x20"}, {0x33, "\x8c\x27
\x41"},
+	{0x33, "\x90\x01\x69"}, {0x33, "\x8c\x27\x45"}, {0x33, "\x90\x04
\xed"},
+	{0x33, "\x8c\x27\x47"}, {0x33, "\x90\x09\x4c"}, {0x33, "\x8c\x27
\x51"},
+	{0x33, "\x90\x00\x00"}, {0x33, "\x8c\x27\x53"}, {0x33, "\x90\x03
\x20"},
+	{0x33, "\x8c\x27\x55"}, {0x33, "\x90\x00\x00"}, {0x33, "\x8c\x27
\x57"},
+	{0x33, "\x90\x02\x58"}, {0x33, "\x8c\x27\x5f"}, {0x33, "\x90\x00
\x00"},
+	{0x33, "\x8c\x27\x61"}, {0x33, "\x90\x06\x40"}, {0x33, "\x8c\x27
\x63"},
+	{0x33, "\x90\x00\x00"}, {0x33, "\x8c\x27\x65"}, {0x33, "\x90\x04
\xb0"},
+	{0x33, "\x8c\x22\x2e"}, {0x33, "\x90\x00\xa1"}, {0x33, "\x8c\xa4
\x08"},
 	{0x33, "\x90\x00\x1f"}, {0x33, "\x8c\xa4\x09"}, {0x33, "\x90\x00
\x21"},
 	{0x33, "\x8c\xa4\x0a"}, {0x33, "\x90\x00\x25"}, {0x33, "\x8c\xa4
\x0b"},
-	{0x33, "\x90\x00\x27"}, {0x33, "\x8c\x24\x11"}, {0x33, "\x90\x00
\xa0"},
-	{0x33, "\x8c\x24\x13"}, {0x33, "\x90\x00\xc0"}, {0x33, "\x8c\x24
\x15"},
-	{0x33, "\x90\x00\xa0"}, {0x33, "\x8c\x24\x17"}, {0x33, "\x90\x00
\xc0"},
-};
-
-static struct idxdata tbl_common5[] = {
-	{0x33, "\x8c\xa4\x04"}, {0x33, "\x90\x00\x80"}, {0x33, "\x8c\xa7
\x9d"},
-	{0x33, "\x90\x00\x00"}, {0x33, "\x8c\xa7\x9e"}, {0x33, "\x90\x00
\x00"},
-	{0x33, "\x8c\xa2\x0c"}, {0x33, "\x90\x00\x17"}, {0x33, "\x8c\xa2
\x15"},
-	{0x33, "\x90\x00\x04"}, {0x33, "\x8c\xa2\x14"}, {0x33, "\x90\x00
\x20"},
-	{0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x00"}, {0x33, "\x8c\x27
\x17"},
-	/* msleep(53); */
-	{0x33, "\x90\x21\x11"}, {0x33, "\x8c\x27\x1b"}, {0x33, "\x90\x02
\x4f"},
-	{0x33, "\x8c\x27\x25"}, {0x33, "\x90\x06\x0f"}, {0x33, "\x8c\x27
\x39"},
-	{0x33, "\x90\x21\x11"}, {0x33, "\x8c\x27\x3d"}, {0x33, "\x90\x01
\x20"},
-	{0x33, "\x8c\x27\x47"}, {0x33, "\x90\x09\x4c"}, {0x33, "\x8c\x27
\x03"},
-	{0x33, "\x90\x02\x84"}, {0x33, "\x8c\x27\x05"}, {0x33, "\x90\x01
\xe2"},
-	{0x33, "\x8c\x27\x07"}, {0x33, "\x90\x06\x40"}, {0x33, "\x8c\x27
\x09"},
-	{0x33, "\x90\x04\xb0"}, {0x33, "\x8c\x27\x0d"}, {0x33, "\x90\x00
\x00"},
-	{0x33, "\x8c\x27\x0f"}, {0x33, "\x90\x00\x00"}, {0x33, "\x8c\x27
\x11"},
-	{0x33, "\x90\x04\xbd"}, {0x33, "\x8c\x27\x13"}, {0x33, "\x90\x06
\x4d"},
-	{0x33, "\x8c\x27\x15"}, {0x33, "\x90\x00\x00"}, {0x33, "\x8c\x27
\x17"},
-	{0x33, "\x90\x21\x11"}, {0x33, "\x8c\x27\x19"}, {0x33, "\x90\x04
\x6c"},
-	{0x33, "\x8c\x27\x1b"}, {0x33, "\x90\x02\x4f"}, {0x33, "\x8c\x27
\x1d"},
-	{0x33, "\x90\x01\x02"}, {0x33, "\x8c\x27\x1f"}, {0x33, "\x90\x02
\x79"},
-	{0x33, "\x8c\x27\x21"}, {0x33, "\x90\x01\x55"}, {0x33, "\x8c\x27
\x23"},
-	{0x33, "\x90\x02\x85"}, {0x33, "\x8c\x27\x25"}, {0x33, "\x90\x06
\x0f"},
-	{0x33, "\x8c\x27\x27"}, {0x33, "\x90\x20\x20"}, {0x33, "\x8c\x27
\x29"},
-	{0x33, "\x90\x20\x20"}, {0x33, "\x8c\x27\x2b"}, {0x33, "\x90\x10
\x20"},
-	{0x33, "\x8c\x27\x2d"}, {0x33, "\x90\x20\x07"}, {0x33, "\x8c\x27
\x2f"},
-	{0x33, "\x90\x00\x04"}, {0x33, "\x8c\x27\x31"}, {0x33, "\x90\x00
\x04"},
-	{0x33, "\x8c\x27\x33"}, {0x33, "\x90\x04\xbb"}, {0x33, "\x8c\x27
\x35"},
-	{0x33, "\x90\x06\x4b"}, {0x33, "\x8c\x27\x37"}, {0x33, "\x90\x00
\x00"},
-	{0x33, "\x8c\x27\x39"}, {0x33, "\x90\x21\x11"}, {0x33, "\x8c\x27
\x3b"},
-	{0x33, "\x90\x00\x24"}, {0x33, "\x8c\x27\x3d"}, {0x33, "\x90\x01
\x20"},
-	{0x33, "\x8c\x27\x41"}, {0x33, "\x90\x01\x69"}, {0x33, "\x8c\x27
\x45"},
-	{0x33, "\x90\x04\xed"}, {0x33, "\x8c\x27\x47"}, {0x33, "\x90\x09
\x4c"},
-	{0x33, "\x8c\x27\x51"}, {0x33, "\x90\x00\x00"}, {0x33, "\x8c\x27
\x53"},
-	{0x33, "\x90\x03\x20"}, {0x33, "\x8c\x27\x55"}, {0x33, "\x90\x00
\x00"},
-	{0x33, "\x8c\x27\x57"}, {0x33, "\x90\x02\x58"}, {0x33, "\x8c\x27
\x5f"},
-	{0x33, "\x90\x00\x00"}, {0x33, "\x8c\x27\x61"}, {0x33, "\x90\x06
\x40"},
-	{0x33, "\x8c\x27\x63"}, {0x33, "\x90\x00\x00"}, {0x33, "\x8c\x27
\x65"},
-	{0x33, "\x90\x04\xb0"}, {0x33, "\x8c\x22\x2e"}, {0x33, "\x90\x00
\xa1"},
-	{0x33, "\x8c\xa4\x08"}, {0x33, "\x90\x00\x1f"}, {0x33, "\x8c\xa4
\x09"},
-	{0x33, "\x90\x00\x21"}, {0x33, "\x8c\xa4\x0a"}, {0x33, "\x90\x00
\x25"},
-	{0x33, "\x8c\xa4\x0b"}, {0x33, "\x90\x00\x27"}, {0x33, "\x8c\x24
\x11"},
-	{0x33, "\x90\x00\xa1"}, {0x33, "\x8c\x24\x13"}, {0x33, "\x90\x00
\xc1"},
-	{0x33, "\x8c\x24\x15"},
-};
-
-static struct validx tbl_init_at_startup[] = {
-	{0x0000, 0x0000},
-	{53, 0xffff},
-	{0x0010, 0x0010},
-	{53, 0xffff},
-	{0x0008, 0x00c0},
-	{53, 0xffff},
-	{0x0001, 0x00c1},
-	{53, 0xffff},
-	{0x0001, 0x00c2},
-	{53, 0xffff},
-	{0x0020, 0x0006},
-	{53, 0xffff},
-	{0x006a, 0x000d},
-	{53, 0xffff},
+	{0x33, "\x90\x00\x27"}, {0x33, "\x8c\x24\x11"}, {0x33, "\x90\x00
\xa1"},
+	{0x33, "\x8c\x24\x13"}, {0x33, "\x90\x00\xc1"}, {0x33, "\x8c\x24
\x15"},
+	{0x33, "\x90\x00\x6a"}, {0x33, "\x8c\x24\x17"}, {0x33, "\x90\x00
\x80"},
+	{0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x05"},
+	{2, "\xff\xff\xff"},
+	{0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x06"},
+	{3, "\xff\xff\xff"},
 };
 
 static struct idxdata tbl_init_post_alt_low1[] = {
@@ -209,7 +206,7 @@ static struct idxdata tbl_init_post_alt_
 	{2, "\xff\xff\xff"},
 	{0x33, "\x8c\xa1\x20"}, {0x33, "\x90\x00\x00"}, {0x33, "\x8c\xa1
\x03"},
 	{0x33, "\x90\x00\x01"}, {0x33, "\x8c\xa7\x02"}, {0x33, "\x90\x00
\x00"},
-	{2, "\xff\xff\xff"}, /* - * */
+	{2, "\xff\xff\xff"},
 	{0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x05"},
 	{2, "\xff\xff\xff"},
 	{0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x06"},
@@ -217,61 +214,15 @@ static struct idxdata tbl_init_post_alt_
 	{0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x05"},
 	{2, "\xff\xff\xff"},
 	{0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x06"},
-	{1, "\xff\xff\xff"},
 };
 
-static struct idxdata tbl_init_post_alt_low4[] = {
-	{0x32, "\x10\x01\xf8"}, {0x34, "\xce\x01\xa8"}, {0x34, "\xd0\x66
\x33"},
-	{0x34, "\xd2\x31\x9a"}, {0x34, "\xd4\x94\x63"}, {0x34, "\xd6\x4b
\x25"},
-	{0x34, "\xd8\x26\x70"}, {0x34, "\xda\x72\x4c"}, {0x34, "\xdc\xff
\x04"},
-	{0x34, "\xde\x01\x5b"}, {0x34, "\xe6\x01\x13"}, {0x34, "\xee\x0b
\xf0"},
-	{0x34, "\xf6\x0b\xa4"}, {0x35, "\x00\xf6\xe7"}, {0x35, "\x08\x0d
\xfd"},
-	{0x35, "\x10\x25\x63"}, {0x35, "\x18\x35\x6c"}, {0x35, "\x20\x42
\x7e"},
-	{0x35, "\x28\x19\x44"}, {0x35, "\x30\x39\xd4"}, {0x35, "\x38\xf5
\xa8"},
-	{0x35, "\x4c\x07\x90"}, {0x35, "\x44\x07\xb8"}, {0x35, "\x5c\x06
\x88"},
-	{0x35, "\x54\x07\xff"}, {0x34, "\xe0\x01\x52"}, {0x34, "\xe8\x00
\xcc"},
-	{0x34, "\xf0\x0d\x83"}, {0x34, "\xf8\x0c\xb3"}, {0x35, "\x02\xfe
\xba"},
-	{0x35, "\x0a\x04\xe0"}, {0x35, "\x12\x1c\x63"}, {0x35, "\x1a\x2b
\x5a"},
-	{0x35, "\x22\x32\x5e"}, {0x35, "\x2a\x0d\x28"}, {0x35, "\x32\x2c
\x02"},
-	{0x35, "\x3a\xf4\xfa"}, {0x35, "\x4e\x07\xef"}, {0x35, "\x46\x07
\x88"},
-	{0x35, "\x5e\x07\xc1"}, {0x35, "\x56\x04\x64"}, {0x34, "\xe4\x01
\x15"},
-	{0x34, "\xec\x00\x82"}, {0x34, "\xf4\x0c\xce"}, {0x34, "\xfc\x0c
\xba"},
-	{0x35, "\x06\x1f\x02"}, {0x35, "\x0e\x02\xe3"}, {0x35, "\x16\x1a
\x50"},
-	{0x35, "\x1e\x24\x39"}, {0x35, "\x26\x23\x4c"}, {0x35, "\x2e\xf9
\x1b"},
-	{0x35, "\x36\x23\x19"}, {0x35, "\x3e\x12\x08"}, {0x35, "\x52\x07
\x22"},
-	{0x35, "\x4a\x03\xd3"}, {0x35, "\x62\x06\x54"}, {0x35, "\x5a\x04
\x5d"},
-	{0x34, "\xe2\x01\x04"}, {0x34, "\xea\x00\xa0"}, {0x34, "\xf2\x0c
\xbc"},
-	{0x34, "\xfa\x0c\x5b"}, {0x35, "\x04\x17\xf2"}, {0x35, "\x0c\x02
\x08"},
-	{0x35, "\x14\x28\x43"}, {0x35, "\x1c\x28\x62"}, {0x35, "\x24\x2b
\x60"},
-	{0x35, "\x2c\x07\x33"}, {0x35, "\x34\x1f\xb0"}, {0x35, "\x3c\xed
\xcd"},
-	{0x35, "\x50\x00\x06"}, {0x35, "\x48\x07\xff"}, {0x35, "\x60\x05
\x89"},
-	{0x35, "\x58\x07\xff"}, {0x35, "\x40\x00\xa0"}, {0x35, "\x42\x00
\x00"},
-	{0x32, "\x10\x01\xfc"}, {0x33, "\x8c\xa1\x18"},
-	/* Flip/Mirror h/v=1 */
-	{0x33, "\x90\x00\x3c"}, {0x33, "\x8c\x27\x19"}, {0x33, "\x90\x04
\x6c"},
-	{0x33, "\x8c\x27\x3b"}, {0x33, "\x90\x00\x24"}, {0x33, "\x8c\xa1
\x03"},
-	{0x33, "\x90\x00\x06"},
-	{130, "\xff\xff\xff"},
-	{0x33, "\x90\x00\x06"}, {0x33, "\x90\x00\x06"}, {0x33, "\x90\x00
\x06"},
-	{0x33, "\x90\x00\x06"}, {0x33, "\x90\x00\x06"}, {0x33, "\x90\x00
\x06"},
-	{100, "\xff\xff\xff"},
-	/* ?? */
-	{0x33, "\x8c\xa1\x02"}, {0x33, "\x90\x00\x1f"}, {0x33, "\x8c\xa1
\x02"},
-	{0x33, "\x90\x00\x1f"}, {0x33, "\x8c\xa1\x02"}, {0x33, "\x90\x00
\x1f"},
-	{0x33, "\x8c\xa1\x02"}, {0x33, "\x90\x00\x1f"},
-	/* Brigthness=70 */
-	{0x33, "\x8c\xa2\x06"}, {0x33, "\x90\x00\x46"}, {0x33, "\x8c\xa1
\x02"},
-	{0x33, "\x90\x00\x0f"}, {0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00
\x05"},
-	/* Sharpness=20 */
-	{0x32, "\x6c\x14\x08"},
-};
-
-static struct idxdata tbl_init_post_alt_big1[] = {
+static struct idxdata tbl_init_post_alt_big[] = {
 	{0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x05"},
 	{2, "\xff\xff\xff"},
 	{0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x06"},
 	{2, "\xff\xff\xff"},
 	{0x34, "\x1e\x8f\x09"}, {0x34, "\x1c\x01\x28"}, {0x34, "\x1e\x8f
\x09"},
+	{2, "\xff\xff\xff"},
 	{0x34, "\x1e\x8f\x09"}, {0x32, "\x14\x06\xe6"}, {0x33, "\x8c\xa1
\x03"},
 	{0x33, "\x90\x00\x05"},
 	{2, "\xff\xff\xff"},
@@ -285,9 +236,17 @@ static struct idxdata tbl_init_post_alt_
 	{0x33, "\x90\x00\x03"}, {0x33, "\x8c\xa1\x34"}, {0x33, "\x90\x00
\x03"},
 	{0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x02"}, {0x33, "\x2e\x01
\x00"},
 	{0x34, "\x04\x00\x2a"}, {0x33, "\x8c\xa7\x02"}, {0x33, "\x90\x00
\x01"},
+	{0x33, "\x8c\x27\x97"}, {0x33, "\x90\x01\x00"},
+	{51, "\xff\xff\xff"},
+	{0x33, "\x8c\xa1\x20"}, {0x33, "\x90\x00\x00"}, {0x33, "\x8c\xa1
\x03"},
+	{0x33, "\x90\x00\x01"}, {0x33, "\x8c\xa7\x02"}, {0x33, "\x90\x00
\x00"},
+	{51, "\xff\xff\xff"},
+	{0x33, "\x8c\xa1\x20"}, {0x33, "\x90\x00\x72"}, {0x33, "\x8c\xa1
\x03"},
+	{0x33, "\x90\x00\x02"}, {0x33, "\x8c\xa7\x02"}, {0x33, "\x90\x00
\x01"},
+	{51, "\xff\xff\xff"},
 };
 
-static struct idxdata tbl_init_post_alt_big2[] = {
+static struct idxdata tbl_init_post_alt_3B[] = {
 	{0x32, "\x10\x01\xf8"}, {0x34, "\xce\x01\xa8"}, {0x34, "\xd0\x66
\x33"},
 	{0x34, "\xd2\x31\x9a"}, {0x34, "\xd4\x94\x63"}, {0x34, "\xd6\x4b
\x25"},
 	{0x34, "\xd8\x26\x70"}, {0x34, "\xda\x72\x4c"}, {0x34, "\xdc\xff
\x04"},
@@ -316,17 +275,6 @@ static struct idxdata tbl_init_post_alt_
 	{0x32, "\x10\x01\xfc"}, {0x33, "\x8c\xa1\x18"}, {0x33, "\x90\x00
\x3c"},
 };
 
-static struct idxdata tbl_init_post_alt_big3[] = {
-	{0x33, "\x8c\xa1\x02"},
-	{0x33, "\x90\x00\x1f"},
-	{0x33, "\x8c\xa1\x02"},
-	{0x33, "\x90\x00\x1f"},
-	{0x33, "\x8c\xa1\x02"},
-	{0x33, "\x90\x00\x1f"},
-	{0x33, "\x8c\xa1\x02"},
-	{0x33, "\x90\x00\x1f"},
-};
-
 static u8 *dat_640  = "\xd0\x02\xd1\x08\xd2\xe1\xd3\x02\xd4\x10\xd5
\x81";
 static u8 *dat_800  = "\xd0\x02\xd1\x10\xd2\x57\xd3\x02\xd4\x18\xd5
\x21";
 static u8 *dat_1280 = "\xd0\x02\xd1\x20\xd2\x01\xd3\x02\xd4\x28\xd5
\x01";
@@ -351,7 +299,7 @@ void mi2020_init_settings(struct gspca_d
 	sd->vcur.gamma      =  0;
 	sd->vcur.hue        =  0;
 	sd->vcur.saturation = 60;
-	sd->vcur.whitebal   = 50;
+	sd->vcur.whitebal   =  0; /* 50, not done by hardware */
 	sd->vcur.mirror = 0;
 	sd->vcur.flip   = 0;
 	sd->vcur.AC50Hz = 1;
@@ -361,17 +309,12 @@ void mi2020_init_settings(struct gspca_d
 	sd->vmax.sharpness  =  40;
 	sd->vmax.contrast   =   3;
 	sd->vmax.gamma      =   2;
-	sd->vmax.hue        =   0 + 1; /* 200 */
-	sd->vmax.saturation =   0;     /* 100 */
-	sd->vmax.whitebal   =   0;     /* 100 */
+	sd->vmax.hue        =   0 + 1; /* 200, not done by hardware */
+	sd->vmax.saturation =   0;     /* 100, not done by hardware */
+	sd->vmax.whitebal   =   2;     /* 100, not done by hardware */
 	sd->vmax.mirror = 1;
 	sd->vmax.flip   = 1;
 	sd->vmax.AC50Hz = 1;
-	if (_MI2020b_) {
-		sd->vmax.contrast  = 0;
-		sd->vmax.gamma     = 0;
-		sd->vmax.backlight = 0;
-	}
 
 	sd->dev_camera_settings = mi2020_camera_settings;
 	sd->dev_init_at_startup = mi2020_init_at_startup;
@@ -384,51 +327,9 @@ void mi2020_init_settings(struct gspca_d
 
 static void common(struct gspca_dev *gspca_dev)
 {
-	s32 reso = gspca_dev->cam.cam_mode[(s32) gspca_dev->curr_mode].priv;
-
-	if (_MI2020b_) {
-		fetch_validx(gspca_dev, tbl_common1, ARRAY_SIZE(tbl_common1));
-	} else {
-		if (_MI2020_)
-			ctrl_out(gspca_dev, 0x40,  1, 0x0008, 0x0004,  0, NULL);
-		else
-			ctrl_out(gspca_dev, 0x40,  1, 0x0002, 0x0004,  0, NULL);
-		msleep(35);
-		fetch_validx(gspca_dev, tbl_common2, ARRAY_SIZE(tbl_common2));
-	}
-	ctrl_out(gspca_dev, 0x40,  3, 0x7a00, 0x0033,  3, "\x86\x25\x01");
-	ctrl_out(gspca_dev, 0x40,  3, 0x7a00, 0x0033,  3, "\x86\x25\x00");
-	msleep(2); /* - * */
-	ctrl_out(gspca_dev, 0x40,  3, 0x7a00, 0x0030,  3, "\x1a\x0a\xcc");
-	if (reso == IMAGE_1600)
-		msleep(2); /* 1600 */
-	fetch_idxdata(gspca_dev, tbl_common3, ARRAY_SIZE(tbl_common3));
-
-	if (_MI2020b_ || _MI2020_)
-		fetch_idxdata(gspca_dev, tbl_common4,
-				ARRAY_SIZE(tbl_common4));
-
-	fetch_idxdata(gspca_dev, tbl_common5, ARRAY_SIZE(tbl_common5));
-	if (_MI2020b_ || _MI2020_) {
-		/* Different from fret */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x78");
-		/* Same as fret */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\x24\x17");
-		/* Different from fret */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x90");
-	} else {
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x6a");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\x24\x17");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x80");
-	}
-	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa1\x03");
-	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x05");
-	msleep(2);
-	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa1\x03");
-	if (reso == IMAGE_1600)
-		msleep(14); /* 1600 */
-	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x06");
-	msleep(2);
+	fetch_validx(gspca_dev, tbl_common_0B, ARRAY_SIZE(tbl_common_0B));
+	fetch_idxdata(gspca_dev, tbl_common_3B, ARRAY_SIZE(tbl_common_3B));
+	ctrl_out(gspca_dev, 0x40, 1, 0x0041, 0x0000, 0, NULL);
 }
 
 static int mi2020_init_at_startup(struct gspca_dev *gspca_dev)
@@ -441,8 +342,16 @@ static int mi2020_init_at_startup(struct
 	fetch_validx(gspca_dev, tbl_init_at_startup,
 			ARRAY_SIZE(tbl_init_at_startup));
 
+	ctrl_out(gspca_dev, 0x40,  1, 0x7a00, 0x8030,  0, NULL);
+	ctrl_in(gspca_dev, 0xc0,  2, 0x7a00, 0x8030,  1, &c);
+
 	common(gspca_dev);
 
+	msleep(61);
+/*	ctrl_out(gspca_dev, 0x40, 11, 0x0000, 0x0000,  0, NULL); */
+/*	msleep(36); */
+	ctrl_out(gspca_dev, 0x40,  1, 0x0001, 0x0000,  0, NULL);
+
 	return 0;
 }
 
@@ -450,17 +359,17 @@ static int mi2020_init_pre_alt(struct gs
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	sd->mirrorMask = 0;
+	sd->mirrorMask =  0;
+	sd->vold.hue   = -1;
 
-	sd->vold.backlight  = -1;
+	/* These controls need to be reset */
 	sd->vold.brightness = -1;
 	sd->vold.sharpness  = -1;
-	sd->vold.contrast   = -1;
-	sd->vold.gamma  = -1;
-	sd->vold.hue    = -1;
-	sd->vold.mirror = -1;
-	sd->vold.flip   = -1;
-	sd->vold.AC50Hz = -1;
+
+	/* If not different from default, they do not need to be set */
+	sd->vold.contrast  = 0;
+	sd->vold.gamma     = 0;
+	sd->vold.backlight = 0;
 
 	mi2020_init_post_alt(gspca_dev);
 
@@ -472,10 +381,10 @@ static int mi2020_init_post_alt(struct g
 	struct sd *sd = (struct sd *) gspca_dev;
 	s32 reso = gspca_dev->cam.cam_mode[(s32) gspca_dev->curr_mode].priv;
 
-	s32 backlight = sd->vcur.backlight;
 	s32 mirror = (((sd->vcur.mirror > 0) ^ sd->mirrorMask) > 0);
 	s32 flip   = (((sd->vcur.flip   > 0) ^ sd->mirrorMask) > 0);
 	s32 freq   = (sd->vcur.AC50Hz  > 0);
+	s32 wbal   = sd->vcur.whitebal;
 
 	u8 dat_freq2[] = {0x90, 0x00, 0x80};
 	u8 dat_multi1[] = {0x8c, 0xa7, 0x00};
@@ -484,6 +393,7 @@ static int mi2020_init_post_alt(struct g
 	u8 dat_multi4[] = {0x90, 0x00, 0x00};
 	u8 dat_hvflip2[] = {0x90, 0x04, 0x6c};
 	u8 dat_hvflip4[] = {0x90, 0x00, 0x24};
+	u8 dat_wbal2[] = {0x90, 0x00, 0x00};
 	u8 c;
 
 	sd->nbIm = -1;
@@ -491,23 +401,26 @@ static int mi2020_init_post_alt(struct g
 	dat_freq2[2] = freq ? 0xc0 : 0x80;
 	dat_multi1[2] = 0x9d;
 	dat_multi3[2] = dat_multi1[2] + 1;
-	dat_multi4[2] = dat_multi2[2] = backlight;
+	if (wbal == 0) {
+		dat_multi4[2] = dat_multi2[2] = 0;
+		dat_wbal2[2] = 0x17;
+	} else if (wbal == 1) {
+		dat_multi4[2] = dat_multi2[2] = 0;
+		dat_wbal2[2] = 0x35;
+	} else if (wbal == 2) {
+		dat_multi4[2] = dat_multi2[2] = 0x20;
+		dat_wbal2[2] = 0x17;
+	}
 	dat_hvflip2[2] = 0x6c + 2 * (1 - flip) + (1 - mirror);
 	dat_hvflip4[2] = 0x24 + 2 * (1 - flip) + (1 - mirror);
 
 	msleep(200);
-
 	ctrl_out(gspca_dev, 0x40, 5, 0x0001, 0x0000, 0, NULL);
-	msleep(3); /* 35 * */
+	msleep(2);
 
 	common(gspca_dev);
 
-	ctrl_out(gspca_dev, 0x40,  1, 0x0041, 0x0000,  0, NULL);
-	msleep(70);
-
-	if (_MI2020b_)
-		ctrl_out(gspca_dev, 0x40,  1, 0x0040, 0x0000,  0, NULL);
-
+	msleep(142);
 	ctrl_out(gspca_dev, 0x40,  1, 0x0010, 0x0010,  0, NULL);
 	ctrl_out(gspca_dev, 0x40,  1, 0x0003, 0x00c1,  0, NULL);
 	ctrl_out(gspca_dev, 0x40,  1, 0x0042, 0x00c2,  0, NULL);
@@ -523,8 +436,7 @@ static int mi2020_init_post_alt(struct g
 			ctrl_out(gspca_dev, 0x40,  3, 0x0000, 0x0200,
 				12, dat_800);
 
-		if (_MI2020c_)
-			fetch_idxdata(gspca_dev, tbl_init_post_alt_low1,
+		fetch_idxdata(gspca_dev, tbl_init_post_alt_low1,
 					ARRAY_SIZE(tbl_init_post_alt_low1));
 
 		if (reso == IMAGE_800)
@@ -534,87 +446,10 @@ static int mi2020_init_post_alt(struct g
 		fetch_idxdata(gspca_dev, tbl_init_post_alt_low3,
 				ARRAY_SIZE(tbl_init_post_alt_low3));
 
-		if (_MI2020b_) {
-			ctrl_out(gspca_dev, 0x40, 1, 0x0001, 0x0010, 0, NULL);
-			ctrl_out(gspca_dev, 0x40, 1, 0x0000, 0x00c1, 0, NULL);
-			ctrl_out(gspca_dev, 0x40, 1, 0x0041, 0x00c2, 0, NULL);
-			msleep(150);
-		} else if (_MI2020c_) {
-			ctrl_out(gspca_dev, 0x40, 1, 0x0010, 0x0010, 0, NULL);
-			ctrl_out(gspca_dev, 0x40, 1, 0x0000, 0x00c1, 0, NULL);
-			ctrl_out(gspca_dev, 0x40, 1, 0x0041, 0x00c2, 0, NULL);
-			msleep(120);
-			ctrl_out(gspca_dev, 0x40, 1, 0x0040, 0x0000, 0, NULL);
-			msleep(30);
-		} else if (_MI2020_) {
-			ctrl_out(gspca_dev, 0x40, 1, 0x0001, 0x0010, 0, NULL);
-			ctrl_out(gspca_dev, 0x40, 1, 0x0000, 0x00c1, 0, NULL);
-			ctrl_out(gspca_dev, 0x40, 1, 0x0041, 0x00c2, 0, NULL);
-			msleep(120);
-			ctrl_out(gspca_dev, 0x40, 1, 0x0040, 0x0000, 0, NULL);
-			msleep(30);
-		}
-
-		/* AC power frequency */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_freq1);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_freq2);
-		msleep(20);
-		/* backlight */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi1);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi2);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi3);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi4);
-		/* at init time but not after */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa2\x0c");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x17");
-		/* finish the backlight */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi5);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi6);
-		msleep(5);/* " */
-
-		if (_MI2020c_) {
-			fetch_idxdata(gspca_dev, tbl_init_post_alt_low4,
-					ARRAY_SIZE(tbl_init_post_alt_low4));
-		} else {
-			ctrl_in(gspca_dev, 0xc0, 2, 0x0000, 0x0000, 1, &c);
-			msleep(14); /* 0xd8 */
-
-			/* flip/mirror */
-			ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033,
-					3, dat_hvflip1);
-			ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033,
-					3, dat_hvflip2);
-			ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033,
-					3, dat_hvflip3);
-			ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033,
-					3, dat_hvflip4);
-			ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033,
-					3, dat_hvflip5);
-			ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033,
-					3, dat_hvflip6);
-			msleep(21);
-			ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033,
-					3, dat_dummy1);
-			msleep(5);
-			ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033,
-					3, dat_dummy1);
-			msleep(5);
-			ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033,
-					3, dat_dummy1);
-			msleep(5);
-			ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033,
-					3, dat_dummy1);
-			msleep(5);
-			ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033,
-					3, dat_dummy1);
-			msleep(5);
-			ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033,
-					3, dat_dummy1);
-			/* end of flip/mirror main part */
-			msleep(246); /* 146 */
-
-			sd->nbIm = 0;
-		}
+		ctrl_out(gspca_dev, 0x40, 1, 0x0010, 0x0010, 0, NULL);
+		ctrl_out(gspca_dev, 0x40, 1, 0x0000, 0x00c1, 0, NULL);
+		ctrl_out(gspca_dev, 0x40, 1, 0x0041, 0x00c2, 0, NULL);
+		msleep(120);
 		break;
 
 	case IMAGE_1280:
@@ -643,108 +478,62 @@ static int mi2020_init_post_alt(struct g
 					3, "\x90\x04\xb0");
 		}
 
-		fetch_idxdata(gspca_dev, tbl_init_post_alt_big1,
-				ARRAY_SIZE(tbl_init_post_alt_big1));
+		fetch_idxdata(gspca_dev, tbl_init_post_alt_big,
+				ARRAY_SIZE(tbl_init_post_alt_big));
 
-		if (reso == IMAGE_1600)
-			msleep(13); /* 1600 */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\x27\x97");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x01\x00");
-		msleep(53);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa1\x20");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x00");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa1\x03");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x01");
-		if (reso == IMAGE_1600)
-			msleep(13); /* 1600 */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa7\x02");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x00");
-		msleep(53);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa1\x20");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x72");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa1\x03");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x02");
-		if (reso == IMAGE_1600)
-			msleep(13); /* 1600 */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa7\x02");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x01");
-		msleep(53);
-
-		if (_MI2020b_) {
-			ctrl_out(gspca_dev, 0x40, 1, 0x0001, 0x0010, 0, NULL);
-			if (reso == IMAGE_1600)
-				msleep(500); /* 1600 */
-			ctrl_out(gspca_dev, 0x40, 1, 0x0000, 0x00c1, 0, NULL);
-			ctrl_out(gspca_dev, 0x40, 1, 0x0041, 0x00c2, 0, NULL);
-			msleep(1850);
-		} else if (_MI2020c_ || _MI2020_) {
-			ctrl_out(gspca_dev, 0x40, 1, 0x0001, 0x0010, 0, NULL);
-			ctrl_out(gspca_dev, 0x40, 1, 0x0000, 0x00c1, 0, NULL);
-			ctrl_out(gspca_dev, 0x40, 1, 0x0041, 0x00c2, 0, NULL);
-			msleep(1850);
-			ctrl_out(gspca_dev, 0x40, 1, 0x0040, 0x0000, 0, NULL);
-			msleep(30);
-		}
-
-		/* AC power frequency */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_freq1);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_freq2);
-		msleep(20);
-		/* backlight */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi1);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi2);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi3);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi4);
-		/* at init time but not after */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa2\x0c");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x17");
-		/* finish the backlight */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi5);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi6);
-		msleep(6); /* " */
-
-		ctrl_in(gspca_dev, 0xc0, 2, 0x0000, 0x0000, 1, &c);
-		msleep(14);
+		ctrl_out(gspca_dev, 0x40, 1, 0x0001, 0x0010, 0, NULL);
+		ctrl_out(gspca_dev, 0x40, 1, 0x0000, 0x00c1, 0, NULL);
+		ctrl_out(gspca_dev, 0x40, 1, 0x0041, 0x00c2, 0, NULL);
+		msleep(1850);
+	}
+
+	ctrl_out(gspca_dev, 0x40, 1, 0x0040, 0x0000, 0, NULL);
+	msleep(40);
+
+	/* AC power frequency */
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_freq1);
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_freq2);
+	msleep(33);
+	/* light source */
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi1);
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi2);
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi3);
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi4);
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_wbal1);
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_wbal2);
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi5);
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi6);
+	msleep(7);
+	ctrl_in(gspca_dev, 0xc0, 2, 0x0000, 0x0000, 1, &c);
+
+	fetch_idxdata(gspca_dev, tbl_init_post_alt_3B,
+			ARRAY_SIZE(tbl_init_post_alt_3B));
+
+	/* hvflip */
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip1);
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip2);
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip3);
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip4);
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip5);
+	ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip6);
+	msleep(250);
+
+	if (reso == IMAGE_640 || reso == IMAGE_800)
+		fetch_idxdata(gspca_dev, tbl_middle_hvflip_low,
+				ARRAY_SIZE(tbl_middle_hvflip_low));
+	else
+		fetch_idxdata(gspca_dev, tbl_middle_hvflip_big,
+				ARRAY_SIZE(tbl_middle_hvflip_big));
 
-		if (_MI2020c_)
-			fetch_idxdata(gspca_dev, tbl_init_post_alt_big2,
-					ARRAY_SIZE(tbl_init_post_alt_big2));
+	fetch_idxdata(gspca_dev, tbl_end_hvflip,
+			ARRAY_SIZE(tbl_end_hvflip));
 
-		/* flip/mirror */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip1);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip2);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip3);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip4);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip5);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip6);
-		/* end of flip/mirror main part */
-		msleep(16);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa1\x03");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x01");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa1\x20");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x00");
-		if (reso == IMAGE_1600)
-			msleep(25); /* 1600 */
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa7\x02");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x00");
-		msleep(103);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa1\x03");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x02");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa1\x20");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x72");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x8c\xa7\x02");
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x01");
-		sd->nbIm = 0;
-
-		if (_MI2020c_)
-			fetch_idxdata(gspca_dev, tbl_init_post_alt_big3,
-					ARRAY_SIZE(tbl_init_post_alt_big3));
-	}
+	sd->nbIm = 0;
 
 	sd->vold.mirror    = mirror;
 	sd->vold.flip      = flip;
 	sd->vold.AC50Hz    = freq;
-	sd->vold.backlight = backlight;
+	sd->vold.whitebal  = wbal;
 
 	mi2020_camera_settings(gspca_dev);
 
@@ -769,9 +558,10 @@ static int mi2020_configure_alt(struct g
 	return 0;
 }
 
-static int mi2020_camera_settings(struct gspca_dev *gspca_dev)
+int mi2020_camera_settings(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	s32 reso = gspca_dev->cam.cam_mode[(s32) gspca_dev->curr_mode].priv;
 
 	s32 backlight = sd->vcur.backlight;
 	s32 bright =  sd->vcur.brightness;
@@ -782,6 +572,7 @@ static int mi2020_camera_settings(struct
 	s32 mirror = (((sd->vcur.mirror > 0) ^ sd->mirrorMask) > 0);
 	s32 flip   = (((sd->vcur.flip   > 0) ^ sd->mirrorMask) > 0);
 	s32 freq   = (sd->vcur.AC50Hz > 0);
+	s32 wbal   = sd->vcur.whitebal;
 
 	u8 dat_sharp[] = {0x6c, 0x00, 0x08};
 	u8 dat_bright2[] = {0x90, 0x00, 0x00};
@@ -792,6 +583,7 @@ static int mi2020_camera_settings(struct
 	u8 dat_multi4[] = {0x90, 0x00, 0x00};
 	u8 dat_hvflip2[] = {0x90, 0x04, 0x6c};
 	u8 dat_hvflip4[] = {0x90, 0x00, 0x24};
+	u8 dat_wbal2[] = {0x90, 0x00, 0x00};
 
 	/* Less than 4 images received -> too early to set the settings */
 	if (sd->nbIm < 4) {
@@ -809,67 +601,89 @@ static int mi2020_camera_settings(struct
 		msleep(20);
 	}
 
+	if (wbal != sd->vold.whitebal) {
+		sd->vold.whitebal = wbal;
+		if (wbal < 0 || wbal > sd->vmax.whitebal)
+			wbal = 0;
+
+		dat_multi1[2] = 0x9d;
+		dat_multi3[2] = dat_multi1[2] + 1;
+		if (wbal == 0) {
+			dat_multi4[2] = dat_multi2[2] = 0;
+			dat_wbal2[2] = 0x17;
+		} else if (wbal == 1) {
+			dat_multi4[2] = dat_multi2[2] = 0;
+			dat_wbal2[2] = 0x35;
+		} else if (wbal == 2) {
+			dat_multi4[2] = dat_multi2[2] = 0x20;
+			dat_wbal2[2] = 0x17;
+		}
+		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi1);
+		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi2);
+		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi3);
+		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi4);
+		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_wbal1);
+		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_wbal2);
+		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi5);
+		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi6);
+	}
+
 	if (mirror != sd->vold.mirror || flip != sd->vold.flip) {
 		sd->vold.mirror = mirror;
 		sd->vold.flip   = flip;
 
 		dat_hvflip2[2] = 0x6c + 2 * (1 - flip) + (1 - mirror);
 		dat_hvflip4[2] = 0x24 + 2 * (1 - flip) + (1 - mirror);
+
+		fetch_idxdata(gspca_dev, tbl_init_post_alt_3B,
+				ARRAY_SIZE(tbl_init_post_alt_3B));
+
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip1);
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip2);
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip3);
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip4);
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip5);
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip6);
-		msleep(130);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_dummy1);
-		msleep(6);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_dummy1);
-		msleep(6);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_dummy1);
-		msleep(6);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_dummy1);
-		msleep(6);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_dummy1);
-		msleep(6);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_dummy1);
-		msleep(6);
-
-		/* Sometimes present, sometimes not, useful? */
-		/* ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dummy2);
-		 * ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dummy3);
-		 * ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dummy2);
-		 * ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dummy3);
-		 * ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dummy2);
-		 * ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dummy3);
-		 * ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dummy2);
-		 * ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dummy3);*/
+		msleep(40);
+
+		if (reso == IMAGE_640 || reso == IMAGE_800)
+			fetch_idxdata(gspca_dev, tbl_middle_hvflip_low,
+					ARRAY_SIZE(tbl_middle_hvflip_low));
+		else
+			fetch_idxdata(gspca_dev, tbl_middle_hvflip_big,
+					ARRAY_SIZE(tbl_middle_hvflip_big));
+
+		fetch_idxdata(gspca_dev, tbl_end_hvflip,
+				ARRAY_SIZE(tbl_end_hvflip));
 	}
 
-	if (backlight != sd->vold.backlight) {
-		sd->vold.backlight = backlight;
-		if (backlight < 0 || backlight > sd->vmax.backlight)
-			backlight = 0;
+	if (bright != sd->vold.brightness) {
+		sd->vold.brightness = bright;
+		if (bright < 0 || bright > sd->vmax.brightness)
+			bright = 0;
 
-		dat_multi1[2] = 0x9d;
-		dat_multi3[2] = dat_multi1[2] + 1;
-		dat_multi4[2] = dat_multi2[2] = backlight;
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi1);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi2);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi3);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi4);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi5);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi6);
+		dat_bright2[2] = bright;
+		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_bright1);
+		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_bright2);
+		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_bright3);
+		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_bright4);
+		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_bright5);
+		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_bright6);
 	}
 
-	if (gam != sd->vold.gamma) {
+	if (cntr != sd->vold.contrast || gam != sd->vold.gamma) {
+		sd->vold.contrast = cntr;
+		if (cntr < 0 || cntr > sd->vmax.contrast)
+			cntr = 0;
 		sd->vold.gamma = gam;
 		if (gam < 0 || gam > sd->vmax.gamma)
 			gam = 0;
 
 		dat_multi1[2] = 0x6d;
 		dat_multi3[2] = dat_multi1[2] + 1;
-		dat_multi4[2] = dat_multi2[2] = 0x40 + gam;
+		if (cntr == 0)
+			cntr = 4;
+		dat_multi4[2] = dat_multi2[2] = cntr * 0x10 + 2 - gam;
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi1);
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi2);
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi3);
@@ -878,14 +692,14 @@ static int mi2020_camera_settings(struct
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi6);
 	}
 
-	if (cntr != sd->vold.contrast) {
-		sd->vold.contrast = cntr;
-		if (cntr < 0 || cntr > sd->vmax.contrast)
-			cntr = 0;
+	if (backlight != sd->vold.backlight) {
+		sd->vold.backlight = backlight;
+		if (backlight < 0 || backlight > sd->vmax.backlight)
+			backlight = 0;
 
-		dat_multi1[2] = 0x6d;
+		dat_multi1[2] = 0x9d;
 		dat_multi3[2] = dat_multi1[2] + 1;
-		dat_multi4[2] = dat_multi2[2] = 0x12 + 16 * cntr;
+		dat_multi4[2] = dat_multi2[2] = backlight;
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi1);
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi2);
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi3);
@@ -894,20 +708,6 @@ static int mi2020_camera_settings(struct
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_multi6);
 	}
 
-	if (bright != sd->vold.brightness) {
-		sd->vold.brightness = bright;
-		if (bright < 0 || bright > sd->vmax.brightness)
-			bright = 0;
-
-		dat_bright2[2] = bright;
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_bright1);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_bright2);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_bright3);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_bright4);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_bright5);
-		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_bright6);
-	}
-
 	if (sharp != sd->vold.sharpness) {
 		sd->vold.sharpness = sharp;
 		if (sharp < 0 || sharp > sd->vmax.sharpness)
@@ -928,9 +728,6 @@ static int mi2020_camera_settings(struct
 static void mi2020_post_unset_alt(struct gspca_dev *gspca_dev)
 {
 	ctrl_out(gspca_dev, 0x40, 5, 0x0000, 0x0000, 0, NULL);
-	msleep(20);
-	if (_MI2020c_ || _MI2020_)
-		ctrl_out(gspca_dev, 0x40, 1, 0x0001, 0x0000, 0, NULL);
-	else
-		ctrl_out(gspca_dev, 0x40, 1, 0x0041, 0x0000, 0, NULL);
+	msleep(40);
+	ctrl_out(gspca_dev, 0x40, 1, 0x0001, 0x0000, 0, NULL);
 }


