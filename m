Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:3727 "EHLO
        DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751674AbdHQHX0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 03:23:26 -0400
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: Nicolas Ferre <nicolas.ferre@microchip.com>,
        <linux-kernel@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        "Jonathan Corbet" <corbet@lwn.net>,
        <linux-arm-kernel@lists.infradead.org>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH 2/3] media: atmel-isc: Remove the redundant assignment
Date: Thu, 17 Aug 2017 15:16:13 +0800
Message-ID: <20170817071614.12767-3-wenyou.yang@microchip.com>
In-Reply-To: <20170817071614.12767-1-wenyou.yang@microchip.com>
References: <20170817071614.12767-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the redundant assignment of members in the isc_formats array.

Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
---

 drivers/media/platform/atmel/atmel-isc.c | 64 ++++++++++++++++----------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 535bb03783fe..d91f4e5f8a8d 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -187,74 +187,74 @@ struct isc_device {
 #define ISC_FMT_IND_END      14
 
 static struct isc_format isc_formats[] = {
+	/* 0 */
 	{ V4L2_PIX_FMT_SBGGR8, MEDIA_BUS_FMT_SBGGR8_1X8, 8,
 	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT8,
-	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
-	  false, false },
+	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0 },
+	/* 1 */
 	{ V4L2_PIX_FMT_SGBRG8, MEDIA_BUS_FMT_SGBRG8_1X8, 8,
 	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_GBGB, ISC_RLP_CFG_MODE_DAT8,
-	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
-	  false, false },
+	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0 },
+	/* 2 */
 	{ V4L2_PIX_FMT_SGRBG8, MEDIA_BUS_FMT_SGRBG8_1X8, 8,
 	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_GRGR, ISC_RLP_CFG_MODE_DAT8,
-	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
-	  false, false },
+	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0 },
+	/* 3 */
 	{ V4L2_PIX_FMT_SRGGB8, MEDIA_BUS_FMT_SRGGB8_1X8, 8,
 	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_RGRG, ISC_RLP_CFG_MODE_DAT8,
-	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
-	  false, false },
+	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0 },
 
+	/* 4 */
 	{ V4L2_PIX_FMT_SBGGR10, MEDIA_BUS_FMT_SBGGR10_1X10, 16,
 	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT10,
-	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
-	  false, false },
+	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0 },
+	/* 5 */
 	{ V4L2_PIX_FMT_SGBRG10, MEDIA_BUS_FMT_SGBRG10_1X10, 16,
 	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_GBGB, ISC_RLP_CFG_MODE_DAT10,
-	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
-	  false, false },
+	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0 },
+	/* 6 */
 	{ V4L2_PIX_FMT_SGRBG10, MEDIA_BUS_FMT_SGRBG10_1X10, 16,
 	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_GRGR, ISC_RLP_CFG_MODE_DAT10,
-	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
-	  false, false },
+	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0 },
+	/* 7 */
 	{ V4L2_PIX_FMT_SRGGB10, MEDIA_BUS_FMT_SRGGB10_1X10, 16,
 	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_RGRG, ISC_RLP_CFG_MODE_DAT10,
-	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
-	  false, false },
+	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0 },
 
+	/* 8 */
 	{ V4L2_PIX_FMT_SBGGR12, MEDIA_BUS_FMT_SBGGR12_1X12, 16,
 	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT12,
-	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
-	  false, false },
+	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0 },
+	/* 9 */
 	{ V4L2_PIX_FMT_SGBRG12, MEDIA_BUS_FMT_SGBRG12_1X12, 16,
 	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_GBGB, ISC_RLP_CFG_MODE_DAT12,
-	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
-	  false, false },
+	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0 },
+	/* 10 */
 	{ V4L2_PIX_FMT_SGRBG12, MEDIA_BUS_FMT_SGRBG12_1X12, 16,
 	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_GRGR, ISC_RLP_CFG_MODE_DAT12,
-	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
-	  false, false },
+	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0 },
+	/* 11 */
 	{ V4L2_PIX_FMT_SRGGB12, MEDIA_BUS_FMT_SRGGB12_1X12, 16,
 	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_RGRG, ISC_RLP_CFG_MODE_DAT12,
-	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
-	  false, false },
+	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0 },
 
+	/* 12 */
 	{ V4L2_PIX_FMT_YUV420, 0x0, 12,
 	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_YYCC,
-	  ISC_DCFG_IMODE_YC420P, ISC_DCTRL_DVIEW_PLANAR, 0x7fb,
-	  false, false },
+	  ISC_DCFG_IMODE_YC420P, ISC_DCTRL_DVIEW_PLANAR, 0x7fb },
+	/* 13 */
 	{ V4L2_PIX_FMT_YUV422P, 0x0, 16,
 	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_YYCC,
-	  ISC_DCFG_IMODE_YC422P, ISC_DCTRL_DVIEW_PLANAR, 0x3fb,
-	  false, false },
+	  ISC_DCFG_IMODE_YC422P, ISC_DCTRL_DVIEW_PLANAR, 0x3fb },
+	/* 14 */
 	{ V4L2_PIX_FMT_RGB565, MEDIA_BUS_FMT_RGB565_2X8_LE, 16,
 	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_RGB565,
-	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x7b,
-	  false, false },
+	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x7b },
 
+	/* 15 */
 	{ V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_YUYV8_2X8, 16,
 	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT8,
-	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
-	  false, false },
+	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0 },
 };
 
 #define GAMMA_MAX	2
-- 
2.13.0
