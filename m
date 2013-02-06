Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2229 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3BFP4p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 10:56:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 02/17] bttv: fix querycap and radio v4l2-compliance issues.
Date: Wed,  6 Feb 2013 16:56:20 +0100
Message-Id: <030c7ffde10d634c71ce856ed3ecd8731b9396ae.1360165855.git.hans.verkuil@cisco.com>
In-Reply-To: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
References: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
References: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The querycap ioctl didn't support V4L2_CAP_DEVICE_CAPS and the radio device
implemented audio and video inputs and s_std, which are not part of the radio
API.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |  101 +++++++++------------------------
 1 file changed, 27 insertions(+), 74 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index ccd18e4..cc7f58f 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2630,6 +2630,7 @@ static int bttv_s_fmt_vid_overlay(struct file *file, void *priv,
 static int bttv_querycap(struct file *file, void  *priv,
 				struct v4l2_capability *cap)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct bttv_fh *fh = priv;
 	struct bttv *btv = fh->btv;
 
@@ -2642,11 +2643,15 @@ static int bttv_querycap(struct file *file, void  *priv,
 		 "PCI:%s", pci_name(btv->c.pci));
 	cap->capabilities =
 		V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_VBI_CAPTURE |
 		V4L2_CAP_READWRITE |
-		V4L2_CAP_STREAMING;
+		V4L2_CAP_STREAMING |
+		V4L2_CAP_DEVICE_CAPS;
 	if (no_overlay <= 0)
 		cap->capabilities |= V4L2_CAP_VIDEO_OVERLAY;
+	if (btv->vbi_dev)
+		cap->capabilities |= V4L2_CAP_VBI_CAPTURE;
+	if (btv->radio_dev)
+		cap->capabilities |= V4L2_CAP_RADIO;
 
 	/*
 	 * No need to lock here: those vars are initialized during board
@@ -2656,6 +2661,25 @@ static int bttv_querycap(struct file *file, void  *priv,
 		cap->capabilities |= V4L2_CAP_RDS_CAPTURE;
 	if (btv->tuner_type != TUNER_ABSENT)
 		cap->capabilities |= V4L2_CAP_TUNER;
+	if (vdev->vfl_type == VFL_TYPE_GRABBER)
+		cap->device_caps = cap->capabilities &
+			(V4L2_CAP_VIDEO_CAPTURE |
+			 V4L2_CAP_READWRITE |
+			 V4L2_CAP_STREAMING |
+			 V4L2_CAP_VIDEO_OVERLAY |
+			 V4L2_CAP_TUNER);
+	else if (vdev->vfl_type == VFL_TYPE_VBI)
+		cap->device_caps = cap->capabilities &
+			(V4L2_CAP_VBI_CAPTURE |
+			 V4L2_CAP_READWRITE |
+			 V4L2_CAP_STREAMING |
+			 V4L2_CAP_TUNER);
+	else {
+		cap->device_caps = V4L2_CAP_RADIO | V4L2_CAP_TUNER;
+		if (btv->has_saa6588)
+			cap->device_caps |= V4L2_CAP_READWRITE |
+						V4L2_CAP_RDS_CAPTURE;
+	}
 	return 0;
 }
 
@@ -3430,20 +3454,6 @@ static int radio_release(struct file *file)
 	return 0;
 }
 
-static int radio_querycap(struct file *file, void *priv,
-					struct v4l2_capability *cap)
-{
-	struct bttv_fh *fh = priv;
-	struct bttv *btv = fh->btv;
-
-	strcpy(cap->driver, "bttv");
-	strlcpy(cap->card, btv->radio_dev->name, sizeof(cap->card));
-	sprintf(cap->bus_info, "PCI:%s", pci_name(btv->c.pci));
-	cap->capabilities = V4L2_CAP_TUNER;
-
-	return 0;
-}
-
 static int radio_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
 	struct bttv_fh *fh = priv;
@@ -3464,29 +3474,6 @@ static int radio_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	return 0;
 }
 
-static int radio_enum_input(struct file *file, void *priv,
-				struct v4l2_input *i)
-{
-	if (i->index != 0)
-		return -EINVAL;
-
-	strcpy(i->name, "Radio");
-	i->type = V4L2_INPUT_TYPE_TUNER;
-
-	return 0;
-}
-
-static int radio_g_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
-{
-	if (unlikely(a->index))
-		return -EINVAL;
-
-	strcpy(a->name, "Radio");
-
-	return 0;
-}
-
 static int radio_s_tuner(struct file *file, void *priv,
 					struct v4l2_tuner *t)
 {
@@ -3500,28 +3487,6 @@ static int radio_s_tuner(struct file *file, void *priv,
 	return 0;
 }
 
-static int radio_s_audio(struct file *file, void *priv,
-					const struct v4l2_audio *a)
-{
-	if (unlikely(a->index))
-		return -EINVAL;
-
-	return 0;
-}
-
-static int radio_s_input(struct file *filp, void *priv, unsigned int i)
-{
-	if (unlikely(i))
-		return -EINVAL;
-
-	return 0;
-}
-
-static int radio_s_std(struct file *file, void *fh, v4l2_std_id *norm)
-{
-	return 0;
-}
-
 static int radio_queryctrl(struct file *file, void *priv,
 					struct v4l2_queryctrl *c)
 {
@@ -3540,12 +3505,6 @@ static int radio_queryctrl(struct file *file, void *priv,
 	return 0;
 }
 
-static int radio_g_input(struct file *filp, void *priv, unsigned int *i)
-{
-	*i = 0;
-	return 0;
-}
-
 static ssize_t radio_read(struct file *file, char __user *data,
 			 size_t count, loff_t *ppos)
 {
@@ -3586,16 +3545,10 @@ static const struct v4l2_file_operations radio_fops =
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
-	.vidioc_querycap        = radio_querycap,
+	.vidioc_querycap        = bttv_querycap,
 	.vidioc_g_tuner         = radio_g_tuner,
-	.vidioc_enum_input      = radio_enum_input,
-	.vidioc_g_audio         = radio_g_audio,
 	.vidioc_s_tuner         = radio_s_tuner,
-	.vidioc_s_audio         = radio_s_audio,
-	.vidioc_s_input         = radio_s_input,
-	.vidioc_s_std           = radio_s_std,
 	.vidioc_queryctrl       = radio_queryctrl,
-	.vidioc_g_input         = radio_g_input,
 	.vidioc_g_ctrl          = bttv_g_ctrl,
 	.vidioc_s_ctrl          = bttv_s_ctrl,
 	.vidioc_g_frequency     = bttv_g_frequency,
-- 
1.7.10.4

