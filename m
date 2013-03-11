Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3752 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab3CKVBM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 17:01:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 14/15] au0828: fix initial video routing.
Date: Mon, 11 Mar 2013 22:00:45 +0100
Message-Id: <0352692461ec201f384048489532bd3790fbf6e0.1363035203.git.hans.verkuil@cisco.com>
In-Reply-To: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
References: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
References: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

After loading the module the initial video routing is not setup.
Explicitly call s_input to get this right.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-video.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 1f06d97..cc1e861 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1391,20 +1391,10 @@ static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 	return 0;
 }
 
-static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
+static void au0828_s_input(struct au0828_dev *dev, int index)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
 	int i;
 
-	dprintk(1, "VIDIOC_S_INPUT in function %s, input=%d\n", __func__,
-		index);
-	if (index >= AU0828_MAX_INPUT)
-		return -EINVAL;
-	if (AUVI_INPUT(index).type == 0)
-		return -EINVAL;
-	dev->ctrl_input = index;
-
 	switch (AUVI_INPUT(index).type) {
 	case AU0828_VMUX_SVIDEO:
 		dev->input_type = AU0828_VMUX_SVIDEO;
@@ -1419,7 +1409,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
 		dev->ctrl_ainput = 0;
 		break;
 	default:
-		dprintk(1, "VIDIOC_S_INPUT unknown input type set [%d]\n",
+		dprintk(1, "unknown input type set [%d]\n",
 			AUVI_INPUT(index).type);
 		break;
 	}
@@ -1450,6 +1440,21 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, audio, s_routing,
 			AUVI_INPUT(index).amux, 0, 0);
+}
+
+static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
+{
+	struct au0828_fh *fh = priv;
+	struct au0828_dev *dev = fh->dev;
+
+	dprintk(1, "VIDIOC_S_INPUT in function %s, input=%d\n", __func__,
+		index);
+	if (index >= AU0828_MAX_INPUT)
+		return -EINVAL;
+	if (AUVI_INPUT(index).type == 0)
+		return -EINVAL;
+	dev->ctrl_input = index;
+	au0828_s_input(dev, index);
 	return 0;
 }
 
@@ -1981,6 +1986,7 @@ int au0828_analog_register(struct au0828_dev *dev,
 	dev->ctrl_ainput = 0;
 	dev->ctrl_freq = 960;
 	dev->std = V4L2_STD_NTSC_M;
+	au0828_s_input(dev, 0);
 
 	/* allocate and fill v4l2 video struct */
 	dev->vdev = video_device_alloc();
-- 
1.7.10.4

