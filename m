Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:54881 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753395AbdCTJc7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 05:32:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7/9] staging/atomisp: add ACPI dependency
Date: Mon, 20 Mar 2017 10:32:23 +0100
Message-Id: <20170320093225.1180723-7-arnd@arndb.de>
In-Reply-To: <20170320093225.1180723-1-arnd@arndb.de>
References: <20170320093225.1180723-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without ACPI, some of the code fails to build:

media/atomisp/platform/intel-mid/atomisp_gmin_platform.c: In function 'atomisp_register_i2c_module':
media/atomisp/platform/intel-mid/atomisp_gmin_platform.c:174:7: error: dereferencing pointer to incomplete type 'struct acpi_device'

We could work around that in the code, but since we already have a hard
dependency on x86, adding the ACPI dependency seems to be the easiest
solution.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/atomisp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/Kconfig b/drivers/staging/media/atomisp/Kconfig
index 3af2acdc7e96..97ffa2fc5384 100644
--- a/drivers/staging/media/atomisp/Kconfig
+++ b/drivers/staging/media/atomisp/Kconfig
@@ -1,6 +1,6 @@
 menuconfig INTEL_ATOMISP
         bool "Enable support to Intel MIPI camera drivers"
-        depends on X86 && PCI
+        depends on X86 && PCI && ACPI
         help
           Enable support for the Intel ISP2 camera interfaces and MIPI
           sensor drivers.
-- 
2.9.0
