Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43857 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab2AYPMc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 10:12:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 6/8] soc-camera: Honor user-requested bytesperline and sizeimage
Date: Wed, 25 Jan 2012 16:12:29 +0100
Message-Id: <1327504351-24413-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1327504351-24413-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1327504351-24413-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compute the bytesperline and sizeimage values when trying/setting
formats or when allocating buffers by taking the user-requested values
into account.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mx3_camera.c           |   20 +++++++++++++-----
 drivers/media/video/sh_mobile_ceu_camera.c |   20 +++++++++++++-----
 drivers/media/video/soc_camera.c           |   29 ++++++++++++++-------------
 3 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 813323c..4fd62d1 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -206,17 +206,25 @@ static int mx3_videobuf_setup(struct vb2_queue *vq,
 	if (fmt) {
 		const struct soc_camera_format_xlate *xlate = soc_camera_xlate_by_fourcc(icd,
 								fmt->fmt.pix.pixelformat);
-		int bytes_per_line;
+		unsigned int bytes_per_line;
+		int ret;
 
 		if (!xlate)
 			return -EINVAL;
 
-		bytes_per_line = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
-							 xlate->host_fmt);
-		if (bytes_per_line < 0)
-			return bytes_per_line;
+		ret = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
+					      xlate->host_fmt);
+		if (ret < 0)
+			return ret;
+
+		bytes_per_line = max_t(u32, fmt->fmt.pix.bytesperline, ret);
+
+		ret = soc_mbus_image_size(bytes_per_line, fmt->fmt.pix.height,
+					  xlate->host_fmt);
+		if (ret < 0)
+			return ret;
 
-		sizes[0] = bytes_per_line * fmt->fmt.pix.height;
+		sizes[0] = max_t(u32, fmt->fmt.pix.sizeimage, ret);
 	} else {
 		/* Called from VIDIOC_REQBUFS or in compatibility mode */
 		sizes[0] = icd->sizeimage;
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index bd6ae79..47b336b 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -210,17 +210,25 @@ static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
 	if (fmt) {
 		const struct soc_camera_format_xlate *xlate = soc_camera_xlate_by_fourcc(icd,
 								fmt->fmt.pix.pixelformat);
-		int bytes_per_line;
+		unsigned int bytes_per_line;
+		int ret;
 
 		if (!xlate)
 			return -EINVAL;
 
-		bytes_per_line = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
-							 xlate->host_fmt);
-		if (bytes_per_line < 0)
-			return bytes_per_line;
+		ret = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
+					      xlate->host_fmt);
+		if (ret < 0)
+			return ret;
+
+		bytes_per_line = max_t(u32, fmt->fmt.pix.bytesperline, ret);
+
+		ret = soc_mbus_image_size(bytes_per_line, fmt->fmt.pix.height,
+					  xlate->host_fmt);
+		if (ret < 0)
+			return ret;
 
-		sizes[0] = bytes_per_line * fmt->fmt.pix.height;
+		sizes[0] = max_t(u32, fmt->fmt.pix.sizeimage, ret);
 	} else {
 		/* Called from VIDIOC_REQBUFS or in compatibility mode */
 		sizes[0] = icd->sizeimage;
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 62e4312..b49ad27 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -164,6 +164,7 @@ static int soc_camera_try_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
 
@@ -177,22 +178,22 @@ static int soc_camera_try_fmt(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
-	if (!pix->sizeimage) {
-		if (!pix->bytesperline) {
-			const struct soc_camera_format_xlate *xlate;
+	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	if (!xlate)
+		return -EINVAL;
 
-			xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
-			if (!xlate)
-				return -EINVAL;
+	ret = soc_mbus_bytes_per_line(pix->width, xlate->host_fmt);
+	if (ret < 0)
+		return ret;
 
-			ret = soc_mbus_bytes_per_line(pix->width,
-						      xlate->host_fmt);
-			if (ret > 0)
-				pix->bytesperline = ret;
-		}
-		if (pix->bytesperline)
-			pix->sizeimage = pix->bytesperline * pix->height;
-	}
+	pix->bytesperline = max_t(u32, pix->bytesperline, ret);
+
+	ret = soc_mbus_image_size(pix->bytesperline, pix->height,
+				  xlate->host_fmt);
+	if (ret < 0)
+		return ret;
+
+	pix->sizeimage = max_t(u32, pix->sizeimage, ret);
 
 	return 0;
 }
-- 
1.7.3.4

