Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55773 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbaFMWlo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 18:41:44 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] si2168: firmware download fix
Date: Sat, 14 Jun 2014 01:41:27 +0300
Message-Id: <1402699287-21615-3-git-send-email-crope@iki.fi>
In-Reply-To: <1402699287-21615-1-git-send-email-crope@iki.fi>
References: <1402699287-21615-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

First 8 bytes belonging to firmware image were hard-coded and uploaded
by the driver mistakenly. Introduce new corrected firmware file and
remove those 8 bytes from the driver.

New firmware image could be extracted from the PCTV 292e driver CD
using following command:

$ dd if=/TVC 6.4.8/Driver/PCTV Empia/emOEM.sys ibs=1 skip=1089408 count=2728 of=dvb-demod-si2168-02.fw
$ md5sum dvb-demod-si2168-02.fw
d8da7ff67cd56cd8aa4e101aea45e052  dvb-demod-si2168-02.fw
$ sudo cp dvb-demod-si2168-02.fw /lib/firmware/

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c      | 14 --------------
 drivers/media/dvb-frontends/si2168_priv.h |  2 +-
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index f205736..2e3cdcf 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -485,20 +485,6 @@ static int si2168_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	cmd.args[0] = 0x05;
-	cmd.args[1] = 0x00;
-	cmd.args[2] = 0xaa;
-	cmd.args[3] = 0x4d;
-	cmd.args[4] = 0x56;
-	cmd.args[5] = 0x40;
-	cmd.args[6] = 0x00;
-	cmd.args[7] = 0x00;
-	cmd.wlen = 8;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
 	/* cold state - try to download firmware */
 	dev_info(&s->client->dev, "%s: found a '%s' in cold state\n",
 			KBUILD_MODNAME, si2168_ops.info.name);
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index 2a343e8..53f7f06 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -22,7 +22,7 @@
 #include <linux/firmware.h>
 #include <linux/i2c-mux.h>
 
-#define SI2168_FIRMWARE "dvb-demod-si2168-01.fw"
+#define SI2168_FIRMWARE "dvb-demod-si2168-02.fw"
 
 /* state struct */
 struct si2168 {
-- 
1.9.3

