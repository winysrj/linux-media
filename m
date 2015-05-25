Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37505 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbbEYPeh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 11:34:37 -0400
Received: by wifw1 with SMTP id w1so1296089wif.0
        for <linux-media@vger.kernel.org>; Mon, 25 May 2015 08:34:36 -0700 (PDT)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 3/3] media: davinci_vpfe: use monotonic timestamp
Date: Mon, 25 May 2015 16:34:29 +0100
Message-Id: <1432568069-11349-4-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1432568069-11349-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1432568069-11349-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

V4L2 drivers should use MONOTONIC timestamps instead of gettimeofday,
which is affected by daylight savings time.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 6744192..87048a1 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -470,7 +470,7 @@ void vpfe_video_process_buffer_complete(struct vpfe_video_device *video)
 {
 	struct vpfe_pipeline *pipe = &video->pipe;
 
-	do_gettimeofday(&video->cur_frm->vb.v4l2_buf.timestamp);
+	v4l2_get_timestamp(&video->cur_frm->vb.v4l2_buf.timestamp);
 	vb2_buffer_done(&video->cur_frm->vb, VB2_BUF_STATE_DONE);
 	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS)
 		video->cur_frm = video->next_frm;
@@ -1337,6 +1337,7 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 	q->ops = &video_qops;
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct vpfe_cap_buffer);
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 
 	ret = vb2_queue_init(q);
 	if (ret) {
-- 
2.1.4

