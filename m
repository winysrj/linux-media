Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:47809 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0CSGEV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 02:04:21 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id o2J64I89010389
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 01:04:20 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: m-karicheri2@ti.com, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V2 3/7] DM644x CCDC: Add 10bit BT support
Date: Fri, 19 Mar 2010 11:34:09 +0530
Message-Id: <1268978653-32710-4-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/davinci/dm644x_ccdc.c      |   16 +++++++++++++---
 drivers/media/video/davinci/dm644x_ccdc_regs.h |    8 ++++++++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
index 840eee9..0ea7ea2 100644
--- a/drivers/media/video/davinci/dm644x_ccdc.c
+++ b/drivers/media/video/davinci/dm644x_ccdc.c
@@ -399,7 +399,11 @@ void ccdc_config_ycbcr(void)
 		 * configure the FID, VD, HD pin polarity,
 		 * fld,hd pol positive, vd negative, 8-bit data
 		 */
-		syn_mode |= CCDC_SYN_MODE_VD_POL_NEGATIVE | CCDC_SYN_MODE_8BITS;
+		syn_mode |= CCDC_SYN_MODE_VD_POL_NEGATIVE;
+		if (ccdc_cfg.if_type == VPFE_BT656_10BIT)
+			syn_mode |= CCDC_SYN_MODE_10BITS;
+		else
+			syn_mode |= CCDC_SYN_MODE_8BITS;
 	} else {
 		/* y/c external sync mode */
 		syn_mode |= (((params->fid_pol & CCDC_FID_POL_MASK) <<
@@ -418,8 +422,13 @@ void ccdc_config_ycbcr(void)
 	 * configure the order of y cb cr in SDRAM, and disable latch
 	 * internal register on vsync
 	 */
-	regw((params->pix_order << CCDC_CCDCFG_Y8POS_SHIFT) |
-		 CCDC_LATCH_ON_VSYNC_DISABLE, CCDC_CCDCFG);
+	if (ccdc_cfg.if_type == VPFE_BT656_10BIT)
+		regw((params->pix_order << CCDC_CCDCFG_Y8POS_SHIFT) |
+			CCDC_LATCH_ON_VSYNC_DISABLE | CCDC_CCDCFG_BW656_10BIT,
+			CCDC_CCDCFG);
+	else
+		regw((params->pix_order << CCDC_CCDCFG_Y8POS_SHIFT) |
+			CCDC_LATCH_ON_VSYNC_DISABLE, CCDC_CCDCFG);

 	/*
 	 * configure the horizontal line offset. This should be a
@@ -825,6 +834,7 @@ static int ccdc_set_hw_if_params(struct vpfe_hw_if_param *params)
 	case VPFE_BT656:
 	case VPFE_YCBCR_SYNC_16:
 	case VPFE_YCBCR_SYNC_8:
+	case VPFE_BT656_10BIT:
 		ccdc_cfg.ycbcr.vd_pol = params->vdpol;
 		ccdc_cfg.ycbcr.hd_pol = params->hdpol;
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

