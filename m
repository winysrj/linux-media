Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16873 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752237AbdIANhR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 09:37:17 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Alan Cox <alan@linux.intel.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 7/7] staging: atomisp: Remove unneeded intel-mid.h inclusion
Date: Fri,  1 Sep 2017 16:36:40 +0300
Message-Id: <20170901133640.17589-7-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170901133640.17589-1-andriy.shevchenko@linux.intel.com>
References: <20170901133640.17589-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In many files in the driver the intel-mid.h header inclusion is redundant.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/imx/drv201.c                        | 1 -
 drivers/staging/media/atomisp/i2c/imx/dw9714.c                        | 1 -
 drivers/staging/media/atomisp/i2c/imx/imx.c                           | 1 -
 drivers/staging/media/atomisp/i2c/imx/otp_imx.c                       | 1 -
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c              | 1 -
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h         | 2 --
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c            | 1 -
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c           | 1 -
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c             | 1 -
 drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.h | 1 -
 10 files changed, 11 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/imx/drv201.c b/drivers/staging/media/atomisp/i2c/imx/drv201.c
index 6d9d4c968722..532af7da3158 100644
--- a/drivers/staging/media/atomisp/i2c/imx/drv201.c
+++ b/drivers/staging/media/atomisp/i2c/imx/drv201.c
@@ -16,7 +16,6 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <media/v4l2-device.h>
-#include <asm/intel-mid.h>
 
 #include "drv201.h"
 
diff --git a/drivers/staging/media/atomisp/i2c/imx/dw9714.c b/drivers/staging/media/atomisp/i2c/imx/dw9714.c
index 6397a7ee0af6..7e58fb3589cc 100644
--- a/drivers/staging/media/atomisp/i2c/imx/dw9714.c
+++ b/drivers/staging/media/atomisp/i2c/imx/dw9714.c
@@ -16,7 +16,6 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <media/v4l2-device.h>
-#include <asm/intel-mid.h>
 
 #include "dw9714.h"
 
diff --git a/drivers/staging/media/atomisp/i2c/imx/imx.c b/drivers/staging/media/atomisp/i2c/imx/imx.c
index 49ab0af87096..71b688970822 100644
--- a/drivers/staging/media/atomisp/i2c/imx/imx.c
+++ b/drivers/staging/media/atomisp/i2c/imx/imx.c
@@ -18,7 +18,6 @@
  * 02110-1301, USA.
  *
  */
-#include <asm/intel-mid.h>
 #include "../../include/linux/atomisp_platform.h"
 #include <linux/bitops.h>
 #include <linux/device.h>
diff --git a/drivers/staging/media/atomisp/i2c/imx/otp_imx.c b/drivers/staging/media/atomisp/i2c/imx/otp_imx.c
index 1ca27c26ef75..279784cab6c3 100644
--- a/drivers/staging/media/atomisp/i2c/imx/otp_imx.c
+++ b/drivers/staging/media/atomisp/i2c/imx/otp_imx.c
@@ -30,7 +30,6 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <media/v4l2-device.h>
-#include <asm/intel-mid.h>
 #include "common.h"
 
 /* Defines for OTP Data Registers */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 73e15dd9d4d6..b0c647f4d250 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -28,7 +28,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/timer.h>
 
-#include <asm/intel-mid.h>
 #include <asm/iosf_mbi.h>
 
 #include <media/v4l2-event.h>
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
index 1fe1711387a2..6c1eb417361d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
@@ -29,8 +29,6 @@
 #include <linux/pm_qos.h>
 #include <linux/idr.h>
 
-#include <asm/intel-mid.h>
-
 #include <media/media-device.h>
 #include <media/v4l2-subdev.h>
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index 717647951fb6..dd59167237c1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
@@ -24,7 +24,6 @@
 #include <linux/delay.h>
 #include <linux/pci.h>
 
-#include <asm/intel-mid.h>
 
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
index 744ab6eb42a0..d27a50e66be2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <asm/intel-mid.h>
 
 #include <media/v4l2-event.h>
 #include <media/v4l2-mediabus.h>
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 0896f5ea7e4e..e85b3819bffa 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -28,7 +28,6 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 
-#include <asm/intel-mid.h>
 #include <asm/iosf_mbi.h>
 
 #include "../../include/linux/atomisp_gmin_platform.h"
diff --git a/drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.h b/drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.h
index b730ab0e8223..3bc0de129780 100644
--- a/drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.h
+++ b/drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.h
@@ -20,7 +20,6 @@
 #define _PLATFORM_VLV2_PLAT_CLK_H_
 
 #include <linux/sfi.h>
-#include <asm/intel-mid.h>
 
 extern void __init *vlv2_plat_clk_device_platform_data(
 				void *info) __attribute__((weak));
-- 
2.14.1
