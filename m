Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab2HEDaZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Aug 2012 23:30:25 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/5] [media] dvb-usb-v2: Fix cypress firmware compilation
Date: Sun,  5 Aug 2012 00:30:07 -0300
Message-Id: <1344137411-27948-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344137411-27948-1-git-send-email-mchehab@redhat.com>
References: <1344137411-27948-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ERROR: "usbv2_cypress_load_firmware" [drivers/media/dvb/dvb-usb-v2/dvb-usb-az6007.ko] undefined!

Cypress fimware will never be compiled properly, as the Makefile rule
is wrong.

Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb-v2/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb/dvb-usb-v2/Makefile b/drivers/media/dvb/dvb-usb-v2/Makefile
index a98319c..4438dcd 100644
--- a/drivers/media/dvb/dvb-usb-v2/Makefile
+++ b/drivers/media/dvb/dvb-usb-v2/Makefile
@@ -1,7 +1,8 @@
 dvb_usbv2-objs = dvb_usb_core.o dvb_usb_urb.o usb_urb.o
 obj-$(CONFIG_DVB_USB_V2) += dvb_usbv2.o
 
-obj-$(DVB_USB_CYPRESS_FIRMWARE) += dvb_usb_cypress_firmware.o
+dvb_usb_cypress_firmware-objs = cypress_firmware.o
+obj-$(CONFIG_DVB_USB_CYPRESS_FIRMWARE) += dvb_usb_cypress_firmware.o
 
 dvb-usb-af9015-objs = af9015.o
 obj-$(CONFIG_DVB_USB_AF9015) += dvb-usb-af9015.o
-- 
1.7.11.2

