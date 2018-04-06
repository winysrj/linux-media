Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:32782 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756616AbeDFOXc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 01/21] media: davinci_vpfe: remove useless checks from ipipe
Date: Fri,  6 Apr 2018 10:23:02 -0400
Message-Id: <1a0bbeca38f41f0063c83a83858b09a4d4baeb66.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dm365_ipipe_hw.c and dm365_ipipe.c file check if several table
pointers, declared at davinci_vpfe_user.h, are filled before using
them.

The problem is that those pointers come from struct declarations
like:

	struct vpfe_ipipe_yee {
	...
	short table[VPFE_IPIPE_MAX_SIZE_YEE_LUT];
	};

So, they can't be NULL! Solve those warnings:

    drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c:433 ipipe_set_lutdpc_regs() warn: this array is probably non-NULL. 'dpc->table'
    drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c:763 ipipe_set_gamma_regs() warn: this array is probably non-NULL. 'gamma->table_r'
    drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c:766 ipipe_set_gamma_regs() warn: this array is probably non-NULL. 'gamma->table_b'
    drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c:769 ipipe_set_gamma_regs() warn: this array is probably non-NULL. 'gamma->table_g'
    drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c:791 ipipe_set_3d_lut_regs() warn: this array is probably non-NULL. 'lut_3d->table'
    drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c:903 ipipe_set_gbce_regs() warn: this array is probably non-NULL. 'gbce->table'
    drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c:946 ipipe_set_ee_regs() warn: this array is probably non-NULL. 'ee->table'
    drivers/staging/media/davinci_vpfe/dm365_ipipe.c:59 ipipe_validate_lutdpc_params() warn: this array is probably non-NULL. 'lutdpc->table'
    drivers/staging/media/davinci_vpfe/dm365_ipipe.c:697 ipipe_get_gamma_params() warn: this array is probably non-NULL. 'gamma_param->table_r'
    drivers/staging/media/davinci_vpfe/dm365_ipipe.c:705 ipipe_get_gamma_params() warn: this array is probably non-NULL. 'gamma_param->table_g'
    drivers/staging/media/davinci_vpfe/dm365_ipipe.c:712 ipipe_get_gamma_params() warn: this array is probably non-NULL. 'gamma_param->table_b'
    drivers/staging/media/davinci_vpfe/dm365_ipipe.c:745 ipipe_get_3d_lut_params() warn: this array is probably non-NULL. 'lut_param->table'
    drivers/staging/media/davinci_vpfe/dm365_ipipe.c:926 ipipe_get_gbce_params() warn: this array is probably non-NULL. 'gbce_param->table'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c    | 18 ++++--------------
 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c | 19 +++----------------
 2 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 6a3434cebd79..31b9e3011415 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -56,7 +56,7 @@ static int ipipe_validate_lutdpc_params(struct vpfe_ipipe_lutdpc *lutdpc)
 	    lutdpc->dpc_size > LUT_DPC_MAX_SIZE)
 		return -EINVAL;
 
-	if (lutdpc->en && !lutdpc->table)
+	if (lutdpc->en)
 		return -EINVAL;
 
 	for (i = 0; i < lutdpc->dpc_size; i++)
@@ -694,7 +694,7 @@ static int ipipe_get_gamma_params(struct vpfe_ipipe_device *ipipe, void *param)
 
 	table_size = gamma->tbl_size;
 
-	if (!gamma->bypass_r && !gamma_param->table_r) {
+	if (!gamma->bypass_r) {
 		dev_err(dev,
 			"ipipe_get_gamma_params: table ptr empty for R\n");
 		return -EINVAL;
@@ -702,14 +702,14 @@ static int ipipe_get_gamma_params(struct vpfe_ipipe_device *ipipe, void *param)
 	memcpy(gamma_param->table_r, gamma->table_r,
 	       (table_size * sizeof(struct vpfe_ipipe_gamma_entry)));
 
-	if (!gamma->bypass_g && !gamma_param->table_g) {
+	if (!gamma->bypass_g) {
 		dev_err(dev, "ipipe_get_gamma_params: table ptr empty for G\n");
 		return -EINVAL;
 	}
 	memcpy(gamma_param->table_g, gamma->table_g,
 	       (table_size * sizeof(struct vpfe_ipipe_gamma_entry)));
 
-	if (!gamma->bypass_b && !gamma_param->table_b) {
+	if (!gamma->bypass_b) {
 		dev_err(dev, "ipipe_get_gamma_params: table ptr empty for B\n");
 		return -EINVAL;
 	}
@@ -739,13 +739,8 @@ static int ipipe_get_3d_lut_params(struct vpfe_ipipe_device *ipipe, void *param)
 {
 	struct vpfe_ipipe_3d_lut *lut_param = param;
 	struct vpfe_ipipe_3d_lut *lut = &ipipe->config.lut;
-	struct device *dev = ipipe->subdev.v4l2_dev->dev;
 
 	lut_param->en = lut->en;
-	if (!lut_param->table) {
-		dev_err(dev, "ipipe_get_3d_lut_params: Invalid table ptr\n");
-		return -EINVAL;
-	}
 
 	memcpy(lut_param->table, &lut->table,
 	       (VPFE_IPIPE_MAX_SIZE_3D_LUT *
@@ -919,14 +914,9 @@ static int ipipe_get_gbce_params(struct vpfe_ipipe_device *ipipe, void *param)
 {
 	struct vpfe_ipipe_gbce *gbce_param = param;
 	struct vpfe_ipipe_gbce *gbce = &ipipe->config.gbce;
-	struct device *dev = ipipe->subdev.v4l2_dev->dev;
 
 	gbce_param->en = gbce->en;
 	gbce_param->type = gbce->type;
-	if (!gbce_param->table) {
-		dev_err(dev, "ipipe_get_gbce_params: Invalid table ptr\n");
-		return -EINVAL;
-	}
 
 	memcpy(gbce_param->table, gbce->table,
 		(VPFE_IPIPE_MAX_SIZE_GBCE_LUT * sizeof(unsigned short)));
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
index a893072d0f04..dbb7ddc70bef 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
@@ -430,9 +430,6 @@ ipipe_set_lutdpc_regs(void __iomem *base_addr, void __iomem *isp5_base_addr,
 	regw_ip(base_addr, LUT_DPC_START_ADDR, DPC_LUT_ADR);
 	regw_ip(base_addr, dpc->dpc_size, DPC_LUT_SIZ & LUT_DPC_SIZE_MASK);
 
-	if (dpc->table == NULL)
-		return;
-
 	for (count = 0; count < dpc->dpc_size; count++) {
 		if (count >= max_tbl_size)
 			lut_start_addr = DPC_TB1_START_ADDR;
@@ -760,13 +757,13 @@ ipipe_set_gamma_regs(void __iomem *base_addr, void __iomem *isp5_base_addr,
 
 	table_size = gamma->tbl_size;
 
-	if (!gamma->bypass_r && gamma->table_r != NULL)
+	if (!gamma->bypass_r)
 		ipipe_update_gamma_tbl(isp5_base_addr, gamma->table_r,
 			table_size, GAMMA_R_START_ADDR);
-	if (!gamma->bypass_b && gamma->table_b != NULL)
+	if (!gamma->bypass_b)
 		ipipe_update_gamma_tbl(isp5_base_addr, gamma->table_b,
 			table_size, GAMMA_B_START_ADDR);
-	if (!gamma->bypass_g && gamma->table_g != NULL)
+	if (!gamma->bypass_g)
 		ipipe_update_gamma_tbl(isp5_base_addr, gamma->table_g,
 			table_size, GAMMA_G_START_ADDR);
 }
@@ -787,10 +784,6 @@ ipipe_set_3d_lut_regs(void __iomem *base_addr, void __iomem *isp5_base_addr,
 	if (!lut_3d->en)
 		return;
 
-	/* lut_3d enabled */
-	if (!lut_3d->table)
-		return;
-
 	/* valied table */
 	tbl = lut_3d->table;
 	for (i = 0; i < VPFE_IPIPE_MAX_SIZE_3D_LUT; i++) {
@@ -900,9 +893,6 @@ ipipe_set_gbce_regs(void __iomem *base_addr, void __iomem *isp5_base_addr,
 
 	regw_ip(base_addr, gbce->type, GBCE_TYP);
 
-	if (!gbce->table)
-		return;
-
 	for (count = 0; count < VPFE_IPIPE_MAX_SIZE_GBCE_LUT; count += 2)
 		w_ip_table(isp5_base_addr, ((gbce->table[count + 1] & mask) <<
 		GBCE_ENTRY_SHIFT) | (gbce->table[count] & mask),
@@ -943,9 +933,6 @@ ipipe_set_ee_regs(void __iomem *base_addr, void __iomem *isp5_base_addr,
 	regw_ip(base_addr, ee->es_gain_grad & YEE_THR_MASK, YEE_G_GAN);
 	regw_ip(base_addr, ee->es_ofst_grad & YEE_THR_MASK, YEE_G_OFT);
 
-	if (ee->table == NULL)
-		return;
-
 	for (count = 0; count < VPFE_IPIPE_MAX_SIZE_YEE_LUT; count += 2)
 		w_ip_table(isp5_base_addr, ((ee->table[count + 1] &
 		YEE_ENTRY_MASK) << YEE_ENTRY_SHIFT) |
-- 
2.14.3
