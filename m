Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:53361 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753437AbdCTJcz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 05:32:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/9] staging/atomisp: include linux/io.h where needed
Date: Mon, 20 Mar 2017 10:32:17 +0100
Message-Id: <20170320093225.1180723-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
---
 drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c b/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
index a8ca93dbfbb5..25e939c50aef 100644
--- a/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
+++ b/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include "../../include/linux/vlv2_plat_clock.h"
-- 
2.9.0
