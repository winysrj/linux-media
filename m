Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:54450 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbbIKG4k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 02:56:40 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-arm-kernel@lists.infradead.org>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v4 3/3] media: atmel-isi: add sanity check for supported formats in try/set_fmt()
Date: Fri, 11 Sep 2015 15:00:16 +0800
Message-ID: <1441954816-11285-3-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1441954816-11285-1-git-send-email-josh.wu@atmel.com>
References: <1441954816-11285-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After adding the format check in try_fmt()/set_fmt(), we don't need any
format check in configure_geometry(). So make configure_geometry() as
void type.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
Hi, Laurent

For the similiarity between set_fmt() and try_frm() function, it need more work than I thought.
So in this patch I didn't touch that part. I plan to try that later.

Best Regards,
Josh Wu

Changes in v4:
- correct the comment typo.

Changes in v3:
- check the whether format is supported, if no then return a default
  format.
- misc changes according to Laurent's feedback.

Changes in v2:
- new added patch

 drivers/media/platform/soc_camera/atmel-isi.c | 37 +++++++++++++++++++++------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index d727037..6e55d9f 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -102,17 +102,19 @@ static u32 isi_readl(struct atmel_isi *isi, u32 reg)
 	return readl(isi->regs + reg);
 }
 
-static int configure_geometry(struct atmel_isi *isi, u32 width,
+static void configure_geometry(struct atmel_isi *isi, u32 width,
 			u32 height, u32 code)
 {
 	u32 cfg2;
 
 	/* According to sensor's output format to set cfg2 */
 	switch (code) {
-	/* YUV, including grey */
+	default:
+	/* Grey */
 	case MEDIA_BUS_FMT_Y8_1X8:
 		cfg2 = ISI_CFG2_GRAYSCALE | ISI_CFG2_COL_SPACE_YCbCr;
 		break;
+	/* YUV */
 	case MEDIA_BUS_FMT_VYUY8_2X8:
 		cfg2 = ISI_CFG2_YCC_SWAP_MODE_3 | ISI_CFG2_COL_SPACE_YCbCr;
 		break;
@@ -126,8 +128,6 @@ static int configure_geometry(struct atmel_isi *isi, u32 width,
 		cfg2 = ISI_CFG2_YCC_SWAP_DEFAULT | ISI_CFG2_COL_SPACE_YCbCr;
 		break;
 	/* RGB, TODO */
-	default:
-		return -EINVAL;
 	}
 
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
@@ -138,8 +138,23 @@ static int configure_geometry(struct atmel_isi *isi, u32 width,
 	cfg2 |= ((height - 1) << ISI_CFG2_IM_VSIZE_OFFSET)
 			& ISI_CFG2_IM_VSIZE_MASK;
 	isi_writel(isi, ISI_CFG2, cfg2);
+}
 
-	return 0;
+static bool is_supported(struct soc_camera_device *icd,
+		const u32 pixformat)
+{
+	switch (pixformat) {
+	/* YUV, including grey */
+	case V4L2_PIX_FMT_GREY:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_VYUY:
+		return true;
+	/* RGB, TODO */
+	default:
+		return false;
+	}
 }
 
 static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
@@ -390,10 +405,8 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	/* Disable all interrupts */
 	isi_writel(isi, ISI_INTDIS, (u32)~0UL);
 
-	ret = configure_geometry(isi, icd->user_width, icd->user_height,
+	configure_geometry(isi, icd->user_width, icd->user_height,
 				icd->current_fmt->code);
-	if (ret < 0)
-		return ret;
 
 	spin_lock_irq(&isi->lock);
 	/* Clear any pending interrupt */
@@ -491,6 +504,10 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_mbus_framefmt *mf = &format.format;
 	int ret;
 
+	/* check with atmel-isi support format, if not support use YUYV */
+	if (!is_supported(icd, pix->pixelformat))
+		pix->pixelformat = V4L2_PIX_FMT_YUYV;
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
 		dev_warn(icd->parent, "Format %x not found\n",
@@ -540,6 +557,10 @@ static int isi_camera_try_fmt(struct soc_camera_device *icd,
 	u32 pixfmt = pix->pixelformat;
 	int ret;
 
+	/* check with atmel-isi support format, if not support use YUYV */
+	if (!is_supported(icd, pix->pixelformat))
+		pix->pixelformat = V4L2_PIX_FMT_YUYV;
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (pixfmt && !xlate) {
 		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
-- 
1.9.1

