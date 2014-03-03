Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49404 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbaCCKH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:59 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 38/79] [media] drx-j: Fix release and error path on drx39xxj.c
Date: Mon,  3 Mar 2014 07:06:32 -0300
Message-Id: <1393841233-24840-39-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are memory leaks on both DVB release and
dvb attach error path. Fix them.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c | 31 +++++++++++++++----------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index e5f276f5d215..44e9bafcc9ed 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -318,6 +318,12 @@ static int drx39xxj_get_tune_settings(struct dvb_frontend *fe,
 static void drx39xxj_release(struct dvb_frontend *fe)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
+	struct drx_demod_instance *demod = state->demod;
+
+	kfree(demod->my_ext_attr);
+	kfree(demod->my_common_attr);
+	kfree(demod->my_i2c_dev_addr);
+	kfree(demod);
 	kfree(state);
 }
 
@@ -378,16 +384,14 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 
 	demod->my_ext_attr = demod_ext_attr;
 	memcpy(demod->my_ext_attr, &drxj_data_g, sizeof(struct drxj_data));
-	((struct drxj_data *)demod->my_ext_attr)->uio_sma_tx_mode =
-	    DRX_UIO_MODE_READWRITE;
+	((struct drxj_data *)demod->my_ext_attr)->uio_sma_tx_mode = DRX_UIO_MODE_READWRITE;
 
 	demod->my_tuner = NULL;
 
 	result = drx_open(demod);
 	if (result != 0) {
 		pr_err("DRX open failed!  Aborting\n");
-		kfree(state);
-		return NULL;
+		goto error;
 	}
 
 	/* Turn off the LNA */
@@ -395,9 +399,9 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	uio_cfg.mode = DRX_UIO_MODE_READWRITE;
 	/* Configure user-I/O #3: enable read/write */
 	result = drx_ctrl(demod, DRX_CTRL_UIO_CFG, &uio_cfg);
-	if (result != 0) {
+	if (result) {
 		pr_err("Failed to setup LNA GPIO!\n");
-		return NULL;
+		goto error;
 	}
 
 	uio_data.uio = DRX_UIO1;
@@ -405,7 +409,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	result = drx_ctrl(demod, DRX_CTRL_UIO_WRITE, &uio_data);
 	if (result != 0) {
 		pr_err("Failed to disable LNA!\n");
-		return NULL;
+		goto error;
 	}
 
 	/* create dvb_frontend */
@@ -416,10 +420,12 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	return &state->frontend;
 
 error:
-	if (state != NULL)
-		kfree(state);
-	if (demod != NULL)
-		kfree(demod);
+	kfree(demod_ext_attr);
+	kfree(demod_comm_attr);
+	kfree(demod_addr);
+	kfree(demod);
+	kfree(state);
+
 	return NULL;
 }
 EXPORT_SYMBOL(drx39xxj_attach);
@@ -431,7 +437,8 @@ static struct dvb_frontend_ops drx39xxj_ops = {
 		 .frequency_stepsize = 62500,
 		 .frequency_min = 51000000,
 		 .frequency_max = 858000000,
-		 .caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB},
+		 .caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
+	},
 
 	.init = drx39xxj_init,
 	.i2c_gate_ctrl = drx39xxj_i2c_gate_ctrl,
-- 
1.8.5.3

