Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:62111 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab2JJPET (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 11:04:19 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBO00GTGN76P590@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Oct 2012 00:04:18 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBO002YDME0EC70@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Oct 2012 00:04:18 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: [PATCHv10 26/26] v4l: s5p-mfc: support for dmabuf exporting
Date: Wed, 10 Oct 2012 16:46:45 +0200
Message-id: <1349880405-26049-27-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances s5p-mfc with support for DMABUF exporting via
VIDIOC_EXPBUF ioctl.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Kamil Debski <k.debski@samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |   14 ++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |   14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index eb6a70b..6dad9a7 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -636,6 +636,19 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 	return -EINVAL;
 }
 
+/* Export DMA buffer */
+static int vidioc_expbuf(struct file *file, void *priv,
+	struct v4l2_exportbuffer *eb)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+
+	if (eb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return vb2_expbuf(&ctx->vq_src, eb);
+	if (eb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return vb2_expbuf(&ctx->vq_dst, eb);
+	return -EINVAL;
+}
+
 /* Stream on */
 static int vidioc_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type type)
@@ -813,6 +826,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 	.vidioc_querybuf = vidioc_querybuf,
 	.vidioc_qbuf = vidioc_qbuf,
 	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_expbuf = vidioc_expbuf,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_g_crop = vidioc_g_crop,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 2af6d52..22bf684 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1165,6 +1165,19 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 	return ret;
 }
 
+/* Export DMA buffer */
+static int vidioc_expbuf(struct file *file, void *priv,
+	struct v4l2_exportbuffer *eb)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+
+	if (eb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return vb2_expbuf(&ctx->vq_src, eb);
+	if (eb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return vb2_expbuf(&ctx->vq_dst, eb);
+	return -EINVAL;
+}
+
 /* Stream on */
 static int vidioc_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type type)
@@ -1568,6 +1581,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_enc_ioctl_ops = {
 	.vidioc_querybuf = vidioc_querybuf,
 	.vidioc_qbuf = vidioc_qbuf,
 	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_expbuf = vidioc_expbuf,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_s_parm = vidioc_s_parm,
-- 
1.7.9.5

