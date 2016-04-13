Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbcDMTdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2016 15:33:47 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Subject: [PATCH] [media] exynos-gsc: remove an always false condition
Date: Wed, 13 Apr 2016 16:32:36 -0300
Message-Id: <26a7ed9c18193dc7a3dfba33e3c711822f4bdd29.1460575950.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
drivers/media/platform/exynos-gsc/gsc-core.c:1073 gsc_probe() warn: impossible condition '(gsc->id < 0) => (0-65535 < 0)'
drivers/media/platform/exynos-gsc/gsc-core.c: In function 'gsc_probe':
drivers/media/platform/exynos-gsc/gsc-core.c:1073:51: warning: comparison is always false due to limited range of data type [-Wtype-limits]
  if (gsc->id >= drv_data->num_entities || gsc->id < 0) {
                                                   ^

gsc->id is an u16, so it can never be a negative number. So,
remove the always false condition.

Fixes: c1ac057173ba "[media] exynos-gsc: remove non-device-tree init code"
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 032a423fb892..c595723f5031 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1070,7 +1070,7 @@ static int gsc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	gsc->id = of_alias_get_id(pdev->dev.of_node, "gsc");
-	if (gsc->id >= drv_data->num_entities || gsc->id < 0) {
+	if (gsc->id >= drv_data->num_entities) {
 		dev_err(dev, "Invalid platform device id: %d\n", gsc->id);
 		return -EINVAL;
 	}
-- 
2.5.5

