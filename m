Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33880 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab3CJCEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:43 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 37/41] af9033: sleep on attach()
Date: Sun, 10 Mar 2013 04:03:29 +0200
Message-Id: <1362881013-5271-37-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 8e3a99d..2dba516 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -985,10 +985,17 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 			"OFDM=%d.%d.%d.%d\n", KBUILD_MODNAME, buf[0], buf[1],
 			buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
 
-
-	/* FIXME: Do not abuse adc_multiplier for detecting IT9135 */
-	if (state->cfg.adc_multiplier != AF9033_ADC_MULTIPLIER_2X) {
-		/* sleep */
+	/* sleep */
+	switch (state->cfg.tuner) {
+	case AF9033_TUNER_IT9135_38:
+	case AF9033_TUNER_IT9135_51:
+	case AF9033_TUNER_IT9135_52:
+	case AF9033_TUNER_IT9135_60:
+	case AF9033_TUNER_IT9135_61:
+	case AF9033_TUNER_IT9135_62:
+		/* IT9135 did not like to sleep at that early */
+		break;
+	default:
 		ret = af9033_wr_reg(state, 0x80004c, 1);
 		if (ret < 0)
 			goto err;
-- 
1.7.11.7

