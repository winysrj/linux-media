Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:42523 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751854AbbKCFij (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 00:38:39 -0500
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/5] media: atmel-isi: correct yuv swap according to different sensor outputs
Date: Tue, 3 Nov 2015 13:45:08 +0800
Message-ID: <1446529512-19109-2-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1446529512-19109-1-git-send-email-josh.wu@atmel.com>
References: <1446529512-19109-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

we need to configure the YCC_SWAP bits in ISI_CFG2 according to current
sensor output and Atmel ISI output format.

Current there are two cases Atmel ISI supported:
  1. Atmel ISI outputs YUYV format.
     This case we need to setup YCC_SWAP according to sensor output
     format.
  2. Atmel ISI output a pass-through formats, which means no swap.
     Just setup YCC_SWAP as default with no swap.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

Changes in v2:
- remove the duplicated variable: cfg2_yuv_swap.

 drivers/media/platform/soc_camera/atmel-isi.c | 39 ++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 45e304a..ce87a16 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -103,13 +103,37 @@ static u32 isi_readl(struct atmel_isi *isi, u32 reg)
 	return readl(isi->regs + reg);
 }
 
+static u32 setup_cfg2_yuv_swap(struct atmel_isi *isi,
+		const struct soc_camera_format_xlate *xlate)
+{
+	if (xlate->host_fmt->fourcc == V4L2_PIX_FMT_YUYV) {
+		/* all convert to YUYV */
+		switch (xlate->code) {
+		case MEDIA_BUS_FMT_VYUY8_2X8:
+			return ISI_CFG2_YCC_SWAP_MODE_3;
+		case MEDIA_BUS_FMT_UYVY8_2X8:
+			return ISI_CFG2_YCC_SWAP_MODE_2;
+		case MEDIA_BUS_FMT_YVYU8_2X8:
+			return ISI_CFG2_YCC_SWAP_MODE_1;
+		}
+	}
+
+	/*
+	 * By default, no swap for the codec path of Atmel ISI. So codec
+	 * output is same as sensor's output.
+	 * For instance, if sensor's output is YUYV, then codec outputs YUYV.
+	 * And if sensor's output is UYVY, then codec outputs UYVY.
+	 */
+	return ISI_CFG2_YCC_SWAP_DEFAULT;
+}
+
 static void configure_geometry(struct atmel_isi *isi, u32 width,
-			u32 height, u32 code)
+		u32 height, const struct soc_camera_format_xlate *xlate)
 {
 	u32 cfg2;
 
 	/* According to sensor's output format to set cfg2 */
-	switch (code) {
+	switch (xlate->code) {
 	default:
 	/* Grey */
 	case MEDIA_BUS_FMT_Y8_1X8:
@@ -117,16 +141,11 @@ static void configure_geometry(struct atmel_isi *isi, u32 width,
 		break;
 	/* YUV */
 	case MEDIA_BUS_FMT_VYUY8_2X8:
-		cfg2 = ISI_CFG2_YCC_SWAP_MODE_3 | ISI_CFG2_COL_SPACE_YCbCr;
-		break;
 	case MEDIA_BUS_FMT_UYVY8_2X8:
-		cfg2 = ISI_CFG2_YCC_SWAP_MODE_2 | ISI_CFG2_COL_SPACE_YCbCr;
-		break;
 	case MEDIA_BUS_FMT_YVYU8_2X8:
-		cfg2 = ISI_CFG2_YCC_SWAP_MODE_1 | ISI_CFG2_COL_SPACE_YCbCr;
-		break;
 	case MEDIA_BUS_FMT_YUYV8_2X8:
-		cfg2 = ISI_CFG2_YCC_SWAP_DEFAULT | ISI_CFG2_COL_SPACE_YCbCr;
+		cfg2 = ISI_CFG2_COL_SPACE_YCbCr |
+				setup_cfg2_yuv_swap(isi, xlate);
 		break;
 	/* RGB, TODO */
 	}
@@ -407,7 +426,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	isi_writel(isi, ISI_INTDIS, (u32)~0UL);
 
 	configure_geometry(isi, icd->user_width, icd->user_height,
-				icd->current_fmt->code);
+				icd->current_fmt);
 
 	spin_lock_irq(&isi->lock);
 	/* Clear any pending interrupt */
-- 
1.9.1

