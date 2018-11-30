Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37866 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbeLADkQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 22:40:16 -0500
To: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Ettore Chimenti <ek5.chimenti@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -next] media: seco-cec: add missing header file to fix build
Message-ID: <3e9c29d3-5e34-751d-134e-b2a0599aeb10@infradead.org>
Date: Fri, 30 Nov 2018 08:30:20 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors due to missing <linux/module.h> header file.
The header file is inserted first because module-related errors
begin showing up in <linux/acpi.h> (when CONFIG_ACPI is not set).

Sample of build errors:

In file included from ../include/linux/acpi.h:27:0,
                 from ../drivers/media/platform/seco-cec/seco-cec.c:10:
../include/linux/device.h:1620:1: warning: data definition has no type or storage class [enabled by default]
 module_exit(__driver##_exit);
 ^
../include/linux/platform_device.h:229:2: note: in expansion of macro 'module_driver'
  module_driver(__platform_driver, platform_driver_register, \
  ^
../drivers/media/platform/seco-cec/seco-cec.c:791:1: note: in expansion of macro 'module_platform_driver'
 module_platform_driver(secocec_driver);
 ^
../include/linux/device.h:1620:1: error: type defaults to 'int' in declaration of 'module_exit' [-Werror=implicit-int]
 module_exit(__driver##_exit);
 ^
../include/linux/platform_device.h:229:2: note: in expansion of macro 'module_driver'
  module_driver(__platform_driver, platform_driver_register, \
  ^
../drivers/media/platform/seco-cec/seco-cec.c:791:1: note: in expansion of macro 'module_platform_driver'
 module_platform_driver(secocec_driver);
 ^
In file included from ../include/linux/linkage.h:7:0,
                 from ../include/linux/kernel.h:7,
                 from ../include/linux/list.h:9,
                 from ../include/linux/resource_ext.h:17,
                 from ../include/linux/acpi.h:26,
                 from ../drivers/media/platform/seco-cec/seco-cec.c:10:
../include/linux/export.h:18:30: warning: parameter names (without types) in function declaration [enabled by default]
 #define THIS_MODULE ((struct module *)0)
                              ^
../include/linux/platform_device.h:199:34: note: in expansion of macro 'THIS_MODULE'
  __platform_driver_register(drv, THIS_MODULE)
                                  ^
../include/linux/device.h:1613:9: note: in expansion of macro 'platform_driver_register'
  return __register(&(__driver) , ##__VA_ARGS__); \
         ^
../include/linux/platform_device.h:229:2: note: in expansion of macro 'module_driver'
  module_driver(__platform_driver, platform_driver_register, \
  ^
../drivers/media/platform/seco-cec/seco-cec.c:791:1: note: in expansion of macro 'module_platform_driver'
 module_platform_driver(secocec_driver);
 ^
../drivers/media/platform/seco-cec/seco-cec.c:793:20: error: expected declaration specifiers or '...' before string constant
 MODULE_DESCRIPTION("SECO CEC X86 Driver");
                    ^
../drivers/media/platform/seco-cec/seco-cec.c:794:15: error: expected declaration specifiers or '...' before string constant
 MODULE_AUTHOR("Ettore Chimenti <ek5.chimenti@gmail.com>");
               ^
../drivers/media/platform/seco-cec/seco-cec.c:795:16: error: expected declaration specifiers or '...' before string constant
 MODULE_LICENSE("Dual BSD/GPL");
                ^
In file included from ../include/linux/acpi.h:27:0,
                 from ../drivers/media/platform/seco-cec/seco-cec.c:10:
../drivers/media/platform/seco-cec/seco-cec.c:791:24: warning: 'secocec_driver_init' defined but not used [-Wunused-function]
 module_platform_driver(secocec_driver);
                        ^
../include/linux/device.h:1611:19: note: in definition of macro 'module_driver'
 static int __init __driver##_init(void) \
                   ^
../drivers/media/platform/seco-cec/seco-cec.c:791:1: note: in expansion of macro 'module_platform_driver'
 module_platform_driver(secocec_driver);


Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ettore Chimenti <ek5.chimenti@gmail.com>
---
 drivers/media/platform/seco-cec/seco-cec.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20181130.orig/drivers/media/platform/seco-cec/seco-cec.c
+++ linux-next-20181130/drivers/media/platform/seco-cec/seco-cec.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2018, Aidilab Srl.
  */
 
+#include <linux/module.h>
 #include <linux/acpi.h>
 #include <linux/delay.h>
 #include <linux/dmi.h>
