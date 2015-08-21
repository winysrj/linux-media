Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:50780 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbbHUICk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 04:02:40 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Josh Wu <josh.wu@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/3] media: atmel-isi: setup the ISI_CFG2 register directly
Date: Fri, 21 Aug 2015 16:08:12 +0800
Message-ID: <1440144494-11800-1-git-send-email-josh.wu@atmel.com>
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

Changes in v3: None
Changes in v2:
- add Laurent's reviewed-by tag.

 drivers/media/platform/soc_camera/atmel-isi.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index f39132c..b67da70 100644
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
+		cfg2 = ISI_CFG2_GRAYSCALE;
 		break;
 	case MEDIA_BUS_FMT_VYUY8_2X8:
-		cr = ISI_CFG2_YCC_SWAP_MODE_3;
+		cfg2 = ISI_CFG2_YCC_SWAP_MODE_3;
 		break;
 	case MEDIA_BUS_FMT_UYVY8_2X8:
-		cr = ISI_CFG2_YCC_SWAP_MODE_2;
+		cfg2 = ISI_CFG2_YCC_SWAP_MODE_2;
 		break;
 	case MEDIA_BUS_FMT_YVYU8_2X8:
-		cr = ISI_CFG2_YCC_SWAP_MODE_1;
+		cfg2 = ISI_CFG2_YCC_SWAP_MODE_1;
 		break;
 	case MEDIA_BUS_FMT_YUYV8_2X8:
-		cr = ISI_CFG2_YCC_SWAP_DEFAULT;
+		cfg2 = ISI_CFG2_YCC_SWAP_DEFAULT;
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
-- 
1.9.1

