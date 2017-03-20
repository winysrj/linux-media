Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:59852 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753441AbdCTJcz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 05:32:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/9] staging/atomisp: add PCI dependency
Date: Mon, 20 Mar 2017 10:32:22 +0100
Message-Id: <20170320093225.1180723-6-arnd@arndb.de>
In-Reply-To: <20170320093225.1180723-1-arnd@arndb.de>
References: <20170320093225.1180723-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
---
 drivers/staging/media/atomisp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/Kconfig b/drivers/staging/media/atomisp/Kconfig
index f7d8a841c629..3af2acdc7e96 100644
--- a/drivers/staging/media/atomisp/Kconfig
+++ b/drivers/staging/media/atomisp/Kconfig
@@ -1,6 +1,6 @@
 menuconfig INTEL_ATOMISP
         bool "Enable support to Intel MIPI camera drivers"
-        depends on X86
+        depends on X86 && PCI
         help
           Enable support for the Intel ISP2 camera interfaces and MIPI
           sensor drivers.
-- 
2.9.0
