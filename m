Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62930 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2JAWq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 18:46:56 -0400
Received: by mail-qa0-f46.google.com with SMTP id c26so86179qad.19
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2012 15:46:56 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH v2 5/5] arm: omap: Move iopgtable header to drivers/iommu/
Date: Mon,  1 Oct 2012 18:46:31 -0400
Message-Id: <1349131591-10804-5-git-send-email-ido@wizery.com>
In-Reply-To: <1349131591-10804-1-git-send-email-ido@wizery.com>
References: <20120927195526.GP4840@atomide.com>
 <1349131591-10804-1-git-send-email-ido@wizery.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The iopgtable header file is only used by the iommu & iovmm drivers, so
move it to drivers/iommu/, as part of the single zImage effort.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/iommu/omap-iommu-debug.c                                       | 3 +--
 drivers/iommu/omap-iommu.c                                             | 3 +--
 .../include/plat/iopgtable.h => drivers/iommu/omap-iopgtable.h         | 0
 drivers/iommu/omap-iovmm.c                                             | 3 +--
 4 files changed, 3 insertions(+), 6 deletions(-)
 rename arch/arm/plat-omap/include/plat/iopgtable.h => drivers/iommu/omap-iopgtable.h (100%)

diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index 8c1e30b..84dbfd2 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -22,8 +22,7 @@
 #include <linux/platform_data/iommu-omap.h>
 #include <linux/platform_data/iovmm-omap.h>
 
-#include <plat/iopgtable.h>
-
+#include "omap-iopgtable.h"
 #include "omap-iommu.h"
 
 #define MAXCOLUMN 100 /* for short messages */
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 6100334..1ca33b0 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -26,8 +26,7 @@
 
 #include <linux/platform_data/iommu-omap.h>
 
-#include <plat/iopgtable.h>
-
+#include "omap-iopgtable.h"
 #include "omap-iommu.h"
 
 #define for_each_iotlb_cr(obj, n, __i, cr)				\
diff --git a/arch/arm/plat-omap/include/plat/iopgtable.h b/drivers/iommu/omap-iopgtable.h
similarity index 100%
rename from arch/arm/plat-omap/include/plat/iopgtable.h
rename to drivers/iommu/omap-iopgtable.h
diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index b5ac2cd..2820e3a 100644
--- a/drivers/iommu/omap-iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -24,8 +24,7 @@
 #include <linux/platform_data/iommu-omap.h>
 #include <linux/platform_data/iovmm-omap.h>
 
-#include <plat/iopgtable.h>
-
+#include "omap-iopgtable.h"
 #include "omap-iommu.h"
 
 static struct kmem_cache *iovm_area_cachep;
-- 
1.7.11.4

