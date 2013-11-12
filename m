Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:64836 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3KLP5p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Nov 2013 10:57:45 -0500
Received: by mail-wi0-f175.google.com with SMTP id hm11so3866959wib.14
        for <linux-media@vger.kernel.org>; Tue, 12 Nov 2013 07:57:44 -0800 (PST)
From: Luis Alves <ljalvs@gmail.com>
To: linux-media@vger.kernel.org
Cc: mkrufky@linuxtv.org, mchehab@infradead.org,
	pboettcher@kernellabs.com, ljalvs@gmail.com
Subject: [PATCH 1/2] cx24117: Add complete demod command list.
Date: Tue, 12 Nov 2013 15:57:37 +0000
Message-Id: <1384271857-23540-1-git-send-email-ljalvs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patch adds the complete list of all the commands known for the cx24117 demod.

Regards,
Luis


Signed-off-by: Luis Alves <ljalvs@gmail.com>
---
 drivers/media/dvb-frontends/cx24117.c | 98 +++++++++++++++++++++--------------
 1 file changed, 58 insertions(+), 40 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index 476b422..a6fe1af 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -135,15 +135,33 @@
 
 
 enum cmds {
-	CMD_SET_VCO     = 0x10,
-	CMD_TUNEREQUEST = 0x11,
-	CMD_MPEGCONFIG  = 0x13,
-	CMD_TUNERINIT   = 0x14,
-	CMD_LNBSEND     = 0x21, /* Formerly CMD_SEND_DISEQC */
-	CMD_LNBDCLEVEL  = 0x22,
-	CMD_SET_TONE    = 0x23,
-	CMD_UPDFWVERS   = 0x35,
-	CMD_TUNERSLEEP  = 0x36,
+	CMD_SET_VCOFREQ    = 0x10,
+	CMD_TUNEREQUEST    = 0x11,
+	CMD_GLOBAL_MPEGCFG = 0x13,
+	CMD_MPEGCFG        = 0x14,
+	CMD_TUNERINIT      = 0x15,
+	CMD_GET_SRATE      = 0x18,
+	CMD_SET_GOLDCODE   = 0x19,
+	CMD_GET_AGCACC     = 0x1a,
+	CMD_DEMODINIT      = 0x1b,
+	CMD_GETCTLACC      = 0x1c,
+
+	CMD_LNBCONFIG      = 0x20,
+	CMD_LNBSEND        = 0x21,
+	CMD_LNBDCLEVEL     = 0x22,
+	CMD_LNBPCBCONFIG   = 0x23,
+	CMD_LNBSENDTONEBST = 0x24,
+	CMD_LNBUPDREPLY    = 0x25,
+
+	CMD_SET_GPIOMODE   = 0x30,
+	CMD_SET_GPIOEN     = 0x31,
+	CMD_SET_GPIODIR    = 0x32,
+	CMD_SET_GPIOOUT    = 0x33,
+	CMD_ENABLERSCORR   = 0x34,
+	CMD_FWVERSION      = 0x35,
+	CMD_SET_SLEEPMODE  = 0x36,
+	CMD_BERCTRL        = 0x3c,
+	CMD_EVENTCTRL      = 0x3d,
 };
 
 static LIST_HEAD(hybrid_tuner_instance_list);
@@ -619,8 +637,8 @@ static int cx24117_load_firmware(struct dvb_frontend *fe,
 	cx24117_writereg(state, 0xf7, 0x0c);
 	cx24117_writereg(state, 0xe0, 0x00);
 
-	/* CMD 1B */
-	cmd.args[0] = 0x1b;
+	/* Init demodulator */
+	cmd.args[0] = CMD_DEMODINIT;
 	cmd.args[1] = 0x00;
 	cmd.args[2] = 0x01;
 	cmd.args[3] = 0x00;
@@ -629,8 +647,8 @@ static int cx24117_load_firmware(struct dvb_frontend *fe,
 	if (ret != 0)
 		goto error;
 
-	/* CMD 10 */
-	cmd.args[0] = CMD_SET_VCO;
+	/* Set VCO frequency */
+	cmd.args[0] = CMD_SET_VCOFREQ;
 	cmd.args[1] = 0x06;
 	cmd.args[2] = 0x2b;
 	cmd.args[3] = 0xd8;
@@ -648,8 +666,8 @@ static int cx24117_load_firmware(struct dvb_frontend *fe,
 	if (ret != 0)
 		goto error;
 
-	/* CMD 15 */
-	cmd.args[0] = 0x15;
+	/* Tuner init */
+	cmd.args[0] = CMD_TUNERINIT;
 	cmd.args[1] = 0x00;
 	cmd.args[2] = 0x01;
 	cmd.args[3] = 0x00;
@@ -667,8 +685,8 @@ static int cx24117_load_firmware(struct dvb_frontend *fe,
 	if (ret != 0)
 		goto error;
 
-	/* CMD 13 */
-	cmd.args[0] = CMD_MPEGCONFIG;
+	/* Global MPEG config */
+	cmd.args[0] = CMD_GLOBAL_MPEGCFG;
 	cmd.args[1] = 0x00;
 	cmd.args[2] = 0x00;
 	cmd.args[3] = 0x00;
@@ -679,9 +697,9 @@ static int cx24117_load_firmware(struct dvb_frontend *fe,
 	if (ret != 0)
 		goto error;
 
-	/* CMD 14 */
+	/* MPEG config for each demod */
 	for (i = 0; i < 2; i++) {
-		cmd.args[0] = CMD_TUNERINIT;
+		cmd.args[0] = CMD_MPEGCFG;
 		cmd.args[1] = (u8) i;
 		cmd.args[2] = 0x00;
 		cmd.args[3] = 0x05;
@@ -699,8 +717,8 @@ static int cx24117_load_firmware(struct dvb_frontend *fe,
 	cx24117_writereg(state, 0xcf, 0x00);
 	cx24117_writereg(state, 0xe5, 0x04);
 
-	/* Firmware CMD 35: Get firmware version */
-	cmd.args[0] = CMD_UPDFWVERS;
+	/* Get firmware version */
+	cmd.args[0] = CMD_FWVERSION;
 	cmd.len = 2;
 	for (i = 0; i < 4; i++) {
 		cmd.args[1] = i;
@@ -779,8 +797,8 @@ static int cx24117_read_signal_strength(struct dvb_frontend *fe,
 	u8 reg = (state->demod == 0) ?
 		CX24117_REG_SSTATUS0 : CX24117_REG_SSTATUS1;
 
-	/* Firmware CMD 1A */
-	cmd.args[0] = 0x1a;
+	/* Read AGC accumulator register */
+	cmd.args[0] = CMD_GET_AGCACC;
 	cmd.args[1] = (u8) state->demod;
 	cmd.len = 2;
 	ret = cx24117_cmd_execute(fe, &cmd);
@@ -899,8 +917,8 @@ static int cx24117_set_voltage(struct dvb_frontend *fe,
 		voltage == SEC_VOLTAGE_18 ? "SEC_VOLTAGE_18" :
 		"SEC_VOLTAGE_OFF");
 
-	/* CMD 32 */
-	cmd.args[0] = 0x32;
+	/* Set GPIO direction */
+	cmd.args[0] = CMD_SET_GPIODIR;
 	cmd.args[1] = reg;
 	cmd.args[2] = reg;
 	cmd.len = 3;
@@ -910,8 +928,8 @@ static int cx24117_set_voltage(struct dvb_frontend *fe,
 
 	if ((voltage == SEC_VOLTAGE_13) ||
 	    (voltage == SEC_VOLTAGE_18)) {
-		/* CMD 33 */
-		cmd.args[0] = 0x33;
+		/* Set GPIO logic level */
+		cmd.args[0] = CMD_SET_GPIOOUT;
 		cmd.args[1] = reg;
 		cmd.args[2] = reg;
 		cmd.len = 3;
@@ -926,7 +944,7 @@ static int cx24117_set_voltage(struct dvb_frontend *fe,
 		/* Wait for voltage/min repeat delay */
 		msleep(100);
 
-		/* CMD 22 - CMD_LNBDCLEVEL */
+		/* Set 13V/18V select pin */
 		cmd.args[0] = CMD_LNBDCLEVEL;
 		cmd.args[1] = state->demod ? 0 : 1;
 		cmd.args[2] = (voltage == SEC_VOLTAGE_18 ? 0x01 : 0x00);
@@ -935,7 +953,7 @@ static int cx24117_set_voltage(struct dvb_frontend *fe,
 		/* Min delay time before DiSEqC send */
 		msleep(20);
 	} else {
-		cmd.args[0] = 0x33;
+		cmd.args[0] = CMD_SET_GPIOOUT;
 		cmd.args[1] = 0x00;
 		cmd.args[2] = reg;
 		cmd.len = 3;
@@ -968,8 +986,7 @@ static int cx24117_set_tone(struct dvb_frontend *fe,
 	msleep(20);
 
 	/* Set the tone */
-	/* CMD 23 - CMD_SET_TONE */
-	cmd.args[0] = CMD_SET_TONE;
+	cmd.args[0] = CMD_LNBPCBCONFIG;
 	cmd.args[1] = (state->demod ? 0 : 1);
 	cmd.args[2] = 0x00;
 	cmd.args[3] = 0x00;
@@ -1231,8 +1248,8 @@ static int cx24117_initfe(struct dvb_frontend *fe)
 
 	mutex_lock(&state->priv->fe_lock);
 
-	/* Firmware CMD 36: Power config */
-	cmd.args[0] = CMD_TUNERSLEEP;
+	/* Set sleep mode off */
+	cmd.args[0] = CMD_SET_SLEEPMODE;
 	cmd.args[1] = (state->demod ? 1 : 0);
 	cmd.args[2] = 0;
 	cmd.len = 3;
@@ -1244,8 +1261,8 @@ static int cx24117_initfe(struct dvb_frontend *fe)
 	if (ret != 0)
 		goto exit;
 
-	/* CMD 3C */
-	cmd.args[0] = 0x3c;
+	/* Set BER control */
+	cmd.args[0] = CMD_BERCTRL;
 	cmd.args[1] = (state->demod ? 1 : 0);
 	cmd.args[2] = 0x10;
 	cmd.args[3] = 0x10;
@@ -1254,8 +1271,8 @@ static int cx24117_initfe(struct dvb_frontend *fe)
 	if (ret != 0)
 		goto exit;
 
-	/* CMD 34 */
-	cmd.args[0] = 0x34;
+	/* Set RS correction (enable/disable) */
+	cmd.args[0] = CMD_ENABLERSCORR;
 	cmd.args[1] = (state->demod ? 1 : 0);
 	cmd.args[2] = CX24117_OCC;
 	cmd.len = 3;
@@ -1278,8 +1295,8 @@ static int cx24117_sleep(struct dvb_frontend *fe)
 	dev_dbg(&state->priv->i2c->dev, "%s() demod%d\n",
 		__func__, state->demod);
 
-	/* Firmware CMD 36: Power config */
-	cmd.args[0] = CMD_TUNERSLEEP;
+	/* Set sleep mode on */
+	cmd.args[0] = CMD_SET_SLEEPMODE;
 	cmd.args[1] = (state->demod ? 1 : 0);
 	cmd.args[2] = 1;
 	cmd.len = 3;
@@ -1558,7 +1575,8 @@ static int cx24117_get_frontend(struct dvb_frontend *fe)
 
 	u8 buf[0x1f-4];
 
-	cmd.args[0] = 0x1c;
+	/* Read current tune parameters */
+	cmd.args[0] = CMD_GETCTLACC;
 	cmd.args[1] = (u8) state->demod;
 	cmd.len = 2;
 	ret = cx24117_cmd_execute(fe, &cmd);
-- 
1.8.3.2

