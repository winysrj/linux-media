Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39717 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbcJKKfV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:35:21 -0400
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
Subject: [PATCH v2 05/31] cinergyT2-fe: don't do DMA on stack
Date: Tue, 11 Oct 2016 07:09:20 -0300
Message-Id: <bfebb46eb0a9af7d3983f6c61f6be8dd0748050c.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

Reviewed-By: Patrick Boettcher <patrick.boettcher@posteo.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/cinergyT2-fe.c | 56 +++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cinergyT2-fe.c b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
index fd8edcb56e61..2d29b4174dba 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
@@ -139,6 +139,10 @@ static uint16_t compute_tps(struct dtv_frontend_properties *op)
 struct cinergyt2_fe_state {
 	struct dvb_frontend fe;
 	struct dvb_usb_device *d;
+
+	unsigned char data[64];
+	struct mutex data_mutex;
+
 	struct dvbt_get_status_msg status;
 };
 
@@ -146,28 +150,31 @@ static int cinergyt2_fe_read_status(struct dvb_frontend *fe,
 				    enum fe_status *status)
 {
 	struct cinergyt2_fe_state *state = fe->demodulator_priv;
-	struct dvbt_get_status_msg result;
-	u8 cmd[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
 	int ret;
 
-	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (u8 *)&result,
-			sizeof(result), 0);
+	mutex_lock(&state->data_mutex);
+	state->data[0] = CINERGYT2_EP1_GET_TUNER_STATUS;
+
+	ret = dvb_usb_generic_rw(state->d, state->data, 1,
+				 state->data, sizeof(state->status), 0);
+	if (!ret)
+		memcpy(&state->status, state->data, sizeof(state->status));
+	mutex_unlock(&state->data_mutex);
+
 	if (ret < 0)
 		return ret;
 
-	state->status = result;
-
 	*status = 0;
 
-	if (0xffff - le16_to_cpu(result.gain) > 30)
+	if (0xffff - le16_to_cpu(state->status.gain) > 30)
 		*status |= FE_HAS_SIGNAL;
-	if (result.lock_bits & (1 << 6))
+	if (state->status.lock_bits & (1 << 6))
 		*status |= FE_HAS_LOCK;
-	if (result.lock_bits & (1 << 5))
+	if (state->status.lock_bits & (1 << 5))
 		*status |= FE_HAS_SYNC;
-	if (result.lock_bits & (1 << 4))
+	if (state->status.lock_bits & (1 << 4))
 		*status |= FE_HAS_CARRIER;
-	if (result.lock_bits & (1 << 1))
+	if (state->status.lock_bits & (1 << 1))
 		*status |= FE_HAS_VITERBI;
 
 	if ((*status & (FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC)) !=
@@ -232,34 +239,36 @@ static int cinergyt2_fe_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct cinergyt2_fe_state *state = fe->demodulator_priv;
-	struct dvbt_set_parameters_msg param;
-	char result[2];
+	struct dvbt_set_parameters_msg *param;
 	int err;
 
-	param.cmd = CINERGYT2_EP1_SET_TUNER_PARAMETERS;
-	param.tps = cpu_to_le16(compute_tps(fep));
-	param.freq = cpu_to_le32(fep->frequency / 1000);
-	param.flags = 0;
+	mutex_lock(&state->data_mutex);
+
+	param = (void *)state->data;
+	param->cmd = CINERGYT2_EP1_SET_TUNER_PARAMETERS;
+	param->tps = cpu_to_le16(compute_tps(fep));
+	param->freq = cpu_to_le32(fep->frequency / 1000);
+	param->flags = 0;
 
 	switch (fep->bandwidth_hz) {
 	default:
 	case 8000000:
-		param.bandwidth = 8;
+		param->bandwidth = 8;
 		break;
 	case 7000000:
-		param.bandwidth = 7;
+		param->bandwidth = 7;
 		break;
 	case 6000000:
-		param.bandwidth = 6;
+		param->bandwidth = 6;
 		break;
 	}
 
-	err = dvb_usb_generic_rw(state->d,
-			(char *)&param, sizeof(param),
-			result, sizeof(result), 0);
+	err = dvb_usb_generic_rw(state->d, state->data, sizeof(*param),
+				 state->data, 2, 0);
 	if (err < 0)
 		err("cinergyt2_fe_set_frontend() Failed! err=%d\n", err);
 
+	mutex_unlock(&state->data_mutex);
 	return (err < 0) ? err : 0;
 }
 
@@ -281,6 +290,7 @@ struct dvb_frontend *cinergyt2_fe_attach(struct dvb_usb_device *d)
 	s->d = d;
 	memcpy(&s->fe.ops, &cinergyt2_fe_ops, sizeof(struct dvb_frontend_ops));
 	s->fe.demodulator_priv = s;
+	mutex_init(&s->data_mutex);
 	return &s->fe;
 }
 
-- 
2.7.4


