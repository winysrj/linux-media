Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35265 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbeDSKSu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 06:18:50 -0400
Received: by mail-wr0-f194.google.com with SMTP id w3-v6so12520401wrg.2
        for <linux-media@vger.kernel.org>; Thu, 19 Apr 2018 03:18:49 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH 07/15] media: staging/imx: add 10 bit bayer support
Date: Thu, 19 Apr 2018 11:18:04 +0100
Message-Id: <20180419101812.30688-8-rui.silva@linaro.org>
In-Reply-To: <20180419101812.30688-1-rui.silva@linaro.org>
References: <20180419101812.30688-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some sensors can only output 10 bit bayer formats, like the OV2680. Add support
for that in imx-media.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/imx-media-utils.c | 24 +++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index fab98fc0d6a0..99527daba29a 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -118,6 +118,30 @@ static const struct imx_media_pixfmt rgb_formats[] = {
 		.cs     = IPUV3_COLORSPACE_RGB,
 		.bpp    = 8,
 		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SBGGR10,
+		.codes  = {MEDIA_BUS_FMT_SBGGR10_1X10},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SGBRG10,
+		.codes  = {MEDIA_BUS_FMT_SGBRG10_1X10},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SGRBG10,
+		.codes  = {MEDIA_BUS_FMT_SGRBG10_1X10},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SRGGB10,
+		.codes  = {MEDIA_BUS_FMT_SRGGB10_1X10},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+		.bayer  = true,
 	}, {
 		.fourcc = V4L2_PIX_FMT_SBGGR16,
 		.codes  = {
-- 
2.17.0
