Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55539 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab2EJGs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 02:48:28 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so1506042pbb.19
        for <linux-media@vger.kernel.org>; Wed, 09 May 2012 23:48:28 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, andrzej.p@samsung.com,
	kyungmin.park@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org
Subject: [PATCH] [media] s5p-jpeg: Make s5p_jpeg_g_selection function static
Date: Thu, 10 May 2012 12:08:40 +0530
Message-Id: <1336631920-3831-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Makes the function s5p_jpeg_g_selection static (detected by sparse).

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-jpeg/jpeg-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
index 5a49c30..f147cbb 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
@@ -813,7 +813,7 @@ static int s5p_jpeg_streamoff(struct file *file, void *priv,
 	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
 }
 
-int s5p_jpeg_g_selection(struct file *file, void *priv,
+static int s5p_jpeg_g_selection(struct file *file, void *priv,
 			 struct v4l2_selection *s)
 {
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-- 
1.7.4.1

