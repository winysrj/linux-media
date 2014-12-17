Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:48359 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaLQH2r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Dec 2014 02:28:47 -0500
From: Tony K Nadackal <tony.kn@samsung.com>
To: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Cc: mchehab@osg.samsung.com, j.anaszewski@samsung.com,
	kgene@kernel.org, k.debski@samsung.com, s.nawrocki@samsung.com,
	bhushan.r@samsung.com, Tony K Nadackal <tony.kn@samsung.com>
Subject: [PATCH] [media] s5p-jpeg: Initialize cb and cr to zero.
Date: Wed, 17 Dec 2014 12:51:21 +0530
Message-id: <1418800881-7428-1-git-send-email-tony.kn@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To avoid garbage value written into image base address planes,
initialize cb and cr of structure s5p_jpeg_addr to zero.

Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
---
This patch is created and tested on top of linux-next-20141210.
It can be cleanly applied on media-next and kgene/for-next.

 drivers/media/platform/s5p-jpeg/jpeg-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 91bd3e6..54fa5d9 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1845,6 +1845,9 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 	struct s5p_jpeg_addr jpeg_addr;
 	u32 pix_size, padding_bytes = 0;
 
+	jpeg_addr.cb = 0;
+	jpeg_addr.cr = 0;
+
 	pix_size = ctx->cap_q.w * ctx->cap_q.h;
 
 	if (ctx->mode == S5P_JPEG_ENCODE) {
-- 
2.2.0

