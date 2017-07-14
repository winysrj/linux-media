Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33827 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdGNVXk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 17:23:40 -0400
Received: by mail-wm0-f68.google.com with SMTP id p204so12836256wmg.1
        for <linux-media@vger.kernel.org>; Fri, 14 Jul 2017 14:23:39 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org, mchehab@s-opensource.com, liplianin@netup.ru
Subject: [PATCH] [media] dvb-frontends/stv0367: improve QAM fe_status
Date: Fri, 14 Jul 2017 23:23:36 +0200
Message-Id: <20170714212336.13909-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

While cab_state->state gives a quite accurate indication of the demod
signal status, it might be incorrect if cab_algo() wasn't able to
determine the exact status, with cab_algo() being the only place where
this status was updated from, and it is only called upon tuning to new
parameters passed to set_frontend(). Thus, the status will be wrong
until the demod is retuned. With the cab_signal_type parsing in
read_status(), this results in unusual fe_states like FE_HAS_SIGNAL |
FE_HAS_CARRIER | FE_HAS_LOCK, which, while userspace applications check
for FE_HAS_LOCK and work fine, leads to missing CNR or UCB stats.

Fix this by re-reading CAB_FSM_STATUS and updating cab_state->state() in
read_status(). While at it, refactor the fsm/qamfeclock and the
fsm->signaltype parsing into separate functions to make things cleaner
and deduplicate code. Also, assume full QAM FEC lock equals full
FE_STATUS.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 148 +++++++++++++++++++---------------
 1 file changed, 85 insertions(+), 63 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 8ac0f598978d..b336fa3d10bf 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -2149,6 +2149,71 @@ static u32 stv0367cab_GetSymbolRate(struct stv0367_state *state, u32 mclk_hz)
 	return regsym;
 }
 
+static u32 stv0367cab_fsm_status(struct stv0367_state *state)
+{
+	return stv0367_readbits(state, F367CAB_FSM_STATUS);
+}
+
+static u32 stv0367cab_qamfec_lock(struct stv0367_state *state)
+{
+	return stv0367_readbits(state,
+		(state->cab_state->qamfec_status_reg ?
+		 state->cab_state->qamfec_status_reg :
+		 F367CAB_QAMFEC_LOCK));
+}
+
+static
+enum stv0367_cab_signal_type stv0367cab_fsm_signaltype(u32 qam_fsm_status)
+{
+	enum stv0367_cab_signal_type signaltype = FE_CAB_NOAGC;
+
+	switch (qam_fsm_status) {
+	case 1:
+		signaltype = FE_CAB_NOAGC;
+		break;
+	case 2:
+		signaltype = FE_CAB_NOTIMING;
+		break;
+	case 3:
+		signaltype = FE_CAB_TIMINGOK;
+		break;
+	case 4:
+		signaltype = FE_CAB_NOCARRIER;
+		break;
+	case 5:
+		signaltype = FE_CAB_CARRIEROK;
+		break;
+	case 7:
+		signaltype = FE_CAB_NOBLIND;
+		break;
+	case 8:
+		signaltype = FE_CAB_BLINDOK;
+		break;
+	case 10:
+		signaltype = FE_CAB_NODEMOD;
+		break;
+	case 11:
+		signaltype = FE_CAB_DEMODOK;
+		break;
+	case 12:
+		signaltype = FE_CAB_DEMODOK;
+		break;
+	case 13:
+		signaltype = FE_CAB_NODEMOD;
+		break;
+	case 14:
+		signaltype = FE_CAB_NOBLIND;
+		break;
+	case 15:
+		signaltype = FE_CAB_NOSIGNAL;
+		break;
+	default:
+		break;
+	}
+
+	return signaltype;
+}
+
 static int stv0367cab_read_status(struct dvb_frontend *fe,
 				  enum fe_status *status)
 {
@@ -2158,22 +2223,26 @@ static int stv0367cab_read_status(struct dvb_frontend *fe,
 
 	*status = 0;
 
-	if (state->cab_state->state > FE_CAB_NOSIGNAL)
-		*status |= FE_HAS_SIGNAL;
+	/* update cab_state->state from QAM_FSM_STATUS */
+	state->cab_state->state = stv0367cab_fsm_signaltype(
+		stv0367cab_fsm_status(state));
 
-	if (state->cab_state->state > FE_CAB_NOCARRIER)
-		*status |= FE_HAS_CARRIER;
+	if (stv0367cab_qamfec_lock(state)) {
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI
+			  | FE_HAS_SYNC | FE_HAS_LOCK;
+		dprintk("%s: stv0367 has locked\n", __func__);
+	} else {
+		if (state->cab_state->state > FE_CAB_NOSIGNAL)
+			*status |= FE_HAS_SIGNAL;
 
-	if (state->cab_state->state >= FE_CAB_DEMODOK)
-		*status |= FE_HAS_VITERBI;
+		if (state->cab_state->state > FE_CAB_NOCARRIER)
+			*status |= FE_HAS_CARRIER;
 
-	if (state->cab_state->state >= FE_CAB_DATAOK)
-		*status |= FE_HAS_SYNC;
+		if (state->cab_state->state >= FE_CAB_DEMODOK)
+			*status |= FE_HAS_VITERBI;
 
-	if (stv0367_readbits(state, (state->cab_state->qamfec_status_reg ?
-		state->cab_state->qamfec_status_reg : F367CAB_QAMFEC_LOCK))) {
-		*status |= FE_HAS_LOCK;
-		dprintk("%s: stv0367 has locked\n", __func__);
+		if (state->cab_state->state >= FE_CAB_DATAOK)
+			*status |= FE_HAS_SYNC;
 	}
 
 	return 0;
@@ -2374,7 +2443,7 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 	LockTime = 0;
 	stv0367_writereg(state, R367CAB_CTRL_1, 0x00);
 	do {
-		QAM_Lock = stv0367_readbits(state, F367CAB_FSM_STATUS);
+		QAM_Lock = stv0367cab_fsm_status(state);
 		if ((LockTime >= (DemodTimeOut - EQLTimeOut)) &&
 							(QAM_Lock == 0x04))
 			/*
@@ -2435,10 +2504,7 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 		do {
 			usleep_range(5000, 7000);
 			LockTime += 5;
-			QAMFEC_Lock = stv0367_readbits(state,
-				(state->cab_state->qamfec_status_reg ?
-				state->cab_state->qamfec_status_reg :
-				F367CAB_QAMFEC_LOCK));
+			QAMFEC_Lock = stv0367cab_qamfec_lock(state);
 		} while (!QAMFEC_Lock && (LockTime < FECTimeOut));
 	} else
 		QAMFEC_Lock = 0;
@@ -2474,52 +2540,8 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 		cab_state->locked = 1;
 
 		/* stv0367_setbits(state, F367CAB_AGC_ACCUMRSTSEL,7);*/
-	} else {
-		switch (QAM_Lock) {
-		case 1:
-			signalType = FE_CAB_NOAGC;
-			break;
-		case 2:
-			signalType = FE_CAB_NOTIMING;
-			break;
-		case 3:
-			signalType = FE_CAB_TIMINGOK;
-			break;
-		case 4:
-			signalType = FE_CAB_NOCARRIER;
-			break;
-		case 5:
-			signalType = FE_CAB_CARRIEROK;
-			break;
-		case 7:
-			signalType = FE_CAB_NOBLIND;
-			break;
-		case 8:
-			signalType = FE_CAB_BLINDOK;
-			break;
-		case 10:
-			signalType = FE_CAB_NODEMOD;
-			break;
-		case 11:
-			signalType = FE_CAB_DEMODOK;
-			break;
-		case 12:
-			signalType = FE_CAB_DEMODOK;
-			break;
-		case 13:
-			signalType = FE_CAB_NODEMOD;
-			break;
-		case 14:
-			signalType = FE_CAB_NOBLIND;
-			break;
-		case 15:
-			signalType = FE_CAB_NOSIGNAL;
-			break;
-		default:
-			break;
-		}
-
-	}
+	} else
+		signalType = stv0367cab_fsm_signaltype(QAM_Lock);
 
 	/* Set the AGC control values to tracking values */
 	stv0367_writebits(state, F367CAB_AGC_ACCUMRSTSEL, TrackAGCAccum);
-- 
2.13.0
