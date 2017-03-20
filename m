Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:61540 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753508AbdCTJdF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 05:33:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 9/9] staging/atomisp: add EFI dependency
Date: Mon, 20 Mar 2017 10:32:25 +0100
Message-Id: <20170320093225.1180723-9-arnd@arndb.de>
In-Reply-To: <20170320093225.1180723-1-arnd@arndb.de>
References: <20170320093225.1180723-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without CONFIG_EFI, the driver fails to call efivar_entry_get:

drivers/staging/built-in.o: In function `gmin_get_config_var':
(.text+0x1e3b): undefined reference to `efivar_entry_get'

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/atomisp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/Kconfig b/drivers/staging/media/atomisp/Kconfig
index f24ae1c8cc90..e0ae0c93f800 100644
--- a/drivers/staging/media/atomisp/Kconfig
+++ b/drivers/staging/media/atomisp/Kconfig
@@ -1,6 +1,6 @@
 menuconfig INTEL_ATOMISP
         bool "Enable support to Intel MIPI camera drivers"
-        depends on X86 && PCI && ACPI && MEDIA_CONTROLLER
+        depends on X86 && PCI && ACPI && EFI && MEDIA_CONTROLLER
         help
           Enable support for the Intel ISP2 camera interfaces and MIPI
           sensor drivers.
-- 
2.9.0
