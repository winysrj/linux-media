Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53627 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751446AbdJEVbB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 17:31:01 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] media: rc: gpio-ir-tx does not work without devicetree or gpiolib
Date: Thu,  5 Oct 2017 22:30:57 +0100
Message-Id: <20171005213059.11074-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the kernel is built without device tree, this driver cannot be
used and without gpiolib it cannot control any gpio pin.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 451cba1fe9bf..946d2ec419db 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -403,6 +403,7 @@ config IR_GPIO_TX
 	tristate "GPIO IR Bit Banging Transmitter"
 	depends on RC_CORE
 	depends on LIRC
+	depends on (OF && GPIOLIB) || COMPILE_TEST
 	---help---
 	   Say Y if you want to a GPIO based IR transmitter. This is a
 	   bit banging driver.
-- 
2.13.6
