Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:5299 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754011AbcE3Hwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2016 03:52:55 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <Tiffany.lin@mediatek.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH] vcodec: mediatek: Add g/s_selection support for V4L2 Encoder
Date: Mon, 30 May 2016 15:52:48 +0800
Message-ID: <1464594768-1993-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add g/s_selection support for MT8173

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   74 ++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index 6e72d73..23ef9a1 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -630,6 +630,77 @@ static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
 	return vidioc_try_fmt(f, fmt);
 }
 
+static int vidioc_venc_g_selection(struct file *file, void *priv,
+				     struct v4l2_selection *s)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	struct mtk_q_data *q_data;
+
+	/* crop means compose for output devices */
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE:
+		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+			mtk_v4l2_err("Invalid s->type = %d", s->type);
+			return -EINVAL;
+		}
+		break;
+	default:
+		mtk_v4l2_err("Invalid s->target = %d", s->target);
+		return -EINVAL;
+	}
+
+	q_data = mtk_venc_get_q_data(ctx, s->type);
+	if (!q_data)
+		return -EINVAL;
+
+	s->r.top = 0;
+	s->r.left = 0;
+	s->r.width = q_data->visible_width;
+	s->r.height = q_data->visible_height;
+
+	return 0;
+}
+
+static int vidioc_venc_s_selection(struct file *file, void *priv,
+				     struct v4l2_selection *s)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	struct mtk_q_data *q_data;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE:
+		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+			mtk_v4l2_err("Invalid s->type = %d", s->type);
+			return -EINVAL;
+		}
+		break;
+	default:
+		mtk_v4l2_err("Invalid s->target = %d", s->target);
+		return -EINVAL;
+	}
+
+	q_data = mtk_venc_get_q_data(ctx, s->type);
+	if (!q_data)
+		return -EINVAL;
+
+	s->r.top = 0;
+	s->r.left = 0;
+	q_data->visible_width = s->r.width;
+	q_data->visible_height = s->r.height;
+
+	return 0;
+}
+
 static int vidioc_venc_qbuf(struct file *file, void *priv,
 			    struct v4l2_buffer *buf)
 {
@@ -688,6 +759,9 @@ const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
 
 	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
 	.vidioc_prepare_buf		= v4l2_m2m_ioctl_prepare_buf,
+
+	.vidioc_g_selection		= vidioc_venc_g_selection,
+	.vidioc_s_selection		= vidioc_venc_s_selection,
 };
 
 static int vb2ops_venc_queue_setup(struct vb2_queue *vq,
-- 
1.7.9.5

