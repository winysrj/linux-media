Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.domdv.de ([193.102.202.1]:2944 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbaCZUjX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 16:39:23 -0400
Message-ID: <1395865977.23074.62.camel@host028-server-9.lan.domdv.de>
Subject: [PATCH 3/3] TBS USB drivers (DVB-S/S2) - enable driver lock led code
From: Andreas Steinmetz <ast@domdv.de>
To: linux-media@vger.kernel.org
Date: Wed, 26 Mar 2014 21:32:57 +0100
Content-Type: multipart/mixed; boundary="=-PZ2Bpi8hRF84F6DjJmnw"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-PZ2Bpi8hRF84F6DjJmnw
Content-Type: text/plain; charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit

[Please CC me on replies, I'm not subscribed]

The lock led code being enabled is based on GPLv2 code taken from:

https://bitbucket.org/CrazyCat/linux-tbs-drivers/

Just having to look at a device to get a visual lock notification by a
led is a nice feature.
-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de

--=-PZ2Bpi8hRF84F6DjJmnw
Content-Disposition: attachment; filename="enable-tbs-lockled.patch"
Content-Type: text/x-patch; name="enable-tbs-lockled.patch"; charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit

Signed-off-by: Andreas Steinmetz <ast@domdv.de>

diff -rNup v4l-dvb.orig/drivers/media/usb/dvb-usb/tbs-usb.c v4l-dvb/drivers/media/usb/dvb-usb/tbs-usb.c
--- v4l-dvb.orig/drivers/media/usb/dvb-usb/tbs-usb.c	2014-03-26 19:29:25.981009433 +0100
+++ v4l-dvb/drivers/media/usb/dvb-usb/tbs-usb.c	2014-03-26 19:34:39.864065854 +0100
@@ -348,8 +348,6 @@ static int tbsusb_set_voltage(struct dvb
 			voltage == SEC_VOLTAGE_18 ? command_18v : command_13v);
 }
 
-#ifdef TBS_LOCKLED
-
 static void tbsusb_led_ctrl(struct dvb_frontend *fe, int onoff)
 {
 	static u8 led_off[2] = {0x05, 0x00};
@@ -358,8 +356,6 @@ static void tbsusb_led_ctrl(struct dvb_f
 	tbsusb_set_pin(fe, onoff ? led_on : led_off);
 }
 
-#endif
-
 static int tbsusb_i2c_transfer(struct i2c_adapter *adap,
 					struct i2c_msg msg[], int num)
 {
@@ -766,9 +762,7 @@ static const struct stv090x_config stv09
 	.tuner_set_bandwidth    = stb6100_set_bandwidth,
 	.tuner_get_bandwidth    = stb6100_get_bandwidth,
 
-#ifdef TBS_LOCKLED
 	.set_lock_led		= tbsusb_led_ctrl,
-#endif
 };
 
 static const struct stv090x_config stv0900_config = {
@@ -790,9 +784,7 @@ static const struct stv090x_config stv09
 	.tuner_set_bandwidth    = stb6100_set_bandwidth,
 	.tuner_get_bandwidth    = stb6100_get_bandwidth,
 
-#ifdef TBS_LOCKLED
 	.set_lock_led		= tbsusb_led_ctrl,
-#endif
 };
 
 static const struct tda10071_config tda10071_config = {
@@ -803,24 +795,18 @@ static const struct tda10071_config tda1
 	.spec_inv       = 0,
 	.xtal           = 40444000, /* 40.444 MHz */
 	.pll_multiplier = 20,
-#ifdef TBS_LOCKLED
 	.set_lock_led   = tbsusb_led_ctrl,
-#endif
 };
 
 static const struct cx24116_config cx24116_config = {
 	.demod_address   = 0x55,
 	.mpg_clk_pos_pol = 0x01,
-#ifdef TBS_LOCKLED
 	.set_lock_led    = tbsusb_led_ctrl,
-#endif
 };
 
 static const struct stv0288_config stv0288_config = {
 	.demod_address = 0x68,
-#ifdef TBS_LOCKLED
 	.set_lock_led  = tbsusb_led_ctrl,
-#endif
 };
 
 static int tbsusb_frontend_attach(struct dvb_usb_adapter *d)

--=-PZ2Bpi8hRF84F6DjJmnw--

