Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:52710 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdFIVg1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 17:36:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Kevin Hilman <khilman@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] davinci/dm644x: work around ccdc_update_raw_params trainwreck
Date: Fri,  9 Jun 2017 23:36:04 +0200
Message-Id: <20170609213616.410415-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the davinci drivers can be enabled in compile tests on other
architectures, I ran into this warning on a 64-bit build:

drivers/media/platform/davinci/dm644x_ccdc.c: In function 'ccdc_update_raw_params':
drivers/media/platform/davinci/dm644x_ccdc.c:279:7: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]

While that looks fairly harmless (it would be fine on 32-bit), it was
just the tip of the iceberg:

- The function constantly mixes up pointers and phys_addr_t numbers
- This is part of a 'VPFE_CMD_S_CCDC_RAW_PARAMS' ioctl command that is
  described as an 'experimental ioctl that will change in future kernels',
  but if we have users that probably won't happen.
- The code to allocate the table never gets called after we copy_from_user
  the user input over the kernel settings, and then compare them
  for inequality.
- We then go on to use an address provided by user space as both the
  __user pointer for input and pass it through phys_to_virt to come up
  with a kernel pointer to copy the data to. This looks like a trivially
  exploitable root hole.

This patch disables all the obviously broken code, by zeroing out the
sensitive data provided by user space. I also fix the type confusion
here. If we think the ioctl has no stable users, we could consider
just removing it instead.

Fixes: 5f15fbb68fd7 ("V4L/DVB (12251): v4l: dm644x ccdc module for vpfe capture driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/davinci/dm644x_ccdc.c | 40 +++++++++++++++++-----------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index 740fbc7a8c14..1b42f50cad38 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -236,10 +236,22 @@ static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
 {
 	struct ccdc_config_params_raw *config_params =
 				&ccdc_cfg.bayer.config_params;
-	unsigned int *fpc_virtaddr = NULL;
-	unsigned int *fpc_physaddr = NULL;
+	unsigned int *fpc_virtaddr;
+	phys_addr_t fpc_physaddr;
 
 	memcpy(config_params, raw_params, sizeof(*raw_params));
+
+	/*
+	 * FIXME: the code to copy the fault_pxl settings was present
+	 *	  in the original version but clearly could never
+	 *	  work and will interpret user-provided data in
+	 * 	  dangerous ways. Let's disable it completely to be
+	 *        on the safe side.
+	 */
+	config_params->fault_pxl.enable = 0;
+	config_params->fault_pxl.fp_num = 0;
+	config_params->fault_pxl.fpc_table_addr = 0;
+
 	/*
 	 * allocate memory for fault pixel table and copy the user
 	 * values to the table
@@ -247,16 +259,15 @@ static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
 	if (!config_params->fault_pxl.enable)
 		return 0;
 
-	fpc_physaddr = (unsigned int *)config_params->fault_pxl.fpc_table_addr;
-	fpc_virtaddr = (unsigned int *)phys_to_virt(
-				(unsigned long)fpc_physaddr);
+	fpc_physaddr = config_params->fault_pxl.fpc_table_addr;
+	fpc_virtaddr = (unsigned int *)phys_to_virt(fpc_physaddr);
 	/*
 	 * Allocate memory for FPC table if current
 	 * FPC table buffer is not big enough to
 	 * accommodate FPC Number requested
 	 */
 	if (raw_params->fault_pxl.fp_num != config_params->fault_pxl.fp_num) {
-		if (fpc_physaddr != NULL) {
+		if (fpc_physaddr) {
 			free_pages((unsigned long)fpc_virtaddr,
 				   get_order
 				   (config_params->fault_pxl.fp_num *
@@ -270,13 +281,12 @@ static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
 							 fault_pxl.fp_num *
 							 FP_NUM_BYTES));
 
-		if (fpc_virtaddr == NULL) {
+		if (fpc_virtaddr) {
 			dev_dbg(ccdc_cfg.dev,
 				"\nUnable to allocate memory for FPC");
 			return -EFAULT;
 		}
-		fpc_physaddr =
-		    (unsigned int *)virt_to_phys((void *)fpc_virtaddr);
+		fpc_physaddr = virt_to_phys(fpc_virtaddr);
 	}
 
 	/* Copy number of fault pixels and FPC table */
@@ -287,7 +297,7 @@ static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
 		dev_dbg(ccdc_cfg.dev, "\n copy_from_user failed");
 		return -EFAULT;
 	}
-	config_params->fault_pxl.fpc_table_addr = (unsigned long)fpc_physaddr;
+	config_params->fault_pxl.fpc_table_addr = fpc_physaddr;
 	return 0;
 }
 
@@ -295,13 +305,13 @@ static int ccdc_close(struct device *dev)
 {
 	struct ccdc_config_params_raw *config_params =
 				&ccdc_cfg.bayer.config_params;
-	unsigned int *fpc_physaddr = NULL, *fpc_virtaddr = NULL;
+	phys_addr_t fpc_physaddr;
+	unsigned int *fpc_virtaddr;
 
-	fpc_physaddr = (unsigned int *)config_params->fault_pxl.fpc_table_addr;
+	fpc_physaddr = config_params->fault_pxl.fpc_table_addr;
 
-	if (fpc_physaddr != NULL) {
-		fpc_virtaddr = (unsigned int *)
-		    phys_to_virt((unsigned long)fpc_physaddr);
+	if (fpc_physaddr) {
+		fpc_virtaddr = phys_to_virt(fpc_physaddr);
 		free_pages((unsigned long)fpc_virtaddr,
 			   get_order(config_params->fault_pxl.fp_num *
 			   FP_NUM_BYTES));
-- 
2.9.0
