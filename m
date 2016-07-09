Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51541 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088AbcGIHdI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jul 2016 03:33:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: tiffany.lin@mediatek.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] mtk-vcodec: fix compiler warning
Date: Sat,  9 Jul 2016 09:32:58 +0200
Message-Id: <1468049578-10039-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468049578-10039-1-git-send-email-hverkuil@xs4all.nl>
References: <1468049578-10039-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

mtk-vcodec/venc_vpu_if.c:40:30: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  struct venc_vpu_inst *vpu = (struct venc_vpu_inst *)msg->venc_inst;
                              ^

Note: venc_inst is u64.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/mtk-vcodec/venc_vpu_if.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mtk-vcodec/venc_vpu_if.c b/drivers/media/platform/mtk-vcodec/venc_vpu_if.c
index b92c6d2..a01c759 100644
--- a/drivers/media/platform/mtk-vcodec/venc_vpu_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc_vpu_if.c
@@ -37,7 +37,8 @@ static void handle_enc_encode_msg(struct venc_vpu_inst *vpu, void *data)
 static void vpu_enc_ipi_handler(void *data, unsigned int len, void *priv)
 {
 	struct venc_vpu_ipi_msg_common *msg = data;
-	struct venc_vpu_inst *vpu = (struct venc_vpu_inst *)msg->venc_inst;
+	struct venc_vpu_inst *vpu =
+		(struct venc_vpu_inst *)(unsigned long)msg->venc_inst;
 
 	mtk_vcodec_debug(vpu, "msg_id %x inst %p status %d",
 			 msg->msg_id, vpu, msg->status);
-- 
2.8.1

