Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35731 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1AQJwP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 04:52:15 -0500
Subject: [PATCH 2/2 v2] Fix capture issues for non 8-bit per pixel formats
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: HansVerkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1101152228470.14685@axis700.grange>
References: <1290964687.3016.5.camel@realization>
	 <1290965045.3016.11.camel@realization>
	 <Pine.LNX.4.64.1012011832430.28110@axis700.grange>
	 <Pine.LNX.4.64.1012181722200.18515@axis700.grange>
	 <Pine.LNX.4.64.1012302028100.13281@axis700.grange>
	 <1294076008.2493.85.camel@realization>
	 <Pine.LNX.4.64.1101031931160.23134@axis700.grange>
	 <1294092449.2493.135.camel@realization>
	 <1294830836.2576.46.camel@realization>
	 <1294831223.2576.52.camel@realization>
	 <Pine.LNX.4.64.1101152228470.14685@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 10:52:10 +0100
Message-ID: <1295257930.2884.16.camel@realization>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

If the camera was set to output formats like RGB565 YUYV or SBGGR10,
the resulting image was scrambled due to erroneous interpretations of
horizontal parameter's units.

This patch in fourcc_to_ipu_pix, eliminate also the pixel formats mappings
that, first are not used within mainline code and second, standing at
the datasheets, they will not work properly:

 The IPU internal bus support only the following data formatting
 (44.1.1.3 Data Flows and Formats):
  1 YUV 4:4:4 or RGB-8 bits per color component
  2 YUV 4:4:4 or RGB-10 bits per color component
  3 Generic data (from sensor to the system memory only)

 And format conversions are done:
  - from memory: unpacking from other formats to IPU supported ones
  - to memory: packing in the inverse order.

 So, assigning a packing/depacking strategy to the IPU for that formats
 will produce a packing to memory and not the inverse.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 drivers/media/video/mx3_camera.c |   64 +++++++++++++++++++++++++++++--------
 1 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index b9cb4a4..9391006 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -324,14 +324,10 @@ static enum pixel_fmt fourcc_to_ipu_pix(__u32 fourcc)
 {
 	/* Add more formats as need arises and test possibilities appear... */
 	switch (fourcc) {
-	case V4L2_PIX_FMT_RGB565:
-		return IPU_PIX_FMT_RGB565;
 	case V4L2_PIX_FMT_RGB24:
 		return IPU_PIX_FMT_RGB24;
-	case V4L2_PIX_FMT_RGB332:
-		return IPU_PIX_FMT_RGB332;
-	case V4L2_PIX_FMT_YUV422P:
-		return IPU_PIX_FMT_YVU422P;
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_RGB565:
 	default:
 		return IPU_PIX_FMT_GENERIC;
 	}
@@ -359,9 +355,31 @@ static void mx3_videobuf_queue(struct videobuf_queue *vq,
 
 	/* This is the configuration of one sg-element */
 	video->out_pixel_fmt	= fourcc_to_ipu_pix(fourcc);
-	video->out_width	= icd->user_width;
-	video->out_height	= icd->user_height;
-	video->out_stride	= icd->user_width;
+
+	if (video->out_pixel_fmt == IPU_PIX_FMT_GENERIC) {
+		/*
+		 * If the IPU DMA channel is configured to transport
+		 * generic 8-bit data, we have to set up correctly the
+		 * geometry parameters upon the current pixel format.
+		 * So, since the DMA horizontal parameters are expressed
+		 * in bytes not pixels, convert these in the right unit.
+		 */
+		int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
+		BUG_ON(bytes_per_line <= 0);
+
+		video->out_width	= bytes_per_line;
+		video->out_height	= icd->user_height;
+		video->out_stride	= bytes_per_line;
+	} else {
+		/*
+		 * For IPU known formats the pixel unit will be managed
+		 * successfully by the IPU code
+		 */
+		video->out_width	= icd->user_width;
+		video->out_height	= icd->user_height;
+		video->out_stride	= icd->user_width;
+	}
 
 #ifdef DEBUG
 	/* helps to see what DMA actually has written */
@@ -734,18 +752,36 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	if (xlate) {
 		xlate->host_fmt	= fmt;
 		xlate->code	= code;
+		dev_dbg(dev, "Providing format %c%c%c%c in pass-through mode\n",
+			(fmt->fourcc >> (0*8)) & 0xFF,
+			(fmt->fourcc >> (1*8)) & 0xFF,
+			(fmt->fourcc >> (2*8)) & 0xFF,
+			(fmt->fourcc >> (3*8)) & 0xFF);
 		xlate++;
-		dev_dbg(dev, "Providing format %x in pass-through mode\n",
-			xlate->host_fmt->fourcc);
 	}
 
 	return formats;
 }
 
 static void configure_geometry(struct mx3_camera_dev *mx3_cam,
-			       unsigned int width, unsigned int height)
+			       unsigned int width, unsigned int height,
+			       enum v4l2_mbus_pixelcode code)
 {
 	u32 ctrl, width_field, height_field;
+	const struct soc_mbus_pixelfmt *fmt;
+
+	fmt = soc_mbus_get_fmtdesc(code);
+	BUG_ON(!fmt);
+
+	if (fourcc_to_ipu_pix(fmt->fourcc) == IPU_PIX_FMT_GENERIC) {
+		/*
+		 * As the CSI will be configured to output BAYER, here
+		 * the width parameter count the number of samples to
+		 * capture to complete the whole image width.
+		 */
+		width *= soc_mbus_samples_per_pixel(fmt);
+		BUG_ON(!width);
+	}
 
 	/* Setup frame size - this cannot be changed on-the-fly... */
 	width_field = width - 1;
@@ -854,7 +890,7 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 				return ret;
 		}
 
-		configure_geometry(mx3_cam, mf.width, mf.height);
+		configure_geometry(mx3_cam, mf.width, mf.height, mf.code);
 	}
 
 	dev_dbg(icd->dev.parent, "Sensor cropped %dx%d\n",
@@ -897,7 +933,7 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	 * mxc_v4l2_s_fmt()
 	 */
 
-	configure_geometry(mx3_cam, pix->width, pix->height);
+	configure_geometry(mx3_cam, pix->width, pix->height, xlate->code);
 
 	mf.width	= pix->width;
 	mf.height	= pix->height;
-- 
1.7.1



