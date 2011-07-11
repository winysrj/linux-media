Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:45553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab1GKB7W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:22 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xLxe018078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:22 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKP030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:21 -0400
Date: Sun, 10 Jul 2011 22:59:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 21/21] [media] drxk: Add a fallback method for QAM parameter
 setting
Message-ID: <20110710225907.32cddb94@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

The QAM standard is set using this scu_command:
	SCU_RAM_COMMAND_STANDARD_QAM |
	SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM

The driver implements a version that has 4 parameters, however,
Terratec H5 needs to break this into two separate commands, otherwise,
DVB-C doesn't work.

With this fix, scan is now properly working and getting the
channel list:
>>> tune to: 609000000:INVERSION_AUTO:5217000:FEC_3_4:QAM_256
>>> tuning status == 0x00
>>> tuning status == 0x07
>>> tuning status == 0x1f

0x0093 0x0026: pmt_pid 0x0758 (null) -- SporTV2 (running, scrambled)
0x0093 0x0027: pmt_pid 0x0748 (null) -- SporTV (running, scrambled)
0x0093 0x0036: pmt_pid 0x0768 (null) -- FX (running, scrambled)
0x0093 0x0052: pmt_pid 0x0788 (null) -- The History Channel (running, scrambled)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 5745f52..f74a176 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -5389,7 +5389,7 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 {
 	int status;
 	u8 parameterLen;
-	u16 setEnvParameters[5];
+	u16 setEnvParameters[5] = { 0, 0, 0, 0, 0 };
 	u16 setParamParameters[4] = { 0, 0, 0, 0 };
 	u16 cmdResult;
 
@@ -5456,9 +5456,25 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	setParamParameters[1] = DRXK_QAM_I12_J17;	/* interleave mode   */
 
 	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM, 4, setParamParameters, 1, &cmdResult);
+	if (status < 0) {
+		/* Fall-back to the simpler call */
+		setParamParameters[0] = QAM_TOP_ANNEX_A;
+		if (state->m_OperationMode == OM_QAM_ITU_C)
+			setEnvParameters[0] = QAM_TOP_ANNEX_C;	/* Annex */
+		else
+			setEnvParameters[0] = 0;
+
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 1, setEnvParameters, 1, &cmdResult);
 	if (status < 0)
 		goto error;
 
+		setParamParameters[0] = state->m_Constellation; /* constellation     */
+		setParamParameters[1] = DRXK_QAM_I12_J17;       /* interleave mode   */
+
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM, 2, setParamParameters, 1, &cmdResult);
+	}
+	if (status < 0)
+		goto error;
 
 	/* STEP 3: enable the system in a mode where the ADC provides valid signal
 		setup constellation independent registers */
-- 
1.7.1

