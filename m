Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3856 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab2EKHzn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 16/16] av7110: fix v4l2_compliance test issues.
Date: Fri, 11 May 2012 09:55:10 +0200
Message-Id: <c9992d20b33df8a58d238ceb9eeca1bdc7833231.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Besides the usual inconsistencies in input enumeration there was also a
kernel crash if you tried to poll on a vbi node. The checks for sliced
vbi output vs vbi capture were not complete enough.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146_fops.c  |    4 +++
 drivers/media/common/saa7146_video.c |    4 +--
 drivers/media/dvb/ttpci/av7110_v4l.c |   48 +++++++++++++++++++++++++---------
 3 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index 9242ec7..965313b 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -309,6 +309,8 @@ static int fops_mmap(struct file *file, struct vm_area_struct * vma)
 	case VFL_TYPE_VBI: {
 		DEB_EE("V4L2_BUF_TYPE_VBI_CAPTURE: file:%p, vma:%p\n",
 		       file, vma);
+		if (fh->dev->ext_vv_data->capabilities & V4L2_CAP_SLICED_VBI_OUTPUT)
+			return -ENODEV;
 		q = &fh->vbi_q;
 		break;
 		}
@@ -331,6 +333,8 @@ static unsigned int fops_poll(struct file *file, struct poll_table_struct *wait)
 	DEB_EE("file:%p, poll:%p\n", file, wait);
 
 	if (vdev->vfl_type == VFL_TYPE_VBI) {
+		if (fh->dev->ext_vv_data->capabilities & V4L2_CAP_SLICED_VBI_OUTPUT)
+			return res | POLLOUT | POLLWRNORM;
 		if( 0 == fh->vbi_q.streaming )
 			return res | videobuf_poll_stream(file, &fh->vbi_q, wait);
 		q = &fh->vbi_q;
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index 9d19320..6d14785 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -458,13 +458,13 @@ static int vidioc_querycap(struct file *file, void *fh, struct v4l2_capability *
 		V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING;
 	cap->device_caps |= dev->ext_vv_data->capabilities;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	if (vdev->vfl_type == VFL_TYPE_GRABBER)
 		cap->device_caps &=
 			~(V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_OUTPUT);
 	else
 		cap->device_caps &=
-			~(V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OVERLAY);
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+			~(V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OVERLAY | V4L2_CAP_AUDIO);
 	return 0;
 }
 
diff --git a/drivers/media/dvb/ttpci/av7110_v4l.c b/drivers/media/dvb/ttpci/av7110_v4l.c
index 3b7a624..1b2d151 100644
--- a/drivers/media/dvb/ttpci/av7110_v4l.c
+++ b/drivers/media/dvb/ttpci/av7110_v4l.c
@@ -107,7 +107,7 @@ static struct v4l2_input inputs[4] = {
 		.index		= 1,
 		.name		= "Television",
 		.type		= V4L2_INPUT_TYPE_TUNER,
-		.audioset	= 2,
+		.audioset	= 1,
 		.tuner		= 0,
 		.std		= V4L2_STD_PAL_BG|V4L2_STD_NTSC_M,
 		.status		= 0,
@@ -494,7 +494,7 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 	dprintk(2, "VIDIOC_S_INPUT: %d\n", input);
 
 	if (!av7110->analog_tuner_flags)
-		return 0;
+		return input ? -EINVAL : 0;
 
 	if (input >= 4)
 		return -EINVAL;
@@ -503,19 +503,38 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 	return av7110_dvb_c_switch(fh);
 }
 
+static int vidioc_enumaudio(struct file *file, void *fh, struct v4l2_audio *a)
+{
+	dprintk(2, "VIDIOC_G_AUDIO: %d\n", a->index);
+	if (a->index != 0)
+		return -EINVAL;
+	*a = msp3400_v4l2_audio;
+	return 0;
+}
+
 static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
 {
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct av7110 *av7110 = (struct av7110 *)dev->ext_priv;
+
 	dprintk(2, "VIDIOC_G_AUDIO: %d\n", a->index);
 	if (a->index != 0)
 		return -EINVAL;
-	memcpy(a, &msp3400_v4l2_audio, sizeof(struct v4l2_audio));
+	if (av7110->current_input >= 2)
+		return -EINVAL;
+	*a = msp3400_v4l2_audio;
 	return 0;
 }
 
 static int vidioc_s_audio(struct file *file, void *fh, struct v4l2_audio *a)
 {
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct av7110 *av7110 = (struct av7110 *)dev->ext_priv;
+
 	dprintk(2, "VIDIOC_S_AUDIO: %d\n", a->index);
-	return 0;
+	if (av7110->current_input >= 2)
+		return -EINVAL;
+	return a->index ? -EINVAL : 0;
 }
 
 static int vidioc_g_sliced_vbi_cap(struct file *file, void *fh,
@@ -809,29 +828,32 @@ int av7110_init_v4l(struct av7110 *av7110)
 	vv_data->vid_ops.vidioc_s_tuner = vidioc_s_tuner;
 	vv_data->vid_ops.vidioc_g_frequency = vidioc_g_frequency;
 	vv_data->vid_ops.vidioc_s_frequency = vidioc_s_frequency;
+	vv_data->vid_ops.vidioc_enumaudio = vidioc_enumaudio;
 	vv_data->vid_ops.vidioc_g_audio = vidioc_g_audio;
 	vv_data->vid_ops.vidioc_s_audio = vidioc_s_audio;
+	vv_data->vid_ops.vidioc_g_fmt_vbi_cap = NULL;
 
-	vv_data->vbi_ops.vidioc_enum_input = vidioc_enum_input;
-	vv_data->vbi_ops.vidioc_g_input = vidioc_g_input;
-	vv_data->vbi_ops.vidioc_s_input = vidioc_s_input;
 	vv_data->vbi_ops.vidioc_g_tuner = vidioc_g_tuner;
 	vv_data->vbi_ops.vidioc_s_tuner = vidioc_s_tuner;
 	vv_data->vbi_ops.vidioc_g_frequency = vidioc_g_frequency;
 	vv_data->vbi_ops.vidioc_s_frequency = vidioc_s_frequency;
-	vv_data->vbi_ops.vidioc_g_audio = vidioc_g_audio;
-	vv_data->vbi_ops.vidioc_s_audio = vidioc_s_audio;
+	vv_data->vbi_ops.vidioc_g_fmt_vbi_cap = NULL;
 	vv_data->vbi_ops.vidioc_g_sliced_vbi_cap = vidioc_g_sliced_vbi_cap;
 	vv_data->vbi_ops.vidioc_g_fmt_sliced_vbi_out = vidioc_g_fmt_sliced_vbi_out;
 	vv_data->vbi_ops.vidioc_s_fmt_sliced_vbi_out = vidioc_s_fmt_sliced_vbi_out;
 
+	if (FW_VERSION(av7110->arm_app) < 0x2623)
+		vv_data->capabilities &= ~V4L2_CAP_SLICED_VBI_OUTPUT;
+
 	if (saa7146_register_device(&av7110->v4l_dev, dev, "av7110", VFL_TYPE_GRABBER)) {
 		ERR("cannot register capture device. skipping\n");
 		saa7146_vv_release(dev);
 		return -ENODEV;
 	}
-	if (saa7146_register_device(&av7110->vbi_dev, dev, "av7110", VFL_TYPE_VBI))
-		ERR("cannot register vbi v4l2 device. skipping\n");
+	if (FW_VERSION(av7110->arm_app) >= 0x2623) {
+		if (saa7146_register_device(&av7110->vbi_dev, dev, "av7110", VFL_TYPE_VBI))
+			ERR("cannot register vbi v4l2 device. skipping\n");
+	}
 	return 0;
 }
 
@@ -915,7 +937,7 @@ static int std_callback(struct saa7146_dev* dev, struct saa7146_standard *std)
 static struct saa7146_ext_vv av7110_vv_data_st = {
 	.inputs		= 1,
 	.audios		= 1,
-	.capabilities	= V4L2_CAP_SLICED_VBI_OUTPUT,
+	.capabilities	= V4L2_CAP_SLICED_VBI_OUTPUT | V4L2_CAP_AUDIO,
 	.flags		= 0,
 
 	.stds		= &standard[0],
@@ -930,7 +952,7 @@ static struct saa7146_ext_vv av7110_vv_data_st = {
 static struct saa7146_ext_vv av7110_vv_data_c = {
 	.inputs		= 1,
 	.audios		= 1,
-	.capabilities	= V4L2_CAP_TUNER | V4L2_CAP_SLICED_VBI_OUTPUT,
+	.capabilities	= V4L2_CAP_TUNER | V4L2_CAP_SLICED_VBI_OUTPUT | V4L2_CAP_AUDIO,
 	.flags		= SAA7146_USE_PORT_B_FOR_VBI,
 
 	.stds		= &standard[0],
-- 
1.7.10

