Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:65173 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbCEN4e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2015 08:56:34 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKQ001B3S28G3B0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Mar 2015 22:56:32 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-jpeg: Initialize jpeg_addr fields to zero
Date: Thu, 05 Mar 2015 14:56:25 +0100
Message-id: <1425563785-20650-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

JPEG codecs on Exynos4 and Exynos3250 SoCs utilize different number
of planes for storing the raw image data, depending on the format
of the image being processed. For the unused planes a random data
was being written to the related registers. Regardless of the fact
that this seemed not to be harmful, fix the issue for clarity reasons.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Reported-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 12f7452..fb97c4c 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1842,7 +1842,7 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 	struct s5p_jpeg *jpeg = ctx->jpeg;
 	struct s5p_jpeg_fmt *fmt;
 	struct vb2_buffer *vb;
-	struct s5p_jpeg_addr jpeg_addr;
+	struct s5p_jpeg_addr jpeg_addr = {};
 	u32 pix_size, padding_bytes = 0;
 
 	pix_size = ctx->cap_q.w * ctx->cap_q.h;
@@ -1943,7 +1943,7 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 	struct s5p_jpeg *jpeg = ctx->jpeg;
 	struct s5p_jpeg_fmt *fmt;
 	struct vb2_buffer *vb;
-	struct s5p_jpeg_addr jpeg_addr;
+	struct s5p_jpeg_addr jpeg_addr = {};
 	u32 pix_size;
 
 	pix_size = ctx->cap_q.w * ctx->cap_q.h;
-- 
1.7.9.5

