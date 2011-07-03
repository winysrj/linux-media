Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:51024 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751301Ab1GCQ5o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 12:57:44 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 09/16] ngene: Codingstyle fixes
Date: Sun, 3 Jul 2011 18:56:28 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107031831.20378@orion.escape-edv.de>
In-Reply-To: <201107031831.20378@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107031856.29895@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Codingstyle fixes

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/media/dvb/ngene/ngene-cards.c |   36 +++++++++++++-------------------
 drivers/media/dvb/ngene/ngene-core.c  |   14 ++++++------
 drivers/media/dvb/ngene/ngene-dvb.c   |    4 +-
 drivers/media/dvb/ngene/ngene.h       |    2 +-
 4 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/drivers/media/dvb/ngene/ngene-cards.c b/drivers/media/dvb/ngene/ngene-cards.c
index ca2e146..0d550a9 100644
--- a/drivers/media/dvb/ngene/ngene-cards.c
+++ b/drivers/media/dvb/ngene/ngene-cards.c
@@ -40,6 +40,7 @@
 #include "lnbh24.h"
 #include "lgdt330x.h"
 #include "mt2131.h"
+#include "tda18271c2dd.h"
 #include "drxk.h"
 
 
@@ -99,9 +100,6 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 	return status;
 }
 
-struct dvb_frontend *tda18271c2dd_attach(struct dvb_frontend *fe,
-					 struct i2c_adapter *i2c, u8 adr);
-
 static int tuner_attach_tda18271(struct ngene_channel *chan)
 {
 	struct i2c_adapter *i2c;
@@ -114,7 +112,7 @@ static int tuner_attach_tda18271(struct ngene_channel *chan)
 	if (chan->fe->ops.i2c_gate_ctrl)
 		chan->fe->ops.i2c_gate_ctrl(chan->fe, 0);
 	if (!fe) {
-		printk("No TDA18271 found!\n");
+		printk(KERN_ERR "No TDA18271 found!\n");
 		return -ENODEV;
 	}
 
@@ -180,7 +178,7 @@ static void cineS2_tuner_i2c_lock(struct dvb_frontend *fe, int lock)
 static int i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val)
 {
 	struct i2c_msg msgs[1] = {{.addr = adr,  .flags = I2C_M_RD,
-				   .buf  = val,  .len   = 1 }};
+				   .buf  = val,  .len   = 1 } };
 	return (i2c_transfer(adapter, msgs, 1) == 1) ? 0 : -1;
 }
 
@@ -191,7 +189,7 @@ static int i2c_read_reg16(struct i2c_adapter *adapter, u8 adr,
 	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
 				   .buf  = msg, .len   = 2},
 				  {.addr = adr, .flags = I2C_M_RD,
-				   .buf  = val, .len   = 1}};
+				   .buf  = val, .len   = 1} };
 	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
 }
 
@@ -209,25 +207,22 @@ static int port_has_drxk(struct i2c_adapter *i2c, int port)
 
 	if (i2c_read(i2c, 0x29+port, &val) < 0)
 		return 0;
-	printk("DRXK@%02x\n", 0x29+port);
 	return 1;
 }
 
 static int demod_attach_drxk(struct ngene_channel *chan,
 			     struct i2c_adapter *i2c)
 {
-	struct dvb_frontend *fe;
-
-	chan->fe = fe = dvb_attach(drxk_attach,
+	chan->fe = dvb_attach(drxk_attach,
 				   i2c, 0x29 + (chan->number^2),
 				   &chan->fe2);
 	if (!chan->fe) {
-		printk("No DRXK found!\n");
+		printk(KERN_ERR "No DRXK found!\n");
 		return -ENODEV;
 	}
-	fe->sec_priv = chan;
-	chan->gate_ctrl = fe->ops.i2c_gate_ctrl;
-	fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
+	chan->fe->sec_priv = chan;
+	chan->gate_ctrl = chan->fe->ops.i2c_gate_ctrl;
+	chan->fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
 	return 0;
 }
 
@@ -246,19 +241,18 @@ static int cineS2_probe(struct ngene_channel *chan)
 		i2c = &chan->dev->channel[1].i2c_adapter;
 
 	if (port_has_stv0900(i2c, chan->number)) {
-		chan->demod_type=0;
+		chan->demod_type = 0;
 		fe_conf = chan->dev->card_info->fe_config[chan->number];
 		/* demod found, attach it */
 		rc = demod_attach_stv0900(chan);
 		if (rc < 0 || chan->number < 2)
 			return rc;
-  
+
 		/* demod #2: reprogram outputs DPN1 & DPN2 */
 		i2c_msg.addr = fe_conf->address;
 		i2c_msg.len = 3;
 		buf[0] = 0xf1;
-		switch (chan->number)
-		{
+		switch (chan->number) {
 		case 2:
 			buf[1] = 0x5c;
 			buf[2] = 0xc2;
@@ -276,10 +270,10 @@ static int cineS2_probe(struct ngene_channel *chan)
 			return -EIO;
 		}
 	} else if (port_has_drxk(i2c, chan->number^2)) {
-		chan->demod_type=1;
+		chan->demod_type = 1;
 		demod_attach_drxk(chan, i2c);
 	} else {
-		printk("No demod found on chan %d\n", chan->number);
+		printk(KERN_ERR "No demod found on chan %d\n", chan->number);
 	}
 	return 0;
 }
@@ -497,7 +491,7 @@ MODULE_DEVICE_TABLE(pci, ngene_id_tbl);
 /****************************************************************************/
 
 static pci_ers_result_t ngene_error_detected(struct pci_dev *dev,
-					    enum pci_channel_state state)
+					     enum pci_channel_state state)
 {
 	printk(KERN_ERR DEVICE_NAME ": PCI error\n");
 	if (state == pci_channel_io_perm_failure)
diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
index c59bf50..fa4b3eb 100644
--- a/drivers/media/dvb/ngene/ngene-core.c
+++ b/drivers/media/dvb/ngene/ngene-core.c
@@ -41,7 +41,7 @@
 
 #include "ngene.h"
 
-static int one_adapter = 0;
+static int one_adapter;
 module_param(one_adapter, int, 0444);
 MODULE_PARM_DESC(one_adapter, "Use only one adapter.");
 
@@ -1443,9 +1443,9 @@ static void release_channel(struct ngene_channel *chan)
 		chan->ci_dev = NULL;
 	}
 
-	if (chan->fe2) {
+	if (chan->fe2)
 		dvb_unregister_frontend(chan->fe2);
-	}
+
 	if (chan->fe) {
 		dvb_unregister_frontend(chan->fe);
 		dvb_frontend_detach(chan->fe);
@@ -1540,10 +1540,10 @@ static int init_channel(struct ngene_channel *chan)
 	if (chan->fe2) {
 		if (dvb_register_frontend(adapter, chan->fe2) < 0)
 			goto err;
-			chan->fe2->tuner_priv=chan->fe->tuner_priv;
-			memcpy(&chan->fe2->ops.tuner_ops,
-			       &chan->fe->ops.tuner_ops,
-			       sizeof(struct dvb_tuner_ops));
+		chan->fe2->tuner_priv = chan->fe->tuner_priv;
+		memcpy(&chan->fe2->ops.tuner_ops,
+		       &chan->fe->ops.tuner_ops,
+		       sizeof(struct dvb_tuner_ops));
 	}
 
 	if (chan->has_demux) {
diff --git a/drivers/media/dvb/ngene/ngene-dvb.c b/drivers/media/dvb/ngene/ngene-dvb.c
index 0b49432..ba209cb 100644
--- a/drivers/media/dvb/ngene/ngene-dvb.c
+++ b/drivers/media/dvb/ngene/ngene-dvb.c
@@ -133,9 +133,9 @@ void *tsin_exchange(void *priv, void *buf, u32 len, u32 clock, u32 flags)
 		}
 		return 0;
 	}
-	if (chan->users > 0) {
+	if (chan->users > 0)
 		dvb_dmx_swfilter(&chan->demux, buf, len);
-	}
+
 	return NULL;
 }
 
diff --git a/drivers/media/dvb/ngene/ngene.h b/drivers/media/dvb/ngene/ngene.h
index e8cd93d..90fa136 100644
--- a/drivers/media/dvb/ngene/ngene.h
+++ b/drivers/media/dvb/ngene/ngene.h
@@ -855,7 +855,7 @@ struct ngene_info {
 };
 
 #ifdef NGENE_V4L
-struct ngene_format{
+struct ngene_format {
 	char *name;
 	int   fourcc;          /* video4linux 2      */
 	int   btformat;        /* BT848_COLOR_FMT_*  */
-- 
1.7.4.1

