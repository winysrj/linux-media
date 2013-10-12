Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:53087 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab3JLIyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 04:54:52 -0400
Received: by mail-we0-f179.google.com with SMTP id w61so5270216wes.10
        for <linux-media@vger.kernel.org>; Sat, 12 Oct 2013 01:54:51 -0700 (PDT)
From: Luis Alves <ljalvs@gmail.com>
To: mkrufky@linuxtv.org
Cc: crope@iki.fi, linux-media@vger.kernel.org, mchehab@infradead.org,
	Luis Alves <ljalvs@gmail.com>
Subject: [PATCH] cx24117: Fix/enhance set_voltage function.
Date: Sat, 12 Oct 2013 09:54:45 +0100
Message-Id: <1381568085-2407-1-git-send-email-ljalvs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On this patch:
Added a few defines to describe what every constant in the set_voltage function.
Added the description to the CX24117 GPIO control commands.
Moved the GPIODIR setup to the initfe function.

Regards,
Luis


Signed-off-by: Luis Alves <ljalvs@gmail.com>
---
 drivers/media/dvb-frontends/cx24117.c |   60 +++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index 476b422..3c7523b 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -129,6 +129,14 @@
 #define CX24117_DISEQC_MINI_A (0)
 #define CX24117_DISEQC_MINI_B (1)
 
+/* LNB voltage enable GPIO pins */
+#define CX24117_DEMOD0_LNBDCPIN (1 << 4)
+#define CX24117_DEMOD1_LNBDCPIN (1 << 5)
+
+/* Demod to LNB mapping */
+#define CX24117_DEMOD0_LNB	(1)
+#define CX24117_DEMOD1_LNB	(0)
+
 
 #define CX24117_PNE	(0) /* 0 disabled / 2 enabled */
 #define CX24117_OCC	(1) /* 0 disabled / 1 enabled */
@@ -142,6 +150,8 @@ enum cmds {
 	CMD_LNBSEND     = 0x21, /* Formerly CMD_SEND_DISEQC */
 	CMD_LNBDCLEVEL  = 0x22,
 	CMD_SET_TONE    = 0x23,
+	CMD_GPIODIR	= 0x32,
+	CMD_GPIOOUT	= 0x33,
 	CMD_UPDFWVERS   = 0x35,
 	CMD_TUNERSLEEP  = 0x36,
 };
@@ -891,7 +901,8 @@ static int cx24117_set_voltage(struct dvb_frontend *fe,
 	struct cx24117_state *state = fe->demodulator_priv;
 	struct cx24117_cmd cmd;
 	int ret;
-	u8 reg = (state->demod == 0) ? 0x10 : 0x20;
+	u8 pin = (state->demod == 0) ?
+		CX24117_DEMOD0_LNBDCPIN : CX24117_DEMOD1_LNBDCPIN;
 
 	dev_dbg(&state->priv->i2c->dev, "%s() demod%d %s\n",
 		__func__, state->demod,
@@ -899,26 +910,18 @@ static int cx24117_set_voltage(struct dvb_frontend *fe,
 		voltage == SEC_VOLTAGE_18 ? "SEC_VOLTAGE_18" :
 		"SEC_VOLTAGE_OFF");
 
-	/* CMD 32 */
-	cmd.args[0] = 0x32;
-	cmd.args[1] = reg;
-	cmd.args[2] = reg;
-	cmd.len = 3;
-	ret = cx24117_cmd_execute(fe, &cmd);
-	if (ret)
-		return ret;
-
 	if ((voltage == SEC_VOLTAGE_13) ||
 	    (voltage == SEC_VOLTAGE_18)) {
-		/* CMD 33 */
-		cmd.args[0] = 0x33;
-		cmd.args[1] = reg;
-		cmd.args[2] = reg;
+		/* Turn on LNB DC voltage */
+		cmd.args[0] = CMD_GPIOOUT;
+		cmd.args[1] = pin;	/* level */
+		cmd.args[2] = pin;	/* mask */
 		cmd.len = 3;
 		ret = cx24117_cmd_execute(fe, &cmd);
 		if (ret != 0)
 			return ret;
 
+		/* Wait for any pending diseqc TX */
 		ret = cx24117_wait_for_lnb(fe);
 		if (ret != 0)
 			return ret;
@@ -926,22 +929,25 @@ static int cx24117_set_voltage(struct dvb_frontend *fe,
 		/* Wait for voltage/min repeat delay */
 		msleep(100);
 
-		/* CMD 22 - CMD_LNBDCLEVEL */
+		/* Set DC level (0=13V 1=18V) */
 		cmd.args[0] = CMD_LNBDCLEVEL;
-		cmd.args[1] = state->demod ? 0 : 1;
-		cmd.args[2] = (voltage == SEC_VOLTAGE_18 ? 0x01 : 0x00);
+		cmd.args[1] = (state->demod == 0) ?
+			CX24117_DEMOD0_LNB : CX24117_DEMOD1_LNB;
+		cmd.args[2] = (voltage == SEC_VOLTAGE_18 ? 1 : 0);
 		cmd.len = 3;
+		ret = cx24117_cmd_execute(fe, &cmd);
 
 		/* Min delay time before DiSEqC send */
 		msleep(20);
 	} else {
-		cmd.args[0] = 0x33;
-		cmd.args[1] = 0x00;
-		cmd.args[2] = reg;
+		/* Turn off LNB DC voltage */
+		cmd.args[0] = CMD_GPIOOUT;
+		cmd.args[1] = 0;	/* level */
+		cmd.args[2] = pin;	/* mask */
 		cmd.len = 3;
+		ret = cx24117_cmd_execute(fe, &cmd);
 	}
-
-	return cx24117_cmd_execute(fe, &cmd);
+	return ret;
 }
 
 static int cx24117_set_tone(struct dvb_frontend *fe,
@@ -1260,6 +1266,16 @@ static int cx24117_initfe(struct dvb_frontend *fe)
 	cmd.args[2] = CX24117_OCC;
 	cmd.len = 3;
 	ret = cx24117_cmd_execute_nolock(fe, &cmd);
+	if (ret != 0)
+		goto exit;
+
+	/* Setup cx24117 GPIO direction */
+	/* These pins turn on/off LNB DC voltage */
+	cmd.args[0] = CMD_GPIODIR;
+	cmd.args[1] = CX24117_DEMOD0_LNBDCPIN | CX24117_DEMOD1_LNBDCPIN;
+	cmd.args[2] = CX24117_DEMOD0_LNBDCPIN | CX24117_DEMOD1_LNBDCPIN;
+	cmd.len = 3;
+	ret = cx24117_cmd_execute_nolock(fe, &cmd);
 
 exit:
 	mutex_unlock(&state->priv->fe_lock);
-- 
1.7.9.5

