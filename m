Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59069 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbbASWTO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 17:19:14 -0500
Date: Mon, 19 Jan 2015 23:19:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] soc-camera: fix device capabilities in multiple camera host
 drivers
Message-ID: <Pine.LNX.4.64.1501192316550.1903@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 API requires both .capabilities and .device_caps fields of
struct v4l2_capability to be set. Otherwise the compliance checker
complains and since commit "v4l2-ioctl: WARN_ON if querycap didn't fill
device_caps" a compile-time warning is issued. Fix this non-compliance
in several soc-camera camera host drivers.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Only compile tested on one platform. Would be nice to have a slightly 
wider test coverage. I'll try to do some more verification too, then send 
out as a fix for 3.19 in a day or two.

 drivers/media/platform/soc_camera/atmel-isi.c            | 5 +++--
 drivers/media/platform/soc_camera/mx2_camera.c           | 3 ++-
 drivers/media/platform/soc_camera/mx3_camera.c           | 3 ++-
 drivers/media/platform/soc_camera/omap1_camera.c         | 3 ++-
 drivers/media/platform/soc_camera/pxa_camera.c           | 3 ++-
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 4 +++-
 6 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 8efe403..6d88523 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -760,8 +760,9 @@ static int isi_camera_querycap(struct soc_camera_host *ici,
 {
 	strcpy(cap->driver, "atmel-isi");
 	strcpy(cap->card, "Atmel Image Sensor Interface");
-	cap->capabilities = (V4L2_CAP_VIDEO_CAPTURE |
-				V4L2_CAP_STREAMING);
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index ce72bd2..192377f 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1256,7 +1256,8 @@ static int mx2_camera_querycap(struct soc_camera_host *ici,
 {
 	/* cap->name is set by the friendly caller:-> */
 	strlcpy(cap->card, MX2_CAM_DRIVER_DESCRIPTION, sizeof(cap->card));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index a60c3bb..0b3299d 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -967,7 +967,8 @@ static int mx3_camera_querycap(struct soc_camera_host *ici,
 {
 	/* cap->name is set by the firendly caller:-> */
 	strlcpy(cap->card, "i.MX3x Camera", sizeof(cap->card));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index e6b9328..16f65ec 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -1427,7 +1427,8 @@ static int omap1_cam_querycap(struct soc_camera_host *ici,
 {
 	/* cap->name is set by the friendly caller:-> */
 	strlcpy(cap->card, "OMAP1 Camera", sizeof(cap->card));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 951226a..8d6e343 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1576,7 +1576,8 @@ static int pxa_camera_querycap(struct soc_camera_host *ici,
 {
 	/* cap->name is set by the firendly caller:-> */
 	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 8b27b3e..7178770 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1652,7 +1652,9 @@ static int sh_mobile_ceu_querycap(struct soc_camera_host *ici,
 				  struct v4l2_capability *cap)
 {
 	strlcpy(cap->card, "SuperH_Mobile_CEU", sizeof(cap->card));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
 	return 0;
 }
 
-- 
1.9.3

