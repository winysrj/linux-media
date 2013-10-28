Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:55845 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3J1VXg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Oct 2013 17:23:36 -0400
Received: by mail-pd0-f175.google.com with SMTP id g10so7680019pdj.34
        for <linux-media@vger.kernel.org>; Mon, 28 Oct 2013 14:23:36 -0700 (PDT)
Date: Mon, 28 Oct 2013 14:23:34 -0700
From: Lisa Nguyen <lisa@xenapiadmin.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/2] staging: media: davinci_vpfe: Remove spaces before
 semicolons
Message-ID: <3fb66890b3aec35a1e1804189320f6a0acb666d8.1382995303.git.lisa@xenapiadmin.com>
References: <c171c58417eb45b816caa1fd8cb0d74ae813dbbf.1382995303.git.lisa@xenapiadmin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c171c58417eb45b816caa1fd8cb0d74ae813dbbf.1382995303.git.lisa@xenapiadmin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unnecessary spaces before semicolons to meet kernel
coding style.

Signed-off-by: Lisa Nguyen <lisa@xenapiadmin.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c    | 2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c | 4 ++--
 drivers/staging/media/davinci_vpfe/dm365_isif.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 766a071..b7044a3 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1009,7 +1009,7 @@ static int ipipe_validate_yee_params(struct vpfe_ipipe_yee *yee)
 	    yee->es_ofst_grad > YEE_THR_MASK)
 		return -EINVAL;
 
-	for (i = 0; i < VPFE_IPIPE_MAX_SIZE_YEE_LUT ; i++)
+	for (i = 0; i < VPFE_IPIPE_MAX_SIZE_YEE_LUT; i++)
 		if (yee->table[i] > YEE_ENTRY_MASK)
 			return -EINVAL;
 
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
index e027b92..2d36b60 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
@@ -791,7 +791,7 @@ ipipe_set_3d_lut_regs(void *__iomem base_addr, void *__iomem isp5_base_addr,
 
 	/* valied table */
 	tbl = lut_3d->table;
-	for (i = 0 ; i < VPFE_IPIPE_MAX_SIZE_3D_LUT; i++) {
+	for (i = 0; i < VPFE_IPIPE_MAX_SIZE_3D_LUT; i++) {
 		/* Each entry has 0-9 (B), 10-19 (G) and
 		20-29 R values */
 		val = tbl[i].b & D3_LUT_ENTRY_MASK;
@@ -899,7 +899,7 @@ ipipe_set_gbce_regs(void *__iomem base_addr, void *__iomem isp5_base_addr,
 	if (!gbce->table)
 		return;
 
-	for (count = 0; count < VPFE_IPIPE_MAX_SIZE_GBCE_LUT ; count += 2)
+	for (count = 0; count < VPFE_IPIPE_MAX_SIZE_GBCE_LUT; count += 2)
 		w_ip_table(isp5_base_addr, ((gbce->table[count + 1] & mask) <<
 		GBCE_ENTRY_SHIFT) | (gbce->table[count] & mask),
 		((count/2) << 2) + GBCE_TB_START_ADDR);
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index ff48fce..4171cfd 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -918,7 +918,7 @@ isif_config_dfc(struct vpfe_isif_device *isif, struct vpfe_isif_dfc *vdfc)
 		   (0 << ISIF_VDFC_EN_SHIFT), DFCCTL);
 
 	isif_write(isif->isif_cfg.base_addr, 0x6, DFCMEMCTL);
-	for (i = 0 ; i < vdfc->num_vdefects; i++) {
+	for (i = 0; i < vdfc->num_vdefects; i++) {
 		count = DFC_WRITE_WAIT_COUNT;
 		while (count &&
 			(isif_read(isif->isif_cfg.base_addr, DFCMEMCTL) & 0x2))
-- 
1.8.1.2

