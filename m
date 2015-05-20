Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56776 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932214AbbEUJDk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:03:40 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 19/20] media: rcar_vin: Clean up format debugging statements
Date: Wed, 20 May 2015 17:39:39 +0100
Message-Id: <1432139980-12619-20-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pretty print fourcc and code in format debugging statements.

Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
Reviewed-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index b530503..0bebca5 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -39,6 +39,9 @@
 
 #include "soc_scale_crop.h"
 
+#define pixfmtstr(x) (x) & 0xff, ((x) >> 8) & 0xff, ((x) >> 16) & 0xff, \
+	((x) >> 24) & 0xff
+
 #define DRV_NAME "rcar_vin"
 
 /* Register offsets for R-Car VIN */
@@ -1352,10 +1355,12 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 
 	fmt = soc_mbus_get_fmtdesc(code.code);
 	if (!fmt) {
-		dev_warn(dev, "unsupported format code #%u: %d\n", idx, code.code);
+		dev_warn(dev, "unsupported format code #%u: %x\n", idx, code.code);
 		return 0;
 	}
 
+	dev_dbg(dev, "Supported format: %x (%c%c%c%c)", code.code, pixfmtstr(fmt->fourcc));
+
 	ret = rcar_vin_try_bus_param(icd, fmt->bits_per_sample);
 	if (ret < 0)
 		return 0;
@@ -1456,7 +1461,7 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 		for (k = 0; xlate && k < n; k++, xlate++) {
 			xlate->host_fmt = &rcar_vin_formats[k];
 			xlate->code = code.code;
-			dev_dbg(dev, "Providing format %s using code %d\n",
+			dev_dbg(dev, "Providing format %s using code %x\n",
 				rcar_vin_formats[k].name, code.code);
 		}
 		break;
@@ -1596,8 +1601,8 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
 	enum v4l2_field field;
 	v4l2_std_id std;
 
-	dev_dbg(dev, "S_FMT(pix=0x%x, %ux%u)\n",
-		pixfmt, pix->width, pix->height);
+	dev_dbg(dev, "S_FMT(pix=%c%c%c%c, %ux%u)\n",
+		pixfmtstr(pixfmt), pix->width, pix->height);
 
 	switch (pix->field) {
 	default:
@@ -1623,7 +1628,7 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(dev, "Format %x not found\n", pixfmt);
+		dev_warn(dev, "Format %c%c%c%c not found\n", pixfmtstr(pixfmt));
 		return -EINVAL;
 	}
 	/* Calculate client output geometry */
@@ -1720,11 +1725,14 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	int width, height;
 	int ret;
 
+	dev_dbg(icd->parent, "TRY_FMT(%c%c%c%c, %ux%u)\n",
+		pixfmtstr(pix->pixelformat), pix->width, pix->height);
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
 		xlate = icd->current_fmt;
-		dev_dbg(icd->parent, "Format %x not found, keeping %x\n",
-			pixfmt, xlate->host_fmt->fourcc);
+		dev_dbg(icd->parent, "Format %c%c%c%c not found, keeping %x\n",
+			pixfmtstr(pixfmt), xlate->host_fmt->fourcc);
 		pixfmt = xlate->host_fmt->fourcc;
 		pix->pixelformat = pixfmt;
 		pix->colorspace = icd->colorspace;
-- 
1.7.10.4

