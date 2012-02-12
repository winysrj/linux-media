Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:40091 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab2BLTDR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Feb 2012 14:03:17 -0500
Date: Sun, 12 Feb 2012 20:03:03 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: [PATCH] cx22702: Fix signal strength
Message-ID: <20120212200303.04e6b316@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The signal strength value returned is not quite correct, it decreases
when I increase the gain of my antenna, and vice versa. It also
doesn't span over the whole 0x0000-0xffff range. Compute a value which
at least increases when signal strength increases, and spans the whole
allowed range.

In practice I get 67% with my antenna fully amplified and 51% with
no amplification. This is close enough to what I get on my other
DVB-T adapter with the same antenna.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Steven Toth <stoth@kernellabs.com>
---
This was written without a datasheet so this is essentially
guess work.

 drivers/media/dvb/frontends/cx22702.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- linux-3.3-rc3.orig/drivers/media/dvb/frontends/cx22702.c	2012-02-11 08:28:15.000000000 +0100
+++ linux-3.3-rc3/drivers/media/dvb/frontends/cx22702.c	2012-02-12 14:45:33.361921465 +0100
@@ -502,10 +502,26 @@ static int cx22702_read_signal_strength(
 	u16 *signal_strength)
 {
 	struct cx22702_state *state = fe->demodulator_priv;
+	u8 reg23;
 
-	u16 rs_ber;
-	rs_ber = cx22702_readreg(state, 0x23);
-	*signal_strength = (rs_ber << 8) | rs_ber;
+	/*
+	 * Experience suggests that the strength signal register works as
+	 * follows:
+	 * - In the absence of signal, value is 0xff.
+	 * - In the presence of a weak signal, bit 7 is set, not sure what
+	 *   the lower 7 bits mean.
+	 * - In the presence of a strong signal, the register holds a 7-bit
+	 *   value (bit 7 is cleared), with greater values standing for
+	 *   weaker signals.
+	 */
+	reg23 = cx22702_readreg(state, 0x23);
+	if (reg23 & 0x80) {
+		*signal_strength = 0;
+	} else {
+		reg23 = ~reg23 & 0x7f;
+		/* Scale to 16 bit */
+		*signal_strength = (reg23 << 9) | (reg23 << 2) | (reg23 >> 5);
+	}
 
 	return 0;
 }


-- 
Jean Delvare
