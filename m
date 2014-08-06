Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:48444 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaHFBZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 21:25:51 -0400
From: Zhaowei Yuan <zhaowei.yuan@samsung.com>
To: linux-media@vger.kernel.org, k.debski@samsung.com,
	m.chehab@samsung.com, kyungmin.park@samsung.com,
	jtp.park@samsung.com
Cc: linux-samsung-soc@vger.kernel.org
Subject: [PATCH V3] media: s5p_mfc: Release ctx->ctx if failed to allocate
 ctx->shm
Date: Wed, 06 Aug 2014 09:22:08 +0800
Message-id: <1407288128-21465-1-git-send-email-zhaowei.yuan@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ctx->ctx should be released if the following allocation for ctx->shm
gets failed.

Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 58ec7bb..dc00aea 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -228,6 +228,7 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->shm);
 	if (ret) {
 		mfc_err("Failed to allocate shared memory buffer\n");
+		s5p_mfc_release_priv_buf(dev->mem_dev_l, &ctx->ctx);
 		return ret;
 	}

--
1.7.9.5

