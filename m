Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:47359 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbaKXJiE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 04:38:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/6] media/usb,pci: fix querycap
Date: Mon, 24 Nov 2014 10:37:23 +0100
Message-Id: <1416821846-7677-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1416821846-7677-1-git-send-email-hverkuil@xs4all.nl>
References: <1416821846-7677-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Querycap shouldn't set the version field (the core does that for you),
but it should set the device_caps field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/meye/meye.c                 | 3 ---
 drivers/media/pci/zoran/zoran_driver.c        | 5 +++--
 drivers/media/usb/usbvision/usbvision-video.c | 3 ++-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index aeae547..9d9f90c 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1031,9 +1031,6 @@ static int vidioc_querycap(struct file *file, void *fh,
 	strcpy(cap->card, "meye");
 	sprintf(cap->bus_info, "PCI:%s", pci_name(meye.mchip_dev));
 
-	cap->version = (MEYE_DRIVER_MAJORVERSION << 8) +
-		       MEYE_DRIVER_MINORVERSION;
-
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
 			    V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 099d5fb..2b25d31 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -1528,8 +1528,9 @@ static int zoran_querycap(struct file *file, void *__fh, struct v4l2_capability
 	strncpy(cap->driver, "zoran", sizeof(cap->driver)-1);
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(zr->pci_dev));
-	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE |
-			    V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OVERLAY;
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE |
+			   V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OVERLAY;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 9bfa041..693d5f4 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -509,11 +509,12 @@ static int vidioc_querycap(struct file *file, void  *priv,
 		usbvision_device_data[usbvision->dev_model].model_string,
 		sizeof(vc->card));
 	usb_make_path(usbvision->dev, vc->bus_info, sizeof(vc->bus_info));
-	vc->capabilities = V4L2_CAP_VIDEO_CAPTURE |
+	vc->device_caps = V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_AUDIO |
 		V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING |
 		(usbvision->have_tuner ? V4L2_CAP_TUNER : 0);
+	vc->capabilities = vc->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-- 
2.1.3

