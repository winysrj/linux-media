Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward8l.mail.yandex.net ([84.201.143.141]:48798 "EHLO
	forward8l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbaKNV3g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 16:29:36 -0500
Received: from smtp1m.mail.yandex.net (smtp1m.mail.yandex.net [77.88.61.132])
	by forward8l.mail.yandex.net (Yandex) with ESMTP id 598E31A41270
	for <linux-media@vger.kernel.org>; Sat, 15 Nov 2014 00:22:14 +0300 (MSK)
Received: from smtp1m.mail.yandex.net (localhost [127.0.0.1])
	by smtp1m.mail.yandex.net (Yandex) with ESMTP id F0BB267401E4
	for <linux-media@vger.kernel.org>; Sat, 15 Nov 2014 00:22:13 +0300 (MSK)
From: CrazyCat <crazycat69@narod.ru>
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] si2168: TS clock inversion control.
Date: Fri, 14 Nov 2014 23:22:10 +0200
Message-ID: <2586479.jPeNbxzlMS@computer>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TS clock polarity control implemented.

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
---
 drivers/media/dvb-frontends/si2168.c      | 7 +++++--
 drivers/media/dvb-frontends/si2168.h      | 4 ++++
 drivers/media/dvb-frontends/si2168_priv.h | 1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 7bac748..16a347a 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -308,14 +308,16 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	memcpy(cmd.args, "\x14\x00\x09\x10\xe3\x18", 6);
+	memcpy(cmd.args, "\x14\x00\x09\x10\xe3\x08", 6);
+	cmd.args[5] |= s->ts_clock_inv ? 0x00 : 0x10;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
 	ret = si2168_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
 
-	memcpy(cmd.args, "\x14\x00\x08\x10\xd7\x15", 6);
+	memcpy(cmd.args, "\x14\x00\x08\x10\xd7\x05", 6);
+	cmd.args[5] |= s->ts_clock_inv ? 0x00 : 0x10;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
 	ret = si2168_cmd_execute(s, &cmd);
@@ -669,6 +671,7 @@ static int si2168_probe(struct i2c_client *client,
 	*config->i2c_adapter = s->adapter;
 	*config->fe = &s->fe;
 	s->ts_mode = config->ts_mode;
+	s->ts_clock_inv = config->ts_clock_inv;
 	s->fw_loaded = false;
 
 	i2c_set_clientdata(client, s);
diff --git a/drivers/media/dvb-frontends/si2168.h b/drivers/media/dvb-frontends/si2168.h
index e086d67..87bc121 100644
--- a/drivers/media/dvb-frontends/si2168.h
+++ b/drivers/media/dvb-frontends/si2168.h
@@ -37,6 +37,10 @@ struct si2168_config {
 
 	/* TS mode */
 	u8 ts_mode;
+
+	/* TS clock inverted */
+	bool ts_clock_inv;
+
 };
 
 #define SI2168_TS_PARALLEL	0x06
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index 132df67..66ed675 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -36,6 +36,7 @@ struct si2168 {
 	fe_delivery_system_t delivery_system;
 	fe_status_t fe_status;
 	u8 ts_mode;
+	bool ts_clock_inv;
 	bool active;
 	bool fw_loaded;
 };
-- 
1.9.1


