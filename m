Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:44148 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZKPFaQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 00:30:16 -0500
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id nAG5UJeG008378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 15 Nov 2009 23:30:21 -0600
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: m-karicheri2@ti.com, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH] DM644x CCDC: Add 10bit BT support
Date: Mon, 16 Nov 2009 11:00:15 +0530
Message-Id: <1258349415-18499-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Reviewed-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
 drivers/media/video/davinci/dm644x_ccdc.c      |   17 +++++++++++++----
 drivers/media/video/davinci/dm644x_ccdc_regs.h |    8 ++++++++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
index 2f19a91..9d601b4 100644
--- a/drivers/media/video/davinci/dm644x_ccdc.c
+++ b/drivers/media/video/davinci/dm644x_ccdc.c
@@ -394,7 +394,11 @@ void ccdc_config_ycbcr(void)
 		 * configure the FID, VD, HD pin polarity,
 		 * fld,hd pol positive, vd negative, 8-bit data
 		 */
-		syn_mode |= CCDC_SYN_MODE_VD_POL_NEGATIVE | CCDC_SYN_MODE_8BITS;
+		syn_mode |= CCDC_SYN_MODE_VD_POL_NEGATIVE;
+		if (ccdc_if_type == VPFE_BT656_10BIT)
+			syn_mode |= CCDC_SYN_MODE_10BITS;
+		else
+			syn_mode |= CCDC_SYN_MODE_8BITS;
 	} else {
 		/* y/c external sync mode */
 		syn_mode |= (((params->fid_pol & CCDC_FID_POL_MASK) <<
@@ -413,8 +417,13 @@ void ccdc_config_ycbcr(void)
 	 * configure the order of y cb cr in SDRAM, and disable latch
 	 * internal register on vsync
 	 */
-	regw((params->pix_order << CCDC_CCDCFG_Y8POS_SHIFT) |
-		 CCDC_LATCH_ON_VSYNC_DISABLE, CCDC_CCDCFG);
+	if (ccdc_if_type == VPFE_BT656_10BIT)
+		regw((params->pix_order << CCDC_CCDCFG_Y8POS_SHIFT) |
+			CCDC_LATCH_ON_VSYNC_DISABLE | CCDC_CCDCFG_BW656_10BIT,
+			CCDC_CCDCFG);
+	else
+		regw((params->pix_order << CCDC_CCDCFG_Y8POS_SHIFT) |
+			CCDC_LATCH_ON_VSYNC_DISABLE, CCDC_CCDCFG);

 	/*
 	 * configure the horizontal line offset. This should be a
@@ -429,7 +438,6 @@ void ccdc_config_ycbcr(void)

 	ccdc_sbl_reset();
 	dev_dbg(dev, "\nEnd of ccdc_config_ycbcr...\n");
-	ccdc_readregs();
 }

 static void ccdc_config_black_clamp(struct ccdc_black_clamp *bclamp)
@@ -822,6 +830,7 @@ static int ccdc_set_hw_if_params(struct vpfe_hw_if_param *params)
 	case VPFE_BT656:
 	case VPFE_YCBCR_SYNC_16:
 	case VPFE_YCBCR_SYNC_8:
+	case VPFE_BT656_10BIT:
 		ccdc_hw_params_ycbcr.vd_pol = params->vdpol;
 		ccdc_hw_params_ycbcr.hd_pol = params->hdpol;
 		break;
diff --git a/drivers/media/video/davinci/dm644x_ccdc_regs.h b/drivers/media/video/davinci/dm644x_ccdc_regs.h
index 6e5d053..b18d166 100644
--- a/drivers/media/video/davinci/dm644x_ccdc_regs.h
+++ b/drivers/media/video/davinci/dm644x_ccdc_regs.h
@@ -135,11 +135,19 @@
 #define CCDC_SYN_MODE_INPMOD_SHIFT		12
 #define CCDC_SYN_MODE_INPMOD_MASK		3
 #define CCDC_SYN_MODE_8BITS			(7 << 8)
+#define CCDC_SYN_MODE_10BITS			(6 << 8)
+#define CCDC_SYN_MODE_11BITS			(5 << 8)
+#define CCDC_SYN_MODE_12BITS			(4 << 8)
+#define CCDC_SYN_MODE_13BITS			(3 << 8)
+#define CCDC_SYN_MODE_14BITS			(2 << 8)
+#define CCDC_SYN_MODE_15BITS			(1 << 8)
+#define CCDC_SYN_MODE_16BITS			(0 << 8)
 #define CCDC_SYN_FLDMODE_MASK			1
 #define CCDC_SYN_FLDMODE_SHIFT			7
 #define CCDC_REC656IF_BT656_EN			3
 #define CCDC_SYN_MODE_VD_POL_NEGATIVE		(1 << 2)
 #define CCDC_CCDCFG_Y8POS_SHIFT			11
+#define CCDC_CCDCFG_BW656_10BIT 		(1 << 5)
 #define CCDC_SDOFST_FIELD_INTERLEAVED		0x249
 #define CCDC_NO_CULLING				0xffff00ff
 #endif
--
1.6.2.4

