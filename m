Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:43257 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752580AbbKCFkx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 00:40:53 -0500
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/5] media: atmel-isi: support RGB565 output when sensor output YUV formats
Date: Tue, 3 Nov 2015 13:45:12 +0800
Message-ID: <1446529512-19109-6-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1446529512-19109-1-git-send-email-josh.wu@atmel.com>
References: <1446529512-19109-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enable Atmel ISI preview path to convert the YUV to RGB format.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

Changes in v2:
- According to Guennadi's suggestion, remove the is_output_rgb() function
  which only used once. Also move the code into the for loop.

 drivers/media/platform/soc_camera/atmel-isi.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 826d04e..8abeeeb 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -146,6 +146,10 @@ static void configure_geometry(struct atmel_isi *isi, u32 width,
 		u32 height, const struct soc_camera_format_xlate *xlate)
 {
 	u32 cfg2, psize;
+	u32 fourcc = xlate->host_fmt->fourcc;
+
+	isi->enable_preview_path = (fourcc == V4L2_PIX_FMT_RGB565 ||
+				    fourcc == V4L2_PIX_FMT_RGB32);
 
 	/* According to sensor's output format to set cfg2 */
 	switch (xlate->code) {
@@ -195,8 +199,9 @@ static bool is_supported(struct soc_camera_device *icd,
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YVYU:
 	case V4L2_PIX_FMT_VYUY:
+	/* RGB */
+	case V4L2_PIX_FMT_RGB565:
 		return true;
-	/* RGB, TODO */
 	default:
 		return false;
 	}
@@ -682,6 +687,14 @@ static const struct soc_mbus_pixelfmt isi_camera_formats[] = {
 		.order			= SOC_MBUS_ORDER_LE,
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
+	{
+		.fourcc			= V4L2_PIX_FMT_RGB565,
+		.name			= "RGB565",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
+	},
 };
 
 /* This will be corrected as we get more formats */
@@ -738,7 +751,7 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 				  struct soc_camera_format_xlate *xlate)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	int formats = 0, ret;
+	int formats = 0, ret, i, n;
 	/* sensor format */
 	struct v4l2_subdev_mbus_code_enum code = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
@@ -772,11 +785,11 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 	case MEDIA_BUS_FMT_VYUY8_2X8:
 	case MEDIA_BUS_FMT_YUYV8_2X8:
 	case MEDIA_BUS_FMT_YVYU8_2X8:
-		formats++;
-		if (xlate) {
-			xlate->host_fmt	= &isi_camera_formats[0];
+		n = ARRAY_SIZE(isi_camera_formats);
+		formats += n;
+		for (i = 0; xlate && i < n; i++, xlate++) {
+			xlate->host_fmt	= &isi_camera_formats[i];
 			xlate->code	= code.code;
-			xlate++;
 			dev_dbg(icd->parent, "Providing format %s using code %d\n",
 				isi_camera_formats[0].name, code.code);
 		}
-- 
1.9.1

