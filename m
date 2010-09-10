Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:3823 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab0IJNdu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 09:33:50 -0400
Date: Fri, 10 Sep 2010 15:33:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Steven Toth <stoth@kernellabs.com>
Subject: [PATCH 3/5] cx22702: Avoid duplicating code in branches
Message-ID: <20100910153342.62f90f73@hyperion.delvare>
In-Reply-To: <20100910151943.103f7423@hyperion.delvare>
References: <20100910151943.103f7423@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Calling the same functions in if/else or switch/case branches is
inefficient. Refactor the code for a smaller binary and increased
readability.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Steven Toth <stoth@kernellabs.com>
---
 drivers/media/dvb/frontends/cx22702.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- linux-2.6.32-rc5.orig/drivers/media/dvb/frontends/cx22702.c	2009-10-24 16:12:18.000000000 +0200
+++ linux-2.6.32-rc5/drivers/media/dvb/frontends/cx22702.c	2009-10-24 16:27:04.000000000 +0200
@@ -128,19 +128,20 @@ static int cx22702_set_inversion(struct
 {
 	u8 val;
 
+	val = cx22702_readreg(state, 0x0C);
 	switch (inversion) {
 	case INVERSION_AUTO:
 		return -EOPNOTSUPP;
 	case INVERSION_ON:
-		val = cx22702_readreg(state, 0x0C);
-		return cx22702_writereg(state, 0x0C, val | 0x01);
+		val |= 0x01;
+		break;
 	case INVERSION_OFF:
-		val = cx22702_readreg(state, 0x0C);
-		return cx22702_writereg(state, 0x0C, val & 0xfe);
+		val &= 0xfe;
+		break;
 	default:
 		return -EINVAL;
 	}
-
+	return cx22702_writereg(state, 0x0C, val);
 }
 
 /* Retrieve the demod settings */
@@ -247,13 +248,15 @@ static int cx22702_get_tps(struct cx2270
 static int cx22702_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct cx22702_state *state = fe->demodulator_priv;
+	u8 val;
+
 	dprintk("%s(%d)\n", __func__, enable);
+	val = cx22702_readreg(state, 0x0D);
 	if (enable)
-		return cx22702_writereg(state, 0x0D,
-			cx22702_readreg(state, 0x0D) & 0xfe);
+		val &= 0xfe;
 	else
-		return cx22702_writereg(state, 0x0D,
-			cx22702_readreg(state, 0x0D) | 1);
+		val |= 0x01;
+	return cx22702_writereg(state, 0x0D, val);
 }
 
 /* Talk to the demod, set the FEC, GUARD, QAM settings etc */
@@ -273,23 +276,21 @@ static int cx22702_set_tps(struct dvb_fr
 	cx22702_set_inversion(state, p->inversion);
 
 	/* set bandwidth */
+	val = cx22702_readreg(state, 0x0C) & 0xcf;
 	switch (p->u.ofdm.bandwidth) {
 	case BANDWIDTH_6_MHZ:
-		cx22702_writereg(state, 0x0C,
-			(cx22702_readreg(state, 0x0C) & 0xcf) | 0x20);
+		val |= 0x20;
 		break;
 	case BANDWIDTH_7_MHZ:
-		cx22702_writereg(state, 0x0C,
-			(cx22702_readreg(state, 0x0C) & 0xcf) | 0x10);
+		val |= 0x10;
 		break;
 	case BANDWIDTH_8_MHZ:
-		cx22702_writereg(state, 0x0C,
-			cx22702_readreg(state, 0x0C) & 0xcf);
 		break;
 	default:
 		dprintk("%s: invalid bandwidth\n", __func__);
 		return -EINVAL;
 	}
+	cx22702_writereg(state, 0x0C, val);
 
 	p->u.ofdm.code_rate_LP = FEC_AUTO; /* temp hack as manual not working */
 

-- 
Jean Delvare
