Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.logicpd.com ([174.46.170.145]:38092 "HELO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755240AbbCRWz7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 18:55:59 -0400
From: Tim Nordell <tim.nordell@logicpd.com>
To: <linux-media@vger.kernel.org>
CC: <laurent.pinchart@ideasonboard.com>, <sakari.ailus@iki.fi>,
	Tim Nordell <tim.nordell@logicpd.com>
Subject: [PATCH] OMAP3 ISP: Set DMA segment size
Date: Wed, 18 Mar 2015 17:55:43 -0500
Message-ID: <1426719343-13027-1-git-send-email-tim.nordell@logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When utilizing userptr buffers for output from the CCDC, the
DMA subsystem maps buffers into the virtual address space.
However, the DMA subsystem also has a configurable parameter
for what the largest segment to allocate is out of the virtual
address space as well.

Since we need contiguous buffers for the memory space from the
OMAP3 ISP's vantage point, we need to configure the segments
to be at least as large as the largest buffer we expect.

Signed-off-by: Tim Nordell <tim.nordell@logicpd.com>
---
 drivers/media/platform/omap3isp/isp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index ead2d0d..ab95fd1 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2170,6 +2170,14 @@ static int isp_attach_iommu(struct isp_device *isp)
 		goto error;
 	}
 
+	isp->dev->dma_parms = devm_kzalloc(isp->dev,
+		sizeof(*isp->dev->dma_parms), GFP_KERNEL);
+	ret = dma_set_max_seg_size(isp->dev, SZ_32M);
+	if (ret < 0) {
+		dev_err(isp->dev, "failed to set max segment size for dma\n");
+		goto error;
+	}
+
 	return 0;
 
 error:
-- 
2.0.4

