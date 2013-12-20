Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46881 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab3LTI7m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 03:59:42 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, k.debski@samsung.com,
	prathyush.k@samsung.com, s.shirish@samsung.com, arun.m@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH] [media] exynos-gsc: swap cb/cr only for 3 plane formats
Date: Fri, 20 Dec 2013 14:29:33 +0530
Message-Id: <1387529973-6123-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Prathyush K <prathyush.k@samsung.com>

The address for cb/cr needs to be swapped for 3 plane formats like
YVU420 and YVU420M. If these address gets swapped for other formats like
NV21, it results in passing a NULL dma address to gscalar (which will
result in a PAGE FAULT if sysmmu is enabled).

E.g. For NV21, the dma_address are (Y, CbCr, 0) and we swap them (Y, 0,
CbCr) which is incorrect.

Signed-off-by: Prathyush K <prathyush.k@samsung.com>
Signed-off-by: Shirish S <s.shirish@samsung.com>
Signed-off-by: Arun Mankuzhi <arun.m@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 9d0cc04..ff851fc 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -844,11 +844,7 @@ int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
 			addr->cr = vb2_dma_contig_plane_dma_addr(vb, 2);
 	}
 
-	if ((frame->fmt->pixelformat == V4L2_PIX_FMT_VYUY) ||
-		(frame->fmt->pixelformat == V4L2_PIX_FMT_YVYU) ||
-		(frame->fmt->pixelformat == V4L2_PIX_FMT_NV61) ||
-		(frame->fmt->pixelformat == V4L2_PIX_FMT_YVU420) ||
-		(frame->fmt->pixelformat == V4L2_PIX_FMT_NV21) ||
+	if ((frame->fmt->pixelformat == V4L2_PIX_FMT_YVU420) ||
 		(frame->fmt->pixelformat == V4L2_PIX_FMT_YVU420M))
 		swap(addr->cb, addr->cr);
 
-- 
1.7.9.5

