Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51739 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570AbaJaPVQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:21:16 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id E916E217D1
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 16:19:04 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] v4l: omap4iss: Enable DMABUF support
Date: Fri, 31 Oct 2014 17:21:19 +0200
Message-Id: <1414768882-16255-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414768882-16255-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414768882-16255-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable DMABUF import and export operations using videobuf2.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 5d62503..774ccea 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -773,6 +773,14 @@ iss_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 }
 
 static int
+iss_video_expbuf(struct file *file, void *fh, struct v4l2_exportbuffer *e)
+{
+	struct iss_video_fh *vfh = to_iss_video_fh(fh);
+
+	return vb2_expbuf(&vfh->queue, e);
+}
+
+static int
 iss_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
 	struct iss_video_fh *vfh = to_iss_video_fh(fh);
@@ -1021,6 +1029,7 @@ static const struct v4l2_ioctl_ops iss_video_ioctl_ops = {
 	.vidioc_reqbufs			= iss_video_reqbufs,
 	.vidioc_querybuf		= iss_video_querybuf,
 	.vidioc_qbuf			= iss_video_qbuf,
+	.vidioc_expbuf			= iss_video_expbuf,
 	.vidioc_dqbuf			= iss_video_dqbuf,
 	.vidioc_streamon		= iss_video_streamon,
 	.vidioc_streamoff		= iss_video_streamoff,
@@ -1071,7 +1080,7 @@ static int iss_video_open(struct file *file)
 	q = &handle->queue;
 
 	q->type = video->type;
-	q->io_modes = VB2_MMAP;
+	q->io_modes = VB2_MMAP | VB2_DMABUF;
 	q->drv_priv = handle;
 	q->ops = &iss_video_vb2ops;
 	q->mem_ops = &vb2_dma_contig_memops;
-- 
2.0.4

