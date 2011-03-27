Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33644 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab1C0BAf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2011 21:00:35 -0400
Received: by wwa36 with SMTP id 36so2595676wwa.1
        for <linux-media@vger.kernel.org>; Sat, 26 Mar 2011 18:00:34 -0700 (PDT)
Subject: [PATCH 1/2] STV0299 incorrect standby setting issues register 02
 (MCR)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Mar 2011 00:57:33 +0000
Message-ID: <1301187453.2179.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Issues with Register 02 causing spurious channel locking from standby.
Should have always bits 4 & 5 written to 1.
Lower nibble not used in any current driver. Usage if necessary can be applied
through initab to mcr_reg.
stv0299 not out of standby before writing inittab.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/stv0299.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0299.c b/drivers/media/dvb/frontends/stv0299.c
index 4e3db3a..42684be 100644
--- a/drivers/media/dvb/frontends/stv0299.c
+++ b/drivers/media/dvb/frontends/stv0299.c
@@ -64,6 +64,7 @@ struct stv0299_state {
 	fe_code_rate_t fec_inner;
 	int errmode;
 	u32 ucblocks;
+	u8 mcr_reg;
 };
 
 #define STATUS_BER 0
@@ -457,6 +458,9 @@ static int stv0299_init (struct dvb_frontend* fe)
 
 	dprintk("stv0299: init chip\n");
 
+	stv0299_writeregI(state, 0x02, 0x30 | state->mcr_reg);
+	msleep(50);
+
 	for (i = 0; ; i += 2)  {
 		reg = state->config->inittab[i];
 		val = state->config->inittab[i+1];
@@ -464,6 +468,8 @@ static int stv0299_init (struct dvb_frontend* fe)
 			break;
 		if (reg == 0x0c && state->config->op0_off)
 			val &= ~0x10;
+		if (reg == 0x2)
+			state->mcr_reg = val & 0xf;
 		stv0299_writeregI(state, reg, val);
 	}
 
@@ -618,7 +624,7 @@ static int stv0299_sleep(struct dvb_frontend* fe)
 {
 	struct stv0299_state* state = fe->demodulator_priv;
 
-	stv0299_writeregI(state, 0x02, 0x80);
+	stv0299_writeregI(state, 0x02, 0xb0 | state->mcr_reg);
 	state->initialised = 0;
 
 	return 0;
@@ -680,7 +686,7 @@ struct dvb_frontend* stv0299_attach(const struct stv0299_config* config,
 	state->errmode = STATUS_BER;
 
 	/* check if the demod is there */
-	stv0299_writeregI(state, 0x02, 0x34); /* standby off */
+	stv0299_writeregI(state, 0x02, 0x30); /* standby off */
 	msleep(200);
 	id = stv0299_readreg(state, 0x00);
 
-- 
1.7.4.1


