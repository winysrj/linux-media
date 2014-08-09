Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54503 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbaHIU1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 16:27:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/14] af9033: feed clock to RF tuner
Date: Sat,  9 Aug 2014 23:27:02 +0300
Message-Id: <1407616032-2722-5-git-send-email-crope@iki.fi>
In-Reply-To: <1407616032-2722-1-git-send-email-crope@iki.fi>
References: <1407616032-2722-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

IT9135 RF tuner clock is coming from demodulator. We need enable it
early in demod init, before any tuner I/O. Currently it is enabled
by tuner driver itself, but it is too late and performance will be
reduced as some registers are not updated correctly. Clock is
disabled automatically when demod is put onto sleep.

Cc: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index be4bec2..5c90ea6 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -314,6 +314,19 @@ static int af9033_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
+	/* feed clock to RF tuner */
+	switch (state->cfg.tuner) {
+	case AF9033_TUNER_IT9135_38:
+	case AF9033_TUNER_IT9135_51:
+	case AF9033_TUNER_IT9135_52:
+	case AF9033_TUNER_IT9135_60:
+	case AF9033_TUNER_IT9135_61:
+	case AF9033_TUNER_IT9135_62:
+		ret = af9033_wr_reg(state, 0x80fba8, 0x00);
+		if (ret < 0)
+			goto err;
+	}
+
 	/* settings for TS interface */
 	if (state->cfg.ts_mode == AF9033_TS_MODE_USB) {
 		ret = af9033_wr_reg_mask(state, 0x80f9a5, 0x00, 0x01);
-- 
http://palosaari.fi/

