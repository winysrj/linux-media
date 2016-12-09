Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward19h.cmail.yandex.net ([87.250.230.161]:49090 "EHLO
        forward19h.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753052AbcLIAZt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 19:25:49 -0500
Received: from smtp3o.mail.yandex.net (smtp3o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::27])
        by forward19h.cmail.yandex.net (Yandex) with ESMTP id 53ABB220B9
        for <linux-media@vger.kernel.org>; Fri,  9 Dec 2016 03:18:05 +0300 (MSK)
Received: from smtp3o.mail.yandex.net (localhost.localdomain [127.0.0.1])
        by smtp3o.mail.yandex.net (Yandex) with ESMTP id 2E5A52940D7C
        for <linux-media@vger.kernel.org>; Fri,  9 Dec 2016 03:18:04 +0300 (MSK)
From: CrazyCat <crazycat69@narod.ru>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] si2168: Si2168-D60 support.
Date: Fri, 09 Dec 2016 02:17:58 +0200
Message-ID: <3148066.V8NoLtYRlU@computer>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for new demod version.

Signed-off-by: CrazyCat <crazycat69@narod.ru>
---
 drivers/media/dvb-frontends/si2168.c      | 4 ++++
 drivers/media/dvb-frontends/si2168_priv.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 20b4a65..28f3bbe 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -674,6 +674,9 @@ static int si2168_probe(struct i2c_client *client,
 	case SI2168_CHIP_ID_B40:
 		dev->firmware_name = SI2168_B40_FIRMWARE;
 		break;
+	case SI2168_CHIP_ID_D60:
+		dev->firmware_name = SI2168_D60_FIRMWARE;
+		break;
 	default:
 		dev_dbg(&client->dev, "unknown chip version Si21%d-%c%c%c\n",
 			cmd.args[2], cmd.args[1], cmd.args[3], cmd.args[4]);
@@ -761,3 +764,4 @@ static int si2168_remove(struct i2c_client *client)
 MODULE_FIRMWARE(SI2168_A20_FIRMWARE);
 MODULE_FIRMWARE(SI2168_A30_FIRMWARE);
 MODULE_FIRMWARE(SI2168_B40_FIRMWARE);
+MODULE_FIRMWARE(SI2168_D60_FIRMWARE);
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index 7843ccb..4baa95b 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -25,6 +25,7 @@
 #define SI2168_A20_FIRMWARE "dvb-demod-si2168-a20-01.fw"
 #define SI2168_A30_FIRMWARE "dvb-demod-si2168-a30-01.fw"
 #define SI2168_B40_FIRMWARE "dvb-demod-si2168-b40-01.fw"
+#define SI2168_D60_FIRMWARE "dvb-demod-si2168-d60-01.fw"
 #define SI2168_B40_FIRMWARE_FALLBACK "dvb-demod-si2168-02.fw"
 
 /* state struct */
@@ -37,6 +38,7 @@ struct si2168_dev {
 	#define SI2168_CHIP_ID_A20 ('A' << 24 | 68 << 16 | '2' << 8 | '0' << 0)
 	#define SI2168_CHIP_ID_A30 ('A' << 24 | 68 << 16 | '3' << 8 | '0' << 0)
 	#define SI2168_CHIP_ID_B40 ('B' << 24 | 68 << 16 | '4' << 8 | '0' << 0)
+	#define SI2168_CHIP_ID_D60 ('D' << 24 | 68 << 16 | '6' << 8 | '0' << 0)
 	unsigned int chip_id;
 	unsigned int version;
 	const char *firmware_name;
-- 
1.9.1


