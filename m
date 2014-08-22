Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52332 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbaHVK63 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 06:58:29 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL FINAL 06/21] cxusb: add ts mode setting for TechnoTrend CT2-4400
Date: Fri, 22 Aug 2014 13:57:58 +0300
Message-Id: <1408705093-5167-7-git-send-email-crope@iki.fi>
In-Reply-To: <1408705093-5167-1-git-send-email-crope@iki.fi>
References: <1408705093-5167-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Olli Salonen <olli.salonen@iki.fi>

TS mode must be set in the existing TechnoTrend CT2-4400 driver.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb/cxusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 16bc579..87842e9 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1369,6 +1369,7 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
 	/* attach frontend */
 	si2168_config.i2c_adapter = &adapter;
 	si2168_config.fe = &adap->fe_adap[0].fe;
+	si2168_config.ts_mode = SI2168_TS_PARALLEL;
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
 	info.addr = 0x64;
-- 
http://palosaari.fi/

