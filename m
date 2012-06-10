Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2851 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab2FJK0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 26/32] vivi: remove pointless g/s_std support
Date: Sun, 10 Jun 2012 12:25:48 +0200
Message-Id: <d768c5db59e037af50d90a73fed5130e3d543481.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 08c1024..8dd5ae6 100644
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
@@ -1318,7 +1313,6 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_querybuf      = vidioc_querybuf,
 	.vidioc_qbuf          = vidioc_qbuf,
 	.vidioc_dqbuf         = vidioc_dqbuf,
-	.vidioc_s_std         = vidioc_s_std,
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
@@ -1334,9 +1328,6 @@ static struct video_device vivi_template = {
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

