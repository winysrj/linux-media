Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37979 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752001AbdF3OP6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 10:15:58 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/8] [media] s5p-jpeg: Split s5p_jpeg_parse_hdr()
Date: Fri, 30 Jun 2017 16:15:44 +0200
Message-Id: <1498832147-16316-6-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1498832147-16316-1-git-send-email-thierry.escande@collabora.com>
References: <1498832147-16316-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch moves the subsampling value decoding read from the jpeg
header into its own function. This new function is called
s5p_jpeg_subsampling_decode() and returns true if it successfully
decodes the subsampling value, false otherwise.

Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
Acked-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 42 ++++++++++++++++-------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 1769744..0783809 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1096,6 +1096,29 @@ static void skip(struct s5p_jpeg_buffer *buf, long len)
 		get_byte(buf);
 }
 
+static bool s5p_jpeg_subsampling_decode(struct s5p_jpeg_ctx *ctx,
+					unsigned int subsampling)
+{
+	switch (subsampling) {
+	case 0x11:
+		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_444;
+		break;
+	case 0x21:
+		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_422;
+		break;
+	case 0x22:
+		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_420;
+		break;
+	case 0x33:
+		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
 static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 			       unsigned long buffer, unsigned long size,
 			       struct s5p_jpeg_ctx *ctx)
@@ -1207,26 +1230,9 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 		}
 	}
 
-	if (notfound || !sos)
+	if (notfound || !sos || !s5p_jpeg_subsampling_decode(ctx, subsampling))
 		return false;
 
-	switch (subsampling) {
-	case 0x11:
-		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_444;
-		break;
-	case 0x21:
-		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_422;
-		break;
-	case 0x22:
-		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_420;
-		break;
-	case 0x33:
-		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
-		break;
-	default:
-		return false;
-	}
-
 	result->w = width;
 	result->h = height;
 	result->sos = sos;
-- 
2.7.4
