Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:64617 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbaDGNQm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 09:16:42 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3N00JPVWVLO0C0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Apr 2014 22:16:33 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/8] [media] s5p-jpeg: Perform fourcc downgrade only for
 Exynos4x12 SoCs
Date: Mon, 07 Apr 2014 15:16:07 +0200
Message-id: <1396876573-15811-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1396876573-15811-1-git-send-email-j.anaszewski@samsung.com>
References: <1396876573-15811-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the driver variant check from "is not S5PC210"
to "is Exynos4" while checking whether YUV format needs
to be downgraded in order to prevent upsampling which
is not supported by Exynos4 SoCs family.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 9b0102d..c675c90 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1070,7 +1070,7 @@ static int s5p_jpeg_try_fmt_vid_cap(struct file *file, void *priv,
 	 * If this requirement is not met then downgrade the requested
 	 * capture format to the one with subsampling equal to the input jpeg.
 	 */
-	if ((ctx->jpeg->variant->version != SJPEG_S5P) &&
+	if ((ctx->jpeg->variant->version == SJPEG_EXYNOS4) &&
 	    (ctx->mode == S5P_JPEG_DECODE) &&
 	    (fmt->flags & SJPEG_FMT_NON_RGB) &&
 	    (fmt->subsampling < ctx->subsampling)) {
-- 
1.7.9.5

