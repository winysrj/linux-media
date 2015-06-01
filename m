Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:34704 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418AbbFALSj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 07:18:39 -0400
Message-ID: <556C3F87.9000402@xs4all.nl>
Date: Mon, 01 Jun 2015 13:18:31 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] stk1160: add DMABUF support
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement DMABUF exporting and importing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 749ad56..4d313ed 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -500,6 +500,7 @@ static const struct v4l2_ioctl_ops stk1160_ioctl_ops = {
 	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
 	.vidioc_streamon      = vb2_ioctl_streamon,
 	.vidioc_streamoff     = vb2_ioctl_streamoff,
+	.vidioc_expbuf        = vb2_ioctl_expbuf,
 
 	.vidioc_log_status  = v4l2_ctrl_log_status,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
@@ -645,7 +646,7 @@ int stk1160_vb2_setup(struct stk1160 *dev)
 
 	q = &dev->vb_vidq;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
+	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	q->drv_priv = dev;
 	q->buf_struct_size = sizeof(struct stk1160_buffer);
 	q->ops = &stk1160_video_qops;
