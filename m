Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:50130 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967795AbaLLN3G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 08:29:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/7] cx25821: add create_bufs support
Date: Fri, 12 Dec 2014 14:27:59 +0100
Message-Id: <1418390880-39009-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
References: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the VIDIOC_CREATE_BUFS ioctl. This was missing in this
driver and in vb2 it's trivial to add.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 3497946..827c3c0 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -146,9 +146,13 @@ static int cx25821_queue_setup(struct vb2_queue *q, const struct v4l2_format *fm
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct cx25821_channel *chan = q->drv_priv;
+	unsigned size = (chan->fmt->depth * chan->width * chan->height) >> 3;
+
+	if (fmt && fmt->fmt.pix.sizeimage < size)
+		return -EINVAL;
 
 	*num_planes = 1;
-	sizes[0] = (chan->fmt->depth * chan->width * chan->height) >> 3;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : size;
 	alloc_ctxs[0] = chan->dev->alloc_ctx;
 	return 0;
 }
@@ -610,6 +614,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
 	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
 	.vidioc_prepare_buf   = vb2_ioctl_prepare_buf,
+	.vidioc_create_bufs   = vb2_ioctl_create_bufs,
 	.vidioc_querybuf      = vb2_ioctl_querybuf,
 	.vidioc_qbuf          = vb2_ioctl_qbuf,
 	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
-- 
2.1.3

