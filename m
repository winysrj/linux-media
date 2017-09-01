Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51251 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751983AbdIANho (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 09:37:44 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Alan Cox <alan@linux.intel.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 3/7] staging: atomisp: Remove dead code for MID (#2)
Date: Fri,  1 Sep 2017 16:36:36 +0300
Message-Id: <20170901133640.17589-3-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170901133640.17589-1-andriy.shevchenko@linux.intel.com>
References: <20170901133640.17589-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

intel_mid_soc_stepping() is not used anywhere.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h   | 1 -
 .../media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c        | 7 -------
 2 files changed, 8 deletions(-)

diff --git a/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h b/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
index 0d7f5c618b56..5d8451ee391e 100644
--- a/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
+++ b/drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
@@ -24,4 +24,3 @@ void intel_mid_msgbus_write32_raw(u32 cmd, u32 data);
 void intel_mid_msgbus_write32(u8 port, u32 addr, u32 data);
 u32 intel_mid_msgbus_read32_raw_ext(u32 cmd, u32 cmd_ext);
 void intel_mid_msgbus_write32_raw_ext(u32 cmd, u32 cmd_ext, u32 data);
-u32 intel_mid_soc_stepping(void);
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
index 341bfd3ab313..c34f461653db 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
@@ -154,10 +154,3 @@ void intel_mid_msgbus_write32(u8 port, u32 addr, u32 data)
 	spin_unlock_irqrestore(&msgbus_lock, irq_flags);
 }
 EXPORT_SYMBOL(intel_mid_msgbus_write32);
-
-/* called only from where is later then fs_initcall */
-u32 intel_mid_soc_stepping(void)
-{
-	return pci_root->revision;
-}
-EXPORT_SYMBOL(intel_mid_soc_stepping);
-- 
2.14.1
