Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:24465 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab2HPJqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 05:46:22 -0400
Received: from epcpsbgm2.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8U00ABJDT84OA0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 18:46:21 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8U00AV0DT26T80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 18:46:21 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/4] s5p-fimc: Enable FIMC-LITE driver only for SOC_EXYNOS4x12
Date: Thu, 16 Aug 2012 11:46:09 +0200
Message-id: <1345110372-11874-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow to compile-in the FIMC-LITE driver only on Exynos4212,
Exynos4412 and Exynos5250 SoC where the device is available.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-fimc/Kconfig b/drivers/media/platform/s5p-fimc/Kconfig
index a564f7e..8f090a8 100644
--- a/drivers/media/platform/s5p-fimc/Kconfig
+++ b/drivers/media/platform/s5p-fimc/Kconfig
@@ -31,7 +31,7 @@ config VIDEO_S5P_MIPI_CSIS
 	  To compile this driver as a module, choose M here: the
 	  module will be called s5p-csis.
 
-if ARCH_EXYNOS
+if SOC_EXYNOS4212 || SOC_EXYNOS4412 || SOC_EXYNOS5250
 
 config VIDEO_EXYNOS_FIMC_LITE
 	tristate "EXYNOS FIMC-LITE camera interface driver"
-- 
1.7.10

