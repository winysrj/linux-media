Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073Ab1G0U3v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 16:29:51 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6RKTpdT018899
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 16:29:51 -0400
Received: from localhost.localdomain (vpn-227-4.phx2.redhat.com [10.3.227.4])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6RKTkxw009397
	for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 16:29:50 -0400
Date: Wed, 27 Jul 2011 17:29:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] [media] drxk: Fix the logic that selects between DVB-C
 annex A and C
Message-ID: <20110727172934.3d2503b1@redhat.com>
In-Reply-To: <cover.1311798269.git.mchehab@redhat.com>
References: <cover.1311798269.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the DRX-K logic that selects between DVB-C annex A and C

Fix a typo where DVB-C annex type is set via setEnvParameters, but
the driver, uses, instead, setParamParameters[2].

While here, cleans up the code, fixing a bad identation at the fallback
code for other types of firmware, and put the multiple-line comments
into the Linux CodingStyle.

Acked-by: Oliver Endriss <o.endriss@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 85332e8..41b0838 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -5382,18 +5382,16 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 		  s32 tunerFreqOffset)
 {
 	int status;
-	u8 parameterLen;
-	u16 setEnvParameters[5] = { 0, 0, 0, 0, 0 };
 	u16 setParamParameters[4] = { 0, 0, 0, 0 };
 	u16 cmdResult;
 
 	dprintk(1, "\n");
 	/*
-		STEP 1: reset demodulator
-		resets FEC DI and FEC RS
-		resets QAM block
-		resets SCU variables
-		*/
+	 * STEP 1: reset demodulator
+	 *	resets FEC DI and FEC RS
+	 *	resets QAM block
+	 *	resets SCU variables
+	 */
 	status = write16(state, FEC_DI_COMM_EXEC__A, FEC_DI_COMM_EXEC_STOP);
 	if (status < 0)
 		goto error;
@@ -5405,23 +5403,14 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 		goto error;
 
 	/*
-		STEP 2: configure demodulator
-		-set env
-		-set params; resets IQM,QAM,FEC HW; initializes some SCU variables
-		*/
+	 * STEP 2: configure demodulator
+	 *	-set params; resets IQM,QAM,FEC HW; initializes some
+	 *       SCU variables
+	 */
 	status = QAMSetSymbolrate(state);
 	if (status < 0)
 		goto error;
 
-	/* Env parameters */
-	setEnvParameters[2] = QAM_TOP_ANNEX_A;	/* Annex */
-	if (state->m_OperationMode == OM_QAM_ITU_C)
-		setEnvParameters[2] = QAM_TOP_ANNEX_C;	/* Annex */
-	setParamParameters[3] |= (QAM_MIRROR_AUTO_ON);
-	/* check for LOCKRANGE Extented */
-	/* setParamParameters[3] |= QAM_LOCKRANGE_NORMAL; */
-	parameterLen = 4;
-
 	/* Set params */
 	switch (state->param.u.qam.modulation) {
 	case QAM_256:
@@ -5448,30 +5437,37 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 		goto error;
 	setParamParameters[0] = state->m_Constellation;	/* constellation     */
 	setParamParameters[1] = DRXK_QAM_I12_J17;	/* interleave mode   */
+	if (state->m_OperationMode == OM_QAM_ITU_C)
+		setParamParameters[2] = QAM_TOP_ANNEX_C;
+	else
+		setParamParameters[2] = QAM_TOP_ANNEX_A;
+	setParamParameters[3] |= (QAM_MIRROR_AUTO_ON);
+	/* Env parameters */
+	/* check for LOCKRANGE Extented */
+	/* setParamParameters[3] |= QAM_LOCKRANGE_NORMAL; */
 
 	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM, 4, setParamParameters, 1, &cmdResult);
 	if (status < 0) {
 		/* Fall-back to the simpler call */
-		setParamParameters[0] = QAM_TOP_ANNEX_A;
 		if (state->m_OperationMode == OM_QAM_ITU_C)
-			setEnvParameters[0] = QAM_TOP_ANNEX_C;	/* Annex */
+			setParamParameters[0] = QAM_TOP_ANNEX_C;
 		else
-			setEnvParameters[0] = 0;
-
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 1, setEnvParameters, 1, &cmdResult);
-	if (status < 0)
-		goto error;
+			setParamParameters[0] = QAM_TOP_ANNEX_A;
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 1, setParamParameters, 1, &cmdResult);
+		if (status < 0)
+			goto error;
 
 		setParamParameters[0] = state->m_Constellation; /* constellation     */
 		setParamParameters[1] = DRXK_QAM_I12_J17;       /* interleave mode   */
-
 		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM, 2, setParamParameters, 1, &cmdResult);
 	}
 	if (status < 0)
 		goto error;
 
-	/* STEP 3: enable the system in a mode where the ADC provides valid signal
-		setup constellation independent registers */
+	/*
+	 * STEP 3: enable the system in a mode where the ADC provides valid
+	 * signal setup constellation independent registers
+	 */
 #if 0
 	status = SetFrequency(channel, tunerFreqOffset));
 	if (status < 0)
-- 
1.7.1

