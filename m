Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44698 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751241AbdKEOZ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 09:25:28 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 11/15] si2165: add DVBv5 C/N statistics for DVB-C
Date: Sun,  5 Nov 2017 15:25:07 +0100
Message-Id: <20171105142511.16563-11-zzam@gentoo.org>
In-Reply-To: <20171105142511.16563-1-zzam@gentoo.org>
References: <20171105142511.16563-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add C/N statistics in dB to read_status (DVBv5).

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c      | 43 +++++++++++++++++++++++++++++--
 drivers/media/dvb-frontends/si2165_priv.h |  1 +
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 30ceba664f5f..777b7d049ae7 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -116,6 +116,17 @@ static int si2165_readreg16(struct si2165_state *state,
 	return ret;
 }
 
+static int si2165_readreg24(struct si2165_state *state,
+			    const u16 reg, u32 *val)
+{
+	u8 buf[3];
+
+	int ret = si2165_read(state, reg, buf, 3);
+	*val = buf[0] | buf[1] << 8 | buf[2] << 16;
+	dev_dbg(&state->client->dev, "reg read: R(0x%04x)=0x%06x\n", reg, *val);
+	return ret;
+}
+
 static int si2165_writereg8(struct si2165_state *state, const u16 reg, u8 val)
 {
 	return regmap_write(state->regmap, reg, val);
@@ -518,6 +529,7 @@ static int si2165_init(struct dvb_frontend *fe)
 {
 	int ret = 0;
 	struct si2165_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u8 val;
 	u8 patch_version = 0x00;
 
@@ -627,6 +639,10 @@ static int si2165_init(struct dvb_frontend *fe)
 	if (ret < 0)
 		return ret;
 
+	c = &state->fe.dtv_property_cache;
+	c->cnr.len = 1;
+	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	return 0;
 error:
 	return ret;
@@ -652,9 +668,10 @@ static int si2165_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	int ret;
 	u8 u8tmp;
+	u32 u32tmp;
 	struct si2165_state *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	u32 delsys = p->delivery_system;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 delsys = c->delivery_system;
 
 	*status = 0;
 
@@ -699,6 +716,28 @@ static int si2165_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		*status |= FE_HAS_LOCK;
 	}
 
+	/* CNR */
+	if (delsys == SYS_DVBC_ANNEX_A && *status & FE_HAS_VITERBI) {
+		ret = si2165_readreg24(state, REG_C_N, &u32tmp);
+		if (ret < 0)
+			return ret;
+		/*
+		 * svalue =
+		 * 1000 * c_n/dB =
+		 * 1000 * 10 * log10(2^24 / regval) =
+		 * 1000 * 10 * (log10(2^24) - log10(regval)) =
+		 * 1000 * 10 * (intlog10(2^24) - intlog10(regval)) / 2^24
+		 *
+		 * intlog10(x) = log10(x) * 2^24
+		 * intlog10(2^24) = log10(2^24) * 2^24 = 121210686
+		 */
+		u32tmp = (1000 * 10 * (121210686 - (u64)intlog10(u32tmp)))
+				>> 24;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		c->cnr.stat[0].svalue = u32tmp;
+	} else
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	return 0;
 }
 
diff --git a/drivers/media/dvb-frontends/si2165_priv.h b/drivers/media/dvb-frontends/si2165_priv.h
index 47f18ff69fe5..9d79e86d04c2 100644
--- a/drivers/media/dvb-frontends/si2165_priv.h
+++ b/drivers/media/dvb-frontends/si2165_priv.h
@@ -74,6 +74,7 @@ struct si2165_config {
 #define REG_KP_LOCK			0x023a
 #define REG_UNKNOWN_24C			0x024c
 #define REG_CENTRAL_TAP			0x0261
+#define REG_C_N				0x026c
 #define REG_EQ_AUTO_CONTROL		0x0278
 #define REG_UNKNOWN_27C			0x027c
 #define REG_START_SYNCHRO		0x02e0
-- 
2.15.0
