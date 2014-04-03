Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52430 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbaDCWh6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 18:37:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 01/25] omap3isp: stat: Rename IS_COHERENT_BUF to ISP_STAT_USES_DMAENGINE
Date: Fri,  4 Apr 2014 00:39:31 +0200
Message-Id: <1396564795-27192-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The macro is meant to test whether the statistics engine uses an
external DMA engine to transfer data or supports DMA directly. As both
cases will be supported by DMA coherent buffers rename the macro to
ISP_STAT_USES_DMAENGINE for improved clarity.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispstat.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 5707f85..48b702a 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -32,7 +32,7 @@
 
 #include "isp.h"
 
-#define IS_COHERENT_BUF(stat)	((stat)->dma_ch >= 0)
+#define ISP_STAT_USES_DMAENGINE(stat)	((stat)->dma_ch >= 0)
 
 /*
  * MAGIC_SIZE must always be the greatest common divisor of
@@ -99,7 +99,7 @@ static void isp_stat_buf_sync_magic_for_device(struct ispstat *stat,
 					       u32 buf_size,
 					       enum dma_data_direction dir)
 {
-	if (IS_COHERENT_BUF(stat))
+	if (ISP_STAT_USES_DMAENGINE(stat))
 		return;
 
 	__isp_stat_buf_sync_magic(stat, buf, buf_size, dir,
@@ -111,7 +111,7 @@ static void isp_stat_buf_sync_magic_for_cpu(struct ispstat *stat,
 					    u32 buf_size,
 					    enum dma_data_direction dir)
 {
-	if (IS_COHERENT_BUF(stat))
+	if (ISP_STAT_USES_DMAENGINE(stat))
 		return;
 
 	__isp_stat_buf_sync_magic(stat, buf, buf_size, dir,
@@ -180,7 +180,7 @@ static void isp_stat_buf_insert_magic(struct ispstat *stat,
 static void isp_stat_buf_sync_for_device(struct ispstat *stat,
 					 struct ispstat_buffer *buf)
 {
-	if (IS_COHERENT_BUF(stat))
+	if (ISP_STAT_USES_DMAENGINE(stat))
 		return;
 
 	dma_sync_sg_for_device(stat->isp->dev, buf->iovm->sgt->sgl,
@@ -190,7 +190,7 @@ static void isp_stat_buf_sync_for_device(struct ispstat *stat,
 static void isp_stat_buf_sync_for_cpu(struct ispstat *stat,
 				      struct ispstat_buffer *buf)
 {
-	if (IS_COHERENT_BUF(stat))
+	if (ISP_STAT_USES_DMAENGINE(stat))
 		return;
 
 	dma_sync_sg_for_cpu(stat->isp->dev, buf->iovm->sgt->sgl,
@@ -360,7 +360,7 @@ static void isp_stat_bufs_free(struct ispstat *stat)
 	for (i = 0; i < STAT_MAX_BUFS; i++) {
 		struct ispstat_buffer *buf = &stat->buf[i];
 
-		if (!IS_COHERENT_BUF(stat)) {
+		if (!ISP_STAT_USES_DMAENGINE(stat)) {
 			if (IS_ERR_OR_NULL((void *)buf->iommu_addr))
 				continue;
 			if (buf->iovm)
@@ -489,7 +489,7 @@ static int isp_stat_bufs_alloc(struct ispstat *stat, u32 size)
 
 	isp_stat_bufs_free(stat);
 
-	if (IS_COHERENT_BUF(stat))
+	if (ISP_STAT_USES_DMAENGINE(stat))
 		return isp_stat_bufs_alloc_dma(stat, size);
 	else
 		return isp_stat_bufs_alloc_iommu(stat, size);
-- 
1.8.3.2

