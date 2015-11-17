Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:54546 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbbKQQS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 11:18:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] [MEDIA] dvb: usb: fix dib3000mc dependencies
Date: Tue, 17 Nov 2015 17:17:39 +0100
Message-ID: <3984729.n55BH9Zr8c@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dibusb_read_eeprom_byte function is defined in dibusb-common.c,
but that file is not compiled for CONFIG_DVB_USB_DIBUSB_MB as it
is for the other driver using the common functions, so we can
get a link error:

drivers/built-in.o: In function `dibusb_dib3000mc_tuner_attach':
(.text+0x2c5124): undefined reference to `dibusb_read_eeprom_byte'
(.text+0x2c5134): undefined reference to `dibusb_read_eeprom_byte'

This changes the Makefile to treat the file like all the others
in this directory, and enforce building dvb-usb-dibusb-common.o
as a dependency.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/media/usb/dvb-usb/Makefile b/drivers/media/usb/dvb-usb/Makefile
index 8da26352f73b..048ab0b6c36d 100644
--- a/drivers/media/usb/dvb-usb/Makefile
+++ b/drivers/media/usb/dvb-usb/Makefile
@@ -17,7 +17,7 @@ obj-$(CONFIG_DVB_USB_DTT200U) += dvb-usb-dtt200u.o
 dvb-usb-dibusb-common-objs := dibusb-common.o
 
 dvb-usb-dibusb-mc-common-objs := dibusb-mc-common.o
-obj-$(CONFIG_DVB_USB_DIB3000MC)	+= dvb-usb-dibusb-mc-common.o
+obj-$(CONFIG_DVB_USB_DIB3000MC)	+= dvb-usb-dibusb-common.o dvb-usb-dibusb-mc-common.o
 
 dvb-usb-a800-objs := a800.o
 obj-$(CONFIG_DVB_USB_A800) += dvb-usb-dibusb-common.o dvb-usb-a800.o

