Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:9867 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaIOGrv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 02:47:51 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NBX00FI2K7QW590@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 15:47:50 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH 02/17] [media] s5p-mfc: Fix REQBUFS(0) for encoder.
Date: Mon, 15 Sep 2014 12:12:57 +0530
Message-id: <1410763393-12183-3-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

Handle REQBUFS(0) for CAPTURE queue as well. Also use the proper queue to call
it on for OUTPUT.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index ecd2bd1..cd1b2a2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1166,6 +1166,11 @@ static int vidioc_reqbufs(struct file *file, void *priv,
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
@@ -1187,6 +1192,14 @@ static int vidioc_reqbufs(struct file *file, void *priv,
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
1.7.3.rc2

