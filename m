Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54488 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab2DCIM6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2012 04:12:58 -0400
Received: by dake40 with SMTP id e40so3409301dak.11
        for <linux-media@vger.kernel.org>; Tue, 03 Apr 2012 01:12:58 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, sachin.kamat@linaro.org,
	mchehab@infradead.org, patches@linaro.org
Subject: [PATCH] [media] s5p-tv: Fix compiler warning in mixer_video.c file
Date: Tue,  3 Apr 2012 13:34:54 +0530
Message-Id: <1333440294-382-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following warning:

mixer_video.c:857:3: warning: format ‘%lx’ expects argument of type
‘long unsigned int’, but argument 5 has type ‘unsigned int’ [-Wformat]

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-tv/mixer_video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index f7ca5cc..bb33d7c 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -854,7 +854,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	for (i = 0; i < fmt->num_subframes; ++i) {
 		alloc_ctxs[i] = layer->mdev->alloc_ctx;
 		sizes[i] = PAGE_ALIGN(planes[i].sizeimage);
-		mxr_dbg(mdev, "size[%d] = %08lx\n", i, sizes[i]);
+		mxr_dbg(mdev, "size[%d] = %08x\n", i, sizes[i]);
 	}
 
 	if (*nbuffers == 0)
-- 
1.7.4.1

