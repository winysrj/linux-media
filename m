Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:56673 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2IUFO0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 01:14:26 -0400
Received: by qaas11 with SMTP id s11so987463qaa.19
        for <linux-media@vger.kernel.org>; Thu, 20 Sep 2012 22:14:25 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH 2/3] iommu/omap: Merge iommu2.h into iommu.h
Date: Fri, 21 Sep 2012 01:14:07 -0400
Message-Id: <1348204448-30855-2-git-send-email-ido@wizery.com>
In-Reply-To: <1348204448-30855-1-git-send-email-ido@wizery.com>
References: <1348204448-30855-1-git-send-email-ido@wizery.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since iommu is not currently supported on OMAP1, merge plat/iommu2.h into
iommu.h so only one file would have to move to platform_data/ as part of the
single zImage effort.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 arch/arm/plat-omap/include/plat/iommu.h  | 88 +++++++++++++++++++++++++++--
 arch/arm/plat-omap/include/plat/iommu2.h | 96 --------------------------------
 2 files changed, 83 insertions(+), 101 deletions(-)
 delete mode 100644 arch/arm/plat-omap/include/plat/iommu2.h

diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
index 88be3e6..42f64e7 100644
--- a/arch/arm/plat-omap/include/plat/iommu.h
+++ b/arch/arm/plat-omap/include/plat/iommu.h
@@ -13,6 +13,12 @@
 #ifndef __MACH_IOMMU_H
 #define __MACH_IOMMU_H
 
+#include <linux/io.h>
+
+#if defined(CONFIG_ARCH_OMAP1)
+#error "iommu for this processor not implemented yet"
+#endif
+
 struct iotlb_entry {
 	u32 da;
 	u32 pa;
@@ -144,11 +150,70 @@ static inline struct omap_iommu *dev_to_omap_iommu(struct device *dev)
 #define OMAP_IOMMU_ERR_TBLWALK_FAULT	(1 << 3)
 #define OMAP_IOMMU_ERR_MULTIHIT_FAULT	(1 << 4)
 
-#if defined(CONFIG_ARCH_OMAP1)
-#error "iommu for this processor not implemented yet"
-#else
-#include <plat/iommu2.h>
-#endif
+/*
+ * MMU Register offsets
+ */
+#define MMU_REVISION		0x00
+#define MMU_SYSCONFIG		0x10
+#define MMU_SYSSTATUS		0x14
+#define MMU_IRQSTATUS		0x18
+#define MMU_IRQENABLE		0x1c
+#define MMU_WALKING_ST		0x40
+#define MMU_CNTL		0x44
+#define MMU_FAULT_AD		0x48
+#define MMU_TTB			0x4c
+#define MMU_LOCK		0x50
+#define MMU_LD_TLB		0x54
+#define MMU_CAM			0x58
+#define MMU_RAM			0x5c
+#define MMU_GFLUSH		0x60
+#define MMU_FLUSH_ENTRY		0x64
+#define MMU_READ_CAM		0x68
+#define MMU_READ_RAM		0x6c
+#define MMU_EMU_FAULT_AD	0x70
+
+#define MMU_REG_SIZE		256
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
+#define MMU_CAM_VATAG_SHIFT	12
+#define MMU_CAM_VATAG_MASK \
+	((~0UL >> MMU_CAM_VATAG_SHIFT) << MMU_CAM_VATAG_SHIFT)
+#define MMU_CAM_P		(1 << 3)
+#define MMU_CAM_V		(1 << 2)
+#define MMU_CAM_PGSZ_MASK	3
+#define MMU_CAM_PGSZ_1M		(0 << 0)
+#define MMU_CAM_PGSZ_64K	(1 << 0)
+#define MMU_CAM_PGSZ_4K		(2 << 0)
+#define MMU_CAM_PGSZ_16M	(3 << 0)
+
+#define MMU_RAM_PADDR_SHIFT	12
+#define MMU_RAM_PADDR_MASK \
+	((~0UL >> MMU_RAM_PADDR_SHIFT) << MMU_RAM_PADDR_SHIFT)
+#define MMU_RAM_ENDIAN_SHIFT	9
+#define MMU_RAM_ENDIAN_MASK	(1 << MMU_RAM_ENDIAN_SHIFT)
+#define MMU_RAM_ENDIAN_BIG	(1 << MMU_RAM_ENDIAN_SHIFT)
+#define MMU_RAM_ENDIAN_LITTLE	(0 << MMU_RAM_ENDIAN_SHIFT)
+#define MMU_RAM_ELSZ_SHIFT	7
+#define MMU_RAM_ELSZ_MASK	(3 << MMU_RAM_ELSZ_SHIFT)
+#define MMU_RAM_ELSZ_8		(0 << MMU_RAM_ELSZ_SHIFT)
+#define MMU_RAM_ELSZ_16		(1 << MMU_RAM_ELSZ_SHIFT)
+#define MMU_RAM_ELSZ_32		(2 << MMU_RAM_ELSZ_SHIFT)
+#define MMU_RAM_ELSZ_NONE	(3 << MMU_RAM_ELSZ_SHIFT)
+#define MMU_RAM_MIXED_SHIFT	6
+#define MMU_RAM_MIXED_MASK	(1 << MMU_RAM_MIXED_SHIFT)
+#define MMU_RAM_MIXED		MMU_RAM_MIXED_MASK
 
 /*
  * utilities for super page(16MB, 1MB, 64KB and 4KB)
@@ -203,4 +268,17 @@ omap_iommu_dump_ctx(struct omap_iommu *obj, char *buf, ssize_t len);
 extern size_t
 omap_dump_tlb_entries(struct omap_iommu *obj, char *buf, ssize_t len);
 
+/*
+ * register accessors
+ */
+static inline u32 iommu_read_reg(struct omap_iommu *obj, size_t offs)
+{
+	return __raw_readl(obj->regbase + offs);
+}
+
+static inline void iommu_write_reg(struct omap_iommu *obj, u32 val, size_t offs)
+{
+	__raw_writel(val, obj->regbase + offs);
+}
+
 #endif /* __MACH_IOMMU_H */
diff --git a/arch/arm/plat-omap/include/plat/iommu2.h b/arch/arm/plat-omap/include/plat/iommu2.h
deleted file mode 100644
index d4116b5..0000000
--- a/arch/arm/plat-omap/include/plat/iommu2.h
+++ /dev/null
@@ -1,96 +0,0 @@
-/*
- * omap iommu: omap2 architecture specific definitions
- *
- * Copyright (C) 2008-2009 Nokia Corporation
- *
- * Written by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __MACH_IOMMU2_H
-#define __MACH_IOMMU2_H
-
-#include <linux/io.h>
-
-/*
- * MMU Register offsets
- */
-#define MMU_REVISION		0x00
-#define MMU_SYSCONFIG		0x10
-#define MMU_SYSSTATUS		0x14
-#define MMU_IRQSTATUS		0x18
-#define MMU_IRQENABLE		0x1c
-#define MMU_WALKING_ST		0x40
-#define MMU_CNTL		0x44
-#define MMU_FAULT_AD		0x48
-#define MMU_TTB			0x4c
-#define MMU_LOCK		0x50
-#define MMU_LD_TLB		0x54
-#define MMU_CAM			0x58
-#define MMU_RAM			0x5c
-#define MMU_GFLUSH		0x60
-#define MMU_FLUSH_ENTRY		0x64
-#define MMU_READ_CAM		0x68
-#define MMU_READ_RAM		0x6c
-#define MMU_EMU_FAULT_AD	0x70
-
-#define MMU_REG_SIZE		256
-
-/*
- * MMU Register bit definitions
- */
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
-#define MMU_CAM_VATAG_SHIFT	12
-#define MMU_CAM_VATAG_MASK \
-	((~0UL >> MMU_CAM_VATAG_SHIFT) << MMU_CAM_VATAG_SHIFT)
-#define MMU_CAM_P		(1 << 3)
-#define MMU_CAM_V		(1 << 2)
-#define MMU_CAM_PGSZ_MASK	3
-#define MMU_CAM_PGSZ_1M		(0 << 0)
-#define MMU_CAM_PGSZ_64K	(1 << 0)
-#define MMU_CAM_PGSZ_4K		(2 << 0)
-#define MMU_CAM_PGSZ_16M	(3 << 0)
-
-#define MMU_RAM_PADDR_SHIFT	12
-#define MMU_RAM_PADDR_MASK \
-	((~0UL >> MMU_RAM_PADDR_SHIFT) << MMU_RAM_PADDR_SHIFT)
-#define MMU_RAM_ENDIAN_SHIFT	9
-#define MMU_RAM_ENDIAN_MASK	(1 << MMU_RAM_ENDIAN_SHIFT)
-#define MMU_RAM_ENDIAN_BIG	(1 << MMU_RAM_ENDIAN_SHIFT)
-#define MMU_RAM_ENDIAN_LITTLE	(0 << MMU_RAM_ENDIAN_SHIFT)
-#define MMU_RAM_ELSZ_SHIFT	7
-#define MMU_RAM_ELSZ_MASK	(3 << MMU_RAM_ELSZ_SHIFT)
-#define MMU_RAM_ELSZ_8		(0 << MMU_RAM_ELSZ_SHIFT)
-#define MMU_RAM_ELSZ_16		(1 << MMU_RAM_ELSZ_SHIFT)
-#define MMU_RAM_ELSZ_32		(2 << MMU_RAM_ELSZ_SHIFT)
-#define MMU_RAM_ELSZ_NONE	(3 << MMU_RAM_ELSZ_SHIFT)
-#define MMU_RAM_MIXED_SHIFT	6
-#define MMU_RAM_MIXED_MASK	(1 << MMU_RAM_MIXED_SHIFT)
-#define MMU_RAM_MIXED		MMU_RAM_MIXED_MASK
-
-/*
- * register accessors
- */
-static inline u32 iommu_read_reg(struct omap_iommu *obj, size_t offs)
-{
-	return __raw_readl(obj->regbase + offs);
-}
-
-static inline void iommu_write_reg(struct omap_iommu *obj, u32 val, size_t offs)
-{
-	__raw_writel(val, obj->regbase + offs);
-}
-
-#endif /* __MACH_IOMMU2_H */
-- 
1.7.11.4

