Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab1AOQLf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 11:11:35 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0FGBZU3020916
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 11:11:35 -0500
Received: from pedra (vpn-234-251.phx2.redhat.com [10.3.234.251])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p0FG5PY0001803
	for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 11:11:34 -0500
Date: Sat, 15 Jan 2011 16:04:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/8] [media] mb86a20s: Be sure that device is initialized
 before starting DVB
Message-ID: <20110115160423.327706a3@pedra>
In-Reply-To: <cover.1295114145.git.mchehab@redhat.com>
References: <cover.1295114145.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Due to a hard to track bug between tda829x/tda18271/saa7134, tda829x
wants to go to analog mode during DVB initialization, causing some
I2C errors.

The analog failure doesn't cause any harm, as the device were already
properly initialized in analog mode. However, the failure at the digital
mode causes the frontend mb86a20s to not initialize. Fortunately, at
least on my tests, it was possible to detect that the device is a
mb86a20s before the failure.

What happens is that tda8290 is a very bad boy: during DVB setup, it
keeps insisting to call tda18271 analog_set_params, that calls
tune_agc code. The tune_agc code calls saa7134 driver, changing the
value of GPIO 27, switching from digital to analog mode and disabling
the access to mb86a20s, as, on Kworld SBTVD, the same GPIO used
to switch the hardware AGC mode seems to be used to enable the I2C
switch that allows access to the frontend (mb86a20s).

So, a call to analog_set_params ultimately disables the access to
the frontend, and causes a failure at the init frontend logic.

This patch is a workaround for this issue: it simply checks if the
frontend init had any failure. If so, it will init the frontend when
some DTV application will try to set DVB mode.

Even being a hack for Kworld SBTVD to work, and assumning that we could
teach tda8290 to be a good boy, this is actually an improvement at the
frontend driver, as it will be more reliable to initialization failures.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/mb86a20s.c b/drivers/media/dvb/frontends/mb86a20s.c
index e06507d..cc4acd2 100644
--- a/drivers/media/dvb/frontends/mb86a20s.c
+++ b/drivers/media/dvb/frontends/mb86a20s.c
@@ -43,6 +43,8 @@ struct mb86a20s_state {
 	const struct mb86a20s_config *config;
 
 	struct dvb_frontend frontend;
+
+	bool need_init;
 };
 
 struct regdata {
@@ -382,23 +384,31 @@ static int mb86a20s_initfe(struct dvb_frontend *fe)
 	/* Initialize the frontend */
 	rc = mb86a20s_writeregdata(state, mb86a20s_init);
 	if (rc < 0)
-		return rc;
+		goto err;
 
 	if (!state->config->is_serial) {
 		regD5 &= ~1;
 
 		rc = mb86a20s_writereg(state, 0x50, 0xd5);
 		if (rc < 0)
-			return rc;
+			goto err;
 		rc = mb86a20s_writereg(state, 0x51, regD5);
 		if (rc < 0)
-			return rc;
+			goto err;
 	}
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
-	return 0;
+err:
+	if (rc < 0) {
+		state->need_init = true;
+		printk(KERN_INFO "mb86a20s: Init failed. Will try again later\n");
+	} else {
+		state->need_init = false;
+		dprintk("Initialization succeded.\n");
+	}
+	return rc;
 }
 
 static int mb86a20s_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
@@ -485,8 +495,22 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe,
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
+	dprintk("Calling tuner set parameters\n");
 	fe->ops.tuner_ops.set_params(fe, p);
 
+	/*
+	 * Make it more reliable: if, for some reason, the initial
+	 * device initialization doesn't happen, initialize it when
+	 * a SBTVD parameters are adjusted.
+	 *
+	 * Unfortunately, due to a hard to track bug at tda829x/tda18271,
+	 * the agc callback logic is not called during DVB attach time,
+	 * causing mb86a20s to not be initialized with Kworld SBTVD.
+	 * So, this hack is needed, in order to make Kworld SBTVD to work.
+	 */
+	if (state->need_init)
+		mb86a20s_initfe(fe);
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 	rc = mb86a20s_writeregdata(state, mb86a20s_reset_reception);
-- 
1.7.1


