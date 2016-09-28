Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50144 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933623AbcI1VWH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:22:07 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 18/35] media: ti-vpe: vpe: Add RGB565 and RGB5551 support
Date: Wed, 28 Sep 2016 16:22:05 -0500
Message-ID: <20160928212205.27130-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

VPE hardware can generate output in RGB565 or in RGB5551 format.
Add these formats in the supported format list for CAPTURE stream.
Also, for RGB5551 format, the alpha component is not processed,
so the alpha value is taken from the default color.
Set the default color to make alpha component full when the dst
format is of RGB color space.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 843cbcbf3944..a43dcac0b15e 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -302,6 +302,22 @@ static struct vpe_fmt vpe_formats[] = {
 		.vpdma_fmt	= { &vpdma_rgb_fmts[VPDMA_DATA_FMT_ABGR32],
 				  },
 	},
+	{
+		.name		= "RGB565",
+		.fourcc		= V4L2_PIX_FMT_RGB565,
+		.types		= VPE_FMT_TYPE_CAPTURE,
+		.coplanar	= 0,
+		.vpdma_fmt	= { &vpdma_rgb_fmts[VPDMA_DATA_FMT_RGB565],
+				  },
+	},
+	{
+		.name		= "RGB5551",
+		.fourcc		= V4L2_PIX_FMT_RGB555,
+		.types		= VPE_FMT_TYPE_CAPTURE,
+		.coplanar	= 0,
+		.vpdma_fmt	= { &vpdma_rgb_fmts[VPDMA_DATA_FMT_RGBA16_5551],
+				  },
+	},
 };
 
 /*
@@ -738,9 +754,11 @@ static void set_dst_registers(struct vpe_ctx *ctx)
 	struct vpe_fmt *fmt = ctx->q_data[Q_DATA_DST].fmt;
 	u32 val = 0;
 
-	if (clrspc == V4L2_COLORSPACE_SRGB)
+	if (clrspc == V4L2_COLORSPACE_SRGB) {
 		val |= VPE_RGB_OUT_SELECT;
-	else if (fmt->fourcc == V4L2_PIX_FMT_NV16)
+		vpdma_set_bg_color(ctx->dev->vpdma,
+			(struct vpdma_data_format *)fmt->vpdma_fmt[0], 0xff);
+	} else if (fmt->fourcc == V4L2_PIX_FMT_NV16)
 		val |= VPE_COLOR_SEPARATE_422;
 
 	/*
-- 
2.9.0

