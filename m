Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46781 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938911AbcJGRYq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 13:24:46 -0400
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
Subject: [PATCH 13/26] dtt200u-fe: handle errors on USB control messages
Date: Fri,  7 Oct 2016 14:24:23 -0300
Message-Id: <0a881bb73f490906c7023630c1a32bfea80c95a9.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If something goes wrong, return an error code, instead of
assuming that everything went fine.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/dtt200u-fe.c | 38 +++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dtt200u-fe.c b/drivers/media/usb/dvb-usb/dtt200u-fe.c
index 9ed68429e950..ede6e1bc7315 100644
--- a/drivers/media/usb/dvb-usb/dtt200u-fe.c
+++ b/drivers/media/usb/dvb-usb/dtt200u-fe.c
@@ -26,10 +26,15 @@ static int dtt200u_fe_read_status(struct dvb_frontend *fe,
 				  enum fe_status *stat)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
+	int ret;
 
 	state->data[0] = GET_TUNE_STATUS;
 
-	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 3, 0);
+	ret = dvb_usb_generic_rw(state->d, state->data, 1, state->data, 3, 0);
+	if (ret < 0) {
+		*stat = 0;
+		return ret;
+	}
 
 	switch (state->data[0]) {
 		case 0x01:
@@ -50,10 +55,14 @@ static int dtt200u_fe_read_status(struct dvb_frontend *fe,
 static int dtt200u_fe_read_ber(struct dvb_frontend* fe, u32 *ber)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
+	int ret;
 
 	state->data[0] = GET_VIT_ERR_CNT;
 
-	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 3, 0);
+	ret = dvb_usb_generic_rw(state->d, state->data, 1, state->data, 3, 0);
+	if (ret < 0)
+		return ret;
+
 	*ber = (state->data[0] << 16) | (state->data[1] << 8) | state->data[2];
 	return 0;
 }
@@ -61,10 +70,13 @@ static int dtt200u_fe_read_ber(struct dvb_frontend* fe, u32 *ber)
 static int dtt200u_fe_read_unc_blocks(struct dvb_frontend* fe, u32 *unc)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
+	int ret;
 
 	state->data[0] = GET_RS_UNCOR_BLK_CNT;
 
-	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 2, 0);
+	ret = dvb_usb_generic_rw(state->d, state->data, 1, state->data, 2, 0);
+	if (ret < 0)
+		return ret;
 
 	*unc = (state->data[0] << 8) | state->data[1];
 	return 0;
@@ -73,10 +85,13 @@ static int dtt200u_fe_read_unc_blocks(struct dvb_frontend* fe, u32 *unc)
 static int dtt200u_fe_read_signal_strength(struct dvb_frontend* fe, u16 *strength)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
+	int ret;
 
 	state->data[0] = GET_AGC;
 
-	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 1, 0);
+	ret = dvb_usb_generic_rw(state->d, state->data, 1, state->data, 1, 0);
+	if (ret < 0)
+		return ret;
 
 	*strength = (state->data[0] << 8) | state->data[0];
 	return 0;
@@ -85,10 +100,13 @@ static int dtt200u_fe_read_signal_strength(struct dvb_frontend* fe, u16 *strengt
 static int dtt200u_fe_read_snr(struct dvb_frontend* fe, u16 *snr)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
+	int ret;
 
 	state->data[0] = GET_SNR;
 
-	dvb_usb_generic_rw(state->d, state->data, 1, state->data, 1, 0);
+	ret = dvb_usb_generic_rw(state->d, state->data, 1, state->data, 1, 0);
+	if (ret < 0)
+		return ret;
 
 	*snr = ~((state->data[0] << 8) | state->data[0]);
 	return 0;
@@ -120,7 +138,7 @@ static int dtt200u_fe_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
-	int i;
+	int i, ret;
 	enum fe_status st;
 	u16 freq = fep->frequency / 250000;
 
@@ -139,12 +157,16 @@ static int dtt200u_fe_set_frontend(struct dvb_frontend *fe)
 		return -EINVAL;
 	}
 
-	dvb_usb_generic_write(state->d, state->data, 2);
+	ret = dvb_usb_generic_write(state->d, state->data, 2);
+	if (ret < 0)
+		return ret;
 
 	state->data[0] = SET_RF_FREQ;
 	state->data[1] = freq & 0xff;
 	state->data[2] = (freq >> 8) & 0xff;
-	dvb_usb_generic_write(state->d, state->data, 3);
+	ret = dvb_usb_generic_write(state->d, state->data, 3);
+	if (ret < 0)
+		return ret;
 
 	for (i = 0; i < 30; i++) {
 		msleep(20);
-- 
2.7.4


