Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:40650 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753577AbdLPMY4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 07:24:56 -0500
Received: by mail-wr0-f196.google.com with SMTP id q9so10208699wre.7
        for <linux-media@vger.kernel.org>; Sat, 16 Dec 2017 04:24:56 -0800 (PST)
From: Athanasios Oikonomou <athoik@gmail.com>
To: linux-media@vger.kernel.org
Cc: Athanasios Oikonomou <athoik@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ralph Metzler <rjkm@metzlerbros.de>,
        Manu Abraham <abraham.manu@gmail.com>
Subject: [PATCH 2/2] media: stv090x: add physical layer scrambling support
Date: Sat, 16 Dec 2017 14:23:39 +0200
Message-Id: <4edcfc24e35f434ecf7a994aa49799308892f04b.1513426881.git.athoik@gmail.com>
In-Reply-To: <cover.1513426880.git.athoik@gmail.com>
References: <cover.1513426880.git.athoik@gmail.com>
In-Reply-To: <cover.1513426880.git.athoik@gmail.com>
References: <cover.1513426880.git.athoik@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit uses the new property scrambling_sequence_index
to control PLS.
By default we are using the gold sequence 0 and only gold sequences
expected on the new property.

Please note that all services use PLS, just most with the default
sequence 0 and many demods only support gold 0.

Signed-off-by: Athanasios Oikonomou <athoik@gmail.com>
---
 drivers/media/dvb-frontends/stv090x.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index 7ef469c..9369a11 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -3429,6 +3429,21 @@ static enum stv090x_signal_state stv090x_algo(struct stv090x_state *state)
 	return -1;
 }
 
+static int stv090x_set_pls(struct stv090x_state *state, u32 pls_code)
+{
+	dprintk(FE_DEBUG, 1, "Set Gold PLS code %d", pls_code);
+	if (STV090x_WRITE_DEMOD(state, PLROOT0, pls_code & 0xff) < 0)
+		goto err;
+	if (STV090x_WRITE_DEMOD(state, PLROOT1, (pls_code >> 8) & 0xff) < 0)
+		goto err;
+	if (STV090x_WRITE_DEMOD(state, PLROOT2, 0x04 | (pls_code >> 16)) < 0)
+		goto err;
+	return 0;
+err:
+	dprintk(FE_ERROR, 1, "I/O error");
+	return -1;
+}
+
 static int stv090x_set_mis(struct stv090x_state *state, int mis)
 {
 	u32 reg;
@@ -3491,6 +3506,7 @@ static enum dvbfe_search stv090x_search(struct dvb_frontend *fe)
 		state->search_range = 5000000;
 	}
 
+	stv090x_set_pls(state, props->scrambling_sequence_index);
 	stv090x_set_mis(state, props->stream_id);
 
 	if (stv090x_algo(state) == STV090x_RANGEOK) {
-- 
2.1.4
