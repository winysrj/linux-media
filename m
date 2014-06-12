Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56134 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaFLXMa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 19:12:30 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9035: override tuner for AVerMedia A835B devices
Date: Fri, 13 Jun 2014 02:12:24 +0300
Message-Id: <1402614744-15723-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tuner ID set into EEPROM is wrong, which causes driver to select
wrong tuner profile. That leads device non-working. Fix issue by
overriding known bad tuner IDs with suitable default value.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 021e4d3..204a91a 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -773,6 +773,25 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		addr += 0x10; /* shift for the 2nd tuner params */
 	}
 
+	/*
+	 * These AVerMedia devices has a bad EEPROM content :-(
+	 * Override some wrong values here.
+	 */
+	if (le16_to_cpu(d->udev->descriptor.idVendor) == USB_VID_AVERMEDIA) {
+		switch (le16_to_cpu(d->udev->descriptor.idProduct)) {
+		case USB_PID_AVERMEDIA_A835B_1835:
+		case USB_PID_AVERMEDIA_A835B_2835:
+		case USB_PID_AVERMEDIA_A835B_3835:
+			dev_info(&d->udev->dev,
+				 "%s: overriding tuner from %02x to %02x\n",
+				 KBUILD_MODNAME, state->af9033_config[0].tuner,
+				 AF9033_TUNER_IT9135_60);
+
+			state->af9033_config[0].tuner = AF9033_TUNER_IT9135_60;
+			break;
+		}
+	}
+
 skip_eeprom:
 	/* get demod clock */
 	ret = af9035_rd_reg(d, 0x00d800, &tmp);
-- 
1.9.3

