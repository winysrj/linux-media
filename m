Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47926 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab2IKBZx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 21:25:53 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] dvb_usb_v2: rename module dvb_usbv2 => dvb_usb_v2
Date: Tue, 11 Sep 2012 04:25:13 +0300
Message-Id: <1347326714-19514-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think it is better name. At that phase renaming is quite painless
as module is not yet merged to mainline Kernel.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/Makefile b/drivers/media/usb/dvb-usb-v2/Makefile
index 58027fd..b76f58e 100644
--- a/drivers/media/usb/dvb-usb-v2/Makefile
+++ b/drivers/media/usb/dvb-usb-v2/Makefile
@@ -1,5 +1,5 @@
-dvb_usbv2-objs := dvb_usb_core.o dvb_usb_urb.o usb_urb.o
-obj-$(CONFIG_DVB_USB_V2) += dvb_usbv2.o
+dvb_usb_v2-objs := dvb_usb_core.o dvb_usb_urb.o usb_urb.o
+obj-$(CONFIG_DVB_USB_V2) += dvb_usb_v2.o
 
 dvb_usb_cypress_firmware-objs := cypress_firmware.o
 obj-$(CONFIG_DVB_USB_CYPRESS_FIRMWARE) += dvb_usb_cypress_firmware.o
-- 
1.7.11.4

