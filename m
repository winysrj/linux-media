Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37587 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3D2Jhx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 05:37:53 -0400
Received: by mail-pa0-f45.google.com with SMTP id lf10so3577365pab.18
        for <linux-media@vger.kernel.org>; Mon, 29 Apr 2013 02:37:52 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 3/3] [media] s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL in mixer_video.c
Date: Mon, 29 Apr 2013 14:54:59 +0530
Message-Id: <1367227499-543-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1367227499-543-1-git-send-email-sachin.kamat@linaro.org>
References: <1367227499-543-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vb2_dma_contig_init_ctx does not return NULL. Use IS_ERR()
instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/mixer_video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index ef0efdf..25319de 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -81,7 +81,7 @@ int mxr_acquire_video(struct mxr_device *mdev,
 	}
 
 	mdev->alloc_ctx = vb2_dma_contig_init_ctx(mdev->dev);
-	if (IS_ERR_OR_NULL(mdev->alloc_ctx)) {
+	if (IS_ERR(mdev->alloc_ctx)) {
 		mxr_err(mdev, "could not acquire vb2 allocator\n");
 		goto fail_v4l2_dev;
 	}
-- 
1.7.9.5

