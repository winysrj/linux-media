Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:34049 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbaDGNQu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 09:16:50 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3N00DE4WW103C0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Apr 2014 22:16:49 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 5/8] [media] s5p-jpeg: g_selection callback should always
 succeed
Date: Mon, 07 Apr 2014 15:16:10 +0200
Message-id: <1396876573-15811-5-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1396876573-15811-1-git-send-email-j.anaszewski@samsung.com>
References: <1396876573-15811-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove erroneous guard preventing successful execution of
g_selection callback in case the driver variant is different
from SJPEG_S5P.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 913a027..8a15c4a 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1177,8 +1177,7 @@ static int s5p_jpeg_g_selection(struct file *file, void *priv,
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
-	    s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
-	    ctx->jpeg->variant->version != SJPEG_S5P)
+	    s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
 	/* For JPEG blob active == default == bounds */
-- 
1.7.9.5

