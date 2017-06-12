Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60244 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753189AbdFLRNd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 13:13:33 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] [media] s5p-jpeg: Reset the Codec before doing a soft reset
Date: Mon, 12 Jun 2017 19:13:20 +0200
Message-Id: <1497287605-20074-2-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1497287605-20074-1-git-send-email-thierry.escande@collabora.com>
References: <1497287605-20074-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Abhilash Kesavan <a.kesavan@samsung.com>

This patch resets the encoding and decoding register bits before doing a
soft reset.

Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
index a1d823a..9ad8f6d 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
@@ -21,6 +21,10 @@ void exynos4_jpeg_sw_reset(void __iomem *base)
 	unsigned int reg;
 
 	reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
+	writel(reg & ~(EXYNOS4_DEC_MODE | EXYNOS4_ENC_MODE),
+	       base + EXYNOS4_JPEG_CNTL_REG);
+
+	reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
 	writel(reg & ~EXYNOS4_SOFT_RESET_HI, base + EXYNOS4_JPEG_CNTL_REG);
 
 	udelay(100);
-- 
2.7.4
