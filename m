Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38116 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752264AbdHHL1V (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 07:27:21 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 3/5] media: platform: s5p-jpeg: Clear JPEG_CODEC_ON bits in sw
 reset function
Date: Tue, 08 Aug 2017 13:27:06 +0200
Message-id: <1502191628-11958-3-git-send-email-andrzej.p@samsung.com>
In-reply-to: <1502191628-11958-1-git-send-email-andrzej.p@samsung.com>
References: <1502191352-11595-1-git-send-email-andrzej.p@samsung.com>
 <1502191628-11958-1-git-send-email-andrzej.p@samsung.com>
 <CGME20170808112716eucas1p27388118c826671edd88e79e68ceb7821@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tony K Nadackal <tony.kn@samsung.com>

Bits EXYNOS4_DEC_MODE and EXYNOS4_ENC_MODE do not get cleared
on software reset. These bits need to be cleared explicitly.

Even though the bits in question are already cleared in interrupt
service routine, the reset should also clear them in case e.g.
bootloader uses the codec and leaves it in a bad state.

Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
[Updated commit message]
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
index c784033..c72789b 100644
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
1.9.1
