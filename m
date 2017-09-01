Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46984 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752039AbdIANhQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 09:37:16 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Alan Cox <alan@linux.intel.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 6/7] staging: atomisp: Remove dead code for MID (#4)
Date: Fri,  1 Sep 2017 16:36:39 +0300
Message-Id: <20170901133640.17589-6-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170901133640.17589-1-andriy.shevchenko@linux.intel.com>
References: <20170901133640.17589-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since we switched to upstream IOSF MBI API the custom code become not in
use anymore.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../atomisp/include/asm/intel_mid_pcihelpers.h     | 22 -----
 .../media/atomisp/pci/atomisp2/atomisp_internal.h  |  1 -
 .../media/atomisp/platform/intel-mid/Makefile      |  1 -
 .../platform/intel-mid/intel_mid_pcihelpers.c      | 98 ----------------------
 4 files changed, 122 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
 delete mode 100644 drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c

diff --git a/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h b/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
deleted file mode 100644
index bf39f42c1c96..000000000000
--- a/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * Access to message bus through three registers
- * in CUNIT(0:0:0) PCI configuration space.
- * MSGBUS_CTRL_REG(0xD0):
- *   31:24      = message bus opcode
- *   23:16      = message bus port
- *   15:8       = message bus address, low 8 bits.
- *   7:4        = message bus byte enables
- * MSGBUS_CTRL_EXT_REG(0xD8):
- *   31:8       = message bus address, high 24 bits.
- * MSGBUS_DATA_REG(0xD4):
- *   hold the data for write or read
- */
-#define PCI_ROOT_MSGBUS_CTRL_REG        0xD0
-#define PCI_ROOT_MSGBUS_DATA_REG        0xD4
-#define PCI_ROOT_MSGBUS_CTRL_EXT_REG    0xD8
-#define PCI_ROOT_MSGBUS_READ            0x10
-#define PCI_ROOT_MSGBUS_WRITE           0x11
-#define PCI_ROOT_MSGBUS_DWORD_ENABLE    0xf0
-
-u32 intel_mid_msgbus_read32(u8 port, u32 addr);
-void intel_mid_msgbus_write32(u8 port, u32 addr, u32 data);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
index 7542a72f1d0f..1fe1711387a2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
@@ -30,7 +30,6 @@
 #include <linux/idr.h>
 
 #include <asm/intel-mid.h>
-#include "../../include/asm/intel_mid_pcihelpers.h"
 
 #include <media/media-device.h>
 #include <media/v4l2-subdev.h>
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/Makefile b/drivers/staging/media/atomisp/platform/intel-mid/Makefile
index 4621261c35db..c53db1364e21 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/Makefile
+++ b/drivers/staging/media/atomisp/platform/intel-mid/Makefile
@@ -1,5 +1,4 @@
 #
 # Makefile for intel-mid devices.
 #
-obj-$(CONFIG_INTEL_ATOMISP) += intel_mid_pcihelpers.o
 obj-$(CONFIG_INTEL_ATOMISP) += atomisp_gmin_platform.o
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
deleted file mode 100644
index 4ed3268c4e63..000000000000
--- a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
+++ /dev/null
@@ -1,98 +0,0 @@
-#include <linux/export.h>
-#include <linux/pci.h>
-#include <linux/pm_qos.h>
-#include <linux/delay.h>
-
-/* G-Min addition: "platform_is()" lives in intel_mid_pm.h in the MCG
- * tree, but it's just platform ID info and we don't want to pull in
- * the whole SFI-based PM architecture.
- */
-#define INTEL_ATOM_MRST 0x26
-#define INTEL_ATOM_MFLD 0x27
-#define INTEL_ATOM_CLV 0x35
-#define INTEL_ATOM_MRFLD 0x4a
-#define INTEL_ATOM_BYT 0x37
-#define INTEL_ATOM_MOORFLD 0x5a
-#define INTEL_ATOM_CHT 0x4c
-static inline int platform_is(u8 model)
-{
-	return (boot_cpu_data.x86_model == model);
-}
-
-#include "../../include/asm/intel_mid_pcihelpers.h"
-
-/* Unified message bus read/write operation */
-static DEFINE_SPINLOCK(msgbus_lock);
-
-static struct pci_dev *pci_root;
-static struct pm_qos_request pm_qos;
-
-#define DW_I2C_NEED_QOS	(platform_is(INTEL_ATOM_BYT))
-
-static int intel_mid_msgbus_init(void)
-{
-	pci_root = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
-	if (!pci_root) {
-		pr_err("%s: Error: msgbus PCI handle NULL\n", __func__);
-		return -ENODEV;
-	}
-
-	if (DW_I2C_NEED_QOS) {
-		pm_qos_add_request(&pm_qos,
-			PM_QOS_CPU_DMA_LATENCY,
-			PM_QOS_DEFAULT_VALUE);
-	}
-	return 0;
-}
-fs_initcall(intel_mid_msgbus_init);
-
-u32 intel_mid_msgbus_read32(u8 port, u32 addr)
-{
-	unsigned long irq_flags;
-	u32 data;
-	u32 cmd;
-	u32 cmdext;
-
-	cmd = (PCI_ROOT_MSGBUS_READ << 24) | (port << 16) |
-		((addr & 0xff) << 8) | PCI_ROOT_MSGBUS_DWORD_ENABLE;
-	cmdext = addr & 0xffffff00;
-
-	spin_lock_irqsave(&msgbus_lock, irq_flags);
-
-	if (cmdext) {
-		/* This resets to 0 automatically, no need to write 0 */
-		pci_write_config_dword(pci_root, PCI_ROOT_MSGBUS_CTRL_EXT_REG,
-					cmdext);
-	}
-
-	pci_write_config_dword(pci_root, PCI_ROOT_MSGBUS_CTRL_REG, cmd);
-	pci_read_config_dword(pci_root, PCI_ROOT_MSGBUS_DATA_REG, &data);
-	spin_unlock_irqrestore(&msgbus_lock, irq_flags);
-
-	return data;
-}
-EXPORT_SYMBOL(intel_mid_msgbus_read32);
-
-void intel_mid_msgbus_write32(u8 port, u32 addr, u32 data)
-{
-	unsigned long irq_flags;
-	u32 cmd;
-	u32 cmdext;
-
-	cmd = (PCI_ROOT_MSGBUS_WRITE << 24) | (port << 16) |
-		((addr & 0xFF) << 8) | PCI_ROOT_MSGBUS_DWORD_ENABLE;
-	cmdext = addr & 0xffffff00;
-
-	spin_lock_irqsave(&msgbus_lock, irq_flags);
-	pci_write_config_dword(pci_root, PCI_ROOT_MSGBUS_DATA_REG, data);
-
-	if (cmdext) {
-		/* This resets to 0 automatically, no need to write 0 */
-		pci_write_config_dword(pci_root, PCI_ROOT_MSGBUS_CTRL_EXT_REG,
-					cmdext);
-	}
-
-	pci_write_config_dword(pci_root, PCI_ROOT_MSGBUS_CTRL_REG, cmd);
-	spin_unlock_irqrestore(&msgbus_lock, irq_flags);
-}
-EXPORT_SYMBOL(intel_mid_msgbus_write32);
-- 
2.14.1
