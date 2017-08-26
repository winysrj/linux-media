Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40928 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdHZGS4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 02:18:56 -0400
Date: Sat, 26 Aug 2017 09:18:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] [media] dib8000: remove some bogus dead code
Message-ID: <20170826061841.7hepoocimf5kit5g@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function is broken.  It sets the wrong front_end to NULL.  But it's
not used, so let's just delete it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb-frontends/dib8000.h b/drivers/media/dvb-frontends/dib8000.h
index 2b8b4b1656a2..75cc8e47ec8f 100644
--- a/drivers/media/dvb-frontends/dib8000.h
+++ b/drivers/media/dvb-frontends/dib8000.h
@@ -53,7 +53,6 @@ struct dib8000_ops {
 	enum frontend_tune_state (*get_tune_state)(struct dvb_frontend *fe);
 	int (*set_tune_state)(struct dvb_frontend *fe, enum frontend_tune_state tune_state);
 	int (*set_slave_frontend)(struct dvb_frontend *fe, struct dvb_frontend *fe_slave);
-	int (*remove_slave_frontend)(struct dvb_frontend *fe);
 	struct dvb_frontend *(*get_slave_frontend)(struct dvb_frontend *fe, int slave_index);
 	int (*i2c_enumeration)(struct i2c_adapter *host, int no_of_demods,
 		u8 default_addr, u8 first_addr, u8 is_dib8096p);
diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index a179a3f6563d..5d9381509b07 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -4255,23 +4255,6 @@ static int dib8000_set_slave_frontend(struct dvb_frontend *fe, struct dvb_fronte
 	return -ENOMEM;
 }
 
-static int dib8000_remove_slave_frontend(struct dvb_frontend *fe)
-{
-	struct dib8000_state *state = fe->demodulator_priv;
-	u8 index_frontend = 1;
-
-	while ((index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL))
-		index_frontend++;
-	if (index_frontend != 1) {
-		dprintk("remove slave fe %p (index %i)\n", state->fe[index_frontend-1], index_frontend-1);
-		state->fe[index_frontend] = NULL;
-		return 0;
-	}
-
-	dprintk("no frontend to be removed\n");
-	return -ENODEV;
-}
-
 static struct dvb_frontend *dib8000_get_slave_frontend(struct dvb_frontend *fe, int slave_index)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
@@ -4506,7 +4489,6 @@ void *dib8000_attach(struct dib8000_ops *ops)
 	ops->get_slave_frontend = dib8000_get_slave_frontend;
 	ops->set_tune_state = dib8000_set_tune_state;
 	ops->pid_filter_ctrl = dib8000_pid_filter_ctrl;
-	ops->remove_slave_frontend = dib8000_remove_slave_frontend;
 	ops->get_adc_power = dib8000_get_adc_power;
 	ops->update_pll = dib8000_update_pll;
 	ops->tuner_sleep = dib8096p_tuner_sleep;
