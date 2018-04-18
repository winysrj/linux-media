Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34133 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751204AbeDRPGX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 11:06:23 -0400
From: Colin King <colin.king@canonical.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] include/media: fix missing | operator when setting cfg
Date: Wed, 18 Apr 2018 16:06:17 +0100
Message-Id: <20180418150617.22489-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The value from a readl is being masked with ITE_REG_CIOCAN_MASK however
this is not being used and cfg is being re-assigned.  I believe the
assignment operator should actually be instead the |= operator.

Detected by CoverityScan, CID#1467987 ("Unused value")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/exynos4-is/fimc-lite-reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.c b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
index f0acc550d065..16565a0b4bf1 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
@@ -254,7 +254,7 @@ void flite_hw_set_dma_window(struct fimc_lite *dev, struct flite_frame *f)
 	/* Maximum output pixel size */
 	cfg = readl(dev->regs + FLITE_REG_CIOCAN);
 	cfg &= ~FLITE_REG_CIOCAN_MASK;
-	cfg = (f->f_height << 16) | f->f_width;
+	cfg |= (f->f_height << 16) | f->f_width;
 	writel(cfg, dev->regs + FLITE_REG_CIOCAN);
 
 	/* DMA offsets */
-- 
2.17.0
