Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54350 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752042AbeCZVLB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:11:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Georgiana Chelu <georgiana.chelu93@gmail.com>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 08/18] media: staging: atomisp: remove unused set_pd_base()
Date: Mon, 26 Mar 2018 17:10:41 -0400
Message-Id: <4a974da154f40008d58a98bf736fd3314dffdea7.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's an implementation for set_pd_base at sh_mmu logic
with is said to be mandatory. However, the implementation
ends by calling a routine that does nothing.

So get rid of this entire nonsense.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../staging/media/atomisp/pci/atomisp2/atomisp_compat.h   |  2 --
 .../media/atomisp/pci/atomisp2/atomisp_compat_css20.c     |  4 ----
 .../media/atomisp/pci/atomisp2/include/mmu/isp_mmu.h      |  4 +---
 drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c  | 13 ++-----------
 .../staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c | 15 ---------------
 5 files changed, 3 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
index 3ef850cd25bd..398ee02229f8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
@@ -182,8 +182,6 @@ void atomisp_css_mmu_invalidate_cache(void);
 
 void atomisp_css_mmu_invalidate_tlb(void);
 
-void atomisp_css_mmu_set_page_table_base_index(unsigned long base_index);
-
 int atomisp_css_start(struct atomisp_sub_device *asd,
 		      enum atomisp_css_pipe_id pipe_id, bool in_reset);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index 7621b4537147..bbed1ed02074 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -1159,10 +1159,6 @@ void atomisp_css_mmu_invalidate_tlb(void)
 	ia_css_mmu_invalidate_cache();
 }
 
-void atomisp_css_mmu_set_page_table_base_index(unsigned long base_index)
-{
-}
-
 /*
  * Check whether currently running MIPI buffer size fulfill
  * the requirement of the stream to be run
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/isp_mmu.h b/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/isp_mmu.h
index 560014add005..4b2d94a37ea1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/isp_mmu.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/isp_mmu.h
@@ -80,12 +80,10 @@ struct isp_mmu_client {
 	unsigned int null_pte;
 
 	/*
-	 * set/get page directory base address (physical address).
+	 * get page directory base address (physical address).
 	 *
 	 * must be provided.
 	 */
-	int (*set_pd_base) (struct isp_mmu *mmu,
-			phys_addr_t pd_base);
 	unsigned int (*get_pd_base) (struct isp_mmu *mmu, phys_addr_t pd_base);
 	/*
 	 * callback to flush tlb.
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c b/drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c
index f21075c1e503..198f29f4a324 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c
@@ -344,13 +344,6 @@ static int mmu_map(struct isp_mmu *mmu, unsigned int isp_virt,
 		/*
 		 * setup L1 page table physical addr to MMU
 		 */
-		ret = mmu->driver->set_pd_base(mmu, l1_pt);
-		if (ret) {
-			dev_err(atomisp_dev,
-				 "set page directory base address fail.\n");
-			mutex_unlock(&mmu->pt_mutex);
-			return ret;
-		}
 		mmu->base_address = l1_pt;
 		mmu->l1_pte = isp_pgaddr_to_pte_valid(mmu, l1_pt);
 		memset(mmu->l2_pgt_refcount, 0, sizeof(int) * ISP_L1PT_PTES);
@@ -531,10 +524,8 @@ int isp_mmu_init(struct isp_mmu *mmu, struct isp_mmu_client *driver)
 
 	mmu->driver = driver;
 
-	if (!driver->set_pd_base || !driver->tlb_flush_all) {
-		dev_err(atomisp_dev,
-			    "set_pd_base or tlb_flush_all operation "
-			     "not provided.\n");
+	if (!driver->tlb_flush_all) {
+		dev_err(atomisp_dev, "tlb_flush_all operation not provided.\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c b/drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c
index c59bcc982966..4cbf907bd07b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c
@@ -40,20 +40,6 @@ static phys_addr_t sh_pte_to_phys(struct isp_mmu *mmu,
 	return (phys_addr_t)((pte & ~mask) << ISP_PAGE_OFFSET);
 }
 
-/*
- * set page directory base address (physical address).
- *
- * must be provided.
- */
-static int sh_set_pd_base(struct isp_mmu *mmu,
-			  phys_addr_t phys)
-{
-	unsigned int pte = sh_phys_to_pte(mmu, phys);
-	/*mmgr_set_base_address(HOST_ADDRESS(pte));*/
-	atomisp_css_mmu_set_page_table_base_index(HOST_ADDRESS(pte));
-	return 0;
-}
-
 static unsigned int sh_get_pd_base(struct isp_mmu *mmu,
 				   phys_addr_t phys)
 {
@@ -81,7 +67,6 @@ struct isp_mmu_client sh_mmu_mrfld = {
 	.name = "Silicon Hive ISP3000 MMU",
 	.pte_valid_mask = MERR_VALID_PTE_MASK,
 	.null_pte = ~MERR_VALID_PTE_MASK,
-	.set_pd_base = sh_set_pd_base,
 	.get_pd_base = sh_get_pd_base,
 	.tlb_flush_all = sh_tlb_flush,
 	.phys_to_pte = sh_phys_to_pte,
-- 
2.14.3
