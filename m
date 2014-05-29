Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35998 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332AbaE2MUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 08:20:25 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/5] dib8000: rename dib8000_attach to dib8000_init
Date: Thu, 29 May 2014 09:20:16 -0300
Message-Id: <1401366017-19874-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1401366017-19874-1-git-send-email-m.chehab@samsung.com>
References: <1401366017-19874-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well, what we call as "foo_attach" is the method that should
be called by the dvb_attach() macro.

It should be noticed that the name "dvb_attach" is really a
bad name and don't express what it does.

dvb_attach() basically does three things, if the frontend is
compiled as a module:
- It lookups for the module that it is known to have the
  given symbol name and requests such module;
- It increments the module usage (anonymously - so lsmod
  doesn't print who loaded the module);
- after loading the module, it runs the function associated
  with the dynamic symbol.

When compiled as builtin, it just calls the function given to it.

As dvb_attach() increments refcount, it can't be (easily)
called more than once for the same module, or the kernel
will deny to remove the module, because refcount will never
be zeroed.

In other words, the function name given to dvb_attach()
should be one single symbol that will always be called
before any other function on that module to be used.

For almost all DVB frontends, there's just one function,
but, on dib8000, there are several exported symbols.

We need to get rid of all those direct calls, because they
cause compilation breakages when bridge is builtin and
frontend is module, we'll need to add a new function that
will be the first one to be called, whatever initialization
is needed.

So, let's rename this function, in order to prepare for
a next patch that will add a new attach() function that
will be the only one exported by this module.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c       |  6 ++---
 drivers/media/dvb-frontends/dib8000.h       |  4 +--
 drivers/media/usb/dvb-usb/dib0700_devices.c | 40 ++++++++++++++---------------
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 1632d78a5479..c1c8c92ce498 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -4405,12 +4405,12 @@ static const struct dvb_frontend_ops dib8000_ops = {
 	.read_ucblocks = dib8000_read_unc_blocks,
 };
 
-struct dvb_frontend *dib8000_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib8000_config *cfg)
+struct dvb_frontend *dib8000_init(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib8000_config *cfg)
 {
 	struct dvb_frontend *fe;
 	struct dib8000_state *state;
 
-	dprintk("dib8000_attach");
+	dprintk("dib8000_init");
 
 	state = kzalloc(sizeof(struct dib8000_state), GFP_KERNEL);
 	if (state == NULL)
@@ -4467,7 +4467,7 @@ error:
 	return NULL;
 }
 
-EXPORT_SYMBOL(dib8000_attach);
+EXPORT_SYMBOL(dib8000_init);
 
 MODULE_AUTHOR("Olivier Grenie <Olivier.Grenie@dibcom.fr, " "Patrick Boettcher <pboettcher@dibcom.fr>");
 MODULE_DESCRIPTION("Driver for the DiBcom 8000 ISDB-T demodulator");
diff --git a/drivers/media/dvb-frontends/dib8000.h b/drivers/media/dvb-frontends/dib8000.h
index b8c11e52c512..89962d640e4c 100644
--- a/drivers/media/dvb-frontends/dib8000.h
+++ b/drivers/media/dvb-frontends/dib8000.h
@@ -40,7 +40,7 @@ struct dib8000_config {
 #define DEFAULT_DIB8000_I2C_ADDRESS 18
 
 #if IS_ENABLED(CONFIG_DVB_DIB8000)
-extern struct dvb_frontend *dib8000_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib8000_config *cfg);
+extern struct dvb_frontend *dib8000_init(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib8000_config *cfg);
 extern struct i2c_adapter *dib8000_get_i2c_master(struct dvb_frontend *, enum dibx000_i2c_interface, int);
 
 extern int dib8000_i2c_enumeration(struct i2c_adapter *host, int no_of_demods,
@@ -65,7 +65,7 @@ extern int dib8000_set_slave_frontend(struct dvb_frontend *fe, struct dvb_fronte
 extern int dib8000_remove_slave_frontend(struct dvb_frontend *fe);
 extern struct dvb_frontend *dib8000_get_slave_frontend(struct dvb_frontend *fe, int slave_index);
 #else
-static inline struct dvb_frontend *dib8000_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib8000_config *cfg)
+static inline struct dvb_frontend *dib8000_init(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib8000_config *cfg)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 111dcc4c7140..424832cb4444 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -282,7 +282,7 @@ static int stk7700P2_frontend_attach(struct dvb_usb_adapter *adap)
 					     stk7700d_dib7000p_mt2266_config)
 		    != 0) {
 			err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
-			dvb_detach(dib7000p_attach);
+			dvb_detach(&state->dib7000p_ops);;
 			return -ENODEV;
 		}
 	}
@@ -316,7 +316,7 @@ static int stk7700d_frontend_attach(struct dvb_usb_adapter *adap)
 					     stk7700d_dib7000p_mt2266_config)
 		    != 0) {
 			err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
-			dvb_detach(dib7000p_attach);
+			dvb_detach(&state->dib7000p_ops);;
 			return -ENODEV;
 		}
 	}
@@ -469,7 +469,7 @@ static int stk7700ph_frontend_attach(struct dvb_usb_adapter *adap)
 				     &stk7700ph_dib7700_xc3028_config) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 		    __func__);
-		dvb_detach(dib7000p_attach);
+		dvb_detach(&state->dib7000p_ops);;
 		return -ENODEV;
 	}
 
@@ -720,7 +720,7 @@ static int stk7700p_frontend_attach(struct dvb_usb_adapter *adap)
 		adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 18, &stk7700p_dib7000p_config);
 		st->is_dib7000pc = 1;
 	} else {
-		dvb_detach(dib7000p_attach);
+		dvb_detach(&state->dib7000p_ops);;
 		memset(&state->dib7000p_ops, 0, sizeof(state->dib7000p_ops));
 		adap->fe_adap[0].fe = dvb_attach(dib7000m_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000m_config);
 	}
@@ -1006,7 +1006,7 @@ static int stk7070p_frontend_attach(struct dvb_usb_adapter *adap)
 				     &dib7070p_dib7000p_config) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 		    __func__);
-		dvb_detach(dib7000p_attach);
+		dvb_detach(&state->dib7000p_ops);;
 		return -ENODEV;
 	}
 
@@ -1064,7 +1064,7 @@ static int stk7770p_frontend_attach(struct dvb_usb_adapter *adap)
 				     &dib7770p_dib7000p_config) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 		    __func__);
-		dvb_detach(dib7000p_attach);
+		dvb_detach(&state->dib7000p_ops);;
 		return -ENODEV;
 	}
 
@@ -1337,7 +1337,7 @@ static int stk807x_frontend_attach(struct dvb_usb_adapter *adap)
 	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
 				0x80, 0);
 
-	adap->fe_adap[0].fe = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x80,
+	adap->fe_adap[0].fe = dvb_attach(dib8000_init, &adap->dev->i2c_adap, 0x80,
 			      &dib807x_dib8000_config[0]);
 
 	return adap->fe_adap[0].fe == NULL ?  -ENODEV : 0;
@@ -1366,7 +1366,7 @@ static int stk807xpvr_frontend_attach0(struct dvb_usb_adapter *adap)
 	/* initialize IC 0 */
 	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 1, 0x22, 0x80, 0);
 
-	adap->fe_adap[0].fe = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x80,
+	adap->fe_adap[0].fe = dvb_attach(dib8000_init, &adap->dev->i2c_adap, 0x80,
 			      &dib807x_dib8000_config[0]);
 
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
@@ -1377,7 +1377,7 @@ static int stk807xpvr_frontend_attach1(struct dvb_usb_adapter *adap)
 	/* initialize IC 1 */
 	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 1, 0x12, 0x82, 0);
 
-	adap->fe_adap[0].fe = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x82,
+	adap->fe_adap[0].fe = dvb_attach(dib8000_init, &adap->dev->i2c_adap, 0x82,
 			      &dib807x_dib8000_config[1]);
 
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
@@ -1709,7 +1709,7 @@ static int stk809x_frontend_attach(struct dvb_usb_adapter *adap)
 
 	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 1, 18, 0x80, 0);
 
-	adap->fe_adap[0].fe = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x80, &dib809x_dib8000_config[0]);
+	adap->fe_adap[0].fe = dvb_attach(dib8000_init, &adap->dev->i2c_adap, 0x80, &dib809x_dib8000_config[0]);
 
 	return adap->fe_adap[0].fe == NULL ?  -ENODEV : 0;
 }
@@ -1760,11 +1760,11 @@ static int nim8096md_frontend_attach(struct dvb_usb_adapter *adap)
 
 	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 2, 18, 0x80, 0);
 
-	adap->fe_adap[0].fe = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x80, &dib809x_dib8000_config[0]);
+	adap->fe_adap[0].fe = dvb_attach(dib8000_init, &adap->dev->i2c_adap, 0x80, &dib809x_dib8000_config[0]);
 	if (adap->fe_adap[0].fe == NULL)
 		return -ENODEV;
 
-	fe_slave = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x82, &dib809x_dib8000_config[1]);
+	fe_slave = dvb_attach(dib8000_init, &adap->dev->i2c_adap, 0x82, &dib809x_dib8000_config[1]);
 	dib8000_set_slave_frontend(adap->fe_adap[0].fe, fe_slave);
 
 	return fe_slave == NULL ?  -ENODEV : 0;
@@ -2078,7 +2078,7 @@ static int tfe8096p_frontend_attach(struct dvb_usb_adapter *adap)
 
 	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 1, 0x10, 0x80, 1);
 
-	adap->fe_adap[0].fe = dvb_attach(dib8000_attach,
+	adap->fe_adap[0].fe = dvb_attach(dib8000_init,
 			&adap->dev->i2c_adap, 0x80, &tfe8096p_dib8000_config);
 
 	return adap->fe_adap[0].fe == NULL ?  -ENODEV : 0;
@@ -2947,7 +2947,7 @@ static int nim7090_frontend_attach(struct dvb_usb_adapter *adap)
 
 	if (state->dib7000p_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 0x10, &nim7090_dib7000p_config) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
-		dvb_detach(dib7000p_attach);
+		dvb_detach(&state->dib7000p_ops);;
 		return -ENODEV;
 	}
 	adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 0x80, &nim7090_dib7000p_config);
@@ -3000,7 +3000,7 @@ static int tfe7090pvr_frontend0_attach(struct dvb_usb_adapter *adap)
 	/* initialize IC 0 */
 	if (state->dib7000p_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 0x20, &tfe7090pvr_dib7000p_config[0]) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
-		dvb_detach(dib7000p_attach);
+		dvb_detach(&state->dib7000p_ops);;
 		return -ENODEV;
 	}
 
@@ -3030,7 +3030,7 @@ static int tfe7090pvr_frontend1_attach(struct dvb_usb_adapter *adap)
 	i2c = state->dib7000p_ops.get_i2c_master(adap->dev->adapter[0].fe_adap[0].fe, DIBX000_I2C_INTERFACE_GPIO_6_7, 1);
 	if (state->dib7000p_ops.i2c_enumeration(i2c, 1, 0x10, &tfe7090pvr_dib7000p_config[1]) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
-		dvb_detach(dib7000p_attach);
+		dvb_detach(&state->dib7000p_ops);;
 		return -ENODEV;
 	}
 
@@ -3105,7 +3105,7 @@ static int tfe7790p_frontend_attach(struct dvb_usb_adapter *adap)
 				1, 0x10, &tfe7790p_dib7000p_config) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 				__func__);
-		dvb_detach(dib7000p_attach);
+		dvb_detach(&state->dib7000p_ops);;
 		return -ENODEV;
 	}
 	adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap,
@@ -3200,7 +3200,7 @@ static int stk7070pd_frontend_attach0(struct dvb_usb_adapter *adap)
 				     stk7070pd_dib7000p_config) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 		    __func__);
-		dvb_detach(dib7000p_attach);
+		dvb_detach(&state->dib7000p_ops);;
 		return -ENODEV;
 	}
 
@@ -3275,7 +3275,7 @@ static int novatd_frontend_attach(struct dvb_usb_adapter *adap)
 					     stk7070pd_dib7000p_config) != 0) {
 			err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 			    __func__);
-			dvb_detach(dib7000p_attach);
+			dvb_detach(&state->dib7000p_ops);;
 			return -ENODEV;
 		}
 	}
@@ -3503,7 +3503,7 @@ static int pctv340e_frontend_attach(struct dvb_usb_adapter *adap)
 
 	if (state->dib7000p_ops.dib7000pc_detection(&adap->dev->i2c_adap) == 0) {
 		/* Demodulator not found for some reason? */
-		dvb_detach(dib7000p_attach);
+		dvb_detach(&state->dib7000p_ops);;
 		return -ENODEV;
 	}
 
-- 
1.9.3

