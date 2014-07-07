Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:57783 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaGGQdG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jul 2014 12:33:06 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 4/9] s5p-jpeg: fix g_selection op
Date: Mon, 07 Jul 2014 18:32:05 +0200
Message-id: <1404750730-22996-5-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1404750730-22996-1-git-send-email-j.anaszewski@samsung.com>
References: <1404750730-22996-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_SEL_TGT_COMPOSE_DEFAULT switch case should select whole
available area of the image and V4L2_SEL_TGT_COMPOSE
should apply user settings.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 0854f37..09b59d3 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1505,21 +1505,23 @@ static int s5p_jpeg_g_selection(struct file *file, void *priv,
 	case V4L2_SEL_TGT_CROP:
 	case V4L2_SEL_TGT_CROP_BOUNDS:
 	case V4L2_SEL_TGT_CROP_DEFAULT:
-	case V4L2_SEL_TGT_COMPOSE:
 	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
 		s->r.width = ctx->out_q.w;
 		s->r.height = ctx->out_q.h;
+		s->r.left = 0;
+		s->r.top = 0;
 		break;
+	case V4L2_SEL_TGT_COMPOSE:
 	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
 	case V4L2_SEL_TGT_COMPOSE_PADDED:
-		s->r.width = ctx->cap_q.w;
-		s->r.height = ctx->cap_q.h;
+		s->r.width = ctx->crop_rect.width;
+		s->r.height =  ctx->crop_rect.height;
+		s->r.left = ctx->crop_rect.left;
+		s->r.top = ctx->crop_rect.top;
 		break;
 	default:
 		return -EINVAL;
 	}
-	s->r.left = 0;
-	s->r.top = 0;
 	return 0;
 }
 
-- 
1.7.9.5

