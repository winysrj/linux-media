Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:26238 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752319AbcHODQQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 23:16:16 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <Tiffany.lin@mediatek.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH for v4.8] vcodec:mediatek: Add timestamp and timecode copy for V4L2 Encoder
Date: Mon, 15 Aug 2016 11:15:44 +0800
Message-ID: <1471230944-24227-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add copying timestamp and timecode from src buffer to dst buffer

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   23 ++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index cd36c9e..7bef7ba 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -934,7 +934,8 @@ static int mtk_venc_encode_header(void *priv)
 {
 	struct mtk_vcodec_ctx *ctx = priv;
 	int ret;
-	struct vb2_buffer *dst_buf;
+	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *dst_vb2_v4l2, *src_vb2_v4l2;
 	struct mtk_vcodec_mem bs_buf;
 	struct venc_done_result enc_result;
 
@@ -967,6 +968,15 @@ static int mtk_venc_encode_header(void *priv)
 		mtk_v4l2_err("venc_if_encode failed=%d", ret);
 		return -EINVAL;
 	}
+	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	if (src_buf) {
+		src_vb2_v4l2 = to_vb2_v4l2_buffer(src_buf);
+		dst_vb2_v4l2 = to_vb2_v4l2_buffer(dst_buf);
+		dst_buf->timestamp = src_buf->timestamp;
+		dst_vb2_v4l2->timecode = src_vb2_v4l2->timecode;
+	} else {
+		mtk_v4l2_err("No timestamp for the header buffer.");
+	}
 
 	ctx->state = MTK_STATE_HEADER;
 	dst_buf->planes[0].bytesused = enc_result.bs_size;
@@ -1059,7 +1069,7 @@ static void mtk_venc_worker(struct work_struct *work)
 	struct mtk_vcodec_mem bs_buf;
 	struct venc_done_result enc_result;
 	int ret, i;
-	struct vb2_v4l2_buffer *vb2_v4l2;
+	struct vb2_v4l2_buffer *dst_vb2_v4l2, *src_vb2_v4l2;
 
 	/* check dst_buf, dst_buf may be removed in device_run
 	 * to stored encdoe header so we need check dst_buf and
@@ -1099,9 +1109,14 @@ static void mtk_venc_worker(struct work_struct *work)
 	ret = venc_if_encode(ctx, VENC_START_OPT_ENCODE_FRAME,
 			     &frm_buf, &bs_buf, &enc_result);
 
-	vb2_v4l2 = container_of(dst_buf, struct vb2_v4l2_buffer, vb2_buf);
+	src_vb2_v4l2 = to_vb2_v4l2_buffer(src_buf);
+	dst_vb2_v4l2 = to_vb2_v4l2_buffer(dst_buf);
+
+	dst_buf->timestamp = src_buf->timestamp;
+	dst_vb2_v4l2->timecode = src_vb2_v4l2->timecode;
+
 	if (enc_result.is_key_frm)
-		vb2_v4l2->flags |= V4L2_BUF_FLAG_KEYFRAME;
+		dst_vb2_v4l2->flags |= V4L2_BUF_FLAG_KEYFRAME;
 
 	if (ret) {
 		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
-- 
1.7.9.5

