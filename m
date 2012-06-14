Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21916 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab2FNOcn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 10:32:43 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5M001TQ3398Z70@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 15:33:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M5M00M2932D1H@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 15:32:38 +0100 (BST)
Date: Thu, 14 Jun 2012 16:32:28 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 8/9] v4l: s5p-mfc: support for dmabuf exporting
In-reply-to: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de,
	Kamil Debski <k.debski@samsung.com>
Message-id: <1339684349-28882-9-git-send-email-t.stanislaws@samsung.com>
Content-transfer-encoding: 7BIT
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances s5p-mfc with support for DMABUF exporting via
VIDIOC_EXPBUF ioctl.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c |   18 ++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |   18 ++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index c25ec02..8344ce5 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -564,6 +564,23 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 	return -EINVAL;
 }
 
+/* Export DMA buffer */
+static int vidioc_expbuf(struct file *file, void *priv,
+	struct v4l2_exportbuffer *eb)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	if (eb->mem_offset < DST_QUEUE_OFF_BASE)
+		return vb2_expbuf(&ctx->vq_src, eb);
+
+	eb->mem_offset -= DST_QUEUE_OFF_BASE;
+	ret = vb2_expbuf(&ctx->vq_dst, eb);
+	eb->mem_offset += DST_QUEUE_OFF_BASE;
+
+	return ret;
+}
+
 /* Stream on */
 static int vidioc_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type type)
@@ -739,6 +756,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 	.vidioc_querybuf = vidioc_querybuf,
 	.vidioc_qbuf = vidioc_qbuf,
 	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_expbuf = vidioc_expbuf,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_g_crop = vidioc_g_crop,
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index acedb20..db110c5 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -1141,6 +1141,23 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 	return -EINVAL;
 }
 
+/* Export DMA buffer */
+static int vidioc_expbuf(struct file *file, void *priv,
+	struct v4l2_exportbuffer *eb)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	if (eb->mem_offset < DST_QUEUE_OFF_BASE)
+		return vb2_expbuf(&ctx->vq_src, eb);
+
+	eb->mem_offset -= DST_QUEUE_OFF_BASE;
+	ret = vb2_expbuf(&ctx->vq_dst, eb);
+	eb->mem_offset += DST_QUEUE_OFF_BASE;
+
+	return ret;
+}
+
 /* Stream on */
 static int vidioc_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type type)
@@ -1486,6 +1503,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_enc_ioctl_ops = {
 	.vidioc_querybuf = vidioc_querybuf,
 	.vidioc_qbuf = vidioc_qbuf,
 	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_expbuf = vidioc_expbuf,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_s_parm = vidioc_s_parm,
-- 
1.7.9.5

