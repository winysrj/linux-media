Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45810 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3LROuG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 09:50:06 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY0001S8BVINY70@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Dec 2013 23:50:06 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v3 5/8] s5p-jpeg: Allow for wider JPEG subsampling scope for
 Exynos4x12 encoder
Date: Wed, 18 Dec 2013 15:49:32 +0100
Message-id: <1387378175-23399-6-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1387378175-23399-1-git-send-email-j.anaszewski@samsung.com>
References: <1387378175-23399-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exynos4x12 supports wider scope of subsampling modes than
S5PC210. Adjust corresponding mask accordingly.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 377dd31..9195252 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1249,7 +1249,8 @@ static int s5p_jpeg_controls_create(struct s5p_jpeg_ctx *ctx)
 		v4l2_ctrl_new_std(&ctx->ctrl_handler, &s5p_jpeg_ctrl_ops,
 				  V4L2_CID_JPEG_RESTART_INTERVAL,
 				  0, 3, 0xffff, 0);
-		mask = ~0x06; /* 422, 420 */
+		if (ctx->jpeg->variant->version == SJPEG_S5P)
+			mask = ~0x06; /* 422, 420 */
 	}
 
 	ctrl = v4l2_ctrl_new_std_menu(&ctx->ctrl_handler, &s5p_jpeg_ctrl_ops,
-- 
1.7.9.5

