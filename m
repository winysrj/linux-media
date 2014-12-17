Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:20780 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaLQG3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Dec 2014 01:29:34 -0500
From: Tony K Nadackal <tony.kn@samsung.com>
To: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Cc: mchehab@osg.samsung.com, j.anaszewski@samsung.com,
	kgene@kernel.org, k.debski@samsung.com, s.nawrocki@samsung.com,
	bhushan.r@samsung.com, Tony K Nadackal <tony.kn@samsung.com>
Subject: [PATCH] [media] s5p-jpeg: Clear JPEG_CODEC_ON bits in sw reset function
Date: Wed, 17 Dec 2014 11:52:19 +0530
Message-id: <1418797339-27877-1-git-send-email-tony.kn@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bits EXYNOS4_DEC_MODE and EXYNOS4_ENC_MODE do not get cleared
on software reset. These bits need to be cleared explicitly.

Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
---
This patch is created and tested on top of linux-next-20141210.
It can be cleanly applied on media-next and kgene/for-next.


 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
index ab6d6f43..e53f13a 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
@@ -21,6 +21,10 @@ void exynos4_jpeg_sw_reset(void __iomem *base)
 	unsigned int reg;
 
 	reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
+	writel(reg & ~(EXYNOS4_DEC_MODE | EXYNOS4_ENC_MODE),
+				base + EXYNOS4_JPEG_CNTL_REG);
+
+	reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
 	writel(reg & ~EXYNOS4_SOFT_RESET_HI, base + EXYNOS4_JPEG_CNTL_REG);
 
 	udelay(100);
-- 
2.2.0

