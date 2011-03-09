Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62387 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab1CIJRr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 04:17:47 -0500
From: David Cohen <dacohen@gmail.com>
To: Hiroshi.DOYU@nokia.com
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, fernando.lugo@ti.com,
	David Cohen <dacohen@gmail.com>
Subject: [PATCH v3 2/2] omap: iovmm: don't check 'da' to set IOVMF_DA_FIXED flag
Date: Wed,  9 Mar 2011 11:17:33 +0200
Message-Id: <1299662253-29817-3-git-send-email-dacohen@gmail.com>
In-Reply-To: <1299662253-29817-1-git-send-email-dacohen@gmail.com>
References: <1299662253-29817-1-git-send-email-dacohen@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Currently IOVMM driver sets IOVMF_DA_FIXED/IOVMF_DA_ANON flags according
to input 'da' address when mapping memory:
da == 0: IOVMF_DA_ANON
da != 0: IOVMF_DA_FIXED

It prevents IOMMU to map first page with fixed 'da'. To avoid such
issue, IOVMM will not automatically set IOVMF_DA_FIXED. It should now
come from the user throught 'flags' parameter when mapping memory.
As IOVMF_DA_ANON and IOVMF_DA_FIXED are mutually exclusive, IOVMF_DA_ANON
can be removed. The driver will now check internally if IOVMF_DA_FIXED
is set or not.

Signed-off-by: David Cohen <dacohen@gmail.com>
---
 arch/arm/plat-omap/include/plat/iovmm.h |    2 --
 arch/arm/plat-omap/iovmm.c              |   14 +++++---------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/iovmm.h b/arch/arm/plat-omap/include/plat/iovmm.h
index bdc7ce5..32a2f6c 100644
--- a/arch/arm/plat-omap/include/plat/iovmm.h
+++ b/arch/arm/plat-omap/include/plat/iovmm.h
@@ -71,8 +71,6 @@ struct iovm_struct {
 #define IOVMF_LINEAR_MASK	(3 << (2 + IOVMF_SW_SHIFT))
 
 #define IOVMF_DA_FIXED		(1 << (4 + IOVMF_SW_SHIFT))
-#define IOVMF_DA_ANON		(2 << (4 + IOVMF_SW_SHIFT))
-#define IOVMF_DA_MASK		(3 << (4 + IOVMF_SW_SHIFT))
 
 
 extern struct iovm_struct *find_iovm_area(struct iommu *obj, u32 da);
diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index ea7eab9..51ef43e 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -279,7 +279,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 	start = da;
 	alignment = PAGE_SIZE;
 
-	if (flags & IOVMF_DA_ANON) {
+	if (~flags & IOVMF_DA_FIXED) {
 		/* Don't map address 0 */
 		start = obj->da_start ? obj->da_start : alignment;
 
@@ -304,7 +304,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 		if (tmp->da_start > start && (tmp->da_start - start) >= bytes)
 			goto found;
 
-		if (tmp->da_end >= start && flags & IOVMF_DA_ANON)
+		if (tmp->da_end >= start && ~flags & IOVMF_DA_FIXED)
 			start = roundup(tmp->da_end + 1, alignment);
 
 		prev_end = tmp->da_end;
@@ -651,7 +651,6 @@ u32 iommu_vmap(struct iommu *obj, u32 da, const struct sg_table *sgt,
 	flags &= IOVMF_HW_MASK;
 	flags |= IOVMF_DISCONT;
 	flags |= IOVMF_MMIO;
-	flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
 
 	da = __iommu_vmap(obj, da, sgt, va, bytes, flags);
 	if (IS_ERR_VALUE(da))
@@ -691,7 +690,7 @@ EXPORT_SYMBOL_GPL(iommu_vunmap);
  * @flags:	iovma and page property
  *
  * Allocate @bytes linearly and creates 1-n-1 mapping and returns
- * @da again, which might be adjusted if 'IOVMF_DA_ANON' is set.
+ * @da again, which might be adjusted if 'IOVMF_DA_FIXED' is not set.
  */
 u32 iommu_vmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
 {
@@ -710,7 +709,6 @@ u32 iommu_vmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
 	flags &= IOVMF_HW_MASK;
 	flags |= IOVMF_DISCONT;
 	flags |= IOVMF_ALLOC;
-	flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
 
 	sgt = sgtable_alloc(bytes, flags, da, 0);
 	if (IS_ERR(sgt)) {
@@ -781,7 +779,7 @@ static u32 __iommu_kmap(struct iommu *obj, u32 da, u32 pa, void *va,
  * @flags:	iovma and page property
  *
  * Creates 1-1-1 mapping and returns @da again, which can be
- * adjusted if 'IOVMF_DA_ANON' is set.
+ * adjusted if 'IOVMF_DA_FIXED' is not set.
  */
 u32 iommu_kmap(struct iommu *obj, u32 da, u32 pa, size_t bytes,
 		 u32 flags)
@@ -800,7 +798,6 @@ u32 iommu_kmap(struct iommu *obj, u32 da, u32 pa, size_t bytes,
 	flags &= IOVMF_HW_MASK;
 	flags |= IOVMF_LINEAR;
 	flags |= IOVMF_MMIO;
-	flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
 
 	da = __iommu_kmap(obj, da, pa, va, bytes, flags);
 	if (IS_ERR_VALUE(da))
@@ -839,7 +836,7 @@ EXPORT_SYMBOL_GPL(iommu_kunmap);
  * @flags:	iovma and page property
  *
  * Allocate @bytes linearly and creates 1-1-1 mapping and returns
- * @da again, which might be adjusted if 'IOVMF_DA_ANON' is set.
+ * @da again, which might be adjusted if 'IOVMF_DA_FIXED' is not set.
  */
 u32 iommu_kmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
 {
@@ -859,7 +856,6 @@ u32 iommu_kmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
 	flags &= IOVMF_HW_MASK;
 	flags |= IOVMF_LINEAR;
 	flags |= IOVMF_ALLOC;
-	flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
 
 	da = __iommu_kmap(obj, da, pa, va, bytes, flags);
 	if (IS_ERR_VALUE(da))
-- 
1.7.4.1

