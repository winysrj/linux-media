Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:17799 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaHAJPd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 05:15:33 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9M00E7LF1VQNA0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Aug 2014 18:15:31 +0900 (KST)
From: panpan liu <panpan1.liu@samsung.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH] media: s5p_mfc_dec: delete the redundant code
Date: Fri, 01 Aug 2014 17:15:14 +0800
Message-id: <1406884515-3250-1-git-send-email-panpan1.liu@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Because the api s5p_mfc_queue_setup has already realized the same function

Signed-off-by: panpan liu <panpan1.liu@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c

--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -544,14 +544,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			mfc_err("vb2_reqbufs on capture failed\n");
 			return ret;
 		}
-		if (reqbufs->count < ctx->pb_count) {
-			mfc_err("Not enough buffers allocated\n");
-			reqbufs->count = 0;
-			s5p_mfc_clock_on();
-			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
-			s5p_mfc_clock_off();
-			return -ENOMEM;
-		}
+
 		ctx->total_dpb_count = reqbufs->count;
 		ret = s5p_mfc_hw_call(dev->mfc_ops, alloc_codec_buffers, ctx);
 		if (ret) {
--
1.7.9.5

