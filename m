Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA6N4oWl006845
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 18:04:50 -0500
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA6N4Iqr023023
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 18:04:35 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: video4linux-list@redhat.com, g.liakhovetski@gmx.de
Date: Fri,  7 Nov 2008 00:04:16 +0100
Message-Id: <1226012656-17334-1-git-send-email-robert.jarzmik@free.fr>
Cc: 
Subject: [PATCH] pxa_camera: Fix YUV format handling.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Allows all YUV formats on pxa interface. Even if PXA capture
interface expects data in UYVY format, we allow all formats
considering the pxa bus is not making any translation.

For the special YUV planar format, we translate the pixel
format asked to the sensor to VYUY, which is the bus byte
order necessary (out of the sensor) for the pxa to make the
correct translation.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index eb6be58..863e0df 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -862,7 +862,15 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	case V4L2_PIX_FMT_YUV422P:
 		pcdev->channels = 3;
 		cicr1 |= CICR1_YCBCR_F;
+		/*
+		 * Normally, pxa bus wants as input VYUY format.
+		 * We allow all YUV formats, as no translation is used, and the
+		 * YUV stream is just passed through without any transformation.
+		 */
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
 	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
 		cicr1 |= CICR1_COLOR_SP_VAL(2);
 		break;
 	case V4L2_PIX_FMT_RGB555:
@@ -907,6 +915,13 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 static int pxa_camera_set_fmt_cap(struct soc_camera_device *icd,
 				  __u32 pixfmt, struct v4l2_rect *rect)
 {
+	/*
+	 * The YUV 4:2:2 planar format is translated by the pxa assuming its
+	 * input (ie. camera device output) is VYUV.
+	 * We fix the pixel format asked to the camera device.
+	 */
+	if (pixfmt == V4L2_PIX_FMT_YUV422P)
+		pixfmt = V4L2_PIX_FMT_VYUY;
 	return icd->ops->set_fmt_cap(icd, pixfmt, rect);
 }
 
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
