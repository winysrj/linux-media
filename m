Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:39702 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3EIMoA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 08:44:00 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ004Q87D4CK80@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 May 2013 21:43:59 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, hj210.choi@samsung.com,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] exynos4-is: Correct fimc-lite compatible property description
Date: Thu, 09 May 2013 14:43:34 +0200
Message-id: <1368103414-16645-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure the compatible property for FIMC-LITE IP blocks is properly
documented, a cut&paste error fix.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/media/exynos-fimc-lite.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/exynos-fimc-lite.txt b/Documentation/devicetree/bindings/media/exynos-fimc-lite.txt
index 3f62adf..de9f6b7 100644
--- a/Documentation/devicetree/bindings/media/exynos-fimc-lite.txt
+++ b/Documentation/devicetree/bindings/media/exynos-fimc-lite.txt
@@ -2,7 +2,7 @@ Exynos4x12/Exynos5 SoC series camera host interface (FIMC-LITE)
 
 Required properties:
 
-- compatible	: should be "samsung,exynos4212-fimc" for Exynos4212 and
+- compatible	: should be "samsung,exynos4212-fimc-lite" for Exynos4212 and
 		  Exynos4412 SoCs;
 - reg		: physical base address and size of the device memory mapped
 		  registers;
-- 
1.7.9.5

