Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57209 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072AbaIDChC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:02 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 22/37] af9033: fix firmware version logging
Date: Thu,  4 Sep 2014 05:36:30 +0300
Message-Id: <1409798205-25645-22-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

AF9030 and IT9130 series has different memory location for firmware
version. Choose correct location according to chip type.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 7f22f01..7d637b9 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -1061,6 +1061,7 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	int ret;
 	struct af9033_state *state;
 	u8 buf[8];
+	u32 reg;
 
 	dev_dbg(&i2c->dev, "%s:\n", __func__);
 
@@ -1081,7 +1082,21 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	}
 
 	/* firmware version */
-	ret = af9033_rd_regs(state, 0x0083e9, &buf[0], 4);
+	switch (state->cfg.tuner) {
+	case AF9033_TUNER_IT9135_38:
+	case AF9033_TUNER_IT9135_51:
+	case AF9033_TUNER_IT9135_52:
+	case AF9033_TUNER_IT9135_60:
+	case AF9033_TUNER_IT9135_61:
+	case AF9033_TUNER_IT9135_62:
+		reg = 0x004bfc;
+		break;
+	default:
+		reg = 0x0083e9;
+		break;
+	}
+
+	ret = af9033_rd_regs(state, reg, &buf[0], 4);
 	if (ret < 0)
 		goto err;
 
-- 
http://palosaari.fi/

