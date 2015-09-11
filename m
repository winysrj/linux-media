Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:54118 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbbIKGyc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 02:54:32 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-arm-kernel@lists.infradead.org>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v4 1/3] media: atmel-isi: setup the ISI_CFG2 register directly
Date: Fri, 11 Sep 2015 15:00:14 +0800
Message-ID: <1441954816-11285-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the function configure_geometry(), we will setup the ISI CFG2
according to the sensor output format.

It make no sense to just read back the CFG2 register and just set part
of it.

So just set up this register directly makes things simpler.
Currently only support YUV format from camera sensor.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---

Changes in v4:
- add a COL_SPACE_YCbCr for cfg2

Changes in v3: None
Changes in v2:
- add Laurent's reviewed-by tag.

 drivers/media/platform/soc_camera/atmel-isi.c | 20 +++++++-------------
 include/media/atmel-isi.h                     |  2 ++
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index f39132c..a76c609 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -105,24 +105,25 @@ static u32 isi_readl(struct atmel_isi *isi, u32 reg)
 static int configure_geometry(struct atmel_isi *isi, u32 width,
 			u32 height, u32 code)
 {
-	u32 cfg2, cr;
+	u32 cfg2;
 
+	/* According to sensor's output format to set cfg2 */
 	switch (code) {
 	/* YUV, including grey */
 	case MEDIA_BUS_FMT_Y8_1X8:
-		cr = ISI_CFG2_GRAYSCALE;
+		cfg2 = ISI_CFG2_GRAYSCALE | ISI_CFG2_COL_SPACE_YCbCr;
 		break;
 	case MEDIA_BUS_FMT_VYUY8_2X8:
-		cr = ISI_CFG2_YCC_SWAP_MODE_3;
+		cfg2 = ISI_CFG2_YCC_SWAP_MODE_3 | ISI_CFG2_COL_SPACE_YCbCr;
 		break;
 	case MEDIA_BUS_FMT_UYVY8_2X8:
-		cr = ISI_CFG2_YCC_SWAP_MODE_2;
+		cfg2 = ISI_CFG2_YCC_SWAP_MODE_2 | ISI_CFG2_COL_SPACE_YCbCr;
 		break;
 	case MEDIA_BUS_FMT_YVYU8_2X8:
-		cr = ISI_CFG2_YCC_SWAP_MODE_1;
+		cfg2 = ISI_CFG2_YCC_SWAP_MODE_1 | ISI_CFG2_COL_SPACE_YCbCr;
 		break;
 	case MEDIA_BUS_FMT_YUYV8_2X8:
-		cr = ISI_CFG2_YCC_SWAP_DEFAULT;
+		cfg2 = ISI_CFG2_YCC_SWAP_DEFAULT | ISI_CFG2_COL_SPACE_YCbCr;
 		break;
 	/* RGB, TODO */
 	default:
@@ -130,17 +131,10 @@ static int configure_geometry(struct atmel_isi *isi, u32 width,
 	}
 
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
-
-	cfg2 = isi_readl(isi, ISI_CFG2);
-	/* Set YCC swap mode */
-	cfg2 &= ~ISI_CFG2_YCC_SWAP_MODE_MASK;
-	cfg2 |= cr;
 	/* Set width */
-	cfg2 &= ~(ISI_CFG2_IM_HSIZE_MASK);
 	cfg2 |= ((width - 1) << ISI_CFG2_IM_HSIZE_OFFSET) &
 			ISI_CFG2_IM_HSIZE_MASK;
 	/* Set height */
-	cfg2 &= ~(ISI_CFG2_IM_VSIZE_MASK);
 	cfg2 |= ((height - 1) << ISI_CFG2_IM_VSIZE_OFFSET)
 			& ISI_CFG2_IM_VSIZE_MASK;
 	isi_writel(isi, ISI_CFG2, cfg2);
diff --git a/include/media/atmel-isi.h b/include/media/atmel-isi.h
index 6008b09..e7a96b8 100644
--- a/include/media/atmel-isi.h
+++ b/include/media/atmel-isi.h
@@ -66,6 +66,8 @@
 
 /* Bitfields in CFG2 */
 #define ISI_CFG2_GRAYSCALE			(1 << 13)
+#define ISI_CFG2_COL_SPACE_YCbCr		(0 << 15)
+#define ISI_CFG2_COL_SPACE_RGB			(1 << 15)
 /* Constants for YCC_SWAP(ISI_V2) */
 #define		ISI_CFG2_YCC_SWAP_DEFAULT	(0 << 28)
 #define		ISI_CFG2_YCC_SWAP_MODE_1	(1 << 28)
-- 
1.9.1

