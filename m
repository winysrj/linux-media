Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab1GXML7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 08:11:59 -0400
Message-ID: <4E2C0BF8.5090006@redhat.com>
Date: Sun, 24 Jul 2011 09:11:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>,
	Oliver Endriss <o.endriss@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] drx-k: Fix QAM Annex C selection
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ralph/Oliver,

As I said before,the DRX-K logic to select DVB-C annex A seems wrong.

Basically, it sets Annex A at setEnvParameters, but this var is not
used anywhere.  However, as setParamParameters[2] is not used, I suspect
that this is a typo. 

The enclosed patch fixes it, but, on my tests here with devices with
drx-3913k and drx-3926k, DVB-C is not working with the drxk_a3.mc firmware. 
So, I'm not sure if the devices I have don't support that firmware,
or if the DVB-C code is broken or is not supported by such firmware.

I'm getting the drxk_a3.mc via Documentation/dvb/get_dvb_firmware
from:
	http://l4m-daten.de/files/DDTuner.zip

With the firmware I'm using, SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM only
accepts 1 parameter.

So, I can't actually test it.

Could you please double-check it?

Thanks!
Mauro

-

Fix the DRX-K logic to select DVB-C annex A

setEnvParameters, but this var is not used anywhere.  However, as 
setParamParameters[2] is not used, it seems to be a typo.

The enclosed patch fixes it.

This patch was not tested.

While here, corrects a bad identation at the fallback code for
other types of firmware.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index b3dbe82..d420464 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -5384,8 +5384,6 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 		  s32 tunerFreqOffset)
 {
 	int status;
-	u8 parameterLen;
-	u16 setEnvParameters[5] = { 0, 0, 0, 0, 0 };
 	u16 setParamParameters[4] = { 0, 0, 0, 0 };
 	u16 cmdResult;
 
@@ -5416,13 +5414,12 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 		goto error;
 
 	/* Env parameters */
-	setEnvParameters[2] = QAM_TOP_ANNEX_A;	/* Annex */
+	setParamParameters[2] = QAM_TOP_ANNEX_A;	/* Annex */
 	if (state->m_OperationMode == OM_QAM_ITU_C)
-		setEnvParameters[2] = QAM_TOP_ANNEX_C;	/* Annex */
+		setParamParameters[2] = QAM_TOP_ANNEX_C;	/* Annex */
 	setParamParameters[3] |= (QAM_MIRROR_AUTO_ON);
 	/* check for LOCKRANGE Extented */
 	/* setParamParameters[3] |= QAM_LOCKRANGE_NORMAL; */
-	parameterLen = 4;
 
 	/* Set params */
 	switch (state->param.u.qam.modulation) {
@@ -5453,6 +5450,7 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 
 	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM, 4, setParamParameters, 1, &cmdResult);
 	if (status < 0) {
+		u16 setEnvParameters[5] = { 0, 0, 0, 0, 0 };
 		/* Fall-back to the simpler call */
 		setParamParameters[0] = QAM_TOP_ANNEX_A;
 		if (state->m_OperationMode == OM_QAM_ITU_C)
@@ -5461,8 +5459,8 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 			setEnvParameters[0] = 0;
 
 		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 1, setEnvParameters, 1, &cmdResult);
-	if (status < 0)
-		goto error;
+		if (status < 0)
+			goto error;
 
 		setParamParameters[0] = state->m_Constellation; /* constellation     */
 		setParamParameters[1] = DRXK_QAM_I12_J17;       /* interleave mode   */
