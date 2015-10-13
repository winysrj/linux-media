Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56983 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbbJMNS1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2015 09:18:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux-foundation.org, robin.murphy@arm.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Lars-Peter Clausen <lars@metafoo.de>, sakari.ailus@iki.fi,
	Shuah Khan <shuahkhan@gmail.com>
Subject: [RFC/PATCH] media: omap3isp: Set maximum DMA segment size
Date: Tue, 13 Oct 2015 16:18:36 +0300
Message-Id: <1444742316-27986-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The maximum DMA segment size controls the IOMMU mapping granularity. Its
default value is 64kB, resulting in potentially non-contiguous IOMMU
mappings. Configure it to 4GB to ensure that buffers get mapped
contiguously.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c | 4 ++++
 drivers/media/platform/omap3isp/isp.h | 1 +
 2 files changed, 5 insertions(+)

I'm posting this as an RFC because I'm not happy with the patch, even if it
gets the job done.

On ARM the maximum DMA segment size is used when creating IOMMU mappings. As
a large number of devices require contiguous memory buffers (this is a very
common requirement for video-related embedded devices) the default 64kB value
doesn't work.

I haven't investigated the history behind this API in details but I have a
feeling something is not quite right. We force most drivers to explicitly set
the maximum segment size from a default that seems valid for specific use
cases only. Furthermore, as the DMA parameters are not stored directly in
struct device this require allocation of external memory for which we have no
proper management rule, making automatic handling of the DMA parameters in
frameworks or helper functions cumbersome (for a discussion on this topic see
http://www.spinics.net/lists/linux-media/msg92467.html and
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305913.html).

Is it time to fix this mess ?

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 17430a6ed85a..ebf7dc76e94d 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2444,6 +2444,10 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret)
 		goto error;
 
+	isp->dev->dma_parms = &isp->dma_parms;
+	dma_set_max_seg_size(isp->dev, DMA_BIT_MASK(32));
+	dma_set_seg_boundary(isp->dev, 0xffffffff);
+
 	platform_set_drvdata(pdev, isp);
 
 	/* Regulators */
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index e579943175c4..4b2231cf01be 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -193,6 +193,7 @@ struct isp_device {
 	u32 syscon_offset;
 	u32 phy_type;
 
+	struct device_dma_parameters dma_parms;
 	struct dma_iommu_mapping *mapping;
 
 	/* ISP Obj */
-- 
Regards,

Laurent Pinchart

