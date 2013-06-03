Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4753 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab3FCJhZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 05:37:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>
Subject: [RFC PATCH 08/13] saa7164: replace current_norm by g_std
Date: Mon,  3 Jun 2013 11:36:45 +0200
Message-Id: <1370252210-4994-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

current_norm is deprecated. Replace it by g_std.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Steven Toth <stoth@kernellabs.com>
---
 drivers/media/pci/saa7164/saa7164-encoder.c |   13 ++++++++++++-
 drivers/media/pci/saa7164/saa7164-vbi.c     |   13 ++++++++++++-
 drivers/media/pci/saa7164/saa7164.h         |    1 +
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 63a72fb..ffa2965 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -228,6 +228,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 		return -EINVAL;
 
 	port->encodernorm = saa7164_tvnorms[i];
+	port->std = id;
 
 	/* Update the audio decoder while is not running in
 	 * auto detect mode.
@@ -239,6 +240,15 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 	return 0;
 }
 
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
+{
+	struct saa7164_encoder_fh *fh = file->private_data;
+	struct saa7164_port *port = fh->port;
+
+	*id = port->std;
+	return 0;
+}
+
 static int vidioc_enum_input(struct file *file, void *priv,
 	struct v4l2_input *i)
 {
@@ -1322,6 +1332,7 @@ static int saa7164_s_register(struct file *file, void *fh,
 
 static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_std		 = vidioc_s_std,
+	.vidioc_g_std		 = vidioc_g_std,
 	.vidioc_enum_input	 = vidioc_enum_input,
 	.vidioc_g_input		 = vidioc_g_input,
 	.vidioc_s_input		 = vidioc_s_input,
@@ -1353,7 +1364,6 @@ static struct video_device saa7164_mpeg_template = {
 	.ioctl_ops     = &mpeg_ioctl_ops,
 	.minor         = -1,
 	.tvnorms       = SAA7164_NORMS,
-	.current_norm  = V4L2_STD_NTSC_M,
 };
 
 static struct video_device *saa7164_encoder_alloc(
@@ -1420,6 +1430,7 @@ int saa7164_encoder_register(struct saa7164_port *port)
 	port->encoder_params.ctl_aspect = V4L2_MPEG_VIDEO_ASPECT_4x3;
 	port->encoder_params.refdist = 1;
 	port->encoder_params.gop_size = SAA7164_ENCODER_DEFAULT_GOP_SIZE;
+	port->std = V4L2_STD_NTSC_M;
 
 	if (port->encodernorm.id & V4L2_STD_525_60)
 		port->height = 480;
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index da224eb..07c361e 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -200,6 +200,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 		return -EINVAL;
 
 	port->encodernorm = saa7164_tvnorms[i];
+	port->std = id;
 
 	/* Update the audio decoder while is not running in
 	 * auto detect mode.
@@ -211,6 +212,15 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 	return 0;
 }
 
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
+{
+	struct saa7164_encoder_fh *fh = file->private_data;
+	struct saa7164_port *port = fh->port;
+
+	*id = port->std;
+	return 0;
+}
+
 static int vidioc_enum_input(struct file *file, void *priv,
 	struct v4l2_input *i)
 {
@@ -1236,6 +1246,7 @@ static const struct v4l2_file_operations vbi_fops = {
 
 static const struct v4l2_ioctl_ops vbi_ioctl_ops = {
 	.vidioc_s_std		 = vidioc_s_std,
+	.vidioc_g_std		 = vidioc_g_std,
 	.vidioc_enum_input	 = vidioc_enum_input,
 	.vidioc_g_input		 = vidioc_g_input,
 	.vidioc_s_input		 = vidioc_s_input,
@@ -1274,7 +1285,6 @@ static struct video_device saa7164_vbi_template = {
 	.ioctl_ops     = &vbi_ioctl_ops,
 	.minor         = -1,
 	.tvnorms       = SAA7164_NORMS,
-	.current_norm  = V4L2_STD_NTSC_M,
 };
 
 static struct video_device *saa7164_vbi_alloc(
@@ -1333,6 +1343,7 @@ int saa7164_vbi_register(struct saa7164_port *port)
 		goto failed;
 	}
 
+	port->std = V4L2_STD_NTSC_M;
 	video_set_drvdata(port->v4l_device, port);
 	result = video_register_device(port->v4l_device,
 		VFL_TYPE_VBI, -1);
diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
index 437284e..a23e7fe 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -376,6 +376,7 @@ struct saa7164_port {
 	/* Encoder */
 	/* Defaults established in saa7164-encoder.c */
 	struct saa7164_tvnorm encodernorm;
+	v4l2_std_id std;
 	u32 height;
 	u32 width;
 	u32 freq;
-- 
1.7.10.4

