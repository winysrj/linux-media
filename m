Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:59117 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbbCIVXx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:23:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/18] marvell-ccic: add create_bufs support
Date: Mon,  9 Mar 2015 22:22:15 +0100
Message-Id: <1425936143-5658-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This fixes the final v4l2-compliance warning.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index b6b838f..51b7291 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1073,7 +1073,9 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
 	int minbufs = (cam->buffer_mode == B_DMA_contig) ? 3 : 2;
 
-	sizes[0] = cam->pix_format.sizeimage;
+	if (fmt && fmt->fmt.pix.sizeimage < cam->pix_format.sizeimage)
+		return -EINVAL;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : cam->pix_format.sizeimage;
 	*num_planes = 1; /* Someday we have to support planar formats... */
 	if (*nbufs < minbufs)
 		*nbufs = minbufs;
@@ -1380,7 +1382,7 @@ static int mcam_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
 	 * Can't do anything if the device is not idle
 	 * Also can't if there are streaming buffers in place.
 	 */
-	if (cam->state != S_IDLE || cam->vb_queue.num_buffers > 0)
+	if (cam->state != S_IDLE || vb2_is_busy(&cam->vb_queue))
 		return -EBUSY;
 
 	f = mcam_find_format(fmt->fmt.pix.pixelformat);
@@ -1573,6 +1575,7 @@ static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
 	.vidioc_g_input		= mcam_vidioc_g_input,
 	.vidioc_s_input		= mcam_vidioc_s_input,
 	.vidioc_reqbufs		= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs	= vb2_ioctl_create_bufs,
 	.vidioc_querybuf	= vb2_ioctl_querybuf,
 	.vidioc_qbuf		= vb2_ioctl_qbuf,
 	.vidioc_dqbuf		= vb2_ioctl_dqbuf,
-- 
2.1.4

