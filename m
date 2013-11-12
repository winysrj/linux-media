Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62089 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3KLP7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Nov 2013 10:59:46 -0500
Received: by mail-wg0-f44.google.com with SMTP id k14so4458199wgh.11
        for <linux-media@vger.kernel.org>; Tue, 12 Nov 2013 07:59:45 -0800 (PST)
From: Luis Alves <ljalvs@gmail.com>
To: linux-media@vger.kernel.org
Cc: mkrufky@linuxtv.org, mchehab@infradead.org,
	pboettcher@kernellabs.com, ljalvs@gmail.com
Subject: [PATCH 2/2] cx24117: Fix LNB set_voltage function.
Date: Tue, 12 Nov 2013 15:59:40 +0000
Message-Id: <1384271980-23867-1-git-send-email-ljalvs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
This patch should fix/enhance the set_voltage function for the cx24117 demod.

Regards,
Luis

Signed-off-by: Luis Alves <ljalvs@gmail.com>
---
 drivers/media/dvb-frontends/cx24117.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index a6fe1af..68f768a 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -917,22 +917,15 @@ static int cx24117_set_voltage(struct dvb_frontend *fe,
 		voltage == SEC_VOLTAGE_18 ? "SEC_VOLTAGE_18" :
 		"SEC_VOLTAGE_OFF");
 
-	/* Set GPIO direction */
-	cmd.args[0] = CMD_SET_GPIODIR;
-	cmd.args[1] = reg;
-	cmd.args[2] = reg;
+	/* Prepare a set GPIO logic level CMD */
+	cmd.args[0] = CMD_SET_GPIOOUT;
+	cmd.args[2] = reg; /* mask */
 	cmd.len = 3;
-	ret = cx24117_cmd_execute(fe, &cmd);
-	if (ret)
-		return ret;
 
 	if ((voltage == SEC_VOLTAGE_13) ||
 	    (voltage == SEC_VOLTAGE_18)) {
-		/* Set GPIO logic level */
-		cmd.args[0] = CMD_SET_GPIOOUT;
+		/* power on LNB */
 		cmd.args[1] = reg;
-		cmd.args[2] = reg;
-		cmd.len = 3;
 		ret = cx24117_cmd_execute(fe, &cmd);
 		if (ret != 0)
 			return ret;
@@ -949,17 +942,17 @@ static int cx24117_set_voltage(struct dvb_frontend *fe,
 		cmd.args[1] = state->demod ? 0 : 1;
 		cmd.args[2] = (voltage == SEC_VOLTAGE_18 ? 0x01 : 0x00);
 		cmd.len = 3;
+		ret = cx24117_cmd_execute(fe, &cmd);
 
 		/* Min delay time before DiSEqC send */
 		msleep(20);
 	} else {
-		cmd.args[0] = CMD_SET_GPIOOUT;
+		/* power off LNB */
 		cmd.args[1] = 0x00;
-		cmd.args[2] = reg;
-		cmd.len = 3;
+		ret = cx24117_cmd_execute(fe, &cmd);
 	}
 
-	return cx24117_cmd_execute(fe, &cmd);
+	return ret;
 }
 
 static int cx24117_set_tone(struct dvb_frontend *fe,
@@ -1277,6 +1270,16 @@ static int cx24117_initfe(struct dvb_frontend *fe)
 	cmd.args[2] = CX24117_OCC;
 	cmd.len = 3;
 	ret = cx24117_cmd_execute_nolock(fe, &cmd);
+	if (ret != 0)
+		goto exit;
+
+	/* Set GPIO direction */
+	/* Set as output - controls LNB power on/off */
+	cmd.args[0] = CMD_SET_GPIODIR;
+	cmd.args[1] = 0x30;
+	cmd.args[2] = 0x30;
+	cmd.len = 3;
+	ret = cx24117_cmd_execute_nolock(fe, &cmd);
 
 exit:
 	mutex_unlock(&state->priv->fe_lock);
-- 
1.8.3.2

