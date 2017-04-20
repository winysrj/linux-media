Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12661 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943796AbdDTIwg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Apr 2017 04:52:36 -0400
From: Songjun Wu <songjun.wu@microchip.com>
To: <nicolas.ferre@microchip.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Songjun Wu <songjun.wu@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: [PATCH] [media] atmel-isc: Set the default DMA memory burst size
Date: Thu, 20 Apr 2017 16:51:30 +0800
Message-ID: <20170420085130.24326-1-songjun.wu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes 'DMA single access' is not enough to transfer
a frame of image, '8-beat burst access' is set as the
default DMA memory burst size.

Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
---

 drivers/media/platform/atmel/atmel-isc.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index c4b2115559a5..78d966233f80 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -239,13 +239,11 @@ static struct isc_format isc_formats[] = {
 
 	{ V4L2_PIX_FMT_YUV420, 0x0, 12,
 	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_YYCC,
-	  ISC_DCFG_IMODE_YC420P | ISC_DCFG_YMBSIZE_BEATS8 |
-	  ISC_DCFG_CMBSIZE_BEATS8, ISC_DCTRL_DVIEW_PLANAR, 0x7fb,
+	  ISC_DCFG_IMODE_YC420P, ISC_DCTRL_DVIEW_PLANAR, 0x7fb,
 	  false, false },
 	{ V4L2_PIX_FMT_YUV422P, 0x0, 16,
 	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_YYCC,
-	  ISC_DCFG_IMODE_YC422P | ISC_DCFG_YMBSIZE_BEATS8 |
-	  ISC_DCFG_CMBSIZE_BEATS8, ISC_DCTRL_DVIEW_PLANAR, 0x3fb,
+	  ISC_DCFG_IMODE_YC422P, ISC_DCTRL_DVIEW_PLANAR, 0x3fb,
 	  false, false },
 	{ V4L2_PIX_FMT_RGB565, MEDIA_BUS_FMT_RGB565_2X8_LE, 16,
 	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_RGB565,
@@ -700,8 +698,10 @@ static void isc_set_histogram(struct isc_device *isc)
 }
 
 static inline void isc_get_param(const struct isc_format *fmt,
-				     u32 *rlp_mode, u32 *dcfg_imode)
+				  u32 *rlp_mode, u32 *dcfg)
 {
+	*dcfg = ISC_DCFG_YMBSIZE_BEATS8;
+
 	switch (fmt->fourcc) {
 	case V4L2_PIX_FMT_SBGGR10:
 	case V4L2_PIX_FMT_SGBRG10:
@@ -712,11 +712,11 @@ static inline void isc_get_param(const struct isc_format *fmt,
 	case V4L2_PIX_FMT_SGRBG12:
 	case V4L2_PIX_FMT_SRGGB12:
 		*rlp_mode = fmt->reg_rlp_mode;
-		*dcfg_imode = fmt->reg_dcfg_imode;
+		*dcfg |= fmt->reg_dcfg_imode;
 		break;
 	default:
 		*rlp_mode = ISC_RLP_CFG_MODE_DAT8;
-		*dcfg_imode = ISC_DCFG_IMODE_PACKED8;
+		*dcfg |= ISC_DCFG_IMODE_PACKED8;
 		break;
 	}
 }
@@ -726,18 +726,19 @@ static int isc_configure(struct isc_device *isc)
 	struct regmap *regmap = isc->regmap;
 	const struct isc_format *current_fmt = isc->current_fmt;
 	struct isc_subdev_entity *subdev = isc->current_subdev;
-	u32 pfe_cfg0, rlp_mode, dcfg_imode, mask, pipeline;
+	u32 pfe_cfg0, rlp_mode, dcfg, mask, pipeline;
 
 	if (sensor_is_preferred(current_fmt)) {
 		pfe_cfg0 = current_fmt->reg_bps;
 		pipeline = 0x0;
-		isc_get_param(current_fmt, &rlp_mode, &dcfg_imode);
+		isc_get_param(current_fmt, &rlp_mode, &dcfg);
 		isc->ctrls.hist_stat = HIST_INIT;
 	} else {
 		pfe_cfg0  = isc->raw_fmt->reg_bps;
 		pipeline = current_fmt->pipeline;
 		rlp_mode = current_fmt->reg_rlp_mode;
-		dcfg_imode = current_fmt->reg_dcfg_imode;
+		dcfg = current_fmt->reg_dcfg_imode | ISC_DCFG_YMBSIZE_BEATS8 |
+		       ISC_DCFG_CMBSIZE_BEATS8;
 	}
 
 	pfe_cfg0  |= subdev->pfe_cfg0 | ISC_PFE_CFG0_MODE_PROGRESSIVE;
@@ -750,7 +751,7 @@ static int isc_configure(struct isc_device *isc)
 	regmap_update_bits(regmap, ISC_RLP_CFG, ISC_RLP_CFG_MODE_MASK,
 			   rlp_mode);
 
-	regmap_update_bits(regmap, ISC_DCFG, ISC_DCFG_IMODE_MASK, dcfg_imode);
+	regmap_write(regmap, ISC_DCFG, dcfg);
 
 	/* Set the pipeline */
 	isc_set_pipeline(isc, pipeline);
-- 
2.11.0
