Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48026 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab0FAW6N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jun 2010 18:58:13 -0400
Received: by mail-wy0-f174.google.com with SMTP id 11so1438372wyi.19
        for <linux-media@vger.kernel.org>; Tue, 01 Jun 2010 15:58:12 -0700 (PDT)
Subject: [PATCH 6/6] gspca - gl860: text alignment
From: Olivier Lorin <olorin75@gmail.com>
To: V4L Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain
Date: Wed, 02 Jun 2010 00:58:06 +0200
Message-Id: <1275433086.20756.104.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gspca - gl860: text alignment

From: Olivier Lorin <o.lorin@laposte.net>

- Extra spaces to align some variable names and a defined value

Priority: normal

Signed-off-by: Olivier Lorin <o.lorin@laposte.net>

diff -urpN i5/gl860.h gl860/gl860.h
--- i5/gl860.h	2010-06-01 23:20:10.000000000 +0200
+++ gl860/gl860.h	2010-04-28 13:36:36.000000000 +0200
@@ -41,7 +41,7 @@
 #define IMAGE_640   0
 #define IMAGE_800   1
 #define IMAGE_1280  2
-#define IMAGE_1600 3
+#define IMAGE_1600  3
 
 struct sd_gl860 {
 	u16 backlight;
@@ -72,10 +72,10 @@ struct sd {
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
 


