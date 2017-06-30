Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37967 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751659AbdF3OP5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 10:15:57 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/8] [media] s5p-jpeg: Correct WARN_ON statement for checking subsampling
Date: Fri, 30 Jun 2017 16:15:41 +0200
Message-Id: <1498832147-16316-3-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1498832147-16316-1-git-send-email-thierry.escande@collabora.com>
References: <1498832147-16316-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tony K Nadackal <tony.kn@samsung.com>

Corrects the WARN_ON statement for subsampling based on the
JPEG Hardware version.

Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
Acked-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 623508d..0d935f5 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -614,24 +614,26 @@ static inline struct s5p_jpeg_ctx *fh_to_ctx(struct v4l2_fh *fh)
 
 static int s5p_jpeg_to_user_subsampling(struct s5p_jpeg_ctx *ctx)
 {
-	WARN_ON(ctx->subsampling > 3);
-
 	switch (ctx->jpeg->variant->version) {
 	case SJPEG_S5P:
+		WARN_ON(ctx->subsampling > 3);
 		if (ctx->subsampling > 2)
 			return V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
 		return ctx->subsampling;
 	case SJPEG_EXYNOS3250:
 	case SJPEG_EXYNOS5420:
+		WARN_ON(ctx->subsampling > 6);
 		if (ctx->subsampling > 3)
 			return V4L2_JPEG_CHROMA_SUBSAMPLING_411;
 		return exynos3250_decoded_subsampling[ctx->subsampling];
 	case SJPEG_EXYNOS4:
 	case SJPEG_EXYNOS5433:
+		WARN_ON(ctx->subsampling > 3);
 		if (ctx->subsampling > 2)
 			return V4L2_JPEG_CHROMA_SUBSAMPLING_420;
 		return exynos4x12_decoded_subsampling[ctx->subsampling];
 	default:
+		WARN_ON(ctx->subsampling > 3);
 		return V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
 	}
 }
-- 
2.7.4
