Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward20p.cmail.yandex.net ([77.88.31.15]:43502 "EHLO
        forward20p.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932334AbdBGVj5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 16:39:57 -0500
Received: from smtp1p.mail.yandex.net (smtp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:6])
        by forward20p.cmail.yandex.net (Yandex) with ESMTP id D443721EFB
        for <linux-media@vger.kernel.org>; Wed,  8 Feb 2017 00:33:54 +0300 (MSK)
Received: from smtp1p.mail.yandex.net (localhost.localdomain [127.0.0.1])
        by smtp1p.mail.yandex.net (Yandex) with ESMTP id B49FE1780884
        for <linux-media@vger.kernel.org>; Wed,  8 Feb 2017 00:33:54 +0300 (MSK)
From: CrazyCat <crazycat69@narod.ru>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] si2168: Si2168-D60 support.
Date: Tue, 07 Feb 2017 23:33:47 +0200
Message-ID: <2400472.5jOdR5GxAm@computer>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for new demod version.

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
---
 drivers/media/dvb-frontends/si2168.c      | 4 ++++
 drivers/media/dvb-frontends/si2168_priv.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 680ba06..172fc36 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -740,6 +740,9 @@ static int si2168_probe(struct i2c_client *client,
 	case SI2168_CHIP_ID_B40:
 		dev->firmware_name = SI2168_B40_FIRMWARE;
 		break;
+	case SI2168_CHIP_ID_D60:
+		dev->firmware_name = SI2168_D60_FIRMWARE;
+		break;
 	default:
 		dev_dbg(&client->dev, "unknown chip version Si21%d-%c%c%c\n",
 			cmd.args[2], cmd.args[1], cmd.args[3], cmd.args[4]);
@@ -827,3 +830,4 @@ static int si2168_remove(struct i2c_client *client)
 MODULE_FIRMWARE(SI2168_A20_FIRMWARE);
 MODULE_FIRMWARE(SI2168_A30_FIRMWARE);
 MODULE_FIRMWARE(SI2168_B40_FIRMWARE);
+MODULE_FIRMWARE(SI2168_D60_FIRMWARE);
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index 2fecac6..737cf41 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -26,6 +26,7 @@
 #define SI2168_A20_FIRMWARE "dvb-demod-si2168-a20-01.fw"
 #define SI2168_A30_FIRMWARE "dvb-demod-si2168-a30-01.fw"
 #define SI2168_B40_FIRMWARE "dvb-demod-si2168-b40-01.fw"
+#define SI2168_D60_FIRMWARE "dvb-demod-si2168-d60-01.fw"
 #define SI2168_B40_FIRMWARE_FALLBACK "dvb-demod-si2168-02.fw"
 
 /* state struct */
@@ -38,6 +39,7 @@ struct si2168_dev {
 	#define SI2168_CHIP_ID_A20 ('A' << 24 | 68 << 16 | '2' << 8 | '0' << 0)
 	#define SI2168_CHIP_ID_A30 ('A' << 24 | 68 << 16 | '3' << 8 | '0' << 0)
 	#define SI2168_CHIP_ID_B40 ('B' << 24 | 68 << 16 | '4' << 8 | '0' << 0)
+	#define SI2168_CHIP_ID_D60 ('D' << 24 | 68 << 16 | '6' << 8 | '0' << 0)
 	unsigned int chip_id;
 	unsigned int version;
 	const char *firmware_name;
-- 
1.9.1


