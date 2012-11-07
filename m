Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:26642 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2KGGRP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2012 01:17:15 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MD300HZCTFNC9J0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Nov 2012 15:17:10 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MD300HBSTF6GW30@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Nov 2012 15:17:09 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	shaik.samsung@gmail.com
Subject: [PATCH] [media] exynos-gsc: Adding tiled multi-planar format to
 G-Scaler
Date: Wed, 07 Nov 2012 12:07:07 +0530
Message-id: <1352270227-8369-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding V4L2_PIX_FMT_NV12MT_16X16 to G-Scaler supported formats.
If the output or input format is V4L2_PIX_FMT_NV12MT_16X16, configure
G-Scaler to use GSC_IN_TILE_MODE.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |    9 +++++++++
 drivers/media/platform/exynos-gsc/gsc-core.h |    5 +++++
 drivers/media/platform/exynos-gsc/gsc-regs.c |    6 ++++++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index cc7b218..00f1013 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -185,6 +185,15 @@ static const struct gsc_fmt gsc_formats[] = {
 		.corder		= GSC_CRCB,
 		.num_planes	= 3,
 		.num_comp	= 3,
+	}, {
+		.name		= "YUV 4:2:0 non-contig. 2p, Y/CbCr, tiled",
+		.pixelformat	= V4L2_PIX_FMT_NV12MT_16X16,
+		.depth		= { 8, 4 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 2,
+		.num_comp	= 2,
 	}
 };
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index 5f157ef..cc19bba 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -427,6 +427,11 @@ static inline void gsc_ctx_state_lock_clear(u32 state, struct gsc_ctx *ctx)
 	spin_unlock_irqrestore(&ctx->gsc_dev->slock, flags);
 }
 
+static inline int is_tiled(const struct gsc_fmt *fmt)
+{
+	return fmt->pixelformat == V4L2_PIX_FMT_NV12MT_16X16;
+}
+
 static inline void gsc_hw_enable_control(struct gsc_dev *dev, bool on)
 {
 	u32 cfg = readl(dev->regs + GSC_ENABLE);
diff --git a/drivers/media/platform/exynos-gsc/gsc-regs.c b/drivers/media/platform/exynos-gsc/gsc-regs.c
index 0146b35..6f5b5a4 100644
--- a/drivers/media/platform/exynos-gsc/gsc-regs.c
+++ b/drivers/media/platform/exynos-gsc/gsc-regs.c
@@ -214,6 +214,9 @@ void gsc_hw_set_in_image_format(struct gsc_ctx *ctx)
 		break;
 	}
 
+	if (is_tiled(frame->fmt))
+		cfg |= GSC_IN_TILE_C_16x8 | GSC_IN_TILE_MODE;
+
 	writel(cfg, dev->regs + GSC_IN_CON);
 }
 
@@ -334,6 +337,9 @@ void gsc_hw_set_out_image_format(struct gsc_ctx *ctx)
 		break;
 	}
 
+	if (is_tiled(frame->fmt))
+		cfg |= GSC_OUT_TILE_C_16x8 | GSC_OUT_TILE_MODE;
+
 end_set:
 	writel(cfg, dev->regs + GSC_OUT_CON);
 }
-- 
1.7.0.4

