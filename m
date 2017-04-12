Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58763 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754745AbdDLSUG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 14:20:06 -0400
Subject: [PATCH 01/14] staging: atomisp: use local variable to reduce number
 of references
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Wed, 12 Apr 2017 19:20:01 +0100
Message-ID: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daeseok Youn <daeseok.youn@gmail.com>

Define new local variable to reduce the number of reference.
The new local variable is added to save the addess of dfs
and used in atomisp_freq_scaling() function.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |   37 +++++++++++---------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 94bc793..9ad5146 100644
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
@@ -265,20 +266,22 @@ int atomisp_freq_scaling(struct atomisp_device *isp,
 		ATOMISP_PCI_DEVICE_SOC_CHT && ATOMISP_USE_YUVPP(asd))
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
 
@@ -304,26 +307,26 @@ int atomisp_freq_scaling(struct atomisp_device *isp,
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
