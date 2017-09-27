Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3795 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751263AbdI0SZP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 14:25:15 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 06/13] staging: atomisp: Remove unneeded gpio.h inclusion
Date: Wed, 27 Sep 2017 21:25:01 +0300
Message-Id: <20170927182508.52119-7-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
References: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

GPIO handling is done only in two modules, the rest do not need to
include linux/gpio.h header.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/gc0310.c        | 1 -
 drivers/staging/media/atomisp/i2c/gc2235.c        | 1 -
 drivers/staging/media/atomisp/i2c/mt9m114.c       | 1 -
 drivers/staging/media/atomisp/i2c/ov2680.c        | 1 -
 drivers/staging/media/atomisp/i2c/ov2722.c        | 1 -
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c | 1 -
 6 files changed, 6 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c b/drivers/staging/media/atomisp/i2c/gc0310.c
index 6f54304f1ca0..0e6fcf44b656 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/gc0310.c
@@ -26,7 +26,6 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
-#include <linux/gpio.h>
 #include <linux/moduleparam.h>
 #include <media/v4l2-device.h>
 #include <linux/io.h>
diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 8ed12e16caf4..94b93ccc6aeb 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -26,7 +26,6 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
-#include <linux/gpio.h>
 #include <linux/moduleparam.h>
 #include <media/v4l2-device.h>
 #include "../include/linux/atomisp_gmin_platform.h"
diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index 8c75372782d8..4ac1ad045283 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
-#include <linux/gpio.h>
 #include <linux/acpi.h>
 #include "../include/linux/atomisp_gmin_platform.h"
 #include <media/v4l2-device.h>
diff --git a/drivers/staging/media/atomisp/i2c/ov2680.c b/drivers/staging/media/atomisp/i2c/ov2680.c
index 99c6d699f899..a42adeeb748c 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/ov2680.c
@@ -26,7 +26,6 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
-#include <linux/gpio.h>
 #include <linux/moduleparam.h>
 #include <media/v4l2-device.h>
 #include <linux/io.h>
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.c b/drivers/staging/media/atomisp/i2c/ov2722.c
index 2481fda345c0..1b7012f47303 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/ov2722.c
@@ -26,7 +26,6 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
-#include <linux/gpio.h>
 #include <linux/moduleparam.h>
 #include <media/v4l2-device.h>
 #include "../include/linux/atomisp_gmin_platform.h"
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
index a083c61ad3ea..357821af4db0 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
@@ -31,7 +31,6 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
-#include <linux/gpio.h>
 #include <linux/moduleparam.h>
 #include <media/v4l2-device.h>
 #include <linux/io.h>
-- 
2.14.1
