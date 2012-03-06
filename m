Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56327 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759125Ab2CFLiU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 06:38:20 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0G003KLOBR18@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:16 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0G0071WOBRLO@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:15 +0000 (GMT)
Date: Tue, 06 Mar 2012 12:38:10 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFCv2 PATCH 9/9] v4l: s5p-tv: mixer: integrate with dmabuf
In-reply-to: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com
Message-id: <1331033890-10350-10-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/Kconfig       |    1 +
 drivers/media/video/s5p-tv/mixer_video.c |   12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-tv/Kconfig b/drivers/media/video/s5p-tv/Kconfig
index f248b28..2e80126 100644
--- a/drivers/media/video/s5p-tv/Kconfig
+++ b/drivers/media/video/s5p-tv/Kconfig
@@ -10,6 +10,7 @@ config VIDEO_SAMSUNG_S5P_TV
 	bool "Samsung TV driver for S5P platform (experimental)"
 	depends on PLAT_S5P && PM_RUNTIME
 	depends on EXPERIMENTAL
+	select DMA_SHARED_BUFFER
 	default n
 	---help---
 	  Say Y here to enable selecting the TV output devices for
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index f7ca5cc..f08edbf 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -697,6 +697,15 @@ static int mxr_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 	return vb2_dqbuf(&layer->vb_queue, p, file->f_flags & O_NONBLOCK);
 }
 
+static int mxr_expbuf(struct file *file, void *priv,
+	struct v4l2_exportbuffer *eb)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	return vb2_expbuf(&layer->vb_queue, eb);
+}
+
 static int mxr_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct mxr_layer *layer = video_drvdata(file);
@@ -724,6 +733,7 @@ static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
 	.vidioc_querybuf = mxr_querybuf,
 	.vidioc_qbuf = mxr_qbuf,
 	.vidioc_dqbuf = mxr_dqbuf,
+	.vidioc_expbuf = mxr_expbuf,
 	/* Streaming control */
 	.vidioc_streamon = mxr_streamon,
 	.vidioc_streamoff = mxr_streamoff,
@@ -1074,7 +1084,7 @@ struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
 
 	layer->vb_queue = (struct vb2_queue) {
 		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
-		.io_modes = VB2_MMAP | VB2_USERPTR,
+		.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF,
 		.drv_priv = layer,
 		.buf_struct_size = sizeof(struct mxr_buffer),
 		.ops = &mxr_video_qops,
-- 
1.7.5.4

