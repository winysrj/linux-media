Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:40701 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbcA3TEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2016 14:04:16 -0500
From: ayaka <ayaka@soulik.info>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@osg.samsung.com,
	linux-arm-kernel@lists.infradead.org, ayaka <ayaka@soulik.info>
Subject: [PATCH 1/4] [media] s5p-mfc: Add handling of buffer freeing reqbufs request
Date: Sun, 31 Jan 2016 02:53:34 +0800
Message-Id: <1454180017-29071-2-git-send-email-ayaka@soulik.info>
In-Reply-To: <1454180017-29071-1-git-send-email-ayaka@soulik.info>
References: <1454180017-29071-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The encoder forget the work to call hardware to release its buffers.
This patch comes from chromium project. I just change its code
style.

Signed-off-by: ayaka <ayaka@soulik.info>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index e65993f..7c9e5f5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1144,7 +1144,10 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 		return -EINVAL;
 	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		if (reqbufs->count == 0) {
+			mfc_debug(2, "Freeing buffers\n");
 			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			s5p_mfc_hw_call_void(dev->mfc_ops, release_codec_buffers,
+					ctx);
 			ctx->capture_state = QUEUE_FREE;
 			return ret;
 		}
-- 
2.5.0

