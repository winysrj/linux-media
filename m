Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:52870 "EHLO smtp.220.in.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbcHDHzU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 03:55:20 -0400
From: Oleh Kravchenko <oleg@kaa.org.ua>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: Oleh Kravchenko <oleg@kaa.org.ua>
Subject: [PATCH] [media] si2157: Improve support Si2158-A20 tuner
Date: Thu,  4 Aug 2016 10:54:02 +0300
Message-Id: <1470297242-32129-1-git-send-email-oleg@kaa.org.ua>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
---
 drivers/media/tuners/si2157.c      | 34 +++++++++++++++++++++++++++-------
 drivers/media/tuners/si2157_priv.h |  1 +
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 57b2508..d7035a5 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -103,12 +103,21 @@ static int si2157_init(struct dvb_frontend *fe)
 		goto warm;
 
 	/* power up */
-	if (dev->chiptype == SI2157_CHIPTYPE_SI2146) {
-		memcpy(cmd.args, "\xc0\x05\x01\x00\x00\x0b\x00\x00\x01", 9);
-		cmd.wlen = 9;
-	} else {
-		memcpy(cmd.args, "\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01", 15);
-		cmd.wlen = 15;
+	switch (dev->chiptype) {
+		case SI2157_CHIPTYPE_SI2146:
+			memcpy(cmd.args, "\xc0\x05\x01\x00\x00\x0b\x00\x00\x01", 9);
+			cmd.wlen = 9;
+			break;
+
+		case SI2157_CHIPTYPE_SI2158:
+			memcpy(cmd.args, "\xC0\x00\x00\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01", 15);
+			cmd.wlen = 15;
+			break;
+
+		default:
+			memcpy(cmd.args, "\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01", 15);
+			cmd.wlen = 15;
+			break;
 	}
 	cmd.rlen = 1;
 	ret = si2157_cmd_execute(client, &cmd);
@@ -204,6 +213,16 @@ skip_fw_download:
 	if (ret)
 		goto err;
 
+	/* start tuner? */
+	if (SI2157_CHIPTYPE_SI2158 == dev->chiptype) {
+		memcpy(cmd.args, "\xC0\x00\x0C", 3);
+		cmd.wlen = 3;
+		cmd.rlen = 1;
+		ret = si2157_cmd_execute(client, &cmd);
+		if (ret)
+			goto err;
+	}
+
 	/* query firmware version */
 	memcpy(cmd.args, "\x11", 1);
 	cmd.wlen = 1;
@@ -506,8 +525,9 @@ static int si2157_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id si2157_id_table[] = {
-	{"si2157", SI2157_CHIPTYPE_SI2157},
 	{"si2146", SI2157_CHIPTYPE_SI2146},
+	{"si2157", SI2157_CHIPTYPE_SI2157},
+	{"si2158", SI2157_CHIPTYPE_SI2158},
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, si2157_id_table);
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index d6b2c7b..677fa00 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -42,6 +42,7 @@ struct si2157_dev {
 
 #define SI2157_CHIPTYPE_SI2157 0
 #define SI2157_CHIPTYPE_SI2146 1
+#define SI2157_CHIPTYPE_SI2158 2
 
 /* firmware command struct */
 #define SI2157_ARGLEN      30
-- 
2.7.3

