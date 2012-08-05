Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab2HEDaY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Aug 2012 23:30:24 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/5] [media] dvb-usb-v2: Don't ask user to select Cypress firmware module
Date: Sun,  5 Aug 2012 00:30:08 -0300
Message-Id: <1344137411-27948-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344137411-27948-1-git-send-email-mchehab@redhat.com>
References: <1344137411-27948-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb-usb-v2 cypress firmware module is not optional, as drivers
won't work without it. So, instead of opening a menu for the user to
manually select, let the drivers that need it to select, hiding this
option from the Kconfig menu.

Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb-v2/Kconfig | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb-v2/Kconfig b/drivers/media/dvb/dvb-usb-v2/Kconfig
index 81f0f1c..98b8fb5 100644
--- a/drivers/media/dvb/dvb-usb-v2/Kconfig
+++ b/drivers/media/dvb/dvb-usb-v2/Kconfig
@@ -16,14 +16,6 @@ config DVB_USB_V2
 config DVB_USB_CYPRESS_FIRMWARE
 	tristate "Cypress firmware helper routines"
 	depends on DVB_USB_V2
-	help
-	  Common firmware download routine for various Cypress USB interface
-	  chips.
-
-	  Supported models are:
-	  Cypress AN2135
-	  Cypress AN2235
-	  Cypress FX2
 
 config DVB_USB_AF9015
 	tristate "Afatech AF9015 DVB-T USB2.0 support"
-- 
1.7.11.2

