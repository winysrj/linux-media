Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41648 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030957AbbD1XEl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:04:41 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 04/13] dib3000mc: Fix indentation
Date: Tue, 28 Apr 2015 20:04:26 -0300
Message-Id: <bd2ce077e2f5e53f0731a21a43741b32aace6ac9.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/dib3000mc.c:134 dib3000mc_setup_pwm_state() warn: inconsistent indenting
drivers/media/dvb-frontends/dib3000mc.c:144 dib3000mc_setup_pwm_state() warn: inconsistent indenting
drivers/media/dvb-frontends/dib3000mc.c:420 dib3000mc_sleep() warn: inconsistent indenting
drivers/media/dvb-frontends/dib3000mc.c:453 dib3000mc_set_channel_cfg() warn: inconsistent indenting

The last one is actually due to a commented code. Let's rework
it, in order to remove the sparse warning without removing the
dead code, as it may be useful in the future.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/dib3000mc.c b/drivers/media/dvb-frontends/dib3000mc.c
index ffad181a9692..ba5e832eb1d4 100644
--- a/drivers/media/dvb-frontends/dib3000mc.c
+++ b/drivers/media/dvb-frontends/dib3000mc.c
@@ -131,7 +131,7 @@ static int dib3000mc_set_timing(struct dib3000mc_state *state, s16 nfft, u32 bw,
 static int dib3000mc_setup_pwm_state(struct dib3000mc_state *state)
 {
 	u16 reg_51, reg_52 = state->cfg->agc->setup & 0xfefb;
-    if (state->cfg->pwm3_inversion) {
+	if (state->cfg->pwm3_inversion) {
 		reg_51 =  (2 << 14) | (0 << 10) | (7 << 6) | (2 << 2) | (2 << 0);
 		reg_52 |= (1 << 2);
 	} else {
@@ -141,7 +141,7 @@ static int dib3000mc_setup_pwm_state(struct dib3000mc_state *state)
 	dib3000mc_write_word(state, 51, reg_51);
 	dib3000mc_write_word(state, 52, reg_52);
 
-    if (state->cfg->use_pwm3)
+	if (state->cfg->use_pwm3)
 		dib3000mc_write_word(state, 245, (1 << 3) | (1 << 0));
 	else
 		dib3000mc_write_word(state, 245, 0);
@@ -417,7 +417,7 @@ static int dib3000mc_sleep(struct dvb_frontend *demod)
 	dib3000mc_write_word(state, 1032, 0xFFFF);
 	dib3000mc_write_word(state, 1033, 0xFFF0);
 
-    return 0;
+	return 0;
 }
 
 static void dib3000mc_set_adp_cfg(struct dib3000mc_state *state, s16 qam)
@@ -447,10 +447,14 @@ static void dib3000mc_set_channel_cfg(struct dib3000mc_state *state,
 	dib3000mc_set_bandwidth(state, bw);
 	dib3000mc_set_timing(state, ch->transmission_mode, bw, 0);
 
-//	if (boost)
-//		dib3000mc_write_word(state, 100, (11 << 6) + 6);
-//	else
+#if 1
+	dib3000mc_write_word(state, 100, (16 << 6) + 9);
+#else
+	if (boost)
+		dib3000mc_write_word(state, 100, (11 << 6) + 6);
+	else
 		dib3000mc_write_word(state, 100, (16 << 6) + 9);
+#endif
 
 	dib3000mc_write_word(state, 1027, 0x0800);
 	dib3000mc_write_word(state, 1027, 0x0000);
-- 
2.1.0

