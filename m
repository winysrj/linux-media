Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:64232 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037965AbdDUKte (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 06:49:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: atomisp: remove #ifdef for runtime PM functions
Date: Fri, 21 Apr 2017 12:48:35 +0200
Message-Id: <20170421104903.815637-2-arnd@arndb.de>
In-Reply-To: <20170421104903.815637-1-arnd@arndb.de>
References: <20170421104903.815637-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The runtime power management functions are called from the reset handler even
if CONFIG_PM is disabled, leading to a link error:

drivers/staging/built-in.o: In function `atomisp_reset':
(.text+0x4cd1c): undefined reference to `atomisp_runtime_suspend'
drivers/staging/built-in.o: In function `atomisp_reset':
(.text+0x4cd3a): undefined reference to `atomisp_mrfld_power_down'
drivers/staging/built-in.o: In function `atomisp_reset':
(.text+0x4cd58): undefined reference to `atomisp_mrfld_power_up'
drivers/staging/built-in.o: In function `atomisp_reset':
(.text+0x4cd77): undefined reference to `atomisp_runtime_resume'

Removing the #ifdef around the PM functions avoids the problem, and
lets us simplify it further. The __maybe_unused annotation is needed
to ensure the compiler can silently drop the unused callbacks.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 9bd186bad1bd..9b4508e731f3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -310,7 +310,6 @@ static int __maybe_unused atomisp_restore_iunit_reg(struct atomisp_device *isp)
 	return 0;
 }
 
-#ifdef CONFIG_PM
 static int atomisp_mrfld_pre_power_down(struct atomisp_device *isp)
 {
 	struct pci_dev *dev = isp->pdev;
@@ -550,7 +549,7 @@ int atomisp_runtime_resume(struct device *dev)
 	return 0;
 }
 
-static int atomisp_suspend(struct device *dev)
+static int __maybe_unused atomisp_suspend(struct device *dev)
 {
 	struct atomisp_device *isp = (struct atomisp_device *)
 		dev_get_drvdata(dev);
@@ -588,7 +587,7 @@ static int atomisp_suspend(struct device *dev)
 	return atomisp_mrfld_power_down(isp);
 }
 
-static int atomisp_resume(struct device *dev)
+static int __maybe_unused atomisp_resume(struct device *dev)
 {
 	struct atomisp_device *isp = (struct atomisp_device *)
 		dev_get_drvdata(dev);
@@ -614,7 +613,6 @@ static int atomisp_resume(struct device *dev)
 	atomisp_freq_scaling(isp, ATOMISP_DFS_MODE_LOW, true);
 	return 0;
 }
-#endif
 
 int atomisp_csi_lane_config(struct atomisp_device *isp)
 {
@@ -1576,7 +1574,6 @@ static const struct pci_device_id atomisp_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, atomisp_pci_tbl);
 
-#ifdef CONFIG_PM
 static const struct dev_pm_ops atomisp_pm_ops = {
 	.runtime_suspend = atomisp_runtime_suspend,
 	.runtime_resume = atomisp_runtime_resume,
@@ -1584,14 +1581,9 @@ static const struct dev_pm_ops atomisp_pm_ops = {
 	.resume = atomisp_resume,
 };
 
-#define DEV_PM_OPS (&atomisp_pm_ops)
-#else
-#define DEV_PM_OPS NULL
-#endif
-
 static struct pci_driver atomisp_pci_driver = {
 	.driver = {
-		.pm = DEV_PM_OPS,
+		.pm = &atomisp_pm_ops,
 	},
 	.name = "atomisp-isp2",
 	.id_table = atomisp_pci_tbl,
-- 
2.9.0
