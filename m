Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885AbcBDP6s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 10:58:48 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/7] [media] lgs8gxx: don't export get_frontend() callback
Date: Thu,  4 Feb 2016 13:57:29 -0200
Message-Id: <91b396ddb5766b5dde0669da2b32afd6eb7bd9b0.1454600641.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This device doesn't really have a get_frontend(). All it does is
to blindly set everything to auto mode.

Remove the get_frontend(), as the code does that already,
and put the frontend changes at set_frontend, where it
belongs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/lgs8gxx.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgs8gxx.c b/drivers/media/dvb-frontends/lgs8gxx.c
index e2c191c8b196..919daeb96747 100644
--- a/drivers/media/dvb-frontends/lgs8gxx.c
+++ b/drivers/media/dvb-frontends/lgs8gxx.c
@@ -672,7 +672,7 @@ static int lgs8gxx_write(struct dvb_frontend *fe, const u8 buf[], int len)
 
 static int lgs8gxx_set_fe(struct dvb_frontend *fe)
 {
-
+	struct dtv_frontend_properties *fe_params = &fe->dtv_property_cache;
 	struct lgs8gxx_state *priv = fe->demodulator_priv;
 
 	dprintk("%s\n", __func__);
@@ -689,17 +689,7 @@ static int lgs8gxx_set_fe(struct dvb_frontend *fe)
 
 	msleep(10);
 
-	return 0;
-}
-
-static int lgs8gxx_get_fe(struct dvb_frontend *fe)
-{
-	struct dtv_frontend_properties *fe_params = &fe->dtv_property_cache;
-	dprintk("%s\n", __func__);
-
 	/* TODO: get real readings from device */
-	/* inversion status */
-	fe_params->inversion = INVERSION_OFF;
 
 	/* bandwidth */
 	fe_params->bandwidth_hz = 8000000;
@@ -1016,7 +1006,6 @@ static struct dvb_frontend_ops lgs8gxx_ops = {
 	.i2c_gate_ctrl = lgs8gxx_i2c_gate_ctrl,
 
 	.set_frontend = lgs8gxx_set_fe,
-	.get_frontend = lgs8gxx_get_fe,
 	.get_tune_settings = lgs8gxx_get_tune_settings,
 
 	.read_status = lgs8gxx_read_status,
-- 
2.5.0


