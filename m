Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:61023 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaJULHa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 07:07:30 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	kiran@chromium.org, arunkk.samsung@gmail.com
Subject: [PATCH v3 02/13] [media] s5p-mfc: Fix REQBUFS(0) for encoder.
Date: Tue, 21 Oct 2014 16:36:56 +0530
Message-Id: <1413889627-8431-3-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
References: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

Handle REQBUFS(0) for CAPTURE queue as well. Also use the proper queue to call
it on for OUTPUT.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 4816f31..6a1c890 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1147,6 +1147,11 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 		(reqbufs->memory != V4L2_MEMORY_USERPTR))
 		return -EINVAL;
 	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		if (reqbufs->count == 0) {
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			ctx->capture_state = QUEUE_FREE;
+			return ret;
+		}
 		if (ctx->capture_state != QUEUE_FREE) {
 			mfc_err("invalid capture state: %d\n",
 							ctx->capture_state);
@@ -1168,6 +1173,14 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			return -ENOMEM;
 		}
 	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		if (reqbufs->count == 0) {
+			mfc_debug(2, "Freeing buffers\n");
+			ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
+			s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers,
+					ctx);
+			ctx->output_state = QUEUE_FREE;
+			return ret;
+		}
 		if (ctx->output_state != QUEUE_FREE) {
 			mfc_err("invalid output state: %d\n",
 							ctx->output_state);
-- 
1.7.9.5

