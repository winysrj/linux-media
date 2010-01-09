Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out13.alice.it ([85.33.2.18]:3821 "EHLO
	smtp-out13.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab0AIAmv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2010 19:42:51 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: [PATCH] ov534: allow enumerating supported framerates
Date: Sat,  9 Jan 2010 01:41:31 +0100
Message-Id: <1262997691-20651-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

---

Historical note:

This has been re-tested on a reliable machine and it works from guvcview for
all the framerates; on my old PC I am still having problems with 640x480@60fps
_regardless_ of this change, so it must be a USB problem.

Thanks,
   Antonio

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -282,6 +282,21 @@
 	 .priv = 0},
 };
 
+static const int qvga_rates[] = {125, 100, 75, 60, 50, 40, 30};
+static const int vga_rates[] = {60, 50, 40, 30, 15};
+
+static const struct framerates ov772x_framerates[] = {
+	{ /* 320x240 */
+		.rates = qvga_rates,
+		.nrates = ARRAY_SIZE(qvga_rates),
+	},
+	{ /* 640x480 */
+		.rates = vga_rates,
+		.nrates = ARRAY_SIZE(vga_rates),
+	},
+};
+
+
 static const u8 bridge_init[][2] = {
 	{ 0xc2, 0x0c },
 	{ 0x88, 0xf8 },
@@ -799,6 +814,7 @@
 
 	cam->cam_mode = ov772x_mode;
 	cam->nmodes = ARRAY_SIZE(ov772x_mode);
+	cam->mode_framerates = ov772x_framerates;
 
 	cam->bulk = 1;
 	cam->bulk_size = 16384;
