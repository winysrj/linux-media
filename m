Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:38790 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752092AbdIANho (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 09:37:44 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Alan Cox <alan@linux.intel.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 5/7] staging: atomisp: Move to upstream IOSF MBI API
Date: Fri,  1 Sep 2017 16:36:38 +0300
Message-Id: <20170901133640.17589-5-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170901133640.17589-1-andriy.shevchenko@linux.intel.com>
References: <20170901133640.17589-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a common for x86 IOSF MBI API. Move atomisp code to use it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/pci/Kconfig          |  1 +
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       | 20 +++++++-----
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      | 38 ++++++++++------------
 3 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/Kconfig b/drivers/staging/media/atomisp/pci/Kconfig
index a72421431c7a..fb66fc9d6952 100644
--- a/drivers/staging/media/atomisp/pci/Kconfig
+++ b/drivers/staging/media/atomisp/pci/Kconfig
@@ -5,6 +5,7 @@
 config VIDEO_ATOMISP
        tristate "Intel Atom Image Signal Processor Driver"
        depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+       select IOSF_MBI
        select VIDEOBUF_VMALLOC
         ---help---
           Say Y here if your platform supports Intel Atom SoC
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index f48bf451c1f5..73e15dd9d4d6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -27,7 +27,9 @@
 #include <linux/kfifo.h>
 #include <linux/pm_runtime.h>
 #include <linux/timer.h>
+
 #include <asm/intel-mid.h>
+#include <asm/iosf_mbi.h>
 
 #include <media/v4l2-event.h>
 #include <media/videobuf-vmalloc.h>
@@ -143,36 +145,36 @@ static int write_target_freq_to_hw(struct atomisp_device *isp,
 	unsigned int ratio, timeout, guar_ratio;
 	u32 isp_sspm1 = 0;
 	int i;
+
 	if (!isp->hpll_freq) {
 		dev_err(isp->dev, "failed to get hpll_freq. no change to freq\n");
 		return -EINVAL;
 	}
 
-	isp_sspm1 = intel_mid_msgbus_read32(PUNIT_PORT, ISPSSPM1);
+	iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ, ISPSSPM1, &isp_sspm1);
 	if (isp_sspm1 & ISP_FREQ_VALID_MASK) {
 		dev_dbg(isp->dev, "clearing ISPSSPM1 valid bit.\n");
-		intel_mid_msgbus_write32(PUNIT_PORT, ISPSSPM1,
+		iosf_mbi_write(BT_MBI_UNIT_PMC, MBI_REG_WRITE, ISPSSPM1,
 				    isp_sspm1 & ~(1 << ISP_FREQ_VALID_OFFSET));
 	}
 
 	ratio = (2 * isp->hpll_freq + new_freq / 2) / new_freq - 1;
 	guar_ratio = (2 * isp->hpll_freq + 200 / 2) / 200 - 1;
 
-	isp_sspm1 = intel_mid_msgbus_read32(PUNIT_PORT, ISPSSPM1);
+	iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ, ISPSSPM1, &isp_sspm1);
 	isp_sspm1 &= ~(0x1F << ISP_REQ_FREQ_OFFSET);
 
 	for (i = 0; i < ISP_DFS_TRY_TIMES; i++) {
-		intel_mid_msgbus_write32(PUNIT_PORT, ISPSSPM1,
+		iosf_mbi_write(BT_MBI_UNIT_PMC, MBI_REG_WRITE, ISPSSPM1,
 				   isp_sspm1
 				   | ratio << ISP_REQ_FREQ_OFFSET
 				   | 1 << ISP_FREQ_VALID_OFFSET
 				   | guar_ratio << ISP_REQ_GUAR_FREQ_OFFSET);
 
-		isp_sspm1 = intel_mid_msgbus_read32(PUNIT_PORT, ISPSSPM1);
-
+		iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ, ISPSSPM1, &isp_sspm1);
 		timeout = 20;
 		while ((isp_sspm1 & ISP_FREQ_VALID_MASK) && timeout) {
-			isp_sspm1 = intel_mid_msgbus_read32(PUNIT_PORT, ISPSSPM1);
+			iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ, ISPSSPM1, &isp_sspm1);
 			dev_dbg(isp->dev, "waiting for ISPSSPM1 valid bit to be 0.\n");
 			udelay(100);
 			timeout--;
@@ -187,10 +189,10 @@ static int write_target_freq_to_hw(struct atomisp_device *isp,
 		return -EINVAL;
 	}
 
-	isp_sspm1 = intel_mid_msgbus_read32(PUNIT_PORT, ISPSSPM1);
+	iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ, ISPSSPM1, &isp_sspm1);
 	timeout = 10;
 	while (((isp_sspm1 >> ISP_FREQ_STAT_OFFSET) != ratio) && timeout) {
-		isp_sspm1 = intel_mid_msgbus_read32(PUNIT_PORT, ISPSSPM1);
+		iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ, ISPSSPM1, &isp_sspm1);
 		dev_dbg(isp->dev, "waiting for ISPSSPM1 status bit to be 0x%x.\n",
 			new_freq);
 		udelay(100);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 663aa916e3ca..0896f5ea7e4e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -28,6 +28,9 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 
+#include <asm/intel-mid.h>
+#include <asm/iosf_mbi.h>
+
 #include "../../include/linux/atomisp_gmin_platform.h"
 
 #include "atomisp_cmd.h"
@@ -46,7 +49,6 @@
 #include "hrt/hive_isp_css_mm_hrt.h"
 
 #include "device_access.h"
-#include <asm/intel-mid.h>
 
 /* G-Min addition: pull this in from intel_mid_pm.h */
 #define CSTATE_EXIT_LATENCY_C1  1
@@ -386,28 +388,23 @@ static int atomisp_mrfld_pre_power_down(struct atomisp_device *isp)
  */
 static void punit_ddr_dvfs_enable(bool enable)
 {
-	int reg = intel_mid_msgbus_read32(PUNIT_PORT, MRFLD_ISPSSDVFS);
 	int door_bell = 1 << 8;
 	int max_wait = 30;
+	int reg;
 
+	iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ, MRFLD_ISPSSDVFS, &reg);
 	if (enable) {
 		reg &= ~(MRFLD_BIT0 | MRFLD_BIT1);
 	} else {
 		reg |= (MRFLD_BIT1 | door_bell);
 		reg &= ~(MRFLD_BIT0);
 	}
+	iosf_mbi_write(BT_MBI_UNIT_PMC, MBI_REG_WRITE, MRFLD_ISPSSDVFS, reg);
 
-	intel_mid_msgbus_write32(PUNIT_PORT, MRFLD_ISPSSDVFS, reg);
-
-	/*Check Req_ACK to see freq status, wait until door_bell is cleared*/
-	if (reg & door_bell) {
-		while (max_wait--) {
-			if (0 == (intel_mid_msgbus_read32(PUNIT_PORT,
-				MRFLD_ISPSSDVFS) & door_bell))
-					break;
-
-			usleep_range(100, 500);
-		}
+	/* Check Req_ACK to see freq status, wait until door_bell is cleared */
+	while ((reg & door_bell) && max_wait--) {
+		iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ, MRFLD_ISPSSDVFS, &reg);
+		usleep_range(100, 500);
 	}
 
 	if (max_wait == -1)
@@ -421,10 +418,10 @@ int atomisp_mrfld_power_down(struct atomisp_device *isp)
 	u32 reg_value;
 
 	/* writing 0x3 to ISPSSPM0 bit[1:0] to power off the IUNIT */
-	reg_value = intel_mid_msgbus_read32(PUNIT_PORT, MRFLD_ISPSSPM0);
+	iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ, MRFLD_ISPSSPM0, &reg_value);
 	reg_value &= ~MRFLD_ISPSSPM0_ISPSSC_MASK;
 	reg_value |= MRFLD_ISPSSPM0_IUNIT_POWER_OFF;
-	intel_mid_msgbus_write32(PUNIT_PORT, MRFLD_ISPSSPM0, reg_value);
+	iosf_mbi_write(BT_MBI_UNIT_PMC, MBI_REG_WRITE, MRFLD_ISPSSPM0, reg_value);
 
 	/*WA:Enable DVFS*/
 	if (IS_CHT)
@@ -437,8 +434,7 @@ int atomisp_mrfld_power_down(struct atomisp_device *isp)
 	 */
 	timeout = jiffies + msecs_to_jiffies(50);
 	while (1) {
-		reg_value = intel_mid_msgbus_read32(PUNIT_PORT,
-							MRFLD_ISPSSPM0);
+		iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ, MRFLD_ISPSSPM0, &reg_value);
 		dev_dbg(isp->dev, "power-off in progress, ISPSSPM0: 0x%x\n",
 				reg_value);
 		/* wait until ISPSSPM0 bit[25:24] shows 0x3 */
@@ -477,14 +473,14 @@ int atomisp_mrfld_power_up(struct atomisp_device *isp)
 		msleep(10);
 
 	/* writing 0x0 to ISPSSPM0 bit[1:0] to power off the IUNIT */
-	reg_value = intel_mid_msgbus_read32(PUNIT_PORT, MRFLD_ISPSSPM0);
+	iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ, MRFLD_ISPSSPM0, &reg_value);
 	reg_value &= ~MRFLD_ISPSSPM0_ISPSSC_MASK;
-	intel_mid_msgbus_write32(PUNIT_PORT, MRFLD_ISPSSPM0, reg_value);
+	iosf_mbi_write(BT_MBI_UNIT_PMC, MBI_REG_WRITE, MRFLD_ISPSSPM0, reg_value);
 
 	/* FIXME: experienced value for delay */
 	timeout = jiffies + msecs_to_jiffies(50);
 	while (1) {
-		reg_value = intel_mid_msgbus_read32(PUNIT_PORT, MRFLD_ISPSSPM0);
+		iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ, MRFLD_ISPSSPM0, &reg_value);
 		dev_dbg(isp->dev, "power-on in progress, ISPSSPM0: 0x%x\n",
 				reg_value);
 		/* wait until ISPSSPM0 bit[25:24] shows 0x0 */
@@ -1323,7 +1319,7 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 		isp->dfs = &dfs_config_cht;
 		isp->pdev->d3cold_delay = 0;
 
-		val = intel_mid_msgbus_read32(CCK_PORT, CCK_FUSE_REG_0);
+		iosf_mbi_read(CCK_PORT, MBI_REG_READ, CCK_FUSE_REG_0, &val);
 		switch (val & CCK_FUSE_HPLL_FREQ_MASK) {
 		case 0x00:
 			isp->hpll_freq = HPLL_FREQ_800MHZ;
-- 
2.14.1
