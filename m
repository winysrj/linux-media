Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:34230 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbZJCVsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 17:48:25 -0400
Received: by ewy7 with SMTP id 7so2378190ewy.17
        for <linux-media@vger.kernel.org>; Sat, 03 Oct 2009 14:47:46 -0700 (PDT)
Subject: [PATCH 2/3] gspca_gl860/Fixed format : comment changes and unified
 naming scheme
From: Olivier Lorin <olorin75@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Oct 2009 23:47:42 +0200
Message-Id: <1254606463.24873.33.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gspca_gl860: comment changes and unified naming scheme

From: Olivier Lorin <o.lorin@laposte.net>

- small changes in comments
- unified naming scheme for subdriver variables

Priority: trivial

Signed-off-by: Olivier Lorin <o.lorin@laposte.net>

diff -rupN ../gspca-msrc/linux/drivers/media/video/gspca/gl860/gl860.c ./linux/drivers/media/video/gspca/gl860/gl860.c
--- ../gspca-msrc/linux/drivers/media/video/gspca/gl860/gl860.c	2009-09-24 13:55:34.000000000 +0200
+++ ./linux/drivers/media/video/gspca/gl860/gl860.c	2009-09-24 23:17:32.000000000 +0200
@@ -1,9 +1,7 @@
-/* @file gl860.c
- * @date 2009-08-27
+/* GSPCA subdrivers for Genesys Logic webcams with the GL860 chip
+ * Subdriver core
  *
- * Genesys Logic webcam with gl860 subdrivers
- *
- * Driver by Olivier Lorin <o.lorin@laposte.net>
+ * 2009/09/24 Olivier Lorin <o.lorin@laposte.net>
  * GSPCA by Jean-Francois Moine <http://moinejf.free.fr>
  * Thanks BUGabundo and Malmostoso for your amazing help!
  *
diff -rupN ../gspca-msrc/linux/drivers/media/video/gspca/gl860/gl860.h ./linux/drivers/media/video/gspca/gl860/gl860.h
--- ../gspca-msrc/linux/drivers/media/video/gspca/gl860/gl860.h	2009-09-24 14:01:41.000000000 +0200
+++ ./linux/drivers/media/video/gspca/gl860/gl860.h	2009-09-24 23:16:10.000000000 +0200
@@ -1,6 +1,7 @@
-/* @file gl860.h
- * @author Olivier LORIN, tiré du pilote Syntek par Nicolas VIVIEN
- * @date 2009-08-27
+/* GSPCA subdrivers for Genesys Logic webcams with the GL860 chip
+ * Subdriver declarations
+ *
+ * 2009/09/24 Olivier LORIN <o.lorin@laposte.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff -rupN ../gspca-msrc/linux/drivers/media/video/gspca/gl860/gl860-mi1320.c ./linux/drivers/media/video/gspca/gl860/gl860-mi1320.c
--- ../gspca-msrc/linux/drivers/media/video/gspca/gl860/gl860-mi1320.c	2009-09-18 10:36:24.000000000 +0200
+++ ./linux/drivers/media/video/gspca/gl860/gl860-mi1320.c	2009-09-24 21:24:59.000000000 +0200
@@ -1,6 +1,5 @@
-/* @file gl860-mi1320.c
- * @author Olivier LORIN from my logs
- * @date 2009-08-27
+/* Subdriver for the GL860 chip with the MI1320 sensor
+ * Author Olivier LORIN from own logs
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -127,49 +126,49 @@ static u8 dat_wbalBL[] =
 
 static u8 dat_hvflip1[] = {0xf0, 0x00, 0xf1, 0x00};
 
-static u8 s000[] =
+static u8 dat_common00[] =
 	"\x00\x01\x07\x6a\x06\x63\x0d\x6a" "\xc0\x00\x10\x10\xc1\x03\xc2\x42"
 	"\xd8\x04\x58\x00\x04\x02";
-static u8 s001[] =
+static u8 dat_common01[] =
 	"\x0d\x00\xf1\x0b\x0d\x00\xf1\x08" "\x35\x00\xf1\x22\x68\x00\xf1\x5d"
 	"\xf0\x00\xf1\x01\x06\x70\xf1\x0e" "\xf0\x00\xf1\x02\xdd\x18\xf1\xe0";
-static u8 s002[] =
+static u8 dat_common02[] =
 	"\x05\x01\xf1\x84\x06\x00\xf1\x44" "\x07\x00\xf1\xbe\x08\x00\xf1\x1e"
 	"\x20\x01\xf1\x03\x21\x84\xf1\x00" "\x22\x0d\xf1\x0f\x24\x80\xf1\x00"
 	"\x34\x18\xf1\x2d\x35\x00\xf1\x22" "\x43\x83\xf1\x83\x59\x00\xf1\xff";
-static u8 s003[] =
+static u8 dat_common03[] =
 	"\xf0\x00\xf1\x02\x39\x06\xf1\x8c" "\x3a\x06\xf1\x8c\x3b\x03\xf1\xda"
 	"\x3c\x05\xf1\x30\x57\x01\xf1\x0c" "\x58\x01\xf1\x42\x59\x01\xf1\x0c"
 	"\x5a\x01\xf1\x42\x5c\x13\xf1\x0e" "\x5d\x17\xf1\x12\x64\x1e\xf1\x1c";
-static u8 s004[] =
+static u8 dat_common04[] =
 	"\xf0\x00\xf1\x02\x24\x5f\xf1\x20" "\x28\xea\xf1\x02\x5f\x41\xf1\x43";
-static u8 s005[] =
+static u8 dat_common05[] =
 	"\x02\x00\xf1\xee\x03\x29\xf1\x1a" "\x04\x02\xf1\xa4\x09\x00\xf1\x68"
 	"\x0a\x00\xf1\x2a\x0b\x00\xf1\x04" "\x0c\x00\xf1\x93\x0d\x00\xf1\x82"
 	"\x0e\x00\xf1\x40\x0f\x00\xf1\x5f" "\x10\x00\xf1\x4e\x11\x00\xf1\x5b";
-static u8 s006[] =
+static u8 dat_common06[] =
 	"\x15\x00\xf1\xc9\x16\x00\xf1\x5e" "\x17\x00\xf1\x9d\x18\x00\xf1\x06"
 	"\x19\x00\xf1\x89\x1a\x00\xf1\x12" "\x1b\x00\xf1\xa1\x1c\x00\xf1\xe4"
 	"\x1d\x00\xf1\x7a\x1e\x00\xf1\x64" "\xf6\x00\xf1\x5f";
-static u8 s007[] =
+static u8 dat_common07[] =
 	"\xf0\x00\xf1\x01\x53\x09\xf1\x03" "\x54\x3d\xf1\x1c\x55\x99\xf1\x72"
 	"\x56\xc1\xf1\xb1\x57\xd8\xf1\xce" "\x58\xe0\xf1\x00\xdc\x0a\xf1\x03"
 	"\xdd\x45\xf1\x20\xde\xae\xf1\x82" "\xdf\xdc\xf1\xc9\xe0\xf6\xf1\xea"
 	"\xe1\xff\xf1\x00";
-static u8 s008[] =
+static u8 dat_common08[] =
 	"\xf0\x00\xf1\x01\x80\x00\xf1\x06" "\x81\xf6\xf1\x08\x82\xfb\xf1\xf7"
 	"\x83\x00\xf1\xfe\xb6\x07\xf1\x03" "\xb7\x18\xf1\x0c\x84\xfb\xf1\x06"
 	"\x85\xfb\xf1\xf9\x86\x00\xf1\xff" "\xb8\x07\xf1\x04\xb9\x16\xf1\x0a";
-static u8 s009[] =
+static u8 dat_common09[] =
 	"\x87\xfa\xf1\x05\x88\xfc\xf1\xf9" "\x89\x00\xf1\xff\xba\x06\xf1\x03"
 	"\xbb\x17\xf1\x09\x8a\xe8\xf1\x14" "\x8b\xf7\xf1\xf0\x8c\xfd\xf1\xfa"
 	"\x8d\x00\xf1\x00\xbc\x05\xf1\x01" "\xbd\x0c\xf1\x08\xbe\x00\xf1\x14";
-static u8 s010[] =
+static u8 dat_common10[] =
 	"\x8e\xea\xf1\x13\x8f\xf7\xf1\xf2" "\x90\xfd\xf1\xfa\x91\x00\xf1\x00"
 	"\xbf\x05\xf1\x01\xc0\x0a\xf1\x08" "\xc1\x00\xf1\x0c\x92\xed\xf1\x0f"
 	"\x93\xf9\xf1\xf4\x94\xfe\xf1\xfb" "\x95\x00\xf1\x00\xc2\x04\xf1\x01"
 	"\xc3\x0a\xf1\x07\xc4\x00\xf1\x10";
-static u8 s011[] =
+static u8 dat_common11[] =
 	"\xf0\x00\xf1\x01\x05\x00\xf1\x06" "\x25\x00\xf1\x55\x34\x10\xf1\x10"
 	"\x35\xf0\xf1\x10\x3a\x02\xf1\x03" "\x3b\x04\xf1\x2a\x9b\x43\xf1\x00"
 	"\xa4\x03\xf1\xc0\xa7\x02\xf1\x81";
@@ -222,26 +221,26 @@ void mi1320_init_settings(struct gspca_d
 
 static void common(struct gspca_dev *gspca_dev)
 {
-	s32 n; /* reserved for FETCH macros */
+	s32 n; /* reserved for FETCH functions */
 
-	ctrl_out(gspca_dev, 0x40, 3, 0x0000, 0x0200, 22, s000);
+	ctrl_out(gspca_dev, 0x40, 3, 0x0000, 0x0200, 22, dat_common00);
 	ctrl_out(gspca_dev, 0x40, 1, 0x0041, 0x0000, 0, NULL);
-	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 32, s001);
+	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 32, dat_common01);
 	n = fetch_validx(gspca_dev, tbl_common, ARRAY_SIZE(tbl_common));
-	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 48, s002);
-	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 48, s003);
-	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 16, s004);
-	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 48, s005);
-	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 44, s006);
+	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 48, dat_common02);
+	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 48, dat_common03);
+	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 16, dat_common04);
+	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 48, dat_common05);
+	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 44, dat_common06);
 	keep_on_fetching_validx(gspca_dev, tbl_common,
 					ARRAY_SIZE(tbl_common), n);
-	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 52, s007);
-	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 48, s008);
-	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 48, s009);
-	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 56, s010);
+	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 52, dat_common07);
+	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 48, dat_common08);
+	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 48, dat_common09);
+	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 56, dat_common10);
 	keep_on_fetching_validx(gspca_dev, tbl_common,
 					ARRAY_SIZE(tbl_common), n);
-	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 40, s011);
+	ctrl_out(gspca_dev, 0x40, 3, 0xba00, 0x0200, 40, dat_common11);
 	keep_on_fetching_validx(gspca_dev, tbl_common,
 					ARRAY_SIZE(tbl_common), n);
 }
diff -rupN ../gspca-msrc/linux/drivers/media/video/gspca/gl860/gl860-mi2020.c ./linux/drivers/media/video/gspca/gl860/gl860-mi2020.c
--- ../gspca-msrc/linux/drivers/media/video/gspca/gl860/gl860-mi2020.c	2009-09-18 10:36:24.000000000 +0200
+++ ./linux/drivers/media/video/gspca/gl860/gl860-mi2020.c	2009-09-24 23:20:58.000000000 +0200
@@ -1,7 +1,6 @@
-/* @file gl860-mi2020.c
- * @author Olivier LORIN, from Ice/Soro2005's logs(A), Fret_saw/Hulkie's
+/* Subdriver for the GL860 chip with the MI2020 sensor
+ * Author Olivier LORIN, from Ice/Soro2005's logs(A), Fret_saw/Hulkie's
  * logs(B) and Tricid"s logs(C). With the help of Kytrix/BUGabundo/Blazercist.
- * @date 2009-08-27
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -41,7 +40,7 @@ static u8 dat_freq1[] = { 0x8c, 0xa4, 0x
 static u8 dat_multi5[] = { 0x8c, 0xa1, 0x03 };
 static u8 dat_multi6[] = { 0x90, 0x00, 0x05 };
 
-static struct validx tbl_common_a[] = {
+static struct validx tbl_common1[] = {
 	{0x0000, 0x0000},
 	{1, 0xffff}, /* msleep(35); */
 	{0x006a, 0x0007}, {0x0063, 0x0006}, {0x006a, 0x000d}, {0x0000, 0x00c0},
@@ -49,7 +48,7 @@ static struct validx tbl_common_a[] = {
 	{0x0000, 0x0058}, {0x0002, 0x0004}, {0x0041, 0x0000},
 };
 
-static struct validx tbl_common_b[] = {
+static struct validx tbl_common2[] = {
 	{0x006a, 0x0007},
 	{35, 0xffff},
 	{0x00ef, 0x0006},
@@ -60,7 +59,7 @@ static struct validx tbl_common_b[] = {
 	{0x0004, 0x00d8}, {0x0000, 0x0058}, {0x0041, 0x0000},
 };
 
-static struct idxdata tbl_common_c[] = {
+static struct idxdata tbl_common3[] = {
 	{0x32, "\x02\x00\x08"}, {0x33, "\xf4\x03\x1d"},
 	{6, "\xff\xff\xff"}, /* 12 */
 	{0x34, "\x1e\x8f\x09"}, {0x34, "\x1c\x01\x28"}, {0x34, "\x1e\x8f\x09"},
@@ -109,7 +108,7 @@ static struct idxdata tbl_common_c[] = {
 	{0x33, "\x8c\xa2\x03"}, {0x33, "\x90\x00\xbb"},
 };
 
-static struct idxdata tbl_common_d[] = {
+static struct idxdata tbl_common4[] = {
 	{0x33, "\x8c\x22\x2e"}, {0x33, "\x90\x00\xa0"}, {0x33, "\x8c\xa4\x08"},
 	{0x33, "\x90\x00\x1f"}, {0x33, "\x8c\xa4\x09"}, {0x33, "\x90\x00\x21"},
 	{0x33, "\x8c\xa4\x0a"}, {0x33, "\x90\x00\x25"}, {0x33, "\x8c\xa4\x0b"},
@@ -118,7 +117,7 @@ static struct idxdata tbl_common_d[] = {
 	{0x33, "\x90\x00\xa0"}, {0x33, "\x8c\x24\x17"}, {0x33, "\x90\x00\xc0"},
 };
 
-static struct idxdata tbl_common_e[] = {
+static struct idxdata tbl_common5[] = {
 	{0x33, "\x8c\xa4\x04"}, {0x33, "\x90\x00\x80"}, {0x33, "\x8c\xa7\x9d"},
 	{0x33, "\x90\x00\x00"}, {0x33, "\x8c\xa7\x9e"}, {0x33, "\x90\x00\x00"},
 	{0x33, "\x8c\xa2\x0c"}, {0x33, "\x90\x00\x17"}, {0x33, "\x8c\xa2\x15"},
@@ -180,7 +179,7 @@ static struct validx tbl_init_at_startup
 	{53, 0xffff},
 };
 
-static struct idxdata tbl_init_post_alt_low_a[] = {
+static struct idxdata tbl_init_post_alt_low1[] = {
 	{0x33, "\x8c\x27\x15"}, {0x33, "\x90\x00\x25"}, {0x33, "\x8c\x22\x2e"},
 	{0x33, "\x90\x00\x81"}, {0x33, "\x8c\xa4\x08"}, {0x33, "\x90\x00\x17"},
 	{0x33, "\x8c\xa4\x09"}, {0x33, "\x90\x00\x1a"}, {0x33, "\x8c\xa4\x0a"},
@@ -189,7 +188,7 @@ static struct idxdata tbl_init_post_alt_
 	{0x33, "\x90\x00\x9b"},
 };
 
-static struct idxdata tbl_init_post_alt_low_b[] = {
+static struct idxdata tbl_init_post_alt_low2[] = {
 	{0x33, "\x8c\x27\x03"}, {0x33, "\x90\x03\x24"}, {0x33, "\x8c\x27\x05"},
 	{0x33, "\x90\x02\x58"}, {0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x05"},
 	{2, "\xff\xff\xff"},
@@ -197,7 +196,7 @@ static struct idxdata tbl_init_post_alt_
 	{2, "\xff\xff\xff"},
 };
 
-static struct idxdata tbl_init_post_alt_low_c[] = {
+static struct idxdata tbl_init_post_alt_low3[] = {
 	{0x34, "\x1e\x8f\x09"}, {0x34, "\x1c\x01\x28"}, {0x34, "\x1e\x8f\x09"},
 	{2, "\xff\xff\xff"},
 	{0x34, "\x1e\x8f\x09"}, {0x32, "\x14\x06\xe6"}, {0x33, "\x8c\xa1\x20"},
@@ -221,7 +220,7 @@ static struct idxdata tbl_init_post_alt_
 	{1, "\xff\xff\xff"},
 };
 
-static struct idxdata tbl_init_post_alt_low_d[] = {
+static struct idxdata tbl_init_post_alt_low4[] = {
 	{0x32, "\x10\x01\xf8"}, {0x34, "\xce\x01\xa8"}, {0x34, "\xd0\x66\x33"},
 	{0x34, "\xd2\x31\x9a"}, {0x34, "\xd4\x94\x63"}, {0x34, "\xd6\x4b\x25"},
 	{0x34, "\xd8\x26\x70"}, {0x34, "\xda\x72\x4c"}, {0x34, "\xdc\xff\x04"},
@@ -267,7 +266,7 @@ static struct idxdata tbl_init_post_alt_
 	{0x32, "\x6c\x14\x08"},
 };
 
-static struct idxdata tbl_init_post_alt_big_a[] = {
+static struct idxdata tbl_init_post_alt_big1[] = {
 	{0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x05"},
 	{2, "\xff\xff\xff"},
 	{0x33, "\x8c\xa1\x03"}, {0x33, "\x90\x00\x06"},
@@ -288,7 +287,7 @@ static struct idxdata tbl_init_post_alt_
 	{0x34, "\x04\x00\x2a"}, {0x33, "\x8c\xa7\x02"}, {0x33, "\x90\x00\x01"},
 };
 
-static struct idxdata tbl_init_post_alt_big_b[] = {
+static struct idxdata tbl_init_post_alt_big2[] = {
 	{0x32, "\x10\x01\xf8"}, {0x34, "\xce\x01\xa8"}, {0x34, "\xd0\x66\x33"},
 	{0x34, "\xd2\x31\x9a"}, {0x34, "\xd4\x94\x63"}, {0x34, "\xd6\x4b\x25"},
 	{0x34, "\xd8\x26\x70"}, {0x34, "\xda\x72\x4c"}, {0x34, "\xdc\xff\x04"},
@@ -317,7 +316,7 @@ static struct idxdata tbl_init_post_alt_
 	{0x32, "\x10\x01\xfc"}, {0x33, "\x8c\xa1\x18"}, {0x33, "\x90\x00\x3c"},
 };
 
-static struct idxdata tbl_init_post_alt_big_c[] = {
+static struct idxdata tbl_init_post_alt_big3[] = {
 	{0x33, "\x8c\xa1\x02"},
 	{0x33, "\x90\x00\x1f"},
 	{0x33, "\x8c\xa1\x02"},
@@ -388,14 +387,14 @@ static void common(struct gspca_dev *gsp
 	s32 reso = gspca_dev->cam.cam_mode[(s32) gspca_dev->curr_mode].priv;
 
 	if (_MI2020b_) {
-		fetch_validx(gspca_dev, tbl_common_a, ARRAY_SIZE(tbl_common_a));
+		fetch_validx(gspca_dev, tbl_common1, ARRAY_SIZE(tbl_common1));
 	} else {
 		if (_MI2020_)
 			ctrl_out(gspca_dev, 0x40,  1, 0x0008, 0x0004,  0, NULL);
 		else
 			ctrl_out(gspca_dev, 0x40,  1, 0x0002, 0x0004,  0, NULL);
 		msleep(35);
-		fetch_validx(gspca_dev, tbl_common_b, ARRAY_SIZE(tbl_common_b));
+		fetch_validx(gspca_dev, tbl_common2, ARRAY_SIZE(tbl_common2));
 	}
 	ctrl_out(gspca_dev, 0x40,  3, 0x7a00, 0x0033,  3, "\x86\x25\x01");
 	ctrl_out(gspca_dev, 0x40,  3, 0x7a00, 0x0033,  3, "\x86\x25\x00");
@@ -403,13 +402,13 @@ static void common(struct gspca_dev *gsp
 	ctrl_out(gspca_dev, 0x40,  3, 0x7a00, 0x0030,  3, "\x1a\x0a\xcc");
 	if (reso == IMAGE_1600)
 		msleep(2); /* 1600 */
-	fetch_idxdata(gspca_dev, tbl_common_c, ARRAY_SIZE(tbl_common_c));
+	fetch_idxdata(gspca_dev, tbl_common3, ARRAY_SIZE(tbl_common3));
 
 	if (_MI2020b_ || _MI2020_)
-		fetch_idxdata(gspca_dev, tbl_common_d,
-				ARRAY_SIZE(tbl_common_d));
+		fetch_idxdata(gspca_dev, tbl_common4,
+				ARRAY_SIZE(tbl_common4));
 
-	fetch_idxdata(gspca_dev, tbl_common_e, ARRAY_SIZE(tbl_common_e));
+	fetch_idxdata(gspca_dev, tbl_common5, ARRAY_SIZE(tbl_common5));
 	if (_MI2020b_ || _MI2020_) {
 		/* Different from fret */
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, "\x90\x00\x78");
@@ -525,15 +524,15 @@ static int mi2020_init_post_alt(struct g
 				12, dat_800);
 
 		if (_MI2020c_)
-			fetch_idxdata(gspca_dev, tbl_init_post_alt_low_a,
-					ARRAY_SIZE(tbl_init_post_alt_low_a));
+			fetch_idxdata(gspca_dev, tbl_init_post_alt_low1,
+					ARRAY_SIZE(tbl_init_post_alt_low1));
 
 		if (reso == IMAGE_800)
-			fetch_idxdata(gspca_dev, tbl_init_post_alt_low_b,
-					ARRAY_SIZE(tbl_init_post_alt_low_b));
+			fetch_idxdata(gspca_dev, tbl_init_post_alt_low2,
+					ARRAY_SIZE(tbl_init_post_alt_low2));
 
-		fetch_idxdata(gspca_dev, tbl_init_post_alt_low_c,
-				ARRAY_SIZE(tbl_init_post_alt_low_c));
+		fetch_idxdata(gspca_dev, tbl_init_post_alt_low3,
+				ARRAY_SIZE(tbl_init_post_alt_low3));
 
 		if (_MI2020b_) {
 			ctrl_out(gspca_dev, 0x40, 1, 0x0001, 0x0010, 0, NULL);
@@ -574,8 +573,8 @@ static int mi2020_init_post_alt(struct g
 		msleep(5);/* " */
 
 		if (_MI2020c_) {
-			fetch_idxdata(gspca_dev, tbl_init_post_alt_low_d,
-					ARRAY_SIZE(tbl_init_post_alt_low_d));
+			fetch_idxdata(gspca_dev, tbl_init_post_alt_low4,
+					ARRAY_SIZE(tbl_init_post_alt_low4));
 		} else {
 			ctrl_in(gspca_dev, 0xc0, 2, 0x0000, 0x0000, 1, &c);
 			msleep(14); /* 0xd8 */
@@ -644,8 +643,8 @@ static int mi2020_init_post_alt(struct g
 					3, "\x90\x04\xb0");
 		}
 
-		fetch_idxdata(gspca_dev, tbl_init_post_alt_big_a,
-				ARRAY_SIZE(tbl_init_post_alt_big_a));
+		fetch_idxdata(gspca_dev, tbl_init_post_alt_big1,
+				ARRAY_SIZE(tbl_init_post_alt_big1));
 
 		if (reso == IMAGE_1600)
 			msleep(13); /* 1600 */
@@ -708,8 +707,8 @@ static int mi2020_init_post_alt(struct g
 		msleep(14);
 
 		if (_MI2020c_)
-			fetch_idxdata(gspca_dev, tbl_init_post_alt_big_b,
-					ARRAY_SIZE(tbl_init_post_alt_big_b));
+			fetch_idxdata(gspca_dev, tbl_init_post_alt_big2,
+					ARRAY_SIZE(tbl_init_post_alt_big2));
 
 		/* flip/mirror */
 		ctrl_out(gspca_dev, 0x40, 3, 0x7a00, 0x0033, 3, dat_hvflip1);
@@ -738,8 +737,8 @@ static int mi2020_init_post_alt(struct g
 		sd->nbIm = 0;
 
 		if (_MI2020c_)
-			fetch_idxdata(gspca_dev, tbl_init_post_alt_big_c,
-					ARRAY_SIZE(tbl_init_post_alt_big_c));
+			fetch_idxdata(gspca_dev, tbl_init_post_alt_big3,
+					ARRAY_SIZE(tbl_init_post_alt_big3));
 	}
 
 	sd->vold.mirror    = mirror;
diff -rupN ../gspca-msrc/linux/drivers/media/video/gspca/gl860/gl860-ov2640.c ./linux/drivers/media/video/gspca/gl860/gl860-ov2640.c
--- ../gspca-msrc/linux/drivers/media/video/gspca/gl860/gl860-ov2640.c	2009-09-18 10:36:24.000000000 +0200
+++ ./linux/drivers/media/video/gspca/gl860/gl860-ov2640.c	2009-09-24 23:34:57.000000000 +0200
@@ -1,6 +1,5 @@
-/* @file gl860-ov2640.c
- * @author Olivier LORIN, from Malmostoso's logs
- * @date 2009-08-27
+/* Subdriver for the GL860 chip with the OV2640 sensor
+ * Author Olivier LORIN, from Malmostoso's logs
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -92,7 +91,7 @@ static struct validx tbl_common[] = {
 	{0x6000, 0x0010},
 };
 
-static struct validx tbl_sensor_settings_common_a[] = {
+static struct validx tbl_sensor_settings_common1[] = {
 	{0x0041, 0x0000}, {0x006a, 0x0007}, {0x00ef, 0x0006}, {0x006a, 0x000d},
 	{0x0000, 0x00c0}, {0x0010, 0x0010}, {0x0001, 0x00c1}, {0x0041, 0x00c2},
 	{0x0004, 0x00d8}, {0x0012, 0x0004}, {0x0000, 0x0058}, {0x0041, 0x0000},
@@ -104,7 +103,7 @@ static struct validx tbl_sensor_settings
 	{0x0040, 0x0000},
 };
 
-static struct validx tbl_sensor_settings_common_b[] = {
+static struct validx tbl_sensor_settings_common2[] = {
 	{0x6001, 0x00ff}, {0x6038, 0x000c},
 	{10, 0xffff},
 	{0x6000, 0x0011},
@@ -166,7 +165,7 @@ static struct validx tbl_800[] = {
 	{0x60ff, 0x00dd}, {0x6020, 0x008c}, {0x6001, 0x00ff}, {0x6044, 0x0018},
 };
 
-static struct validx tbl_big_a[] = {
+static struct validx tbl_big1[] = {
 	{0x0002, 0x00c1}, {0x6000, 0x00ff}, {0x60f1, 0x00dd}, {0x6004, 0x00e0},
 	{0x6001, 0x00ff}, {0x6000, 0x0012}, {0x6000, 0x0000}, {0x6000, 0x0045},
 	{0x6000, 0x0010}, {0x6000, 0x0011}, {0x6011, 0x0017}, {0x6075, 0x0018},
@@ -176,14 +175,14 @@ static struct validx tbl_big_a[] = {
 	{0x60c8, 0x00c0}, {0x6096, 0x00c1}, {0x6000, 0x008c},
 };
 
-static struct validx tbl_big_b[] = {
+static struct validx tbl_big2[] = {
 	{0x603d, 0x0086}, {0x6000, 0x0050}, {0x6090, 0x0051}, {0x602c, 0x0052},
 	{0x6000, 0x0053}, {0x6000, 0x0054}, {0x6088, 0x0055}, {0x6000, 0x0057},
 	{0x6040, 0x005a}, {0x60f0, 0x005b}, {0x6001, 0x005c}, {0x6082, 0x00d3},
 	{0x6000, 0x008e},
 };
 
-static struct validx tbl_big_c[] = {
+static struct validx tbl_big3[] = {
 	{0x6004, 0x00da}, {0x6000, 0x00e0}, {0x6067, 0x00e1}, {0x60ff, 0x00dd},
 	{0x6001, 0x00ff}, {0x6000, 0x00ff}, {0x60f1, 0x00dd}, {0x6004, 0x00e0},
 	{0x6001, 0x00ff}, {0x6000, 0x0011}, {0x6000, 0x00ff}, {0x6010, 0x00c7},
@@ -275,6 +274,8 @@ static int ov2640_init_pre_alt(struct gs
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
+	sd->mirrorMask = 0;
+
 	sd->vold.backlight  = -1;
 	sd->vold.brightness = -1;
 	sd->vold.sharpness  = -1;
@@ -292,16 +293,16 @@ static int ov2640_init_pre_alt(struct gs
 static int ov2640_init_post_alt(struct gspca_dev *gspca_dev)
 {
 	s32 reso = gspca_dev->cam.cam_mode[(s32) gspca_dev->curr_mode].priv;
-	s32 n; /* reserved for FETCH macros */
+	s32 n; /* reserved for FETCH functions */
 
 	ctrl_out(gspca_dev, 0x40, 5, 0x0001, 0x0000, 0, NULL);
 
-	n = fetch_validx(gspca_dev, tbl_sensor_settings_common_a,
-			ARRAY_SIZE(tbl_sensor_settings_common_a));
+	n = fetch_validx(gspca_dev, tbl_sensor_settings_common1,
+			ARRAY_SIZE(tbl_sensor_settings_common1));
 	ctrl_out(gspca_dev, 0x40, 3, 0x0000, 0x0200, 12, dat_post);
 	common(gspca_dev);
-	keep_on_fetching_validx(gspca_dev, tbl_sensor_settings_common_a,
-				ARRAY_SIZE(tbl_sensor_settings_common_a), n);
+	keep_on_fetching_validx(gspca_dev, tbl_sensor_settings_common1,
+				ARRAY_SIZE(tbl_sensor_settings_common1), n);
 
 	switch (reso) {
 	case IMAGE_640:
@@ -316,18 +317,18 @@ static int ov2640_init_post_alt(struct g
 
 	case IMAGE_1600:
 	case IMAGE_1280:
-		n = fetch_validx(gspca_dev, tbl_big_a, ARRAY_SIZE(tbl_big_a));
+		n = fetch_validx(gspca_dev, tbl_big1, ARRAY_SIZE(tbl_big1));
 
 		if (reso == IMAGE_1280) {
-			n = fetch_validx(gspca_dev, tbl_big_b,
-					ARRAY_SIZE(tbl_big_b));
+			n = fetch_validx(gspca_dev, tbl_big2,
+					ARRAY_SIZE(tbl_big2));
 		} else {
 			ctrl_out(gspca_dev, 0x40, 1, 0x601d, 0x0086, 0, NULL);
 			ctrl_out(gspca_dev, 0x40, 1, 0x6001, 0x00d7, 0, NULL);
 			ctrl_out(gspca_dev, 0x40, 1, 0x6082, 0x00d3, 0, NULL);
 		}
 
-		n = fetch_validx(gspca_dev, tbl_big_c, ARRAY_SIZE(tbl_big_c));
+		n = fetch_validx(gspca_dev, tbl_big3, ARRAY_SIZE(tbl_big3));
 
 		if (reso == IMAGE_1280) {
 			ctrl_out(gspca_dev, 0x40, 1, 0x6001, 0x00ff, 0, NULL);
@@ -343,20 +344,20 @@ static int ov2640_init_post_alt(struct g
 		break;
 	}
 
-	n = fetch_validx(gspca_dev, tbl_sensor_settings_common_b,
-			ARRAY_SIZE(tbl_sensor_settings_common_b));
+	n = fetch_validx(gspca_dev, tbl_sensor_settings_common2,
+			ARRAY_SIZE(tbl_sensor_settings_common2));
 	ctrl_in(gspca_dev, 0xc0, 2, 0x0000, 0x0000, 1, c50);
-	keep_on_fetching_validx(gspca_dev, tbl_sensor_settings_common_b,
-				ARRAY_SIZE(tbl_sensor_settings_common_b), n);
+	keep_on_fetching_validx(gspca_dev, tbl_sensor_settings_common2,
+				ARRAY_SIZE(tbl_sensor_settings_common2), n);
 	ctrl_in(gspca_dev, 0xc0, 2, 0x6000, 0x8004, 1, c28);
-	keep_on_fetching_validx(gspca_dev, tbl_sensor_settings_common_b,
-				ARRAY_SIZE(tbl_sensor_settings_common_b), n);
+	keep_on_fetching_validx(gspca_dev, tbl_sensor_settings_common2,
+				ARRAY_SIZE(tbl_sensor_settings_common2), n);
 	ctrl_in(gspca_dev, 0xc0, 2, 0x6000, 0x8004, 1, ca8);
-	keep_on_fetching_validx(gspca_dev, tbl_sensor_settings_common_b,
-				ARRAY_SIZE(tbl_sensor_settings_common_b), n);
+	keep_on_fetching_validx(gspca_dev, tbl_sensor_settings_common2,
+				ARRAY_SIZE(tbl_sensor_settings_common2), n);
 	ctrl_in(gspca_dev, 0xc0, 2, 0x0000, 0x0000, 1, c50);
-	keep_on_fetching_validx(gspca_dev, tbl_sensor_settings_common_b,
-				ARRAY_SIZE(tbl_sensor_settings_common_b), n);
+	keep_on_fetching_validx(gspca_dev, tbl_sensor_settings_common2,
+				ARRAY_SIZE(tbl_sensor_settings_common2), n);
 
 	ov2640_camera_settings(gspca_dev);
 
@@ -395,6 +396,7 @@ static int ov2640_camera_settings(struct
 	s32 wbal   = sd->vcur.whitebal;
 
 	if (backlight != sd->vold.backlight) {
+		/* No sd->vold.backlight=backlight; (to be done again later) */
 		if (backlight < 0 || backlight > sd->vmax.backlight)
 			backlight = 0;
 
@@ -404,7 +406,6 @@ static int ov2640_camera_settings(struct
 				0, NULL);
 		ctrl_out(gspca_dev, 0x40, 1, 0x601f + backlight - 10, 0x0025,
 				0, NULL);
-		/* No sd->vold.backlight=backlight; (to be done again later) */
 	}
 
 	if (bright != sd->vold.brightness) {
diff -rupN ../gspca-msrc/linux/drivers/media/video/gspca/gl860/gl860-ov9655.c ./linux/drivers/media/video/gspca/gl860/gl860-ov9655.c
--- ../gspca-msrc/linux/drivers/media/video/gspca/gl860/gl860-ov9655.c	2009-09-18 10:36:24.000000000 +0200
+++ ./linux/drivers/media/video/gspca/gl860/gl860-ov9655.c	2009-09-24 23:22:35.000000000 +0200
@@ -1,7 +1,6 @@
-/* @file gl860-ov9655.c
- * @author Olivier LORIN, from logs done by Simon (Sur3) and Almighurt
+/* Subdriver for the GL860 chip with the OV9655 sensor
+ * Author Olivier LORIN, from logs done by Simon (Sur3) and Almighurt
  * on dsd's weblog
- * @date 2009-08-27
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -104,14 +103,14 @@ static u8 *tbl_800[] = {
 };
 
 static u8 c04[] = {0x04};
-static u8 dat_post_1[] = "\x04\x00\x10\x20\xa1\x00\x00\x02";
-static u8 dat_post_2[] = "\x10\x10\xc1\x02";
-static u8 dat_post_3[] = "\x04\x00\x10\x7c\xa1\x00\x00\x04";
-static u8 dat_post_4[] = "\x10\x02\xc1\x06";
-static u8 dat_post_5[] = "\x04\x00\x10\x7b\xa1\x00\x00\x08";
-static u8 dat_post_6[] = "\x10\x10\xc1\x05";
-static u8 dat_post_7[] = "\x04\x00\x10\x7c\xa1\x00\x00\x08";
-static u8 dat_post_8[] = "\x04\x00\x10\x7c\xa1\x00\x00\x09";
+static u8 dat_post1[] = "\x04\x00\x10\x20\xa1\x00\x00\x02";
+static u8 dat_post2[] = "\x10\x10\xc1\x02";
+static u8 dat_post3[] = "\x04\x00\x10\x7c\xa1\x00\x00\x04";
+static u8 dat_post4[] = "\x10\x02\xc1\x06";
+static u8 dat_post5[] = "\x04\x00\x10\x7b\xa1\x00\x00\x08";
+static u8 dat_post6[] = "\x10\x10\xc1\x05";
+static u8 dat_post7[] = "\x04\x00\x10\x7c\xa1\x00\x00\x08";
+static u8 dat_post8[] = "\x04\x00\x10\x7c\xa1\x00\x00\x09";
 
 static struct validx tbl_init_post_alt[] = {
 	{0x6032, 0x00ff}, {0x6032, 0x00ff}, {0x6032, 0x00ff}, {0x603c, 0x00ff},
@@ -212,7 +211,7 @@ static int ov9655_init_pre_alt(struct gs
 static int ov9655_init_post_alt(struct gspca_dev *gspca_dev)
 {
 	s32 reso = gspca_dev->cam.cam_mode[(s32) gspca_dev->curr_mode].priv;
-	s32 n; /* reserved for FETCH macros */
+	s32 n; /* reserved for FETCH functions */
 	s32 i;
 	u8 **tbl;
 
@@ -243,7 +242,7 @@ static int ov9655_init_post_alt(struct g
 	ctrl_in(gspca_dev, 0xc0, 2, 0x6000, 0x801e, 1, c04);
 	keep_on_fetching_validx(gspca_dev, tbl_init_post_alt,
 					ARRAY_SIZE(tbl_init_post_alt), n);
-	ctrl_out(gspca_dev, 0x40, 3, 0x6000, 0x0200, 8, dat_post_1);
+	ctrl_out(gspca_dev, 0x40, 3, 0x6000, 0x0200, 8, dat_post1);
 	keep_on_fetching_validx(gspca_dev, tbl_init_post_alt,
 					ARRAY_SIZE(tbl_init_post_alt), n);
 
@@ -259,7 +258,7 @@ static int ov9655_init_post_alt(struct g
 	ctrl_in(gspca_dev, 0xc0, 2, 0x6000, 0x801e, 1, c04);
 	keep_on_fetching_validx(gspca_dev, tbl_init_post_alt,
 					ARRAY_SIZE(tbl_init_post_alt), n);
-	ctrl_out(gspca_dev, 0x40, 3, 0x6000, 0x0200, 8, dat_post_1);
+	ctrl_out(gspca_dev, 0x40, 3, 0x6000, 0x0200, 8, dat_post1);
 	keep_on_fetching_validx(gspca_dev, tbl_init_post_alt,
 					ARRAY_SIZE(tbl_init_post_alt), n);
 
@@ -270,18 +269,18 @@ static int ov9655_init_post_alt(struct g
 	keep_on_fetching_validx(gspca_dev, tbl_init_post_alt,
 					ARRAY_SIZE(tbl_init_post_alt), n);
 
-	ctrl_out(gspca_dev, 0x40, 3, 0x6000, 0x0200, 8, dat_post_1);
+	ctrl_out(gspca_dev, 0x40, 3, 0x6000, 0x0200, 8, dat_post1);
 
-	ctrl_out(gspca_dev, 0x40, 3, 0x0000, 0x0200, 4, dat_post_2);
-	ctrl_out(gspca_dev, 0x40, 3, 0x6000, 0x0200, 8, dat_post_3);
+	ctrl_out(gspca_dev, 0x40, 3, 0x0000, 0x0200, 4, dat_post2);
+	ctrl_out(gspca_dev, 0x40, 3, 0x6000, 0x0200, 8, dat_post3);
 
-	ctrl_out(gspca_dev, 0x40, 3, 0x0000, 0x0200, 4, dat_post_4);
-	ctrl_out(gspca_dev, 0x40, 3, 0x6000, 0x0200, 8, dat_post_5);
+	ctrl_out(gspca_dev, 0x40, 3, 0x0000, 0x0200, 4, dat_post4);
+	ctrl_out(gspca_dev, 0x40, 3, 0x6000, 0x0200, 8, dat_post5);
 
-	ctrl_out(gspca_dev, 0x40, 3, 0x0000, 0x0200, 4, dat_post_6);
-	ctrl_out(gspca_dev, 0x40, 3, 0x6000, 0x0200, 8, dat_post_7);
+	ctrl_out(gspca_dev, 0x40, 3, 0x0000, 0x0200, 4, dat_post6);
+	ctrl_out(gspca_dev, 0x40, 3, 0x6000, 0x0200, 8, dat_post7);
 
-	ctrl_out(gspca_dev, 0x40, 3, 0x6000, 0x0200, 8, dat_post_8);
+	ctrl_out(gspca_dev, 0x40, 3, 0x6000, 0x0200, 8, dat_post8);
 
 	ov9655_camera_settings(gspca_dev);
 


