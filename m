Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33799 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934785AbdCaBaY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 21:30:24 -0400
Date: Fri, 31 Mar 2017 10:30:12 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2 V2] staging: atomisp: use local variable to reduce the
 number of reference
Message-ID: <20170331013012.GA15884@jyoun-Latitude-E6530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Define new local variable to reduce the number of reference.
The new local variable is added to save the addess of dfs
and used in atomisp_freq_scaling() function.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
V2: this patch was rebased since the patch 1/2 was improved.

 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       | 37 ++++++++++++----------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 87224d6..9f4041a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -251,6 +251,7 @@ int atomisp_freq_scaling(struct atomisp_device *isp,
 {
 	/* FIXME! Only use subdev[0] status yet */
 	struct atomisp_sub_device *asd = &isp->asd[0];
+	const struct atomisp_dfs_config *dfs;
 	unsigned int new_freq;
 	struct atomisp_freq_scaling_rule curr_rules;
 	int i, ret;
@@ -264,20 +265,22 @@ int atomisp_freq_scaling(struct atomisp_device *isp,
 	if (ATOMISP_IS_CHT(isp) && ATOMISP_USE_YUVPP(asd))
 		isp->dfs = &dfs_config_cht_soc;
 
-	if (isp->dfs->lowest_freq == 0 || isp->dfs->max_freq_at_vmin == 0 ||
-	    isp->dfs->highest_freq == 0 || isp->dfs->dfs_table_size == 0 ||
-	    !isp->dfs->dfs_table) {
+	dfs = isp->dfs;
+
+	if (dfs->lowest_freq == 0 || dfs->max_freq_at_vmin == 0 ||
+	    dfs->highest_freq == 0 || dfs->dfs_table_size == 0 ||
+	    !dfs->dfs_table) {
 		dev_err(isp->dev, "DFS configuration is invalid.\n");
 		return -EINVAL;
 	}
 
 	if (mode == ATOMISP_DFS_MODE_LOW) {
-		new_freq = isp->dfs->lowest_freq;
+		new_freq = dfs->lowest_freq;
 		goto done;
 	}
 
 	if (mode == ATOMISP_DFS_MODE_MAX) {
-		new_freq = isp->dfs->highest_freq;
+		new_freq = dfs->highest_freq;
 		goto done;
 	}
 
@@ -303,26 +306,26 @@ int atomisp_freq_scaling(struct atomisp_device *isp,
 	}
 
 	/* search for the target frequency by looping freq rules*/
-	for (i = 0; i < isp->dfs->dfs_table_size; i++) {
-		if (curr_rules.width != isp->dfs->dfs_table[i].width &&
-		    isp->dfs->dfs_table[i].width != ISP_FREQ_RULE_ANY)
+	for (i = 0; i < dfs->dfs_table_size; i++) {
+		if (curr_rules.width != dfs->dfs_table[i].width &&
+		    dfs->dfs_table[i].width != ISP_FREQ_RULE_ANY)
 			continue;
-		if (curr_rules.height != isp->dfs->dfs_table[i].height &&
-		    isp->dfs->dfs_table[i].height != ISP_FREQ_RULE_ANY)
+		if (curr_rules.height != dfs->dfs_table[i].height &&
+		    dfs->dfs_table[i].height != ISP_FREQ_RULE_ANY)
 			continue;
-		if (curr_rules.fps != isp->dfs->dfs_table[i].fps &&
-		    isp->dfs->dfs_table[i].fps != ISP_FREQ_RULE_ANY)
+		if (curr_rules.fps != dfs->dfs_table[i].fps &&
+		    dfs->dfs_table[i].fps != ISP_FREQ_RULE_ANY)
 			continue;
-		if (curr_rules.run_mode != isp->dfs->dfs_table[i].run_mode &&
-		    isp->dfs->dfs_table[i].run_mode != ISP_FREQ_RULE_ANY)
+		if (curr_rules.run_mode != dfs->dfs_table[i].run_mode &&
+		    dfs->dfs_table[i].run_mode != ISP_FREQ_RULE_ANY)
 			continue;
 		break;
 	}
 
-	if (i == isp->dfs->dfs_table_size)
-		new_freq = isp->dfs->max_freq_at_vmin;
+	if (i == dfs->dfs_table_size)
+		new_freq = dfs->max_freq_at_vmin;
 	else
-		new_freq = isp->dfs->dfs_table[i].isp_freq;
+		new_freq = dfs->dfs_table[i].isp_freq;
 
 done:
 	dev_dbg(isp->dev, "DFS target frequency=%d.\n", new_freq);
-- 
2.7.4
