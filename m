Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37262 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760135AbaGSCis (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 22:38:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Luis Alves <ljalvs@gmail.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/10] si2168: Support Si2168-A20 firmware downloading.
Date: Sat, 19 Jul 2014 05:38:21 +0300
Message-Id: <1405737506-13186-5-git-send-email-crope@iki.fi>
In-Reply-To: <1405737506-13186-1-git-send-email-crope@iki.fi>
References: <1405737506-13186-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Luis Alves <ljalvs@gmail.com>

This adds support for the Si2168-A20 firmware download.

Extracting the firmware:

wget http://www.tbsdtv.com/download/document/tbs6281/tbs6281-t2-t-driver_v1.0.0.6.zip
unzip tbs6281-t2-t-driver_v1.0.0.6.zip
dd if=tbs-6281_x64/tbs6281_64.sys of=dvb-demod-si2168-a20-01.fw count=28656 bs=1 skip=1625088

md5sum:
32e06713b33915f674bfb2c209beaea5 /lib/firmware/dvb-demod-si2168-a20-01.fw

Signed-off-by: Luis Alves <ljalvs@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c      | 5 +++++
 drivers/media/dvb-frontends/si2168_priv.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 9925a12..8f81d97 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -384,10 +384,14 @@ static int si2168_init(struct dvb_frontend *fe)
 	chip_id = cmd.args[1] << 24 | cmd.args[2] << 16 | cmd.args[3] << 8 |
 			cmd.args[4] << 0;
 
+	#define SI2168_A20 ('A' << 24 | 68 << 16 | '2' << 8 | '0' << 0)
 	#define SI2168_A30 ('A' << 24 | 68 << 16 | '3' << 8 | '0' << 0)
 	#define SI2168_B40 ('B' << 24 | 68 << 16 | '4' << 8 | '0' << 0)
 
 	switch (chip_id) {
+	case SI2168_A20:
+		fw_file = SI2168_A20_FIRMWARE;
+		break;
 	case SI2168_A30:
 		fw_file = SI2168_A30_FIRMWARE;
 		break;
@@ -679,5 +683,6 @@ module_i2c_driver(si2168_driver);
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Silicon Labs Si2168 DVB-T/T2/C demodulator driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(SI2168_A20_FIRMWARE);
 MODULE_FIRMWARE(SI2168_A30_FIRMWARE);
 MODULE_FIRMWARE(SI2168_B40_FIRMWARE);
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index bebb68a..ebbf502 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -22,6 +22,7 @@
 #include <linux/firmware.h>
 #include <linux/i2c-mux.h>
 
+#define SI2168_A20_FIRMWARE "dvb-demod-si2168-a20-01.fw"
 #define SI2168_A30_FIRMWARE "dvb-demod-si2168-a30-01.fw"
 #define SI2168_B40_FIRMWARE "dvb-demod-si2168-b40-01.fw"
 #define SI2168_B40_FIRMWARE_FALLBACK "dvb-demod-si2168-02.fw"
-- 
1.9.3

