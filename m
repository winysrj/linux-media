Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44071 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbaHZVzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:18 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 05/35] [media] gsc-core: Remove useless test
Date: Tue, 26 Aug 2014 18:54:41 -0300
Message-Id: <1409090111-8290-6-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/exynos-gsc/gsc-core.c: In function 'gsc_probe':
drivers/media/platform/exynos-gsc/gsc-core.c:1089:2: warning: comparison is alw
ays false due to limited range of data type [-Wtype-limits]
  if (gsc->id < 0 || gsc->id >= drv_data->num_entities) {
  ^

gsc->id is declared as u16, so it should always be a positive
value.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 9d0cc04d7ab7..8d8b3cff8212 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1086,7 +1086,7 @@ static int gsc_probe(struct platform_device *pdev)
 	else
 		gsc->id = pdev->id;
 
-	if (gsc->id < 0 || gsc->id >= drv_data->num_entities) {
+	if (gsc->id >= drv_data->num_entities) {
 		dev_err(dev, "Invalid platform device id: %d\n", gsc->id);
 		return -EINVAL;
 	}
-- 
1.9.3

