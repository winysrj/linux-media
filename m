Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out01.alice.it ([85.33.2.12]:2553 "EHLO
	smtp-out01.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030791Ab0B0UbJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 15:31:09 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Max Thrun <bear24rw@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 07/11] ov534: Fixes for sharpness control
Date: Sat, 27 Feb 2010 21:20:24 +0100
Message-Id: <1267302028-7941-8-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Max Thrun <bear24rw@gmail.com>

  * Adjust comments for sharpness control
  * Set default value unconditionally, for readability

Signed-off-by: Max Thrun <bear24rw@gmail.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 linux/drivers/media/video/gspca/ov534.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -751,8 +751,8 @@
 	u8 val;
 
 	val = sd->sharpness;
-	sccb_reg_write(gspca_dev, 0x91, val);	/* vga noise */
-	sccb_reg_write(gspca_dev, 0x8e, val);	/* qvga noise */
+	sccb_reg_write(gspca_dev, 0x91, val);	/* Auto de-noise threshold */
+	sccb_reg_write(gspca_dev, 0x8e, val);	/* De-noise threshold */
 }
 
 static void sethflip(struct gspca_dev *gspca_dev)
@@ -809,9 +809,7 @@
 #endif
 	sd->awb = AWB_DEF;
 	sd->aec = AEC_DEF;
-#if SHARPNESS_DEF != 0
 	sd->sharpness = SHARPNESS_DEF;
-#endif
 #if HFLIP_DEF != 0
 	sd->hflip = HFLIP_DEF;
 #endif
