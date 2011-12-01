Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37103 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab1LAAPS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 19:15:18 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
	<sakari.ailus@iki.fi>, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH v2 11/11] arm: Add support for CMA for omap4iss driver
Date: Wed, 30 Nov 2011 18:15:00 -0600
Message-ID: <1322698500-29924-12-git-send-email-saaguirre@ti.com>
In-Reply-To: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/mach-omap2/devices.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index b48aeea..e411c4e 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -17,6 +17,9 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#ifdef CONFIG_CMA
+#include <linux/dma-contiguous.h>
+#endif
 
 #include <mach/hardware.h>
 #include <mach/irqs.h>
@@ -246,6 +249,11 @@ int omap4_init_camera(struct iss_platform_data *pdata, struct omap_board_data *b
 
 	oh->mux = omap_hwmod_mux_init(bdata->pads, bdata->pads_cnt);
 
+#ifdef CONFIG_CMA
+	/* Create private 32MiB contiguous memory area for omap4iss device */
+	dma_declare_contiguous(&pdev->dev, 32*SZ_1M, 0, 0);
+#endif
+
 	return 0;
 }
 
-- 
1.7.7.4

