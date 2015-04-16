Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36615 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933655AbbDPNhr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 09:37:47 -0400
Received: by wizk4 with SMTP id k4so195215422wiz.1
        for <linux-media@vger.kernel.org>; Thu, 16 Apr 2015 06:37:46 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 16 Apr 2015 15:37:46 +0200
Message-ID: <CAEVwYfgW9nuA1DNbA=Y9gpX1PFvCtHAWMyTm=XRH_KsSrbJH1A@mail.gmail.com>
Subject: [PATCH] si2165 - Add DVB-C Support
From: beta992 <beta992@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: beta990
Subject: [PATCH] si2165 - Add DVB-C Support

This patch is based of the work of ZZram.
I clean-up his patch and removed double code (e.g. double resets,
actions, etc.):

// -- init?
ret = si2165_readreg8(state, 0x00e0, val); /* returned 0x00 */
if (ret < 0)
return ret;
ret = si2165_writereg32(state, 0x00e8, 0x02db6db6);
if (ret < 0)
return ret;
-- //

Remember this is the first time I submit a patch, please be gentle. ;P

Patch contents:

diff --git a/drivers/media/dvb-frontends/si2165.c
b/drivers/media/dvb-frontends/si2165.c
index 4cc5d10..d283d68 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -704,7 +704,7 @@ static int si2165_read_status(struct dvb_frontend
*fe, fe_status_t *status)
  u8 fec_lock = 0;
  struct si2165_state *state = fe->demodulator_priv;

- if (!state->has_dvbt)
+ if (!state->has_dvbt || !state->has_dvbc)
  return -EINVAL;

  /* check fec_lock */
@@ -777,131 +777,272 @@ static int si2165_set_parameters(struct
dvb_frontend *fe)
  return -EINVAL;
  }

- if (!state->has_dvbt)
+ if (!state->has_dvbt || !state->has_dvbc)
  return -EINVAL;

- if (p->bandwidth_hz > 0) {
- dvb_rate = p->bandwidth_hz * 8 / 7;
- bw10k = p->bandwidth_hz / 10000;
- } else {
- dvb_rate = 8 * 8 / 7;
- bw10k = 800;
- }
+ if (p->delivery_system == SYS_DVBT) {
+ if (p->bandwidth_hz > 0) {
+ dvb_rate = p->bandwidth_hz * 8 / 7;
+ bw10k = p->bandwidth_hz / 10000;
+ } else {
+ dvb_rate = 8 * 8 / 7;
+ bw10k = 800;
+ }

- /* standard = DVB-T */
- ret = si2165_writereg8(state, 0x00ec, 0x01);
- if (ret < 0)
- return ret;
- ret = si2165_adjust_pll_divl(state, 12);
- if (ret < 0)
- return ret;
+ /* DVB-T */
+ ret = si2165_writereg8(state, 0x00ec, 0x01);
+ if (ret < 0)
+ return ret;
+ ret = si2165_adjust_pll_divl(state, 12);
+ if (ret < 0)
+ return ret;

- fe->ops.tuner_ops.get_if_frequency(fe, &IF);
- ret = si2165_set_if_freq_shift(state, IF);
- if (ret < 0)
- return ret;
- ret = si2165_writereg8(state, 0x08f8, 0x00);
- if (ret < 0)
- return ret;
- /* ts output config */
- ret = si2165_writereg8(state, 0x04e4, 0x20);
- if (ret < 0)
- return ret;
- ret = si2165_writereg16(state, 0x04ef, 0x00fe);
- if (ret < 0)
- return ret;
- ret = si2165_writereg24(state, 0x04f4, 0x555555);
- if (ret < 0)
- return ret;
- ret = si2165_writereg8(state, 0x04e5, 0x01);
- if (ret < 0)
- return ret;
- /* bandwidth in 10KHz steps */
- ret = si2165_writereg16(state, 0x0308, bw10k);
- if (ret < 0)
- return ret;
- ret = si2165_set_oversamp(state, dvb_rate);
- if (ret < 0)
- return ret;
- /* impulsive_noise_remover */
- ret = si2165_writereg8(state, 0x031c, 0x01);
- if (ret < 0)
- return ret;
- ret = si2165_writereg8(state, 0x00cb, 0x00);
- if (ret < 0)
- return ret;
- /* agc2 */
- ret = si2165_writereg8(state, 0x016e, 0x41);
- if (ret < 0)
- return ret;
- ret = si2165_writereg8(state, 0x016c, 0x0e);
- if (ret < 0)
- return ret;
- ret = si2165_writereg8(state, 0x016d, 0x10);
- if (ret < 0)
- return ret;
- /* agc */
- ret = si2165_writereg8(state, 0x015b, 0x03);
- if (ret < 0)
- return ret;
- ret = si2165_writereg8(state, 0x0150, 0x78);
- if (ret < 0)
- return ret;
- /* agc */
- ret = si2165_writereg8(state, 0x01a0, 0x78);
- if (ret < 0)
- return ret;
- ret = si2165_writereg8(state, 0x01c8, 0x68);
- if (ret < 0)
- return ret;
- /* freq_sync_range */
- ret = si2165_writereg16(state, 0x030c, 0x0064);
- if (ret < 0)
- return ret;
- /* gp_reg0 */
- ret = si2165_readreg8(state, 0x0387, val);
- if (ret < 0)
- return ret;
- ret = si2165_writereg8(state, 0x0387, 0x00);
- if (ret < 0)
- return ret;
- /* dsp_addr_jump */
- ret = si2165_writereg32(state, 0x0348, 0xf4000000);
- if (ret < 0)
- return ret;
+ fe->ops.tuner_ops.get_if_frequency(fe, &IF);
+ ret = si2165_set_if_freq_shift(state, IF);
+ if (ret < 0)
+ return ret;
+ ret = si2165_writereg8(state, 0x08f8, 0x00);
+ if (ret < 0)
+ return ret;
+ /* ts output config */
+ ret = si2165_writereg8(state, 0x04e4, 0x20);
+ if (ret < 0)
+ return ret;
+ ret = si2165_writereg16(state, 0x04ef, 0x00fe);
+ if (ret < 0)
+ return ret;
+ ret = si2165_writereg24(state, 0x04f4, 0x555555);
+ if (ret < 0)
+ return ret;
+ ret = si2165_writereg8(state, 0x04e5, 0x01);
+ if (ret < 0)
+ return ret;
+ /* bandwidth in 10KHz steps */
+ ret = si2165_writereg16(state, 0x0308, bw10k);
+ if (ret < 0)
+ return ret;
+ ret = si2165_set_oversamp(state, dvb_rate);
+ if (ret < 0)
+ return ret;
+ /* impulsive_noise_remover */
+ ret = si2165_writereg8(state, 0x031c, 0x01);
+ if (ret < 0)
+ return ret;
+ ret = si2165_writereg8(state, 0x00cb, 0x00);
+ if (ret < 0)
+ return ret;
+ /* agc2 */
+ ret = si2165_writereg8(state, 0x016e, 0x41);
+ if (ret < 0)
+ return ret;
+ ret = si2165_writereg8(state, 0x016c, 0x0e);
+ if (ret < 0)
+ return ret;
+ ret = si2165_writereg8(state, 0x016d, 0x10);
+ if (ret < 0)
+ return ret;
+ /* agc */
+ ret = si2165_writereg8(state, 0x015b, 0x03);
+ if (ret < 0)
+ return ret;
+ ret = si2165_writereg8(state, 0x0150, 0x78);
+ if (ret < 0)
+ return ret;
+ /* agc */
+ ret = si2165_writereg8(state, 0x01a0, 0x78);
+ if (ret < 0)
+ return ret;
+ ret = si2165_writereg8(state, 0x01c8, 0x68);
+ if (ret < 0)
+ return ret;
+ /* freq_sync_range */
+ ret = si2165_writereg16(state, 0x030c, 0x0064);
+ if (ret < 0)
+ return ret;
+ /* gp_reg0 */
+ ret = si2165_readreg8(state, 0x0387, val);
+ if (ret < 0)
+ return ret;
+ ret = si2165_writereg8(state, 0x0387, 0x00);
+ if (ret < 0)
+ return ret;
+ /* dsp_addr_jump */
+ ret = si2165_writereg32(state, 0x0348, 0xf4000000);
+ if (ret < 0)
+ return ret;

- if (fe->ops.tuner_ops.set_params)
- fe->ops.tuner_ops.set_params(fe);
+ if (fe->ops.tuner_ops.set_params)
+ fe->ops.tuner_ops.set_params(fe);

- /* recalc if_freq_shift if IF might has changed */
- fe->ops.tuner_ops.get_if_frequency(fe, &IF);
- ret = si2165_set_if_freq_shift(state, IF);
- if (ret < 0)
- return ret;
+ /* recalc if_freq_shift if IF might has changed */
+ fe->ops.tuner_ops.get_if_frequency(fe, &IF);
+ ret = si2165_set_if_freq_shift(state, IF);
+ if (ret < 0)
+ return ret;

- /* boot/wdog status */
- ret = si2165_readreg8(state, 0x0341, val);
- if (ret < 0)
- return ret;
- ret = si2165_writereg8(state, 0x0341, 0x00);
- if (ret < 0)
- return ret;
- /* reset all */
- ret = si2165_writereg8(state, 0x00c0, 0x00);
- if (ret < 0)
- return ret;
- /* gp_reg0 */
- ret = si2165_writereg32(state, 0x0384, 0x00000000);
- if (ret < 0)
- return ret;
- /* start_synchro */
- ret = si2165_writereg8(state, 0x02e0, 0x01);
- if (ret < 0)
- return ret;
- /* boot/wdog status */
- ret = si2165_readreg8(state, 0x0341, val);
- if (ret < 0)
- return ret;
+ /* boot/wdog status */
+ ret = si2165_readreg8(state, 0x0341, val);
+ if (ret < 0)
+ return ret;
+ ret = si2165_writereg8(state, 0x0341, 0x00);
+ if (ret < 0)
+ return ret;
+ /* reset all */
+ ret = si2165_writereg8(state, 0x00c0, 0x00);
+ if (ret < 0)
+ return ret;
+ /* gp_reg0 */
+ ret = si2165_writereg32(state, 0x0384, 0x00000000);
+ if (ret < 0)
+ return ret;
+ /* start_synchro */
+ ret = si2165_writereg8(state, 0x02e0, 0x01);
+ if (ret < 0)
+ return ret;
+ /* boot/wdog status */
+ ret = si2165_readreg8(state, 0x0341, val);
+ if (ret < 0)
+ return ret;
+ }
+ else if (p->delivery_system == SYS_DVBC_ANNEX_A) {
+ /* DVB-C */
+        ret = si2165_writereg8(state, 0x00ec, 0x05);
+        if (ret < 0)
+                return ret;
+        ret = si2165_adjust_pll_divl(state, 14);
+        if (ret < 0)
+                return ret;
+
+        fe->ops.tuner_ops.get_if_frequency(fe, &IF);
+ ret = si2165_set_if_freq_shift(state, IF);
+ if (ret < 0)
+ return ret;
+ ret = si2165_writereg8(state, 0x08f8, 0x00);
+ if (ret < 0)
+ return ret;
+
+ /* ts output config */
+        ret = si2165_writereg8(state, 0x04e4, 0x20);
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg16(state, 0x04ef, 0x00fe);
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg24(state, 0x04f4, 0x555555);
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg8(state, 0x04e5, 0x01);
+        if (ret < 0)
+                return ret;
+ /* bandwidth */
+ ret = si2165_writereg32(state, 0x00e4, 0x040ed730); // or 0x0494f77e
+        if (ret < 0)
+                return ret;
+ /* impulsive_noise_remover */
+ ret = si2165_writereg8(state, 0x031c, 0x01);
+ if (ret < 0)
+ return ret;
+ ret = si2165_writereg8(state, 0x00cb, 0x00);
+ if (ret < 0)
+ return ret;
+ /* agc2 */
+        ret = si2165_writereg8(state, 0x016e, 0x50);
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg8(state, 0x016c, 0x0e);
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg8(state, 0x016d, 0x10);
+        if (ret < 0)
+                return ret;
+ /* agc */
+        ret = si2165_writereg8(state, 0x015b, 0x03);
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg8(state, 0x0150, 0x68);
+        if (ret < 0)
+                return ret;
+ /* agc */
+ ret = si2165_writereg8(state, 0x01a0, 0x68);
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg8(state, 0x01c8, 0x50);
+        if (ret < 0)
+                return ret;
+ /* freq_sync_range */
+ ret = si2165_writereg16(state, 0x030c, 0x0064);
+ if (ret < 0)
+ return ret;
+ /* gp_reg0 */
+        ret = si2165_readreg8(state, 0x0278, val); /* returned 0x0d */
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg8(state, 0x0278, 0x0d);
+        if (ret < 0)
+                return ret;
+ /* dsp_addr_jump */
+ ret = si2165_writereg32(state, 0x0348, 0xf4000000);
+ if (ret < 0)
+ return ret;
+ /* ?? */
+ ret = si2165_writereg8(state, 0x023a, 0x05);
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg8(state, 0x0261, 0x09);
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg16(state, 0x0350, 0x3e80);
+        if (ret < 0)
+                return ret;
+ ret = si2165_writereg32(state, 0x00c4, 0x007a1200);
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg16(state, 0x024c, 0x0000);
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg16(state, 0x027c, 0x0000);
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg8(state, 0x0232, 0x03);
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg8(state, 0x02f4, 0x0b);
+        if (ret < 0)
+                return ret;
+
+        if (fe->ops.tuner_ops.set_params)
+                fe->ops.tuner_ops.set_params(fe);
+
+        /* recalc if_freq_shift if IF might has changed */
+        fe->ops.tuner_ops.get_if_frequency(fe, &IF);
+        ret = si2165_set_if_freq_shift(state, IF);
+        if (ret < 0)
+                return ret;
+
+ /* boot/wdog status */
+        ret = si2165_readreg8(state, 0x0341, val);
+        if (ret < 0)
+                return ret;
+        ret = si2165_writereg8(state, 0x0341, 0x00);
+        if (ret < 0)
+                return ret;
+ /* reset all */
+        ret = si2165_writereg8(state, 0x00c0, 0x00);
+        if (ret < 0)
+                return ret;
+ /* gp_reg0 */
+        ret = si2165_writereg32(state, 0x0384, 0x00000000);
+        if (ret < 0)
+                return ret;
+ /* start_synchro */
+        ret = si2165_writereg8(state, 0x02e0, 0x01);
+        if (ret < 0)
+                return ret;
+ /* boot/wdog status */
+ ret = si2165_readreg8(state, 0x0341, val);
+ if (ret < 0)
+ return ret;
+ }

  return 0;
 }
@@ -917,6 +1058,9 @@ static void si2165_release(struct dvb_frontend *fe)
 static struct dvb_frontend_ops si2165_ops = {
  .info = {
  .name = "Silicon Labs ",
+ /* For DVB-C */
+ .symbol_rate_min = 870000,
+ .symbol_rate_max = 11700000,
  .caps = FE_CAN_FEC_1_2 |
  FE_CAN_FEC_2_3 |
  FE_CAN_FEC_3_4 |
@@ -934,7 +1078,6 @@ static struct dvb_frontend_ops si2165_ops = {
  FE_CAN_GUARD_INTERVAL_AUTO |
  FE_CAN_HIERARCHY_AUTO |
  FE_CAN_MUTE_TS |
- FE_CAN_TRANSMISSION_MODE_AUTO |
  FE_CAN_RECOVER
  },

@@ -1043,8 +1186,9 @@ struct dvb_frontend *si2165_attach(const struct
si2165_config *config,
  sizeof(state->frontend.ops.info.name));
  }
  if (state->has_dvbc)
- dev_warn(&state->i2c->dev, "%s: DVB-C is not yet supported.\n",
-       KBUILD_MODNAME);
+ state->frontend.ops.delsys[n++] = SYS_DVBC_ANNEX_A;
+ strlcat(state->frontend.ops.info.name, " DVB-C",
+ sizeof(state->frontend.ops.info.name));

  return &state->frontend;
