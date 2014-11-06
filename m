Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:48487 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752155AbaKFJ5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 04:57:22 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 09/10] gpu: ipu-v3: Make use of media_bus_format enum
Date: Thu,  6 Nov 2014 10:57:07 +0100
Message-Id: <1415267829-4177-10-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1415267829-4177-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1415267829-4177-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to have subsytem agnostic media bus format definitions we've
moved media bus definition to include/uapi/linux/media-bus-format.h and
prefixed enum values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.

Reference new definitions in the ipu-v3 driver.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/gpu/ipu-v3/ipu-csi.c | 66 ++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
index d6f56471..752cdd2 100644
--- a/drivers/gpu/ipu-v3/ipu-csi.c
+++ b/drivers/gpu/ipu-v3/ipu-csi.c
@@ -227,83 +227,83 @@ static int ipu_csi_set_testgen_mclk(struct ipu_csi *csi, u32 pixel_clk,
 static int mbus_code_to_bus_cfg(struct ipu_csi_bus_config *cfg, u32 mbus_code)
 {
 	switch (mbus_code) {
-	case V4L2_MBUS_FMT_BGR565_2X8_BE:
-	case V4L2_MBUS_FMT_BGR565_2X8_LE:
-	case V4L2_MBUS_FMT_RGB565_2X8_BE:
-	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_BGR565_2X8_BE:
+	case MEDIA_BUS_FMT_BGR565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_BE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_RGB565;
 		cfg->mipi_dt = MIPI_DT_RGB565;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
-	case V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE:
-	case V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE:
+	case MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_RGB444;
 		cfg->mipi_dt = MIPI_DT_RGB444;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
-	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE:
-	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_RGB555;
 		cfg->mipi_dt = MIPI_DT_RGB555;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_YUV422_UYVY;
 		cfg->mipi_dt = MIPI_DT_YUV422;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
-	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_YUV422_YUYV;
 		cfg->mipi_dt = MIPI_DT_YUV422;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
-	case V4L2_MBUS_FMT_UYVY8_1X16:
+	case MEDIA_BUS_FMT_UYVY8_1X16:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_YUV422_UYVY;
 		cfg->mipi_dt = MIPI_DT_YUV422;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_16;
 		break;
-	case V4L2_MBUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_YUYV8_1X16:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_YUV422_YUYV;
 		cfg->mipi_dt = MIPI_DT_YUV422;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_16;
 		break;
-	case V4L2_MBUS_FMT_SBGGR8_1X8:
-	case V4L2_MBUS_FMT_SGBRG8_1X8:
-	case V4L2_MBUS_FMT_SGRBG8_1X8:
-	case V4L2_MBUS_FMT_SRGGB8_1X8:
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+	case MEDIA_BUS_FMT_SGBRG8_1X8:
+	case MEDIA_BUS_FMT_SGRBG8_1X8:
+	case MEDIA_BUS_FMT_SRGGB8_1X8:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_BAYER;
 		cfg->mipi_dt = MIPI_DT_RAW8;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
-	case V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE:
-	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE:
-	case V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE:
-	case V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE:
+	case MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE:
+	case MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_BE:
+	case MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_LE:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_BAYER;
 		cfg->mipi_dt = MIPI_DT_RAW10;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
-	case V4L2_MBUS_FMT_SBGGR10_1X10:
-	case V4L2_MBUS_FMT_SGBRG10_1X10:
-	case V4L2_MBUS_FMT_SGRBG10_1X10:
-	case V4L2_MBUS_FMT_SRGGB10_1X10:
+	case MEDIA_BUS_FMT_SBGGR10_1X10:
+	case MEDIA_BUS_FMT_SGBRG10_1X10:
+	case MEDIA_BUS_FMT_SGRBG10_1X10:
+	case MEDIA_BUS_FMT_SRGGB10_1X10:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_BAYER;
 		cfg->mipi_dt = MIPI_DT_RAW10;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_10;
 		break;
-	case V4L2_MBUS_FMT_SBGGR12_1X12:
-	case V4L2_MBUS_FMT_SGBRG12_1X12:
-	case V4L2_MBUS_FMT_SGRBG12_1X12:
-	case V4L2_MBUS_FMT_SRGGB12_1X12:
+	case MEDIA_BUS_FMT_SBGGR12_1X12:
+	case MEDIA_BUS_FMT_SGBRG12_1X12:
+	case MEDIA_BUS_FMT_SGRBG12_1X12:
+	case MEDIA_BUS_FMT_SRGGB12_1X12:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_BAYER;
 		cfg->mipi_dt = MIPI_DT_RAW12;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_12;
 		break;
-	case V4L2_MBUS_FMT_JPEG_1X8:
+	case MEDIA_BUS_FMT_JPEG_1X8:
 		/* TODO */
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_JPEG;
 		cfg->mipi_dt = MIPI_DT_RAW8;
-- 
1.9.1

