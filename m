Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3893 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753184AbdCTOmE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:42:04 -0400
Subject: [PATCH 09/24] atomisp: remove another pair of 2400/2401 differences
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:40:20 +0000
Message-ID: <149002081364.17109.298566334102301120.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first of these checks the PCI identifier in order to decide what to do so needs no
ifdef. The other is simply a variation on what is dumped for debug - so favour dumping the
most.

Signed-off-by Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |    7 -------
 .../atomisp/pci/atomisp2/atomisp_dfs_tables.h      |    4 ----
 2 files changed, 11 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index d97a8df..08da8ea 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -263,12 +263,10 @@ int atomisp_freq_scaling(struct atomisp_device *isp,
 		return -EINVAL;
 	}
 
-#ifdef ISP2401
 	if ((isp->pdev->device & ATOMISP_PCI_DEVICE_SOC_MASK) ==
 		ATOMISP_PCI_DEVICE_SOC_CHT && ATOMISP_USE_YUVPP(asd))
 		isp->dfs = &dfs_config_cht_soc;
 
-#endif
 	if (isp->dfs->lowest_freq == 0 || isp->dfs->max_freq_at_vmin == 0 ||
 	    isp->dfs->highest_freq == 0 || isp->dfs->dfs_table_size == 0 ||
 	    !isp->dfs->dfs_table) {
@@ -654,13 +652,8 @@ irqreturn_t atomisp_isr(int irq, void *dev)
 			}
 
 			atomisp_eof_event(asd, eof_event.event.exp_id);
-#ifndef ISP2401
-			dev_dbg(isp->dev, "%s EOF exp_id %d\n", __func__,
-				eof_event.event.exp_id);
-#else
 			dev_dbg(isp->dev, "%s EOF exp_id %d, asd %d\n",
 				__func__, eof_event.event.exp_id, asd->index);
-#endif
 		}
 
 		irq_infos &= ~IA_CSS_IRQ_INFO_ISYS_EVENTS_READY;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_dfs_tables.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_dfs_tables.h
index dfb94e6..204d941 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_dfs_tables.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_dfs_tables.h
@@ -340,7 +340,6 @@ static const struct atomisp_freq_scaling_rule dfs_rules_cht[] = {
 		.run_mode = ATOMISP_RUN_MODE_PREVIEW,
 	},
 	{
-#ifdef ISP2401
 		.width = 1280,
 		.height = 720,
 		.fps = ISP_FREQ_RULE_ANY,
@@ -386,7 +385,6 @@ static const struct atomisp_freq_scaling_rule dfs_rules_cht_soc[] = {
 		.run_mode = ATOMISP_RUN_MODE_PREVIEW,
 	},
 	{
-#endif
 		.width = ISP_FREQ_RULE_ANY,
 		.height = ISP_FREQ_RULE_ANY,
 		.fps = ISP_FREQ_RULE_ANY,
@@ -403,7 +401,6 @@ static const struct atomisp_dfs_config dfs_config_cht = {
 	.dfs_table_size = ARRAY_SIZE(dfs_rules_cht),
 };
 
-#ifdef ISP2401
 static const struct atomisp_dfs_config dfs_config_cht_soc = {
 	.lowest_freq = ISP_FREQ_100MHZ,
 	.max_freq_at_vmin = ISP_FREQ_356MHZ,
@@ -412,5 +409,4 @@ static const struct atomisp_dfs_config dfs_config_cht_soc = {
 	.dfs_table_size = ARRAY_SIZE(dfs_rules_cht_soc),
 };
 
-#endif
 #endif /* __ATOMISP_DFS_TABLES_H__ */
