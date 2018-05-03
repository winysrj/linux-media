Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41441 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbeECPGP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 11:06:15 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jan Luebbe <jlu@pengutronix.de>
Subject: [PATCH] media: imx: add 16-bit grayscale support
Date: Thu,  3 May 2018 17:06:06 +0200
Message-Id: <20180503150606.13216-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 50b0f0aee839 ("gpu: ipu-csi: add 10/12-bit grayscale
support to mbus_code_to_bus_cfg") the IPU CSI can be configured to
capture 10-bit and 12-bit grayscale formats, expanded to 16-bit
grayscale, in bayer/generic data mode.
This patch adds support for V4L2_PIX_FMT_Y16 captured from sensors
that provide MEDIA_BUS_FMT_Y10_1X10 or MEDIA_BUS_FMT_Y12_1X12 data.

Cc: Jan Luebbe <jlu@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-csi.c   | 1 +
 drivers/staging/media/imx/imx-media-utils.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 16cab40156ca..1112d8f67a18 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -409,6 +409,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	case V4L2_PIX_FMT_SGBRG16:
 	case V4L2_PIX_FMT_SGRBG16:
 	case V4L2_PIX_FMT_SRGGB16:
+	case V4L2_PIX_FMT_Y16:
 		burst_size = 4;
 		passthrough = true;
 		passthrough_bits = 16;
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index fab98fc0d6a0..7ec2db84451c 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -168,6 +168,15 @@ static const struct imx_media_pixfmt rgb_formats[] = {
 		.cs     = IPUV3_COLORSPACE_RGB,
 		.bpp    = 8,
 		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_Y16,
+		.codes = {
+			MEDIA_BUS_FMT_Y10_1X10,
+			MEDIA_BUS_FMT_Y12_1X12,
+		},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+		.bayer  = true,
 	},
 	/***
 	 * non-mbus RGB formats start here. NOTE! when adding non-mbus
-- 
2.17.0
