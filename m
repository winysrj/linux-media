Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out30.alice.it ([85.33.2.30]:1625 "EHLO
	smtp-out30.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030814Ab0B0Ubv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 15:31:51 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Max Thrun <bear24rw@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 08/11] ov534: Fix unsetting hflip and vflip bits
Date: Sat, 27 Feb 2010 21:20:25 +0100
Message-Id: <1267302028-7941-9-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Max Thrun <bear24rw@gmail.com>

Also set default values unconditionally, for readability.

Signed-off-by: Max Thrun <bear24rw@gmail.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 linux/drivers/media/video/gspca/ov534.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -764,7 +764,7 @@
 				sccb_reg_read(gspca_dev, 0x0c) | 0x40);
 	else
 		sccb_reg_write(gspca_dev, 0x0c,
-				sccb_reg_read(gspca_dev, 0x0c) & 0xbf);
+				sccb_reg_read(gspca_dev, 0x0c) & ~0x40);
 }
 
 static void setvflip(struct gspca_dev *gspca_dev)
@@ -776,7 +776,7 @@
 				sccb_reg_read(gspca_dev, 0x0c) | 0x80);
 	else
 		sccb_reg_write(gspca_dev, 0x0c,
-				sccb_reg_read(gspca_dev, 0x0c) & 0x7f);
+				sccb_reg_read(gspca_dev, 0x0c) & ~0x80);
 }
 
 /* this function is called at probe time */
@@ -810,12 +810,8 @@
 	sd->awb = AWB_DEF;
 	sd->aec = AEC_DEF;
 	sd->sharpness = SHARPNESS_DEF;
-#if HFLIP_DEF != 0
 	sd->hflip = HFLIP_DEF;
-#endif
-#if VFLIP_DEF != 0
 	sd->vflip = VFLIP_DEF;
-#endif
 
 	return 0;
 }
