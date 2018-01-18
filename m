Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:58462 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932402AbeARNSk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 08:18:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Wenyou Yang <wenyou.yang@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: i2c: ov7740: use gpio/consumer.h instead of gpio.h
Date: Thu, 18 Jan 2018 14:18:12 +0100
Message-Id: <20180118131828.944700-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When built on a platform without gpiolib support, we run into
a couple of compile errors in ov7740, including:

drivers/media/i2c/ov7740.c: In function 'ov7740_set_power':
drivers/media/i2c/ov7740.c:307:4: error: implicit declaration of function 'gpiod_direction_output'; did you mean 'gpio_direction_output'? [-Werror=implicit-function-declaration]
    gpiod_direction_output(ov7740->pwdn_gpio, 0);
drivers/media/i2c/ov7740.c:914:4: error: 'GPIOD_OUT_HIGH' undeclared (first use in this function); did you mean 'GPIOF_INIT_HIGH'?

Changing it to use the correct header file solves the problem.

Fixes: 39c5c4471b8d ("media: i2c: Add the ov7740 image sensor driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/ov7740.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index 0308ba437bbb..0db107196d7a 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -3,7 +3,7 @@
 
 #include <linux/clk.h>
 #include <linux/delay.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
-- 
2.9.0
