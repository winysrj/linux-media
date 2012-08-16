Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward2h.mail.yandex.net ([84.201.187.147]:33172 "EHLO
	forward2h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104Ab2HPRyK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 13:54:10 -0400
From: CrazyCat <crazycat69@yandex.ru>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Manu Abraham <manu@linuxtv.org>
Subject: [PATCH] stv090x: Multistream support 
MIME-Version: 1.0
Message-Id: <60211345139314@web25h.yandex.ru>
Date: Thu, 16 Aug 2012 20:48:34 +0300
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB-S2 Multistream support for stv090x

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index ea86a56..13caec0 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -3425,6 +3425,33 @@ err:
 	return -1;
 }
 
+static int stv090x_set_mis(struct stv090x_state *state, int mis)
+{
+	u32 reg;
+
+	if (mis < 0 || mis > 255) {
+		dprintk(FE_DEBUG, 1, "Disable MIS filtering");
+		reg = STV090x_READ_DEMOD(state, PDELCTRL1);
+		STV090x_SETFIELD_Px(reg, FILTER_EN_FIELD, 0x00);
+		if (STV090x_WRITE_DEMOD(state, PDELCTRL1, reg) < 0)
+			goto err;
+	} else {
+		dprintk(FE_DEBUG, 1, "Enable MIS filtering - %d", mis);
+		reg = STV090x_READ_DEMOD(state, PDELCTRL1);
+		STV090x_SETFIELD_Px(reg, FILTER_EN_FIELD, 0x01);
+		if (STV090x_WRITE_DEMOD(state, PDELCTRL1, reg) < 0)
+			goto err;
+		if (STV090x_WRITE_DEMOD(state, ISIENTRY, mis) < 0)
+			goto err;
+		if (STV090x_WRITE_DEMOD(state, ISIBITENA, 0xff) < 0)
+			goto err;
+	}
+	return 0;
+err:
+	dprintk(FE_ERROR, 1, "I/O error");
+	return -1;
+}
+
 static enum dvbfe_search stv090x_search(struct dvb_frontend *fe)
 {
 	struct stv090x_state *state = fe->demodulator_priv;
@@ -3447,6 +3474,8 @@ static enum dvbfe_search stv090x_search(struct dvb_frontend *fe)
 		state->search_range = 5000000;
 	}
 
+	stv090x_set_mis(state, props->stream_id);
+
 	if (stv090x_algo(state) == STV090x_RANGEOK) {
 		dprintk(FE_DEBUG, 1, "Search success!");
 		return DVBFE_ALGO_SEARCH_SUCCESS;
@@ -4798,6 +4827,9 @@ struct dvb_frontend *stv090x_attach(const struct stv090x_config *config,
 		}
 	}
 
+	if (state->internal->dev_ver >= 0x30)
+		state->frontend.ops.info.caps |= FE_CAN_MULTISTREAM;
+
 	/* workaround for stuck DiSEqC output */
 	if (config->diseqc_envelope_mode)
 		stv090x_send_diseqc_burst(&state->frontend, SEC_MINI_A);
