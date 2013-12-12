Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45601 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab3LLIgm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 03:36:42 -0500
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>, <k.debski@samsung.com>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
CC: <linux-omap@vger.kernel.org>, <tomi.valkeinen@ti.com>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 6/8] v4l: ti-vpe: Add helper to perform color conversion
Date: Thu, 12 Dec 2013 14:06:02 +0530
Message-ID: <1386837364-1264-7-git-send-email-archit@ti.com>
In-Reply-To: <1386837364-1264-1-git-send-email-archit@ti.com>
References: <1386837364-1264-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSC block can be used for color space conversion between YUV and RGB
formats.

It is configurable via a programmable set of coefficients. Add functionality to
choose the appropriate CSC coefficients and program them in the CSC registers.
We take the source and destination colorspace formats as the arguments, and
choose the coefficient table accordingly.

YUV to RGB coefficients are provided for standard and high definition
colorspaces. The coefficients can also be limited or full range. For now, only
full range coefficients are chosen. We would need some sort of control ioctl for
the user to specify the range needed. Not sure if there is a generic control
ioctl for this already?

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/csc.c | 120 ++++++++++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/csc.h |   3 +
 2 files changed, 123 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/csc.c b/drivers/media/platform/ti-vpe/csc.c
index 62e2fec..acfea50 100644
--- a/drivers/media/platform/ti-vpe/csc.c
+++ b/drivers/media/platform/ti-vpe/csc.c
@@ -16,9 +16,79 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/videodev2.h>
 
 #include "csc.h"
 
+/*
+ * 16 coefficients in the order:
+ * a0, b0, c0, a1, b1, c1, a2, b2, c2, d0, d1, d2
+ * (we may need to pass non-default values from user space later on, we might
+ * need to make the coefficient struct more easy to populate)
+ */
+struct colorspace_coeffs {
+	u16	sd[12];
+	u16	hd[12];
+};
+
+/* VIDEO_RANGE: limited range, GRAPHICS_RANGE: full range */
+#define	CSC_COEFFS_VIDEO_RANGE_Y2R	0
+#define	CSC_COEFFS_GRAPHICS_RANGE_Y2R	1
+#define	CSC_COEFFS_VIDEO_RANGE_R2Y	2
+#define	CSC_COEFFS_GRAPHICS_RANGE_R2Y	3
+
+/* default colorspace coefficients */
+static struct colorspace_coeffs colorspace_coeffs[4] = {
+	[CSC_COEFFS_VIDEO_RANGE_Y2R] = {
+		{
+			/* SDTV */
+			0x0400, 0x0000, 0x057D, 0x0400, 0x1EA7, 0x1D35,
+			0x0400, 0x06EF, 0x1FFE, 0x0D40, 0x0210, 0x0C88,
+		},
+		{
+			/* HDTV */
+			0x0400, 0x0000, 0x0629, 0x0400, 0x1F45, 0x1E2B,
+			0x0400, 0x0742, 0x0000, 0x0CEC, 0x0148, 0x0C60,
+		},
+	},
+	[CSC_COEFFS_GRAPHICS_RANGE_Y2R] = {
+		{
+			/* SDTV */
+			0x04A8, 0x1FFE, 0x0662, 0x04A8, 0x1E6F, 0x1CBF,
+			0x04A8, 0x0812, 0x1FFF, 0x0C84, 0x0220, 0x0BAC,
+		},
+		{
+			/* HDTV */
+			0x04A8, 0x0000, 0x072C, 0x04A8, 0x1F26, 0x1DDE,
+			0x04A8, 0x0873, 0x0000, 0x0C20, 0x0134, 0x0B7C,
+		},
+	},
+	[CSC_COEFFS_VIDEO_RANGE_R2Y] = {
+		{
+			/* SDTV */
+			0x0132, 0x0259, 0x0075, 0x1F50, 0x1EA5, 0x020B,
+			0x020B, 0x1E4A, 0x1FAB, 0x0000, 0x0200, 0x0200,
+		},
+		{
+			/* HDTV */
+			0x00DA, 0x02DC, 0x004A, 0x1F88, 0x1E6C, 0x020C,
+			0x020C, 0x1E24, 0x1FD0, 0x0000, 0x0200, 0x0200,
+		},
+	},
+	[CSC_COEFFS_GRAPHICS_RANGE_R2Y] = {
+		{
+			/* SDTV */
+			0x0107, 0x0204, 0x0064, 0x1F68, 0x1ED6, 0x01C2,
+			0x01C2, 0x1E87, 0x1FB7, 0x0040, 0x0200, 0x0200,
+		},
+		{
+			/* HDTV */
+			0x04A8, 0x0000, 0x072C, 0x04A8, 0x1F26, 0x1DDE,
+			0x04A8, 0x0873, 0x0000, 0x0C20, 0x0134, 0x0B7C,
+		},
+	},
+};
+
 void csc_dump_regs(struct csc_data *csc)
 {
 	struct device *dev = &csc->pdev->dev;
@@ -45,6 +115,56 @@ void csc_set_coeff_bypass(struct csc_data *csc, u32 *csc_reg5)
 	*csc_reg5 |= CSC_BYPASS;
 }
 
+/*
+ * set the color space converter coefficient shadow register values
+ */
+void csc_set_coeff(struct csc_data *csc, u32 *csc_reg0,
+		enum v4l2_colorspace src_colorspace,
+		enum v4l2_colorspace dst_colorspace)
+{
+	u32 *csc_reg5 = csc_reg0 + 5;
+	u32 *shadow_csc = csc_reg0;
+	struct colorspace_coeffs *sd_hd_coeffs;
+	u16 *coeff, *end_coeff;
+	enum v4l2_colorspace yuv_colorspace;
+	int sel = 0;
+
+	/*
+	 * support only graphics data range(full range) for now, a control ioctl
+	 * would be nice here
+	 */
+	/* Y2R */
+	if (dst_colorspace == V4L2_COLORSPACE_SRGB &&
+			(src_colorspace == V4L2_COLORSPACE_SMPTE170M ||
+			src_colorspace == V4L2_COLORSPACE_REC709)) {
+		/* Y2R */
+		sel = 1;
+		yuv_colorspace = src_colorspace;
+	} else if ((dst_colorspace == V4L2_COLORSPACE_SMPTE170M ||
+			dst_colorspace == V4L2_COLORSPACE_REC709) &&
+			src_colorspace == V4L2_COLORSPACE_SRGB) {
+		/* R2Y */
+		sel = 3;
+		yuv_colorspace = dst_colorspace;
+	} else {
+		*csc_reg5 |= CSC_BYPASS;
+		return;
+	}
+
+	sd_hd_coeffs = &colorspace_coeffs[sel];
+
+	/* select between SD or HD coefficients */
+	if (yuv_colorspace == V4L2_COLORSPACE_SMPTE170M)
+		coeff = sd_hd_coeffs->sd;
+	else
+		coeff = sd_hd_coeffs->hd;
+
+	end_coeff = coeff + 12;
+
+	for (; coeff < end_coeff; coeff += 2)
+		*shadow_csc++ = (*(coeff + 1) << 16) | *coeff;
+}
+
 struct csc_data *csc_create(struct platform_device *pdev)
 {
 	struct csc_data *csc;
diff --git a/drivers/media/platform/ti-vpe/csc.h b/drivers/media/platform/ti-vpe/csc.h
index 57b5ed6..1ad2b6d 100644
--- a/drivers/media/platform/ti-vpe/csc.h
+++ b/drivers/media/platform/ti-vpe/csc.h
@@ -60,6 +60,9 @@ struct csc_data {
 
 void csc_dump_regs(struct csc_data *csc);
 void csc_set_coeff_bypass(struct csc_data *csc, u32 *csc_reg5);
+void csc_set_coeff(struct csc_data *csc, u32 *csc_reg0,
+		enum v4l2_colorspace src_colorspace,
+		enum v4l2_colorspace dst_colorspace);
 struct csc_data *csc_create(struct platform_device *pdev);
 
 #endif
-- 
1.8.3.2

