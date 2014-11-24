Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:47359 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbaKXJiV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 04:38:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Gerhard Sittig <gsi@denx.de>, Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 5/6] media/platform: fix querycap
Date: Mon, 24 Nov 2014 10:37:25 +0100
Message-Id: <1416821846-7677-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1416821846-7677-1-git-send-email-hverkuil@xs4all.nl>
References: <1416821846-7677-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Querycap shouldn't set the version field (the core does that for you),
but it should set the device_caps field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Gerhard Sittig <gsi@denx.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/blackfin/bfin_capture.c  | 3 ++-
 drivers/media/platform/fsl-viu.c                | 3 ++-
 drivers/media/platform/marvell-ccic/mcam-core.c | 4 ++--
 drivers/media/platform/mx2_emmaprp.c            | 9 ++-------
 drivers/media/platform/omap/omap_vout.c         | 3 ++-
 drivers/media/platform/sh_vou.c                 | 3 ++-
 drivers/media/platform/via-camera.c             | 4 ++--
 drivers/media/platform/vino.c                   | 6 ++----
 8 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index b3345b3..431c33d 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -841,7 +841,8 @@ static int bcap_querycap(struct file *file, void  *priv,
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
 
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	strlcpy(cap->driver, CAPTURE_DRV_NAME, sizeof(cap->driver));
 	strlcpy(cap->bus_info, "Blackfin Platform", sizeof(cap->bus_info));
 	strlcpy(cap->card, bcap_dev->cfg->card_name, sizeof(cap->card));
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index d5dc198..8afee3c 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -604,10 +604,11 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	strcpy(cap->driver, "viu");
 	strcpy(cap->card, "viu");
-	cap->capabilities =	V4L2_CAP_VIDEO_CAPTURE |
+	cap->device_caps =	V4L2_CAP_VIDEO_CAPTURE |
 				V4L2_CAP_STREAMING     |
 				V4L2_CAP_VIDEO_OVERLAY |
 				V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index f0eeb6c..5ef9579 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1413,9 +1413,9 @@ static int mcam_vidioc_querycap(struct file *file, void *priv,
 {
 	strcpy(cap->driver, "marvell_ccic");
 	strcpy(cap->card, "marvell_ccic");
-	cap->version = 1;
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 4971ff2..f923d1b 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -402,13 +402,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
 	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
-	/*
-	 * This is only a mem-to-mem video device. The capture and output
-	 * device capability flags are left only for backward compatibility
-	 * and are scheduled for removal.
-	 */
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
-			    V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 64ab6fb..d39e2b4 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1054,8 +1054,9 @@ static int vidioc_querycap(struct file *file, void *fh,
 	strlcpy(cap->driver, VOUT_NAME, sizeof(cap->driver));
 	strlcpy(cap->card, vout->vfd->name, sizeof(cap->card));
 	cap->bus_info[0] = '\0';
-	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT |
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT |
 		V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 0476696..154ef0b 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -396,7 +396,8 @@ static int sh_vou_querycap(struct file *file, void  *priv,
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	strlcpy(cap->card, "SuperH VOU", sizeof(cap->card));
-	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index 2616483..86989d8 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -985,9 +985,9 @@ static int viacam_querycap(struct file *filp, void *priv,
 {
 	strcpy(cap->driver, "via-camera");
 	strcpy(cap->card, "via-camera");
-	cap->version = 1;
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
diff --git a/drivers/media/platform/vino.c b/drivers/media/platform/vino.c
index 91d44ea1..2c85357 100644
--- a/drivers/media/platform/vino.c
+++ b/drivers/media/platform/vino.c
@@ -2932,10 +2932,8 @@ static int vino_querycap(struct file *file, void *__fh,
 	strcpy(cap->driver, vino_driver_name);
 	strcpy(cap->card, vino_driver_description);
 	strcpy(cap->bus_info, vino_bus_name);
-	cap->capabilities =
-		V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_STREAMING;
-	// V4L2_CAP_OVERLAY, V4L2_CAP_READWRITE
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-- 
2.1.3

