Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:38110 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751248AbdJEMLW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Oct 2017 08:11:22 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23990407AbdJEMLU5CRD8 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Oct 2017 14:11:20 +0200
Date: Thu, 5 Oct 2017 14:11:06 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, Sean Young <sean@mess.org>
Subject: [PATCH v2] media: rc: fix gpio-ir-receiver build failure
Message-ID: <20171005121105.zdldrc323lpp2upn@lenoch>
References: <201710051617.Heo0ts1p%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201710051617.Heo0ts1p%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 0-day robot reports:

   drivers/media/rc/gpio-ir-recv.c: In function 'gpio_ir_recv_irq':
>> drivers/media/rc/gpio-ir-recv.c:38:8: error: implicit declaration of function 'gpiod_get_value' [-Werror=implicit-function-declaration]

Fixes: eed008e605d1 ("[media] media: rc: gpio-ir-recv: use gpiolib API")

For some reason only partial patch was applied. Also include
gpio/consumer.h otherwise compile test fails.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 Changes:
 -v2: replace Sean's patch with something I believe is more accurate

 drivers/media/rc/Kconfig        |    1 +
 drivers/media/rc/gpio-ir-recv.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index d9ce8ff55d0c..6bfe983ff295 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -393,6 +393,7 @@ config RC_LOOPBACK
 config IR_GPIO_CIR
 	tristate "GPIO IR remote control"
 	depends on RC_CORE
+	depends on (OF && GPIOLIB) || COMPILE_TEST
 	---help---
 	   Say Y if you want to use GPIO based IR Receiver.

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 5bb0851eacce..b6c4a2d2b696 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -14,7 +14,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
