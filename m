Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3999 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbaHNJyS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:54:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 02/20] cx23885: fix audio input handling
Date: Thu, 14 Aug 2014 11:53:47 +0200
Message-Id: <1408010045-24016-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix a bunch of v4l2-compliance errors relating to audio input handling.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-video.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 2666ac4..79de4ac 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1153,7 +1153,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, cx23885_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
-	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING | V4L2_CAP_AUDIO;
 	if (dev->tuner_type != TUNER_ABSENT)
 		cap->device_caps |= V4L2_CAP_TUNER;
 	if (vdev->vfl_type == VFL_TYPE_VBI)
@@ -1302,16 +1302,16 @@ int cx23885_enum_input(struct cx23885_dev *dev, struct v4l2_input *i)
 	i->index = n;
 	i->type  = V4L2_INPUT_TYPE_CAMERA;
 	strcpy(i->name, iname[INPUT(n)->type]);
+	i->std = CX23885_NORMS;
 	if ((CX23885_VMUX_TELEVISION == INPUT(n)->type) ||
 		(CX23885_VMUX_CABLE == INPUT(n)->type)) {
 		i->type = V4L2_INPUT_TYPE_TUNER;
-		i->std = CX23885_NORMS;
+		i->audioset = 4;
+	} else {
+		/* Two selectable audio inputs for non-tv inputs */
+		i->audioset = 3;
 	}
 
-	/* Two selectable audio inputs for non-tv inputs */
-	if (INPUT(n)->type != CX23885_VMUX_TELEVISION)
-		i->audioset = 0x3;
-
 	if (dev->input == n) {
 		/* enum'd input matches our configured input.
 		 * Ask the video decoder to process the call
@@ -1397,19 +1397,19 @@ static int cx23885_query_audinput(struct file *file, void *priv,
 	static const char *iname[] = {
 		[0] = "Baseband L/R 1",
 		[1] = "Baseband L/R 2",
+		[2] = "TV",
 	};
 	unsigned int n;
 	dprintk(1, "%s()\n", __func__);
 
 	n = i->index;
-	if (n >= 2)
+	if (n >= 3)
 		return -EINVAL;
 
 	memset(i, 0, sizeof(*i));
 	i->index = n;
 	strcpy(i->name, iname[n]);
-	i->capability  = V4L2_AUDCAP_STEREO;
-	i->mode  = V4L2_AUDMODE_AVL;
+	i->capability = V4L2_AUDCAP_STEREO;
 	return 0;
 
 }
@@ -1425,7 +1425,11 @@ static int vidioc_g_audinput(struct file *file, void *priv,
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
 
-	i->index = dev->audinput;
+	if ((CX23885_VMUX_TELEVISION == INPUT(dev->input)->type) ||
+		(CX23885_VMUX_CABLE == INPUT(dev->input)->type))
+		i->index = 2;
+	else
+		i->index = dev->audinput;
 	dprintk(1, "%s(input=%d)\n", __func__, i->index);
 
 	return cx23885_query_audinput(file, priv, i);
@@ -1435,7 +1439,12 @@ static int vidioc_s_audinput(struct file *file, void *priv,
 	const struct v4l2_audio *i)
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
-	if (i->index >= 2)
+
+	if ((CX23885_VMUX_TELEVISION == INPUT(dev->input)->type) ||
+		(CX23885_VMUX_CABLE == INPUT(dev->input)->type)) {
+		return i->index != 2 ? -EINVAL : 0;
+	}
+	if (i->index > 1)
 		return -EINVAL;
 
 	dprintk(1, "%s(%d)\n", __func__, i->index);
-- 
2.1.0.rc1

