Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23770 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab2D3QOr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 12:14:47 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3A006ZZVSGNE@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 17:14:40 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3A00FF8VSLG1@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 17:14:46 +0100 (BST)
Date: Mon, 30 Apr 2012 18:14:38 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 09/12] s5p-fimc: Make sure an interrupt is properly requested
In-reply-to: <1335802481-18153-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335802481-18153-10-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1335802481-18153-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use dev_name() for requesting an interrupt so we don't get an interrupt
requested with same name for multiple device instances.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 6573029..d59d8c1 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -841,7 +841,7 @@ static int fimc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, fimc);
 
 	ret = devm_request_irq(&pdev->dev, res->start, fimc_irq_handler,
-			       0, pdev->name, fimc);
+			       0, dev_name(&pdev->dev), fimc);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to install irq (%d)\n", ret);
 		goto err_clk;
-- 
1.7.10

