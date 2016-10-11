Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39711 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752215AbcJKKfK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:35:10 -0400
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
Subject: [PATCH v2 14/31] dtt200u-fe: handle errors on USB control messages
Date: Tue, 11 Oct 2016 07:09:29 -0300
Message-Id: <d81adeaab5f7520860fd78f4e90ae8024defea3d.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If something goes wrong, return an error code, instead of
assuming that everything went fine.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/dtt200u-fe.c | 40 ++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dtt200u-fe.c b/drivers/media/usb/dvb-usb/dtt200u-fe.c
index 7f7f64be6353..f5c042baa254 100644
--- a/drivers/media/usb/dvb-usb/dtt200u-fe.c
+++ b/drivers/media/usb/dvb-usb/dtt200u-fe.c
@@ -27,11 +27,17 @@ static int dtt200u_fe_read_status(struct dvb_frontend *fe,
 				  enum fe_status *stat)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
+	int ret;
 
 	mutex_lock(&state->data_mutex);
 	state->data[0] = GET_TUNE_STATUS;
 
-	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 3, 0);
+	ret = dvb_usb_generic_rw(state->d, state->data, 1, state->data, 3, 0);
+	if (ret < 0) {
+		*stat = 0;
+		mutex_unlock(&state->data_mutex);
+		return ret;
+	}
 
 	switch (state->data[0]) {
 		case 0x01:
@@ -53,25 +59,30 @@ static int dtt200u_fe_read_status(struct dvb_frontend *fe,
 static int dtt200u_fe_read_ber(struct dvb_frontend* fe, u32 *ber)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
+	int ret;
 
 	mutex_lock(&state->data_mutex);
 	state->data[0] = GET_VIT_ERR_CNT;
 
-	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 3, 0);
-	*ber = (state->data[0] << 16) | (state->data[1] << 8) | state->data[2];
+	ret = dvb_usb_generic_rw(state->d, state->data, 1, state->data, 3, 0);
+	if (ret >= 0)
+		*ber = (state->data[0] << 16) | (state->data[1] << 8) | state->data[2];
 
 	mutex_unlock(&state->data_mutex);
-	return 0;
+	return ret;
 }
 
 static int dtt200u_fe_read_unc_blocks(struct dvb_frontend* fe, u32 *unc)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
+	int ret;
 
 	mutex_lock(&state->data_mutex);
 	state->data[0] = GET_RS_UNCOR_BLK_CNT;
 
-	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 2, 0);
+	ret = dvb_usb_generic_rw(state->d, state->data, 1, state->data, 2, 0);
+	if (ret >= 0)
+		*unc = (state->data[0] << 8) | state->data[1];
 
 	mutex_unlock(&state->data_mutex);
 	return ret;
@@ -80,11 +91,14 @@ static int dtt200u_fe_read_unc_blocks(struct dvb_frontend* fe, u32 *unc)
 static int dtt200u_fe_read_signal_strength(struct dvb_frontend* fe, u16 *strength)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
+	int ret;
 
 	mutex_lock(&state->data_mutex);
 	state->data[0] = GET_AGC;
 
-	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 1, 0);
+	ret = dvb_usb_generic_rw(state->d, state->data, 1, state->data, 1, 0);
+	if (ret >= 0)
+		*strength = (state->data[0] << 8) | state->data[0];
 
 	mutex_unlock(&state->data_mutex);
 	return ret;
@@ -93,11 +107,14 @@ static int dtt200u_fe_read_signal_strength(struct dvb_frontend* fe, u16 *strengt
 static int dtt200u_fe_read_snr(struct dvb_frontend* fe, u16 *snr)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
+	int ret;
 
 	mutex_lock(&state->data_mutex);
 	state->data[0] = GET_SNR;
 
-	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 1, 0);
+	ret = dvb_usb_generic_rw(state->d, state->data, 1, state->data, 1, 0);
+	if (ret >= 0)
+		*snr = ~((state->data[0] << 8) | state->data[0]);
 
 	mutex_unlock(&state->data_mutex);
 	return ret;
@@ -134,6 +151,7 @@ static int dtt200u_fe_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
+	int ret;
 	u16 freq = fep->frequency / 250000;
 
 	mutex_lock(&state->data_mutex);
@@ -153,12 +171,16 @@ static int dtt200u_fe_set_frontend(struct dvb_frontend *fe)
 		goto ret;
 	}
 
-	dvb_usb_generic_write(state->d, state->data, 2);
+	ret = dvb_usb_generic_write(state->d, state->data, 2);
+	if (ret < 0)
+		goto ret;
 
 	state->data[0] = SET_RF_FREQ;
 	state->data[1] = freq & 0xff;
 	state->data[2] = (freq >> 8) & 0xff;
-	dvb_usb_generic_write(state->d, state->data, 3);
+	ret = dvb_usb_generic_write(state->d, state->data, 3);
+	if (ret < 0)
+		goto ret;
 
 ret:
 	mutex_unlock(&state->data_mutex);
-- 
2.7.4


