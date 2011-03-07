Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:33106 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab1CGNKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 08:10:41 -0500
Message-ID: <4D74D94F.7040702@matrix-vision.de>
Date: Mon, 07 Mar 2011 14:10:39 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: David Cohen <dacohen@gmail.com>
CC: Hiroshi.DOYU@nokia.com,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	fernando.lugo@ti.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-omap@vger.kernel.org
Subject: [PATCH] omap: iommu: disallow mapping NULL address
References: <4D6D219D.7020605@matrix-vision.de>	<201103022018.23446.laurent.pinchart@ideasonboard.com>	<4D6FBC7F.1080500@matrix-vision.de>	<AANLkTikAKy=CzTqEv-UGBQ1EavqmCStPNFZ5vs7vH5VK@mail.gmail.com>	<4D70F985.8030902@matrix-vision.de>	<AANLkTinSJpjPXWHWduLbRSmb=La3sv82ufwgsq-uR7S2@mail.gmail.com> <AANLkTi=8Sss-5xfgPmgx=J_T__=hrC1rQU-xBOdKC8Ve@mail.gmail.com>
In-Reply-To: <AANLkTi=8Sss-5xfgPmgx=J_T__=hrC1rQU-xBOdKC8Ve@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>From e7dbe4c4b64eb114f9b0804d6af3a3ca0e78acc8 Mon Sep 17 00:00:00 2001
From: Michael Jones <michael.jones@matrix-vision.de>
Date: Mon, 7 Mar 2011 13:36:15 +0100
Subject: [PATCH] omap: iommu: disallow mapping NULL address

commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb allowed mapping
the NULL address if da_start==0.  Force da_start to exclude the
first page.

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 arch/arm/plat-omap/iommu.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index 5990ea6..dcb5513 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -850,7 +850,7 @@ int iommu_set_da_range(struct iommu *obj, u32 start, u32 end)
 	if (end < start || !PAGE_ALIGN(start | end))
 		return -EINVAL;
 
-	obj->da_start = start;
+	obj->da_start = max(start, (u32)PAGE_SIZE);
 	obj->da_end = end;
 
 	return 0;
@@ -950,7 +950,9 @@ static int __devinit omap_iommu_probe(struct platform_device *pdev)
 	obj->name = pdata->name;
 	obj->dev = &pdev->dev;
 	obj->ctx = (void *)obj + sizeof(*obj);
-	obj->da_start = pdata->da_start;
+
+	/* reserve the first page for NULL */
+	obj->da_start = max(pdata->da_start, (u32)PAGE_SIZE);
 	obj->da_end = pdata->da_end;
 
 	mutex_init(&obj->iommu_lock);
-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
