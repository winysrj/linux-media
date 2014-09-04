Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39102 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757047AbaIDChB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Bimow Chen <Bimow.Chen@ite.com.tw>
Subject: [PATCH 01/37] af9033: provide dyn0_clk clock source
Date: Thu,  4 Sep 2014 05:36:09 +0300
Message-Id: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

AF903x/IT913x demod provides clock source(s). It seems that this
clock source is used for integrated RF tuner of IT913x. It is
enabled by default, but firmware disables it automatically when
suspend is requested (suspend_flag (0x004c) + trigger_ofsm
(0x0000)). Automatic disable behavior seems to be similar for both
AF903x and IT913x I tested, though there is no likely any real
clock user in a case of AF903x.

Cc: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 10 ++--------
 drivers/media/dvb-frontends/af9033.h |  5 +++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 5c90ea6..2a4dfd2 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -314,14 +314,8 @@ static int af9033_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	/* feed clock to RF tuner */
-	switch (state->cfg.tuner) {
-	case AF9033_TUNER_IT9135_38:
-	case AF9033_TUNER_IT9135_51:
-	case AF9033_TUNER_IT9135_52:
-	case AF9033_TUNER_IT9135_60:
-	case AF9033_TUNER_IT9135_61:
-	case AF9033_TUNER_IT9135_62:
+	/* clock output */
+	if (state->cfg.dyn0_clk) {
 		ret = af9033_wr_reg(state, 0x80fba8, 0x00);
 		if (ret < 0)
 			goto err;
diff --git a/drivers/media/dvb-frontends/af9033.h b/drivers/media/dvb-frontends/af9033.h
index 539f4db..b95a6d4 100644
--- a/drivers/media/dvb-frontends/af9033.h
+++ b/drivers/media/dvb-frontends/af9033.h
@@ -75,6 +75,11 @@ struct af9033_config {
 	 * input spectrum inversion
 	 */
 	bool spec_inv;
+
+	/*
+	 *
+	 */
+	bool dyn0_clk;
 };
 
 
-- 
http://palosaari.fi/

