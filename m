Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-out-1.rwth-aachen.de ([134.130.5.186]:49143 "EHLO
        mx-out-1.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751525AbdBOBvd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 20:51:33 -0500
From: =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
Subject: [PATCH v2 1/3] [media] si2157: Add support for Si2141-A10
Date: Wed, 15 Feb 2017 02:51:20 +0100
In-Reply-To: <20170215015122.4647-1-stefan.bruens@rwth-aachen.de>
References: <20170215015122.4647-1-stefan.bruens@rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <1edb96b52cd34f5f94b66f2cb05c629b@rwthex-w2-b.rwth-ad.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Si2141 needs two distinct commands for powerup/reset, otherwise it
will not respond to chip revision requests. It also needs a firmware
to run properly.

Signed-off-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>
---
 drivers/media/tuners/si2157.c      | 23 +++++++++++++++++++++--
 drivers/media/tuners/si2157_priv.h |  2 ++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 57b250847cd3..e35b1faf0ddc 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -106,6 +106,9 @@ static int si2157_init(struct dvb_frontend *fe)
 	if (dev->chiptype == SI2157_CHIPTYPE_SI2146) {
 		memcpy(cmd.args, "\xc0\x05\x01\x00\x00\x0b\x00\x00\x01", 9);
 		cmd.wlen = 9;
+	} else if (dev->chiptype == SI2157_CHIPTYPE_SI2141) {
+		memcpy(cmd.args, "\xc0\x00\x0d\x0e\x00\x01\x01\x01\x01\x03", 10);
+		cmd.wlen = 10;
 	} else {
 		memcpy(cmd.args, "\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01", 15);
 		cmd.wlen = 15;
@@ -115,6 +118,15 @@ static int si2157_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
+	/* Si2141 needs a second command before it answers the revision query */
+	if (dev->chiptype == SI2157_CHIPTYPE_SI2141) {
+		memcpy(cmd.args, "\xc0\x08\x01\x02\x00\x00\x01", 7);
+		cmd.wlen = 7;
+		ret = si2157_cmd_execute(client, &cmd);
+		if (ret)
+			goto err;
+	}
+
 	/* query chip revision */
 	memcpy(cmd.args, "\x02", 1);
 	cmd.wlen = 1;
@@ -131,12 +143,16 @@ static int si2157_init(struct dvb_frontend *fe)
 	#define SI2157_A30 ('A' << 24 | 57 << 16 | '3' << 8 | '0' << 0)
 	#define SI2147_A30 ('A' << 24 | 47 << 16 | '3' << 8 | '0' << 0)
 	#define SI2146_A10 ('A' << 24 | 46 << 16 | '1' << 8 | '0' << 0)
+	#define SI2141_A10 ('A' << 24 | 41 << 16 | '1' << 8 | '0' << 0)
 
 	switch (chip_id) {
 	case SI2158_A20:
 	case SI2148_A20:
 		fw_name = SI2158_A20_FIRMWARE;
 		break;
+	case SI2141_A10:
+		fw_name = SI2141_A10_FIRMWARE;
+		break;
 	case SI2157_A30:
 	case SI2147_A30:
 	case SI2146_A10:
@@ -371,7 +387,7 @@ static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static const struct dvb_tuner_ops si2157_ops = {
 	.info = {
-		.name           = "Silicon Labs Si2146/2147/2148/2157/2158",
+		.name           = "Silicon Labs Si2141/Si2146/2147/2148/2157/2158",
 		.frequency_min  = 42000000,
 		.frequency_max  = 870000000,
 	},
@@ -471,6 +487,7 @@ static int si2157_probe(struct i2c_client *client,
 #endif
 
 	dev_info(&client->dev, "Silicon Labs %s successfully attached\n",
+			dev->chiptype == SI2157_CHIPTYPE_SI2141 ?  "Si2141" :
 			dev->chiptype == SI2157_CHIPTYPE_SI2146 ?
 			"Si2146" : "Si2147/2148/2157/2158");
 
@@ -508,6 +525,7 @@ static int si2157_remove(struct i2c_client *client)
 static const struct i2c_device_id si2157_id_table[] = {
 	{"si2157", SI2157_CHIPTYPE_SI2157},
 	{"si2146", SI2157_CHIPTYPE_SI2146},
+	{"si2141", SI2157_CHIPTYPE_SI2141},
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, si2157_id_table);
@@ -524,7 +542,8 @@ static struct i2c_driver si2157_driver = {
 
 module_i2c_driver(si2157_driver);
 
-MODULE_DESCRIPTION("Silicon Labs Si2146/2147/2148/2157/2158 silicon tuner driver");
+MODULE_DESCRIPTION("Silicon Labs Si2141/Si2146/2147/2148/2157/2158 silicon tuner driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(SI2158_A20_FIRMWARE);
+MODULE_FIRMWARE(SI2141_A10_FIRMWARE);
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index d6b2c7b44053..e6436f74abaa 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -42,6 +42,7 @@ struct si2157_dev {
 
 #define SI2157_CHIPTYPE_SI2157 0
 #define SI2157_CHIPTYPE_SI2146 1
+#define SI2157_CHIPTYPE_SI2141 2
 
 /* firmware command struct */
 #define SI2157_ARGLEN      30
@@ -52,5 +53,6 @@ struct si2157_cmd {
 };
 
 #define SI2158_A20_FIRMWARE "dvb-tuner-si2158-a20-01.fw"
+#define SI2141_A10_FIRMWARE "dvb-tuner-si2141-a10-01.fw"
 
 #endif
-- 
2.11.0
