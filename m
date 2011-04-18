Return-path: <mchehab@pedra>
Received: from smtp24.services.sfr.fr ([93.17.128.83]:65369 "EHLO
	smtp24.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1DRUjj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 16:39:39 -0400
Message-ID: <4DACA18A.2060000@sfr.fr>
Date: Mon, 18 Apr 2011 22:39:38 +0200
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: [PATCH 3/5] gspca - jeilinj: add 640*480 resolution support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Patrice CHOTARD <patricechotard@free.fr>
---
 drivers/media/video/gspca/jeilinj.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/gspca/jeilinj.c b/drivers/media/video/gspca/jeilinj.c
index 32494fb..51b68db 100644
--- a/drivers/media/video/gspca/jeilinj.c
+++ b/drivers/media/video/gspca/jeilinj.c
@@ -62,6 +62,11 @@ static struct v4l2_pix_format jlj_mode[] = {
 		.bytesperline = 320,
 		.sizeimage = 320 * 240,
 		.colorspace = V4L2_COLORSPACE_JPEG,
+		.priv = 0},
+	{ 640, 480, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
+		.bytesperline = 640,
+		.sizeimage = 640 * 480,
+		.colorspace = V4L2_COLORSPACE_JPEG,
 		.priv = 0}
 };
 
@@ -207,7 +212,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 		"JEILINJ camera detected"
 		" (vid/pid 0x%04X:0x%04X)", id->idVendor, id->idProduct);
 	cam->cam_mode = jlj_mode;
-	cam->nmodes = 1;
+	cam->nmodes = ARRAY_SIZE(jlj_mode);
 	cam->bulk = 1;
 	cam->bulk_nurbs = 1;
 	cam->bulk_size = JEILINJ_MAX_TRANSFER;
@@ -264,7 +269,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	jpeg_define(dev->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x21);          /* JPEG 422 */
 	jpeg_set_qual(dev->jpeg_hdr, dev->quality);
-	PDEBUG(D_STREAM, "Start streaming at 320x240");
+	PDEBUG(D_STREAM, "Start streaming at %dx%d",
+		gspca_dev->height, gspca_dev->width);
 	jlj_start(gspca_dev);
 	return gspca_dev->usb_err;
 }
-- 
1.7.0.4

