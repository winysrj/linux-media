Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:59176 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZCBATk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2009 19:19:40 -0500
MIME-Version: 1.0
Date: Mon, 2 Mar 2009 09:19:38 +0900
Message-ID: <5e9665e10903011619h60385bcs75e828f5017a0434@mail.gmail.com>
Subject: [OMAPZOOM][PATCH] CAM: Make omap3 camera interface driver more
	generic for external camera devices.
From: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: dongsoo45.kim@samsung.com, sameerv@ti.com, mjalori@ti.com,
	Sakari Ailus <Sakari.Ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

 Since I was working on omap3 and external ISP device, I found some
hard coded thing in camera interface codes which make dependency on
sensor or ISP device. With that code, we cannot make omap3 camera
interface driver generic for every target board.
It makes dependency on camera device mounted on target board, and
therefore we need to modify omap3 camera interface driver when we do
our porting job.

 Please find following patch which I tried to make more generic for
omap3 camera interface driver. Just designate expecting colorspace
from external camera module in board file, then no need to modify
try_pix_parm() function.
Any comments will be welcomed.

Cheers,

Nate


>From f8062b8678fa8f8d9e694fb796431cf340112fa3 Mon Sep 17 00:00:00 2001
From: Dongsoo Kim <dongsoo45.kim@samsung.com>
Date: Thu, 26 Feb 2009 20:32:18 +0900
Subject: [PATCH] CAM: Make try_pix_parm() negotiable with board
specific sensor config.
 Removed hard coded pixelformat in camera interface driver

Signed-off-by: Dongsoo Kim <dongsoo45.kim@samsung.com>
---
 arch/arm/mach-omap2/board-3430sdp.c |    6 ++++++
 arch/arm/mach-omap2/board-ldp.c     |    2 ++
 arch/arm/mach-omap2/board-zoom2.c   |    2 ++
 drivers/media/video/omap34xxcam.c   |    5 +++--
 drivers/media/video/omap34xxcam.h   |    1 +
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/board-3430sdp.c
b/arch/arm/mach-omap2/board-3430sdp.c
index b96954f..b075568 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -604,6 +604,7 @@ static void __iomem *fpga_map_addr;
 static struct omap34xxcam_sensor_config cam_hwc = {
	.sensor_isp = 0,
	.xclk = OMAP34XXCAM_XCLK_A,
+	.pixelformat = V4L2_PIX_FMT_SGRBG10,
	.capture_mem = PAGE_ALIGN(2592 * 1944 * 2) * 4,
 };

@@ -640,6 +641,7 @@ static int mt9p012_sensor_set_prv_data(void *priv)

	hwc->u.sensor.xclk = cam_hwc.xclk;
	hwc->u.sensor.sensor_isp = cam_hwc.sensor_isp;
+	hwc->u.sensor.pixelformat = cam_hwc.pixelformat;
	hwc->u.sensor.capture_mem = cam_hwc.capture_mem;
	hwc->dev_index = 0;
	hwc->dev_minor = 0;
@@ -769,6 +771,7 @@ static struct omap34xxcam_sensor_config ov3640_hwc = {
 #else
	.xclk = OMAP34XXCAM_XCLK_A,
 #endif
+	.pixelformat = V4L2_PIX_FMT_RGB565,
	.capture_mem = PAGE_ALIGN(2048 * 1536 * 2) * 2,
 };

@@ -804,6 +807,7 @@ static int ov3640_sensor_set_prv_data(void *priv)
	hwc = priv;
	hwc->u.sensor.xclk = ov3640_hwc.xclk;
	hwc->u.sensor.sensor_isp = ov3640_hwc.sensor_isp;
+	hwc->u.sensor.pixelformat = ov3640_hwc.pixelformat;
	hwc->u.sensor.capture_mem = ov3640_hwc.capture_mem;
	hwc->dev_index = 1;
	hwc->dev_minor = 4;
@@ -953,6 +957,7 @@ static struct ov3640_platform_data
sdp3430_ov3640_platform_data = {
 static struct omap34xxcam_sensor_config imx046_hwc = {
	.sensor_isp  = 0,
	.xclk        = OMAP34XXCAM_XCLK_B,
+	.pixelformat = V4L2_PIX_FMT_SGRBG10,
	.capture_mem = PAGE_ALIGN(3280 * 2464 * 2) * 2,
 };

@@ -962,6 +967,7 @@ static int imx046_sensor_set_prv_data(void *priv)

	hwc->u.sensor.xclk  = imx046_hwc.xclk;
	hwc->u.sensor.sensor_isp = imx046_hwc.sensor_isp;
+	hwc->u.sensor.pixelformat = imx046_hwc.pixelformat;
	hwc->dev_index      = 2;
	hwc->dev_minor      = 5;
	hwc->dev_type       = OMAP34XXCAM_SLAVE_SENSOR;
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index f8a9e47..5b01e76 100755
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -610,6 +610,7 @@ static struct omap34xxcam_sensor_config ov3640_hwc = {
 #else
	.xclk = OMAP34XXCAM_XCLK_A,
 #endif
+	.pixelformat = V4L2_PIX_FMT_RGB565,
	.capture_mem = 2592 * 1944 * 2 * 2,
 };

@@ -644,6 +645,7 @@ static int ov3640_sensor_set_prv_data(void *priv)

	hwc = priv;
	hwc->u.sensor.xclk = ov3640_hwc.xclk;
+	hwc->u.sensor.pixelformat = ov3640_hwc.pixelformat;
	hwc->u.sensor.sensor_isp = ov3640_hwc.sensor_isp;
	hwc->dev_index = 1;
	hwc->dev_minor = 4;
diff --git a/arch/arm/mach-omap2/board-zoom2.c
b/arch/arm/mach-omap2/board-zoom2.c
index 5ecc71e..806a4a5 100755
--- a/arch/arm/mach-omap2/board-zoom2.c
+++ b/arch/arm/mach-omap2/board-zoom2.c
@@ -331,6 +331,7 @@ static struct twl4030_keypad_data ldp_kp_twl4030_data = {
 static struct omap34xxcam_sensor_config imx046_hwc = {
	.sensor_isp  = 0,
	.xclk        = OMAP34XXCAM_XCLK_B,
+	.pixelformat = V4L2_PIX_FMT_SGRBG10,
	.capture_mem = PAGE_ALIGN(3280 * 2464 * 2) * 2,
 };

@@ -340,6 +341,7 @@ static int imx046_sensor_set_prv_data(void *priv)

	hwc->u.sensor.xclk  = imx046_hwc.xclk;
	hwc->u.sensor.sensor_isp = imx046_hwc.sensor_isp;
+	hwc->u.sensor.pixelformat = imx046_hwc.pixelformat;
	hwc->dev_index      = 2;
	hwc->dev_minor      = 5;
	hwc->dev_type       = OMAP34XXCAM_SLAVE_SENSOR;
diff --git a/drivers/media/video/omap34xxcam.c
b/drivers/media/video/omap34xxcam.c
index 43eeb1c..0cde1c6
--- a/drivers/media/video/omap34xxcam.c
+++ b/drivers/media/video/omap34xxcam.c
@@ -392,8 +392,9 @@ static int try_pix_parm(struct omap34xxcam_videodev *vdev,

	best_ival->denominator = 0;
	best_pix_in->width = 0;
-   /* FIXME: this isn't good... */
-   best_pix_in->pixelformat = V4L2_PIX_FMT_SGRBG10;
+
+	/* first try with default pixel format designated at sensor config */
+	best_pix_in->pixelformat = vdev->vdev_sensor_config.pixelformat;

	best_pix_out.height = INT_MAX >> 1;
	best_pix_out.width = best_pix_out.height;
diff --git a/drivers/media/video/omap34xxcam.h
b/drivers/media/video/omap34xxcam.h
index 86631b7..83d43a1
--- a/drivers/media/video/omap34xxcam.h
+++ b/drivers/media/video/omap34xxcam.h
@@ -71,6 +71,7 @@ struct omap34xxcam_hw_csi2 {
 struct omap34xxcam_sensor_config {
	int xclk;
	int sensor_isp;
+	u32 pixelformat;
	u32 capture_mem;
 };


-- 
========================================================
DongSoo(Nathaniel), Kim
Engineer
Mobile S/W Platform Lab. S/W centre
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
