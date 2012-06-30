Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39322 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab2F3WdJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 18:33:09 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so3876459bkc.19
        for <linux-media@vger.kernel.org>; Sat, 30 Jun 2012 15:33:08 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/2] [media] drxk: Make the QAM demodulator command parameters configurable.
Date: Sun,  1 Jul 2012 00:32:47 +0200
Message-Id: <1341095567-24225-2-git-send-email-martin.blumenstingl@googlemail.com>
In-Reply-To: <1340918440-17523-2-git-send-email-martin.blumenstingl@googlemail.com>
References: <1340918440-17523-2-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently there are two different implementations (in the firmware) for
the QAM demodulator command: one takes 4 and the other takes 2 parameters.
The driver shows an error in dmesg When using the 4-parameter command with
firmware that implements the 2-parameter command.
Unfortunately this happens every time when chaning the frequency (on DVB-C).

This patch simply makes configurable, how many command parameters will be
used.
All existing drxk_config instances using the "drxk_a3.mc" were updated
because this firmware is the only loadable firmware where the QAM
demodulator command takes 4 parameters. Some firmwares in the ROM
might also use it.
The drxk instances in the em28xx-dvb driver were also updated to
silence the warnings.

If no qam_demod_parameter_count is given in the drxk_config struct,
then the correct number of parameters will be auto-detected.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/media/dvb/ddbridge/ddbridge-core.c |   1 +
 drivers/media/dvb/frontends/drxk.h         |  11 ++-
 drivers/media/dvb/frontends/drxk_hard.c    | 105 ++++++++++++++++++++++-------
 drivers/media/dvb/frontends/drxk_hard.h    |   1 +
 drivers/media/dvb/ngene/ngene-cards.c      |   1 +
 drivers/media/video/em28xx/em28xx-dvb.c    |   4 ++
 6 files changed, 96 insertions(+), 27 deletions(-)

diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index 131b938..ebf3f05 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -578,6 +578,7 @@ static int demod_attach_drxk(struct ddb_input *input)
 
 	memset(&config, 0, sizeof(config));
 	config.microcode_name = "drxk_a3.mc";
+	config.qam_demod_parameter_count = 4;
 	config.adr = 0x29 + (input->nr & 1);
 
 	fe = input->fe = dvb_attach(drxk_attach, &config, i2c);
diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb/frontends/drxk.h
index 9d64e4f..19a8114 100644
--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -20,6 +20,14 @@
  *			means that 1=DVBC, 0 = DVBT. Zero means the opposite.
  * @mpeg_out_clk_strength: DRXK Mpeg output clock drive strength.
  * @microcode_name:	Name of the firmware file with the microcode
+ * @qam_demod_parameter_count:	The number of parameters used for the command
+ * 				to set the demodulator parameters. All
+ * 				firmwares are using the 2-parameter commmand.
+ * 				An exception is the "drxk_a3.mc" firmware,
+ * 				which uses the 4-parameter command.
+ * 				A value of 0 (default) or lower indicates that
+ * 				the correct number of parameters will be
+ * 				automatically detected.
  *
  * On the *_gpio vars, bit 0 is UIO-1, bit 1 is UIO-2 and bit 2 is
  * UIO-3.
@@ -38,7 +46,8 @@ struct drxk_config {
 	u8	mpeg_out_clk_strength;
 	int	chunk_size;
 
-	const char *microcode_name;
+	const char	*microcode_name;
+	int		 qam_demod_parameter_count;
 };
 
 #if defined(CONFIG_DVB_DRXK) || (defined(CONFIG_DVB_DRXK_MODULE) \
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 8fa28bb..ef146ca 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -5415,12 +5415,59 @@ static int GetQAMLockStatus(struct drxk_state *state, u32 *pLockStatus)
 #define QAM_LOCKRANGE__M      0x10
 #define QAM_LOCKRANGE_NORMAL  0x10
 
+static int QAMDemodulatorCommand(struct drxk_state *state, int numberOfParameters)
+{
+	int status;
+	u16 cmdResult;
+	u16 setParamParameters[4] = { 0, 0, 0, 0 };
+
+	setParamParameters[0] = state->m_Constellation;	/* modulation     */
+	setParamParameters[1] = DRXK_QAM_I12_J17;	/* interleave mode   */
+
+	if (numberOfParameters == 2) {
+		u16 setEnvParameters[1] = { 0 };
+
+		if (state->m_OperationMode == OM_QAM_ITU_C)
+			setEnvParameters[0] = QAM_TOP_ANNEX_C;
+		else
+			setEnvParameters[0] = QAM_TOP_ANNEX_A;
+
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 1, setEnvParameters, 1, &cmdResult);
+		if (status < 0)
+			goto error;
+
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM,
+				     numberOfParameters, setParamParameters, 1, &cmdResult);
+	} else if (numberOfParameters == 4) {
+		if (state->m_OperationMode == OM_QAM_ITU_C)
+			setParamParameters[2] = QAM_TOP_ANNEX_C;
+		else
+			setParamParameters[2] = QAM_TOP_ANNEX_A;
+
+		setParamParameters[3] |= (QAM_MIRROR_AUTO_ON);
+		/* Env parameters */
+		/* check for LOCKRANGE Extented */
+		/* setParamParameters[3] |= QAM_LOCKRANGE_NORMAL; */
+
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM,
+				     numberOfParameters, setParamParameters, 1, &cmdResult);
+	} else {
+		printk(KERN_WARNING "drxk: Unknown QAM demodulator parameter "
+			"count %d\n", numberOfParameters);
+	}
+
+error:
+	if (status < 0)
+		printk(KERN_WARNING "drxk: Warning %d on %s\n", status, __func__);
+	return status;
+}
+
 static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 		  s32 tunerFreqOffset)
 {
 	int status;
-	u16 setParamParameters[4] = { 0, 0, 0, 0 };
 	u16 cmdResult;
+	int qamDemodParamCount = state->qam_demod_parameter_count;
 
 	dprintk(1, "\n");
 	/*
@@ -5472,34 +5519,39 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	}
 	if (status < 0)
 		goto error;
-	setParamParameters[0] = state->m_Constellation;	/* modulation     */
-	setParamParameters[1] = DRXK_QAM_I12_J17;	/* interleave mode   */
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
-		if (state->m_OperationMode == OM_QAM_ITU_C)
-			setParamParameters[0] = QAM_TOP_ANNEX_C;
-		else
-			setParamParameters[0] = QAM_TOP_ANNEX_A;
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 1, setParamParameters, 1, &cmdResult);
-		if (status < 0)
-			goto error;
+	// Use the 4-parameter if it's requested or we're probing for
+	// the correct command.
+	if (state->qam_demod_parameter_count == 4
+		|| !state->qam_demod_parameter_count) {
+		qamDemodParamCount = 4;
+		status = QAMDemodulatorCommand(state, qamDemodParamCount);
+	}
 
-		setParamParameters[0] = state->m_Constellation; /* modulation     */
-		setParamParameters[1] = DRXK_QAM_I12_J17;       /* interleave mode   */
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM, 2, setParamParameters, 1, &cmdResult);
+	// Use the 2-parameter command if it was requested or if we're
+	// probing for the correct command and the 4-parameter command
+	// failed.
+	if (state->qam_demod_parameter_count == 2
+		|| (!state->qam_demod_parameter_count && status < 0)) {
+		qamDemodParamCount = 2;
+		status = QAMDemodulatorCommand(state, qamDemodParamCount);
+	}
+
+	if (status < 0) {
+		dprintk(1, "Could not set demodulator parameters. Make "
+			"sure qam_demod_parameter_count (%d) is correct for "
+			"your firmware (%s).\n",
+			state->qam_demod_parameter_count, state->microcode_name);
+		goto error;
+	} else if (!state->qam_demod_parameter_count) {
+		dprintk(1, "Auto-probing the correct QAM demodulator command "
+			"parameters was successful - using %d parameters.\n",
+			qamDemodParamCount);
+
+		// One of our commands was successful. We don't need to 
+		// auto-probe anymore, now that we got the correct command.
+		state->qam_demod_parameter_count = qamDemodParamCount;
 	}
-	if (status < 0)
-		goto error;
 
 	/*
 	 * STEP 3: enable the system in a mode where the ADC provides valid
@@ -6502,6 +6554,7 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	state->demod_address = adr;
 	state->single_master = config->single_master;
 	state->microcode_name = config->microcode_name;
+	state->qam_demod_parameter_count = config->qam_demod_parameter_count;
 	state->no_i2c_bridge = config->no_i2c_bridge;
 	state->antenna_gpio = config->antenna_gpio;
 	state->antenna_dvbt = config->antenna_dvbt;
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index f417797..6bb9fc4 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -353,6 +353,7 @@ struct drxk_state {
 	const char *microcode_name;
 	struct completion fw_wait_load;
 	const struct firmware *fw;
+	int qam_demod_parameter_count;
 };
 
 #define NEVER_LOCK 0
diff --git a/drivers/media/dvb/ngene/ngene-cards.c b/drivers/media/dvb/ngene/ngene-cards.c
index 7539a5d..72ee8de 100644
--- a/drivers/media/dvb/ngene/ngene-cards.c
+++ b/drivers/media/dvb/ngene/ngene-cards.c
@@ -217,6 +217,7 @@ static int demod_attach_drxk(struct ngene_channel *chan,
 
 	memset(&config, 0, sizeof(config));
 	config.microcode_name = "drxk_a3.mc";
+	config.qam_demod_parameter_count = 4;
 	config.adr = 0x29 + (chan->number ^ 2);
 
 	chan->fe = dvb_attach(drxk_attach, &config, i2c);
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index f8ffe10..a16531f 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -315,6 +315,7 @@ static struct drxk_config terratec_h5_drxk = {
 	.single_master = 1,
 	.no_i2c_bridge = 1,
 	.microcode_name = "dvb-usb-terratec-h5-drxk.fw",
+	.qam_demod_parameter_count = 2,
 };
 
 static struct drxk_config hauppauge_930c_drxk = {
@@ -323,6 +324,7 @@ static struct drxk_config hauppauge_930c_drxk = {
 	.no_i2c_bridge = 1,
 	.microcode_name = "dvb-usb-hauppauge-hvr930c-drxk.fw",
 	.chunk_size = 56,
+	.qam_demod_parameter_count = 2,
 };
 
 struct drxk_config terratec_htc_stick_drxk = {
@@ -331,6 +333,7 @@ struct drxk_config terratec_htc_stick_drxk = {
 	.no_i2c_bridge = 1,
 	.microcode_name = "dvb-usb-terratec-htc-stick-drxk.fw",
 	.chunk_size = 54,
+	.qam_demod_parameter_count = 2,
 	/* Required for the antenna_gpio to disable LNA. */
 	.antenna_dvbt = true,
 	/* The windows driver uses the same. This will disable LNA. */
@@ -347,6 +350,7 @@ static struct drxk_config pctv_520e_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
 	.microcode_name = "dvb-demod-drxk-pctv.fw",
+	.qam_demod_parameter_count = 2,
 	.chunk_size = 58,
 	.antenna_dvbt = true, /* disable LNA */
 	.antenna_gpio = (1 << 2), /* disable LNA */
-- 
1.7.11.1

