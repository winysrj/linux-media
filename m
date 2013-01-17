Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433Ab3AQS7K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 13:59:10 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0HIxAl6027333
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 17 Jan 2013 13:59:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv11 12/16] [media] mb86a20s: Some improvements for BER measurement
Date: Thu, 17 Jan 2013 16:58:26 -0200
Message-Id: <1358449110-11203-12-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358449110-11203-1-git-send-email-mchehab@redhat.com>
References: <1358449110-11203-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reduce the bit count from 2^24-1 to 2^16-1 to speedup
BER measurement;
Do a per-layer reset, instead of waiting for data on all
layers;
Global stats now start to appear as soon as the first layer
(e. g. the one with the biggest number of segments) start to
have collected data.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 52 +++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 6d4261e..6265003 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -86,16 +86,36 @@ static struct regdata mb86a20s_init[] = {
 	{ 0x04, 0x13 }, { 0x05, 0xff },
 	{ 0x04, 0x15 }, { 0x05, 0x4e },
 	{ 0x04, 0x16 }, { 0x05, 0x20 },
+
+	/*
+	 * On this demod, when the bit count reaches the count below,
+	 * it collects the bit error count.
+	 *
+	 * As FE thread runs on every 3 seconds, adjust the counters to
+	 * provide one collect before 3 seconds, at the worse case (DQPSK,
+	 * 1/4 guard interval, 1/2 FEC, 1-seg rate is 280 Mbps, and
+	 * 3 seconds takes 0xcdb9f bits. Rounds it down to 0xccfff
+	 *
+	 * It should be noticed, however, that, with QAM-64 1/32 guard interval,
+	 * 1 segment bit rate is 1.78 Mbps, and 12-seg is about 21.5 Mbps.
+	 * At such rate, the time to measure BER is about 40 ms.
+	 *
+	 * It makes sense to change the logic there to use TMCC parameters and
+	 * adjust the counters in order to have all of them to take a little
+	 * less than 3 seconds, in order to have a more realistic BER rate,
+	 * instead of having short samples for 12-segs.
+	 */
 	{ 0x52, 0x01 },				/* Turn on BER before Viterbi */
-	{ 0x50, 0xa7 }, { 0x51, 0xff },
-	{ 0x50, 0xa8 }, { 0x51, 0xff },
+	{ 0x50, 0xa7 }, { 0x51, 0x0c },
+	{ 0x50, 0xa8 }, { 0x51, 0xcf },
 	{ 0x50, 0xa9 }, { 0x51, 0xff },
-	{ 0x50, 0xaa }, { 0x51, 0xff },
-	{ 0x50, 0xab }, { 0x51, 0xff },
+	{ 0x50, 0xaa }, { 0x51, 0x0c },
+	{ 0x50, 0xab }, { 0x51, 0xcf },
 	{ 0x50, 0xac }, { 0x51, 0xff },
-	{ 0x50, 0xad }, { 0x51, 0xff },
-	{ 0x50, 0xae }, { 0x51, 0xff },
+	{ 0x50, 0xad }, { 0x51, 0x0c },
+	{ 0x50, 0xae }, { 0x51, 0xcf },
 	{ 0x50, 0xaf }, { 0x51, 0xff },
+
 	{ 0x5e, 0x07 },
 	{ 0x50, 0xdc }, { 0x51, 0x01 },
 	{ 0x50, 0xdd }, { 0x51, 0xf4 },
@@ -734,6 +754,14 @@ static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
 		"%s: bit count before Viterbi for layer %c: %d.\n",
 		__func__, 'A' + layer, *count);
 
+	/* Reset counter to collect new data */
+	rc = mb86a20s_writereg(state, 0x53, 0x07 & ~(1 << layer));
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_writereg(state, 0x53, 0x07);
+	if (rc < 0)
+		return rc;
+
 	return 0;
 }
 
@@ -823,7 +851,11 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 		}
 	}
 
-	if (active_layers == ber_layers) {
+	/*
+	 * Start showing global count if at least one error count is
+	 * available.
+	 */
+	if (ber_layers) {
 		/*
 		 * All BER values are read. We can now calculate the total BER
 		 * And ask for another BER measure
@@ -836,12 +868,6 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 		c->bit_count.stat[0].scale = FE_SCALE_COUNTER;
 		c->bit_count.stat[0].uvalue += t_bit_count;
 
-		/* Reset counters to collect new data */
-		rc = mb86a20s_writeregdata(state, mb86a20s_vber_reset);
-		if (rc < 0)
-			dev_err(&state->i2c->dev,
-				"%s: Can't reset VBER registers.\n", __func__);
-
 		/* All BER measures need to be collected when ready */
 		for (i = 0; i < 3; i++)
 			state->read_ber[i] = true;
-- 
1.7.11.7

