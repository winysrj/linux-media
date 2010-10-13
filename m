Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:42415 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab0JMMYc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 08:24:32 -0400
Date: Wed, 13 Oct 2010 14:24:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linux I2C <linux-i2c@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] i2c: Stop using I2C_CLASS_TV_DIGITAL
Message-ID: <20101013142425.4b1007f7@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Detection class I2C_CLASS_TV_DIGITAL is set by many adapters but no
I2C device driver is setting it anymore, which means it can be
dropped. I2C devices on digital TV adapters are instantiated
explicitly these days, which is much better.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/media/dvb/b2c2/flexcop-i2c.c              |    3 ---
 drivers/media/dvb/dm1105/dm1105.c                 |    1 -
 drivers/media/dvb/dvb-usb/af9015.c                |    5 -----
 drivers/media/dvb/dvb-usb/dvb-usb-i2c.c           |    1 -
 drivers/media/dvb/frontends/cx24123.c             |    1 -
 drivers/media/dvb/frontends/dibx000_common.c      |    1 -
 drivers/media/dvb/frontends/s5h1420.c             |    1 -
 drivers/media/dvb/mantis/mantis_i2c.c             |    1 -
 drivers/media/dvb/ngene/ngene-i2c.c               |    1 -
 drivers/media/dvb/pluto2/pluto2.c                 |    1 -
 drivers/media/dvb/pt1/pt1.c                       |    1 -
 drivers/media/dvb/ttpci/av7110.c                  |    1 -
 drivers/media/dvb/ttpci/budget-core.c             |    2 --
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |    1 -
 drivers/media/video/cx88/cx88-vp3054-i2c.c        |    2 --
 15 files changed, 23 deletions(-)

--- linux-2.6.36-rc7.orig/drivers/media/dvb/b2c2/flexcop-i2c.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/b2c2/flexcop-i2c.c	2010-10-13 12:37:39.000000000 +0200
@@ -245,9 +245,6 @@ int flexcop_i2c_init(struct flexcop_devi
 	i2c_set_adapdata(&fc->fc_i2c_adap[1].i2c_adap, &fc->fc_i2c_adap[1]);
 	i2c_set_adapdata(&fc->fc_i2c_adap[2].i2c_adap, &fc->fc_i2c_adap[2]);
 
-	fc->fc_i2c_adap[0].i2c_adap.class =
-		fc->fc_i2c_adap[1].i2c_adap.class =
-		fc->fc_i2c_adap[2].i2c_adap.class = I2C_CLASS_TV_DIGITAL;
 	fc->fc_i2c_adap[0].i2c_adap.algo =
 		fc->fc_i2c_adap[1].i2c_adap.algo =
 		fc->fc_i2c_adap[2].i2c_adap.algo = &flexcop_algo;
--- linux-2.6.36-rc7.orig/drivers/media/dvb/dm1105/dm1105.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/dm1105/dm1105.c	2010-10-13 12:37:39.000000000 +0200
@@ -862,7 +862,6 @@ static int __devinit dm1105_probe(struct
 	i2c_set_adapdata(&dev->i2c_adap, dev);
 	strcpy(dev->i2c_adap.name, DRIVER_NAME);
 	dev->i2c_adap.owner = THIS_MODULE;
-	dev->i2c_adap.class = I2C_CLASS_TV_DIGITAL;
 	dev->i2c_adap.dev.parent = &pdev->dev;
 	dev->i2c_adap.algo = &dm1105_algo;
 	dev->i2c_adap.algo_data = dev;
--- linux-2.6.36-rc7.orig/drivers/media/dvb/dvb-usb/af9015.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/dvb-usb/af9015.c	2010-10-13 12:37:39.000000000 +0200
@@ -1100,11 +1100,6 @@ static int af9015_i2c_init(struct dvb_us
 
 	strncpy(state->i2c_adap.name, d->desc->name,
 		sizeof(state->i2c_adap.name));
-#ifdef I2C_ADAP_CLASS_TV_DIGITAL
-	state->i2c_adap.class = I2C_ADAP_CLASS_TV_DIGITAL,
-#else
-	state->i2c_adap.class = I2C_CLASS_TV_DIGITAL,
-#endif
 	state->i2c_adap.algo      = d->props.i2c_algo;
 	state->i2c_adap.algo_data = NULL;
 	state->i2c_adap.dev.parent = &d->udev->dev;
--- linux-2.6.36-rc7.orig/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c	2010-10-13 12:37:39.000000000 +0200
@@ -20,7 +20,6 @@ int dvb_usb_i2c_init(struct dvb_usb_devi
 	}
 
 	strlcpy(d->i2c_adap.name, d->desc->name, sizeof(d->i2c_adap.name));
-	d->i2c_adap.class = I2C_CLASS_TV_DIGITAL,
 	d->i2c_adap.algo      = d->props.i2c_algo;
 	d->i2c_adap.algo_data = NULL;
 	d->i2c_adap.dev.parent = &d->udev->dev;
--- linux-2.6.36-rc7.orig/drivers/media/dvb/frontends/cx24123.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/frontends/cx24123.c	2010-10-13 12:37:39.000000000 +0200
@@ -1108,7 +1108,6 @@ struct dvb_frontend *cx24123_attach(cons
 
 	strlcpy(state->tuner_i2c_adapter.name, "CX24123 tuner I2C bus",
 		sizeof(state->tuner_i2c_adapter.name));
-	state->tuner_i2c_adapter.class     = I2C_CLASS_TV_DIGITAL,
 	state->tuner_i2c_adapter.algo      = &cx24123_tuner_i2c_algo;
 	state->tuner_i2c_adapter.algo_data = NULL;
 	i2c_set_adapdata(&state->tuner_i2c_adapter, state);
--- linux-2.6.36-rc7.orig/drivers/media/dvb/frontends/dibx000_common.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/frontends/dibx000_common.c	2010-10-13 12:37:39.000000000 +0200
@@ -130,7 +130,6 @@ static int i2c_adapter_init(struct i2c_a
 			    struct dibx000_i2c_master *mst)
 {
 	strncpy(i2c_adap->name, name, sizeof(i2c_adap->name));
-	i2c_adap->class = I2C_CLASS_TV_DIGITAL, i2c_adap->algo = algo;
 	i2c_adap->algo_data = NULL;
 	i2c_set_adapdata(i2c_adap, mst);
 	if (i2c_add_adapter(i2c_adap) < 0)
--- linux-2.6.36-rc7.orig/drivers/media/dvb/frontends/s5h1420.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/frontends/s5h1420.c	2010-10-13 12:37:39.000000000 +0200
@@ -920,7 +920,6 @@ struct dvb_frontend *s5h1420_attach(cons
 	/* create tuner i2c adapter */
 	strlcpy(state->tuner_i2c_adapter.name, "S5H1420-PN1010 tuner I2C bus",
 		sizeof(state->tuner_i2c_adapter.name));
-	state->tuner_i2c_adapter.class     = I2C_CLASS_TV_DIGITAL,
 	state->tuner_i2c_adapter.algo      = &s5h1420_tuner_i2c_algo;
 	state->tuner_i2c_adapter.algo_data = NULL;
 	i2c_set_adapdata(&state->tuner_i2c_adapter, state);
--- linux-2.6.36-rc7.orig/drivers/media/dvb/mantis/mantis_i2c.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/mantis/mantis_i2c.c	2010-10-13 12:37:39.000000000 +0200
@@ -229,7 +229,6 @@ int __devinit mantis_i2c_init(struct man
 	i2c_set_adapdata(i2c_adapter, mantis);
 
 	i2c_adapter->owner	= THIS_MODULE;
-	i2c_adapter->class	= I2C_CLASS_TV_DIGITAL;
 	i2c_adapter->algo	= &mantis_algo;
 	i2c_adapter->algo_data	= NULL;
 	i2c_adapter->timeout	= 500;
--- linux-2.6.36-rc7.orig/drivers/media/dvb/ngene/ngene-i2c.c	2010-10-13 12:36:50.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/ngene/ngene-i2c.c	2010-10-13 12:37:39.000000000 +0200
@@ -165,7 +165,6 @@ int ngene_i2c_init(struct ngene *dev, in
 	struct i2c_adapter *adap = &(dev->channel[dev_nr].i2c_adapter);
 
 	i2c_set_adapdata(adap, &(dev->channel[dev_nr]));
-	adap->class = I2C_CLASS_TV_DIGITAL;
 
 	strcpy(adap->name, "nGene");
 
--- linux-2.6.36-rc7.orig/drivers/media/dvb/pluto2/pluto2.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/pluto2/pluto2.c	2010-10-13 12:37:39.000000000 +0200
@@ -647,7 +647,6 @@ static int __devinit pluto2_probe(struct
 	i2c_set_adapdata(&pluto->i2c_adap, pluto);
 	strcpy(pluto->i2c_adap.name, DRIVER_NAME);
 	pluto->i2c_adap.owner = THIS_MODULE;
-	pluto->i2c_adap.class = I2C_CLASS_TV_DIGITAL;
 	pluto->i2c_adap.dev.parent = &pdev->dev;
 	pluto->i2c_adap.algo_data = &pluto->i2c_bit;
 	pluto->i2c_bit.data = pluto;
--- linux-2.6.36-rc7.orig/drivers/media/dvb/pt1/pt1.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/pt1/pt1.c	2010-10-13 12:37:39.000000000 +0200
@@ -1087,7 +1087,6 @@ pt1_probe(struct pci_dev *pdev, const st
 	pt1_update_power(pt1);
 
 	i2c_adap = &pt1->i2c_adap;
-	i2c_adap->class = I2C_CLASS_TV_DIGITAL;
 	i2c_adap->algo = &pt1_i2c_algo;
 	i2c_adap->algo_data = NULL;
 	i2c_adap->dev.parent = &pdev->dev;
--- linux-2.6.36-rc7.orig/drivers/media/dvb/ttpci/av7110.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/ttpci/av7110.c	2010-10-13 12:37:39.000000000 +0200
@@ -2476,7 +2476,6 @@ static int __devinit av7110_attach(struc
 	   get recognized before the main driver is fully loaded */
 	saa7146_write(dev, GPIO_CTRL, 0x500000);
 
-	av7110->i2c_adap.class = I2C_CLASS_TV_DIGITAL;
 	strlcpy(av7110->i2c_adap.name, pci_ext->ext_priv, sizeof(av7110->i2c_adap.name));
 
 	saa7146_i2c_adapter_prepare(dev, &av7110->i2c_adap, SAA7146_I2C_BUS_BIT_RATE_120); /* 275 kHz */
--- linux-2.6.36-rc7.orig/drivers/media/dvb/ttpci/budget-core.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/ttpci/budget-core.c	2010-10-13 12:37:39.000000000 +0200
@@ -495,8 +495,6 @@ int ttpci_budget_init(struct budget *bud
 	if (bi->type != BUDGET_FS_ACTIVY)
 		saa7146_write(dev, GPIO_CTRL, 0x500000);	/* GPIO 3 = 1 */
 
-	budget->i2c_adap.class = I2C_CLASS_TV_DIGITAL;
-
 	strlcpy(budget->i2c_adap.name, budget->card->name, sizeof(budget->i2c_adap.name));
 
 	saa7146_i2c_adapter_prepare(dev, &budget->i2c_adap, SAA7146_I2C_BUS_BIT_RATE_120);
--- linux-2.6.36-rc7.orig/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c	2010-10-13 12:37:39.000000000 +0200
@@ -1694,7 +1694,6 @@ static int ttusb_probe(struct usb_interf
 
 	i2c_set_adapdata(&ttusb->i2c_adap, ttusb);
 
-	ttusb->i2c_adap.class		  = I2C_CLASS_TV_DIGITAL;
 	ttusb->i2c_adap.algo              = &ttusb_dec_algo;
 	ttusb->i2c_adap.algo_data         = NULL;
 	ttusb->i2c_adap.dev.parent	  = &udev->dev;
--- linux-2.6.36-rc7.orig/drivers/media/video/cx88/cx88-vp3054-i2c.c	2010-10-13 12:36:36.000000000 +0200
+++ linux-2.6.36-rc7/drivers/media/video/cx88/cx88-vp3054-i2c.c	2010-10-13 12:37:39.000000000 +0200
@@ -121,8 +121,6 @@ int vp3054_i2c_probe(struct cx8802_dev *
 	memcpy(&vp3054_i2c->algo, &vp3054_i2c_algo_template,
 	       sizeof(vp3054_i2c->algo));
 
-	vp3054_i2c->adap.class |= I2C_CLASS_TV_DIGITAL;
-
 	vp3054_i2c->adap.dev.parent = &dev->pci->dev;
 	strlcpy(vp3054_i2c->adap.name, core->name,
 		sizeof(vp3054_i2c->adap.name));


-- 
Jean Delvare
