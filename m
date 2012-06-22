Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4341 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787Ab2FVMVx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:21:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 28/34] vivi: remove pointless g/s_std support
Date: Fri, 22 Jun 2012 14:21:22 +0200
Message-Id: <6537d34aa4daeecd752f97d21d9872566a3a3e22.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 08c1024..e00efcf 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1072,11 +1072,6 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 	return vb2_streamoff(&dev->vb_vidq, i);
 }
 
-static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *i)
-{
-	return 0;
-}
-
 /* only one input in this sample driver */
 static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *inp)
@@ -1085,7 +1080,6 @@ static int vidioc_enum_input(struct file *file, void *priv,
 		return -EINVAL;
 
 	inp->type = V4L2_INPUT_TYPE_CAMERA;
-	inp->std = V4L2_STD_525_60;
 	sprintf(inp->name, "Camera %u", inp->index);
 	return 0;
 }
@@ -1318,7 +1312,6 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_querybuf      = vidioc_querybuf,
 	.vidioc_qbuf          = vidioc_qbuf,
 	.vidioc_dqbuf         = vidioc_dqbuf,
-	.vidioc_s_std         = vidioc_s_std,
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
@@ -1334,9 +1327,6 @@ static struct video_device vivi_template = {
 	.fops           = &vivi_fops,
 	.ioctl_ops 	= &vivi_ioctl_ops,
 	.release	= video_device_release,
-
-	.tvnorms              = V4L2_STD_525_60,
-	.current_norm         = V4L2_STD_NTSC_M,
 };
 
 /* -----------------------------------------------------------------
-- 
1.7.10

