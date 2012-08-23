Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:41197 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab2HWVSb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 17:18:31 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] [media] ttusbir: Add USB dependency
Date: Thu, 23 Aug 2012 22:18:30 +0100
Message-Id: <1345756710-17609-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the error:
ERROR: "usb_speed_string" [drivers/usb/core/usbcore.ko] undefined!

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 4682a5a..83e8b71 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -276,6 +276,7 @@ config IR_IGUANA
 
 config IR_TTUSBIR
 	tristate "TechnoTrend USB IR Receiver"
+	depends on USB_ARCH_HAS_HCD
 	depends on RC_CORE
 	select USB
 	select NEW_LEDS
-- 
1.7.11.4

