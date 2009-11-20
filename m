Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46853 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753347AbZKTNbs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 08:31:48 -0500
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1NBTal-0001mD-7T
	for linux-media@vger.kernel.org; Fri, 20 Nov 2009 14:32:03 +0100
Date: Fri, 20 Nov 2009 14:32:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH/RFC] sh_mobile_ceu_camera: fix pass-through geometry parameters
 and try_fmt reporting
Message-ID: <Pine.LNX.4.64.0911201427350.4438@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix geometry parameter calculations for the pass-through mode, using the 
imagebus API, Also fix try-fmt result reporting for natively supported by 
the driver pixel formats.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Marked as RFC because this is based on my imagebus tree. Otherwise this is 
nothing new, I've had this fix for a while in my tree, just forgot to post 
together with the rest, when presenting my imagebus stack.

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 0114a2b..e7d6191 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -586,20 +586,30 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd,
 			in_width *= 2;
 			left_offset *= 2;
 		}
-		width = cdwdr_width = out_width;
+		width = out_width;
+		cdwdr_width = out_width;
 	} else {
-		unsigned int w_factor = (7 +
-			icd->current_fmt->host_fmt->bits_per_sample) >> 3;
+		int bytes_per_line = v4l2_imgbus_bytes_per_line(out_width,
+						icd->current_fmt->host_fmt);
+		unsigned int w_factor;
 
-		width = out_width * w_factor / 2;
+		width = out_width;
 
-		if (!pcdev->is_16bit)
-			w_factor *= 2;
+		switch (icd->current_fmt->host_fmt->packing) {
+		case V4L2_IMGBUS_PACKING_2X8_PADHI:
+			w_factor = 2;
+			break;
+		default:
+			w_factor = 1;
+		}
 
-		in_width = rect->width * w_factor / 2;
-		left_offset = left_offset * w_factor / 2;
+		in_width = rect->width * w_factor;
+		left_offset = left_offset * w_factor;
 
-		cdwdr_width = width * 2;
+		if (bytes_per_line < 0)
+			cdwdr_width = out_width;
+		else
+			cdwdr_width = bytes_per_line;
 	}
 
 	height = out_height;
@@ -1547,16 +1557,23 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	if (pix->height > ceu_rect.height)
 		pix->height = ceu_rect.height;
 
-	/* Let's rock: scale pix->{width x height} down to width x height */
-	scale_h = calc_scale(ceu_rect.width, &pix->width);
-	scale_v = calc_scale(ceu_rect.height, &pix->height);
+	if (image_mode) {
+		/* Scale pix->{width x height} down to width x height */
+		scale_h = calc_scale(ceu_rect.width, &pix->width);
+		scale_v = calc_scale(ceu_rect.height, &pix->height);
+
+		pcdev->cflcr = scale_h | (scale_v << 16);
+	} else {
+		pix->width = ceu_rect.width;
+		pix->height = ceu_rect.height;
+		scale_h = scale_v = 0;
+		pcdev->cflcr = 0;
+	}
 
 	dev_geo(dev, "10: W: %u : 0x%x = %u, H: %u : 0x%x = %u\n",
 		ceu_rect.width, scale_h, pix->width,
 		ceu_rect.height, scale_v, pix->height);
 
-	pcdev->cflcr = scale_h | (scale_v << 16);
-
 	cam->code		= xlate->code;
 	cam->ceu_rect		= ceu_rect;
 	icd->current_fmt	= xlate;
@@ -1618,21 +1635,25 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 		/* FIXME: check against rect_max after converting soc-camera */
 		/* We can scale precisely, need a bigger image from camera */
 		if (pix->width < width || pix->height < height) {
-			int tmp_w = pix->width, tmp_h = pix->height;
-			pix->width = 2560;
-			pix->height = 1920;
+			/*
+			 * We presume, the sensor behaves sanely, i.e., if
+			 * requested a bigger rectangle, it will not return a
+			 * smaller one.
+			 */
+			imgf.width = 2560;
+			imgf.height = 1920;
 			ret = v4l2_subdev_call(sd, video, try_imgbus_fmt, &imgf);
 			if (ret < 0) {
 				/* Shouldn't actually happen... */
 				dev_err(icd->dev.parent,
-					"FIXME: try_fmt() returned %d\n", ret);
-				pix->width = tmp_w;
-				pix->height = tmp_h;
+					"FIXME: client try_fmt() = %d\n", ret);
+				return ret;
 			}
 		}
-		if (pix->width > width)
+		/* We will scale exactly */
+		if (imgf.width > width)
 			pix->width = width;
-		if (pix->height > height)
+		if (imgf.height > height)
 			pix->height = height;
 	}
 
