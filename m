Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9429 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753739AbdCTOmI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:42:08 -0400
Subject: [PATCH 20/24] staging/atomisp: add ACPI dependency
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:42:05 +0000
Message-ID: <149002092332.17109.8111175086471063268.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

Without ACPI, some of the code fails to build:

media/atomisp/platform/intel-mid/atomisp_gmin_platform.c: In function 'atomisp_register_i2c_module':
media/atomisp/platform/intel-mid/atomisp_gmin_platform.c:174:7: error: dereferencing pointer to incomplete type 'struct acpi_device'

We could work around that in the code, but since we already have a hard
dependency on x86, adding the ACPI dependency seems to be the easiest
solution.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/staging/media/atomisp/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/Kconfig b/drivers/staging/media/atomisp/Kconfig
index 8b172ed..8eb13c3 100644
--- a/drivers/staging/media/atomisp/Kconfig
+++ b/drivers/staging/media/atomisp/Kconfig
@@ -1,6 +1,6 @@
 menuconfig INTEL_ATOMISP
         bool "Enable support to Intel MIPI camera drivers"
-        depends on X86 && EFI && MEDIA_CONTROLLER && PCI
+        depends on X86 && EFI && MEDIA_CONTROLLER && PCI && ACPI
         help
           Enable support for the Intel ISP2 camera interfaces and MIPI
           sensor drivers.
