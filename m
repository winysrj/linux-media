Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58886 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759290AbZLPPGB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 10:06:01 -0500
Message-ID: <4B28F7C9.5040206@gmail.com>
Date: Wed, 16 Dec 2009 16:07:53 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] gspca: Fix tests of unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

val and sd->gain are unsigned so the tests did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

diff --git a/drivers/media/video/gspca/ov534.c b/drivers/media/video/gspca/ov534.c
index 4dbb882..f5d1f18 100644
--- a/drivers/media/video/gspca/ov534.c
+++ b/drivers/media/video/gspca/ov534.c
@@ -1536,7 +1536,7 @@ static void setsharpness_96(struct gspca_dev *gspca_dev)
 	u8 val;
 
 	val = sd->sharpness;
-	if (val < 0) {				/* auto */
+	if (val == -1) {				/* auto */
 		val = sccb_reg_read(gspca_dev, 0x42);	/* com17 */
 		sccb_reg_write(gspca_dev, 0xff, 0x00);
 		sccb_reg_write(gspca_dev, 0x42, val | 0x40);
diff --git a/drivers/media/video/gspca/sn9c20x.c b/drivers/media/video/gspca/sn9c20x.c
index b1944a7..7ebabe7 100644
--- a/drivers/media/video/gspca/sn9c20x.c
+++ b/drivers/media/video/gspca/sn9c20x.c
@@ -2319,7 +2319,7 @@ static void do_autogain(struct gspca_dev *gspca_dev, u16 avg_lum)
 		}
 	}
 	if (avg_lum > MAX_AVG_LUM) {
-		if (sd->gain - 1 >= 0) {
+		if (sd->gain >= 1) {
 			sd->gain--;
 			set_gain(gspca_dev);
 		}
