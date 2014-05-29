Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36000 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333AbaE2MU0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 08:20:26 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/5] dib7000p: rename dib7000p_attach to dib7000p_init
Date: Thu, 29 May 2014 09:20:14 -0300
Message-Id: <1401366017-19874-3-git-send-email-m.chehab@samsung.com>
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

For almost all DVB frontends, there's just one function.

However, the dib7000p initialization can require up to 3
functions to be called:
	- dib7000p_get_i2c_master;
	- dib7000p_i2c_enumeration;
	- dib7000p_init (before this patch dib7000_attach).

(plus a bunch of other functions that the bridge driver will
need to call).

As we need to get rid of all those direct calls, because they
cause compilation breakages when bridge is builtin and
frontend is module, we'll need to add a new function that
will be the first one to be called, whatever initialization
is needed.

So, let's rename the function that probes and init the hardware
to dib7000p_init.

A latter patch will add a new dib7000p_attach that will be
used as originally conceived by dvb_attach() way.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib7000p.c      |  4 ++--
 drivers/media/dvb-frontends/dib7000p.h      |  4 ++--
 drivers/media/pci/cx23885/cx23885-dvb.c     |  2 +-
 drivers/media/usb/dvb-usb/cxusb.c           |  2 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c | 28 ++++++++++++++--------------
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index effb87f773b0..4b33bce3a4c6 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -2374,7 +2374,7 @@ int dib7090_slave_reset(struct dvb_frontend *fe)
 EXPORT_SYMBOL(dib7090_slave_reset);
 
 static struct dvb_frontend_ops dib7000p_ops;
-struct dvb_frontend *dib7000p_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg)
+struct dvb_frontend *dib7000p_init(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg)
 {
 	struct dvb_frontend *demod;
 	struct dib7000p_state *st;
@@ -2434,7 +2434,7 @@ error:
 	kfree(st);
 	return NULL;
 }
-EXPORT_SYMBOL(dib7000p_attach);
+EXPORT_SYMBOL(dib7000p_init);
 
 static struct dvb_frontend_ops dib7000p_ops = {
 	.delsys = { SYS_DVBT },
diff --git a/drivers/media/dvb-frontends/dib7000p.h b/drivers/media/dvb-frontends/dib7000p.h
index d08cdff59bdf..583c94e8eca5 100644
--- a/drivers/media/dvb-frontends/dib7000p.h
+++ b/drivers/media/dvb-frontends/dib7000p.h
@@ -47,7 +47,7 @@ struct dib7000p_config {
 #define DEFAULT_DIB7000P_I2C_ADDRESS 18
 
 #if IS_ENABLED(CONFIG_DVB_DIB7000P)
-extern struct dvb_frontend *dib7000p_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg);
+extern struct dvb_frontend *dib7000p_init(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg);
 extern struct i2c_adapter *dib7000p_get_i2c_master(struct dvb_frontend *, enum dibx000_i2c_interface, int);
 extern int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib7000p_config cfg[]);
 extern int dib7000p_set_gpio(struct dvb_frontend *, u8 num, u8 dir, u8 val);
@@ -65,7 +65,7 @@ extern int dib7000p_get_agc_values(struct dvb_frontend *fe,
 		u16 *agc_global, u16 *agc1, u16 *agc2, u16 *wbd);
 extern int dib7000p_set_agc1_min(struct dvb_frontend *fe, u16 v);
 #else
-static inline struct dvb_frontend *dib7000p_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg)
+static inline struct dvb_frontend *dib7000p_init(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 4be01b3bd4f5..69e526391c12 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -925,7 +925,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
 		i2c_bus = &dev->i2c_bus[0];
-		fe0->dvb.frontend = dvb_attach(dib7000p_attach,
+		fe0->dvb.frontend = dvb_attach(dib7000p_init,
 			&i2c_bus->i2c_adap,
 			0x12, &hauppauge_hvr1400_dib7000_config);
 		if (fe0->dvb.frontend != NULL) {
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index a1c641e18362..e81a2fd54960 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1085,7 +1085,7 @@ static int cxusb_dualdig4_rev2_frontend_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
+	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x80,
 			      &cxusb_dualdig4_rev2_config);
 	if (adap->fe_adap[0].fe == NULL)
 		return -EIO;
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 10e0db8d1850..3585089c805c 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -281,7 +281,7 @@ static int stk7700P2_frontend_attach(struct dvb_usb_adapter *adap)
 	}
 
 	adap->fe_adap[0].fe =
-		dvb_attach(dib7000p_attach, &adap->dev->i2c_adap,
+		dvb_attach(dib7000p_init, &adap->dev->i2c_adap,
 			   0x80 + (adap->id << 1),
 			   &stk7700d_dib7000p_mt2266_config[adap->id]);
 
@@ -310,7 +310,7 @@ static int stk7700d_frontend_attach(struct dvb_usb_adapter *adap)
 	}
 
 	adap->fe_adap[0].fe =
-		dvb_attach(dib7000p_attach, &adap->dev->i2c_adap,
+		dvb_attach(dib7000p_init, &adap->dev->i2c_adap,
 			   0x80 + (adap->id << 1),
 			   &stk7700d_dib7000p_mt2266_config[adap->id]);
 
@@ -452,7 +452,7 @@ static int stk7700ph_frontend_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
+	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x80,
 		&stk7700ph_dib7700_xc3028_config);
 
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
@@ -690,7 +690,7 @@ static int stk7700p_frontend_attach(struct dvb_usb_adapter *adap)
 	st->mt2060_if1[0] = 1220;
 
 	if (dib7000pc_detection(&adap->dev->i2c_adap)) {
-		adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000p_config);
+		adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 18, &stk7700p_dib7000p_config);
 		st->is_dib7000pc = 1;
 	} else
 		adap->fe_adap[0].fe = dvb_attach(dib7000m_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000m_config);
@@ -961,7 +961,7 @@ static int stk7070p_frontend_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
+	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x80,
 		&dib7070p_dib7000p_config);
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
 }
@@ -1013,7 +1013,7 @@ static int stk7770p_frontend_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
+	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x80,
 		&dib7770p_dib7000p_config);
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
 }
@@ -2899,7 +2899,7 @@ static int nim7090_frontend_attach(struct dvb_usb_adapter *adap)
 		err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n", __func__);
 		return -ENODEV;
 	}
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80, &nim7090_dib7000p_config);
+	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x80, &nim7090_dib7000p_config);
 
 	return adap->fe_adap[0].fe == NULL ?  -ENODEV : 0;
 }
@@ -2945,7 +2945,7 @@ static int tfe7090pvr_frontend0_attach(struct dvb_usb_adapter *adap)
 	}
 
 	dib0700_set_i2c_speed(adap->dev, 340);
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x90, &tfe7090pvr_dib7000p_config[0]);
+	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x90, &tfe7090pvr_dib7000p_config[0]);
 	if (adap->fe_adap[0].fe == NULL)
 		return -ENODEV;
 
@@ -2969,7 +2969,7 @@ static int tfe7090pvr_frontend1_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, i2c, 0x92, &tfe7090pvr_dib7000p_config[1]);
+	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, i2c, 0x92, &tfe7090pvr_dib7000p_config[1]);
 	dib0700_set_i2c_speed(adap->dev, 200);
 
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
@@ -3030,7 +3030,7 @@ static int tfe7790p_frontend_attach(struct dvb_usb_adapter *adap)
 				__func__);
 		return -ENODEV;
 	}
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap,
+	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap,
 			0x80, &tfe7790p_dib7000p_config);
 
 	return adap->fe_adap[0].fe == NULL ?  -ENODEV : 0;
@@ -3115,13 +3115,13 @@ static int stk7070pd_frontend_attach0(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80, &stk7070pd_dib7000p_config[0]);
+	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x80, &stk7070pd_dib7000p_config[0]);
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
 }
 
 static int stk7070pd_frontend_attach1(struct dvb_usb_adapter *adap)
 {
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x82, &stk7070pd_dib7000p_config[1]);
+	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x82, &stk7070pd_dib7000p_config[1]);
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
 }
 
@@ -3181,7 +3181,7 @@ static int novatd_frontend_attach(struct dvb_usb_adapter *adap)
 		}
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, &dev->i2c_adap,
+	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &dev->i2c_adap,
 			adap->id == 0 ? 0x80 : 0x82,
 			&stk7070pd_dib7000p_config[adap->id]);
 
@@ -3402,7 +3402,7 @@ static int pctv340e_frontend_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x12,
+	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x12,
 			      &pctv_340e_config);
 	st->is_dib7000pc = 1;
 
-- 
1.9.3

