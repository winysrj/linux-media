Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:49482 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaFEUtE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jun 2014 16:49:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 3/5] staging: sn9c102 depends on USB
Date: Thu,  5 Jun 2014 22:48:13 +0200
Message-Id: <1402001295-1980118-4-git-send-email-arnd@arndb.de>
In-Reply-To: <1402001295-1980118-1-git-send-email-arnd@arndb.de>
References: <1402001295-1980118-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the USB code is a loadable module, this driver cannot
be built-in. This adds an explicit dependency on CONFIG_USB
so that Kconfig can force sn9c102 to be a module in this case.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Cc: linux-usb@vger.kernel.org
---
 drivers/staging/media/sn9c102/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/sn9c102/Kconfig b/drivers/staging/media/sn9c102/Kconfig
index c9aba59..10f586b 100644
--- a/drivers/staging/media/sn9c102/Kconfig
+++ b/drivers/staging/media/sn9c102/Kconfig
@@ -1,6 +1,6 @@
 config USB_SN9C102
 	tristate "USB SN9C1xx PC Camera Controller support (DEPRECATED)"
-	depends on VIDEO_V4L2 && MEDIA_USB_SUPPORT
+	depends on VIDEO_V4L2 && MEDIA_USB_SUPPORT && USB
 	---help---
 	  This driver is DEPRECATED, please use the gspca sonixb and
 	  sonixj modules instead.
-- 
1.8.3.2

