Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:48725 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3IKOKZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 10:10:25 -0400
Received: by mail-bk0-f50.google.com with SMTP id mz11so3582475bkb.37
        for <linux-media@vger.kernel.org>; Wed, 11 Sep 2013 07:10:24 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 11 Sep 2013 22:10:24 +0800
Message-ID: <CAPgLHd9fXJHqn=c50XY84xdmxC5FhAFqJ3Z5yEZReoOgLRPHbw@mail.gmail.com>
Subject: [PATCH] [media] v4l: vsp1: fix error return code in vsp1_video_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: m.chehab@samsung.com, laurent.pinchart+renesas@ideasonboard.com,
	sakari.ailus@iki.fi
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/vsp1/vsp1_video.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 714c53e..4b0ac07 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -1026,8 +1026,10 @@ int vsp1_video_init(struct vsp1_video *video, struct vsp1_entity *rwpf)
 
 	/* ... and the buffers queue... */
 	video->alloc_ctx = vb2_dma_contig_init_ctx(video->vsp1->dev);
-	if (IS_ERR(video->alloc_ctx))
+	if (IS_ERR(video->alloc_ctx)) {
+		ret = PTR_ERR(video->alloc_ctx);
 		goto error;
+	}
 
 	video->queue.type = video->type;
 	video->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;

