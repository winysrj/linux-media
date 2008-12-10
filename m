Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBA7koim014242
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 02:46:50 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBA7kLWp006318
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 02:46:36 -0500
Received: by rv-out-0506.google.com with SMTP id f6so317134rvb.51
	for <video4linux-list@redhat.com>; Tue, 09 Dec 2008 23:46:35 -0800 (PST)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Wed, 10 Dec 2008 16:44:50 +0900
Message-Id: <20081210074450.5727.83002.sendpatchset@rx1.opensource.se>
In-Reply-To: <20081210074435.5727.93374.sendpatchset@rx1.opensource.se>
References: <20081210074435.5727.93374.sendpatchset@rx1.opensource.se>
Cc: g.liakhovetski@gmx.de
Subject: [PATCH 02/03] sh_mobile_ceu: add NV12 and NV21 support
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

From: Magnus Damm <damm@igel.co.jp>

This patch adds NV12/NV21 support to the sh_mobile_ceu driver.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/sh_mobile_ceu_camera.c |  114 ++++++++++++++++++++++++----
 1 file changed, 99 insertions(+), 15 deletions(-)

--- 0031/drivers/media/video/sh_mobile_ceu_camera.c
+++ work/drivers/media/video/sh_mobile_ceu_camera.c	2008-12-10 13:09:43.000000000 +0900
@@ -99,6 +99,8 @@ struct sh_mobile_ceu_dev {
 	struct videobuf_buffer *active;
 
 	struct sh_mobile_ceu_info *pdata;
+
+	const struct soc_camera_data_format *camera_fmt;
 };
 
 static void ceu_write(struct sh_mobile_ceu_dev *priv,
@@ -158,6 +160,9 @@ static void free_buffer(struct videobuf_
 
 static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 {
+	struct soc_camera_device *icd = pcdev->icd;
+	unsigned long phys_addr;
+
 	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) & ~1);
 	ceu_write(pcdev, CETCR, ~ceu_read(pcdev, CETCR) & 0x0317f313);
 	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) | 1);
@@ -166,11 +171,21 @@ static void sh_mobile_ceu_capture(struct
 
 	ceu_write(pcdev, CETCR, 0x0317f313 ^ 0x10);
 
-	if (pcdev->active) {
-		pcdev->active->state = VIDEOBUF_ACTIVE;
-		ceu_write(pcdev, CDAYR, videobuf_to_dma_contig(pcdev->active));
-		ceu_write(pcdev, CAPSR, 0x1); /* start capture */
+	if (!pcdev->active)
+		return;
+
+	phys_addr = videobuf_to_dma_contig(pcdev->active);
+	ceu_write(pcdev, CDAYR, phys_addr);
+
+	switch (icd->current_fmt->fourcc) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+		phys_addr += (icd->width * icd->height);
+		ceu_write(pcdev, CDACR, phys_addr);
 	}
+
+	pcdev->active->state = VIDEOBUF_ACTIVE;
+	ceu_write(pcdev, CAPSR, 0x1); /* start capture */
 }
 
 static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
@@ -364,6 +379,7 @@ static int sh_mobile_ceu_set_bus_param(s
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	int ret, buswidth, width, cfszr_width, cdwdr_width;
 	unsigned long camera_flags, common_flags, value;
+	int yuv_mode, yuv_lineskip;
 
 	camera_flags = icd->ops->query_bus_param(icd);
 	common_flags = soc_camera_bus_param_compatible(camera_flags,
@@ -389,7 +405,35 @@ static int sh_mobile_ceu_set_bus_param(s
 	ceu_write(pcdev, CRCNTR, 0);
 	ceu_write(pcdev, CRCMPR, 0);
 
-	value = 0x00000010;
+	value = 0x00000010; /* data fetch by default */
+	yuv_mode = yuv_lineskip = 0;
+
+	switch (icd->current_fmt->fourcc) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+		yuv_lineskip = 1; /* skip for NV12/21, no skip for NV16/61 */
+		yuv_mode = 1;
+		switch (pcdev->camera_fmt->fourcc) {
+		case V4L2_PIX_FMT_UYVY:
+			value = 0x00000000; /* Cb0, Y0, Cr0, Y1 */
+			break;
+		case V4L2_PIX_FMT_VYUY:
+			value = 0x00000100; /* Cr0, Y0, Cb0, Y1 */
+			break;
+		case V4L2_PIX_FMT_YUYV:
+			value = 0x00000200; /* Y0, Cb0, Y1, Cr0 */
+			break;
+		case V4L2_PIX_FMT_YVYU:
+			value = 0x00000300; /* Y0, Cr0, Y1, Cb0 */
+			break;
+		default:
+			BUG();
+		}
+	}
+
+	if (icd->current_fmt->fourcc == V4L2_PIX_FMT_NV21)
+		value ^= 0x00000100; /* swap U, V to change from NV12->NV21 */
+
 	value |= (common_flags & SOCAM_VSYNC_ACTIVE_LOW) ? (1 << 1) : 0;
 	value |= (common_flags & SOCAM_HSYNC_ACTIVE_LOW) ? (1 << 0) : 0;
 	value |= (buswidth == 16) ? (1 << 12) : 0;
@@ -400,16 +444,22 @@ static int sh_mobile_ceu_set_bus_param(s
 
 	mdelay(1);
 
-	width = icd->width * (icd->current_fmt->depth / 8);
-	width = (buswidth == 16) ? width / 2 : width;
-	cfszr_width = (buswidth == 8) ? width / 2 : width;
-	cdwdr_width = (buswidth == 16) ? width * 2 : width;
+	if (yuv_mode) {
+		width = icd->width * 2;
+		width = (buswidth == 16) ? width / 2 : width;
+		cfszr_width = cdwdr_width = icd->width;
+	} else {
+		width = icd->width * ((icd->current_fmt->depth + 7) >> 3);
+		width = (buswidth == 16) ? width / 2 : width;
+		cfszr_width = (buswidth == 8) ? width / 2 : width;
+		cdwdr_width = (buswidth == 16) ? width * 2 : width;
+	}
 
 	ceu_write(pcdev, CAMOR, 0);
 	ceu_write(pcdev, CAPWR, (icd->height << 16) | width);
-	ceu_write(pcdev, CFLCR, 0); /* data fetch mode - no scaling */
+	ceu_write(pcdev, CFLCR, 0); /* no scaling */
 	ceu_write(pcdev, CFSZR, (icd->height << 16) | cfszr_width);
-	ceu_write(pcdev, CLFCR, 0); /* data fetch mode - no lowpass filter */
+	ceu_write(pcdev, CLFCR, 0); /* no lowpass filter */
 
 	/* A few words about byte order (observed in Big Endian mode)
 	 *
@@ -423,14 +473,16 @@ static int sh_mobile_ceu_set_bus_param(s
 	 * using 7 we swap the data bytes to match the incoming order:
 	 * D0, D1, D2, D3, D4, D5, D6, D7
 	 */
-	ceu_write(pcdev, CDOCR, 0x00000017);
+	value = 0x00000017;
+	if (yuv_lineskip)
+		value &= ~0x00000010; /* convert 4:2:2 -> 4:2:0 */
+
+	ceu_write(pcdev, CDOCR, value);
 
 	ceu_write(pcdev, CDWDR, cdwdr_width);
 	ceu_write(pcdev, CFWCR, 0); /* keep "datafetch firewall" disabled */
 
 	/* not in bundle mode: skip CBDSR, CDAYR2, CDACR2, CDBYR2, CDBCR2 */
-	/* in data fetch mode: no need for CDACR, CDBYR, CDBCR */
-
 	return 0;
 }
 
@@ -449,11 +501,26 @@ static int sh_mobile_ceu_try_bus_param(s
 	return 0;
 }
 
+static const struct soc_camera_data_format sh_mobile_ceu_formats[] = {
+	{
+		.name		= "NV12",
+		.depth		= 12,
+		.fourcc		= V4L2_PIX_FMT_NV12,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	},
+	{
+		.name		= "NV21",
+		.depth		= 12,
+		.fourcc		= V4L2_PIX_FMT_NV21,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	},
+};
+
 static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 				     struct soc_camera_format_xlate *xlate)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	int ret;
+	int ret, k, n;
 	int formats = 0;
 
 	ret = sh_mobile_ceu_try_bus_param(icd);
@@ -461,6 +528,21 @@ static int sh_mobile_ceu_get_formats(str
 		return 0;
 
 	switch (icd->formats[idx].fourcc) {
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+		n = ARRAY_SIZE(sh_mobile_ceu_formats);
+		formats += n;
+		for (k = 0; xlate && k < n; k++) {
+			xlate->host_fmt = &sh_mobile_ceu_formats[k];
+			xlate->cam_fmt = icd->formats + idx;
+			xlate->buswidth = icd->formats[idx].depth;
+			xlate++;
+			dev_dbg(&ici->dev, "Providing format %s using %s\n",
+				sh_mobile_ceu_formats[k].name,
+				icd->formats[idx].name);
+		}
 	default:
 		/* Generic pass-through */
 		formats++;
@@ -482,6 +564,7 @@ static int sh_mobile_ceu_set_fmt(struct 
 				 __u32 pixfmt, struct v4l2_rect *rect)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	const struct soc_camera_format_xlate *xlate;
 	int ret;
 
@@ -502,6 +585,7 @@ static int sh_mobile_ceu_set_fmt(struct 
 	if (pixfmt && !ret) {
 		icd->buswidth = xlate->buswidth;
 		icd->current_fmt = xlate->host_fmt;
+		pcdev->camera_fmt = xlate->cam_fmt;
 	}
 
 	return ret;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
