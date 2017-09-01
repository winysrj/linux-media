Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46984 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752039AbdIANhO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 09:37:14 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Alan Cox <alan@linux.intel.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/7] staging: atomisp: Remove dead code for MID (#1)
Date: Fri,  1 Sep 2017 16:36:34 +0300
Message-Id: <20170901133640.17589-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove dead code. If someone needs it the P-Unit semaphore is handled by
I2C DesignWare driver (drivers/i2c/busses/i2c-designware-baytrail.c).

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../atomisp/include/asm/intel_mid_pcihelpers.h     |   2 -
 .../platform/intel-mid/intel_mid_pcihelpers.c      | 101 ---------------------
 2 files changed, 103 deletions(-)

diff --git a/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h b/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
index c5e22bba455a..b7c079f3630a 100644
--- a/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
+++ b/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
@@ -33,5 +33,3 @@ void intel_mid_msgbus_write32(u8 port, u32 addr, u32 data);
 u32 intel_mid_msgbus_read32_raw_ext(u32 cmd, u32 cmd_ext);
 void intel_mid_msgbus_write32_raw_ext(u32 cmd, u32 cmd_ext, u32 data);
 u32 intel_mid_soc_stepping(void);
-int intel_mid_dw_i2c_acquire_ownership(void);
-int intel_mid_dw_i2c_release_ownership(void);
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
index cd452cc20fea..0d01a269989d 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
@@ -14,13 +14,6 @@
 #define INTEL_ATOM_BYT 0x37
 #define INTEL_ATOM_MOORFLD 0x5a
 #define INTEL_ATOM_CHT 0x4c
-/* synchronization for sharing the I2C controller */
-#define PUNIT_PORT	0x04
-#define PUNIT_DOORBELL_OPCODE	(0xE0)
-#define PUNIT_DOORBELL_REG	(0x0)
-#ifndef CSTATE_EXIT_LATENCY
-#define CSTATE_EXIT_LATENCY_C1 1
-#endif
 static inline int platform_is(u8 model)
 {
 	return (boot_cpu_data.x86_model == model);
@@ -201,97 +194,3 @@ static void pci_d3_delay_fixup(struct pci_dev *dev)
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_d3_delay_fixup);
-
-#define PUNIT_SEMAPHORE	(platform_is(INTEL_ATOM_BYT) ? 0x7 : 0x10E)
-#define GET_SEM() (intel_mid_msgbus_read32(PUNIT_PORT, PUNIT_SEMAPHORE) & 0x1)
-
-static void reset_semaphore(void)
-{
-	u32 data;
-
-	data = intel_mid_msgbus_read32(PUNIT_PORT, PUNIT_SEMAPHORE);
-	smp_mb();
-	data = data & 0xfffffffc;
-	intel_mid_msgbus_write32(PUNIT_PORT, PUNIT_SEMAPHORE, data);
-	smp_mb();
-
-}
-
-int intel_mid_dw_i2c_acquire_ownership(void)
-{
-	u32 ret = 0;
-	u32 data = 0; /* data sent to PUNIT */
-	u32 cmd;
-	u32 cmdext;
-	int timeout = 1000;
-
-	if (DW_I2C_NEED_QOS)
-		pm_qos_update_request(&pm_qos, CSTATE_EXIT_LATENCY_C1 - 1);
-
-	/*
-	 * We need disable irq. Otherwise, the main thread
-	 * might be preempted and the other thread jumps to
-	 * disable irq for a long time. Another case is
-	 * some irq handlers might trigger power voltage change
-	 */
-	BUG_ON(irqs_disabled());
-	local_irq_disable();
-
-	/* host driver writes 0x2 to side band register 0x7 */
-	intel_mid_msgbus_write32(PUNIT_PORT, PUNIT_SEMAPHORE, 0x2);
-	smp_mb();
-
-	/* host driver sends 0xE0 opcode to PUNIT and writes 0 register */
-	cmd = (PUNIT_DOORBELL_OPCODE << 24) | (PUNIT_PORT << 16) |
-	((PUNIT_DOORBELL_REG & 0xFF) << 8) | PCI_ROOT_MSGBUS_DWORD_ENABLE;
-	cmdext = PUNIT_DOORBELL_REG & 0xffffff00;
-
-	if (cmdext)
-		intel_mid_msgbus_write32_raw_ext(cmd, cmdext, data);
-	else
-		intel_mid_msgbus_write32_raw(cmd, data);
-
-	/* host driver waits for bit 0 to be set in side band 0x7 */
-	while (GET_SEM() != 0x1) {
-		udelay(100);
-		timeout--;
-		if (timeout <= 0) {
-			pr_err("Timeout: semaphore timed out, reset sem\n");
-			ret = -ETIMEDOUT;
-			reset_semaphore();
-			/*Delay 1ms in case race with punit*/
-			udelay(1000);
-			if (GET_SEM() != 0) {
-				/*Reset again as kernel might race with punit*/
-				reset_semaphore();
-			}
-			pr_err("PUNIT SEM: %d\n",
-					intel_mid_msgbus_read32(PUNIT_PORT,
-						PUNIT_SEMAPHORE));
-			local_irq_enable();
-
-			if (DW_I2C_NEED_QOS) {
-				pm_qos_update_request(&pm_qos,
-					 PM_QOS_DEFAULT_VALUE);
-			}
-
-			return ret;
-		}
-	}
-	smp_mb();
-
-	return ret;
-}
-EXPORT_SYMBOL(intel_mid_dw_i2c_acquire_ownership);
-
-int intel_mid_dw_i2c_release_ownership(void)
-{
-	reset_semaphore();
-	local_irq_enable();
-
-	if (DW_I2C_NEED_QOS)
-		pm_qos_update_request(&pm_qos, PM_QOS_DEFAULT_VALUE);
-
-	return 0;
-}
-EXPORT_SYMBOL(intel_mid_dw_i2c_release_ownership);
-- 
2.14.1
