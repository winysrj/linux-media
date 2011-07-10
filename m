Return-path: <mchehab@localhost>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37109 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab1GJWW1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 18:22:27 -0400
Received: by wyg8 with SMTP id 8so2239533wyg.19
        for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 15:22:26 -0700 (PDT)
Subject: [PATCH] STV0288 frontend provide wider carrier search and DVB-S2
 drop out.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: 'Linux Media Mailing List' <linux-media@vger.kernel.org>
Cc: 'Oliver Endriss' <o.endriss@gmx.de>,
	=?ISO-8859-1?Q?S=E9bastien?= "RAILLARD (COEXSI)" <sr@coexsi.fr>
In-Reply-To: <1309984524.6358.18.camel@localhost>
References: <00a301cc365e$b6d415c0$247c4140$@coexsi.fr>
	 <201107040043.00393@orion.escape-edv.de>
	 <007201cc3bd0$a1b4aa70$e51dff50$@coexsi.fr>
	 <1309984524.6358.18.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jul 2011 23:22:17 +0100
Message-ID: <1310336537.2472.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Wed, 2011-07-06 at 21:35 +0100, Malcolm Priestley wrote:
> On Wed, 2011-07-06 at 13:34 +0200, Sébastien RAILLARD (COEXSI) wrote:
> > 
> > > -----Original Message-----
> > > From: Oliver Endriss [mailto:o.endriss@gmx.de]
> > > Sent: lundi 4 juillet 2011 00:43
> > > To: Linux Media Mailing List
> > > Cc: Sébastien RAILLARD (COEXSI); Malcolm Priestley
> > > Subject: Re: [DVB] TT S-1500b tuning issue
> > > 
> > > On Wednesday 29 June 2011 15:16:10 Sébastien RAILLARD wrote:
> > > > Dear all,
> > > >
> > > > We have found what seems to be a tuning issue in the driver for the
> > > > ALPS BSBE1-D01A used in the new TT-S-1500b card from Technotrend.
> > > > On some transponders, like ASTRA 19.2E 11817-V-27500, the card can
> > > > work very well (no lock issues) for hours.
> > > >
> > > > On some other transponders, like ASTRA 19.2E 11567-V-22000, the card
> > > > nearly never manage to get the lock: it's looking like the signal
> > > > isn't good enough.
> > > 
> > > Afaics the problem is caused by the tuning loop
> > >     for (tm = -6; tm < 7;)
> > > in stv0288_set_frontend().
> > > 
> > > I doubt that this code works reliably.
> > > Apparently it never obtains a lock within the given delay (30us).
> It's actually quite slow caused by any delay in the I2C bus. I doubt
> given the age many controllers run at the 400kHz spec, if barely 100kHz.
> 
> > > 
> > > Could you please try the attached patch?
> > > It disables the loop and tries to tune to the center frequency.
> > > 
> > 
> > Ok, I've tested this patch with ASTRA 19.2 #24 transponder that wasn't
> > always working: it seems to work.
> > I think it would be great to test it for few days more to be sure.
> 
> Unfortunately, this patch does not work well at all.
> 
> All that is happening is that the carrier offset is getting forced to 0,
> after it has been updated by the lock control register losing a 'good'
> lock.
> 
> The value is typically around ~f800+.
> 
> Perhaps the loop should be knocked down slightly to -9. The loop was
> probably intended for 22000 symbol rate.

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
 drivers/media/dvb/frontends/stv0288.c |   29
+++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0288.c
b/drivers/media/dvb/frontends/stv0288.c
index 8e0cfad..0aa3962 100644
--- a/drivers/media/dvb/frontends/stv0288.c
+++ b/drivers/media/dvb/frontends/stv0288.c
@@ -127,6 +127,11 @@ static int stv0288_set_symbolrate(struct
dvb_frontend *fe, u32 srate)
 	if ((srate < 1000000) || (srate > 45000000))
 		return -EINVAL;
 
+	stv0288_writeregI(state, 0x22, 0);
+	stv0288_writeregI(state, 0x23, 0);
+	stv0288_writeregI(state, 0x2b, 0xff);
+	stv0288_writeregI(state, 0x2c, 0xf7);
+
 	temp = (unsigned int)srate / 1000;
 
 		temp = temp * 32768;
@@ -461,6 +466,7 @@ static int stv0288_set_frontend(struct dvb_frontend
*fe,
 
 	char tm;
 	unsigned char tda[3];
+	u8 reg, time_out = 0;
 
 	dprintk("%s : FE_SET_FRONTEND\n", __func__);
 
@@ -488,22 +494,29 @@ static int stv0288_set_frontend(struct
dvb_frontend *fe,
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

