Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm3.telefonica.net ([213.4.138.19]:18481 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751579Ab3BJTnP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 14:43:15 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Cc: Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: [PATH] enable dual tuner to Avermedia Twinstar in af9035 driver
Date: Sun, 10 Feb 2013 20:43:03 +0100
Message-ID: <1633504.1ZgDSN6MAH@jar7.dominio>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enable dual tuner for Avermedia Twinstar.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
--- linux/drivers/media/usb/dvb-usb-v2/af9035.c	2013-01-07 05:45:57.000000000 +0100
+++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2013-02-10 20:27:26.880926695 +0100
@@ -602,6 +602,7 @@ static int af9035_read_config(struct dvb
 		if (i == 1)
 			switch (tmp) {
 			case AF9033_TUNER_FC0012:
+			case AF9033_TUNER_MXL5007T:
 				break;
 			default:
 				state->dual_mode = false;
 
