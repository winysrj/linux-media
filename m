Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57978 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdFBQDR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 12:03:17 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] [media] s5p-jpeg: Change sclk_jpeg to 166MHz for Exynos5250
Date: Fri,  2 Jun 2017 18:02:54 +0200
Message-Id: <1496419376-17099-8-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
References: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: henryhsu <henryhsu@chromium.org>

The default clock parent of jpeg on Exynos5250 is fin_pll, which is
24MHz. We have to change the clock parent to CPLL, which is 333MHz,
and set sclk_jpeg to 166MHz.

Signed-off-by: Heng-Ruey Hsu <henryhsu@chromium.org>
Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 47 +++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 7a7acbc..430e925 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -969,6 +969,44 @@ static void exynos4_jpeg_parse_q_tbl(struct s5p_jpeg_ctx *ctx)
 	}
 }
 
+static int exynos4_jpeg_set_sclk_rate(struct s5p_jpeg *jpeg, struct clk *sclk)
+{
+	struct clk *mout_jpeg;
+	struct clk *sclk_cpll;
+	int ret;
+
+	mout_jpeg = clk_get(jpeg->dev, "mout_jpeg");
+	if (IS_ERR(mout_jpeg)) {
+		dev_err(jpeg->dev, "mout_jpeg clock not available: %ld\n",
+			PTR_ERR(mout_jpeg));
+		return PTR_ERR(mout_jpeg);
+	}
+
+	sclk_cpll = clk_get(jpeg->dev, "sclk_cpll");
+	if (IS_ERR(sclk_cpll)) {
+		dev_err(jpeg->dev, "sclk_cpll clock not available: %ld\n",
+			PTR_ERR(sclk_cpll));
+		clk_put(mout_jpeg);
+		return PTR_ERR(sclk_cpll);
+	}
+
+	ret = clk_set_parent(mout_jpeg, sclk_cpll);
+	clk_put(sclk_cpll);
+	clk_put(mout_jpeg);
+	if (ret) {
+		dev_err(jpeg->dev, "clk_set_parent failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_set_rate(sclk, 166500 * 1000);
+	if (ret) {
+		dev_err(jpeg->dev, "clk_set_rate failed: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 #if defined(CONFIG_EXYNOS_IOMMU) && defined(CONFIG_ARM_DMA_USE_IOMMU)
 static int jpeg_iommu_init(struct platform_device *pdev)
 {
@@ -2974,6 +3012,15 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 				jpeg->variant->clk_names[i]);
 			return PTR_ERR(jpeg->clocks[i]);
 		}
+
+		if (jpeg->variant->version == SJPEG_EXYNOS4 &&
+		    !strncmp(jpeg->variant->clk_names[i],
+			     "sclk", strlen("sclk"))) {
+			ret = exynos4_jpeg_set_sclk_rate(jpeg,
+							 jpeg->clocks[i]);
+			if (ret)
+				return ret;
+		}
 	}
 
 	/* v4l2 device */
-- 
2.7.4
