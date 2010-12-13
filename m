Return-path: <mchehab@gaivota>
Received: from mail-out.m-online.net ([212.18.0.10]:58082 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab0LMSTh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 13:19:37 -0500
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Detlev Zundel <dzu@denx.de>
Subject: [PATCH 2/2] media: fsl_viu: add VIDIOC_QUERYSTD and VIDIOC_G_STD support
Date: Mon, 13 Dec 2010 19:19:37 +0100
Message-Id: <1292264377-31877-2-git-send-email-agust@denx.de>
In-Reply-To: <1292264377-31877-1-git-send-email-agust@denx.de>
References: <1292264377-31877-1-git-send-email-agust@denx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

VIDIOC_QUERYSTD and VIDIOC_G_STD ioctls are currently not
supported in the FSL VIU driver. The decoder subdevice
driver saa7115 extended by previous patch supports QUERYSTD
for saa7113, so we add the appropriate ioctls to the VIU
driver to be able to determine the video input's standard.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/video/fsl-viu.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
index b8faff2..04be6eb 100644
--- a/drivers/media/video/fsl-viu.c
+++ b/drivers/media/video/fsl-viu.c
@@ -194,6 +194,8 @@ struct viu_dev {
 
 	/* decoder */
 	struct v4l2_subdev	*decoder;
+
+	v4l2_std_id		std;
 };
 
 struct viu_fh {
@@ -933,14 +935,31 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 #define decoder_call(viu, o, f, args...) \
 	v4l2_subdev_call(viu->decoder, o, f, ##args)
 
+static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
+{
+	struct viu_fh *fh = priv;
+
+	decoder_call(fh->dev, video, querystd, std_id);
+	return 0;
+}
+
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
 {
 	struct viu_fh *fh = priv;
 
+	fh->dev->std = *id;
 	decoder_call(fh->dev, core, s_std, *id);
 	return 0;
 }
 
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *std_id)
+{
+	struct viu_fh *fh = priv;
+
+	*std_id = fh->dev->std;
+	return 0;
+}
+
 /* only one input in this driver */
 static int vidioc_enum_input(struct file *file, void *priv,
 					struct v4l2_input *inp)
@@ -1397,7 +1416,9 @@ static const struct v4l2_ioctl_ops viu_ioctl_ops = {
 	.vidioc_querybuf      = vidioc_querybuf,
 	.vidioc_qbuf          = vidioc_qbuf,
 	.vidioc_dqbuf         = vidioc_dqbuf,
+	.vidioc_g_std         = vidioc_g_std,
 	.vidioc_s_std         = vidioc_s_std,
+	.vidioc_querystd      = vidioc_querystd,
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
-- 
1.7.1

