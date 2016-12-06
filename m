Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36375 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751576AbcLFHnZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 02:43:25 -0500
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, kgene@kernel.org, krzk@kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media/platform/exynos4-is/fimc-is - Unmap region obtained by of_iomap
Date: Tue,  6 Dec 2016 13:12:51 +0530
Message-Id: <1481010171-6247-1-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <y>
References: <y>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Free memory mapping, if fimc_is_probe is not successful.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 32ca55f..10d98a5 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -818,12 +818,13 @@ static int fimc_is_probe(struct platform_device *pdev)
 	is->irq = irq_of_parse_and_map(dev->of_node, 0);
 	if (!is->irq) {
 		dev_err(dev, "no irq found\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_iounmap;
 	}
 
 	ret = fimc_is_get_clocks(is);
 	if (ret < 0)
-		return ret;
+		goto err_iounmap;
 
 	platform_set_drvdata(pdev, is);
 
@@ -877,6 +878,8 @@ err_irq:
 	free_irq(is->irq, is);
 err_clk:
 	fimc_is_put_clocks(is);
+err_iounmap:
+	iounmap(is->pmu_regs);
 	return ret;
 }
 
@@ -932,6 +935,7 @@ static int fimc_is_remove(struct platform_device *pdev)
 	fimc_is_unregister_subdevs(is);
 	vb2_dma_contig_clear_max_seg_size(dev);
 	fimc_is_put_clocks(is);
+	iounmap(is->pmu_regs);
 	fimc_is_debugfs_remove(is);
 	release_firmware(is->fw.f_w);
 	fimc_is_free_cpu_memory(is);
-- 
1.7.9.5

