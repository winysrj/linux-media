Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:49627 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbaKNWJx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 17:09:53 -0500
Received: by mail-ig0-f172.google.com with SMTP id a13so477188igq.17
        for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 14:09:53 -0800 (PST)
Date: Fri, 14 Nov 2014 14:09:50 -0800
From: Dmitry Torokhov <dtor@chromium.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Wolfram Sang <wsa@the-dreams.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] exynos4-is: fix error handling of
 irq_of_parse_and_map
Message-ID: <20141114220950.GA34576@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return value of irq_of_parse_and_map() is unsigned int, with 0
indicating failure, so testing for negative result never works.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---

Not tested, found by casual code inspection.

 drivers/media/platform/exynos4-is/fimc-is.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 94c6b47..0fdca86 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -814,9 +814,9 @@ static int fimc_is_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	is->irq = irq_of_parse_and_map(dev->of_node, 0);
-	if (is->irq < 0) {
+	if (!is->irq) {
 		dev_err(dev, "no irq found\n");
-		return is->irq;
+		return -EINVAL;
 	}
 
 	ret = fimc_is_get_clocks(is);
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry
