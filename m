Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61139 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753210AbeDLPYb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:24:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 02/17] media: staging: atomisp: don't declare the same vars as both private and public
Date: Thu, 12 Apr 2018 11:23:54 -0400
Message-Id: <42844ee6ace2c70c17fede492f2bd865232e1e3e.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mmu_private.h header is included at mmu.c, with duplicates the
already existing definitions at mmu_public.h.

Fix this by removing the erroneous header file.

Solve those issues:

    drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h:24:26: warning: function 'mmu_reg_store' with external linkage has definition
    drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h:35:30: warning: function 'mmu_reg_load' with external linkage has definition
    drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h:24:26: warning: function 'mmu_reg_store' with external linkage has definition
    drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h:35:30: warning: function 'mmu_reg_load' with external linkage has definition

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../css2400/hive_isp_css_common/host/mmu.c         |  4 --
 .../css2400/hive_isp_css_common/host/mmu_private.h | 44 ----------------------
 .../css2400/hive_isp_css_include/host/mmu_public.h |  4 +-
 .../css2400/hive_isp_css_include/mmu_device.h      |  8 ----
 4 files changed, 2 insertions(+), 58 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu.c
index a28b67eb66ea..1a1719d3e745 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu.c
@@ -15,10 +15,6 @@
 /* The name "mmu.h is already taken" */
 #include "mmu_device.h"
 
-#ifndef __INLINE_MMU__
-#include "mmu_private.h"
-#endif /* __INLINE_MMU__ */
-
 void mmu_set_page_table_base_index(
 	const mmu_ID_t		ID,
 	const hrt_data		base_index)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h
deleted file mode 100644
index 7377666f6eb7..000000000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h
+++ /dev/null
@@ -1,44 +0,0 @@
-/*
- * Support for Intel Camera Imaging ISP subsystem.
- * Copyright (c) 2010-2015, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- */
-
-#ifndef __MMU_PRIVATE_H_INCLUDED__
-#define __MMU_PRIVATE_H_INCLUDED__
-
-#include "mmu_public.h"
-
-#include "device_access.h"
-
-#include "assert_support.h"
-
-STORAGE_CLASS_MMU_H void mmu_reg_store(
-	const mmu_ID_t		ID,
-	const unsigned int	reg,
-	const hrt_data		value)
-{
-	assert(ID < N_MMU_ID);
-	assert(MMU_BASE[ID] != (hrt_address)-1);
-	ia_css_device_store_uint32(MMU_BASE[ID] + reg*sizeof(hrt_data), value);
-	return;
-}
-
-STORAGE_CLASS_MMU_H hrt_data mmu_reg_load(
-	const mmu_ID_t		ID,
-	const unsigned int	reg)
-{
-	assert(ID < N_MMU_ID);
-	assert(MMU_BASE[ID] != (hrt_address)-1);
-	return ia_css_device_load_uint32(MMU_BASE[ID] + reg*sizeof(hrt_data));
-}
-
-#endif /* __MMU_PRIVATE_H_INCLUDED__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/mmu_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/mmu_public.h
index 0a13eda73607..637e136c4fc5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/mmu_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/mmu_public.h
@@ -62,7 +62,7 @@ extern void mmu_invalidate_cache_all(void);
 
  \return none, MMU[ID].ctrl[reg] = value
  */
-STORAGE_CLASS_MMU_H void mmu_reg_store(
+extern void mmu_reg_store(
 	const mmu_ID_t		ID,
 	const unsigned int	reg,
 	const hrt_data		value);
@@ -75,7 +75,7 @@ STORAGE_CLASS_MMU_H void mmu_reg_store(
 
  \return MMU[ID].ctrl[reg]
  */
-STORAGE_CLASS_MMU_H hrt_data mmu_reg_load(
+extern hrt_data mmu_reg_load(
 	const mmu_ID_t		ID,
 	const unsigned int	reg);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/mmu_device.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/mmu_device.h
index 519e850ec390..8f6f1dc40095 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/mmu_device.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/mmu_device.h
@@ -35,14 +35,6 @@
 #include "system_local.h"
 #include "mmu_local.h"
 
-#ifndef __INLINE_MMU__
-#define STORAGE_CLASS_MMU_H extern
-#define STORAGE_CLASS_MMU_C 
 #include "mmu_public.h"
-#else  /* __INLINE_MMU__ */
-#define STORAGE_CLASS_MMU_H static inline
-#define STORAGE_CLASS_MMU_C static inline
-#include "mmu_private.h"
-#endif /* __INLINE_MMU__ */
 
 #endif /* __MMU_DEVICE_H_INCLUDED__ */
-- 
2.14.3
