Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39811 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab2IVQwk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Sep 2012 12:52:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/5] e4000: fix crash when attach fails
Date: Sat, 22 Sep 2012 19:51:39 +0300
Message-Id: <1348332700-10267-4-git-send-email-crope@iki.fi>
In-Reply-To: <1348332700-10267-1-git-send-email-crope@iki.fi>
References: <1348332700-10267-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Callbacks were set even attach failed. This leads calling
.release() in error case and resulted crash.

Reported-by: Oliver Schinagl <oliver@schinagl.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index ffaa482..1b33ed3 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -366,9 +366,6 @@ struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
 
 	priv->cfg = cfg;
 	priv->i2c = i2c;
-	fe->tuner_priv = priv;
-	memcpy(&fe->ops.tuner_ops, &e4000_tuner_ops,
-			sizeof(struct dvb_tuner_ops));
 
 	/* check if the tuner is there */
 	ret = e4000_rd_reg(priv, 0x02, &chip_id);
@@ -389,6 +386,10 @@ struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
 			"%s: Elonics E4000 successfully identified\n",
 			KBUILD_MODNAME);
 
+	fe->tuner_priv = priv;
+	memcpy(&fe->ops.tuner_ops, &e4000_tuner_ops,
+			sizeof(struct dvb_tuner_ops));
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
-- 
1.7.11.4

