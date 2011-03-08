Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48929 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab1CHUPa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 15:15:30 -0500
From: David Cohen <dacohen@gmail.com>
To: Hiroshi.DOYU@nokia.com
Cc: linux-omap@vger.kernel.org, fernando.lugo@ti.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com,
	Michael Jones <michael.jones@matrix-vision.de>
Subject: [PATCH v2 1/3] omap: iovmm: disallow mapping NULL address when IOVMF_DA_ANON is set
Date: Tue,  8 Mar 2011 22:15:14 +0200
Message-Id: <1299615316-17512-2-git-send-email-dacohen@gmail.com>
In-Reply-To: <1299615316-17512-1-git-send-email-dacohen@gmail.com>
References: <1299615316-17512-1-git-send-email-dacohen@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Michael Jones <michael.jones@matrix-vision.de>

commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb allowed mapping the NULL
address if da_start==0, which would then not get unmapped. Disallow
this again if IOVMF_DA_ANON is set. And spell variable 'alignment'
correctly.

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 arch/arm/plat-omap/iovmm.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 6dc1296..e5f8341 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -271,20 +271,24 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
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
+		if (obj->da_start)
+			start = obj->da_start;
+		else
+			start = alignment;
 
 		if (flags & IOVMF_LINEAR)
-			alignement = iopgsz_max(bytes);
-		start = roundup(start, alignement);
+			alignment = iopgsz_max(bytes);
+		start = roundup(start, alignment);
 	} else if (start < obj->da_start || start > obj->da_end ||
 					obj->da_end - start < bytes) {
 		return ERR_PTR(-EINVAL);
@@ -304,7 +308,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 			goto found;
 
 		if (tmp->da_end >= start && flags & IOVMF_DA_ANON)
-			start = roundup(tmp->da_end + 1, alignement);
+			start = roundup(tmp->da_end + 1, alignment);
 
 		prev_end = tmp->da_end;
 	}
-- 
1.7.0.4

