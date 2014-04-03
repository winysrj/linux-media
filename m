Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52434 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbaDCWiH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 18:38:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 15/25] omap3isp: queue: Fix the dma_map_sg() return value check
Date: Fri,  4 Apr 2014 00:39:45 +0200
Message-Id: <1396564795-27192-16-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dma_map_sg() can merge sglist entries, and can thus return a number of
mapped entries different than the original value. Don't consider this as
an error.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index 2fd254f..479d348 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -465,7 +465,7 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 			  ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 		ret = dma_map_sg(buf->queue->dev, buf->sgt.sgl,
 				 buf->sgt.orig_nents, direction);
-		if (ret != buf->sgt.orig_nents) {
+		if (ret <= 0) {
 			ret = -EFAULT;
 			goto done;
 		}
-- 
1.8.3.2

