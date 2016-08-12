Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:35881 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752786AbcHLONi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 10:13:38 -0400
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
Subject: [PATCH v5] vcodec: mediatek: Add g/s_selection support for V4L2 Encoder
Date: Fri, 12 Aug 2016 22:13:25 +0800
Message-ID: <1471011205-17487-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add g/s_selection for MT8173 V4L2 Encoder.
Only output queue support g/s_selection to configure crop.
The top/left of active rectangle should always be (0,0).

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
v5:
- remove visible_height change to a separate patch
v4:
- do not return -ERANGE and just select a rectangle that works with the
  hardware and is closest to the requested rectangle
- refine v3 note about remove visible_height modification in s_fmt_out
v3:
- add v4l2_s_selection to check constraint flags
- remove visible_height modification in s_fmt_out, it will make v4l2-compliance
  test Cropping fail becuase visible_height larger than coded_height.
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   67 ++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index 3ed3f2d..0a895e0 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -631,6 +631,70 @@ static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
 	return vidioc_try_fmt(f, fmt);
 }
 
+static int vidioc_venc_g_selection(struct file *file, void *priv,
+				     struct v4l2_selection *s)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	struct mtk_q_data *q_data;
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return -EINVAL;
+
+	q_data = mtk_venc_get_q_data(ctx, s->type);
+	if (!q_data)
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		s->r.top = 0;
+		s->r.left = 0;
+		s->r.width = q_data->coded_width;
+		s->r.height = q_data->coded_height;
+		break;
+	case V4L2_SEL_TGT_CROP:
+		s->r.top = 0;
+		s->r.left = 0;
+		s->r.width = q_data->visible_width;
+		s->r.height = q_data->visible_height;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int vidioc_venc_s_selection(struct file *file, void *priv,
+				     struct v4l2_selection *s)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	struct mtk_q_data *q_data;
+	int err;
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return -EINVAL;
+
+	q_data = mtk_venc_get_q_data(ctx, s->type);
+	if (!q_data)
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+		/* Only support crop from (0,0) */
+		s->r.top = 0;
+		s->r.left = 0;
+		s->r.width = min(s->r.width, q_data->coded_width);
+		s->r.height = min(s->r.height, q_data->coded_height);
+		q_data->visible_width = s->r.width;
+		q_data->visible_height = s->r.height;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int vidioc_venc_qbuf(struct file *file, void *priv,
 			    struct v4l2_buffer *buf)
 {
@@ -689,6 +753,9 @@ const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
 
 	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
 	.vidioc_prepare_buf		= v4l2_m2m_ioctl_prepare_buf,
+
+	.vidioc_g_selection		= vidioc_venc_g_selection,
+	.vidioc_s_selection		= vidioc_venc_s_selection,
 };
 
 static int vb2ops_venc_queue_setup(struct vb2_queue *vq,
-- 
1.7.9.5

