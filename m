Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA4M1EOM003844
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 17:01:14 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA4M0Jc6003152
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 17:00:20 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de
Date: Tue,  4 Nov 2008 22:59:38 +0100
Message-Id: <1225835978-14548-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1225835978-14548-1-git-send-email-robert.jarzmik@free.fr>
References: <87bpwvyx19.fsf@free.fr>
	<1225835978-14548-1-git-send-email-robert.jarzmik@free.fr>
Cc: video4linux-list@redhat.com
Subject: [PATCH] mt9m111: add all yuv format combinations.
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

The Micron mt9m111 offers 4 byte orders for YCbCr
output. This patchs adds all possible outputs capabilities
to the mt9m111 driver.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/mt9m111.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index da0b2d5..9b9b377 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -128,9 +128,14 @@
 	.colorspace = _colorspace }
 #define RGB_FMT(_name, _depth, _fourcc) \
 	COL_FMT(_name, _depth, _fourcc, V4L2_COLORSPACE_SRGB)
+#define JPG_FMT(_name, _depth, _fourcc) \
+	COL_FMT(_name, _depth, _fourcc, V4L2_COLORSPACE_JPEG)
 
 static const struct soc_camera_data_format mt9m111_colour_formats[] = {
-	COL_FMT("YCrYCb 8 bit", 8, V4L2_PIX_FMT_YUYV, V4L2_COLORSPACE_JPEG),
+	JPG_FMT("CbYCrY 16 bit", 16, V4L2_PIX_FMT_UYVY),
+	JPG_FMT("CrYCbY 16 bit", 16, V4L2_PIX_FMT_VYUY),
+	JPG_FMT("YCbYCr 16 bit", 16, V4L2_PIX_FMT_YUYV),
+	JPG_FMT("YCrYCb 16 bit", 16, V4L2_PIX_FMT_YVYU),
 	RGB_FMT("RGB 565", 16, V4L2_PIX_FMT_RGB565),
 	RGB_FMT("RGB 555", 16, V4L2_PIX_FMT_RGB555),
 	RGB_FMT("Bayer (sRGB) 10 bit", 10, V4L2_PIX_FMT_SBGGR16),
@@ -438,7 +443,24 @@ static int mt9m111_set_pixfmt(struct soc_camera_device *icd, u32 pixfmt)
 	case V4L2_PIX_FMT_RGB565:
 		ret = mt9m111_setfmt_rgb565(icd);
 		break;
+	case V4L2_PIX_FMT_UYVY:
+		mt9m111->swap_yuv_y_chromas = 0;
+		mt9m111->swap_yuv_cb_cr = 0;
+		ret = mt9m111_setfmt_yuv(icd);
+		break;
+	case V4L2_PIX_FMT_VYUY:
+		mt9m111->swap_yuv_y_chromas = 0;
+		mt9m111->swap_yuv_cb_cr = 1;
+		ret = mt9m111_setfmt_yuv(icd);
+		break;
 	case V4L2_PIX_FMT_YUYV:
+		mt9m111->swap_yuv_y_chromas = 1;
+		mt9m111->swap_yuv_cb_cr = 0;
+		ret = mt9m111_setfmt_yuv(icd);
+		break;
+	case V4L2_PIX_FMT_YVYU:
+		mt9m111->swap_yuv_y_chromas = 1;
+		mt9m111->swap_yuv_cb_cr = 1;
 		ret = mt9m111_setfmt_yuv(icd);
 		break;
 	default:
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
