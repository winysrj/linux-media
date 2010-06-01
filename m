Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56931 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab0FAW57 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jun 2010 18:57:59 -0400
Received: by mail-ww0-f46.google.com with SMTP id 28so2464375wwb.19
        for <linux-media@vger.kernel.org>; Tue, 01 Jun 2010 15:57:58 -0700 (PDT)
Subject: [PATCH 4/6] gspca - gl860: use of real resolutions for MI2020
 sensor
From: Olivier Lorin <olorin75@gmail.com>
To: V4L Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain
Date: Wed, 02 Jun 2010 00:57:54 +0200
Message-Id: <1275433074.20756.102.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gspca - gl860: use of real resolutions for MI2020 sensor

From: Olivier Lorin <o.lorin@laposte.net>

- Change of rounded image resolutions to the real ones for MI2020 sensor
  in order to discard 2 random lines in the bottom of images

Priority: normal

Signed-off-by: Olivier Lorin <o.lorin@laposte.net>

diff -urpN i3/gl860.c gl860/gl860.c
--- i3/gl860.c	2010-06-01 23:16:59.000000000 +0200
+++ gl860/gl860.c	2010-04-28 23:45:19.000000000 +0200
@@ -219,9 +219,9 @@ static struct v4l2_pix_format mi2020_mod
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
@@ -231,9 +231,9 @@ static struct v4l2_pix_format mi2020_mod
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


