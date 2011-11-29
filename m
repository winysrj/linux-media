Return-path: <linux-media-owner@vger.kernel.org>
Received: from skyboo.net ([82.160.187.4]:36855 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754844Ab1K2PLE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 10:11:04 -0500
From: Mariusz Bialonczyk <manio@skyboo.net>
To: linux-media@vger.kernel.org
Cc: Mariusz Bialonczyk <manio@skyboo.net>
Date: Tue, 29 Nov 2011 15:31:23 +0100
Message-Id: <1322577083-24728-1-git-send-email-manio@skyboo.net>
Subject: [PATCH] stv090x: implement function for reading uncorrected blocks count
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add support for reading UNC blocks for stv090x frontend.
Partially based on stv0900 code by Abylay Ospan <aospan@netup.ru>

Signed-off-by: Mariusz Bialonczyk <manio@skyboo.net>
---
 drivers/media/dvb/frontends/stv090x.c |   32 +++++++++++++++++++++++++++++++-
 1 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index 52d8712..ad6141f 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -3687,6 +3687,35 @@ static int stv090x_read_cnr(struct dvb_frontend *fe, u16 *cnr)
 	return 0;
 }
 
+static int stv090x_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	struct stv090x_state *state = fe->demodulator_priv;
+	u32 reg_0, reg_1;
+	u32 val_header_err, val_packet_err;
+
+	switch (state->delsys) {
+	case STV090x_DVBS2:
+		/* DVB-S2 delineator error count */
+
+		/* retrieving number for erronous headers */
+		reg_1 = stv090x_read_reg(state, STV090x_P1_BBFCRCKO1);
+		reg_0 = stv090x_read_reg(state, STV090x_P1_BBFCRCKO0);
+		val_header_err = MAKEWORD16(reg_1, reg_0);
+
+		/* retrieving number for erronous packets */
+		reg_1 = stv090x_read_reg(state, STV090x_P1_UPCRCKO1);
+		reg_0 = stv090x_read_reg(state, STV090x_P1_UPCRCKO0);
+		val_packet_err = MAKEWORD16(reg_1, reg_0);
+
+		*ucblocks = val_packet_err + val_header_err;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int stv090x_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
 {
 	struct stv090x_state *state = fe->demodulator_priv;
@@ -4748,7 +4777,8 @@ static struct dvb_frontend_ops stv090x_ops = {
 	.read_status			= stv090x_read_status,
 	.read_ber			= stv090x_read_per,
 	.read_signal_strength		= stv090x_read_signal_strength,
-	.read_snr			= stv090x_read_cnr
+	.read_snr			= stv090x_read_cnr,
+	.read_ucblocks			= stv090x_read_ucblocks
 };
 
 
-- 
1.7.7.3

