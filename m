Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39927 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756724AbaGNRJX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 13:09:23 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 15/18] si2168: advertise Si2168 A30 firmware
Date: Mon, 14 Jul 2014 20:08:56 +0300
Message-Id: <1405357739-3570-15-git-send-email-crope@iki.fi>
In-Reply-To: <1405357739-3570-1-git-send-email-crope@iki.fi>
References: <1405357739-3570-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver uses that new firmware too, so advertise it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Tested-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 268fce3..e9c138a 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -653,4 +653,5 @@ module_i2c_driver(si2168_driver);
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Silicon Labs Si2168 DVB-T/T2/C demodulator driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(SI2168_A30_FIRMWARE);
 MODULE_FIRMWARE(SI2168_B40_FIRMWARE);
-- 
1.9.3

