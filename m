Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24834 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab0IFGf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 02:35:26 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 06 Sep 2010 08:33:59 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [RFCv5 9/9] mm: vcm: vcm-cma: VCM CMA driver added
In-reply-to: <cover.1283749231.git.mina86@mina86.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Daniel Walker <dwalker@codeaurora.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Jonathan Corbet <corbet@lwn.net>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mel Gorman <mel@csn.ul.ie>,
	Minchan Kim <minchan.kim@gmail.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Russell King <linux@arm.linux.org.uk>,
	Zach Pfeffer <zpfeffer@codeaurora.org>,
	linux-kernel@vger.kernel.org
Message-id: <01be3a37af9569f711ad18c4b868cd4708da19e4.1283749231.git.mina86@mina86.com>
References: <cover.1283749231.git.mina86@mina86.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This commit adds a VCM driver that instead of using real
hardware MMU emulates one and uses CMA for allocating
contiguous memory chunks.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/virtual-contiguous-memory.txt |   12 ++++-
 include/linux/vcm-cma.h                     |   38 ++++++++++++
 mm/Kconfig                                  |   14 +++++
 mm/Makefile                                 |    1 +
 mm/vcm-cma.c                                |   84 +++++++++++++++++++++++++++
 5 files changed, 148 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/vcm-cma.h
 create mode 100644 mm/vcm-cma.c

diff --git a/Documentation/virtual-contiguous-memory.txt b/Documentation/virtual-contiguous-memory.txt
index 6d1014c..01e2e6c 100644
--- a/Documentation/virtual-contiguous-memory.txt
+++ b/Documentation/virtual-contiguous-memory.txt
@@ -496,7 +496,17 @@ able to run with One-to-One driver you should limit operations to:
 
 under some conditions, vcm_map() may also work.
 
-There are no One-to-One drivers at this time.
+*** VCM CMA
+
+VCM CMA driver is a One-to-One driver which uses CMA (see
+[[file:contiguous-memory.txt][contiguous-memory.txt]]) to allocate physically contiguous memory.  VCM
+CMA context is created by calling:
+
+	struct vcm *__must_check
+	vcm_cma_create(const char *regions, dma_addr_t alignment);
+
+Its first argument is the list of regions that CMA should try to
+allocate memory from.  The second argument is required alignment.
 
 * Writing a VCM driver
 
diff --git a/include/linux/vcm-cma.h b/include/linux/vcm-cma.h
new file mode 100644
index 0000000..bc06767
--- /dev/null
+++ b/include/linux/vcm-cma.h
@@ -0,0 +1,38 @@
+/*
+ * Virtual Contiguous Memory driver for CMA header
+ * Copyright (c) 2010 by Samsung Electronics.
+ * Written by Michal Nazarewicz (m.nazarewicz@samsung.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License or (at your optional) any later version of the license.
+ */
+
+/*
+ * See Documentation/virtual-contiguous-memory.txt for details.
+ */
+
+#ifndef __LINUX_VCM_CMA_H
+#define __LINUX_VCM_CMA_H
+
+#include <linux/types.h>
+
+struct vcm;
+
+/**
+ * vcm_cma_create() - creates a VCM context that fakes a hardware MMU
+ * @regions:	list of CMA regions physical allocations should be done
+ *		from.
+ * @alignment:	required alignment of allocations.
+ *
+ * This creates VCM context that can be used on platforms with no
+ * hardware MMU or for devices that aro conected to the bus directly.
+ * Because it does not represent real MMU it has some limitations:
+ * basically, vcm_alloc(), vcm_reserve() and vcm_bind() are likely to
+ * fail so vcm_make_binding() should be used instead.
+ */
+struct vcm *__must_check
+vcm_cma_create(const char *regions, dma_addr_t alignment);
+
+#endif
diff --git a/mm/Kconfig b/mm/Kconfig
index be040e7..bf0c7f6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -410,3 +410,17 @@ config VCM_SAMP
 	  This enables a sample driver for the VCM framework.  This driver
 	  does not handle any real harwdare.  It's merely an template of
 	  how for real drivers.
+
+config VCM_CMA
+	bool "VCM CMA driver"
+	depends on VCM && CMA
+	select VCM_O2O
+	help
+	  This enables VCM driver that instead of using a real hardware
+	  MMU fakes one and uses a direct mapping.  It provides a subset
+	  of functionalities of a real MMU but if drivers limits their
+	  use of VCM to only supported operations they can work on
+	  both systems with and without MMU with no changes.
+
+	  For more information see
+	  <Documentation/virtual-contiguous-memory-cma.txt>.
diff --git a/mm/Makefile b/mm/Makefile
index c465dfa..e376eef 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -51,3 +51,4 @@ obj-$(CONFIG_CMA) += cma.o
 obj-$(CONFIG_CMA_BEST_FIT) += cma-best-fit.o
 obj-$(CONFIG_VCM) += vcm.o
 obj-$(CONFIG_VCM_SAMPLE) += vcm-sample.o
+obj-$(CONFIG_VCM_CMA) += vcm-cma.o
diff --git a/mm/vcm-cma.c b/mm/vcm-cma.c
new file mode 100644
index 0000000..177041a
--- /dev/null
+++ b/mm/vcm-cma.c
@@ -0,0 +1,84 @@
+/*
+ * Virtual Contiguous Memory driver for CMA
+ * Copyright (c) 2010 by Samsung Electronics.
+ * Written by Michal Nazarewicz (m.nazarewicz@samsung.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License or (at your optional) any later version of the license.
+ */
+
+/*
+ * See Documentation/virtual-contiguous-memory.txt for details.
+ */
+
+#include <linux/vcm-cma.h>
+#include <linux/vcm-drv.h>
+#include <linux/cma.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+
+struct vcm_cma {
+	struct vcm_o2o	o2o;
+	const char	*regions;
+	dma_addr_t	alignment;
+};
+
+static void *
+vcm_cma_alloc(struct vcm *vcm, struct vcm_phys_part *part, unsigned flags)
+{
+	struct vcm_cma *cma = container_of(vcm, struct vcm_cma, o2o.vcm);
+	dma_addr_t addr;
+
+	addr = cma_alloc_from(cma->regions, part->size, cma->alignment);
+	if (IS_ERR_VALUE(addr))
+		return ERR_PTR(addr);
+
+	part->start = addr;
+	return NULL;
+}
+
+static void vcm_cma_free(struct vcm_phys_part *part, void *priv)
+{
+	cma_free(part->start);
+}
+
+struct vcm *__must_check
+vcm_cma_create(const char *regions, dma_addr_t alignment)
+{
+	static const struct vcm_o2o_driver driver = {
+		.alloc	= vcm_cma_alloc,
+		.free	= vcm_cma_free,
+	};
+
+	struct cma_info info;
+	struct vcm_cma *cma;
+	struct vcm *vcm;
+	int ret;
+
+	if (alignment & (alignment - 1))
+		return ERR_PTR(-EINVAL);
+
+	ret = cma_info_about(&info, regions);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	if (info.count == 0)
+		return ERR_PTR(-ENOENT);
+
+	cma = kmalloc(sizeof *cma, GFP_KERNEL);
+	if (!cma)
+		return ERR_PTR(-ENOMEM);
+
+	cma->o2o.driver    = &driver;
+	cma->o2o.vcm.start = info.lower_bound;
+	cma->o2o.vcm.size  = info.upper_bound - info.lower_bound;
+	cma->regions       = regions;
+	cma->alignment     = alignment;
+	vcm = vcm_o2o_init(&cma->o2o);
+	if (IS_ERR(vcm))
+		kfree(cma);
+	return vcm;
+}
+EXPORT_SYMBOL_GPL(vcm_cma_create);
-- 
1.7.1

