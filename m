Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:62477 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbcGSPRW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 11:17:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [media] dvb-usb: avoid link error with dib3000m{b,c|
Date: Tue, 19 Jul 2016 17:14:35 +0200
Message-Id: <20160719151645.2610846-2-arnd@arndb.de>
In-Reply-To: <20160719151645.2610846-1-arnd@arndb.de>
References: <20160719151645.2610846-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tha ARM randconfig builds came up with another rare build failure
for the dib3000mc driver, when dvb-usb-dibusb-mb is built-in and
dib3000mc is a loadable module:

ERROR: "dibusb_dib3000mc_frontend_attach" [drivers/media/usb/dvb-usb/dvb-usb-nova-t-usb2.ko] undefined!
ERROR: "dibusb_dib3000mc_tuner_attach" [drivers/media/usb/dvb-usb/dvb-usb-nova-t-usb2.ko] undefined!

Apparently this used to be a valid configuration (build-time, not
run-time), but broke as part of a cleanup.

I tried reverting the cleanup, but saw that the code was still wrong
then. This version adds a dependency for dib3000mb, to ensure that
dib3000mb does not force the dibusb_dib3000mc_frontend_attach function
to be built-in when dib3000mc is a loadable module.

I have also checked the two other files that were changed in the original
cleanup, and found them to be correct in either version, so I do not
touch that part.

As this is a rather obscure bug, there is no need for backports.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 028c70ff42783 ("[media] dvb-usb/dvb-usb-v2: use IS_ENABLED")
---
This is one of two different ways to avoid the link error, please
pick one of them. Adding a dependency is simpler but slighly
more limiting.
---
 drivers/media/usb/dvb-usb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index 8c911119faa6..959fa09dfd92 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -44,6 +44,7 @@ config DVB_USB_DIBUSB_MB
 	depends on DVB_USB
 	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DIB3000MB
+	depends on DVB_DIB3000MC || !DVB_DIB3000MC
 	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for USB 1.1 and 2.0 DVB-T receivers based on reference designs made by
-- 
2.9.0

