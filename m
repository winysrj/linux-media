Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:38723 "EHLO
        homiemail-a123.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753337AbeAQVxK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 16:53:10 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 1/2] si2168: Add spectrum inversion property
Date: Wed, 17 Jan 2018 15:52:47 -0600
Message-Id: <1516225967-21668-1-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1516224756-1649-2-git-send-email-brad@nextdimension.cc>
References: <1516224756-1649-2-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some tuners produce inverted spectrum, but the si2168 is not
currently set up to accept it. This adds an optional parameter
to set the frontend up to receive inverted spectrum.

Parameter is optional and only boards who enable inversion
will utilize this.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v1:
- Embarassing build failure due to missing declaration.

 drivers/media/dvb-frontends/si2168.c | 3 +++
 drivers/media/dvb-frontends/si2168.h | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index c041e79..048b815 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -213,6 +213,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	struct i2c_client *client = fe->demodulator_priv;
 	struct si2168_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct si2168_config *config = client->dev.platform_data;
 	int ret;
 	struct si2168_cmd cmd;
 	u8 bandwidth, delivery_system;
@@ -339,6 +340,8 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 
 	memcpy(cmd.args, "\x14\x00\x0a\x10\x00\x00", 6);
 	cmd.args[4] = delivery_system | bandwidth;
+	if (config->spectral_inversion)
+		cmd.args[5] |= 1;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
 	ret = si2168_cmd_execute(client, &cmd);
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
-- 
2.7.4
