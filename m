Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49241 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751890AbdJELDa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 07:03:30 -0400
Date: Thu, 5 Oct 2017 12:03:28 +0100
From: Sean Young <sean@mess.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Ladislav Michl <ladis@linux-mips.org>, kbuild-all@01.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: rc: fix gpio-ir-receiver build failure
Message-ID: <20171005110327.z4oqlna7jdjk7gh5@gofer.mess.org>
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

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 467cf2bdbd42..b9ae0cb01a53 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -392,6 +392,7 @@ config RC_LOOPBACK
 config IR_GPIO_CIR
 	tristate "GPIO IR remote control"
 	depends on RC_CORE
+	depends on GPIOLIB
 	---help---
 	   Say Y if you want to use GPIO based IR Receiver.
 
-- 
2.13.6
