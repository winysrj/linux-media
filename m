Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:44832 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755509AbdDMCBG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 22:01:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, <linux-media@vger.kernel.org>,
        <devel@driverdev.osuosl.org>
Subject: [PATCH] staging/media: make atomisp vlv2_plat_clock explicitly non-modular
Date: Wed, 12 Apr 2017 21:57:55 -0400
Message-ID: <20170413015755.4533-1-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Makefile / Kconfig currently controlling compilation of this code is:

clock/Makefile:obj-$(CONFIG_INTEL_ATOMISP)     += vlv2_plat_clock.o

atomisp/Kconfig:menuconfig INTEL_ATOMISP
atomisp/Kconfig:        bool "Enable support to Intel MIPI camera drivers"

...meaning that it currently is not being built as a module by anyone.

Lets remove the modular code that is essentially orphaned, so that
when reading the driver there is no doubt it is builtin-only.

Since module_init was already not in use by this driver, the init
ordering remains unchanged with this commit.

Also note that MODULE_DEVICE_TABLE is a no-op for non-modular code.

We also delete the MODULE_LICENSE tag etc. since all that information
is already contained at the top of the file in the comments.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: linux-media@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 .../media/atomisp/platform/clock/vlv2_plat_clock.c  | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c b/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
index 25e939c50aef..a322539d2621 100644
--- a/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
+++ b/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
@@ -21,7 +21,7 @@
 
 #include <linux/err.h>
 #include <linux/io.h>
-#include <linux/module.h>
+#include <linux/init.h>
 #include <linux/platform_device.h>
 #include "../../include/linux/vlv2_plat_clock.h"
 
@@ -205,18 +205,10 @@ static int vlv2_plat_clk_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int vlv2_plat_clk_remove(struct platform_device *pdev)
-{
-	iounmap(pmc_base);
-	pmc_base = NULL;
-	return 0;
-}
-
 static const struct platform_device_id vlv2_plat_clk_id[] = {
 	{"vlv2_plat_clk", 0},
 	{}
 };
-MODULE_DEVICE_TABLE(platform, vlv2_plat_clk_id);
 
 static int vlv2_resume(struct device *device)
 {
@@ -241,7 +233,6 @@ static const struct dev_pm_ops vlv2_pm_ops = {
 
 static struct platform_driver vlv2_plat_clk_driver = {
 	.probe = vlv2_plat_clk_probe,
-	.remove = vlv2_plat_clk_remove,
 	.id_table = vlv2_plat_clk_id,
 	.driver = {
 		.name = "vlv2_plat_clk",
@@ -254,13 +245,3 @@ static int __init vlv2_plat_clk_init(void)
 	return platform_driver_register(&vlv2_plat_clk_driver);
 }
 arch_initcall(vlv2_plat_clk_init);
-
-static void __exit vlv2_plat_clk_exit(void)
-{
-	platform_driver_unregister(&vlv2_plat_clk_driver);
-}
-module_exit(vlv2_plat_clk_exit);
-
-MODULE_AUTHOR("Asutosh Pathak <asutosh.pathak@intel.com>");
-MODULE_DESCRIPTION("Intel VLV2 platform clock driver");
-MODULE_LICENSE("GPL v2");
-- 
2.11.0
