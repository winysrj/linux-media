Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54994 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751211AbeDQKUU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 06:20:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/5] omap: omap-iommu.h: allow building drivers with COMPILE_TEST
Date: Tue, 17 Apr 2018 06:20:11 -0400
Message-Id: <ff6b948447ad0bf3948d0f925254a4bc47881ef6.1523960171.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523960171.git.mchehab@s-opensource.com>
References: <cover.1523960171.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523960171.git.mchehab@s-opensource.com>
References: <cover.1523960171.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers that depend on omap-iommu.h (currently, just omap3isp)
need a stub implementation in order to be built with COMPILE_TEST.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/linux/omap-iommu.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/omap-iommu.h b/include/linux/omap-iommu.h
index c1aede46718b..ce1b7c6283ee 100644
--- a/include/linux/omap-iommu.h
+++ b/include/linux/omap-iommu.h
@@ -13,7 +13,12 @@
 #ifndef _OMAP_IOMMU_H_
 #define _OMAP_IOMMU_H_
 
+#ifdef CONFIG_OMAP_IOMMU
 extern void omap_iommu_save_ctx(struct device *dev);
 extern void omap_iommu_restore_ctx(struct device *dev);
+#else
+static inline void omap_iommu_save_ctx(struct device *dev) {}
+static inline void omap_iommu_restore_ctx(struct device *dev) {}
+#endif
 
 #endif
-- 
2.14.3
