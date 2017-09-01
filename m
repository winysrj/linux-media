Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28637 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752322AbdIANgo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 09:36:44 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Alan Cox <alan@linux.intel.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 4/7] staging: atomisp: Remove dead code for MID (#3)
Date: Fri,  1 Sep 2017 16:36:37 +0300
Message-Id: <20170901133640.17589-4-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170901133640.17589-1-andriy.shevchenko@linux.intel.com>
References: <20170901133640.17589-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

intel_mid_msgbus_*_raw*() are not used anywhere.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../atomisp/include/asm/intel_mid_pcihelpers.h     |  4 --
 .../platform/intel-mid/intel_mid_pcihelpers.c      | 58 ----------------------
 2 files changed, 62 deletions(-)

diff --git a/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h b/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
index 5d8451ee391e..bf39f42c1c96 100644
--- a/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
+++ b/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
@@ -18,9 +18,5 @@
 #define PCI_ROOT_MSGBUS_WRITE           0x11
 #define PCI_ROOT_MSGBUS_DWORD_ENABLE    0xf0
 
-u32 intel_mid_msgbus_read32_raw(u32 cmd);
 u32 intel_mid_msgbus_read32(u8 port, u32 addr);
-void intel_mid_msgbus_write32_raw(u32 cmd, u32 data);
 void intel_mid_msgbus_write32(u8 port, u32 addr, u32 data);
-u32 intel_mid_msgbus_read32_raw_ext(u32 cmd, u32 cmd_ext);
-void intel_mid_msgbus_write32_raw_ext(u32 cmd, u32 cmd_ext, u32 data);
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
index c34f461653db..4ed3268c4e63 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
@@ -46,64 +46,6 @@ static int intel_mid_msgbus_init(void)
 }
 fs_initcall(intel_mid_msgbus_init);
 
-u32 intel_mid_msgbus_read32_raw(u32 cmd)
-{
-	unsigned long irq_flags;
-	u32 data;
-
-	spin_lock_irqsave(&msgbus_lock, irq_flags);
-	pci_write_config_dword(pci_root, PCI_ROOT_MSGBUS_CTRL_REG, cmd);
-	pci_read_config_dword(pci_root, PCI_ROOT_MSGBUS_DATA_REG, &data);
-	spin_unlock_irqrestore(&msgbus_lock, irq_flags);
-
-	return data;
-}
-EXPORT_SYMBOL(intel_mid_msgbus_read32_raw);
-
-/*
- * GU: this function is only used by the VISA and 'VXD' drivers.
- */
-u32 intel_mid_msgbus_read32_raw_ext(u32 cmd, u32 cmd_ext)
-{
-	unsigned long irq_flags;
-	u32 data;
-
-	spin_lock_irqsave(&msgbus_lock, irq_flags);
-	pci_write_config_dword(pci_root, PCI_ROOT_MSGBUS_CTRL_EXT_REG, cmd_ext);
-	pci_write_config_dword(pci_root, PCI_ROOT_MSGBUS_CTRL_REG, cmd);
-	pci_read_config_dword(pci_root, PCI_ROOT_MSGBUS_DATA_REG, &data);
-	spin_unlock_irqrestore(&msgbus_lock, irq_flags);
-
-	return data;
-}
-EXPORT_SYMBOL(intel_mid_msgbus_read32_raw_ext);
-
-void intel_mid_msgbus_write32_raw(u32 cmd, u32 data)
-{
-	unsigned long irq_flags;
-
-	spin_lock_irqsave(&msgbus_lock, irq_flags);
-	pci_write_config_dword(pci_root, PCI_ROOT_MSGBUS_DATA_REG, data);
-	pci_write_config_dword(pci_root, PCI_ROOT_MSGBUS_CTRL_REG, cmd);
-	spin_unlock_irqrestore(&msgbus_lock, irq_flags);
-}
-EXPORT_SYMBOL(intel_mid_msgbus_write32_raw);
-
-/*
- * GU: this function is only used by the VISA and 'VXD' drivers.
- */
-void intel_mid_msgbus_write32_raw_ext(u32 cmd, u32 cmd_ext, u32 data)
-{
-	unsigned long irq_flags;
-
-	spin_lock_irqsave(&msgbus_lock, irq_flags);
-	pci_write_config_dword(pci_root, PCI_ROOT_MSGBUS_DATA_REG, data);
-	pci_write_config_dword(pci_root, PCI_ROOT_MSGBUS_CTRL_EXT_REG, cmd_ext);
-	pci_write_config_dword(pci_root, PCI_ROOT_MSGBUS_CTRL_REG, cmd);
-	spin_unlock_irqrestore(&msgbus_lock, irq_flags);
-}
-EXPORT_SYMBOL(intel_mid_msgbus_write32_raw_ext);
-
 u32 intel_mid_msgbus_read32(u8 port, u32 addr)
 {
 	unsigned long irq_flags;
-- 
2.14.1
