Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:58062 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756520AbbIVFM7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 01:12:59 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 5/5] media: atmel-isi: support RGB565 output when sensor output YUV formats
Date: Tue, 22 Sep 2015 13:14:34 +0800
Message-ID: <1442898875-7147-6-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1442898875-7147-1-git-send-email-josh.wu@atmel.com>
References: <1442898875-7147-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enable Atmel ISI preview path to convert the YUV to RGB format.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

 drivers/media/platform/soc_camera/atmel-isi.c | 38 ++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index e87d354..e33a16a 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -201,13 +201,20 @@ static bool is_supported(struct soc_camera_device *icd,
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
 }
 
+static bool is_output_rgb(const struct soc_mbus_pixelfmt *host_fmt)
+{
+	return host_fmt->fourcc == V4L2_PIX_FMT_RGB565 ||
+			host_fmt->fourcc == V4L2_PIX_FMT_RGB32;
+}
+
 static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
 {
 	if (isi->active) {
@@ -467,6 +474,8 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct atmel_isi *isi = ici->priv;
 	int ret;
 
+	isi->enable_preview_path = is_output_rgb(icd->current_fmt->host_fmt);
+
 	pm_runtime_get_sync(ici->v4l2_dev.dev);
 
 	/* Reset ISI */
@@ -688,6 +697,14 @@ static const struct soc_mbus_pixelfmt isi_camera_formats[] = {
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
@@ -744,7 +761,7 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 				  struct soc_camera_format_xlate *xlate)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	int formats = 0, ret;
+	int formats = 0, ret, i, n;
 	/* sensor format */
 	struct v4l2_subdev_mbus_code_enum code = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
@@ -778,13 +795,16 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 	case MEDIA_BUS_FMT_VYUY8_2X8:
 	case MEDIA_BUS_FMT_YUYV8_2X8:
 	case MEDIA_BUS_FMT_YVYU8_2X8:
-		formats++;
-		if (xlate) {
-			xlate->host_fmt	= &isi_camera_formats[0];
-			xlate->code	= code.code;
-			xlate++;
-			dev_dbg(icd->parent, "Providing format %s using code %d\n",
-				isi_camera_formats[0].name, code.code);
+		n = ARRAY_SIZE(isi_camera_formats);
+		formats += n;
+		for (i = 0; i < n; i++) {
+			if (xlate) {
+				xlate->host_fmt	= &isi_camera_formats[i];
+				xlate->code	= code.code;
+				dev_dbg(icd->parent, "Providing format %s using code %d\n",
+					isi_camera_formats[0].name, code.code);
+				xlate++;
+			}
 		}
 		break;
 	default:
-- 
1.9.1

