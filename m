Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44169 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 23/35] [media] mipi-csis: get rid of a warning
Date: Tue, 26 Aug 2014 18:54:59 -0300
Message-Id: <1409090111-8290-24-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/exynos4-is/mipi-csis.c: In function 's5pcsis_parse_dt':
drivers/media/platform/exynos4-is/mipi-csis.c:756:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
  if (state->index < 0 || state->index >= CSIS_MAX_ENTITIES)
  ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/exynos4-is/mipi-csis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index ae54ef5f535d..8be8897bc6cd 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -752,7 +752,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 	v4l2_of_parse_endpoint(node, &endpoint);
 
 	state->index = endpoint.base.port - FIMC_INPUT_MIPI_CSI2_0;
-	if (state->index < 0 || state->index >= CSIS_MAX_ENTITIES)
+	if (state->index >= CSIS_MAX_ENTITIES)
 		return -ENXIO;
 
 	/* Get MIPI CSI-2 bus configration from the endpoint node. */
-- 
1.9.3

