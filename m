Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:32637 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2JBOau (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 10:30:50 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MB900EW3SB6IC00@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 23:30:49 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MB9005A7S65K790@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 23:30:49 +0900 (KST)
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
Subject: [PATCHv9 25/25] v4l: s5p-mfc: support for dmabuf exporting
Date: Tue, 02 Oct 2012 16:27:36 +0200
Message-id: <1349188056-4886-26-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances s5p-mfc with support for DMABUF exporting via
VIDIOC_EXPBUF ioctl.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c |   14 ++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |   14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index c5d567f..c2f4f49 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -570,6 +570,19 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
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
@@ -745,6 +758,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 	.vidioc_querybuf = vidioc_querybuf,
 	.vidioc_qbuf = vidioc_qbuf,
 	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_expbuf = vidioc_expbuf,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_g_crop = vidioc_g_crop,
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index aa1c244..a08ce0a 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -1142,6 +1142,19 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
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
@@ -1487,6 +1500,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_enc_ioctl_ops = {
 	.vidioc_querybuf = vidioc_querybuf,
 	.vidioc_qbuf = vidioc_qbuf,
 	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_expbuf = vidioc_expbuf,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_s_parm = vidioc_s_parm,
-- 
1.7.9.5

