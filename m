Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:52387 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbeCLQwr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 12:52:47 -0400
From: Suman Anna <s-anna@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Tony Lindgren <tony@atomide.com>, Suman Anna <s-anna@ti.com>,
        <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] media: omap3isp: fix unbalanced dma_iommu_mapping
Date: Mon, 12 Mar 2018 11:52:07 -0500
Message-ID: <20180312165207.12436-1-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The OMAP3 ISP driver manages its MMU mappings through the IOMMU-aware
ARM DMA backend. The current code creates a dma_iommu_mapping and
attaches this to the ISP device, but never detaches the mapping in
either the probe failure paths or the driver remove path resulting
in an unbalanced mapping refcount and a memory leak. Fix this properly.

Reported-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Suman Anna <s-anna@ti.com>
Tested-by: Pavel Machek <pavel@ucw.cz>
---
Hi Mauro, Laurent,

This fixes an issue reported by Pavel and discussed on this
thread,
https://marc.info/?l=linux-omap&m=152051945803598&w=2

Posting this again to the appropriate lists.

regards
Suman

 drivers/media/platform/omap3isp/isp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 8eb000e3d8fd..c7d667bfc2af 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1945,6 +1945,7 @@ static int isp_initialize_modules(struct isp_device *isp)
 
 static void isp_detach_iommu(struct isp_device *isp)
 {
+	arm_iommu_detach_device(isp->dev);
 	arm_iommu_release_mapping(isp->mapping);
 	isp->mapping = NULL;
 }
@@ -1971,13 +1972,15 @@ static int isp_attach_iommu(struct isp_device *isp)
 	ret = arm_iommu_attach_device(isp->dev, mapping);
 	if (ret < 0) {
 		dev_err(isp->dev, "failed to attach device to VA mapping\n");
-		goto error;
+		goto error_attach;
 	}
 
 	return 0;
 
+error_attach:
+	arm_iommu_release_mapping(isp->mapping);
+	isp->mapping = NULL;
 error:
-	isp_detach_iommu(isp);
 	return ret;
 }
 
-- 
2.16.2
