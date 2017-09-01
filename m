Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:14543 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752315AbdIANgo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 09:36:44 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Alan Cox <alan@linux.intel.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 2/7] staging: atomisp: Don't override D3 delay settings here
Date: Fri,  1 Sep 2017 16:36:35 +0300
Message-Id: <20170901133640.17589-2-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170901133640.17589-1-andriy.shevchenko@linux.intel.com>
References: <20170901133640.17589-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The d3_delay parameter is set by arch/x86/pci/intel_mid_pci.c and
drivers/pci/quirks.c.

No need to override that settings in unrelated driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../atomisp/include/asm/intel_mid_pcihelpers.h     |  8 ------
 .../platform/intel-mid/intel_mid_pcihelpers.c      | 33 ----------------------
 2 files changed, 41 deletions(-)

diff --git a/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h b/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
index b7c079f3630a..0d7f5c618b56 100644
--- a/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
+++ b/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
@@ -18,14 +18,6 @@
 #define PCI_ROOT_MSGBUS_WRITE           0x11
 #define PCI_ROOT_MSGBUS_DWORD_ENABLE    0xf0
 
-/* In BYT platform for all internal PCI devices d3 delay
- * of 3 ms is sufficient. Default value of 10 ms is overkill.
- */
-#define INTERNAL_PCI_PM_D3_WAIT		3
-
-#define ISP_SUB_CLASS			0x80
-#define SUB_CLASS_MASK			0xFF00
-
 u32 intel_mid_msgbus_read32_raw(u32 cmd);
 u32 intel_mid_msgbus_read32(u8 port, u32 addr);
 void intel_mid_msgbus_write32_raw(u32 cmd, u32 data);
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
index 0d01a269989d..341bfd3ab313 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
@@ -161,36 +161,3 @@ u32 intel_mid_soc_stepping(void)
 	return pci_root->revision;
 }
 EXPORT_SYMBOL(intel_mid_soc_stepping);
-
-static bool is_south_complex_device(struct pci_dev *dev)
-{
-	unsigned int base_class = dev->class >> 16;
-	unsigned int sub_class  = (dev->class & SUB_CLASS_MASK) >> 8;
-
-	/* other than camera, pci bridges and display,
-	 * everything else are south complex devices.
-	 */
-	if (((base_class == PCI_BASE_CLASS_MULTIMEDIA) &&
-	     (sub_class == ISP_SUB_CLASS)) ||
-	    (base_class == PCI_BASE_CLASS_BRIDGE) ||
-	    ((base_class == PCI_BASE_CLASS_DISPLAY) && !sub_class))
-		return false;
-	else
-		return true;
-}
-
-/* In BYT platform, d3_delay for internal south complex devices,
- * they are not subject to 10 ms d3 to d0 delay required by pci spec.
- */
-static void pci_d3_delay_fixup(struct pci_dev *dev)
-{
-	if (platform_is(INTEL_ATOM_BYT) ||
-		platform_is(INTEL_ATOM_CHT)) {
-		/* All internal devices are in bus 0. */
-		if (dev->bus->number == 0 && is_south_complex_device(dev)) {
-			dev->d3_delay = INTERNAL_PCI_PM_D3_WAIT;
-			dev->d3cold_delay = INTERNAL_PCI_PM_D3_WAIT;
-		}
-	}
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_d3_delay_fixup);
-- 
2.14.1
