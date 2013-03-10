Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58156 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab3CJCEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:43 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 36/41] af9033: move code from it913x to af9033
Date: Sun, 10 Mar 2013 04:03:28 +0200
Message-Id: <1362881013-5271-36-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That register is property of demodulator so move it correct place.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 9 +++++++++
 drivers/media/tuners/it913x.c        | 6 ------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 0320747..8e3a99d 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -391,6 +391,15 @@ static int af9033_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
+	switch (state->cfg.tuner) {
+	case AF9033_TUNER_IT9135_60:
+	case AF9033_TUNER_IT9135_61:
+	case AF9033_TUNER_IT9135_62:
+		ret = af9033_wr_reg(state, 0x800000, 0x01);
+		if (ret < 0)
+			goto err;
+	}
+
 	state->bandwidth_hz = 0; /* force to program all parameters */
 
 	return 0;
diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 2c60bf7..4d7a247 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -145,12 +145,6 @@ static int it913x_init(struct dvb_frontend *fe)
 	u8 nv[] = {48, 32, 24, 16, 12, 8, 6, 4, 2};
 	u8 b[2];
 
-	if (state->chip_ver == 2) {
-		ret = it913x_wr_reg(state, PRO_DMOD, TRIGGER_OFSM, 0x1);
-		if (ret < 0)
-			return -ENODEV;
-	}
-
 	reg = it913x_rd_reg(state, 0xec86);
 	switch (reg) {
 	case 0:
-- 
1.7.11.7

