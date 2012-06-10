Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1212 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2FJKzN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:55:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 10/11] cx88: don't use current_norm.
Date: Sun, 10 Jun 2012 12:54:56 +0200
Message-Id: <4ce9fb31636c8bc1c7d2eeb7b8eaacdc09dcaf1b.1339325224.git.hans.verkuil@cisco.com>
In-Reply-To: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
References: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
References: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

current_norm can only be used if there is a single device node since it is
local to the device node. In this case multiple device nodes share a single
tuner.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cx88/cx88-blackbird.c |   12 +++++++++---
 drivers/media/video/cx88/cx88-video.c     |   14 +++++++++++---
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index 397ac42..9cc6c95 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -930,6 +930,14 @@ static int vidioc_s_tuner (struct file *file, void *priv,
 	return 0;
 }
 
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *tvnorm)
+{
+	struct cx88_core *core = ((struct cx8802_fh *)priv)->dev->core;
+
+	*tvnorm = core->tvnorm;
+	return 0;
+}
+
 static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *id)
 {
 	struct cx88_core  *core = ((struct cx8802_fh *)priv)->dev->core;
@@ -1104,6 +1112,7 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_input       = vidioc_s_input,
 	.vidioc_g_tuner       = vidioc_g_tuner,
 	.vidioc_s_tuner       = vidioc_s_tuner,
+	.vidioc_g_std         = vidioc_g_std,
 	.vidioc_s_std         = vidioc_s_std,
 	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
@@ -1114,7 +1123,6 @@ static struct video_device cx8802_mpeg_template = {
 	.fops                 = &mpeg_fops,
 	.ioctl_ops 	      = &mpeg_ioctl_ops,
 	.tvnorms              = CX88_NORMS,
-	.current_norm         = V4L2_STD_NTSC_M,
 };
 
 /* ------------------------------------------------------------------ */
@@ -1214,8 +1222,6 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	if (!(core->board.mpeg & CX88_MPEG_BLACKBIRD))
 		goto fail_core;
 
-	cx8802_mpeg_template.current_norm = core->tvnorm;
-
 	dev->width = 720;
 	if (core->tvnorm & V4L2_STD_525_60) {
 		dev->height = 480;
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 3dee421..f6fcc7e 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1185,6 +1185,14 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 	return 0;
 }
 
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *tvnorm)
+{
+	struct cx88_core *core = ((struct cx8800_fh *)priv)->dev->core;
+
+	*tvnorm = core->tvnorm;
+	return 0;
+}
+
 static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *tvnorms)
 {
 	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
@@ -1562,6 +1570,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_querybuf      = vidioc_querybuf,
 	.vidioc_qbuf          = vidioc_qbuf,
 	.vidioc_dqbuf         = vidioc_dqbuf,
+	.vidioc_g_std         = vidioc_g_std,
 	.vidioc_s_std         = vidioc_s_std,
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
@@ -1586,7 +1595,6 @@ static const struct video_device cx8800_video_template = {
 	.fops                 = &video_fops,
 	.ioctl_ops 	      = &video_ioctl_ops,
 	.tvnorms              = CX88_NORMS,
-	.current_norm         = V4L2_STD_NTSC_M,
 };
 
 static const struct v4l2_ioctl_ops vbi_ioctl_ops = {
@@ -1598,6 +1606,7 @@ static const struct v4l2_ioctl_ops vbi_ioctl_ops = {
 	.vidioc_querybuf      = vidioc_querybuf,
 	.vidioc_qbuf          = vidioc_qbuf,
 	.vidioc_dqbuf         = vidioc_dqbuf,
+	.vidioc_g_std         = vidioc_g_std,
 	.vidioc_s_std         = vidioc_s_std,
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
@@ -1620,7 +1629,6 @@ static const struct video_device cx8800_vbi_template = {
 	.fops                 = &video_fops,
 	.ioctl_ops	      = &vbi_ioctl_ops,
 	.tvnorms              = CX88_NORMS,
-	.current_norm         = V4L2_STD_NTSC_M,
 };
 
 static const struct v4l2_file_operations radio_fops =
@@ -1730,7 +1738,7 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 
 	/* initialize driver struct */
 	spin_lock_init(&dev->slock);
-	core->tvnorm = cx8800_video_template.current_norm;
+	core->tvnorm = V4L2_STD_NTSC_M;
 
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
-- 
1.7.10

