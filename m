Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33576 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab3LOODT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Dec 2013 09:03:19 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Olivier GRENIE <olivier.grenie@parrot.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/3] [media] dib8000: Don't let tuner hang due to a call to get_frontend()
Date: Sun, 15 Dec 2013 09:00:10 -0200
Message-Id: <1387105210-6893-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1387105210-6893-1-git-send-email-m.chehab@samsung.com>
References: <1387105210-6893-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both dvbv5-scan and dvbv5-zap tools call FE_GET_PROPERTY inside the
loop that checks for stats. If the frontend doesn't support DVBv5, it
falls back to call the DVBv5 stats APIs(FE_READ_BER, FE_READ_SIGNAL,
FE_READ_SNR and FE_READ_UNCORRECTED_BLOCKS).

A call to FE_GET_PROPERTY makes dvb-frontend core to call get_frontend().

However, due to a race condition on dib8000 between dib8000_get_frontend
and dib8000_tune, if get_frontend occurs too early, it causes the
tune state machine to fail and not get any lock.

This patch adds a workaround code that makes get_frontend() to just
return if none of the frontends have a SYNC. This change fixed the issue
with dvbv5-scan/dvbv5-zap, but a fine-tuned logic might be needed in
the future, when we implement DVBv5 stats on this frontend.

The procedure to test the bug and the fix is the one below:

1) tune into a non-existing frequency with:

	$ dvbv5-zap -I dvbv5 -c non_existing_freqs -m 679142857 -t3

2) tune/lock into an existing frequency with:

	$ dvbv5-zap -I dvbv5 -c isdb-test -m 479142857
    or
	$ dvbv5-scan isdb-test

In this case, 679 MHz carrier doesn't exist. Only 479 MHz does.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 36c839cabe82..063232afecd6 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -3276,15 +3276,27 @@ static int dib8000_sleep(struct dvb_frontend *fe)
 	return dib8000_set_adc_state(state, DIBX000_SLOW_ADC_OFF) | dib8000_set_adc_state(state, DIBX000_ADC_OFF);
 }
 
+static int dib8000_read_status(struct dvb_frontend *fe, fe_status_t * stat);
+
 static int dib8000_get_frontend(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	u16 i, val = 0;
-	fe_status_t stat;
+	fe_status_t stat = 0;
 	u8 index_frontend, sub_index_frontend;
 
 	fe->dtv_property_cache.bandwidth_hz = 6000000;
 
+	/*
+	 * If called to early, get_frontend makes dib8000_tune to either
+	 * not lock or not sync. This causes dvbv5-scan/dvbv5-zap to fail.
+	 * So, let's just return if frontend 0 has not locked.
+	 */
+	dib8000_read_status(fe, &stat);
+	if (!(stat & FE_HAS_SYNC))
+		return 0;
+
+	dprintk("TMCC lock");
 	for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
 		state->fe[index_frontend]->ops.read_status(state->fe[index_frontend], &stat);
 		if (stat&FE_HAS_SYNC) {
-- 
1.8.3.1

