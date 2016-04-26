Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:50667 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbcDZJQu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2016 05:16:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] exynos-gsc: avoid build warning without CONFIG_OF
Date: Tue, 26 Apr 2016 11:15:38 +0200
Message-Id: <1461662157-1798157-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When building the exynos-gsc driver with CONFIG_OF disabled, we get
a warning about an out-of-bounds access:

drivers/media/platform/exynos-gsc/gsc-core.c: In function 'gsc_probe':
drivers/media/platform/exynos-gsc/gsc-core.c:1078:34: error: array subscript is above array bounds [-Werror=array-bounds]

This is harmless because the driver will never be used without CONFIG_OF,
but it's better to avoid the warning anyway. Checking the return value
of of_alias_get_id() for an error condition is probably a good idea
anyway, and it makes sure the compiler can verify that we don't get
into that situation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 26a7ed9c1819 ("[media] exynos-gsc: remove an always false condition")
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index c595723f5031..c04973669a47 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1063,13 +1063,17 @@ static int gsc_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct gsc_driverdata *drv_data = gsc_get_drv_data(pdev);
 	struct device *dev = &pdev->dev;
-	int ret = 0;
+	int ret;
 
 	gsc = devm_kzalloc(dev, sizeof(struct gsc_dev), GFP_KERNEL);
 	if (!gsc)
 		return -ENOMEM;
 
-	gsc->id = of_alias_get_id(pdev->dev.of_node, "gsc");
+	ret = of_alias_get_id(pdev->dev.of_node, "gsc");
+	if (ret < 0)
+		return ret;
+
+	gsc->id = ret;
 	if (gsc->id >= drv_data->num_entities) {
 		dev_err(dev, "Invalid platform device id: %d\n", gsc->id);
 		return -EINVAL;
-- 
2.7.0

