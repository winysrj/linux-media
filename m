Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58454 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752666AbdF0QJJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 12:09:09 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/8] [media] s5p-jpeg: Decode 4:1:1 chroma subsampling format
Date: Tue, 27 Jun 2017 18:08:52 +0200
Message-Id: <1498579734-1594-7-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1498579734-1594-1-git-send-email-thierry.escande@collabora.com>
References: <1498579734-1594-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tony K Nadackal <tony.kn@samsung.com>

This patch adds support for decoding 4:1:1 chroma subsampling in the
jpeg header parsing function.

Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 0783809..cca0fb8 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1099,6 +1099,8 @@ static void skip(struct s5p_jpeg_buffer *buf, long len)
 static bool s5p_jpeg_subsampling_decode(struct s5p_jpeg_ctx *ctx,
 					unsigned int subsampling)
 {
+	unsigned int version;
+
 	switch (subsampling) {
 	case 0x11:
 		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_444;
@@ -1112,6 +1114,19 @@ static bool s5p_jpeg_subsampling_decode(struct s5p_jpeg_ctx *ctx,
 	case 0x33:
 		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
 		break;
+	case 0x41:
+		/*
+		 * 4:1:1 subsampling only supported by 3250, 5420, and 5433
+		 * variants
+		 */
+		version = ctx->jpeg->variant->version;
+		if (version != SJPEG_EXYNOS3250 &&
+		    version != SJPEG_EXYNOS5420 &&
+		    version != SJPEG_EXYNOS5433)
+			return false;
+
+		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_411;
+		break;
 	default:
 		return false;
 	}
-- 
2.7.4
