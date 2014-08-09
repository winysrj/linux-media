Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45594 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbaHIU1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 16:27:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/14] af9035: remove AVerMedia eeprom override
Date: Sat,  9 Aug 2014 23:27:09 +0300
Message-Id: <1407616032-2722-12-git-send-email-crope@iki.fi>
In-Reply-To: <1407616032-2722-1-git-send-email-crope@iki.fi>
References: <1407616032-2722-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reverts commit 3ab25123373270152a9fae98e3c48ef1b2a878c0
[media] af9035: override tuner for AVerMedia A835B devices

Original commit itself is correct, but it was replaced by more
general solution (commit 1cbbf90d0406913ad4b44194b07f4f41bde84e54).
This old solution was committed by a accident and is not needed
anymore.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 8ac0423..85f2c4b 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -802,25 +802,6 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		addr += 0x10; /* shift for the 2nd tuner params */
 	}
 
-	/*
-	 * These AVerMedia devices has a bad EEPROM content :-(
-	 * Override some wrong values here.
-	 */
-	if (le16_to_cpu(d->udev->descriptor.idVendor) == USB_VID_AVERMEDIA) {
-		switch (le16_to_cpu(d->udev->descriptor.idProduct)) {
-		case USB_PID_AVERMEDIA_A835B_1835:
-		case USB_PID_AVERMEDIA_A835B_2835:
-		case USB_PID_AVERMEDIA_A835B_3835:
-			dev_info(&d->udev->dev,
-				 "%s: overriding tuner from %02x to %02x\n",
-				 KBUILD_MODNAME, state->af9033_config[0].tuner,
-				 AF9033_TUNER_IT9135_60);
-
-			state->af9033_config[0].tuner = AF9033_TUNER_IT9135_60;
-			break;
-		}
-	}
-
 skip_eeprom:
 	/* get demod clock */
 	ret = af9035_rd_reg(d, 0x00d800, &tmp);
-- 
http://palosaari.fi/

