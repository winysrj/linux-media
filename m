Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:58449 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbcEGFOt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 May 2016 01:14:49 -0400
From: ayaka <ayaka@soulik.info>
To: linux-kernel@vger.kernel.org
Cc: m.szyprowski@samsung.com, nicolas.dufresne@collabora.com,
	shuahkh@osg.samsung.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, kyungmin.park@samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	ayaka <ayaka@soulik.info>
Subject: [PATCH 1/3] [media] s5p-mfc: Add handling of buffer freeing reqbufs request
Date: Sat,  7 May 2016 13:05:24 +0800
Message-Id: <1462597526-31559-2-git-send-email-ayaka@soulik.info>
In-Reply-To: <1462597526-31559-1-git-send-email-ayaka@soulik.info>
References: <1462597526-31559-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The encoder forget the work to call hardware to release its buffers.
This patch came from chromium project. I just change its code
style and make the API match with new kernel.

Signed-off-by: ayaka <ayaka@soulik.info>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 034b5c1..a66a9f9 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1144,7 +1144,10 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 		return -EINVAL;
 	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		if (reqbufs->count == 0) {
+			mfc_debug(2, "Freeing buffers\n");
 			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers,
+					ctx);
 			ctx->capture_state = QUEUE_FREE;
 			return ret;
 		}
-- 
2.5.5

