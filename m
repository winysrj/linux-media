Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38207 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1BAWkl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Feb 2011 17:40:41 -0500
Received: by fxm20 with SMTP id 20so7348272fxm.19
        for <linux-media@vger.kernel.org>; Tue, 01 Feb 2011 14:40:40 -0800 (PST)
Subject: [PATCH 1/9 v2] ds3000: fill in demod init function
To: mchehab@infradead.org, linux-media@vger.kernel.org
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Wed, 2 Feb 2011 00:40:03 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102020040.03555.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Make some initializations in init, not in tune function

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
---
 drivers/media/dvb/frontends/ds3000.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index 125dfad..4773916 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -1092,10 +1092,6 @@ static int ds3000_tune(struct dvb_frontend *fe,
 		/* Reset status register */
 		status = 0;
 		/* Tune */
-		/* TS2020 init */
-		ds3000_tuner_writereg(state, 0x42, 0x73);
-		ds3000_tuner_writereg(state, 0x05, 0x01);
-		ds3000_tuner_writereg(state, 0x62, 0xf5);
 		/* unknown */
 		ds3000_tuner_writereg(state, 0x07, 0x02);
 		ds3000_tuner_writereg(state, 0x10, 0x00);
@@ -1345,7 +1341,19 @@ static enum dvbfe_algo ds3000_get_algo(struct dvb_frontend *fe)
  */
 static int ds3000_initfe(struct dvb_frontend *fe)
 {
+	struct ds3000_state *state = fe->demodulator_priv;
+	int ret;
+
 	dprintk("%s()\n", __func__);
+	/* hard reset */
+	ds3000_writereg(state, 0x08, 0x01 | ds3000_readreg(state, 0x08));
+	msleep(1);
+
+	/* TS2020 init */
+	ds3000_tuner_writereg(state, 0x42, 0x73);
+	ds3000_tuner_writereg(state, 0x05, 0x01);
+	ds3000_tuner_writereg(state, 0x62, 0xf5);
+
 	return 0;
 }
 
-- 
1.7.1

