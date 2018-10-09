Return-path: <linux-media-owner@vger.kernel.org>
Received: from alexa-out-blr-01.qualcomm.com ([103.229.18.197]:6137 "EHLO
        alexa-out-blr-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726488AbeJIPOj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 11:14:39 -0400
From: Malathi Gottam <mgottam@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org, mgottam@codeaurora.org
Subject: [PATCH] media: venus: add support for USERPTR to queue
Date: Tue,  9 Oct 2018 13:22:37 +0530
Message-Id: <1539071557-1500-1-git-send-email-mgottam@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add USERPTR to queue access methods by adding this
support to io_modes on both the planes.

Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
---
 drivers/media/platform/qcom/venus/venc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 754c19a..b86994c 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1096,7 +1096,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	int ret;
 
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->ops = &venc_vb2_ops;
 	src_vq->mem_ops = &vb2_dma_sg_memops;
@@ -1112,7 +1112,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 		return ret;
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->ops = &venc_vb2_ops;
 	dst_vq->mem_ops = &vb2_dma_sg_memops;
-- 
1.9.1
