Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out116.alice.it ([85.37.17.116]:4844 "EHLO
	smtp-out116.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030801Ab0B0UbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 15:31:10 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	Max Thrun <bear24rw@gmail.com>
Subject: [PATCH 05/11] ov534: Fix setting manual exposure
Date: Sat, 27 Feb 2010 21:20:22 +0100
Message-Id: <1267302028-7941-6-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exposure is now a u16 value, both MSB and LSB are set, but values in the v4l2
control are limited to the interval [0,506] as 0x01fa (506) is the maximum
observed value with AEC enabled.

Skip setting exposure when AEC is enabled.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 linux/drivers/media/video/gspca/ov534.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -59,7 +59,7 @@
 	u8 brightness;
 	u8 contrast;
 	u8 gain;
-	u8 exposure;
+	u16 exposure;
 	u8 agc;
 	u8 awb;
 	u8 aec;
@@ -140,7 +140,7 @@
 	    .type    = V4L2_CTRL_TYPE_INTEGER,
 	    .name    = "Exposure",
 	    .minimum = 0,
-	    .maximum = 255,
+	    .maximum = 506,
 	    .step    = 1,
 #define EXPO_DEF 120
 	    .default_value = EXPO_DEF,
@@ -684,11 +684,15 @@
 static void setexposure(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	u8 val;
+	u16 val;
+
+	if (sd->aec)
+		return;
 
 	val = sd->exposure;
-	sccb_reg_write(gspca_dev, 0x08, val >> 7);
-	sccb_reg_write(gspca_dev, 0x10, val << 1);
+	sccb_reg_write(gspca_dev, 0x08, val >> 8);
+	sccb_reg_write(gspca_dev, 0x10, val & 0xff);
+
 }
 
 static void setagc(struct gspca_dev *gspca_dev)
