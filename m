Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:49274 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3EMFtP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 01:49:15 -0400
Received: by mail-bk0-f47.google.com with SMTP id jg9so2213742bkc.34
        for <linux-media@vger.kernel.org>; Sun, 12 May 2013 22:49:14 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 May 2013 13:49:13 +0800
Message-ID: <CAPgLHd80d_pLtTbDQLEAMiLzfoF6AZ5fpjxtxqAoAZ1myNKw+w@mail.gmail.com>
Subject: [PATCH] [media] s5p-tv: fix error return code in mxr_acquire_video()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kyungmin.park@samsung.com, t.stanislaws@samsung.com,
	mchehab@redhat.com
Cc: yongjun_wei@trendmicro.com.cn,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code in the vb2_dma_contig_init_ctx()
error handling case instead of 0, as done elsewhere in this function.
Also vb2_dma_contig_init_ctx() return ERR_PTR() in case of error and
never return NULL, so use IS_ERR() replace IS_ERR_OR_NULL().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/s5p-tv/mixer_video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index ef0efdf..641b1f0 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -81,8 +81,9 @@ int mxr_acquire_video(struct mxr_device *mdev,
 	}
 
 	mdev->alloc_ctx = vb2_dma_contig_init_ctx(mdev->dev);
-	if (IS_ERR_OR_NULL(mdev->alloc_ctx)) {
+	if (IS_ERR(mdev->alloc_ctx)) {
 		mxr_err(mdev, "could not acquire vb2 allocator\n");
+		ret = PTR_ERR(mdev->alloc_ctx);
 		goto fail_v4l2_dev;
 	}
 

