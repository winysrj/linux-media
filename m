Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:53862 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbcB2M5s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 07:57:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/2] vivid: let the v4l2 core calculate the capabilities field
Date: Mon, 29 Feb 2016 13:57:37 +0100
Message-Id: <1456750657-11108-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1456750657-11108-1-git-send-email-hverkuil@xs4all.nl>
References: <1456750657-11108-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2 core is now able to OR all the device_caps value of all
the video devices together in struct v4l2_device, so drop the
calculation of this field in vivid's querycap implementation.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c  | 75 ++++++++++++++++--------------
 drivers/media/platform/vivid/vivid-core.h  |  9 ----
 drivers/media/platform/vivid/vivid-ctrls.c |  8 ++--
 3 files changed, 43 insertions(+), 49 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index c14da84..fecfa07 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -205,11 +205,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strcpy(cap->card, "vivid");
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", dev->v4l2_dev.name);
-
-	cap->capabilities = dev->vid_cap_caps | dev->vid_out_caps |
-		dev->vbi_cap_caps | dev->vbi_out_caps |
-		dev->radio_rx_caps | dev->radio_tx_caps |
-		dev->sdr_cap_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
@@ -646,6 +641,14 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	struct vb2_queue *q;
 	unsigned node_type = node_types[inst];
 	v4l2_std_id tvnorms_cap = 0, tvnorms_out = 0;
+	/* capabilities */
+	u32 vid_cap_caps = 0;
+	u32 vid_out_caps = 0;
+	u32 vbi_cap_caps = 0;
+	u32 vbi_out_caps = 0;
+	u32 sdr_cap_caps = 0;
+	u32 radio_rx_caps = 0;
+	u32 radio_tx_caps = 0;
 	int ret;
 	int i;
 
@@ -771,58 +774,58 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 
 	if (dev->has_vid_cap) {
 		/* set up the capabilities of the video capture device */
-		dev->vid_cap_caps = dev->multiplanar ?
+		vid_cap_caps = dev->multiplanar ?
 			V4L2_CAP_VIDEO_CAPTURE_MPLANE :
 			V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OVERLAY;
-		dev->vid_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		vid_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
 		if (dev->has_audio_inputs)
-			dev->vid_cap_caps |= V4L2_CAP_AUDIO;
+			vid_cap_caps |= V4L2_CAP_AUDIO;
 		if (in_type_counter[TV])
-			dev->vid_cap_caps |= V4L2_CAP_TUNER;
+			vid_cap_caps |= V4L2_CAP_TUNER;
 	}
 	if (dev->has_vid_out) {
 		/* set up the capabilities of the video output device */
-		dev->vid_out_caps = dev->multiplanar ?
+		vid_out_caps = dev->multiplanar ?
 			V4L2_CAP_VIDEO_OUTPUT_MPLANE :
 			V4L2_CAP_VIDEO_OUTPUT;
 		if (dev->has_fb)
-			dev->vid_out_caps |= V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
-		dev->vid_out_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+			vid_out_caps |= V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
+		vid_out_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
 		if (dev->has_audio_outputs)
-			dev->vid_out_caps |= V4L2_CAP_AUDIO;
+			vid_out_caps |= V4L2_CAP_AUDIO;
 	}
 	if (dev->has_vbi_cap) {
 		/* set up the capabilities of the vbi capture device */
-		dev->vbi_cap_caps = (dev->has_raw_vbi_cap ? V4L2_CAP_VBI_CAPTURE : 0) |
-				    (dev->has_sliced_vbi_cap ? V4L2_CAP_SLICED_VBI_CAPTURE : 0);
-		dev->vbi_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		vbi_cap_caps = (dev->has_raw_vbi_cap ? V4L2_CAP_VBI_CAPTURE : 0) |
+			       (dev->has_sliced_vbi_cap ? V4L2_CAP_SLICED_VBI_CAPTURE : 0);
+		vbi_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
 		if (dev->has_audio_inputs)
-			dev->vbi_cap_caps |= V4L2_CAP_AUDIO;
+			vbi_cap_caps |= V4L2_CAP_AUDIO;
 		if (in_type_counter[TV])
-			dev->vbi_cap_caps |= V4L2_CAP_TUNER;
+			vbi_cap_caps |= V4L2_CAP_TUNER;
 	}
 	if (dev->has_vbi_out) {
 		/* set up the capabilities of the vbi output device */
-		dev->vbi_out_caps = (dev->has_raw_vbi_out ? V4L2_CAP_VBI_OUTPUT : 0) |
-				    (dev->has_sliced_vbi_out ? V4L2_CAP_SLICED_VBI_OUTPUT : 0);
-		dev->vbi_out_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		vbi_out_caps = (dev->has_raw_vbi_out ? V4L2_CAP_VBI_OUTPUT : 0) |
+			       (dev->has_sliced_vbi_out ? V4L2_CAP_SLICED_VBI_OUTPUT : 0);
+		vbi_out_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
 		if (dev->has_audio_outputs)
-			dev->vbi_out_caps |= V4L2_CAP_AUDIO;
+			vbi_out_caps |= V4L2_CAP_AUDIO;
 	}
 	if (dev->has_sdr_cap) {
 		/* set up the capabilities of the sdr capture device */
-		dev->sdr_cap_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER;
-		dev->sdr_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		sdr_cap_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER;
+		sdr_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
 	}
 	/* set up the capabilities of the radio receiver device */
 	if (dev->has_radio_rx)
-		dev->radio_rx_caps = V4L2_CAP_RADIO | V4L2_CAP_RDS_CAPTURE |
-				     V4L2_CAP_HW_FREQ_SEEK | V4L2_CAP_TUNER |
-				     V4L2_CAP_READWRITE;
+		radio_rx_caps = V4L2_CAP_RADIO | V4L2_CAP_RDS_CAPTURE |
+				V4L2_CAP_HW_FREQ_SEEK | V4L2_CAP_TUNER |
+				V4L2_CAP_READWRITE;
 	/* set up the capabilities of the radio transmitter device */
 	if (dev->has_radio_tx)
-		dev->radio_tx_caps = V4L2_CAP_RDS_OUTPUT | V4L2_CAP_MODULATOR |
-				     V4L2_CAP_READWRITE;
+		radio_tx_caps = V4L2_CAP_RDS_OUTPUT | V4L2_CAP_MODULATOR |
+				V4L2_CAP_READWRITE;
 
 	/* initialize the test pattern generator */
 	tpg_init(&dev->tpg, 640, 360);
@@ -1120,7 +1123,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		strlcpy(vfd->name, "vivid-vid-cap", sizeof(vfd->name));
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
-		vfd->device_caps = dev->vid_cap_caps;
+		vfd->device_caps = vid_cap_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->queue = &dev->vb_vid_cap_q;
@@ -1146,7 +1149,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->vfl_dir = VFL_DIR_TX;
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
-		vfd->device_caps = dev->vid_out_caps;
+		vfd->device_caps = vid_out_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->queue = &dev->vb_vid_out_q;
@@ -1171,7 +1174,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		strlcpy(vfd->name, "vivid-vbi-cap", sizeof(vfd->name));
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
-		vfd->device_caps = dev->vbi_cap_caps;
+		vfd->device_caps = vbi_cap_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->queue = &dev->vb_vbi_cap_q;
@@ -1195,7 +1198,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->vfl_dir = VFL_DIR_TX;
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
-		vfd->device_caps = dev->vbi_out_caps;
+		vfd->device_caps = vbi_out_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->queue = &dev->vb_vbi_out_q;
@@ -1218,7 +1221,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		strlcpy(vfd->name, "vivid-sdr-cap", sizeof(vfd->name));
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
-		vfd->device_caps = dev->sdr_cap_caps;
+		vfd->device_caps = sdr_cap_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->queue = &dev->vb_sdr_cap_q;
@@ -1237,7 +1240,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		strlcpy(vfd->name, "vivid-rad-rx", sizeof(vfd->name));
 		vfd->fops = &vivid_radio_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
-		vfd->device_caps = dev->radio_rx_caps;
+		vfd->device_caps = radio_rx_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->lock = &dev->mutex;
@@ -1256,7 +1259,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->vfl_dir = VFL_DIR_TX;
 		vfd->fops = &vivid_radio_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
-		vfd->device_caps = dev->radio_tx_caps;
+		vfd->device_caps = radio_tx_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->lock = &dev->mutex;
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 751c1ba..4c0834f 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -158,15 +158,6 @@ struct vivid_dev {
 	spinlock_t			slock;
 	struct mutex			mutex;
 
-	/* capabilities */
-	u32				vid_cap_caps;
-	u32				vid_out_caps;
-	u32				vbi_cap_caps;
-	u32				vbi_out_caps;
-	u32				sdr_cap_caps;
-	u32				radio_rx_caps;
-	u32				radio_tx_caps;
-
 	/* supported features */
 	bool				multiplanar;
 	unsigned			num_inputs;
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index b98089c..99fe3c4 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -1149,10 +1149,10 @@ static int vivid_radio_rx_s_ctrl(struct v4l2_ctrl *ctrl)
 		break;
 	case VIVID_CID_RADIO_RX_RDS_BLOCKIO:
 		dev->radio_rx_rds_controls = ctrl->val;
-		dev->radio_rx_caps &= ~V4L2_CAP_READWRITE;
+		dev->radio_rx_dev.device_caps &= ~V4L2_CAP_READWRITE;
 		dev->radio_rx_rds_use_alternates = false;
 		if (!dev->radio_rx_rds_controls) {
-			dev->radio_rx_caps |= V4L2_CAP_READWRITE;
+			dev->radio_rx_dev.device_caps |= V4L2_CAP_READWRITE;
 			__v4l2_ctrl_s_ctrl(dev->radio_rx_rds_pty, 0);
 			__v4l2_ctrl_s_ctrl(dev->radio_rx_rds_ta, 0);
 			__v4l2_ctrl_s_ctrl(dev->radio_rx_rds_tp, 0);
@@ -1237,9 +1237,9 @@ static int vivid_radio_tx_s_ctrl(struct v4l2_ctrl *ctrl)
 	switch (ctrl->id) {
 	case VIVID_CID_RADIO_TX_RDS_BLOCKIO:
 		dev->radio_tx_rds_controls = ctrl->val;
-		dev->radio_tx_caps &= ~V4L2_CAP_READWRITE;
+		dev->radio_tx_dev.device_caps &= ~V4L2_CAP_READWRITE;
 		if (!dev->radio_tx_rds_controls)
-			dev->radio_tx_caps |= V4L2_CAP_READWRITE;
+			dev->radio_tx_dev.device_caps |= V4L2_CAP_READWRITE;
 		break;
 	case V4L2_CID_RDS_TX_PTY:
 		if (dev->radio_rx_rds_controls)
-- 
2.7.0

