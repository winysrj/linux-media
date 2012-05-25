Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48997 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab2EYRjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 13:39:18 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so1530415dad.19
        for <linux-media@vger.kernel.org>; Fri, 25 May 2012 10:39:18 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 3/4] [media] s5p-fimc: Add missing static storage class in fimc-core.c file
Date: Fri, 25 May 2012 23:08:52 +0530
Message-Id: <1337967533-22240-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1337967533-22240-1-git-send-email-sachin.kamat@linaro.org>
References: <1337967533-22240-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warning:
drivers/media/video/s5p-fimc/fimc-core.c:466:5: warning: symbol 'fimc_set_color_effect' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index c2d621c..02c82c7 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -463,7 +463,7 @@ void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 	    f->fmt->color, f->dma_offset.y_h, f->dma_offset.y_v);
 }
 
-int fimc_set_color_effect(struct fimc_ctx *ctx, enum v4l2_colorfx colorfx)
+static int fimc_set_color_effect(struct fimc_ctx *ctx, enum v4l2_colorfx colorfx)
 {
 	struct fimc_effect *effect = &ctx->effect;
 
-- 
1.7.5.4

