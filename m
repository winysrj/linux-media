Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:58134 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbcCWKbL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 06:31:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Arnd Bergmann <arnd@arndb.de>
Cc: Patrick Boettcher <patrick.boettcher@posteo.de>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] dvb-usb: hide unused functions
Date: Wed, 23 Mar 2016 11:30:38 +0100
Message-Id: <1458729052-3008797-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A couple of data structures in the dibusb-common file are only
accessed when CONFIG_DVB_DIB3000MC is enabled, otherwise we
get a harmless gcc warning:

usb/dvb-usb/dibusb-common.c:223:34: error: 'dib3000p_panasonic_agc_config' defined but not used
usb/dvb-usb/dibusb-common.c:211:32: error: 'stk3000p_dib3000p_config' defined but not used

This moves the existing #ifdef a few lines up to correctly cover
all the conditional data structures, which gets rid of the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/dvb-usb/dibusb-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index 35de6095926d..6eea4e68891d 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -184,6 +184,8 @@ int dibusb_read_eeprom_byte(struct dvb_usb_device *d, u8 offs, u8 *val)
 }
 EXPORT_SYMBOL(dibusb_read_eeprom_byte);
 
+#if IS_ENABLED(CONFIG_DVB_DIB3000MC)
+
 /* 3000MC/P stuff */
 // Config Adjacent channels  Perf -cal22
 static struct dibx000_agc_config dib3000p_mt2060_agc_config = {
@@ -242,8 +244,6 @@ static struct dibx000_agc_config dib3000p_panasonic_agc_config = {
 	.agc2_slope2 = 0x1e,
 };
 
-#if IS_ENABLED(CONFIG_DVB_DIB3000MC)
-
 static struct dib3000mc_config mod3000p_dib3000p_config = {
 	&dib3000p_panasonic_agc_config,
 
-- 
2.7.0

