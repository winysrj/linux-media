Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16931 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab2AWNvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 08:51:38 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LY900GN47U0VS60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:36 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LY900DA47TZTD@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:36 +0000 (GMT)
Date: Mon, 23 Jan 2012 14:51:15 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 10/10] v4l: s5p-tv: mixer: integrate with dmabuf
In-reply-to: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Cc: sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	pawel@osciak.com
Message-id: <1327326675-8431-11-git-send-email-t.stanislaws@samsung.com>
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/mixer_video.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index b47d0c0..65e0722 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -592,6 +592,14 @@ static int mxr_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 	return vb2_dqbuf(&layer->vb_queue, p, file->f_flags & O_NONBLOCK);
 }
 
+static int mxr_expbuf(struct file *file, void *priv, unsigned int offset)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	return vb2_expbuf(&layer->vb_queue, offset);
+}
+
 static int mxr_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct mxr_layer *layer = video_drvdata(file);
@@ -619,6 +627,7 @@ static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
 	.vidioc_querybuf = mxr_querybuf,
 	.vidioc_qbuf = mxr_qbuf,
 	.vidioc_dqbuf = mxr_dqbuf,
+	.vidioc_expbuf = mxr_expbuf,
 	/* Streaming control */
 	.vidioc_streamon = mxr_streamon,
 	.vidioc_streamoff = mxr_streamoff,
@@ -973,7 +982,7 @@ struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
 
 	layer->vb_queue = (struct vb2_queue) {
 		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
-		.io_modes = VB2_MMAP | VB2_USERPTR,
+		.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF,
 		.drv_priv = layer,
 		.buf_struct_size = sizeof(struct mxr_buffer),
 		.ops = &mxr_video_qops,
-- 
1.7.5.4

