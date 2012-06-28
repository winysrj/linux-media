Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58599 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab2F1VVF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 17:21:05 -0400
Received: by bkcji2 with SMTP id ji2so2503068bkc.19
        for <linux-media@vger.kernel.org>; Thu, 28 Jun 2012 14:21:04 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/2] [media] drxk: Make the QAM demodulator command configurable.
Date: Thu, 28 Jun 2012 23:20:39 +0200
Message-Id: <1340918440-17523-2-git-send-email-martin.blumenstingl@googlemail.com>
In-Reply-To: <1340918440-17523-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1340918440-17523-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently there are two different commands: the old command which takes
4 parameters, and a newer one with just takes 2 parameters.
The driver shows an error in dmesg When using the old command with a new
firmware. Unfortunately this happens every time when chaning the
frequency (on DVB-C).

This patch simply makes configurable, whether the old or the new command
will be used.
All existing drxk_config instances using the "drxk_a3.mc" are updated to
make sure that these won't break (as this is the only firmware that uses
the old command).

I also removed a few lines of duplicated code.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/media/dvb/ddbridge/ddbridge-core.c |  1 +
 drivers/media/dvb/frontends/drxk.h         |  6 +++-
 drivers/media/dvb/frontends/drxk_hard.c    | 44 ++++++++++++++++++------------
 drivers/media/dvb/frontends/drxk_hard.h    |  3 +-
 drivers/media/dvb/ngene/ngene-cards.c      |  1 +
 5 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index 131b938..80985bb 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -578,6 +578,7 @@ static int demod_attach_drxk(struct ddb_input *input)
 
 	memset(&config, 0, sizeof(config));
 	config.microcode_name = "drxk_a3.mc";
+	config.old_qam_demod_cmd = true;
 	config.adr = 0x29 + (input->nr & 1);
 
 	fe = input->fe = dvb_attach(drxk_attach, &config, i2c);
diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb/frontends/drxk.h
index 9d64e4f..c718530 100644
--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -20,6 +20,9 @@
  *			means that 1=DVBC, 0 = DVBT. Zero means the opposite.
  * @mpeg_out_clk_strength: DRXK Mpeg output clock drive strength.
  * @microcode_name:	Name of the firmware file with the microcode
+ * @old_qam_demod_cmd:	True if the firmware uses the old (4-parameter)
+ * 			version of the command to set the demodulator params.
+ * 			Only the initial firmware (drxk_a3.mc) use this.
  *
  * On the *_gpio vars, bit 0 is UIO-1, bit 1 is UIO-2 and bit 2 is
  * UIO-3.
@@ -38,7 +41,8 @@ struct drxk_config {
 	u8	mpeg_out_clk_strength;
 	int	chunk_size;
 
-	const char *microcode_name;
+	const char	*microcode_name;
+	bool		old_qam_demod_cmd;
 };
 
 #if defined(CONFIG_DVB_DRXK) || (defined(CONFIG_DVB_DRXK_MODULE) \
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 60b868f..9b4d28c 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -5445,34 +5445,43 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	}
 	if (status < 0)
 		goto error;
+
 	setParamParameters[0] = state->m_Constellation;	/* modulation     */
 	setParamParameters[1] = DRXK_QAM_I12_J17;	/* interleave mode   */
-	if (state->m_OperationMode == OM_QAM_ITU_C)
-		setParamParameters[2] = QAM_TOP_ANNEX_C;
-	else
-		setParamParameters[2] = QAM_TOP_ANNEX_A;
-	setParamParameters[3] |= (QAM_MIRROR_AUTO_ON);
-	/* Env parameters */
-	/* check for LOCKRANGE Extented */
-	/* setParamParameters[3] |= QAM_LOCKRANGE_NORMAL; */
 
-	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM, 4, setParamParameters, 1, &cmdResult);
-	if (status < 0) {
-		/* Fall-back to the simpler call */
+	if (state->old_qam_demod_cmd) {
 		if (state->m_OperationMode == OM_QAM_ITU_C)
-			setParamParameters[0] = QAM_TOP_ANNEX_C;
+			setParamParameters[2] = QAM_TOP_ANNEX_C;
 		else
-			setParamParameters[0] = QAM_TOP_ANNEX_A;
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 1, setParamParameters, 1, &cmdResult);
+			setParamParameters[2] = QAM_TOP_ANNEX_A;
+		setParamParameters[3] |= (QAM_MIRROR_AUTO_ON);
+		/* Env parameters */
+		/* check for LOCKRANGE Extented */
+		/* setParamParameters[3] |= QAM_LOCKRANGE_NORMAL; */
+
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM, 4, setParamParameters, 1, &cmdResult);
+	} else {
+		u16 setEnvParameters[1];
+
+		if (state->m_OperationMode == OM_QAM_ITU_C)
+			setEnvParameters[0] = QAM_TOP_ANNEX_C;
+		else
+			setEnvParameters[0] = QAM_TOP_ANNEX_A;
+
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 1, setEnvParameters, 1, &cmdResult);
 		if (status < 0)
 			goto error;
 
-		setParamParameters[0] = state->m_Constellation; /* modulation     */
-		setParamParameters[1] = DRXK_QAM_I12_J17;       /* interleave mode   */
 		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM, 2, setParamParameters, 1, &cmdResult);
 	}
-	if (status < 0)
+
+	if (status < 0) {
+		dprintk(1, "Could not set demodulator parameters. Make "
+			"sure old_qam_demod_cmd (%d) is correct for your "
+			"firmware (%s).\n",
+			state->old_qam_demod_cmd, state->microcode_name);
 		goto error;
+	}
 
 	/*
 	 * STEP 3: enable the system in a mode where the ADC provides valid
@@ -6385,6 +6394,7 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	state->demod_address = adr;
 	state->single_master = config->single_master;
 	state->microcode_name = config->microcode_name;
+	state->old_qam_demod_cmd = config->old_qam_demod_cmd;
 	state->no_i2c_bridge = config->no_i2c_bridge;
 	state->antenna_gpio = config->antenna_gpio;
 	state->antenna_dvbt = config->antenna_dvbt;
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index 4bbf841..9c84197 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -338,7 +338,8 @@ struct drxk_state {
 	bool	antenna_dvbt;
 	u16	antenna_gpio;
 
-	const char *microcode_name;
+	const char    *microcode_name;
+	bool           old_qam_demod_cmd;
 };
 
 #define NEVER_LOCK 0
diff --git a/drivers/media/dvb/ngene/ngene-cards.c b/drivers/media/dvb/ngene/ngene-cards.c
index 7539a5d..ad45570 100644
--- a/drivers/media/dvb/ngene/ngene-cards.c
+++ b/drivers/media/dvb/ngene/ngene-cards.c
@@ -217,6 +217,7 @@ static int demod_attach_drxk(struct ngene_channel *chan,
 
 	memset(&config, 0, sizeof(config));
 	config.microcode_name = "drxk_a3.mc";
+	config.old_qam_demod_cmd = true;
 	config.adr = 0x29 + (chan->number ^ 2);
 
 	chan->fe = dvb_attach(drxk_attach, &config, i2c);
-- 
1.7.11.1

