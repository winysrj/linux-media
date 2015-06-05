Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:59264 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933062AbbFEO3K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 10:29:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/3] vim2m: add create_bufs and prepare_buf support
Date: Fri,  5 Jun 2015 16:28:52 +0200
Message-Id: <1433514532-23306-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433514532-23306-1-git-send-email-hverkuil@xs4all.nl>
References: <1433514532-23306-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the missing VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF
ioctls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vim2m.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index cecfd75..295fde5 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -693,6 +693,8 @@ static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
 	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
 	.vidioc_qbuf		= v4l2_m2m_ioctl_qbuf,
 	.vidioc_dqbuf		= v4l2_m2m_ioctl_dqbuf,
+	.vidioc_prepare_buf	= v4l2_m2m_ioctl_prepare_buf,
+	.vidioc_create_bufs	= v4l2_m2m_ioctl_create_bufs,
 	.vidioc_expbuf		= v4l2_m2m_ioctl_expbuf,
 
 	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
@@ -720,6 +722,12 @@ static int vim2m_queue_setup(struct vb2_queue *vq,
 
 	size = q_data->width * q_data->height * q_data->fmt->depth >> 3;
 
+	if (fmt) {
+		if (fmt->fmt.pix.sizeimage < size)
+			return -EINVAL;
+		size = fmt->fmt.pix.sizeimage;
+	}
+
 	while (size * count > MEM2MEM_VID_MEM_LIMIT)
 		(count)--;
 
-- 
2.1.4

