Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:9734 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab2HNPic (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 11:38:32 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8R00J7V4S0DVJ0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:38:31 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8R004J44MBC810@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:38:31 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de, dmitriyz@google.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
Subject: [PATCHv8 26/26] v4l: s5p-mfc: support for dmabuf exporting
Date: Tue, 14 Aug 2012 17:34:56 +0200
Message-id: <1344958496-9373-27-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
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
index c5d567f..b375209 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -570,6 +570,23 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
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
@@ -745,6 +762,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 	.vidioc_querybuf = vidioc_querybuf,
 	.vidioc_qbuf = vidioc_qbuf,
 	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_expbuf = vidioc_expbuf,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_g_crop = vidioc_g_crop,
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index aa1c244..df3da50 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -1142,6 +1142,23 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
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
@@ -1487,6 +1504,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_enc_ioctl_ops = {
 	.vidioc_querybuf = vidioc_querybuf,
 	.vidioc_qbuf = vidioc_qbuf,
 	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_expbuf = vidioc_expbuf,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_s_parm = vidioc_s_parm,
-- 
1.7.9.5

