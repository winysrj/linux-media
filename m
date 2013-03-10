Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36194 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab3CJCEi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:38 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 05/41] af9035: fix af9033 demod sampling frequency
Date: Sun, 10 Mar 2013 04:02:57 +0200
Message-Id: <1362881013-5271-5-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ADC needs to be also multiplied to 2 as it9135.
Fixes bug I introduced few commits ago.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 7fdc9ed..cc05f59 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -589,6 +589,7 @@ static int af9035_read_config_af9035(struct dvb_usb_device *d)
 
 	/* demod I2C "address" */
 	state->af9033_config[0].i2c_addr = 0x38;
+	state->af9033_config[0].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
 
 	/* check if there is dual tuners */
 	ret = af9035_rd_reg(d, EEPROM_DUAL_MODE, &tmp);
-- 
1.7.11.7

