Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:43523 "EHLO
        homiemail-a123.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753328AbeBLUwo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 15:52:44 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 9/9] lgdt3306a: Add QAM AUTO support
Date: Mon, 12 Feb 2018 14:52:29 -0600
Message-Id: <1518468749-22162-1-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515110659-20145-10-git-send-email-brad@nextdimension.cc>
References: <1515110659-20145-10-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As configured currently, modulation in the driver is set to auto detect,
no matter what the user sets modulation to. This leads to both QAM64
and QAM256 having the same effect. QAM AUTO is explicitly added here for
compatibility with scanning software who can use AUTO instead of doing
essentially the same scan twice.
Also included is a module option to enforce a specific QAM modulation if
desired. The true modulation is read before calculating the snr.
Changes are backwards compatible with current behaviour.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v1:
- fixed checkpatch complaint

 drivers/media/dvb-frontends/lgdt3306a.c | 41 +++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 377271d..ed70369 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -30,6 +30,17 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, reg=2 (or-able))");
 
+/*
+ * Older drivers treated QAM64 and QAM256 the same; that is the HW always
+ * used "Auto" mode during detection.  Setting "forced_manual"=1 allows
+ * the user to treat these modes as separate.  For backwards compatibility,
+ * it's off by default.  QAM_AUTO can now be specified to achive that
+ * effect even if "forced_manual"=1
+ */
+static int forced_manual;
+module_param(forced_manual, int, 0644);
+MODULE_PARM_DESC(forced_manual, "if set, QAM64 and QAM256 will only lock to modulation specified");
+
 #define DBG_INFO 1
 #define DBG_REG  2
 #define DBG_DUMP 4 /* FGR - comment out to remove dump code */
@@ -566,7 +577,11 @@ static int lgdt3306a_set_qam(struct lgdt3306a_state *state, int modulation)
 	/* 3. : 64QAM/256QAM detection(manual, auto) */
 	ret = lgdt3306a_read_reg(state, 0x0009, &val);
 	val &= 0xfc;
-	val |= 0x02; /* STDOPDETCMODE[1:0]=1=Manual 2=Auto */
+	/* Check for forced Manual modulation modes; otherwise always "auto" */
+	if (forced_manual && (modulation != QAM_AUTO))
+		val |= 0x01; /* STDOPDETCMODE[1:0]= 1=Manual */
+	else
+		val |= 0x02; /* STDOPDETCMODE[1:0]= 2=Auto */
 	ret = lgdt3306a_write_reg(state, 0x0009, val);
 	if (lg_chkerr(ret))
 		goto fail;
@@ -642,10 +657,9 @@ static int lgdt3306a_set_modulation(struct lgdt3306a_state *state,
 		ret = lgdt3306a_set_vsb(state);
 		break;
 	case QAM_64:
-		ret = lgdt3306a_set_qam(state, QAM_64);
-		break;
 	case QAM_256:
-		ret = lgdt3306a_set_qam(state, QAM_256);
+	case QAM_AUTO:
+		ret = lgdt3306a_set_qam(state, p->modulation);
 		break;
 	default:
 		return -EINVAL;
@@ -672,6 +686,7 @@ static int lgdt3306a_agc_setup(struct lgdt3306a_state *state,
 		break;
 	case QAM_64:
 	case QAM_256:
+	case QAM_AUTO:
 		break;
 	default:
 		return -EINVAL;
@@ -726,6 +741,7 @@ static int lgdt3306a_spectral_inversion(struct lgdt3306a_state *state,
 		break;
 	case QAM_64:
 	case QAM_256:
+	case QAM_AUTO:
 		/* Auto ok for QAM */
 		ret = lgdt3306a_set_inversion_auto(state, 1);
 		break;
@@ -749,6 +765,7 @@ static int lgdt3306a_set_if(struct lgdt3306a_state *state,
 		break;
 	case QAM_64:
 	case QAM_256:
+	case QAM_AUTO:
 		if_freq_khz = state->cfg->qam_if_khz;
 		break;
 	default:
@@ -1607,6 +1624,7 @@ static int lgdt3306a_read_status(struct dvb_frontend *fe,
 		switch (state->current_modulation) {
 		case QAM_256:
 		case QAM_64:
+		case QAM_AUTO:
 			if (lgdt3306a_qam_lock_poll(state) == LG3306_LOCK) {
 				*status |= FE_HAS_VITERBI;
 				*status |= FE_HAS_SYNC;
@@ -1650,6 +1668,7 @@ static int lgdt3306a_read_signal_strength(struct dvb_frontend *fe,
 	 * Calculate some sort of "strength" from SNR
 	 */
 	struct lgdt3306a_state *state = fe->demodulator_priv;
+	u8 val;
 	u16 snr; /* snr_x10 */
 	int ret;
 	u32 ref_snr; /* snr*100 */
@@ -1662,11 +1681,15 @@ static int lgdt3306a_read_signal_strength(struct dvb_frontend *fe,
 		 ref_snr = 1600; /* 16dB */
 		 break;
 	case QAM_64:
-		 ref_snr = 2200; /* 22dB */
-		 break;
 	case QAM_256:
-		 ref_snr = 2800; /* 28dB */
-		 break;
+	case QAM_AUTO:
+		/* need to know actual modulation to set proper SNR baseline */
+		lgdt3306a_read_reg(state, 0x00a6, &val);
+		if (val & 0x04)
+			ref_snr = 2800; /* QAM-256 28dB */
+		else
+			ref_snr = 2200; /* QAM-64  22dB */
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2136,7 +2159,7 @@ static const struct dvb_frontend_ops lgdt3306a_ops = {
 		.frequency_min      = 54000000,
 		.frequency_max      = 858000000,
 		.frequency_stepsize = 62500,
-		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
+		.caps = FE_CAN_QAM_AUTO | FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
 	},
 	.i2c_gate_ctrl        = lgdt3306a_i2c_gate_ctrl,
 	.init                 = lgdt3306a_init,
-- 
2.7.4
