Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:4959 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752333AbbHEDVl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 23:21:41 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3] media: atmel-isi: add sanity check for supported formats in set_fmt()
Date: Wed, 5 Aug 2015 11:26:29 +0800
Message-ID: <1438745190-21020-3-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1438745190-21020-1-git-send-email-josh.wu@atmel.com>
References: <1438745190-21020-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After adding the format check in set_fmt(), we don't need any format check
in configure_geometry(). So make configure_geometry() as void type.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

Changes in v2:
- new added patch

 drivers/media/platform/soc_camera/atmel-isi.c | 39 +++++++++++++++++++++------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index cb46aec..d0df518 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -103,17 +103,19 @@ static u32 isi_readl(struct atmel_isi *isi, u32 reg)
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
 		cfg2 = ISI_CFG2_GRAYSCALE;
 		break;
+	/* YUV */
 	case MEDIA_BUS_FMT_VYUY8_2X8:
 		cfg2 = ISI_CFG2_YCC_SWAP_MODE_3;
 		break;
@@ -127,8 +129,6 @@ static int configure_geometry(struct atmel_isi *isi, u32 width,
 		cfg2 = ISI_CFG2_YCC_SWAP_DEFAULT;
 		break;
 	/* RGB, TODO */
-	default:
-		return -EINVAL;
 	}
 
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
@@ -139,8 +139,29 @@ static int configure_geometry(struct atmel_isi *isi, u32 width,
 	cfg2 |= ((height - 1) << ISI_CFG2_IM_VSIZE_OFFSET)
 			& ISI_CFG2_IM_VSIZE_MASK;
 	isi_writel(isi, ISI_CFG2, cfg2);
+}
 
-	return 0;
+static bool is_supported(struct soc_camera_device *icd,
+		const struct soc_camera_format_xlate *xlate)
+{
+	bool ret = true;
+
+	switch (xlate->code) {
+	/* YUV, including grey */
+	case MEDIA_BUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_VYUY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_YVYU8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+		break;
+	/* RGB, TODO */
+	default:
+		dev_err(icd->parent, "not supported format: %d\n",
+					xlate->code);
+		ret = false;
+	}
+
+	return ret;
 }
 
 static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
@@ -391,10 +412,8 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	/* Disable all interrupts */
 	isi_writel(isi, ISI_INTDIS, (u32)~0UL);
 
-	ret = configure_geometry(isi, icd->user_width, icd->user_height,
+	configure_geometry(isi, icd->user_width, icd->user_height,
 				icd->current_fmt->code);
-	if (ret < 0)
-		return ret;
 
 	spin_lock_irq(&isi->lock);
 	/* Clear any pending interrupt */
@@ -515,6 +534,10 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
 	if (mf->code != xlate->code)
 		return -EINVAL;
 
+	/* check with atmel-isi support format */
+	if (!is_supported(icd, xlate))
+		return -EINVAL;
+
 	pix->width		= mf->width;
 	pix->height		= mf->height;
 	pix->field		= mf->field;
-- 
1.9.1

