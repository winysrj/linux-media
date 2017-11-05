Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44670 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751097AbdKEOZW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 09:25:22 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 06/15] si2165: improve read_status
Date: Sun,  5 Nov 2017 15:25:02 +0100
Message-Id: <20171105142511.16563-6-zzam@gentoo.org>
In-Reply-To: <20171105142511.16563-1-zzam@gentoo.org>
References: <20171105142511.16563-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use check_signal register for DVB-T additionally.
For DVB-C use ps_lock additionally.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c      | 41 ++++++++++++++++++++++++++-----
 drivers/media/dvb-frontends/si2165_priv.h |  2 ++
 2 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index b2541c1fe554..f8d7595a25d4 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -651,18 +651,47 @@ static int si2165_sleep(struct dvb_frontend *fe)
 static int si2165_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	int ret;
-	u8 fec_lock = 0;
+	u8 u8tmp;
 	struct si2165_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	u32 delsys = p->delivery_system;
 
-	if (!state->has_dvbt)
-		return -EINVAL;
+	*status = 0;
+
+	switch (delsys) {
+	case SYS_DVBT:
+		/* check fast signal type */
+		ret = si2165_readreg8(state, REG_CHECK_SIGNAL, &u8tmp);
+		if (ret < 0)
+			return ret;
+		switch (u8tmp & 0x3) {
+		case 0: /* searching */
+		case 1: /* nothing */
+			break;
+		case 2: /* digital signal */
+			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
+			break;
+		}
+		break;
+	case SYS_DVBC_ANNEX_A:
+		/* check packet sync lock */
+		ret = si2165_readreg8(state, REG_PS_LOCK, &u8tmp);
+		if (ret < 0)
+			return ret;
+		if (u8tmp & 0x01) {
+			*status |= FE_HAS_SIGNAL;
+			*status |= FE_HAS_CARRIER;
+			*status |= FE_HAS_VITERBI;
+			*status |= FE_HAS_SYNC;
+		}
+		break;
+	}
 
 	/* check fec_lock */
-	ret = si2165_readreg8(state, REG_FEC_LOCK, &fec_lock);
+	ret = si2165_readreg8(state, REG_FEC_LOCK, &u8tmp);
 	if (ret < 0)
 		return ret;
-	*status = 0;
-	if (fec_lock & 0x01) {
+	if (u8tmp & 0x01) {
 		*status |= FE_HAS_SIGNAL;
 		*status |= FE_HAS_CARRIER;
 		*status |= FE_HAS_VITERBI;
diff --git a/drivers/media/dvb-frontends/si2165_priv.h b/drivers/media/dvb-frontends/si2165_priv.h
index da8bbda8a4e3..47f18ff69fe5 100644
--- a/drivers/media/dvb-frontends/si2165_priv.h
+++ b/drivers/media/dvb-frontends/si2165_priv.h
@@ -93,6 +93,8 @@ struct si2165_config {
 #define REG_GP_REG0_LSB			0x0384
 #define REG_GP_REG0_MSB			0x0387
 #define REG_CRC				0x037a
+#define REG_CHECK_SIGNAL		0x03a8
+#define REG_PS_LOCK			0x0440
 #define REG_BER_PKT			0x0470
 #define REG_FEC_LOCK			0x04e0
 #define REG_TS_DATA_MODE		0x04e4
-- 
2.15.0
