Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40920 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdHZGSy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 02:18:54 -0400
Date: Sat, 26 Aug 2017 09:18:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Max Kellermann <max.kellermann@gmail.com>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] [media] dib9000: delete some unused broken code
Message-ID: <20170826060606.ga6vgtriducqyluw@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dib9000_remove_slave_frontend() function isn't used.

I was reviewing it because my static checker claims it writes one
element beyond the end of the array.  That's a false positive.  What it
actually does is, if there are two or more front ends, then it prints a
debug message to say that it removed the first one, stored in
state->fe[1], and then it "removes" (scare quotes on purpose) the second
one, stored in state->fe[2].  Deleting a front end from the middle is
not really supported and breaks code like dib9000_release() which
assumes the first NULL front end marks the end of the list.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb-frontends/dib9000.h b/drivers/media/dvb-frontends/dib9000.h
index b10a70aa7c9f..40883b41e66b 100644
--- a/drivers/media/dvb-frontends/dib9000.h
+++ b/drivers/media/dvb-frontends/dib9000.h
@@ -37,7 +37,6 @@ extern int dib9000_fw_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff);
 extern int dib9000_fw_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff);
 extern int dib9000_firmware_post_pll_init(struct dvb_frontend *fe);
 extern int dib9000_set_slave_frontend(struct dvb_frontend *fe, struct dvb_frontend *fe_slave);
-extern int dib9000_remove_slave_frontend(struct dvb_frontend *fe);
 extern struct dvb_frontend *dib9000_get_slave_frontend(struct dvb_frontend *fe, int slave_index);
 extern struct i2c_adapter *dib9000_get_component_bus_interface(struct dvb_frontend *fe);
 extern int dib9000_set_i2c_adapter(struct dvb_frontend *fe, struct i2c_adapter *i2c);
@@ -97,12 +96,6 @@ static inline int dib9000_set_slave_frontend(struct dvb_frontend *fe, struct dvb
 	return -ENODEV;
 }
 
-static inline int dib9000_remove_slave_frontend(struct dvb_frontend *fe)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
 static inline struct dvb_frontend *dib9000_get_slave_frontend(struct dvb_frontend *fe, int slave_index)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
index 17c6f15c7e68..1b7a4331af05 100644
--- a/drivers/media/dvb-frontends/dib9000.c
+++ b/drivers/media/dvb-frontends/dib9000.c
@@ -2462,24 +2462,6 @@ int dib9000_set_slave_frontend(struct dvb_frontend *fe, struct dvb_frontend *fe_
 }
 EXPORT_SYMBOL(dib9000_set_slave_frontend);
 
-int dib9000_remove_slave_frontend(struct dvb_frontend *fe)
-{
-	struct dib9000_state *state = fe->demodulator_priv;
-	u8 index_frontend = 1;
-
-	while ((index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL))
-		index_frontend++;
-	if (index_frontend != 1) {
-		dprintk("remove slave fe %p (index %i)\n", state->fe[index_frontend - 1], index_frontend - 1);
-		state->fe[index_frontend] = NULL;
-		return 0;
-	}
-
-	dprintk("no frontend to be removed\n");
-	return -ENODEV;
-}
-EXPORT_SYMBOL(dib9000_remove_slave_frontend);
-
 struct dvb_frontend *dib9000_get_slave_frontend(struct dvb_frontend *fe, int slave_index)
 {
 	struct dib9000_state *state = fe->demodulator_priv;
