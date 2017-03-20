Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:64680 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753715AbdCTOmE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:42:04 -0400
Subject: [PATCH 19/24] staging/atomisp: add PCI dependency
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:41:55 +0000
Message-ID: <149002091472.17109.9357026088604954399.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

Without CONFIG_PCI, config space reads never return any data,
leading to undefined behavior that gcc warns about:

platform/intel-mid/intel_mid_pcihelpers.c: In function 'intel_mid_msgbus_read32_raw':
platform/intel-mid/intel_mid_pcihelpers.c:66:9: error: 'data' is used uninitialized in this function [-Werror=uninitialized]
platform/intel-mid/intel_mid_pcihelpers.c: In function 'intel_mid_msgbus_read32_raw_ext':
platform/intel-mid/intel_mid_pcihelpers.c:84:9: error: 'data' is used uninitialized in this function [-Werror=uninitialized]
platform/intel-mid/intel_mid_pcihelpers.c: In function 'intel_mid_msgbus_read32':
platform/intel-mid/intel_mid_pcihelpers.c:137:9: error: 'data' is used uninitialized in this function [-Werror=uninitialized]

With a dependency on CONFIG_PCI, we don't get this warning. This seems
safe as PCI config space accessors should always return something
when PCI is enabled.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/staging/media/atomisp/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/Kconfig b/drivers/staging/media/atomisp/Kconfig
index 28615aa..8b172ed 100644
--- a/drivers/staging/media/atomisp/Kconfig
+++ b/drivers/staging/media/atomisp/Kconfig
@@ -1,6 +1,6 @@
 menuconfig INTEL_ATOMISP
         bool "Enable support to Intel MIPI camera drivers"
-        depends on X86 && EFI && MEDIA_CONTROLLER
+        depends on X86 && EFI && MEDIA_CONTROLLER && PCI
         help
           Enable support for the Intel ISP2 camera interfaces and MIPI
           sensor drivers.
