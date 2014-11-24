Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33306 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867AbaKXJia (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 04:38:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 6/6] media/platform: fix querycap
Date: Mon, 24 Nov 2014 10:37:26 +0100
Message-Id: <1416821846-7677-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1416821846-7677-1-git-send-email-hverkuil@xs4all.nl>
References: <1416821846-7677-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Querycap shouldn't set the version field (the core does that for you),
but it should set the device_caps field.

In addition, remove the CAPTURE and OUTPUT caps for M2M devices. These
were already slated for removal, so it's time to do so.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Kamil Debski <k.debski@samsung.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>
---
 drivers/media/platform/davinci/vpbe_display.c |  1 -
 drivers/media/platform/davinci/vpfe_capture.c |  4 ++--
 drivers/media/platform/s5p-g2d/g2d.c          | 10 ++--------
 drivers/media/platform/s5p-jpeg/jpeg-core.c   |  9 ++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |  6 ++----
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c  |  6 ++----
 6 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 78b9ffe..21a5a56 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -639,7 +639,6 @@ static int vpbe_display_querycap(struct file *file, void  *priv,
 	struct vpbe_layer *layer = video_drvdata(file);
 	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 
-	cap->version = VPBE_DISPLAY_VERSION_CODE;
 	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	snprintf(cap->driver, sizeof(cap->driver), "%s",
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 3d0e3ae..271c460 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -930,8 +930,8 @@ static int vpfe_querycap(struct file *file, void  *priv,
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_querycap\n");
 
-	cap->version = VPFE_CAPTURE_VERSION_CODE;
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	strlcpy(cap->driver, CAPTURE_DRV_NAME, sizeof(cap->driver));
 	strlcpy(cap->bus_info, "VPFE", sizeof(cap->bus_info));
 	strlcpy(cap->card, vpfe_dev->cfg->card_name, sizeof(cap->card));
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index d79e214..51e4edc 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -297,14 +297,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->driver, G2D_NAME, sizeof(cap->driver) - 1);
 	strncpy(cap->card, G2D_NAME, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
-	cap->version = KERNEL_VERSION(1, 0, 0);
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
 
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 6fcc7f0..d6f75b1 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1001,13 +1001,8 @@ static int s5p_jpeg_querycap(struct file *file, void *priv,
 			sizeof(cap->card));
 	}
 	cap->bus_info[0] = 0;
-	/*
-	 * This is only a mem-to-mem video device. The capture and output
-	 * device capability flags are left only for backward compatibility
-	 * and are scheduled for removal.
-	 */
-	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M |
-			    V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT;
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 74bcec8..c6c3452 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -269,15 +269,13 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->driver, dev->plat_dev->name, sizeof(cap->driver) - 1);
 	strncpy(cap->card, dev->plat_dev->name, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
-	cap->version = KERNEL_VERSION(1, 0, 0);
 	/*
 	 * This is only a mem-to-mem video device. The capture and output
 	 * device capability flags are left only for backward compatibility
 	 * and are scheduled for removal.
 	 */
-	cap->capabilities = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING |
-			    V4L2_CAP_VIDEO_CAPTURE_MPLANE |
-			    V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+	cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index e7240cb..bd64f1d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -947,15 +947,13 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->driver, dev->plat_dev->name, sizeof(cap->driver) - 1);
 	strncpy(cap->card, dev->plat_dev->name, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
-	cap->version = KERNEL_VERSION(1, 0, 0);
 	/*
 	 * This is only a mem-to-mem video device. The capture and output
 	 * device capability flags are left only for backward compatibility
 	 * and are scheduled for removal.
 	 */
-	cap->capabilities = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING |
-			    V4L2_CAP_VIDEO_CAPTURE_MPLANE |
-			    V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+	cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-- 
2.1.3

