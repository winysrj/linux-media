Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51095 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbeBISWy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 13:22:54 -0500
Received: by mail-wm0-f68.google.com with SMTP id f71so16948501wmf.0
        for <linux-media@vger.kernel.org>; Fri, 09 Feb 2018 10:22:53 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: post@helmutauer.de, rascobie@slingshot.co.nz,
        d_spingler@freenet.de, Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH] [media] dvb-frontends/stv0910: rework and fix DiSEqC send
Date: Fri,  9 Feb 2018 19:22:49 +0100
Message-Id: <20180209182249.11896-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Rework both DiSEqC send functions (send_master_cmd() and send_burst()) to
utilise the new SET_REG() and SET_FIELD() macros. Esp. due to SET_FIELD(),
this makes sure that not all bits (with unrelated purposes) are always
rewritten, but only those needed for sending DiSEqC commands. In
send_burst(), this makes sure that DISEQC_MODE isn't changed from 3 to 2
inbetween when sending SEC_MINI_A. Also, change both functions to write
DISEQC_MODE first before setting DIS_PRECHARGE. This makes diseqc control
work more reliable for "fullblown" DiSEqC strings in VDR's diseqc.conf in
combination with certain multiswitches.

Fixes: 448461af0e19 ("media: dvb-frontends/stv0910: implement diseqc_send_burst")

Reported-by: Helmut Auer <post@helmutauer.de>
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Helmut Auer <post@helmutauer.de>
Tested-by: Richard Scobie <rascobie@slingshot.co.nz>
Tested-by: Dietmar Spingler <d_spingler@freenet.de>
---
 drivers/media/dvb-frontends/stv0910.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index a2f7c0c1587f..52355c14fd64 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1673,15 +1673,15 @@ static int send_master_cmd(struct dvb_frontend *fe,
 			   struct dvb_diseqc_master_cmd *cmd)
 {
 	struct stv *state = fe->demodulator_priv;
-	u16 offs = state->nr ? 0x40 : 0;
 	int i;
 
-	write_reg(state, RSTV0910_P1_DISTXCFG + offs, 0x3E);
+	SET_FIELD(DISEQC_MODE, 2);
+	SET_FIELD(DIS_PRECHARGE, 1);
 	for (i = 0; i < cmd->msg_len; i++) {
 		wait_dis(state, 0x40, 0x00);
-		write_reg(state, RSTV0910_P1_DISTXFIFO + offs, cmd->msg[i]);
+		SET_REG(DISTXFIFO, cmd->msg[i]);
 	}
-	write_reg(state, RSTV0910_P1_DISTXCFG + offs, 0x3A);
+	SET_FIELD(DIS_PRECHARGE, 0);
 	wait_dis(state, 0x20, 0x20);
 	return 0;
 }
@@ -1689,19 +1689,20 @@ static int send_master_cmd(struct dvb_frontend *fe,
 static int send_burst(struct dvb_frontend *fe, enum fe_sec_mini_cmd burst)
 {
 	struct stv *state = fe->demodulator_priv;
-	u16 offs = state->nr ? 0x40 : 0;
 	u8 value;
 
 	if (burst == SEC_MINI_A) {
-		write_reg(state, RSTV0910_P1_DISTXCFG + offs, 0x3F);
+		SET_FIELD(DISEQC_MODE, 3);
 		value = 0x00;
 	} else {
-		write_reg(state, RSTV0910_P1_DISTXCFG + offs, 0x3E);
+		SET_FIELD(DISEQC_MODE, 2);
 		value = 0xFF;
 	}
+
+	SET_FIELD(DIS_PRECHARGE, 1);
 	wait_dis(state, 0x40, 0x00);
-	write_reg(state, RSTV0910_P1_DISTXFIFO + offs, value);
-	write_reg(state, RSTV0910_P1_DISTXCFG + offs, 0x3A);
+	SET_REG(DISTXFIFO, value);
+	SET_FIELD(DIS_PRECHARGE, 0);
 	wait_dis(state, 0x20, 0x20);
 
 	return 0;
-- 
2.13.6
