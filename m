Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:33408 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940326AbdDSXOc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 19:14:32 -0400
Received: by mail-qk0-f173.google.com with SMTP id h67so33360910qke.0
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 16:14:32 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 06/12] au8522 Remove 0x4 bit for register reads
Date: Wed, 19 Apr 2017 19:13:49 -0400
Message-Id: <1492643635-30823-7-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
References: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The second highest bit in the register value is an indicator to do
a register read, so remove it since now au8522_regread() inserts
the bit automatically.

Also remove a stray instance where we were actually trying to write
to the I2C status register, which was actually a read.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/dvb-frontends/au8522_dig.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
index d117ddb..3f3635f 100644
--- a/drivers/media/dvb-frontends/au8522_dig.c
+++ b/drivers/media/dvb-frontends/au8522_dig.c
@@ -284,7 +284,6 @@ static int au8522_set_if(struct dvb_frontend *fe, enum au8522_if_freq if_freq)
 	u16 data;
 } VSB_mod_tab[] = {
 	{ 0x0090, 0x84 },
-	{ 0x4092, 0x11 },
 	{ 0x2005, 0x00 },
 	{ 0x0091, 0x80 },
 	{ 0x00a3, 0x0c },
@@ -654,12 +653,12 @@ static int au8522_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	if (state->current_modulation == VSB_8) {
 		dprintk("%s() Checking VSB_8\n", __func__);
-		reg = au8522_readreg(state, 0x4088);
+		reg = au8522_readreg(state, 0x0088);
 		if ((reg & 0x03) == 0x03)
 			*status |= FE_HAS_LOCK | FE_HAS_SYNC | FE_HAS_VITERBI;
 	} else {
 		dprintk("%s() Checking QAM\n", __func__);
-		reg = au8522_readreg(state, 0x4541);
+		reg = au8522_readreg(state, 0x0541);
 		if (reg & 0x80)
 			*status |= FE_HAS_VITERBI;
 		if (reg & 0x20)
@@ -745,17 +744,17 @@ static int au8522_read_snr(struct dvb_frontend *fe, u16 *snr)
 	if (state->current_modulation == QAM_256)
 		ret = au8522_mse2snr_lookup(qam256_mse2snr_tab,
 					    ARRAY_SIZE(qam256_mse2snr_tab),
-					    au8522_readreg(state, 0x4522),
+					    au8522_readreg(state, 0x0522),
 					    snr);
 	else if (state->current_modulation == QAM_64)
 		ret = au8522_mse2snr_lookup(qam64_mse2snr_tab,
 					    ARRAY_SIZE(qam64_mse2snr_tab),
-					    au8522_readreg(state, 0x4522),
+					    au8522_readreg(state, 0x0522),
 					    snr);
 	else /* VSB_8 */
 		ret = au8522_mse2snr_lookup(vsb_mse2snr_tab,
 					    ARRAY_SIZE(vsb_mse2snr_tab),
-					    au8522_readreg(state, 0x4311),
+					    au8522_readreg(state, 0x0311),
 					    snr);
 
 	if (state->config.led_cfg)
@@ -804,9 +803,9 @@ static int au8522_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	struct au8522_state *state = fe->demodulator_priv;
 
 	if (state->current_modulation == VSB_8)
-		*ucblocks = au8522_readreg(state, 0x4087);
+		*ucblocks = au8522_readreg(state, 0x0087);
 	else
-		*ucblocks = au8522_readreg(state, 0x4543);
+		*ucblocks = au8522_readreg(state, 0x0543);
 
 	return 0;
 }
-- 
1.9.1
