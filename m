Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33932 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbbECMy1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 May 2015 08:54:27 -0400
Received: by lbcga7 with SMTP id ga7so89569104lbc.1
        for <linux-media@vger.kernel.org>; Sun, 03 May 2015 05:54:25 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH v3 1/6] si2168: add support for gapped clock
Date: Sun,  3 May 2015 15:53:58 +0300
Message-Id: <1430657643-17454-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a parameter in si2168_config to support gapped clock. This might be necessary on
some devices with higher bitrates.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c      | 3 +++
 drivers/media/dvb-frontends/si2168.h      | 3 +++
 drivers/media/dvb-frontends/si2168_priv.h | 1 +
 3 files changed, 7 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 5db588e..29a5936 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -508,6 +508,8 @@ static int si2168_init(struct dvb_frontend *fe)
 	/* set ts mode */
 	memcpy(cmd.args, "\x14\x00\x01\x10\x10\x00", 6);
 	cmd.args[4] |= dev->ts_mode;
+	if (dev->ts_clock_gapped)
+		cmd.args[4] |= 0x40;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
 	ret = si2168_cmd_execute(client, &cmd);
@@ -688,6 +690,7 @@ static int si2168_probe(struct i2c_client *client,
 	*config->fe = &dev->fe;
 	dev->ts_mode = config->ts_mode;
 	dev->ts_clock_inv = config->ts_clock_inv;
+	dev->ts_clock_gapped = config->ts_clock_gapped;
 	dev->fw_loaded = false;
 
 	i2c_set_clientdata(client, dev);
diff --git a/drivers/media/dvb-frontends/si2168.h b/drivers/media/dvb-frontends/si2168.h
index 70d702a..3225d0c 100644
--- a/drivers/media/dvb-frontends/si2168.h
+++ b/drivers/media/dvb-frontends/si2168.h
@@ -42,6 +42,9 @@ struct si2168_config {
 
 	/* TS clock inverted */
 	bool ts_clock_inv;
+
+	/* TS clock gapped */
+	bool ts_clock_gapped;
 };
 
 #endif
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index d7efce8..d2589e3 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -38,6 +38,7 @@ struct si2168_dev {
 	bool fw_loaded;
 	u8 ts_mode;
 	bool ts_clock_inv;
+	bool ts_clock_gapped;
 };
 
 /* firmware command struct */
-- 
1.9.1

