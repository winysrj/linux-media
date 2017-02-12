Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-out-1.rwth-aachen.de ([134.130.5.186]:29296 "EHLO
        mx-out-1.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbdBLP0t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 10:26:49 -0500
From: =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
Subject: [PATCH 2/3] [media] si2168: add support for Si2168-D60
Date: Sun, 12 Feb 2017 16:26:27 +0100
In-Reply-To: <20170212152628.25383-1-stefan.bruens@rwth-aachen.de>
References: <20170212152628.25383-1-stefan.bruens@rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <03602c258e664857911599bba1da19fe@rwthex-w2-b.rwth-ad.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add handling for new revision, requiring new firmware.

Signed-off-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>
---
 drivers/media/dvb-frontends/si2168.c      | 4 ++++
 drivers/media/dvb-frontends/si2168_priv.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 20b4a659e2e4..28f3bbe0af25 100644
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
@@ -761,3 +764,4 @@ MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(SI2168_A20_FIRMWARE);
 MODULE_FIRMWARE(SI2168_A30_FIRMWARE);
 MODULE_FIRMWARE(SI2168_B40_FIRMWARE);
+MODULE_FIRMWARE(SI2168_D60_FIRMWARE);
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index 7843ccb448a0..4baa95b7d648 100644
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
2.11.0
