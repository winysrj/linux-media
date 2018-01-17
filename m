Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:40119 "EHLO
        homiemail-a123.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753332AbeAQWdD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 17:33:03 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v3 1/2] si2168: Add spectrum inversion property
Date: Wed, 17 Jan 2018 16:31:58 -0600
Message-Id: <1516228318-4727-1-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1516225967-21668-1-git-send-email-brad@nextdimension.cc>
References: <1516225967-21668-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some tuners produce inverted spectrum, but the si2168 is not
currently set up to accept it. This adds an optional parameter
to set the frontend up to receive inverted spectrum.

Parameter is optional and only boards who enable inversion
will utilize this.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v2:
- platform_data is not safe outside of probe, move property to state

Changes since v1:
- Embarassing build failure due to missing declaration.

 drivers/media/dvb-frontends/si2168.c      | 3 +++
 drivers/media/dvb-frontends/si2168.h      | 3 +++
 drivers/media/dvb-frontends/si2168_priv.h | 1 +
 3 files changed, 7 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index c041e79..3306dc5 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -339,6 +339,8 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 
 	memcpy(cmd.args, "\x14\x00\x0a\x10\x00\x00", 6);
 	cmd.args[4] = delivery_system | bandwidth;
+	if (dev->spectral_inversion)
+		cmd.args[5] |= 1;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
 	ret = si2168_cmd_execute(client, &cmd);
@@ -799,6 +801,7 @@ static int si2168_probe(struct i2c_client *client,
 	dev->ts_mode = config->ts_mode;
 	dev->ts_clock_inv = config->ts_clock_inv;
 	dev->ts_clock_gapped = config->ts_clock_gapped;
+	dev->spectral_inversion = config->spectral_inversion;
 
 	dev_info(&client->dev, "Silicon Labs Si2168-%c%d%d successfully identified\n",
 		 dev->version >> 24 & 0xff, dev->version >> 16 & 0xff,
diff --git a/drivers/media/dvb-frontends/si2168.h b/drivers/media/dvb-frontends/si2168.h
index f48f0fb..d519edd 100644
--- a/drivers/media/dvb-frontends/si2168.h
+++ b/drivers/media/dvb-frontends/si2168.h
@@ -46,6 +46,9 @@ struct si2168_config {
 
 	/* TS clock gapped */
 	bool ts_clock_gapped;
+
+	/* Inverted spectrum */
+	bool spectral_inversion;
 };
 
 #endif
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index 3c8746a..2d362e1 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -48,6 +48,7 @@ struct si2168_dev {
 	u8 ts_mode;
 	bool ts_clock_inv;
 	bool ts_clock_gapped;
+	bool spectral_inversion;
 };
 
 /* firmware command struct */
-- 
2.7.4
