Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44720 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751307AbdKEOZc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 09:25:32 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 14/15] si2165: Add DVBv3 wrapper for ber statistics
Date: Sun,  5 Nov 2017 15:25:10 +0100
Message-Id: <20171105142511.16563-14-zzam@gentoo.org>
In-Reply-To: <20171105142511.16563-1-zzam@gentoo.org>
References: <20171105142511.16563-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add read_ber function that reads from property cache to support DVBv3.
The implementation is inspired by the cx24120 driver.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index ceb5a2bb0dea..2ad6409dd6b1 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -57,6 +57,9 @@ struct si2165_state {
 	u32 sys_clk;
 	u32 adc_clk;
 
+	/* DVBv3 stats */
+	u64 ber_prev;
+
 	bool has_dvbc;
 	bool has_dvbt;
 	bool firmware_loaded;
@@ -757,6 +760,12 @@ static int si2165_read_status(struct dvb_frontend *fe, enum fe_status *status)
 			c->post_bit_error.stat[0].uvalue = 0;
 			c->post_bit_count.stat[0].uvalue = 0;
 
+			/*
+			 * reset DVBv3 value to deliver a good result
+			 * for the first call
+			 */
+			state->ber_prev = 0;
+
 		} else {
 			ret = si2165_readreg8(state, REG_BER_AVAIL, &u8tmp);
 			if (ret < 0)
@@ -805,6 +814,22 @@ static int si2165_read_snr(struct dvb_frontend *fe, u16 *snr)
 	return 0;
 }
 
+static int si2165_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct si2165_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	if (c->post_bit_error.stat[0].scale != FE_SCALE_COUNTER) {
+		*ber = 0;
+		return 0;
+	}
+
+	*ber = c->post_bit_error.stat[0].uvalue - state->ber_prev;
+	state->ber_prev = c->post_bit_error.stat[0].uvalue;
+
+	return 0;
+}
+
 static int si2165_set_oversamp(struct si2165_state *state, u32 dvb_rate)
 {
 	u64 oversamp;
@@ -1123,6 +1148,7 @@ static const struct dvb_frontend_ops si2165_ops = {
 	.set_frontend      = si2165_set_frontend,
 	.read_status       = si2165_read_status,
 	.read_snr          = si2165_read_snr,
+	.read_ber          = si2165_read_ber,
 };
 
 static int si2165_probe(struct i2c_client *client,
-- 
2.15.0
