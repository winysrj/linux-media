Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36236 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754362AbdCXSZv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 14:25:51 -0400
Received: by mail-wm0-f65.google.com with SMTP id x124so2177763wmf.3
        for <linux-media@vger.kernel.org>; Fri, 24 Mar 2017 11:25:50 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 08/12] [media] dvb-frontends/stv0367: selectable QAM FEC Lock status register
Date: Fri, 24 Mar 2017 19:24:04 +0100
Message-Id: <20170324182408.25996-9-d.scheller.oss@gmail.com>
In-Reply-To: <20170324182408.25996-1-d.scheller.oss@gmail.com>
References: <20170324182408.25996-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

In some configurations (due to different PIN config, wiring or so), the
QAM FECLock might be signalled using a different register than
F367CAB_QAMFEC_LOCK (e.g. F367CAB_DESCR_SYNCSTATE on Digital Devices hw),
so make that register selectable.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 74fee3f..fb41c7b 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -57,6 +57,7 @@ struct stv0367cab_state {
 	u32 freq_khz;			/* found frequency (in kHz)	*/
 	u32 symbol_rate;		/* found symbol rate (in Bds)	*/
 	enum fe_spectral_inversion spect_inv; /* Spectrum Inversion	*/
+	u32 qamfec_status_reg;          /* status reg to poll for FEC Lock */
 };
 
 struct stv0367ter_state {
@@ -2145,7 +2146,8 @@ static int stv0367cab_read_status(struct dvb_frontend *fe,
 
 	*status = 0;
 
-	if (stv0367_readbits(state, F367CAB_QAMFEC_LOCK)) {
+	if (stv0367_readbits(state, (state->cab_state->qamfec_status_reg ?
+		state->cab_state->qamfec_status_reg : F367CAB_QAMFEC_LOCK))) {
 		*status |= FE_HAS_LOCK;
 		dprintk("%s: stv0367 has locked\n", __func__);
 	}
@@ -2410,7 +2412,9 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 			usleep_range(5000, 7000);
 			LockTime += 5;
 			QAMFEC_Lock = stv0367_readbits(state,
-							F367CAB_QAMFEC_LOCK);
+				(state->cab_state->qamfec_status_reg ?
+				state->cab_state->qamfec_status_reg :
+				F367CAB_QAMFEC_LOCK));
 		} while (!QAMFEC_Lock && (LockTime < FECTimeOut));
 	} else
 		QAMFEC_Lock = 0;
@@ -2849,6 +2853,7 @@ struct dvb_frontend *stv0367cab_attach(const struct stv0367_config *config,
 	state->i2c = i2c;
 	state->config = config;
 	cab_state->search_range = 280000;
+	cab_state->qamfec_status_reg = F367CAB_QAMFEC_LOCK;
 	state->cab_state = cab_state;
 	state->fe.ops = stv0367cab_ops;
 	state->fe.demodulator_priv = state;
-- 
2.10.2
