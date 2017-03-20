Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:57392 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753605AbdCTOmE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:42:04 -0400
Subject: [PATCH 14/24] staging/atomisp: include linux/io.h where needed
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:41:11 +0000
Message-ID: <149002086999.17109.2057493049108047404.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

The plat_clock implementation fails ot build in some configurations:

platform/clock/vlv2_plat_clock.c: In function 'vlv2_plat_set_clock_freq':
platform/clock/vlv2_plat_clock.c:88:2: error: implicit declaration of function 'writel';did you mean 'wrmsrl'? [-Werror=implicit-function-declaration]
platform/clock/vlv2_plat_clock.c:88:12: error: implicit declaration of function 'readl' [-Werror=implicit-function-declaration]
platform/clock/vlv2_plat_clock.c: In function 'vlv2_plat_clk_probe':
platform/clock/vlv2_plat_clock.c:193:13: error: implicit declaration of function 'ioremap_nocache' [-Werror=implicit-function-declaration]
platform/clock/vlv2_plat_clock.c:193:11: error: assignment makes pointer from integer without a cast [-Werror=int-conversion]
platform/clock/vlv2_plat_clock.c: In function 'vlv2_plat_clk_remove':
platform/clock/vlv2_plat_clock.c:209:2: error: implicit declaration of function 'iounmap' [-Werror=implicit-function-declaration]

This includes the required header file.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/platform/clock/vlv2_plat_clock.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c b/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
index a8ca93d..25e939c 100644
--- a/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
+++ b/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include "../../include/linux/vlv2_plat_clock.h"
