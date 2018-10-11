Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42541 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbeJKOMP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 10:12:15 -0400
Received: by mail-pl1-f195.google.com with SMTP id c8-v6so3713819plo.9
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2018 23:46:24 -0700 (PDT)
From: Alexandre Courbot <acourbot@chromium.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH] media: venus: support VB2_USERPTR IO mode
Date: Thu, 11 Oct 2018 15:46:08 +0900
Message-Id: <20181011064608.37435-1-acourbot@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The venus codec can work just fine with USERPTR buffers. Enable this
possibility.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 4 ++--
 drivers/media/platform/qcom/venus/venc.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 33320c5025313f..dfc2260e8d213a 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -984,7 +984,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	int ret;
 
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->ops = &vdec_vb2_ops;
 	src_vq->mem_ops = &vb2_dma_sg_memops;
@@ -999,7 +999,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 		return ret;
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->ops = &vdec_vb2_ops;
 	dst_vq->mem_ops = &vb2_dma_sg_memops;
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index d2805b5e28a1b2..71ca59a24991be 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1073,7 +1073,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	int ret;
 
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->ops = &venc_vb2_ops;
 	src_vq->mem_ops = &vb2_dma_sg_memops;
@@ -1090,7 +1090,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 		return ret;
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->ops = &venc_vb2_ops;
 	dst_vq->mem_ops = &vb2_dma_sg_memops;
-- 
2.19.0.605.g01d371f741-goog
