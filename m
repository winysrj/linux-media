Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:15591 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbeCNPmP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 11:42:15 -0400
From: Suman Anna <s-anna@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Tony Lindgren <tony@atomide.com>, Suman Anna <s-anna@ti.com>,
        <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2] media: omap3isp: fix unbalanced dma_iommu_mapping
Date: Wed, 14 Mar 2018 10:41:36 -0500
Message-ID: <20180314154136.16468-1-s-anna@ti.com>
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
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
v2 Changes:
 - Dropped the error_attach label, and returned directly from the
   first error path (comments from Sakari)
 - Added Sakari's Acked-by
v1: https://patchwork.kernel.org/patch/10276759/

Pavel,
I dropped your Tested-by from v2 since I modified the patch, can you
recheck the new patch again? Thanks.

regards
Suman

 drivers/media/platform/omap3isp/isp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 8eb000e3d8fd..f2db5128d786 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1945,6 +1945,7 @@ static int isp_initialize_modules(struct isp_device *isp)
 
 static void isp_detach_iommu(struct isp_device *isp)
 {
+	arm_iommu_detach_device(isp->dev);
 	arm_iommu_release_mapping(isp->mapping);
 	isp->mapping = NULL;
 }
@@ -1961,8 +1962,7 @@ static int isp_attach_iommu(struct isp_device *isp)
 	mapping = arm_iommu_create_mapping(&platform_bus_type, SZ_1G, SZ_2G);
 	if (IS_ERR(mapping)) {
 		dev_err(isp->dev, "failed to create ARM IOMMU mapping\n");
-		ret = PTR_ERR(mapping);
-		goto error;
+		return PTR_ERR(mapping);
 	}
 
 	isp->mapping = mapping;
@@ -1977,7 +1977,8 @@ static int isp_attach_iommu(struct isp_device *isp)
 	return 0;
 
 error:
-	isp_detach_iommu(isp);
+	arm_iommu_release_mapping(isp->mapping);
+	isp->mapping = NULL;
 	return ret;
 }
 
-- 
2.16.2
