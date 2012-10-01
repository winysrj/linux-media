Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36094 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab2JAWqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 18:46:53 -0400
Received: by mail-qa0-f46.google.com with SMTP id c26so86178qad.19
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2012 15:46:53 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH v2 3/5] iommu/omap: Make some definitions local
Date: Mon,  1 Oct 2012 18:46:29 -0400
Message-Id: <1349131591-10804-3-git-send-email-ido@wizery.com>
In-Reply-To: <1349131591-10804-1-git-send-email-ido@wizery.com>
References: <20120927195526.GP4840@atomide.com>
 <1349131591-10804-1-git-send-email-ido@wizery.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move some of the definitions in plat/iommu.h that can be made local to
either drivers/iommu or arch/arm/mach-omap2. This minimizes the number
of global definitions once plat/iommu.h moves to platform_data/ as part
of the single zImage effort.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 arch/arm/mach-omap2/iommu2.c            |  6 ++++
 arch/arm/plat-omap/include/plat/iommu.h | 55 ------------------------------
 drivers/iommu/omap-iommu-debug.c        |  2 ++
 drivers/iommu/omap-iommu.c              |  2 ++
 drivers/iommu/omap-iommu.h              | 59 +++++++++++++++++++++++++++++++++
 drivers/iommu/omap-iovmm.c              |  2 ++
 6 files changed, 71 insertions(+), 55 deletions(-)
 create mode 100644 drivers/iommu/omap-iommu.h

diff --git a/arch/arm/mach-omap2/iommu2.c b/arch/arm/mach-omap2/iommu2.c
index eefc379..c986880 100644
--- a/arch/arm/mach-omap2/iommu2.c
+++ b/arch/arm/mach-omap2/iommu2.c
@@ -65,6 +65,12 @@
 	 ((pgsz) == MMU_CAM_PGSZ_64K) ? 0xffff0000 :	\
 	 ((pgsz) == MMU_CAM_PGSZ_4K)  ? 0xfffff000 : 0)
 
+/* IOMMU errors */
+#define OMAP_IOMMU_ERR_TLB_MISS		(1 << 0)
+#define OMAP_IOMMU_ERR_TRANS_FAULT	(1 << 1)
+#define OMAP_IOMMU_ERR_EMU_MISS		(1 << 2)
+#define OMAP_IOMMU_ERR_TBLWALK_FAULT	(1 << 3)
+#define OMAP_IOMMU_ERR_MULTIHIT_FAULT	(1 << 4)
 
 static void __iommu_set_twl(struct omap_iommu *obj, bool on)
 {
diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
index 7e8c7b6..35a0245 100644
--- a/arch/arm/plat-omap/include/plat/iommu.h
+++ b/arch/arm/plat-omap/include/plat/iommu.h
@@ -77,11 +77,6 @@ struct cr_regs {
 	};
 };
 
-struct iotlb_lock {
-	short base;
-	short vict;
-};
-
 /* architecture specific functions */
 struct iommu_functions {
 	unsigned long	version;
@@ -145,26 +140,6 @@ struct omap_iommu_arch_data {
 	struct omap_iommu *iommu_dev;
 };
 
-#ifdef CONFIG_IOMMU_API
-/**
- * dev_to_omap_iommu() - retrieves an omap iommu object from a user device
- * @dev: iommu client device
- */
-static inline struct omap_iommu *dev_to_omap_iommu(struct device *dev)
-{
-	struct omap_iommu_arch_data *arch_data = dev->archdata.iommu;
-
-	return arch_data->iommu_dev;
-}
-#endif
-
-/* IOMMU errors */
-#define OMAP_IOMMU_ERR_TLB_MISS		(1 << 0)
-#define OMAP_IOMMU_ERR_TRANS_FAULT	(1 << 1)
-#define OMAP_IOMMU_ERR_EMU_MISS		(1 << 2)
-#define OMAP_IOMMU_ERR_TBLWALK_FAULT	(1 << 3)
-#define OMAP_IOMMU_ERR_MULTIHIT_FAULT	(1 << 4)
-
 /*
  * MMU Register offsets
  */
@@ -192,16 +167,6 @@ static inline struct omap_iommu *dev_to_omap_iommu(struct device *dev)
 /*
  * MMU Register bit definitions
  */
-#define MMU_LOCK_BASE_SHIFT	10
-#define MMU_LOCK_BASE_MASK	(0x1f << MMU_LOCK_BASE_SHIFT)
-#define MMU_LOCK_BASE(x)	\
-	((x & MMU_LOCK_BASE_MASK) >> MMU_LOCK_BASE_SHIFT)
-
-#define MMU_LOCK_VICT_SHIFT	4
-#define MMU_LOCK_VICT_MASK	(0x1f << MMU_LOCK_VICT_SHIFT)
-#define MMU_LOCK_VICT(x)	\
-	((x & MMU_LOCK_VICT_MASK) >> MMU_LOCK_VICT_SHIFT)
-
 #define MMU_CAM_VATAG_SHIFT	12
 #define MMU_CAM_VATAG_MASK \
 	((~0UL >> MMU_CAM_VATAG_SHIFT) << MMU_CAM_VATAG_SHIFT)
@@ -257,32 +222,12 @@ static inline struct omap_iommu *dev_to_omap_iommu(struct device *dev)
 /*
  * global functions
  */
-extern u32 omap_iommu_arch_version(void);
-
-extern void omap_iotlb_cr_to_e(struct cr_regs *cr, struct iotlb_entry *e);
-
-extern int
-omap_iopgtable_store_entry(struct omap_iommu *obj, struct iotlb_entry *e);
-
-extern int omap_iommu_set_isr(const char *name,
-		 int (*isr)(struct omap_iommu *obj, u32 da, u32 iommu_errs,
-				    void *priv),
-			 void *isr_priv);
-
 extern void omap_iommu_save_ctx(struct device *dev);
 extern void omap_iommu_restore_ctx(struct device *dev);
 
 extern int omap_install_iommu_arch(const struct iommu_functions *ops);
 extern void omap_uninstall_iommu_arch(const struct iommu_functions *ops);
 
-extern int omap_foreach_iommu_device(void *data,
-				int (*fn)(struct device *, void *));
-
-extern ssize_t
-omap_iommu_dump_ctx(struct omap_iommu *obj, char *buf, ssize_t len);
-extern size_t
-omap_dump_tlb_entries(struct omap_iommu *obj, char *buf, ssize_t len);
-
 /*
  * register accessors
  */
diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index f55fc5d..a0b0309 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -24,6 +24,8 @@
 
 #include <plat/iopgtable.h>
 
+#include "omap-iommu.h"
+
 #define MAXCOLUMN 100 /* for short messages */
 
 static DEFINE_MUTEX(iommu_debug_lock);
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index d0b1234..80844b3 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -28,6 +28,8 @@
 
 #include <plat/iopgtable.h>
 
+#include "omap-iommu.h"
+
 #define for_each_iotlb_cr(obj, n, __i, cr)				\
 	for (__i = 0;							\
 	     (__i < (n)) && (cr = __iotlb_read_cr((obj), __i), true);	\
diff --git a/drivers/iommu/omap-iommu.h b/drivers/iommu/omap-iommu.h
new file mode 100644
index 0000000..51fd00c
--- /dev/null
+++ b/drivers/iommu/omap-iommu.h
@@ -0,0 +1,59 @@
+/*
+ * omap iommu: miscellaneous iommu functions and structures
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ * Copyright (C) 2012 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _OMAP_IOMMU_H
+#define _OMAP_IOMMU_H
+
+/*
+ * MMU Register bit definitions
+ */
+#define MMU_LOCK_BASE_SHIFT	10
+#define MMU_LOCK_BASE_MASK	(0x1f << MMU_LOCK_BASE_SHIFT)
+#define MMU_LOCK_BASE(x)	\
+	((x & MMU_LOCK_BASE_MASK) >> MMU_LOCK_BASE_SHIFT)
+
+#define MMU_LOCK_VICT_SHIFT	4
+#define MMU_LOCK_VICT_MASK	(0x1f << MMU_LOCK_VICT_SHIFT)
+#define MMU_LOCK_VICT(x)	\
+	((x & MMU_LOCK_VICT_MASK) >> MMU_LOCK_VICT_SHIFT)
+
+struct iotlb_lock {
+	short base;
+	short vict;
+};
+
+extern u32 omap_iommu_arch_version(void);
+
+extern void omap_iotlb_cr_to_e(struct cr_regs *cr, struct iotlb_entry *e);
+
+extern int
+omap_iopgtable_store_entry(struct omap_iommu *obj, struct iotlb_entry *e);
+
+extern int omap_foreach_iommu_device(void *data,
+				int (*fn)(struct device *, void *));
+
+extern ssize_t
+omap_iommu_dump_ctx(struct omap_iommu *obj, char *buf, ssize_t len);
+extern size_t
+omap_dump_tlb_entries(struct omap_iommu *obj, char *buf, ssize_t len);
+
+/**
+ * dev_to_omap_iommu() - retrieves an omap iommu object from a user device
+ * @dev: iommu client device
+ */
+static inline struct omap_iommu *dev_to_omap_iommu(struct device *dev)
+{
+	struct omap_iommu_arch_data *arch_data = dev->archdata.iommu;
+
+	return arch_data->iommu_dev;
+}
+
+#endif
diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index 2e10c3e..b362fb5 100644
--- a/drivers/iommu/omap-iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -26,6 +26,8 @@
 
 #include <plat/iopgtable.h>
 
+#include "omap-iommu.h"
+
 static struct kmem_cache *iovm_area_cachep;
 
 /* return the offset of the first scatterlist entry in a sg table */
-- 
1.7.11.4

