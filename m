Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59896 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752244AbdHHL1T (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 07:27:19 -0400
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
Subject: [PATCH 2/5] media: platform: s5p-jpeg: disable encoder/decoder in
 exynos4-like hardware after use
Date: Tue, 08 Aug 2017 13:27:05 +0200
Message-id: <1502191628-11958-2-git-send-email-andrzej.p@samsung.com>
In-reply-to: <1502191628-11958-1-git-send-email-andrzej.p@samsung.com>
References: <1502191352-11595-1-git-send-email-andrzej.p@samsung.com>
 <1502191628-11958-1-git-send-email-andrzej.p@samsung.com>
 <CGME20170808112715eucas1p263e17ba53577e0c4b46cc43bf8376db3@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clearing the bits turns off the encoder/decoder. If the hardware
is not turned off after use, at subsequent uses it does not
work in a stable manner, resulting in incorrect interrupt status
value being read and e.g. erroneous read of compressed bitstream size.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c       | 2 ++
 drivers/media/platform/s5p-jpeg/jpeg-core.h       | 1 +
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c | 5 ++++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index e276bd5..492fab1 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2713,6 +2713,8 @@ static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
 	if (jpeg->variant->version == SJPEG_EXYNOS4)
 		curr_ctx->subsampling = exynos4_jpeg_get_frame_fmt(jpeg->regs);
 
+	exynos4_jpeg_set_enc_dec_mode(jpeg->regs, S5P_JPEG_DISABLE);
+
 	spin_unlock(&jpeg->slock);
 
 	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index 4492a35..36edf92 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -63,6 +63,7 @@
 
 #define S5P_JPEG_ENCODE		0
 #define S5P_JPEG_DECODE		1
+#define S5P_JPEG_DISABLE	-1
 
 #define FMT_TYPE_OUTPUT		0
 #define FMT_TYPE_CAPTURE	1
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
index a1d823a..c784033 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
@@ -38,10 +38,13 @@ void exynos4_jpeg_set_enc_dec_mode(void __iomem *base, unsigned int mode)
 		writel((reg & EXYNOS4_ENC_DEC_MODE_MASK) |
 					EXYNOS4_DEC_MODE,
 			base + EXYNOS4_JPEG_CNTL_REG);
-	} else {/* encode */
+	} else if (mode == S5P_JPEG_ENCODE) {/* encode */
 		writel((reg & EXYNOS4_ENC_DEC_MODE_MASK) |
 					EXYNOS4_ENC_MODE,
 			base + EXYNOS4_JPEG_CNTL_REG);
+	} else { /* disable both */
+		writel(reg & EXYNOS4_ENC_DEC_MODE_MASK,
+			base + EXYNOS4_JPEG_CNTL_REG);
 	}
 }
 
-- 
1.9.1
