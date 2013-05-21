Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56228 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3EUIQg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 04:16:36 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Pawel Osciak <pawel@osciak.com>, John Sheu <sheu@google.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/2] [media] coda: v4l2-compliance fix: add VIDIOC_CREATE_BUFS support
Date: Tue, 21 May 2013 10:16:29 +0200
Message-Id: <1369124189-590-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1369124189-590-1-git-send-email-p.zabel@pengutronix.de>
References: <1369124189-590-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index d64908a..0319114 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -576,6 +576,14 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
 }
 
+static int vidioc_create_bufs(struct file *file, void *priv,
+			      struct v4l2_create_buffers *create)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_create_bufs(file, ctx->m2m_ctx, create);
+}
+
 static int vidioc_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type type)
 {
@@ -610,6 +618,7 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 
 	.vidioc_qbuf		= vidioc_qbuf,
 	.vidioc_dqbuf		= vidioc_dqbuf,
+	.vidioc_create_bufs	= vidioc_create_bufs,
 
 	.vidioc_streamon	= vidioc_streamon,
 	.vidioc_streamoff	= vidioc_streamoff,
-- 
1.8.2.rc2

