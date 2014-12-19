Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:18010 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaLSHpU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 02:45:20 -0500
From: Tony K Nadackal <tony.kn@samsung.com>
To: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: mchehab@osg.samsung.com, j.anaszewski@samsung.com,
	kgene@kernel.org, k.debski@samsung.com, s.nawrocki@samsung.com,
	robh+dt@kernel.org, mark.rutland@arm.com, bhushan.r@samsung.com,
	Tony K Nadackal <tony.kn@samsung.com>
Subject: [PATCH v2 1/2] [media] s5p-jpeg: Fix modification sequence of
 interrupt enable register
Date: Fri, 19 Dec 2014 13:07:59 +0530
Message-id: <1418974680-5837-2-git-send-email-tony.kn@samsung.com>
In-reply-to: <1418974680-5837-1-git-send-email-tony.kn@samsung.com>
References: <1418974680-5837-1-git-send-email-tony.kn@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the bug in modifying the interrupt enable register.

Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
index e53f13a..a61ff7e 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
@@ -155,7 +155,10 @@ void exynos4_jpeg_set_enc_out_fmt(void __iomem *base, unsigned int out_fmt)
 
 void exynos4_jpeg_set_interrupt(void __iomem *base)
 {
-	writel(EXYNOS4_INT_EN_ALL, base + EXYNOS4_INT_EN_REG);
+	unsigned int reg;
+
+	reg = readl(base + EXYNOS4_INT_EN_REG) & ~EXYNOS4_INT_EN_MASK;
+	writel(reg | EXYNOS4_INT_EN_ALL, base + EXYNOS4_INT_EN_REG);
 }
 
 unsigned int exynos4_jpeg_get_int_status(void __iomem *base)
-- 
2.2.0

