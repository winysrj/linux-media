Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41745 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3FQQe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 12:34:59 -0400
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Kukjin Kim <kgene.kim@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Thomas Abraham <thomas.abraham@linaro.org>,
	Tomasz Figa <t.figa@samsung.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 32/38] [media] exynos4-is: Remove check for SOC_EXYNOS4412
Date: Mon, 17 Jun 2013 18:34:17 +0200
Message-id: <1371486863-12398-33-git-send-email-t.figa@samsung.com>
In-reply-to: <1371486863-12398-1-git-send-email-t.figa@samsung.com>
References: <1371486863-12398-1-git-send-email-t.figa@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since SOC_EXYNOS4412 Kconfig symbol has been removed, it is enough to
check for SOC_EXYNOS4212 for both SoCs from Exynos4x12 series.

Cc: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 004fd0b..0d4fd5c 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -33,7 +33,7 @@ config VIDEO_S5P_MIPI_CSIS
 	  To compile this driver as a module, choose M here: the
 	  module will be called s5p-csis.
 
-if SOC_EXYNOS4212 || SOC_EXYNOS4412 || SOC_EXYNOS5250
+if SOC_EXYNOS4212 || SOC_EXYNOS5250
 
 config VIDEO_EXYNOS_FIMC_LITE
 	tristate "EXYNOS FIMC-LITE camera interface driver"
-- 
1.8.2.1

