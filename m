Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57473 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbeIRPO0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 11:14:26 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>, kernel@pengutronix.de
Subject: [PATCH] media: imx: use well defined 32-bit RGB pixel format
Date: Tue, 18 Sep 2018 11:42:31 +0200
Message-Id: <20180918094231.20815-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation in Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
tells us that the V4L2_PIX_FMT_RGB32 format is deprecated and must not
be used by new drivers. Replace it with V4L2_PIX_FMT_XRGB32.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 8aa13403b09d..0eaa353d5cb3 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -88,7 +88,7 @@ static const struct imx_media_pixfmt rgb_formats[] = {
 		.cs     = IPUV3_COLORSPACE_RGB,
 		.bpp    = 24,
 	}, {
-		.fourcc	= V4L2_PIX_FMT_RGB32,
+		.fourcc	= V4L2_PIX_FMT_XRGB32,
 		.codes  = {MEDIA_BUS_FMT_ARGB8888_1X32},
 		.cs     = IPUV3_COLORSPACE_RGB,
 		.bpp    = 32,
@@ -212,7 +212,7 @@ static const struct imx_media_pixfmt ipu_yuv_formats[] = {
 
 static const struct imx_media_pixfmt ipu_rgb_formats[] = {
 	{
-		.fourcc	= V4L2_PIX_FMT_RGB32,
+		.fourcc	= V4L2_PIX_FMT_XRGB32,
 		.codes  = {MEDIA_BUS_FMT_ARGB8888_1X32},
 		.cs     = IPUV3_COLORSPACE_RGB,
 		.bpp    = 32,
-- 
2.19.0
