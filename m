Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38207 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1BAWlp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Feb 2011 17:41:45 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so7348272fxm.19
        for <linux-media@vger.kernel.org>; Tue, 01 Feb 2011 14:41:45 -0800 (PST)
Subject: [PATCH 8/9 v2] ds3000: add carrier offset calculation
To: mchehab@infradead.org, linux-media@vger.kernel.org
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Wed, 2 Feb 2011 00:41:09 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102020041.09392.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
---
 drivers/media/dvb/frontends/ds3000.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index b2ba5f4..e2037b5 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -948,6 +948,25 @@ static int ds3000_get_property(struct dvb_frontend *fe,
 	return 0;
 }
 
+static int ds3000_set_carrier_offset(struct dvb_frontend *fe,
+					s32 carrier_offset_khz)
+{
+	struct ds3000_state *state = fe->demodulator_priv;
+	s32 tmp;
+
+	tmp = carrier_offset_khz;
+	tmp *= 65536;
+	tmp = (2 * tmp + DS3000_SAMPLE_RATE) / (2 * DS3000_SAMPLE_RATE);
+
+	if (tmp < 0)
+		tmp += 65536;
+
+	ds3000_writereg(state, 0x5f, tmp >> 8);
+	ds3000_writereg(state, 0x5e, tmp & 0xff);
+
+	return 0;
+}
+
 static int ds3000_tune(struct dvb_frontend *fe,
 				struct dvb_frontend_parameters *p)
 {
@@ -955,7 +974,8 @@ static int ds3000_tune(struct dvb_frontend *fe,
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
 	int i;
-	u8 status, mlpf, mlpf_new, mlpf_max, mlpf_min, nlpf;
+	u8 status, mlpf, mlpf_new, mlpf_max, mlpf_min, nlpf, div4;
+	s32 offset_khz;
 	u16 value, ndiv;
 	u32 f3db;
 
@@ -970,9 +990,12 @@ static int ds3000_tune(struct dvb_frontend *fe,
 	ds3000_tuner_writereg(state, 0x60, 0x79);
 	ds3000_tuner_writereg(state, 0x08, 0x01);
 	ds3000_tuner_writereg(state, 0x00, 0x01);
+	div4 = 0;
+
 	/* calculate and set freq divider */
 	if (p->frequency < 1146000) {
 		ds3000_tuner_writereg(state, 0x10, 0x11);
+		div4 = 1;
 		ndiv = ((p->frequency * (6 + 8) * 4) +
 				(DS3000_XTAL_FREQ / 2)) /
 				DS3000_XTAL_FREQ - 1024;
@@ -1076,6 +1099,9 @@ static int ds3000_tune(struct dvb_frontend *fe,
 	ds3000_tuner_writereg(state, 0x50, 0x00);
 	msleep(60);
 
+	offset_khz = (ndiv - ndiv % 2 + 1024) * DS3000_XTAL_FREQ
+		/ (6 + 8) / (div4 + 1) / 2 - p->frequency;
+
 	/* ds3000 global reset */
 	ds3000_writereg(state, 0x07, 0x80);
 	ds3000_writereg(state, 0x07, 0x00);
@@ -1179,7 +1205,7 @@ static int ds3000_tune(struct dvb_frontend *fe,
 	/* start ds3000 build-in uC */
 	ds3000_writereg(state, 0xb2, 0x00);
 
-	/* TODO: calculate and set carrier offset */
+	ds3000_set_carrier_offset(fe, offset_khz);
 
 	for (i = 0; i < 30 ; i++) {
 		ds3000_read_status(fe, &status);
-- 
1.7.1

