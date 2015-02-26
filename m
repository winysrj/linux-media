Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:28083 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbbBZKVM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 05:21:12 -0500
From: Yannick Guerrini <yguerrini@tomshardware.fr>
To: crope@iki.fi
Cc: mchehab@osg.samsung.com, trivial@kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yannick Guerrini <yguerrini@tomshardware.fr>
Subject: [PATCH] si2168: tda10071: m88ds3103: Fix trivial typos
Date: Thu, 26 Feb 2015 11:13:06 +0100
Message-Id: <1424945586-8232-1-git-send-email-yguerrini@tomshardware.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change 'firmare' to 'firmware'

Signed-off-by: Yannick Guerrini <yguerrini@tomshardware.fr>
---
 drivers/media/dvb-frontends/m88ds3103.c     | 2 +-
 drivers/media/dvb-frontends/si2168_priv.h   | 2 +-
 drivers/media/dvb-frontends/tda10071_priv.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index ba4ee0b..d3d928e 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -630,7 +630,7 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 	/* request the firmware, this will block and timeout */
 	ret = request_firmware(&fw, fw_file, priv->i2c->dev.parent);
 	if (ret) {
-		dev_err(&priv->i2c->dev, "%s: firmare file '%s' not found\n",
+		dev_err(&priv->i2c->dev, "%s: firmware file '%s' not found\n",
 				KBUILD_MODNAME, fw_file);
 		goto err;
 	}
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index aadd136..d7efce8 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -40,7 +40,7 @@ struct si2168_dev {
 	bool ts_clock_inv;
 };
 
-/* firmare command struct */
+/* firmware command struct */
 #define SI2168_ARGLEN      30
 struct si2168_cmd {
 	u8 args[SI2168_ARGLEN];
diff --git a/drivers/media/dvb-frontends/tda10071_priv.h b/drivers/media/dvb-frontends/tda10071_priv.h
index 4204861..03f839c 100644
--- a/drivers/media/dvb-frontends/tda10071_priv.h
+++ b/drivers/media/dvb-frontends/tda10071_priv.h
@@ -99,7 +99,7 @@ struct tda10071_reg_val_mask {
 #define CMD_BER_CONTROL         0x3e
 #define CMD_BER_UPDATE_COUNTERS 0x3f
 
-/* firmare command struct */
+/* firmware command struct */
 #define TDA10071_ARGLEN      30
 struct tda10071_cmd {
 	u8 args[TDA10071_ARGLEN];
-- 
1.9.5.msysgit.0

