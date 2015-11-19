Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54333 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934033AbbKSUEs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 15:04:48 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 01/10] si2165: rename frontend -> fe
Date: Thu, 19 Nov 2015 21:03:53 +0100
Message-Id: <1447963442-9764-2-git-send-email-zzam@gentoo.org>
In-Reply-To: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
References: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index c5d7c0d..d36b36c 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -42,7 +42,7 @@
 struct si2165_state {
 	struct i2c_adapter *i2c;
 
-	struct dvb_frontend frontend;
+	struct dvb_frontend fe;
 
 	struct si2165_config config;
 
@@ -988,9 +988,9 @@ struct dvb_frontend *si2165_attach(const struct si2165_config *config,
 	}
 
 	/* create dvb_frontend */
-	memcpy(&state->frontend.ops, &si2165_ops,
+	memcpy(&state->fe.ops, &si2165_ops,
 		sizeof(struct dvb_frontend_ops));
-	state->frontend.demodulator_priv = state;
+	state->fe.demodulator_priv = state;
 
 	/* powerup */
 	io_ret = si2165_writereg8(state, 0x0000, state->config.chip_mode);
@@ -1042,20 +1042,20 @@ struct dvb_frontend *si2165_attach(const struct si2165_config *config,
 		KBUILD_MODNAME, chip_name, rev_char, state->chip_type,
 		state->chip_revcode);
 
-	strlcat(state->frontend.ops.info.name, chip_name,
-			sizeof(state->frontend.ops.info.name));
+	strlcat(state->fe.ops.info.name, chip_name,
+			sizeof(state->fe.ops.info.name));
 
 	n = 0;
 	if (state->has_dvbt) {
-		state->frontend.ops.delsys[n++] = SYS_DVBT;
-		strlcat(state->frontend.ops.info.name, " DVB-T",
-			sizeof(state->frontend.ops.info.name));
+		state->fe.ops.delsys[n++] = SYS_DVBT;
+		strlcat(state->fe.ops.info.name, " DVB-T",
+			sizeof(state->fe.ops.info.name));
 	}
 	if (state->has_dvbc)
 		dev_warn(&state->i2c->dev, "%s: DVB-C is not yet supported.\n",
 		       KBUILD_MODNAME);
 
-	return &state->frontend;
+	return &state->fe;
 
 error:
 	kfree(state);
-- 
2.6.3

