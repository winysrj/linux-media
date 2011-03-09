Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46631 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab1CIJRp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 04:17:45 -0500
From: David Cohen <dacohen@gmail.com>
To: Hiroshi.DOYU@nokia.com
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, fernando.lugo@ti.com,
	Michael Jones <michael.jones@matrix-vision.de>
Subject: [PATCH v3 1/2] omap: iovmm: disallow mapping NULL address when IOVMF_DA_ANON is set
Date: Wed,  9 Mar 2011 11:17:32 +0200
Message-Id: <1299662253-29817-2-git-send-email-dacohen@gmail.com>
In-Reply-To: <1299662253-29817-1-git-send-email-dacohen@gmail.com>
References: <1299662253-29817-1-git-send-email-dacohen@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Michael Jones <michael.jones@matrix-vision.de>

commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb allowed mapping the NULL
address if da_start==0, which would then not get unmapped. Disallow
this again if IOVMF_DA_ANON is set. And spell variable 'alignment'
correctly.

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 arch/arm/plat-omap/iovmm.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 6dc1296..ea7eab9 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -271,20 +271,21 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 					   size_t bytes, u32 flags)
 {
 	struct iovm_struct *new, *tmp;
-	u32 start, prev_end, alignement;
+	u32 start, prev_end, alignment;
 
 	if (!obj || !bytes)
 		return ERR_PTR(-EINVAL);
 
 	start = da;
-	alignement = PAGE_SIZE;
+	alignment = PAGE_SIZE;
 
 	if (flags & IOVMF_DA_ANON) {
-		start = obj->da_start;
+		/* Don't map address 0 */
+		start = obj->da_start ? obj->da_start : alignment;
 
 		if (flags & IOVMF_LINEAR)
-			alignement = iopgsz_max(bytes);
-		start = roundup(start, alignement);
+			alignment = iopgsz_max(bytes);
+		start = roundup(start, alignment);
 	} else if (start < obj->da_start || start > obj->da_end ||
 					obj->da_end - start < bytes) {
 		return ERR_PTR(-EINVAL);
@@ -304,7 +305,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 			goto found;
 
 		if (tmp->da_end >= start && flags & IOVMF_DA_ANON)
-			start = roundup(tmp->da_end + 1, alignement);
+			start = roundup(tmp->da_end + 1, alignment);
 
 		prev_end = tmp->da_end;
 	}
-- 
1.7.4.1

