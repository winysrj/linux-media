Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40510 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2ACK2k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 05:28:40 -0500
Received: by werm1 with SMTP id m1so7764612wer.19
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 02:28:39 -0800 (PST)
Message-ID: <1325586512.14924.7.camel@tvbox>
Subject: [PATCH] it913x-fe ver 1.13 add BER and UNC monitoring
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Tue, 03 Jan 2012 10:28:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add BER monitoring with Pre-Viterbi error rate.

Add UCBLOCKS based on Aborted packets.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/it913x-fe.c |   21 +++++++++++++++++----
 drivers/media/dvb/frontends/it913x-fe.h |   10 ++++++++++
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index 8088e62..70131b9 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -66,6 +66,7 @@ struct it913x_fe_state {
 	u8 tun_fdiv;
 	u8 tun_clk_mode;
 	u32 tun_fn_min;
+	u32 ucblocks;
 };
 
 static int it913x_read_reg(struct it913x_fe_state *state,
@@ -553,14 +554,26 @@ static int it913x_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 static int it913x_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
-	*ber = 0;
+	struct it913x_fe_state *state = fe->demodulator_priv;
+	int ret;
+	u8 reg[5];
+	/* Read Aborted Packets and Pre-Viterbi error rate 5 bytes */
+	ret = it913x_read_reg(state, RSD_ABORT_PKT_LSB, reg, sizeof(reg));
+	state->ucblocks += (u32)(reg[1] << 8) | reg[0];
+	*ber = (u32)(reg[4] << 16) | (reg[3] << 8) | reg[2];
 	return 0;
 }
 
 static int it913x_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
-	*ucblocks = 0;
-	return 0;
+	struct it913x_fe_state *state = fe->demodulator_priv;
+	int ret;
+	u8 reg[2];
+	/* Aborted Packets */
+	ret = it913x_read_reg(state, RSD_ABORT_PKT_LSB, reg, sizeof(reg));
+	state->ucblocks += (u32)(reg[1] << 8) | reg[0];
+	*ucblocks = state->ucblocks;
+	return ret;
 }
 
 static int it913x_fe_get_frontend(struct dvb_frontend *fe,
@@ -951,5 +964,5 @@ static struct dvb_frontend_ops it913x_fe_ofdm_ops = {
 
 MODULE_DESCRIPTION("it913x Frontend and it9137 tuner");
 MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
-MODULE_VERSION("1.12");
+MODULE_VERSION("1.13");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/frontends/it913x-fe.h b/drivers/media/dvb/frontends/it913x-fe.h
index 5ee3e2f..c4a908e 100644
--- a/drivers/media/dvb/frontends/it913x-fe.h
+++ b/drivers/media/dvb/frontends/it913x-fe.h
@@ -148,6 +148,16 @@ static inline struct dvb_frontend *it913x_fe_attach(
 #define COEFF_1_2048		0x0001
 #define XTAL_CLK		0x0025
 #define BFS_FCW			0x0029
+
+/* Error Regs */
+#define RSD_ABORT_PKT_LSB	0x0032
+#define RSD_ABORT_PKT_MSB	0x0033
+#define RSD_BIT_ERR_0_7		0x0034
+#define RSD_BIT_ERR_8_15	0x0035
+#define RSD_BIT_ERR_23_16	0x0036
+#define RSD_BIT_COUNT_LSB	0x0037
+#define RSD_BIT_COUNT_MSB	0x0038
+
 #define TPSD_LOCK		0x003c
 #define TRAINING_MODE		0x0040
 #define ADC_X_2			0x0045
-- 
1.7.7.3



