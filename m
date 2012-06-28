Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2313 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab2F1Gs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:48:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 30/33] vivi: add create_bufs/preparebuf support.
Date: Thu, 28 Jun 2012 08:48:24 +0200
Message-Id: <a38c2a7ca5b0cdb8cb1a73703851d19d883a8933.1340865818.git.hans.verkuil@cisco.com>
In-Reply-To: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index f6d7c6e..1e8c4f3 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -767,7 +767,13 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	struct vivi_dev *dev = vb2_get_drv_priv(vq);
 	unsigned long size;
 
-	size = dev->width * dev->height * dev->pixelsize;
+	if (fmt)
+		size = fmt->fmt.pix.sizeimage;
+	else
+		size = dev->width * dev->height * dev->pixelsize;
+
+	if (size == 0)
+		return -EINVAL;
 
 	if (0 == *nbuffers)
 		*nbuffers = 32;
@@ -1180,6 +1186,8 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap   = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
 	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs   = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf   = vb2_ioctl_prepare_buf,
 	.vidioc_querybuf      = vb2_ioctl_querybuf,
 	.vidioc_qbuf          = vb2_ioctl_qbuf,
 	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
-- 
1.7.10

