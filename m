Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:57080 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752381AbcIKJCk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Sep 2016 05:02:40 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] pxa_camera: merge soc_mediabus.c into pxa_camera.c
Message-ID: <874d9ba3-7508-7efd-e83f-a7c630a1fbe3@xs4all.nl>
Date: Sun, 11 Sep 2016 11:02:33 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linking soc_mediabus into this driver causes multiple definition linker warnings
if soc_camera is also enabled:

   drivers/media/platform/soc_camera/built-in.o:(___ksymtab+soc_mbus_image_size+0x0): multiple definition of `__ksymtab_soc_mbus_image_size'
   drivers/media/platform/soc_camera/soc_mediabus.o:(___ksymtab+soc_mbus_image_size+0x0): first defined here
>> drivers/media/platform/soc_camera/built-in.o:(___ksymtab+soc_mbus_samples_per_pixel+0x0): multiple definition of `__ksymtab_soc_mbus_samples_per_pixel'
   drivers/media/platform/soc_camera/soc_mediabus.o:(___ksymtab+soc_mbus_samples_per_pixel+0x0): first defined here
   drivers/media/platform/soc_camera/built-in.o: In function `soc_mbus_config_compatible':
   (.text+0x3840): multiple definition of `soc_mbus_config_compatible'
   drivers/media/platform/soc_camera/soc_mediabus.o:(.text+0x134): first defined here

Since we really don't want to have to use any of the soc-camera code this patch
copies the relevant code and data structures from soc_mediabus and renames it to pxa_mbus_*.

The large table of formats has been culled a bit, removing formats that are not supported
by this driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/Makefile     |   2 +-
 drivers/media/platform/pxa_camera.c | 482 ++++++++++++++++++++++++++++++++++--
 2 files changed, 459 insertions(+), 25 deletions(-)

diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index c645a50..40b18d1 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
 obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/

 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
-obj-$(CONFIG_VIDEO_PXA27x)	+= pxa_camera.o soc_camera/soc_mediabus.o
+obj-$(CONFIG_VIDEO_PXA27x)	+= pxa_camera.o

 obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 1147836..1bce7eb 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -42,7 +42,6 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-of.h>

-#include <media/drv-intf/soc_mediabus.h>
 #include <media/videobuf2-dma-sg.h>

 #include <linux/videodev2.h>
@@ -183,6 +182,441 @@
 /*
  * Format handling
  */
+
+/**
+ * enum pxa_mbus_packing - data packing types on the media-bus
+ * @PXA_MBUS_PACKING_NONE:	no packing, bit-for-bit transfer to RAM, one
+ *				sample represents one pixel
+ * @PXA_MBUS_PACKING_2X8_PADHI:	16 bits transferred in 2 8-bit samples, in the
+ *				possibly incomplete byte high bits are padding
+ * @PXA_MBUS_PACKING_EXTEND16:	sample width (e.g., 10 bits) has to be extended
+ *				to 16 bits
+ */
+enum pxa_mbus_packing {
+	PXA_MBUS_PACKING_NONE,
+	PXA_MBUS_PACKING_2X8_PADHI,
+	PXA_MBUS_PACKING_EXTEND16,
+};
+
+/**
+ * enum pxa_mbus_order - sample order on the media bus
+ * @PXA_MBUS_ORDER_LE:		least significant sample first
+ * @PXA_MBUS_ORDER_BE:		most significant sample first
+ */
+enum pxa_mbus_order {
+	PXA_MBUS_ORDER_LE,
+	PXA_MBUS_ORDER_BE,
+};
+
+/**
+ * enum pxa_mbus_layout - planes layout in memory
+ * @PXA_MBUS_LAYOUT_PACKED:		color components packed
+ * @PXA_MBUS_LAYOUT_PLANAR_2Y_U_V:	YUV components stored in 3 planes (4:2:2)
+ * @PXA_MBUS_LAYOUT_PLANAR_2Y_C:	YUV components stored in a luma and a
+ *					chroma plane (C plane is half the size
+ *					of Y plane)
+ * @PXA_MBUS_LAYOUT_PLANAR_Y_C:		YUV components stored in a luma and a
+ *					chroma plane (C plane is the same size
+ *					as Y plane)
+ */
+enum pxa_mbus_layout {
+	PXA_MBUS_LAYOUT_PACKED = 0,
+	PXA_MBUS_LAYOUT_PLANAR_2Y_U_V,
+	PXA_MBUS_LAYOUT_PLANAR_2Y_C,
+	PXA_MBUS_LAYOUT_PLANAR_Y_C,
+};
+
+/**
+ * struct pxa_mbus_pixelfmt - Data format on the media bus
+ * @name:		Name of the format
+ * @fourcc:		Fourcc code, that will be obtained if the data is
+ *			stored in memory in the following way:
+ * @packing:		Type of sample-packing, that has to be used
+ * @order:		Sample order when storing in memory
+ * @bits_per_sample:	How many bits the bridge has to sample
+ */
+struct pxa_mbus_pixelfmt {
+	const char		*name;
+	u32			fourcc;
+	enum pxa_mbus_packing	packing;
+	enum pxa_mbus_order	order;
+	enum pxa_mbus_layout	layout;
+	u8			bits_per_sample;
+};
+
+/**
+ * struct pxa_mbus_lookup - Lookup FOURCC IDs by mediabus codes for pass-through
+ * @code:	mediabus pixel-code
+ * @fmt:	pixel format description
+ */
+struct pxa_mbus_lookup {
+	u32	code;
+	struct pxa_mbus_pixelfmt	fmt;
+};
+
+static const struct pxa_mbus_lookup mbus_fmt[] = {
+{
+	.code = MEDIA_BUS_FMT_YUYV8_2X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_YUYV,
+		.name			= "YUYV",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_2X8_PADHI,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_YVYU8_2X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_YVYU,
+		.name			= "YVYU",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_2X8_PADHI,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_UYVY8_2X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_UYVY,
+		.name			= "UYVY",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_2X8_PADHI,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_VYUY8_2X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_VYUY,
+		.name			= "VYUY",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_2X8_PADHI,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_RGB555,
+		.name			= "RGB555",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_2X8_PADHI,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_RGB555X,
+		.name			= "RGB555X",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_2X8_PADHI,
+		.order			= PXA_MBUS_ORDER_BE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_RGB565_2X8_LE,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_RGB565,
+		.name			= "RGB565",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_2X8_PADHI,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_RGB565_2X8_BE,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_RGB565X,
+		.name			= "RGB565X",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_2X8_PADHI,
+		.order			= PXA_MBUS_ORDER_BE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SBGGR8_1X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR8,
+		.name			= "Bayer 8 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_NONE,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SBGGR10_1X10,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 10,
+		.packing		= PXA_MBUS_PACKING_EXTEND16,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_Y8_1X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_GREY,
+		.name			= "Grey",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_NONE,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_Y10_1X10,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_Y10,
+		.name			= "Grey 10bit",
+		.bits_per_sample	= 10,
+		.packing		= PXA_MBUS_PACKING_EXTEND16,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_2X8_PADHI,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_2X8_PADHI,
+		.order			= PXA_MBUS_ORDER_BE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_RGB444,
+		.name			= "RGB444",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_2X8_PADHI,
+		.order			= PXA_MBUS_ORDER_BE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_UYVY8_1X16,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_UYVY,
+		.name			= "UYVY 16bit",
+		.bits_per_sample	= 16,
+		.packing		= PXA_MBUS_PACKING_EXTEND16,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_VYUY8_1X16,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_VYUY,
+		.name			= "VYUY 16bit",
+		.bits_per_sample	= 16,
+		.packing		= PXA_MBUS_PACKING_EXTEND16,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_YUYV8_1X16,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_YUYV,
+		.name			= "YUYV 16bit",
+		.bits_per_sample	= 16,
+		.packing		= PXA_MBUS_PACKING_EXTEND16,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_YVYU8_1X16,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_YVYU,
+		.name			= "YVYU 16bit",
+		.bits_per_sample	= 16,
+		.packing		= PXA_MBUS_PACKING_EXTEND16,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SGRBG8_1X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGRBG8,
+		.name			= "Bayer 8 GRBG",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_NONE,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGRBG10DPCM8,
+		.name			= "Bayer 10 BGGR DPCM 8",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_NONE,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SGBRG10_1X10,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGBRG10,
+		.name			= "Bayer 10 GBRG",
+		.bits_per_sample	= 10,
+		.packing		= PXA_MBUS_PACKING_EXTEND16,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SGRBG10_1X10,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGRBG10,
+		.name			= "Bayer 10 GRBG",
+		.bits_per_sample	= 10,
+		.packing		= PXA_MBUS_PACKING_EXTEND16,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SRGGB10_1X10,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SRGGB10,
+		.name			= "Bayer 10 RGGB",
+		.bits_per_sample	= 10,
+		.packing		= PXA_MBUS_PACKING_EXTEND16,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SBGGR12_1X12,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR12,
+		.name			= "Bayer 12 BGGR",
+		.bits_per_sample	= 12,
+		.packing		= PXA_MBUS_PACKING_EXTEND16,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SGBRG12_1X12,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGBRG12,
+		.name			= "Bayer 12 GBRG",
+		.bits_per_sample	= 12,
+		.packing		= PXA_MBUS_PACKING_EXTEND16,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SGRBG12_1X12,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGRBG12,
+		.name			= "Bayer 12 GRBG",
+		.bits_per_sample	= 12,
+		.packing		= PXA_MBUS_PACKING_EXTEND16,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SRGGB12_1X12,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SRGGB12,
+		.name			= "Bayer 12 RGGB",
+		.bits_per_sample	= 12,
+		.packing		= PXA_MBUS_PACKING_EXTEND16,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+},
+};
+
+static s32 pxa_mbus_bytes_per_line(u32 width, const struct pxa_mbus_pixelfmt *mf)
+{
+	if (mf->layout != PXA_MBUS_LAYOUT_PACKED)
+		return width * mf->bits_per_sample / 8;
+
+	switch (mf->packing) {
+	case PXA_MBUS_PACKING_NONE:
+		return width * mf->bits_per_sample / 8;
+	case PXA_MBUS_PACKING_2X8_PADHI:
+	case PXA_MBUS_PACKING_EXTEND16:
+		return width * 2;
+	}
+	return -EINVAL;
+}
+
+static s32 pxa_mbus_image_size(const struct pxa_mbus_pixelfmt *mf,
+			u32 bytes_per_line, u32 height)
+{
+	switch (mf->packing) {
+	case PXA_MBUS_PACKING_2X8_PADHI:
+		return bytes_per_line * height * 2;
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct pxa_mbus_pixelfmt *pxa_mbus_find_fmtdesc(
+	u32 code,
+	const struct pxa_mbus_lookup *lookup,
+	int n)
+{
+	int i;
+
+	for (i = 0; i < n; i++)
+		if (lookup[i].code == code)
+			return &lookup[i].fmt;
+
+	return NULL;
+}
+
+static const struct pxa_mbus_pixelfmt *pxa_mbus_get_fmtdesc(
+	u32 code)
+{
+	return pxa_mbus_find_fmtdesc(code, mbus_fmt, ARRAY_SIZE(mbus_fmt));
+}
+
+static unsigned int pxa_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
+					unsigned int flags)
+{
+	unsigned long common_flags;
+	bool hsync = true, vsync = true, pclk, data, mode;
+	bool mipi_lanes, mipi_clock;
+
+	common_flags = cfg->flags & flags;
+
+	switch (cfg->type) {
+	case V4L2_MBUS_PARALLEL:
+		hsync = common_flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH |
+					V4L2_MBUS_HSYNC_ACTIVE_LOW);
+		vsync = common_flags & (V4L2_MBUS_VSYNC_ACTIVE_HIGH |
+					V4L2_MBUS_VSYNC_ACTIVE_LOW);
+		/* fall through */
+	case V4L2_MBUS_BT656:
+		pclk = common_flags & (V4L2_MBUS_PCLK_SAMPLE_RISING |
+				       V4L2_MBUS_PCLK_SAMPLE_FALLING);
+		data = common_flags & (V4L2_MBUS_DATA_ACTIVE_HIGH |
+				       V4L2_MBUS_DATA_ACTIVE_LOW);
+		mode = common_flags & (V4L2_MBUS_MASTER | V4L2_MBUS_SLAVE);
+		return (!hsync || !vsync || !pclk || !data || !mode) ?
+			0 : common_flags;
+	case V4L2_MBUS_CSI2:
+		mipi_lanes = common_flags & V4L2_MBUS_CSI2_LANES;
+		mipi_clock = common_flags & (V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK |
+					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
+		return (!mipi_lanes || !mipi_clock) ? 0 : common_flags;
+	}
+	return 0;
+}
+
 /**
  * struct soc_camera_format_xlate - match between host and sensor formats
  * @code: code of a sensor provided format
@@ -195,7 +629,7 @@
  */
 struct soc_camera_format_xlate {
 	u32 code;
-	const struct soc_mbus_pixelfmt *host_fmt;
+	const struct pxa_mbus_pixelfmt *host_fmt;
 };

 /*
@@ -281,7 +715,7 @@ static const char *pxa_cam_driver_description = "PXA_Camera";
  * Format translation functions
  */
 static const struct soc_camera_format_xlate
-*soc_mbus_xlate_by_fourcc(struct soc_camera_format_xlate *user_formats,
+*pxa_mbus_xlate_by_fourcc(struct soc_camera_format_xlate *user_formats,
 			  unsigned int fourcc)
 {
 	unsigned int i;
@@ -292,7 +726,7 @@ static const struct soc_camera_format_xlate
 	return NULL;
 }

-static struct soc_camera_format_xlate *soc_mbus_build_fmts_xlate(
+static struct soc_camera_format_xlate *pxa_mbus_build_fmts_xlate(
 	struct v4l2_device *v4l2_dev, struct v4l2_subdev *subdev,
 	int (*get_formats)(struct v4l2_device *, unsigned int,
 			   struct soc_camera_format_xlate *xlate))
@@ -1151,7 +1585,7 @@ static int pxa_camera_set_bus_param(struct pxa_camera_dev *pcdev)

 	ret = sensor_call(pcdev, video, g_mbus_config, &cfg);
 	if (!ret) {
-		common_flags = soc_mbus_config_compatible(&cfg,
+		common_flags = pxa_mbus_config_compatible(&cfg,
 							  bus_flags);
 		if (!common_flags) {
 			dev_warn(pcdev_to_dev(pcdev),
@@ -1218,7 +1652,7 @@ static int pxa_camera_try_bus_param(struct pxa_camera_dev *pcdev,

 	ret = sensor_call(pcdev, video, g_mbus_config, &cfg);
 	if (!ret) {
-		common_flags = soc_mbus_config_compatible(&cfg,
+		common_flags = pxa_mbus_config_compatible(&cfg,
 							  bus_flags);
 		if (!common_flags) {
 			dev_warn(pcdev_to_dev(pcdev),
@@ -1233,25 +1667,25 @@ static int pxa_camera_try_bus_param(struct pxa_camera_dev *pcdev,
 	return ret;
 }

-static const struct soc_mbus_pixelfmt pxa_camera_formats[] = {
+static const struct pxa_mbus_pixelfmt pxa_camera_formats[] = {
 	{
 		.fourcc			= V4L2_PIX_FMT_YUV422P,
 		.name			= "Planar YUV422 16 bit",
 		.bits_per_sample	= 8,
-		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
-		.order			= SOC_MBUS_ORDER_LE,
-		.layout			= SOC_MBUS_LAYOUT_PLANAR_2Y_U_V,
+		.packing		= PXA_MBUS_PACKING_2X8_PADHI,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PLANAR_2Y_U_V,
 	},
 };

 /* This will be corrected as we get more formats */
-static bool pxa_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
+static bool pxa_camera_packing_supported(const struct pxa_mbus_pixelfmt *fmt)
 {
-	return	fmt->packing == SOC_MBUS_PACKING_NONE ||
+	return	fmt->packing == PXA_MBUS_PACKING_NONE ||
 		(fmt->bits_per_sample == 8 &&
-		 fmt->packing == SOC_MBUS_PACKING_2X8_PADHI) ||
+		 fmt->packing == PXA_MBUS_PACKING_2X8_PADHI) ||
 		(fmt->bits_per_sample > 8 &&
-		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
+		 fmt->packing == PXA_MBUS_PACKING_EXTEND16);
 }

 static int pxa_camera_get_formats(struct v4l2_device *v4l2_dev,
@@ -1264,14 +1698,14 @@ static int pxa_camera_get_formats(struct v4l2_device *v4l2_dev,
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 		.index = idx,
 	};
-	const struct soc_mbus_pixelfmt *fmt;
+	const struct pxa_mbus_pixelfmt *fmt;

 	ret = sensor_call(pcdev, pad, enum_mbus_code, NULL, &code);
 	if (ret < 0)
 		/* No more formats */
 		return 0;

-	fmt = soc_mbus_get_fmtdesc(code.code);
+	fmt = pxa_mbus_get_fmtdesc(code.code);
 	if (!fmt) {
 		dev_err(pcdev_to_dev(pcdev),
 			"Invalid format code #%u: %d\n", idx, code.code);
@@ -1330,7 +1764,7 @@ static int pxa_camera_build_formats(struct pxa_camera_dev *pcdev)
 {
 	struct soc_camera_format_xlate *xlate;

-	xlate = soc_mbus_build_fmts_xlate(&pcdev->v4l2_dev, pcdev->sensor,
+	xlate = pxa_mbus_build_fmts_xlate(&pcdev->v4l2_dev, pcdev->sensor,
 					  pxa_camera_get_formats);
 	if (IS_ERR(xlate))
 		return PTR_ERR(xlate);
@@ -1383,7 +1817,7 @@ static int pxac_vidioc_enum_fmt_vid_cap(struct file *filp, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
 	struct pxa_camera_dev *pcdev = video_drvdata(filp);
-	const struct soc_mbus_pixelfmt *format;
+	const struct pxa_mbus_pixelfmt *format;
 	unsigned int idx;

 	for (idx = 0; pcdev->user_formats[idx].code; idx++);
@@ -1427,7 +1861,7 @@ static int pxac_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
 	__u32 pixfmt = pix->pixelformat;
 	int ret;

-	xlate = soc_mbus_xlate_by_fourcc(pcdev->user_formats, pixfmt);
+	xlate = pxa_mbus_xlate_by_fourcc(pcdev->user_formats, pixfmt);
 	if (!xlate) {
 		dev_warn(pcdev_to_dev(pcdev), "Format %x not found\n", pixfmt);
 		return -EINVAL;
@@ -1463,12 +1897,12 @@ static int pxac_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
 		return -EINVAL;
 	}

-	ret = soc_mbus_bytes_per_line(pix->width, xlate->host_fmt);
+	ret = pxa_mbus_bytes_per_line(pix->width, xlate->host_fmt);
 	if (ret < 0)
 		return ret;

 	pix->bytesperline = ret;
-	ret = soc_mbus_image_size(xlate->host_fmt, pix->bytesperline,
+	ret = pxa_mbus_image_size(xlate->host_fmt, pix->bytesperline,
 				  pix->height);
 	if (ret < 0)
 		return ret;
@@ -1504,7 +1938,7 @@ static int pxac_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
 	if (ret)
 		return ret;

-	xlate = soc_mbus_xlate_by_fourcc(pcdev->user_formats,
+	xlate = pxa_mbus_xlate_by_fourcc(pcdev->user_formats,
 					 pix->pixelformat);
 	v4l2_fill_mbus_format(&format.format, pix, xlate->code);
 	ret = sensor_call(pcdev, pad, set_fmt, NULL, &format);
@@ -1685,10 +2119,10 @@ static int pxa_camera_sensor_bound(struct v4l2_async_notifier *notifier,
 	pix->width = DEFAULT_WIDTH;
 	pix->height = DEFAULT_HEIGHT;
 	pix->bytesperline =
-		soc_mbus_bytes_per_line(pix->width,
+		pxa_mbus_bytes_per_line(pix->width,
 					pcdev->current_fmt->host_fmt);
 	pix->sizeimage =
-		soc_mbus_image_size(pcdev->current_fmt->host_fmt,
+		pxa_mbus_image_size(pcdev->current_fmt->host_fmt,
 				    pix->bytesperline, pix->height);
 	pix->pixelformat = pcdev->current_fmt->host_fmt->fourcc;
 	v4l2_fill_mbus_format(mf, pix, pcdev->current_fmt->code);
-- 
2.8.1

