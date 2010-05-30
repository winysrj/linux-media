Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:62445 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0E3WYZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 18:24:25 -0400
Received: by wwb28 with SMTP id 28so913563wwb.19
        for <linux-media@vger.kernel.org>; Sun, 30 May 2010 15:24:23 -0700 (PDT)
Subject: [PATCH 1/3] Gspca-gl860 driver update
From: Olivier Lorin <olorin75@gmail.com>
To: V4L Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain
Date: Mon, 31 May 2010 00:24:21 +0200
Message-Id: <1275258261.18267.23.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gspca - gl860: minor fixes

From: Olivier Lorin <o.lorin@laposte.net>

- Change of rounded image resolutions to the real ones
- Fix for an irrelevant OV9655 image resolution identifier name
- Extra spaces to align some variable names and a defined value

Priority: normal

Signed-off-by: Olivier Lorin <o.lorin@laposte.net>

diff -rupN der_gl860b/gl860.c gl860/gl860.c
--- der_gl860b/gl860.c	2010-03-27 10:08:16.000000000 +0100
+++ gl860/gl860.c	2010-04-28 23:26:53.000000000 +0200
@@ -235,9 +235,9 @@ static struct v4l2_pix_format mi2020_mod
 		.colorspace = V4L2_COLORSPACE_SRGB,
 		.priv = 0
 	},
-	{ 800,  600, V4L2_PIX_FMT_SGBRG8, V4L2_FIELD_NONE,
+	{ 800,  598, V4L2_PIX_FMT_SGBRG8, V4L2_FIELD_NONE,
 		.bytesperline = 800,
-		.sizeimage = 800 * 600,
+		.sizeimage = 800 * 598,
 		.colorspace = V4L2_COLORSPACE_SRGB,
 		.priv = 1
 	},
@@ -247,9 +247,9 @@ static struct v4l2_pix_format mi2020_mod
 		.colorspace = V4L2_COLORSPACE_SRGB,
 		.priv = 2
 	},
-	{1600, 1200, V4L2_PIX_FMT_SGBRG8, V4L2_FIELD_NONE,
+	{1600, 1198, V4L2_PIX_FMT_SGBRG8, V4L2_FIELD_NONE,
 		.bytesperline = 1600,
-		.sizeimage = 1600 * 1200,
+		.sizeimage = 1600 * 1198,
 		.colorspace = V4L2_COLORSPACE_SRGB,
 		.priv = 3
 	},
diff -rupN der_gl860b/gl860.h gl860/gl860.h
--- der_gl860b/gl860.h	2010-03-27 10:08:25.000000000 +0100
+++ gl860/gl860.h	2010-04-28 13:56:51.000000000 +0200
@@ -44,7 +44,7 @@
 #define IMAGE_640   0
 #define IMAGE_800   1
 #define IMAGE_1280  2
-#define IMAGE_1600 3
+#define IMAGE_1600  3
 
 struct sd_gl860 {
 	u16 backlight;
@@ -75,10 +75,10 @@ struct sd {
 	int  (*dev_camera_settings)(struct gspca_dev *);
 
 	u8   swapRB;
-	u8  mirrorMask;
-	u8  sensor;
-	s32 nbIm;
-	s32 nbRightUp;
+	u8   mirrorMask;
+	u8   sensor;
+	s32  nbIm;
+	s32  nbRightUp;
 	u8   waitSet;
 };
 
diff -rupN der_gl860b/gl860-ov9655.c gl860/gl860-ov9655.c
--- der_gl860b/gl860-ov9655.c	2010-03-27 10:08:16.000000000 +0100
+++ gl860/gl860-ov9655.c	2010-04-28 13:39:14.000000000 +0200
@@ -69,7 +69,7 @@ static u8 *tbl_640[] = {
 	"\xd0\x01\xd1\x08\xd2\xe0\xd3\x01" "\xd4\x10\xd5\x80"
 };
 
-static u8 *tbl_800[] = {
+static u8 *tbl_1280[] = {
 	"\x00\x40\x07\x6a\x06\xf3\x0d\x6a" "\x10\x10\xc1\x01"
 	,
 	"\x12\x80\x00\x00\x01\x98\x02\x80" "\x03\x12\x04\x01\x0b\x57\x0e\x61"
@@ -217,7 +217,7 @@ static int ov9655_init_post_alt(struct g
 
 	ctrl_out(gspca_dev, 0x40, 5, 0x0001, 0x0000, 0, NULL);
 
-	tbl = (reso == IMAGE_640) ? tbl_640 : tbl_800;
+	tbl = (reso == IMAGE_640) ? tbl_640 : tbl_1280;
 
 	ctrl_out(gspca_dev, 0x40, 3, 0x0000, 0x0200,
 			tbl_length[0], tbl[0]);


