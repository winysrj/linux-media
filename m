Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39693 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbcJKKeq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:34:46 -0400
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
Subject: [PATCH v2 13/31] dtt200u-fe: don't do DMA on stack
Date: Tue, 11 Oct 2016 07:09:28 -0300
Message-Id: <15fcc12dc8fe547116decedc20ef87398c640dee.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/dtt200u-fe.c | 95 +++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 30 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dtt200u-fe.c b/drivers/media/usb/dvb-usb/dtt200u-fe.c
index 9bb15f7b48db..7f7f64be6353 100644
--- a/drivers/media/usb/dvb-usb/dtt200u-fe.c
+++ b/drivers/media/usb/dvb-usb/dtt200u-fe.c
@@ -18,17 +18,22 @@ struct dtt200u_fe_state {
 
 	struct dtv_frontend_properties fep;
 	struct dvb_frontend frontend;
+
+	unsigned char data[80];
+	struct mutex data_mutex;
 };
 
 static int dtt200u_fe_read_status(struct dvb_frontend *fe,
 				  enum fe_status *stat)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
-	u8 st = GET_TUNE_STATUS, b[3];
 
-	dvb_usb_generic_rw(state->d,&st,1,b,3,0);
+	mutex_lock(&state->data_mutex);
+	state->data[0] = GET_TUNE_STATUS;
 
-	switch (b[0]) {
+	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 3, 0);
+
+	switch (state->data[0]) {
 		case 0x01:
 			*stat = FE_HAS_SIGNAL | FE_HAS_CARRIER |
 				FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
@@ -41,51 +46,75 @@ static int dtt200u_fe_read_status(struct dvb_frontend *fe,
 			*stat = 0;
 			break;
 	}
+	mutex_unlock(&state->data_mutex);
 	return 0;
 }
 
 static int dtt200u_fe_read_ber(struct dvb_frontend* fe, u32 *ber)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
-	u8 bw = GET_VIT_ERR_CNT,b[3];
-	dvb_usb_generic_rw(state->d,&bw,1,b,3,0);
-	*ber = (b[0] << 16) | (b[1] << 8) | b[2];
+
+	mutex_lock(&state->data_mutex);
+	state->data[0] = GET_VIT_ERR_CNT;
+
+	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 3, 0);
+	*ber = (state->data[0] << 16) | (state->data[1] << 8) | state->data[2];
+
+	mutex_unlock(&state->data_mutex);
 	return 0;
 }
 
 static int dtt200u_fe_read_unc_blocks(struct dvb_frontend* fe, u32 *unc)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
-	u8 bw = GET_RS_UNCOR_BLK_CNT,b[2];
 
-	dvb_usb_generic_rw(state->d,&bw,1,b,2,0);
-	*unc = (b[0] << 8) | b[1];
-	return 0;
+	mutex_lock(&state->data_mutex);
+	state->data[0] = GET_RS_UNCOR_BLK_CNT;
+
+	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 2, 0);
+
+	mutex_unlock(&state->data_mutex);
+	return ret;
 }
 
 static int dtt200u_fe_read_signal_strength(struct dvb_frontend* fe, u16 *strength)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
-	u8 bw = GET_AGC, b;
-	dvb_usb_generic_rw(state->d,&bw,1,&b,1,0);
-	*strength = (b << 8) | b;
-	return 0;
+
+	mutex_lock(&state->data_mutex);
+	state->data[0] = GET_AGC;
+
+	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 1, 0);
+
+	mutex_unlock(&state->data_mutex);
+	return ret;
 }
 
 static int dtt200u_fe_read_snr(struct dvb_frontend* fe, u16 *snr)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
-	u8 bw = GET_SNR,br;
-	dvb_usb_generic_rw(state->d,&bw,1,&br,1,0);
-	*snr = ~((br << 8) | br);
-	return 0;
+
+	mutex_lock(&state->data_mutex);
+	state->data[0] = GET_SNR;
+
+	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 1, 0);
+
+	mutex_unlock(&state->data_mutex);
+	return ret;
 }
 
 static int dtt200u_fe_init(struct dvb_frontend* fe)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
-	u8 b = SET_INIT;
-	return dvb_usb_generic_write(state->d,&b,1);
+	int ret;
+
+	mutex_lock(&state->data_mutex);
+	state->data[0] = SET_INIT;
+
+	ret = dvb_usb_generic_write(state->d, state->data, 1);
+	mutex_unlock(&state->data_mutex);
+
+	return ret;
 }
 
 static int dtt200u_fe_sleep(struct dvb_frontend* fe)
@@ -106,29 +135,34 @@ static int dtt200u_fe_set_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
 	u16 freq = fep->frequency / 250000;
-	u8 bwbuf[2] = { SET_BANDWIDTH, 0 },freqbuf[3] = { SET_RF_FREQ, 0, 0 };
 
+	mutex_lock(&state->data_mutex);
+	state->data[0] = SET_BANDWIDTH;
 	switch (fep->bandwidth_hz) {
 	case 8000000:
-		bwbuf[1] = 8;
+		state->data[1] = 8;
 		break;
 	case 7000000:
-		bwbuf[1] = 7;
+		state->data[1] = 7;
 		break;
 	case 6000000:
-		bwbuf[1] = 6;
+		state->data[1] = 6;
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto ret;
 	}
 
-	dvb_usb_generic_write(state->d,bwbuf,2);
+	dvb_usb_generic_write(state->d, state->data, 2);
 
-	freqbuf[1] = freq & 0xff;
-	freqbuf[2] = (freq >> 8) & 0xff;
-	dvb_usb_generic_write(state->d,freqbuf,3);
+	state->data[0] = SET_RF_FREQ;
+	state->data[1] = freq & 0xff;
+	state->data[2] = (freq >> 8) & 0xff;
+	dvb_usb_generic_write(state->d, state->data, 3);
 
-	return 0;
+ret:
+	mutex_unlock(&state->data_mutex);
+	return ret;
 }
 
 static int dtt200u_fe_get_frontend(struct dvb_frontend* fe,
@@ -160,6 +194,7 @@ struct dvb_frontend* dtt200u_fe_attach(struct dvb_usb_device *d)
 	deb_info("attaching frontend dtt200u\n");
 
 	state->d = d;
+	mutex_init(&state->data_mutex);
 
 	memcpy(&state->frontend.ops,&dtt200u_fe_ops,sizeof(struct dvb_frontend_ops));
 	state->frontend.demodulator_priv = state;
-- 
2.7.4


