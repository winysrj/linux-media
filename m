Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab3CCP7A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Mar 2013 10:59:00 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r23Fx0Mr021701
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 3 Mar 2013 10:59:00 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/11] [media] mb86a20s: adjust IF based on what's set on the tuner
Date: Sun,  3 Mar 2013 12:58:42 -0300
Message-Id: <1362326331-17541-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
References: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of hardcoding a fixed IF frequency of 3.3 MHz, use
the IF frequency provided by the tuner driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 57 +++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 44bfb88..daeee81 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -31,6 +31,8 @@ struct mb86a20s_state {
 
 	struct dvb_frontend frontend;
 
+	u32 if_freq;
+
 	u32 estimated_rate[3];
 
 	bool need_init;
@@ -47,7 +49,7 @@ struct regdata {
  * Initialization sequence: Use whatevere default values that PV SBTVD
  * does on its initialisation, obtained via USB snoop
  */
-static struct regdata mb86a20s_init[] = {
+static struct regdata mb86a20s_init1[] = {
 	{ 0x70, 0x0f },
 	{ 0x70, 0xff },
 	{ 0x08, 0x01 },
@@ -56,7 +58,9 @@ static struct regdata mb86a20s_init[] = {
 	{ 0x39, 0x01 },
 	{ 0x71, 0x00 },
 	{ 0x28, 0x2a }, { 0x29, 0x00 }, { 0x2a, 0xff }, { 0x2b, 0x80 },
-	{ 0x28, 0x20 }, { 0x29, 0x33 }, { 0x2a, 0xdf }, { 0x2b, 0xa9 },
+};
+
+static struct regdata mb86a20s_init2[] = {
 	{ 0x28, 0x22 }, { 0x29, 0x00 }, { 0x2a, 0x1f }, { 0x2b, 0xf0 },
 	{ 0x3b, 0x21 },
 	{ 0x3c, 0x3a },
@@ -1737,6 +1741,7 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 static int mb86a20s_initfe(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
+	u64 pll;
 	int rc;
 	u8  regD5 = 1;
 
@@ -1746,10 +1751,35 @@ static int mb86a20s_initfe(struct dvb_frontend *fe)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
 	/* Initialize the frontend */
-	rc = mb86a20s_writeregdata(state, mb86a20s_init);
+	rc = mb86a20s_writeregdata(state, mb86a20s_init1);
 	if (rc < 0)
 		goto err;
 
+	/* Adjust IF frequency to match tuner */
+	if (fe->ops.tuner_ops.get_if_frequency)
+		fe->ops.tuner_ops.get_if_frequency(fe, &state->if_freq);
+
+	if (!state->if_freq)
+		state->if_freq = 3300000;
+
+	/* pll = freq[Hz] * 2^24/10^6 / 16.285714286 */
+	pll = state->if_freq * 1677721600L;
+	do_div(pll, 1628571429L);
+	rc = mb86a20s_writereg(state, 0x28, 0x20);
+	if (rc < 0)
+		goto err;
+	rc = mb86a20s_writereg(state, 0x29, (pll >> 16) & 0xff);
+	if (rc < 0)
+		goto err;
+	rc = mb86a20s_writereg(state, 0x2a, (pll >> 8) & 0xff);
+	if (rc < 0)
+		goto err;
+	rc = mb86a20s_writereg(state, 0x2b, pll & 0xff);
+	if (rc < 0)
+		goto err;
+	dev_dbg(&state->i2c->dev, "%s: IF=%d, PLL=0x%06llx\n",
+		__func__, state->if_freq, (long long)pll);
+
 	if (!state->config->is_serial) {
 		regD5 &= ~1;
 
@@ -1761,6 +1791,11 @@ static int mb86a20s_initfe(struct dvb_frontend *fe)
 			goto err;
 	}
 
+	rc = mb86a20s_writeregdata(state, mb86a20s_init2);
+	if (rc < 0)
+		goto err;
+
+
 err:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
@@ -1779,7 +1814,7 @@ err:
 static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
-	int rc;
+	int rc, if_freq;
 #if 0
 	/*
 	 * FIXME: Properly implement the set frontend properties
@@ -1796,6 +1831,18 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	fe->ops.tuner_ops.set_params(fe);
 
+	if (fe->ops.tuner_ops.get_if_frequency) {
+		fe->ops.tuner_ops.get_if_frequency(fe, &if_freq);
+
+		/*
+		 * If the IF frequency changed, re-initialize the
+		 * frontend. This is needed by some drivers like tda18271,
+		 * that only sets the IF after receiving a set_params() call
+		 */
+		if (if_freq != state->if_freq)
+			state->need_init = true;
+	}
+
 	/*
 	 * Make it more reliable: if, for some reason, the initial
 	 * device initialization doesn't happen, initialize it when
@@ -1805,6 +1852,8 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 	 * the agc callback logic is not called during DVB attach time,
 	 * causing mb86a20s to not be initialized with Kworld SBTVD.
 	 * So, this hack is needed, in order to make Kworld SBTVD to work.
+	 *
+	 * It is also needed to change the IF after the initial init.
 	 */
 	if (state->need_init)
 		mb86a20s_initfe(fe);
-- 
1.8.1.4

