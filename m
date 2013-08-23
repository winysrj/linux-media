Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45441 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab3HWJhV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 05:37:21 -0400
Date: Fri, 23 Aug 2013 12:36:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] exynos4-is: print error message on timeout
Message-ID: <20130823093656.GK31293@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a stray '!' character so the error message never gets printed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker stuff.  Not tested.

diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.c b/drivers/media/platform/exynos4-is/fimc-is-regs.c
index 63c68ec..42f2925 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-regs.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.c
@@ -236,7 +236,7 @@ int fimc_is_itf_mode_change(struct fimc_is *is)
 	fimc_is_hw_change_mode(is);
 	ret = fimc_is_wait_event(is, IS_ST_CHANGE_MODE, 1,
 				FIMC_IS_CONFIG_TIMEOUT);
-	if (!ret < 0)
+	if (ret < 0)
 		dev_err(&is->pdev->dev, "%s(): mode change (%d) timeout\n",
 			__func__, is->config_index);
 	return ret;
