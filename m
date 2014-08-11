Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.193]:56418 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219AbaHKT62 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 15:58:28 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: olli@cabbala.net
Cc: Olli Salonen <olli.salonen@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/6] cxusb: add ts mode setting for TechnoTrend CT2-4400
Date: Mon, 11 Aug 2014 22:58:12 +0300
Message-Id: <1407787095-2167-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi>
References: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TS mode must be set in the existing TechnoTrend CT2-4400 driver.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
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
1.9.1

