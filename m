Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:36099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822Ab1GKCAG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 22:00:06 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B205NG018207
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 22:00:05 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKj030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 22:00:04 -0400
Date: Sun, 10 Jul 2011 22:59:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 19/21] [media] drxk: Simplify the DVB-C set mode logic
Message-ID: <20110710225905.5d1e021b@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 7ea73df..bb8627f 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1806,57 +1806,59 @@ static int SetOperationMode(struct drxk_state *state,
 	if (status < 0)
 		goto error;
 
-	if (state->m_OperationMode != oMode) {
-		switch (state->m_OperationMode) {
-			/* OM_NONE was added for start up */
-		case OM_NONE:
-			break;
-		case OM_DVBT:
-			status = MPEGTSStop(state);
-			if (status < 0)
-				goto error;
-			status = PowerDownDVBT(state, true);
-			if (status < 0)
-				goto error;
-			state->m_OperationMode = OM_NONE;
-			break;
-		case OM_QAM_ITU_A:	/* fallthrough */
-		case OM_QAM_ITU_C:
-			status = MPEGTSStop(state);
-			if (status < 0)
-				goto error;
-			status = PowerDownQAM(state);
-			if (status < 0)
-				goto error;
-			state->m_OperationMode = OM_NONE;
-			break;
-		case OM_QAM_ITU_B:
-		default:
-			status = -EINVAL;
+	/* Device is already at the required mode */
+	if (state->m_OperationMode == oMode)
+		return 0;
+
+	switch (state->m_OperationMode) {
+		/* OM_NONE was added for start up */
+	case OM_NONE:
+		break;
+	case OM_DVBT:
+		status = MPEGTSStop(state);
+		if (status < 0)
+			goto error;
+		status = PowerDownDVBT(state, true);
+		if (status < 0)
+			goto error;
+		state->m_OperationMode = OM_NONE;
+		break;
+	case OM_QAM_ITU_A:	/* fallthrough */
+	case OM_QAM_ITU_C:
+		status = MPEGTSStop(state);
+		if (status < 0)
 			goto error;
-		}
+		status = PowerDownQAM(state);
+		if (status < 0)
+			goto error;
+		state->m_OperationMode = OM_NONE;
+		break;
+	case OM_QAM_ITU_B:
+	default:
+		status = -EINVAL;
+		goto error;
+	}
 
-		/*
-			Power up new standard
-			*/
-		switch (oMode) {
-		case OM_DVBT:
-			state->m_OperationMode = oMode;
-			status = SetDVBTStandard(state, oMode);
-			if (status < 0)
-				goto error;
-			break;
-		case OM_QAM_ITU_A:	/* fallthrough */
-		case OM_QAM_ITU_C:
-			state->m_OperationMode = oMode;
-			status = SetQAMStandard(state, oMode);
-			if (status < 0)
-				goto error;
-			break;
-		case OM_QAM_ITU_B:
-		default:
-			status = -EINVAL;
-		}
+	/*
+		Power up new standard
+		*/
+	switch (oMode) {
+	case OM_DVBT:
+		state->m_OperationMode = oMode;
+		status = SetDVBTStandard(state, oMode);
+		if (status < 0)
+			goto error;
+		break;
+	case OM_QAM_ITU_A:	/* fallthrough */
+	case OM_QAM_ITU_C:
+		state->m_OperationMode = oMode;
+		status = SetQAMStandard(state, oMode);
+		if (status < 0)
+			goto error;
+		break;
+	case OM_QAM_ITU_B:
+	default:
+		status = -EINVAL;
 	}
 error:
 	if (status < 0)
@@ -3086,35 +3088,28 @@ static int InitAGC(struct drxk_state *state, bool isDTV)
 	clpCyclen = 500;
 	clpSumMax = 1023;
 
-	if (IsQAM(state)) {
-		/* Standard specific settings */
-		clpSumMin = 8;
-		clpDirTo = (u16) -9;
-		clpCtrlMode = 0;
-		snsSumMin = 8;
-		snsDirTo = (u16) -9;
-		kiInnergainMin = (u16) -1030;
-	} else {
-		status = -EINVAL;
-		goto error;
-	}
-	if (IsQAM(state)) {
-		ifIaccuHiTgtMax = 0x2380;
-		ifIaccuHiTgt = 0x2380;
-		ingainTgtMin = 0x0511;
-		ingainTgt = 0x0511;
-		ingainTgtMax = 5119;
-		fastClpCtrlDelay =
-			state->m_qamIfAgcCfg.FastClipCtrlDelay;
-	} else {
-		ifIaccuHiTgtMax = 0x1200;
-		ifIaccuHiTgt = 0x1200;
-		ingainTgtMin = 13424;
-		ingainTgt = 13424;
-		ingainTgtMax = 30000;
-		fastClpCtrlDelay =
-			state->m_dvbtIfAgcCfg.FastClipCtrlDelay;
+	/* AGCInit() not available for DVBT; init done in microcode */
+	if (!IsQAM(state)) {
+		printk(KERN_ERR "drxk: %s: mode %d is not DVB-C\n", __func__, state->m_OperationMode);
+		return -EINVAL;
 	}
+
+	/* FIXME: Analog TV AGC require different settings */
+
+	/* Standard specific settings */
+	clpSumMin = 8;
+	clpDirTo = (u16) -9;
+	clpCtrlMode = 0;
+	snsSumMin = 8;
+	snsDirTo = (u16) -9;
+	kiInnergainMin = (u16) -1030;
+	ifIaccuHiTgtMax = 0x2380;
+	ifIaccuHiTgt = 0x2380;
+	ingainTgtMin = 0x0511;
+	ingainTgt = 0x0511;
+	ingainTgtMax = 5119;
+	fastClpCtrlDelay = state->m_qamIfAgcCfg.FastClipCtrlDelay;
+
 	status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, fastClpCtrlDelay);
 	if (status < 0)
 		goto error;
@@ -3238,13 +3233,13 @@ static int InitAGC(struct drxk_state *state, bool isDTV)
 	status = read16(state, SCU_RAM_AGC_KI__A, &data);
 	if (status < 0)
 		goto error;
-	if (IsQAM(state)) {
-		data = 0x0657;
-		data &= ~SCU_RAM_AGC_KI_RF__M;
-		data |= (DRXK_KI_RAGC_QAM << SCU_RAM_AGC_KI_RF__B);
-		data &= ~SCU_RAM_AGC_KI_IF__M;
-		data |= (DRXK_KI_IAGC_QAM << SCU_RAM_AGC_KI_IF__B);
-	}
+
+	data = 0x0657;
+	data &= ~SCU_RAM_AGC_KI_RF__M;
+	data |= (DRXK_KI_RAGC_QAM << SCU_RAM_AGC_KI_RF__B);
+	data &= ~SCU_RAM_AGC_KI_IF__M;
+	data |= (DRXK_KI_IAGC_QAM << SCU_RAM_AGC_KI_IF__B);
+
 	status = write16(state, SCU_RAM_AGC_KI__A, data);
 error:
 	if (status < 0)
@@ -5627,6 +5622,8 @@ static int SetQAMStandard(struct drxk_state *state,
 #undef DRXK_QAMA_TAPS_SELECT
 #endif
 
+	dprintk(1, "\n");
+
 	/* added antenna switch */
 	SwitchAntennaToQAM(state);
 
-- 
1.7.1


