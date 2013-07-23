Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58598 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757117Ab3GWMd5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 08:33:57 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Jim Davis <jim.epost@gmail.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH] dvb-usb-v2: fix Kconfig dependency when RC_CORE=m
Date: Tue, 23 Jul 2013 15:32:45 +0300
Message-Id: <1374582765-2732-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is not allowed to build driver as a build-in when RC_CORE
(remote controller support) is build as a module.

randconfig build error with next-20130719, in drivers/media/usb

drivers/built-in.o: In function `dvb_usbv2_disconnect':
(.text+0x154b39): undefined reference to `rc_unregister_device'
drivers/built-in.o: In function `dvb_usbv2_init_work':
dvb_usb_core.c:(.text+0x155b2d): undefined reference to `rc_allocate_device'
dvb_usb_core.c:(.text+0x155c38): undefined reference to `rc_register_device'
dvb_usb_core.c:(.text+0x155c5b): undefined reference to `rc_free_device'
drivers/built-in.o: In function `anysee_rc_query':
anysee.c:(.text+0x157795): undefined reference to `rc_keydown'

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index a3c8ecf..2059d0c 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -1,6 +1,6 @@
 config DVB_USB_V2
 	tristate "Support for various USB DVB devices v2"
-	depends on DVB_CORE && USB && I2C
+	depends on DVB_CORE && USB && I2C && (RC_CORE || RC_CORE=n)
 	help
 	  By enabling this you will be able to choose the various supported
 	  USB1.1 and USB2.0 DVB devices.
-- 
1.7.11.7

