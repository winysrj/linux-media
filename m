Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57077 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbaLDQS1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Dec 2014 11:18:27 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] stv090x: Some whitespace cleanups
Date: Thu,  4 Dec 2014 14:18:14 -0200
Message-Id: <284cbf4a87a6a4981b8e7089aa753103d747351c.1417709889.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While writing changeset fdf1bc9fa2cf, I noticed some checkpatch
complains about the CodingStyle for function parameters. So,
clean them.

While here, also removes uneeded "extern" from function prototype.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/stv090x.h b/drivers/media/dvb-frontends/stv090x.h
index f7f452f435f2..742eeda99000 100644
--- a/drivers/media/dvb-frontends/stv090x.h
+++ b/drivers/media/dvb-frontends/stv090x.h
@@ -89,29 +89,29 @@ struct stv090x_config {
 
 	bool diseqc_envelope_mode;
 
-	int (*tuner_init) (struct dvb_frontend *fe);
-	int (*tuner_sleep) (struct dvb_frontend *fe);
-	int (*tuner_set_mode) (struct dvb_frontend *fe, enum tuner_mode mode);
-	int (*tuner_set_frequency) (struct dvb_frontend *fe, u32 frequency);
-	int (*tuner_get_frequency) (struct dvb_frontend *fe, u32 *frequency);
-	int (*tuner_set_bandwidth) (struct dvb_frontend *fe, u32 bandwidth);
-	int (*tuner_get_bandwidth) (struct dvb_frontend *fe, u32 *bandwidth);
-	int (*tuner_set_bbgain) (struct dvb_frontend *fe, u32 gain);
-	int (*tuner_get_bbgain) (struct dvb_frontend *fe, u32 *gain);
-	int (*tuner_set_refclk)  (struct dvb_frontend *fe, u32 refclk);
-	int (*tuner_get_status) (struct dvb_frontend *fe, u32 *status);
-	void (*tuner_i2c_lock) (struct dvb_frontend *fe, int lock);
+	int (*tuner_init)(struct dvb_frontend *fe);
+	int (*tuner_sleep)(struct dvb_frontend *fe);
+	int (*tuner_set_mode)(struct dvb_frontend *fe, enum tuner_mode mode);
+	int (*tuner_set_frequency)(struct dvb_frontend *fe, u32 frequency);
+	int (*tuner_get_frequency)(struct dvb_frontend *fe, u32 *frequency);
+	int (*tuner_set_bandwidth)(struct dvb_frontend *fe, u32 bandwidth);
+	int (*tuner_get_bandwidth)(struct dvb_frontend *fe, u32 *bandwidth);
+	int (*tuner_set_bbgain)(struct dvb_frontend *fe, u32 gain);
+	int (*tuner_get_bbgain)(struct dvb_frontend *fe, u32 *gain);
+	int (*tuner_set_refclk)(struct dvb_frontend *fe, u32 refclk);
+	int (*tuner_get_status)(struct dvb_frontend *fe, u32 *status);
+	void (*tuner_i2c_lock)(struct dvb_frontend *fe, int lock);
 
 	/* dir = 0 -> output, dir = 1 -> input/open-drain */
 	int (*set_gpio)(struct dvb_frontend *fe, u8 gpio, u8 dir, u8 value,
-			 u8 xor_value);
+			u8 xor_value);
 };
 
 #if IS_ENABLED(CONFIG_DVB_STV090x)
 
-extern struct dvb_frontend *stv090x_attach(struct stv090x_config *config,
-					   struct i2c_adapter *i2c,
-					   enum stv090x_demodulator demod);
+struct dvb_frontend *stv090x_attach(struct stv090x_config *config,
+				    struct i2c_adapter *i2c,
+				    enum stv090x_demodulator demod);
 
 #else
 
-- 
1.9.3

