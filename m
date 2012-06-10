Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2764 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2FJKzM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:55:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 01/11] cx88: fix querycap
Date: Sun, 10 Jun 2012 12:54:47 +0200
Message-Id: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
In-Reply-To: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
References: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cx88/cx88-blackbird.c |   12 +---
 drivers/media/video/cx88/cx88-video.c     |   90 ++++++++++-------------------
 drivers/media/video/cx88/cx88.h           |    2 +
 3 files changed, 36 insertions(+), 68 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index ed7b2aa..cbacdf6 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -722,21 +722,15 @@ static int vidioc_querymenu (struct file *file, void *priv,
 			cx2341x_ctrl_get_menu(&dev->params, qmenu->id));
 }
 
-static int vidioc_querycap (struct file *file, void  *priv,
+static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
 	struct cx8802_dev *dev  = ((struct cx8802_fh *)priv)->dev;
 	struct cx88_core  *core = dev->core;
 
 	strcpy(cap->driver, "cx88_blackbird");
-	strlcpy(cap->card, core->board.name, sizeof(cap->card));
-	sprintf(cap->bus_info,"PCI:%s",pci_name(dev->pci));
-	cap->capabilities =
-		V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_READWRITE     |
-		V4L2_CAP_STREAMING;
-	if (UNSET != core->board.tuner_type)
-		cap->capabilities |= V4L2_CAP_TUNER;
+	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
+	cx88_querycap(file, core, cap);
 	return 0;
 }
 
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 921c56d..5d99736 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1195,22 +1195,42 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_querycap (struct file *file, void  *priv,
+void cx88_querycap(struct file *file, struct cx88_core *core,
+		struct v4l2_capability *cap)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	strlcpy(cap->card, core->board.name, sizeof(cap->card));
+	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	if (UNSET != core->board.tuner_type)
+		cap->device_caps |= V4L2_CAP_TUNER;
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_RADIO:
+		cap->device_caps = V4L2_CAP_RADIO | V4L2_CAP_TUNER;
+		break;
+	case VFL_TYPE_GRABBER:
+		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
+		break;
+	case VFL_TYPE_VBI:
+		cap->device_caps |= V4L2_CAP_VBI_CAPTURE;
+		break;
+	}
+	cap->capabilities = cap->device_caps | V4L2_CAP_VIDEO_CAPTURE |
+		V4L2_CAP_VBI_CAPTURE | V4L2_CAP_DEVICE_CAPS;
+	if (core->board.radio.type == CX88_RADIO)
+		cap->capabilities |= V4L2_CAP_RADIO;
+}
+EXPORT_SYMBOL(cx88_querycap);
+
+static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
 	struct cx8800_dev *dev  = ((struct cx8800_fh *)priv)->dev;
 	struct cx88_core  *core = dev->core;
 
 	strcpy(cap->driver, "cx8800");
-	strlcpy(cap->card, core->board.name, sizeof(cap->card));
-	sprintf(cap->bus_info,"PCI:%s",pci_name(dev->pci));
-	cap->capabilities =
-		V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_READWRITE     |
-		V4L2_CAP_STREAMING     |
-		V4L2_CAP_VBI_CAPTURE;
-	if (UNSET != core->board.tuner_type)
-		cap->capabilities |= V4L2_CAP_TUNER;
+	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
+	cx88_querycap(file, core, cap);
 	return 0;
 }
 
@@ -1513,19 +1533,6 @@ static int vidioc_s_register (struct file *file, void *fh,
 /* RADIO ESPECIFIC IOCTLS                                      */
 /* ----------------------------------------------------------- */
 
-static int radio_querycap (struct file *file, void  *priv,
-					struct v4l2_capability *cap)
-{
-	struct cx8800_dev *dev  = ((struct cx8800_fh *)priv)->dev;
-	struct cx88_core  *core = dev->core;
-
-	strcpy(cap->driver, "cx8800");
-	strlcpy(cap->card, core->board.name, sizeof(cap->card));
-	sprintf(cap->bus_info,"PCI:%s", pci_name(dev->pci));
-	cap->capabilities = V4L2_CAP_TUNER;
-	return 0;
-}
-
 static int radio_g_tuner (struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
@@ -1541,26 +1548,6 @@ static int radio_g_tuner (struct file *file, void *priv,
 	return 0;
 }
 
-static int radio_enum_input (struct file *file, void *priv,
-				struct v4l2_input *i)
-{
-	if (i->index != 0)
-		return -EINVAL;
-	strcpy(i->name,"Radio");
-	i->type = V4L2_INPUT_TYPE_TUNER;
-
-	return 0;
-}
-
-static int radio_g_audio (struct file *file, void *priv, struct v4l2_audio *a)
-{
-	if (unlikely(a->index))
-		return -EINVAL;
-
-	strcpy(a->name,"Radio");
-	return 0;
-}
-
 /* FIXME: Should add a standard for radio */
 
 static int radio_s_tuner (struct file *file, void *priv,
@@ -1576,17 +1563,6 @@ static int radio_s_tuner (struct file *file, void *priv,
 	return 0;
 }
 
-static int radio_s_audio (struct file *file, void *fh,
-			  struct v4l2_audio *a)
-{
-	return 0;
-}
-
-static int radio_s_input (struct file *file, void *fh, unsigned int i)
-{
-	return 0;
-}
-
 static int radio_queryctrl (struct file *file, void *priv,
 			    struct v4l2_queryctrl *c)
 {
@@ -1797,13 +1773,9 @@ static const struct v4l2_file_operations radio_fops =
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
-	.vidioc_querycap      = radio_querycap,
+	.vidioc_querycap      = vidioc_querycap,
 	.vidioc_g_tuner       = radio_g_tuner,
-	.vidioc_enum_input    = radio_enum_input,
-	.vidioc_g_audio       = radio_g_audio,
 	.vidioc_s_tuner       = radio_s_tuner,
-	.vidioc_s_audio       = radio_s_audio,
-	.vidioc_s_input       = radio_s_input,
 	.vidioc_queryctrl     = radio_queryctrl,
 	.vidioc_g_ctrl        = vidioc_g_ctrl,
 	.vidioc_s_ctrl        = vidioc_s_ctrl,
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index c9659de..8e9820c 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -730,3 +730,5 @@ int cx88_set_freq (struct cx88_core  *core,struct v4l2_frequency *f);
 int cx88_get_control(struct cx88_core *core, struct v4l2_control *ctl);
 int cx88_set_control(struct cx88_core *core, struct v4l2_control *ctl);
 int cx88_video_mux(struct cx88_core *core, unsigned int input);
+void cx88_querycap(struct file *file, struct cx88_core *core,
+		struct v4l2_capability *cap);
-- 
1.7.10

