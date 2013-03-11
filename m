Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1717 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab3CKVBI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 17:01:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 05/15] au0828: fix audio input handling.
Date: Mon, 11 Mar 2013 22:00:36 +0100
Message-Id: <9c96cd9c23dc28b9165702f73c9cd7b2d3e76cdd.1363035203.git.hans.verkuil@cisco.com>
In-Reply-To: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
References: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
References: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- V4L2_CAP_AUDIO was set, but enumaudio was not implemented.
- audioset was never filled by enum_input
- ctrl_ainput was never updated when switching the video input
- g_audio was broken due to faulty logic: g_audio should set the
  index, it doesn't receive it from the user.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-video.c |   35 +++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index e3d8a3c..e4a24fa 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1373,10 +1373,13 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	input->index = tmp;
 	strcpy(input->name, inames[AUVI_INPUT(tmp).type]);
 	if ((AUVI_INPUT(tmp).type == AU0828_VMUX_TELEVISION) ||
-	    (AUVI_INPUT(tmp).type == AU0828_VMUX_CABLE))
+	    (AUVI_INPUT(tmp).type == AU0828_VMUX_CABLE)) {
 		input->type |= V4L2_INPUT_TYPE_TUNER;
-	else
+		input->audioset = 1;
+	} else {
 		input->type |= V4L2_INPUT_TYPE_CAMERA;
+		input->audioset = 2;
+	}
 
 	input->std = dev->vdev->tvnorms;
 
@@ -1408,12 +1411,15 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
 	switch (AUVI_INPUT(index).type) {
 	case AU0828_VMUX_SVIDEO:
 		dev->input_type = AU0828_VMUX_SVIDEO;
+		dev->ctrl_ainput = 1;
 		break;
 	case AU0828_VMUX_COMPOSITE:
 		dev->input_type = AU0828_VMUX_COMPOSITE;
+		dev->ctrl_ainput = 1;
 		break;
 	case AU0828_VMUX_TELEVISION:
 		dev->input_type = AU0828_VMUX_TELEVISION;
+		dev->ctrl_ainput = 0;
 		break;
 	default:
 		dprintk(1, "VIDIOC_S_INPUT unknown input type set [%d]\n",
@@ -1450,23 +1456,32 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
 	return 0;
 }
 
+static int vidioc_enumaudio(struct file *file, void *priv, struct v4l2_audio *a)
+{
+	if (a->index > 1)
+		return -EINVAL;
+
+	if (a->index == 0)
+		strcpy(a->name, "Television");
+	else
+		strcpy(a->name, "Line in");
+
+	a->capability = V4L2_AUDCAP_STEREO;
+	return 0;
+}
+
 static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 {
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
-	unsigned int index = a->index;
 
-	if (a->index > 1)
-		return -EINVAL;
-
-	index = dev->ctrl_ainput;
-	if (index == 0)
+	a->index = dev->ctrl_ainput;
+	if (a->index == 0)
 		strcpy(a->name, "Television");
 	else
 		strcpy(a->name, "Line in");
 
 	a->capability = V4L2_AUDCAP_STEREO;
-	a->index = index;
 	return 0;
 }
 
@@ -1474,6 +1489,7 @@ static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio
 {
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
+
 	if (a->index != dev->ctrl_ainput)
 		return -EINVAL;
 	return 0;
@@ -1876,6 +1892,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_fmt_vid_cap       = vidioc_s_fmt_vid_cap,
 	.vidioc_g_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
 	.vidioc_s_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
+	.vidioc_enumaudio           = vidioc_enumaudio,
 	.vidioc_g_audio             = vidioc_g_audio,
 	.vidioc_s_audio             = vidioc_s_audio,
 	.vidioc_cropcap             = vidioc_cropcap,
-- 
1.7.10.4

