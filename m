Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47005 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab1CHMqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 07:46:24 -0500
From: David Cohen <dacohen@gmail.com>
To: Hiroshi.DOYU@nokia.com
Cc: linux-omap@vger.kernel.org, fernando.lugo@ti.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com,
	David Cohen <dacohen@gmail.com>
Subject: [PATCH 3/3] omap: iovmm: don't check 'da' to set IOVMF_DA_FIXED/IOVMF_DA_ANON flags
Date: Tue,  8 Mar 2011 14:46:05 +0200
Message-Id: <1299588365-2749-4-git-send-email-dacohen@gmail.com>
In-Reply-To: <1299588365-2749-1-git-send-email-dacohen@gmail.com>
References: <1299588365-2749-1-git-send-email-dacohen@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Currently IOVMM driver sets IOVMF_DA_FIXED/IOVMF_DA_ANON flags according
to input 'da' address when mapping memory:
da == 0: IOVMF_DA_ANON
da != 0: IOVMF_DA_FIXED

It prevents IOMMU to map first page with fixed 'da'. To avoid such
issue, IOVMM will not automatically set IOVMF_DA_FIXED. It should now
come from the user. IOVMF_DA_ANON will be automatically set if
IOVMF_DA_FIXED isn't set.

Signed-off-by: David Cohen <dacohen@gmail.com>
---
 arch/arm/plat-omap/iovmm.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 11c9b76..dde9cb0 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -654,7 +654,8 @@ u32 iommu_vmap(struct iommu *obj, u32 da, const struct sg_table *sgt,
 	flags &= IOVMF_HW_MASK;
 	flags |= IOVMF_DISCONT;
 	flags |= IOVMF_MMIO;
-	flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
+	if (~flags & IOVMF_DA_FIXED)
+		flags |= IOVMF_DA_ANON;
 
 	da = __iommu_vmap(obj, da, sgt, va, bytes, flags);
 	if (IS_ERR_VALUE(da))
@@ -713,7 +714,8 @@ u32 iommu_vmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
 	flags &= IOVMF_HW_MASK;
 	flags |= IOVMF_DISCONT;
 	flags |= IOVMF_ALLOC;
-	flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
+	if (~flags & IOVMF_DA_FIXED)
+		flags |= IOVMF_DA_ANON;
 
 	sgt = sgtable_alloc(bytes, flags, da, 0);
 	if (IS_ERR(sgt)) {
@@ -803,7 +805,8 @@ u32 iommu_kmap(struct iommu *obj, u32 da, u32 pa, size_t bytes,
 	flags &= IOVMF_HW_MASK;
 	flags |= IOVMF_LINEAR;
 	flags |= IOVMF_MMIO;
-	flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
+	if (~flags & IOVMF_DA_FIXED)
+		flags |= IOVMF_DA_ANON;
 
 	da = __iommu_kmap(obj, da, pa, va, bytes, flags);
 	if (IS_ERR_VALUE(da))
@@ -862,7 +865,8 @@ u32 iommu_kmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
 	flags &= IOVMF_HW_MASK;
 	flags |= IOVMF_LINEAR;
 	flags |= IOVMF_ALLOC;
-	flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
+	if (~flags & IOVMF_DA_FIXED)
+		flags |= IOVMF_DA_ANON;
 
 	da = __iommu_kmap(obj, da, pa, va, bytes, flags);
 	if (IS_ERR_VALUE(da))
-- 
1.7.0.4

