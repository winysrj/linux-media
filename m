Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.logicpd.com ([174.46.170.145]:50683 "HELO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754578AbbCSOAP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 10:00:15 -0400
From: Tim Nordell <tim.nordell@logicpd.com>
To: <linux-media@vger.kernel.org>
CC: <laurent.pinchart@ideasonboard.com>, <sakari.ailus@iki.fi>,
	Tim Nordell <tim.nordell@logicpd.com>
Subject: [PATCH v2] OMAP3 ISP: Set DMA segment size
Date: Thu, 19 Mar 2015 08:59:52 -0500
Message-ID: <1426773592-30182-1-git-send-email-tim.nordell@logicpd.com>
In-Reply-To: <1426719343-13027-1-git-send-email-tim.nordell@logicpd.com>
References: <1426719343-13027-1-git-send-email-tim.nordell@logicpd.com>
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
 drivers/media/platform/omap3isp/isp.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index ead2d0d..906d3e5 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2170,6 +2170,20 @@ static int isp_attach_iommu(struct isp_device *isp)
 		goto error;
 	}
 
+	isp->dev->dma_parms = devm_kzalloc(isp->dev,
+		sizeof(*isp->dev->dma_parms), GFP_KERNEL);
+	if (!isp->dev->dma_parms) {
+		dev_err(isp->dev, "failed to allocate memory for dma_parms\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
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

