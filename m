Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:47550 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab0IJNca (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 09:32:30 -0400
Date: Fri, 10 Sep 2010 15:32:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Steven Toth <stoth@kernellabs.com>
Subject: [PATCH 2/5] cx22702: Drop useless initializations to 0
Message-ID: <20100910153221.0a8e0d5f@hyperion.delvare>
In-Reply-To: <20100910151943.103f7423@hyperion.delvare>
References: <20100910151943.103f7423@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

These variables are either unconditionally set right afterward, or
already set to 0 by kzalloc.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Steven Toth <stoth@kernellabs.com>
---
 drivers/media/dvb/frontends/cx22702.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.32-rc5.orig/drivers/media/dvb/frontends/cx22702.c	2009-10-17 14:01:34.000000000 +0200
+++ linux-2.6.32-rc5/drivers/media/dvb/frontends/cx22702.c	2009-10-17 14:23:48.000000000 +0200
@@ -508,7 +508,7 @@ static int cx22702_read_signal_strength(
 {
 	struct cx22702_state *state = fe->demodulator_priv;
 
-	u16 rs_ber = 0;
+	u16 rs_ber;
 	rs_ber = cx22702_readreg(state, 0x23);
 	*signal_strength = (rs_ber << 8) | rs_ber;
 
@@ -519,7 +519,7 @@ static int cx22702_read_snr(struct dvb_f
 {
 	struct cx22702_state *state = fe->demodulator_priv;
 
-	u16 rs_ber = 0;
+	u16 rs_ber;
 	if (cx22702_readreg(state, 0xE4) & 0x02) {
 		/* Realtime statistics */
 		rs_ber = (cx22702_readreg(state, 0xDE) & 0x7F) << 7
@@ -590,7 +590,6 @@ struct dvb_frontend *cx22702_attach(cons
 	/* setup the state */
 	state->config = config;
 	state->i2c = i2c;
-	state->prevUCBlocks = 0;
 
 	/* check if the demod is there */
 	if (cx22702_readreg(state, 0x1f) != 0x3)

-- 
Jean Delvare
