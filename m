Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbaCCKIK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:10 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 59/79] [media] drx-j: be sure to use tuner's IF
Date: Mon,  3 Mar 2014 07:06:53 -0300
Message-Id: <1393841233-24840-60-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of just hardcoding an IF value of 5MHz, use the one
provided by the tuner, with can be different for QAM and
VSB.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index c9608e627cca..ccd847e10797 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -20171,11 +20171,21 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	/* Bring the demod out of sleep */
 	drx39xxj_set_powerstate(fe, 1);
 
-	/* Now make the tuner do it's thing... */
 	if (fe->ops.tuner_ops.set_params) {
+		u32 int_freq;
+
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
+
+		/* Set tuner to desired frequency and standard */
 		fe->ops.tuner_ops.set_params(fe);
+
+		/* Use the tuner's IF */
+		if (fe->ops.tuner_ops.get_if_frequency) {
+			fe->ops.tuner_ops.get_if_frequency(fe, &int_freq);
+			demod->my_common_attr->intermediate_freq = int_freq / 1000;
+		}
+
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
-- 
1.8.5.3

