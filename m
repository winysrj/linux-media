Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44849 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbcCAO5Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2016 09:57:25 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 7/8] vivid: set device_caps in video_device.
Date: Tue,  1 Mar 2016 16:57:25 +0200
Message-Id: <1456844246-18778-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This simplifies the querycap function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vivid/vivid-core.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index ec125becb7af..c14da84af09b 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -200,27 +200,12 @@ static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
 	struct vivid_dev *dev = video_drvdata(file);
-	struct video_device *vdev = video_devdata(file);
 
 	strcpy(cap->driver, "vivid");
 	strcpy(cap->card, "vivid");
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", dev->v4l2_dev.name);
 
-	if (vdev->vfl_type == VFL_TYPE_GRABBER && vdev->vfl_dir == VFL_DIR_RX)
-		cap->device_caps = dev->vid_cap_caps;
-	if (vdev->vfl_type == VFL_TYPE_GRABBER && vdev->vfl_dir == VFL_DIR_TX)
-		cap->device_caps = dev->vid_out_caps;
-	else if (vdev->vfl_type == VFL_TYPE_VBI && vdev->vfl_dir == VFL_DIR_RX)
-		cap->device_caps = dev->vbi_cap_caps;
-	else if (vdev->vfl_type == VFL_TYPE_VBI && vdev->vfl_dir == VFL_DIR_TX)
-		cap->device_caps = dev->vbi_out_caps;
-	else if (vdev->vfl_type == VFL_TYPE_SDR)
-		cap->device_caps = dev->sdr_cap_caps;
-	else if (vdev->vfl_type == VFL_TYPE_RADIO && vdev->vfl_dir == VFL_DIR_RX)
-		cap->device_caps = dev->radio_rx_caps;
-	else if (vdev->vfl_type == VFL_TYPE_RADIO && vdev->vfl_dir == VFL_DIR_TX)
-		cap->device_caps = dev->radio_tx_caps;
 	cap->capabilities = dev->vid_cap_caps | dev->vid_out_caps |
 		dev->vbi_cap_caps | dev->vbi_out_caps |
 		dev->radio_rx_caps | dev->radio_tx_caps |
@@ -1135,6 +1120,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		strlcpy(vfd->name, "vivid-vid-cap", sizeof(vfd->name));
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
+		vfd->device_caps = dev->vid_cap_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->queue = &dev->vb_vid_cap_q;
@@ -1160,6 +1146,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->vfl_dir = VFL_DIR_TX;
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
+		vfd->device_caps = dev->vid_out_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->queue = &dev->vb_vid_out_q;
@@ -1184,6 +1171,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		strlcpy(vfd->name, "vivid-vbi-cap", sizeof(vfd->name));
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
+		vfd->device_caps = dev->vbi_cap_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->queue = &dev->vb_vbi_cap_q;
@@ -1207,6 +1195,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->vfl_dir = VFL_DIR_TX;
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
+		vfd->device_caps = dev->vbi_out_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->queue = &dev->vb_vbi_out_q;
@@ -1229,6 +1218,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		strlcpy(vfd->name, "vivid-sdr-cap", sizeof(vfd->name));
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
+		vfd->device_caps = dev->sdr_cap_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->queue = &dev->vb_sdr_cap_q;
@@ -1247,6 +1237,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		strlcpy(vfd->name, "vivid-rad-rx", sizeof(vfd->name));
 		vfd->fops = &vivid_radio_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
+		vfd->device_caps = dev->radio_rx_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->lock = &dev->mutex;
@@ -1265,6 +1256,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->vfl_dir = VFL_DIR_TX;
 		vfd->fops = &vivid_radio_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
+		vfd->device_caps = dev->radio_tx_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->lock = &dev->mutex;
-- 
2.4.10

