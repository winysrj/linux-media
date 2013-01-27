Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:56349 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab3A0Tpd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 14:45:33 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/7] saa7134: v4l2-compliance: implement V4L2_CAP_DEVICE_CAPS
Date: Sun, 27 Jan 2013 20:45:06 +0100
Message-Id: <1359315912-1767-2-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make saa7134 driver more V4L2 compliant: implement V4L2_CAP_DEVICE_CAPS support
and fix all capabilities problems reported by v4l2-compliance.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/saa7134/saa7134-video.c |   55 ++++++++++++++++------------
 1 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 3abf527..ce15f1f 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1805,6 +1805,8 @@ static int saa7134_querycap(struct file *file, void  *priv,
 {
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
+	struct video_device *vdev = video_devdata(file);
+	u32 radio_caps, video_caps, vbi_caps;
 
 	unsigned int tuner_type = dev->tuner_type;
 
@@ -1812,19 +1814,37 @@ static int saa7134_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, saa7134_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
-	cap->capabilities =
-		V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_VBI_CAPTURE |
-		V4L2_CAP_READWRITE |
-		V4L2_CAP_STREAMING |
-		V4L2_CAP_TUNER;
+
+	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	if ((tuner_type != TUNER_ABSENT) && (tuner_type != UNSET))
+		cap->device_caps |= V4L2_CAP_TUNER;
+
+	radio_caps = V4L2_CAP_RADIO;
 	if (dev->has_rds)
-		cap->capabilities |= V4L2_CAP_RDS_CAPTURE;
+		radio_caps |= V4L2_CAP_RDS_CAPTURE;
+
+	video_caps = V4L2_CAP_VIDEO_CAPTURE;
 	if (saa7134_no_overlay <= 0)
-		cap->capabilities |= V4L2_CAP_VIDEO_OVERLAY;
+		video_caps |= V4L2_CAP_VIDEO_OVERLAY;
+
+	vbi_caps = V4L2_CAP_VBI_CAPTURE;
+
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_RADIO:
+		cap->device_caps |= radio_caps;
+		break;
+	case VFL_TYPE_GRABBER:
+		cap->device_caps |= video_caps;
+		break;
+	case VFL_TYPE_VBI:
+		cap->device_caps |= vbi_caps;
+		break;
+	}
+	cap->capabilities = radio_caps | video_caps | vbi_caps |
+		cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	if (vdev->vfl_type == VFL_TYPE_RADIO)
+		cap->device_caps &= ~(V4L2_CAP_READWRITE | V4L2_CAP_STREAMING);
 
-	if ((tuner_type == TUNER_ABSENT) || (tuner_type == UNSET))
-		cap->capabilities &= ~V4L2_CAP_TUNER;
 	return 0;
 }
 
@@ -2299,19 +2319,6 @@ static int vidioc_s_register (struct file *file, void *priv,
 }
 #endif
 
-static int radio_querycap(struct file *file, void *priv,
-					struct v4l2_capability *cap)
-{
-	struct saa7134_fh *fh = file->private_data;
-	struct saa7134_dev *dev = fh->dev;
-
-	strcpy(cap->driver, "saa7134");
-	strlcpy(cap->card, saa7134_boards[dev->board].name, sizeof(cap->card));
-	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
-	cap->capabilities = V4L2_CAP_TUNER;
-	return 0;
-}
-
 static int radio_g_tuner(struct file *file, void *priv,
 					struct v4l2_tuner *t)
 {
@@ -2473,7 +2480,7 @@ static const struct v4l2_file_operations radio_fops = {
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
-	.vidioc_querycap	= radio_querycap,
+	.vidioc_querycap	= saa7134_querycap,
 	.vidioc_g_tuner		= radio_g_tuner,
 	.vidioc_enum_input	= radio_enum_input,
 	.vidioc_g_audio		= radio_g_audio,
-- 
Ondrej Zary

