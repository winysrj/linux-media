Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACKW3MA022779
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:32:03 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACKVsMf027304
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:54 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, video4linux-list@redhat.com
Date: Wed, 12 Nov 2008 21:29:43 +0100
Message-Id: <1226521783-19806-13-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1226521783-19806-12-git-send-email-robert.jarzmik@free.fr>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-2-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-3-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-4-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-5-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-6-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-7-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-8-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-9-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-10-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-11-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-12-git-send-email-robert.jarzmik@free.fr>
Cc: 
Subject: [PATCH 12/13] pxa_camera: Fix YUV format handling.
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
format asked to the sensor to UYVY, which is the bus byte
order necessary (out of the sensor) for the pxa to make the
correct translation.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index cd9d09e..fde14e7 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -894,7 +894,17 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	case V4L2_PIX_FMT_YUV422P:
 		pcdev->channels = 3;
 		cicr1 |= CICR1_YCBCR_F;
+		/*
+		 * Normally, pxa bus wants as input UYVY format.
+		 * We allow all YUV formats, as no translation is used, and the
+		 * YUV stream is just passed through without any transformation.
+		 * Note that UYVY is the only format that should be used if pxa
+		 * framebuffer Overlay2 is used.
+		 */
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
 	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
 		cicr1 |= CICR1_COLOR_SP_VAL(2);
 		break;
 	case V4L2_PIX_FMT_RGB555:
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
