Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:34610 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389AbaKEISD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 03:18:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 7/8] s5p-mfc: fix sparse error
Date: Wed,  5 Nov 2014 09:17:51 +0100
Message-Id: <1415175472-24203-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
References: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

s5p_mfc_enc.c:1178:25: error: incompatible types in conditional expression (different base types)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 9391b8e..e7240cb 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1175,7 +1175,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 		if (reqbufs->count == 0) {
 			mfc_debug(2, "Freeing buffers\n");
 			ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
-			s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers,
+			s5p_mfc_hw_call_void(dev->mfc_ops, release_codec_buffers,
 					ctx);
 			ctx->output_state = QUEUE_FREE;
 			return ret;
-- 
2.1.1

