Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:3235 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2LQBGU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 20:06:20 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 1/2] tda10071: add tuner_i2c_addr to struct tda10071_config
Date: Sun, 16 Dec 2012 20:05:50 -0500
Message-Id: <1355706351-25551-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The default i2c address for the tuner is 0x14,
allow this to be overridden with a configuration parameter

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Reviewed-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c |    2 +-
 drivers/media/dvb-frontends/tda10071.h |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 16a4bc5..7103629 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -1064,7 +1064,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 		cmd.args[2] = 0x00;
 		cmd.args[3] = 0x00;
 		cmd.args[4] = 0x00;
-		cmd.args[5] = 0x14;
+		cmd.args[5] = (priv->cfg.tuner_i2c_addr) ? priv->cfg.tuner_i2c_addr : 0x14;
 		cmd.args[6] = 0x00;
 		cmd.args[7] = 0x03;
 		cmd.args[8] = 0x02;
diff --git a/drivers/media/dvb-frontends/tda10071.h b/drivers/media/dvb-frontends/tda10071.h
index 21163c4..a20d5c4 100644
--- a/drivers/media/dvb-frontends/tda10071.h
+++ b/drivers/media/dvb-frontends/tda10071.h
@@ -30,6 +30,12 @@ struct tda10071_config {
 	 */
 	u8 i2c_address;
 
+	/* Tuner I2C address.
+	 * Default: 0x14
+	 * Values: 0x14, 0x54, ...
+	 */
+	u8 tuner_i2c_addr;
+
 	/* Max bytes I2C provider can write at once.
 	 * Note: Buffer is taken from the stack currently!
 	 * Default: none, must set
-- 
1.7.10.4

