Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43493 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbcF2Wng (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 18:43:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 02/10] au8522: use the RF strentgh provided by the tuner
Date: Wed, 29 Jun 2016 19:43:18 -0300
Message-Id: <314f7a0ded01b76e0c2ff3c1dc44c5cfd01ad445.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The usage of SNR to estimate the signal strength is a poor man's
approach. The best is to use the RF strength as measured by the
tuner. So, use it, if available.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/au8522_dig.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
index e676b9461a59..ee14fd48c414 100644
--- a/drivers/media/dvb-frontends/au8522_dig.c
+++ b/drivers/media/dvb-frontends/au8522_dig.c
@@ -767,16 +767,30 @@ static int au8522_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int au8522_read_signal_strength(struct dvb_frontend *fe,
 				       u16 *signal_strength)
 {
-	/* borrowed from lgdt330x.c
+	u16 snr;
+	u32 tmp;
+	int ret;
+
+	/* If the tuner has RF strength, use it */
+	if (fe->ops.tuner_ops.get_rf_strength) {
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 1);
+		ret = fe->ops.tuner_ops.get_rf_strength(fe, signal_strength);
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+		return ret;
+	}
+
+	/*
+	 * If it doen't, estimate from SNR
+	 * (borrowed from lgdt330x.c)
 	 *
 	 * Calculate strength from SNR up to 35dB
 	 * Even though the SNR can go higher than 35dB,
 	 * there is some comfort factor in having a range of
 	 * strong signals that can show at 100%
 	 */
-	u16 snr;
-	u32 tmp;
-	int ret = au8522_read_snr(fe, &snr);
+	ret = au8522_read_snr(fe, &snr);
 
 	*signal_strength = 0;
 
-- 
2.7.4

