Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:65010 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab3BORIr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 12:08:47 -0500
Subject: [PATCH] media: i.MX27 camera: fix picture source width
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Shawn Guo <shawn.guo@linaro.org>
Cc: linux-media <linux-media@vger.kernel.org>, stable@vger.kernel.org,
	"Hans J. Koch" <hjk@hansjkoch.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Feb 2013 18:08:41 +0100
Message-ID: <1360948121.29406.15.camel@mars>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While using a mt9m001 (monochrome) camera the final output falsely gets
horizontally divided into two pictures.

The issue was git bisected to commit f410991dcf1f

  |  [media] i.MX27 camera: add support for YUV420 format
  |
  |  This patch uses channel 2 of the eMMa-PrP to convert
  |  format provided by the sensor to YUV420.
  |
  |  This format is very useful since it is used by the
  |  internal H.264 encoder.

It sets PICTURE_X_SIZE in register PRP_SRC_FRAME_SIZE to its full width
while before that commit it was divided by two:

-   writel(((bytesperline >> 1) << 16) | icd->user_height,
+           writel((icd->user_width << 16) | icd->user_height,
                    pcdev->base_emma + PRP_SRC_FRAME_SIZE);

i.mx27 reference manual (41.6.12 PrP Source Frame Size Register) says:

    PICTURE_X_SIZE. These bits set the frame width to be
    processed in number of pixels. In YUV 4:2:0 mode, Cb and
    Cr widths are taken as PICTURE_X_SIZE/2 pixels.  In YUV
    4:2:0 mode, this value should be a multiple of 8-pixels.
    In other modes (RGB, YUV 4:2:2 and YUV 4:4:4) it should
    be a multiple of 4 pixels.

This patch reverts to PICTURE_X_SIZE/2 for channel 1.

Tested on Kernel 3.4, merged to 3.8rc.

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
---
 drivers/media/platform/soc_camera/mx2_camera.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 8bda2c9..795bd3f 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -778,11 +778,11 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
 	struct mx2_camera_dev *pcdev = ici->priv;
 	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
 
-	writel((pcdev->s_width << 16) | pcdev->s_height,
-	       pcdev->base_emma + PRP_SRC_FRAME_SIZE);
 	writel(prp->cfg.src_pixel,
 	       pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
 	if (prp->cfg.channel == 1) {
+		writel(((bytesperline >> 1) << 16) | pcdev->s_height,
+			pcdev->base_emma + PRP_SRC_FRAME_SIZE);
 		writel((icd->user_width << 16) | icd->user_height,
 			pcdev->base_emma + PRP_CH1_OUT_IMAGE_SIZE);
 		writel(bytesperline,
@@ -790,6 +790,8 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
 		writel(prp->cfg.ch1_pixel,
 			pcdev->base_emma + PRP_CH1_PIXEL_FORMAT_CNTL);
 	} else { /* channel 2 */
+		writel((pcdev->s_width << 16) | pcdev->s_height,
+			pcdev->base_emma + PRP_SRC_FRAME_SIZE);
 		writel((icd->user_width << 16) | icd->user_height,
 			pcdev->base_emma + PRP_CH2_OUT_IMAGE_SIZE);
 	}
-- 
1.7.10.4



