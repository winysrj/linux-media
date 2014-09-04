Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35916 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039AbaIDChA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/37] af9033: make checkpatch.pl happy
Date: Thu,  4 Sep 2014 05:36:16 +0300
Message-Id: <1409798205-25645-8-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct issues reported by checkpatch.pl.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 2a4dfd2..7f22f01 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -69,8 +69,9 @@ static int af9033_wr_regs(struct af9033_state *state, u32 reg, const u8 *val,
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&state->i2c->dev, "%s: i2c wr failed=%d reg=%06x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&state->i2c->dev,
+				"%s: i2c wr failed=%d reg=%06x len=%d\n",
+				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -101,8 +102,9 @@ static int af9033_rd_regs(struct af9033_state *state, u32 reg, u8 *val, int len)
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		dev_warn(&state->i2c->dev, "%s: i2c rd failed=%d reg=%06x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&state->i2c->dev,
+				"%s: i2c rd failed=%d reg=%06x len=%d\n",
+				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -835,7 +837,7 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 	int ret, i, len;
 	u8 buf[3], tmp;
 	u32 snr_val;
-	const struct val_snr *uninitialized_var(snr_lut);
+	const struct val_snr *snr_lut;
 
 	/* read value */
 	ret = af9033_rd_regs(state, 0x80002c, buf, 3);
@@ -928,7 +930,9 @@ static int af9033_update_ch_stat(struct af9033_state *state)
 			abort_cnt = 1000;
 			state->ber = 0xffffffff;
 		} else {
-			/* 8 byte packets, that have not been rejected already */
+			/*
+			 * 8 byte packets, that have not been rejected already
+			 */
 			bit_cnt -= (u32)abort_cnt;
 			if (bit_cnt == 0) {
 				state->ber = 0xffffffff;
@@ -1015,7 +1019,8 @@ err:
 	return ret;
 }
 
-static int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid, int onoff)
+static int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid,
+		int onoff)
 {
 	struct af9033_state *state = fe->demodulator_priv;
 	int ret;
@@ -1069,8 +1074,8 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	memcpy(&state->cfg, config, sizeof(struct af9033_config));
 
 	if (state->cfg.clock != 12000000) {
-		dev_err(&state->i2c->dev, "%s: af9033: unsupported clock=%d, " \
-				"only 12000000 Hz is supported currently\n",
+		dev_err(&state->i2c->dev,
+				"%s: af9033: unsupported clock=%d, only 12000000 Hz is supported currently\n",
 				KBUILD_MODNAME, state->cfg.clock);
 		goto err;
 	}
@@ -1084,9 +1089,10 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	if (ret < 0)
 		goto err;
 
-	dev_info(&state->i2c->dev, "%s: firmware version: LINK=%d.%d.%d.%d " \
-			"OFDM=%d.%d.%d.%d\n", KBUILD_MODNAME, buf[0], buf[1],
-			buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
+	dev_info(&state->i2c->dev,
+			"%s: firmware version: LINK=%d.%d.%d.%d OFDM=%d.%d.%d.%d\n",
+			KBUILD_MODNAME, buf[0], buf[1], buf[2], buf[3], buf[4],
+			buf[5], buf[6], buf[7]);
 
 	/* sleep */
 	switch (state->cfg.tuner) {
-- 
http://palosaari.fi/

