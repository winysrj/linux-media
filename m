Return-path: <mchehab@localhost>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41782 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1GJWhW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 18:37:22 -0400
Received: by wwg11 with SMTP id 11so1779057wwg.1
        for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 15:37:21 -0700 (PDT)
Subject: [PATCH] STV0288 frontend provide wider carrier search and DVB-S2
 drop out. resend
From: Malcolm Priestley <tvboxspy@gmail.com>
To: 'Linux Media Mailing List' <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jul 2011 23:37:13 +0100
Message-ID: <1310337433.2472.9.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

The following patch provides wider carrier search.

As with existing code search starts at MSB aligned. The boundary
is widened to start at -9.  In order to save time, if no carrier is
detected at the start it advances to the next alignment until carrier
is found.

The stv0288 will detect a DVB-S2 carrier on all steps , a
time out of 11 steps is introduced to drop out of the loop.

In stv0288_set_symbol carrier and timing loops are restored to
default values (inittab) before setting the symbol rate on each tune. A
slight drift was noticed with full scan in the higher IF frequencies of
each band.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/stv0288.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0288.c b/drivers/media/dvb/frontends/stv0288.c
index 8e0cfad..0aa3962 100644
--- a/drivers/media/dvb/frontends/stv0288.c
+++ b/drivers/media/dvb/frontends/stv0288.c
@@ -127,6 +127,11 @@ static int stv0288_set_symbolrate(struct dvb_frontend *fe, u32 srate)
 	if ((srate < 1000000) || (srate > 45000000))
 		return -EINVAL;
 
+	stv0288_writeregI(state, 0x22, 0);
+	stv0288_writeregI(state, 0x23, 0);
+	stv0288_writeregI(state, 0x2b, 0xff);
+	stv0288_writeregI(state, 0x2c, 0xf7);
+
 	temp = (unsigned int)srate / 1000;
 
 		temp = temp * 32768;
@@ -461,6 +466,7 @@ static int stv0288_set_frontend(struct dvb_frontend *fe,
 
 	char tm;
 	unsigned char tda[3];
+	u8 reg, time_out = 0;
 
 	dprintk("%s : FE_SET_FRONTEND\n", __func__);
 
@@ -488,22 +494,29 @@ static int stv0288_set_frontend(struct dvb_frontend *fe,
 	/* Carrier lock control register */
 	stv0288_writeregI(state, 0x15, 0xc5);
 
-	tda[0] = 0x2b; /* CFRM */
 	tda[2] = 0x0; /* CFRL */
-	for (tm = -6; tm < 7;) {
+	for (tm = -9; tm < 7;) {
 		/* Viterbi status */
-		if (stv0288_readreg(state, 0x24) & 0x8)
-			break;
-
-		tda[2] += 40;
-		if (tda[2] < 40)
+		reg = stv0288_readreg(state, 0x24);
+		if (reg & 0x8)
+				break;
+		if (reg & 0x80) {
+			time_out++;
+			if (time_out > 10)
+				break;
+			tda[2] += 40;
+			if (tda[2] < 40)
+				tm++;
+		} else {
 			tm++;
+			tda[2] = 0;
+			time_out = 0;
+		}
 		tda[1] = (unsigned char)tm;
 		stv0288_writeregI(state, 0x2b, tda[1]);
 		stv0288_writeregI(state, 0x2c, tda[2]);
 		udelay(30);
 	}
-
 	state->tuner_frequency = c->frequency;
 	state->fec_inner = FEC_AUTO;
 	state->symbol_rate = c->symbol_rate;
-- 
1.7.4.1

