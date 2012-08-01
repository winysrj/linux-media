Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:43086 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335Ab2HAFzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Aug 2012 01:55:18 -0400
From: Albert Wang <twang13@marvell.com>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>
Subject: [PATCH] media: soc_camera: don't clear pix->sizeimage in JPEG mode when try_fmt
Date: Wed,  1 Aug 2012 13:45:41 +0800
Message-Id: <1343799941-1125-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In JPEG mode, the size of image is variable due to different JPEG compress rate
We only can get the pix->sizeimage from user in USERPTR mode

If we clear pix->sizeimage in soc_camera_try_fmt() then we will get it from:
	ret = soc_mbus_image_size(xlate->host_fmt, pix->bytesperline,
				pix->height);
	if (ret < 0)
		return ret;

	pix->sizeimage = max_t(u32, pix->sizeimage, ret);

In general, this sizeimage will large than the actul JPEG image size

But vb2 will check the buffer and size of image in __qbuf_userptr():
	/* Check if the provided plane buffer is large enough */
	if (planes[plane].length < q->plane_sizes[plane])

So we shouldn't clear the pix->sizeimage and also shouldn't re-calculate
the pix->sizeimage in soc_mbus_image_size() in JPEG mode

For pix->bytesperline, also shouldn't re-calculate it from:
	ret = soc_mbus_bytes_per_line(pix->width, xlate->host_fmt);
	if (ret < 0)
		return ret;

	pix->bytesperline = max_t(u32, pix->bytesperline, ret);

pix->bytesperline also should be set from user or
from driver try_fmt() implementation

Change-Id: I700690a2287346127a624b5260922eaa5427a596
Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c   |    3 ++-
 drivers/media/video/soc_mediabus.c |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 0421bf9..d929a9c 100755
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -171,7 +171,8 @@ static int soc_camera_try_fmt(struct soc_camera_device *icd,
 	dev_dbg(icd->pdev, "TRY_FMT(%c%c%c%c, %ux%u)\n",
 		pixfmtstr(pix->pixelformat), pix->width, pix->height);
 
-	if (!(ici->capabilities & SOCAM_HOST_CAP_STRIDE)) {
+	if (pix->pixelformat != V4L2_PIX_FMT_JPEG &&
+		!(ici->capabilities & SOCAM_HOST_CAP_STRIDE)) {
 		pix->bytesperline = 0;
 		pix->sizeimage = 0;
 	}
diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
index 89dce09..a397812 100755
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -378,6 +378,9 @@ EXPORT_SYMBOL(soc_mbus_samples_per_pixel);
 
 s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
 {
+	if (mf->fourcc == V4L2_PIX_FMT_JPEG)
+		return 0;
+
 	if (mf->layout != SOC_MBUS_LAYOUT_PACKED)
 		return width * mf->bits_per_sample / 8;
 
@@ -400,6 +403,9 @@ EXPORT_SYMBOL(soc_mbus_bytes_per_line);
 s32 soc_mbus_image_size(const struct soc_mbus_pixelfmt *mf,
 			u32 bytes_per_line, u32 height)
 {
+	if (mf->fourcc == V4L2_PIX_FMT_JPEG)
+		return 0;
+
 	if (mf->layout == SOC_MBUS_LAYOUT_PACKED)
 		return bytes_per_line * height;
 
-- 
1.7.0.4

