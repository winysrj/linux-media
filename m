Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9TBZ0kH027566
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 07:35:00 -0400
Received: from smtp-out25.alice.it (smtp-out25.alice.it [85.33.2.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9TBYnWc022581
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 07:34:50 -0400
Date: Wed, 29 Oct 2008 12:34:46 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081029123446.540dcd2e.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [PATCH, RFC] mt9m111: Fix YUYV format for pxa-camera
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

Hi,

I'd like to discuss this change to mt9m111, but I am not sure if the
first hunk of the following patch is a proper fix for the problem I had:
when using YUYV the output buffer has to be WIDTH*HEIGHT*2,
and not WIDTH*HEIGHT as it is now using 8bit YUYV format.
Maybe the proper fix belongs to pxa-camera.c?

Anyway, with the following changes I have the right output from mt9m111
interfaced to pxa-camera on a Motorola A910 phone:
http://people.openezx.org/ao2/a910-camera-working.jpg
http://wiki.openezx.org/A910

Regards,
   Antonio Ospite.

Here's the patch:

Use 16 bit depth for YUYV so the pxa-camera image buffer has the correct size,
see the formula:

	*size = icd->width * icd->height *
		((icd->current_fmt->depth + 7) >> 3);

in drivers/media/video/pxa_camera.c: pxa_videobuf_setup().

Don't swap Cb and Cr components, to respect PXA Quick Capture Interface
data format.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

---
 drivers/media/video/mt9m111.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index da0b2d5..76fb0cb 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -130,7 +130,7 @@
 	COL_FMT(_name, _depth, _fourcc, V4L2_COLORSPACE_SRGB)
 
 static const struct soc_camera_data_format mt9m111_colour_formats[] = {
-	COL_FMT("YCrYCb 8 bit", 8, V4L2_PIX_FMT_YUYV, V4L2_COLORSPACE_JPEG),
+	COL_FMT("YCrYCb 16 bit", 16, V4L2_PIX_FMT_YUYV, V4L2_COLORSPACE_JPEG),
 	RGB_FMT("RGB 565", 16, V4L2_PIX_FMT_RGB565),
 	RGB_FMT("RGB 555", 16, V4L2_PIX_FMT_RGB555),
 	RGB_FMT("Bayer (sRGB) 10 bit", 10, V4L2_PIX_FMT_SBGGR16),
@@ -864,6 +864,9 @@ static int mt9m111_video_probe(struct soc_camera_device *icd)
 	mt9m111->swap_rgb_even_odd = 1;
 	mt9m111->swap_rgb_red_blue = 1;
 
+	mt9m111->swap_yuv_y_chromas = 1;
+	mt9m111->swap_yuv_cb_cr = 0;
+
 	return 0;
 eisis:
 ei2c:

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
