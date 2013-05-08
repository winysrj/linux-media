Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60034 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab3EHWvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 May 2013 18:51:08 -0400
Received: from mailout-de.gmx.net ([10.1.76.10]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Lvegk-1UUWil0hHo-017Y9m for
 <linux-media@vger.kernel.org>; Thu, 09 May 2013 00:51:07 +0200
From: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
Subject: [PATCH 1/3] stb0899: store successful inversion for next run
Date: Thu,  9 May 2013 00:50:54 +0200
Message-Id: <1368053456-18475-1-git-send-email-rnissl@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Usually, inversion doesn't change in a system. Storing the last
successful inversion value speeds up tuning of DVB-S2 transponders.

Signed-off-by: Reinhard Nißl <rnissl@gmx.de>
---
 drivers/media/dvb-frontends/stb0899_algo.c | 8 +++++++-
 drivers/media/dvb-frontends/stb0899_drv.c  | 5 ++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb0899_algo.c b/drivers/media/dvb-frontends/stb0899_algo.c
index e0d31a2..4b49efb 100644
--- a/drivers/media/dvb-frontends/stb0899_algo.c
+++ b/drivers/media/dvb-frontends/stb0899_algo.c
@@ -1488,9 +1488,15 @@ enum stb0899_status stb0899_dvbs2_algo(struct stb0899_state *state)
 
 		offsetfreq = offsetfreq / ((1 << 30) / 1000);
 		offsetfreq *= (internal->master_clk / 1000000);
+
+		/* store current inversion for next run */
 		reg = STB0899_READ_S2REG(STB0899_S2DEMOD, DMD_CNTRL2);
 		if (STB0899_GETFIELD(SPECTRUM_INVERT, reg))
-			offsetfreq *= -1;
+			internal->inversion = IQ_SWAP_ON;
+		else
+			internal->inversion = IQ_SWAP_OFF;
+
+		offsetfreq *= internal->inversion;
 
 		internal->freq = internal->freq - offsetfreq;
 		internal->srate = stb0899_dvbs2_get_srate(state);
diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
index cc278b3..3dd5714 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.c
+++ b/drivers/media/dvb-frontends/stb0899_drv.c
@@ -1618,19 +1618,18 @@ static struct dvb_frontend_ops stb0899_ops = {
 struct dvb_frontend *stb0899_attach(struct stb0899_config *config, struct i2c_adapter *i2c)
 {
 	struct stb0899_state *state = NULL;
-	enum stb0899_inversion inversion;
 
 	state = kzalloc(sizeof (struct stb0899_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error;
 
-	inversion				= config->inversion;
 	state->verbose				= &verbose;
 	state->config				= config;
 	state->i2c				= i2c;
 	state->frontend.ops			= stb0899_ops;
 	state->frontend.demodulator_priv	= state;
-	state->internal.inversion		= inversion;
+	/* use configured inversion as default -- we'll later autodetect inversion */
+	state->internal.inversion		= config->inversion;
 
 	stb0899_wakeup(&state->frontend);
 	if (stb0899_get_dev_id(state) == -ENODEV) {
-- 
1.8.1.4

