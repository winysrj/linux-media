Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45725 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab2JJPDa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 11:03:30 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBO00H69N55D2W0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Oct 2012 00:03:08 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBO002YDME0EC70@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Oct 2012 00:03:07 +0900 (KST)
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
Subject: [PATCHv10 24/26] v4l: s5p-fimc: support for dmabuf exporting
Date: Wed, 10 Oct 2012 16:46:43 +0200
Message-id: <1349880405-26049-25-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances s5p-fimc with support for DMABUF exporting via
VIDIOC_EXPBUF ioctl.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |    9 +++++++++
 drivers/media/platform/s5p-fimc/fimc-m2m.c     |   10 ++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 246bb32..e5fd159 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -1231,6 +1231,14 @@ static int fimc_cap_qbuf(struct file *file, void *priv,
 	return vb2_qbuf(&fimc->vid_cap.vbq, buf);
 }
 
+static int fimc_cap_expbuf(struct file *file, void *priv,
+			  struct v4l2_exportbuffer *eb)
+{
+	struct fimc_dev *fimc = video_drvdata(file);
+
+	return vb2_expbuf(&fimc->vid_cap.vbq, eb);
+}
+
 static int fimc_cap_dqbuf(struct file *file, void *priv,
 			   struct v4l2_buffer *buf)
 {
@@ -1355,6 +1363,7 @@ static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 
 	.vidioc_qbuf			= fimc_cap_qbuf,
 	.vidioc_dqbuf			= fimc_cap_dqbuf,
+	.vidioc_expbuf			= fimc_cap_expbuf,
 
 	.vidioc_prepare_buf		= fimc_cap_prepare_buf,
 	.vidioc_create_bufs		= fimc_cap_create_bufs,
diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index 17067a7..1cd4fcf 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -439,6 +439,15 @@ static int fimc_m2m_dqbuf(struct file *file, void *fh,
 	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
 }
 
+static int fimc_m2m_expbuf(struct file *file, void *fh,
+			    struct v4l2_exportbuffer *eb)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+
+	return v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
+}
+
+
 static int fimc_m2m_streamon(struct file *file, void *fh,
 			     enum v4l2_buf_type type)
 {
@@ -607,6 +616,7 @@ static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
 	.vidioc_querybuf		= fimc_m2m_querybuf,
 	.vidioc_qbuf			= fimc_m2m_qbuf,
 	.vidioc_dqbuf			= fimc_m2m_dqbuf,
+	.vidioc_expbuf			= fimc_m2m_expbuf,
 	.vidioc_streamon		= fimc_m2m_streamon,
 	.vidioc_streamoff		= fimc_m2m_streamoff,
 	.vidioc_g_crop			= fimc_m2m_g_crop,
-- 
1.7.9.5

