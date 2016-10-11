Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39720 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752400AbcJKKfX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:35:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>
Subject: [PATCH v2 04/31] cinergyT2-fe: cache stats at cinergyt2_fe_read_status()
Date: Tue, 11 Oct 2016 07:09:19 -0300
Message-Id: <c5bd4af5538b03cdc94a8ba24226e99f8592162e.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of sending USB commands for every stats call, collect
them once, when status is updated. As the frontend kthread
will call it on every few seconds, the stats will still be
collected.

Besides reducing the amount of USB/I2C transfers, this also
warrants that all stats will be collected at the same time,
and makes easier to convert it to DVBv5 stats in the future.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/cinergyT2-fe.c | 48 +++++---------------------------
 1 file changed, 7 insertions(+), 41 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cinergyT2-fe.c b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
index b3ec743a7a2e..fd8edcb56e61 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
@@ -139,6 +139,7 @@ static uint16_t compute_tps(struct dtv_frontend_properties *op)
 struct cinergyt2_fe_state {
 	struct dvb_frontend fe;
 	struct dvb_usb_device *d;
+	struct dvbt_get_status_msg status;
 };
 
 static int cinergyt2_fe_read_status(struct dvb_frontend *fe,
@@ -154,6 +155,8 @@ static int cinergyt2_fe_read_status(struct dvb_frontend *fe,
 	if (ret < 0)
 		return ret;
 
+	state->status = result;
+
 	*status = 0;
 
 	if (0xffff - le16_to_cpu(result.gain) > 30)
@@ -177,34 +180,16 @@ static int cinergyt2_fe_read_status(struct dvb_frontend *fe,
 static int cinergyt2_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct cinergyt2_fe_state *state = fe->demodulator_priv;
-	struct dvbt_get_status_msg status;
-	char cmd[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
-	int ret;
 
-	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (char *)&status,
-				sizeof(status), 0);
-	if (ret < 0)
-		return ret;
-
-	*ber = le32_to_cpu(status.viterbi_error_rate);
+	*ber = le32_to_cpu(state->status.viterbi_error_rate);
 	return 0;
 }
 
 static int cinergyt2_fe_read_unc_blocks(struct dvb_frontend *fe, u32 *unc)
 {
 	struct cinergyt2_fe_state *state = fe->demodulator_priv;
-	struct dvbt_get_status_msg status;
-	u8 cmd[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
-	int ret;
 
-	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (u8 *)&status,
-				sizeof(status), 0);
-	if (ret < 0) {
-		err("cinergyt2_fe_read_unc_blocks() Failed! (Error=%d)\n",
-			ret);
-		return ret;
-	}
-	*unc = le32_to_cpu(status.uncorrected_block_count);
+	*unc = le32_to_cpu(state->status.uncorrected_block_count);
 	return 0;
 }
 
@@ -212,35 +197,16 @@ static int cinergyt2_fe_read_signal_strength(struct dvb_frontend *fe,
 						u16 *strength)
 {
 	struct cinergyt2_fe_state *state = fe->demodulator_priv;
-	struct dvbt_get_status_msg status;
-	char cmd[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
-	int ret;
 
-	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (char *)&status,
-				sizeof(status), 0);
-	if (ret < 0) {
-		err("cinergyt2_fe_read_signal_strength() Failed!"
-			" (Error=%d)\n", ret);
-		return ret;
-	}
-	*strength = (0xffff - le16_to_cpu(status.gain));
+	*strength = (0xffff - le16_to_cpu(state->status.gain));
 	return 0;
 }
 
 static int cinergyt2_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct cinergyt2_fe_state *state = fe->demodulator_priv;
-	struct dvbt_get_status_msg status;
-	char cmd[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
-	int ret;
 
-	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (char *)&status,
-				sizeof(status), 0);
-	if (ret < 0) {
-		err("cinergyt2_fe_read_snr() Failed! (Error=%d)\n", ret);
-		return ret;
-	}
-	*snr = (status.snr << 8) | status.snr;
+	*snr = (state->status.snr << 8) | state->status.snr;
 	return 0;
 }
 
-- 
2.7.4


