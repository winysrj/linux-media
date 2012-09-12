Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42432 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760195Ab2ILPh5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 11:37:57 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/5] af9013: declare MODULE_FIRMWARE
Date: Wed, 12 Sep 2012 18:37:28 +0300
Message-Id: <1347464249-23728-4-git-send-email-crope@iki.fi>
In-Reply-To: <1347464249-23728-1-git-send-email-crope@iki.fi>
References: <1347464249-23728-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c      | 3 ++-
 drivers/media/dvb-frontends/af9013_priv.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 2dac314..b30ca2d 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -1332,7 +1332,7 @@ static int af9013_download_firmware(struct af9013_state *state)
 	u16 checksum = 0;
 	u8 val;
 	u8 fw_params[4];
-	u8 *fw_file = AF9013_DEFAULT_FIRMWARE;
+	u8 *fw_file = AF9013_FIRMWARE;
 
 	msleep(100);
 	/* check whether firmware is already running */
@@ -1524,3 +1524,4 @@ static struct dvb_frontend_ops af9013_ops = {
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Afatech AF9013 DVB-T demodulator driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(AF9013_FIRMWARE);
diff --git a/drivers/media/dvb-frontends/af9013_priv.h b/drivers/media/dvb-frontends/af9013_priv.h
index fa848af..04ee6ce 100644
--- a/drivers/media/dvb-frontends/af9013_priv.h
+++ b/drivers/media/dvb-frontends/af9013_priv.h
@@ -42,7 +42,7 @@
 #undef warn
 #define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
 
-#define AF9013_DEFAULT_FIRMWARE     "dvb-fe-af9013.fw"
+#define AF9013_FIRMWARE "dvb-fe-af9013.fw"
 
 struct af9013_reg_bit {
 	u16 addr;
-- 
1.7.11.4

