Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:50993 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751082Ab1GCQ5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 12:57:43 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 08/16] ngene: Support Digital Devices DuoFlex CT
Date: Sun, 3 Jul 2011 18:55:06 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107031831.20378@orion.escape-edv.de>
In-Reply-To: <201107031831.20378@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107031855.07372@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Ralph Metzler <rmetzler@digitaldevices.de>

Support Digital Devices DuoFlex CT with ngene.

Signed-off-by: Ralph Metzler <rmetzler@digitaldevices.de>
Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/media/dvb/ngene/Kconfig       |    2 +
 drivers/media/dvb/ngene/ngene-cards.c |  176 ++++++++++++++++++++++++++-------
 drivers/media/dvb/ngene/ngene-core.c  |   15 +++-
 drivers/media/dvb/ngene/ngene.h       |    3 +
 4 files changed, 156 insertions(+), 40 deletions(-)

diff --git a/drivers/media/dvb/ngene/Kconfig b/drivers/media/dvb/ngene/Kconfig
index cec242b..64c8470 100644
--- a/drivers/media/dvb/ngene/Kconfig
+++ b/drivers/media/dvb/ngene/Kconfig
@@ -5,6 +5,8 @@ config DVB_NGENE
 	select DVB_STV6110x if !DVB_FE_CUSTOMISE
 	select DVB_STV090x if !DVB_FE_CUSTOMISE
 	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
+	select DVB_DRXK if !DVB_FE_CUSTOMISE
+	select DVB_TDA18271C2DD if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_MT2131 if !MEDIA_TUNER_CUSTOMISE
 	---help---
 	  Support for Micronas PCI express cards with nGene bridge.
diff --git a/drivers/media/dvb/ngene/ngene-cards.c b/drivers/media/dvb/ngene/ngene-cards.c
index fcf4be9..ca2e146 100644
--- a/drivers/media/dvb/ngene/ngene-cards.c
+++ b/drivers/media/dvb/ngene/ngene-cards.c
@@ -40,6 +40,7 @@
 #include "lnbh24.h"
 #include "lgdt330x.h"
 #include "mt2131.h"
+#include "drxk.h"
 
 
 /****************************************************************************/
@@ -83,6 +84,52 @@ static int tuner_attach_stv6110(struct ngene_channel *chan)
 }
 
 
+static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct ngene_channel *chan = fe->sec_priv;
+	int status;
+
+	if (enable) {
+		down(&chan->dev->pll_mutex);
+		status = chan->gate_ctrl(fe, 1);
+	} else {
+		status = chan->gate_ctrl(fe, 0);
+		up(&chan->dev->pll_mutex);
+	}
+	return status;
+}
+
+struct dvb_frontend *tda18271c2dd_attach(struct dvb_frontend *fe,
+					 struct i2c_adapter *i2c, u8 adr);
+
+static int tuner_attach_tda18271(struct ngene_channel *chan)
+{
+	struct i2c_adapter *i2c;
+	struct dvb_frontend *fe;
+
+	i2c = &chan->dev->channel[0].i2c_adapter;
+	if (chan->fe->ops.i2c_gate_ctrl)
+		chan->fe->ops.i2c_gate_ctrl(chan->fe, 1);
+	fe = dvb_attach(tda18271c2dd_attach, chan->fe, i2c, 0x60);
+	if (chan->fe->ops.i2c_gate_ctrl)
+		chan->fe->ops.i2c_gate_ctrl(chan->fe, 0);
+	if (!fe) {
+		printk("No TDA18271 found!\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int tuner_attach_probe(struct ngene_channel *chan)
+{
+	if (chan->demod_type == 0)
+		return tuner_attach_stv6110(chan);
+	if (chan->demod_type == 1)
+		return tuner_attach_tda18271(chan);
+	return -EINVAL;
+}
+
 static int demod_attach_stv0900(struct ngene_channel *chan)
 {
 	struct i2c_adapter *i2c;
@@ -130,6 +177,60 @@ static void cineS2_tuner_i2c_lock(struct dvb_frontend *fe, int lock)
 		up(&chan->dev->pll_mutex);
 }
 
+static int i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val)
+{
+	struct i2c_msg msgs[1] = {{.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = val,  .len   = 1 }};
+	return (i2c_transfer(adapter, msgs, 1) == 1) ? 0 : -1;
+}
+
+static int i2c_read_reg16(struct i2c_adapter *adapter, u8 adr,
+			  u16 reg, u8 *val)
+{
+	u8 msg[2] = {reg>>8, reg&0xff};
+	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
+				   .buf  = msg, .len   = 2},
+				  {.addr = adr, .flags = I2C_M_RD,
+				   .buf  = val, .len   = 1}};
+	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
+}
+
+static int port_has_stv0900(struct i2c_adapter *i2c, int port)
+{
+	u8 val;
+	if (i2c_read_reg16(i2c, 0x68+port/2, 0xf100, &val) < 0)
+		return 0;
+	return 1;
+}
+
+static int port_has_drxk(struct i2c_adapter *i2c, int port)
+{
+	u8 val;
+
+	if (i2c_read(i2c, 0x29+port, &val) < 0)
+		return 0;
+	printk("DRXK@%02x\n", 0x29+port);
+	return 1;
+}
+
+static int demod_attach_drxk(struct ngene_channel *chan,
+			     struct i2c_adapter *i2c)
+{
+	struct dvb_frontend *fe;
+
+	chan->fe = fe = dvb_attach(drxk_attach,
+				   i2c, 0x29 + (chan->number^2),
+				   &chan->fe2);
+	if (!chan->fe) {
+		printk("No DRXK found!\n");
+		return -ENODEV;
+	}
+	fe->sec_priv = chan;
+	chan->gate_ctrl = fe->ops.i2c_gate_ctrl;
+	fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
+	return 0;
+}
+
 static int cineS2_probe(struct ngene_channel *chan)
 {
 	struct i2c_adapter *i2c;
@@ -144,43 +245,42 @@ static int cineS2_probe(struct ngene_channel *chan)
 	else
 		i2c = &chan->dev->channel[1].i2c_adapter;
 
-	fe_conf = chan->dev->card_info->fe_config[chan->number];
-	i2c_msg.addr = fe_conf->address;
-
-	/* probe demod */
-	i2c_msg.len = 2;
-	buf[0] = 0xf1;
-	buf[1] = 0x00;
-	rc = i2c_transfer(i2c, &i2c_msg, 1);
-	if (rc != 1)
-		return -ENODEV;
-
-	/* demod found, attach it */
-	rc = demod_attach_stv0900(chan);
-	if (rc < 0 || chan->number < 2)
-		return rc;
-
-	/* demod #2: reprogram outputs DPN1 & DPN2 */
-	i2c_msg.len = 3;
-	buf[0] = 0xf1;
-	switch (chan->number) {
-	case 2:
-		buf[1] = 0x5c;
-		buf[2] = 0xc2;
-		break;
-	case 3:
-		buf[1] = 0x61;
-		buf[2] = 0xcc;
-		break;
-	default:
-		return -ENODEV;
+	if (port_has_stv0900(i2c, chan->number)) {
+		chan->demod_type=0;
+		fe_conf = chan->dev->card_info->fe_config[chan->number];
+		/* demod found, attach it */
+		rc = demod_attach_stv0900(chan);
+		if (rc < 0 || chan->number < 2)
+			return rc;
+  
+		/* demod #2: reprogram outputs DPN1 & DPN2 */
+		i2c_msg.addr = fe_conf->address;
+		i2c_msg.len = 3;
+		buf[0] = 0xf1;
+		switch (chan->number)
+		{
+		case 2:
+			buf[1] = 0x5c;
+			buf[2] = 0xc2;
+			break;
+		case 3:
+			buf[1] = 0x61;
+			buf[2] = 0xcc;
+			break;
+		default:
+			return -ENODEV;
+		}
+		rc = i2c_transfer(i2c, &i2c_msg, 1);
+		if (rc != 1) {
+			printk(KERN_ERR DEVICE_NAME ": could not setup DPNx\n");
+			return -EIO;
+		}
+	} else if (port_has_drxk(i2c, chan->number^2)) {
+		chan->demod_type=1;
+		demod_attach_drxk(chan, i2c);
+	} else {
+		printk("No demod found on chan %d\n", chan->number);
 	}
-	rc = i2c_transfer(i2c, &i2c_msg, 1);
-	if (rc != 1) {
-		printk(KERN_ERR DEVICE_NAME ": could not setup DPNx\n");
-		return -EIO;
-	}
-
 	return 0;
 }
 
@@ -337,7 +437,7 @@ static struct ngene_info ngene_info_duoFlexS2 = {
 	.io_type        = {NGENE_IO_TSIN, NGENE_IO_TSIN, NGENE_IO_TSIN, NGENE_IO_TSIN,
 			   NGENE_IO_TSOUT},
 	.demod_attach   = {cineS2_probe, cineS2_probe, cineS2_probe, cineS2_probe},
-	.tuner_attach   = {tuner_attach_stv6110, tuner_attach_stv6110, tuner_attach_stv6110, tuner_attach_stv6110},
+	.tuner_attach   = {tuner_attach_probe, tuner_attach_probe, tuner_attach_probe, tuner_attach_probe},
 	.fe_config      = {&fe_cineS2, &fe_cineS2, &fe_cineS2_2, &fe_cineS2_2},
 	.tuner_config   = {&tuner_cineS2_0, &tuner_cineS2_1, &tuner_cineS2_0, &tuner_cineS2_1},
 	.lnb            = {0x0a, 0x08, 0x0b, 0x09},
@@ -397,7 +497,7 @@ MODULE_DEVICE_TABLE(pci, ngene_id_tbl);
 /****************************************************************************/
 
 static pci_ers_result_t ngene_error_detected(struct pci_dev *dev,
-					     enum pci_channel_state state)
+					    enum pci_channel_state state)
 {
 	printk(KERN_ERR DEVICE_NAME ": PCI error\n");
 	if (state == pci_channel_io_perm_failure)
diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
index 6927c72..c59bf50 100644
--- a/drivers/media/dvb/ngene/ngene-core.c
+++ b/drivers/media/dvb/ngene/ngene-core.c
@@ -41,7 +41,7 @@
 
 #include "ngene.h"
 
-static int one_adapter = 1;
+static int one_adapter = 0;
 module_param(one_adapter, int, 0444);
 MODULE_PARM_DESC(one_adapter, "Use only one adapter.");
 
@@ -461,7 +461,7 @@ static u8 TSFeatureDecoderSetup[8 * 5] = {
 	0x42, 0x00, 0x00, 0x02, 0x02, 0xbc, 0x00, 0x00,
 	0x40, 0x06, 0x00, 0x02, 0x02, 0xbc, 0x00, 0x00,	/* DRXH */
 	0x71, 0x07, 0x00, 0x02, 0x02, 0xbc, 0x00, 0x00,	/* DRXHser */
-	0x72, 0x06, 0x00, 0x02, 0x02, 0xbc, 0x00, 0x00,	/* S2ser */
+	0x72, 0x00, 0x00, 0x02, 0x02, 0xbc, 0x00, 0x00,	/* S2ser */
 	0x40, 0x07, 0x00, 0x02, 0x02, 0xbc, 0x00, 0x00, /* LGDT3303 */
 };
 
@@ -1443,6 +1443,9 @@ static void release_channel(struct ngene_channel *chan)
 		chan->ci_dev = NULL;
 	}
 
+	if (chan->fe2) {
+		dvb_unregister_frontend(chan->fe2);
+	}
 	if (chan->fe) {
 		dvb_unregister_frontend(chan->fe);
 		dvb_frontend_detach(chan->fe);
@@ -1534,6 +1537,14 @@ static int init_channel(struct ngene_channel *chan)
 			goto err;
 		chan->has_demux = true;
 	}
+	if (chan->fe2) {
+		if (dvb_register_frontend(adapter, chan->fe2) < 0)
+			goto err;
+			chan->fe2->tuner_priv=chan->fe->tuner_priv;
+			memcpy(&chan->fe2->ops.tuner_ops,
+			       &chan->fe->ops.tuner_ops,
+			       sizeof(struct dvb_tuner_ops));
+	}
 
 	if (chan->has_demux) {
 		ret = my_dvb_dmx_ts_card_init(dvbdemux, "SW demux",
diff --git a/drivers/media/dvb/ngene/ngene.h b/drivers/media/dvb/ngene/ngene.h
index 40fce9e..e8cd93d 100644
--- a/drivers/media/dvb/ngene/ngene.h
+++ b/drivers/media/dvb/ngene/ngene.h
@@ -641,8 +641,11 @@ struct ngene_channel {
 	int                   mode;
 	bool                  has_adapter;
 	bool                  has_demux;
+	int                   demod_type;
+	int (*gate_ctrl)(struct dvb_frontend *, int);
 
 	struct dvb_frontend  *fe;
+	struct dvb_frontend  *fe2;
 	struct dmxdev         dmxdev;
 	struct dvb_demux      demux;
 	struct dvb_net        dvbnet;
-- 
1.7.4.1

