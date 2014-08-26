Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44073 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbaHZVzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:18 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 06/35] [media] gsc-m2m: Remove an unused var.
Date: Tue, 26 Aug 2014 18:54:42 -0300
Message-Id: <1409090111-8290-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/exynos-gsc/gsc-m2m.c: In function 'gsc_m2m_reqbufs':
drivers/media/platform/exynos-gsc/gsc-m2m.c:365:20: warning: variable 'frame' s
et but not used [-Wunused-but-set-variable]
  struct gsc_frame *frame;
                    ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-m2m.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index e434f1f03d7b..74e1de637e8f 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -362,7 +362,6 @@ static int gsc_m2m_reqbufs(struct file *file, void *fh,
 {
 	struct gsc_ctx *ctx = fh_to_ctx(fh);
 	struct gsc_dev *gsc = ctx->gsc_dev;
-	struct gsc_frame *frame;
 	u32 max_cnt;
 
 	max_cnt = (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
@@ -376,8 +375,6 @@ static int gsc_m2m_reqbufs(struct file *file, void *fh,
 			gsc_ctx_state_lock_clear(GSC_DST_FMT, ctx);
 	}
 
-	frame = ctx_get_frame(ctx, reqbufs->type);
-
 	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
 }
 
-- 
1.9.3

