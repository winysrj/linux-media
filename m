Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36523 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754894AbdC3G3E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 02:29:04 -0400
Date: Thu, 30 Mar 2017 15:24:49 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] staging: atomisp: simplify the if condition in
 atomisp_freq_scaling()
Message-ID: <20170330062449.GA25214@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The condition line in if-statement is needed to be shorthen to
improve readability.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 94bc793..eebfccd 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -255,14 +255,17 @@ int atomisp_freq_scaling(struct atomisp_device *isp,
 	struct atomisp_freq_scaling_rule curr_rules;
 	int i, ret;
 	unsigned short fps = 0;
+	unsigned short masked_dev = 0;
 
 	if (isp->sw_contex.power_state != ATOM_ISP_POWER_UP) {
 		dev_err(isp->dev, "DFS cannot proceed due to no power.\n");
 		return -EINVAL;
 	}
 
-	if ((isp->pdev->device & ATOMISP_PCI_DEVICE_SOC_MASK) ==
-		ATOMISP_PCI_DEVICE_SOC_CHT && ATOMISP_USE_YUVPP(asd))
+	masked_dev = isp->pdev->device & ATOMISP_PCI_DEVICE_SOC_MASK;
+
+	if (masked_dev == ATOMISP_PCI_DEVICE_SOC_CHT &&
+	    ATOMISP_USE_YUVPP(asd))
 		isp->dfs = &dfs_config_cht_soc;
 
 	if (isp->dfs->lowest_freq == 0 || isp->dfs->max_freq_at_vmin == 0 ||
-- 
1.9.1
