Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52045 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2EWNHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 09:07:48 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4H0004P8GN11@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:35 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H00KYY8GXMD@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:45 +0100 (BST)
Date: Wed, 23 May 2012 15:07:32 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 09/12] v4l: s5p-mfc: support for dmabuf exporting
In-reply-to: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de,
	Kamil Debski <k.debski@samsung.com>
Message-id: <1337778455-27912-10-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances s5p-mfc with support for DMABUF exporting via
VIDIOC_EXPBUF ioctl.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c |   13 +++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |   13 +++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index c25ec02..e1ebc76 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -564,6 +564,18 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 	return -EINVAL;
 }
 
+/* Export DMA buffer */
+static int vidioc_expbuf(struct file *file, void *priv,
+	struct v4l2_exportbuffer *eb)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+
+	if (eb->mem_offset < DST_QUEUE_OFF_BASE)
+		return vb2_expbuf(&ctx->vq_src, eb);
+	else
+		return vb2_expbuf(&ctx->vq_dst, eb);
+}
+
 /* Stream on */
 static int vidioc_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type type)
@@ -739,6 +751,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 	.vidioc_querybuf = vidioc_querybuf,
 	.vidioc_qbuf = vidioc_qbuf,
 	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_expbuf = vidioc_expbuf,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_g_crop = vidioc_g_crop,
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index acedb20..887f1aa 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -1141,6 +1141,18 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 	return -EINVAL;
 }
 
+/* Export DMA buffer */
+static int vidioc_expbuf(struct file *file, void *priv,
+	struct v4l2_exportbuffer *eb)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+
+	if (eb->mem_offset < DST_QUEUE_OFF_BASE)
+		return vb2_expbuf(&ctx->vq_src, eb);
+	else
+		return vb2_expbuf(&ctx->vq_dst, eb);
+}
+
 /* Stream on */
 static int vidioc_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type type)
@@ -1486,6 +1498,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_enc_ioctl_ops = {
 	.vidioc_querybuf = vidioc_querybuf,
 	.vidioc_qbuf = vidioc_qbuf,
 	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_expbuf = vidioc_expbuf,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_s_parm = vidioc_s_parm,
-- 
1.7.9.5

