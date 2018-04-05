Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:49436 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751447AbeDERyY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 13:54:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/16] omap: omap-iommu.h: allow building drivers with COMPILE_TEST
Date: Thu,  5 Apr 2018 13:54:01 -0400
Message-Id: <6741dd205de1e7d4e80a93386095db2a0c604bb5.1522949748.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
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
index c1aede46718b..0c21fc5b002e 100644
--- a/include/linux/omap-iommu.h
+++ b/include/linux/omap-iommu.h
@@ -13,7 +13,12 @@
 #ifndef _OMAP_IOMMU_H_
 #define _OMAP_IOMMU_H_
 
+#ifdef CONFIG_OMAP_IOMMU
 extern void omap_iommu_save_ctx(struct device *dev);
 extern void omap_iommu_restore_ctx(struct device *dev);
+#else
+static inline void omap_iommu_save_ctx(struct device *dev) {};
+static inline void omap_iommu_restore_ctx(struct device *dev) {};
+#endif
 
 #endif
-- 
2.14.3
