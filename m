Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59395 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760189Ab2ILPh6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 11:37:58 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/5] tda10071: declare MODULE_FIRMWARE
Date: Wed, 12 Sep 2012 18:37:29 +0300
Message-Id: <1347464249-23728-5-git-send-email-crope@iki.fi>
In-Reply-To: <1347464249-23728-1-git-send-email-crope@iki.fi>
References: <1347464249-23728-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c      | 3 ++-
 drivers/media/dvb-frontends/tda10071_priv.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 703c3d0..806d1fe 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -850,7 +850,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 	struct tda10071_cmd cmd;
 	int ret, i, len, remaining, fw_size;
 	const struct firmware *fw;
-	u8 *fw_file = TDA10071_DEFAULT_FIRMWARE;
+	u8 *fw_file = TDA10071_FIRMWARE;
 	u8 tmp, buf[4];
 	struct tda10071_reg_val_mask tab[] = {
 		{ 0xcd, 0x00, 0x07 },
@@ -1282,3 +1282,4 @@ static struct dvb_frontend_ops tda10071_ops = {
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("NXP TDA10071 DVB-S/S2 demodulator driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(TDA10071_FIRMWARE);
diff --git a/drivers/media/dvb-frontends/tda10071_priv.h b/drivers/media/dvb-frontends/tda10071_priv.h
index 0fa85cf..4baf14b 100644
--- a/drivers/media/dvb-frontends/tda10071_priv.h
+++ b/drivers/media/dvb-frontends/tda10071_priv.h
@@ -77,7 +77,7 @@ struct tda10071_reg_val_mask {
 };
 
 /* firmware filename */
-#define TDA10071_DEFAULT_FIRMWARE      "dvb-fe-tda10071.fw"
+#define TDA10071_FIRMWARE "dvb-fe-tda10071.fw"
 
 /* firmware commands */
 #define CMD_DEMOD_INIT          0x10
-- 
1.7.11.4

