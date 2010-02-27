Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-OUT05A.alice.it ([85.33.3.5]:2350 "EHLO
	smtp-OUT05A.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030778Ab0B0UUy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 15:20:54 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Max Thrun <bear24rw@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 06/11] ov534: Fix Auto White Balance control
Date: Sat, 27 Feb 2010 21:20:23 +0100
Message-Id: <1267302028-7941-7-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Max Thrun <bear24rw@gmail.com>

Set only the needed bits for AWB, and enable it by default.

Signed-off-by: Max Thrun <bear24rw@gmail.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 linux/drivers/media/video/gspca/ov534.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -171,7 +171,7 @@
 		.minimum = 0,
 		.maximum = 1,
 		.step    = 1,
-#define AWB_DEF 0
+#define AWB_DEF 1
 		.default_value = AWB_DEF,
 	},
 	.set = sd_setawb,
@@ -718,10 +718,17 @@
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	if (sd->awb)
-		sccb_reg_write(gspca_dev, 0x63, 0xe0);	/* AWB on */
-	else
-		sccb_reg_write(gspca_dev, 0x63, 0xaa);	/* AWB off */
+	if (sd->awb) {
+		sccb_reg_write(gspca_dev, 0x13,
+				sccb_reg_read(gspca_dev, 0x13) | 0x02);
+		sccb_reg_write(gspca_dev, 0x63,
+				sccb_reg_read(gspca_dev, 0x63) | 0xc0);
+	} else {
+		sccb_reg_write(gspca_dev, 0x13,
+				sccb_reg_read(gspca_dev, 0x13) & ~0x02);
+		sccb_reg_write(gspca_dev, 0x63,
+				sccb_reg_read(gspca_dev, 0x63) & ~0xc0);
+	}
 }
 
 static void setaec(struct gspca_dev *gspca_dev)
@@ -800,9 +807,7 @@
 #else
 	gspca_dev->ctrl_inac |= (1 << AWB_IDX);
 #endif
-#if AWB_DEF != 0
-	sd->awb = AWB_DEF
-#endif
+	sd->awb = AWB_DEF;
 	sd->aec = AEC_DEF;
 #if SHARPNESS_DEF != 0
 	sd->sharpness = SHARPNESS_DEF;
