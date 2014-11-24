Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36498 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaKXHB0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 02:01:26 -0500
Received: by mail-lb0-f173.google.com with SMTP id z12so3895952lbi.4
        for <linux-media@vger.kernel.org>; Sun, 23 Nov 2014 23:01:25 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 4/4] si2157: Add support for Si2148-A20
Date: Mon, 24 Nov 2014 08:57:36 +0200
Message-Id: <1416812256-27894-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1416812256-27894-1-git-send-email-olli.salonen@iki.fi>
References: <1416812256-27894-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Silicon Labs Si2148 tuner works as the Si2158, but does not contain analog tuner. A firmware is required for the tuner. Currently the Si2158-A20 firmware will work for Si2148-A20 as well, but as there are no guarantees that that will be the case in future, a unique file name is used for the firmware.

The datasheet is available on manufacturer's website:
http://www.silabs.com/Support%20Documents/TechnicalDocs/Si2148-short.pdf

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/tuners/si2157.c      | 13 +++++++++----
 drivers/media/tuners/si2157.h      |  2 +-
 drivers/media/tuners/si2157_priv.h |  3 ++-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 3bdf00a..e6d7f35 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -1,5 +1,5 @@
 /*
- * Silicon Labs Si2146/2147/2157/2158 silicon tuner driver
+ * Silicon Labs Si2146/2147/2148/2157/2158 silicon tuner driver
  *
  * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
  *
@@ -118,6 +118,7 @@ static int si2157_init(struct dvb_frontend *fe)
 
 	#define SI2158_A20 ('A' << 24 | 58 << 16 | '2' << 8 | '0' << 0)
 	#define SI2157_A30 ('A' << 24 | 57 << 16 | '3' << 8 | '0' << 0)
+	#define SI2148_A20 ('A' << 24 | 48 << 16 | '2' << 8 | '0' << 0)
 	#define SI2147_A30 ('A' << 24 | 47 << 16 | '3' << 8 | '0' << 0)
 	#define SI2146_A10 ('A' << 24 | 46 << 16 | '1' << 8 | '0' << 0)
 
@@ -125,6 +126,9 @@ static int si2157_init(struct dvb_frontend *fe)
 	case SI2158_A20:
 		fw_file = SI2158_A20_FIRMWARE;
 		break;
+	case SI2148_A20:
+		fw_file = SI2148_A20_FIRMWARE;
+		break;
 	case SI2157_A30:
 	case SI2147_A30:
 	case SI2146_A10:
@@ -317,7 +321,7 @@ static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static const struct dvb_tuner_ops si2157_ops = {
 	.info = {
-		.name           = "Silicon Labs Si2146/2147/2157/2158",
+		.name           = "Silicon Labs Si2146/2147/2148/2157/2158",
 		.frequency_min  = 110000000,
 		.frequency_max  = 862000000,
 	},
@@ -367,7 +371,7 @@ static int si2157_probe(struct i2c_client *client,
 	dev_info(&s->client->dev,
 			"Silicon Labs %s successfully attached\n",
 			s->chiptype == SI2157_CHIPTYPE_SI2146 ?
-			"Si2146" : "Si2147/2157/2158");
+			"Si2146" : "Si2147/2148/2157/2158");
 
 	return 0;
 err:
@@ -410,7 +414,8 @@ static struct i2c_driver si2157_driver = {
 
 module_i2c_driver(si2157_driver);
 
-MODULE_DESCRIPTION("Silicon Labs Si2146/2147/2157/2158 silicon tuner driver");
+MODULE_DESCRIPTION("Silicon Labs Si2146/2147/2148/2157/2158 silicon tuner driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(SI2148_A20_FIRMWARE);
 MODULE_FIRMWARE(SI2158_A20_FIRMWARE);
diff --git a/drivers/media/tuners/si2157.h b/drivers/media/tuners/si2157.h
index 8467d08..a564c4a 100644
--- a/drivers/media/tuners/si2157.h
+++ b/drivers/media/tuners/si2157.h
@@ -1,5 +1,5 @@
 /*
- * Silicon Labs Si2146/2147/2157/2158 silicon tuner driver
+ * Silicon Labs Si2146/2147/2148/2157/2158 silicon tuner driver
  *
  * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
  *
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index c1ea821..65874e0 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -1,5 +1,5 @@
 /*
- * Silicon Labs Si2146/2147/2157/2158 silicon tuner driver
+ * Silicon Labs Si2146/2147/2148/2157/2158 silicon tuner driver
  *
  * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
  *
@@ -42,6 +42,7 @@ struct si2157_cmd {
 	unsigned rlen;
 };
 
+#define SI2148_A20_FIRMWARE "dvb-tuner-si2148-a20-01.fw"
 #define SI2158_A20_FIRMWARE "dvb-tuner-si2158-a20-01.fw"
 
 #endif
-- 
1.9.1

