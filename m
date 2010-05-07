Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:50110 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab0EGObP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 10:31:15 -0400
Received: by wwa36 with SMTP id 36so15227wwa.19
        for <linux-media@vger.kernel.org>; Fri, 07 May 2010 07:31:13 -0700 (PDT)
Subject: [PATCH] Support for the Geniatech/Mygica A680B (05e1:0480)
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
To: LMML <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-wnZ1o+IOjWmLSrikUfGx"
Date: Fri, 07 May 2010 07:31:07 -0700
Message-ID: <1273242667.6020.15.camel@chimera>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-wnZ1o+IOjWmLSrikUfGx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Some time ago, Michael Krufky started a mercurial tree for this device
and related ones. I began this patch from his changes, but all that
remains from them are the (largely non-applicable) tuner-attaching code
and identifier names. I have been very careful to make sure the chip
driver changes in this patch are no-ops on already supported devices,
which I can't test; I recommend those who can test them to enable those
changes as appropriate.

I had hoped to include IR support in this patch, but the IR core does
not currently build against the .31 kernel with which I am testing, so
that will need to be a second patch when more feasible. To review, every
100ms, bit 4 is set in register 0xe0 in the AU8524 demod, register 0xe1
is read, and if bit 4 is on in it, 0x28 bytes are read from 0xe3.

--=-wnZ1o+IOjWmLSrikUfGx
Content-Disposition: inline; filename="a680b.patch"
Content-Type: text/x-patch; name="a680b.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Signed-off-by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
diff --git a/drivers/media/dvb/frontends/au8522.h b/drivers/media/dvb/frontends/au8522.h
index 565dcf3..c798919 100644
--- a/drivers/media/dvb/frontends/au8522.h
+++ b/drivers/media/dvb/frontends/au8522.h
@@ -58,6 +58,7 @@ struct au8522_config {
 
 	enum au8522_if_freq vsb_if;
 	enum au8522_if_freq qam_if;
+	int flakiness;
 };
 
 #if defined(CONFIG_DVB_AU8522) || 				\
diff --git a/drivers/media/dvb/frontends/au8522_dig.c b/drivers/media/dvb/frontends/au8522_dig.c
index 44390e2..6ca878f 100644
--- a/drivers/media/dvb/frontends/au8522_dig.c
+++ b/drivers/media/dvb/frontends/au8522_dig.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/time.h>
 #include <linux/delay.h>
 #include "dvb_frontend.h"
 #include "au8522.h"
@@ -36,6 +37,7 @@ static int debug;
 static LIST_HEAD(hybrid_tuner_instance_list);
 static DEFINE_MUTEX(au8522_list_mutex);
 
+#define LOCK_DELAY 1
 #define dprintk(arg...)\
 	do { if (debug)\
 		printk(arg);\
@@ -606,6 +608,7 @@ static int au8522_set_frontend(struct dvb_frontend *fe,
 		return ret;
 
 	state->current_frequency = p->frequency;
+	state->lock_time = get_seconds() + LOCK_DELAY;
 
 	return 0;
 }
@@ -623,6 +626,7 @@ int au8522_init(struct dvb_frontend *fe)
 	   chip, so that when it gets powered back up it won't think
 	   that it is already tuned */
 	state->current_frequency = 0;
+	state->lock_time = (unsigned long)-1L;
 
 	au8522_writereg(state, 0xa4, 1 << 5);
 
@@ -736,6 +740,7 @@ int au8522_sleep(struct dvb_frontend *fe)
 	au8522_writereg(state, 0xa4, 1 << 5);
 
 	state->current_frequency = 0;
+	state->lock_time = (unsigned long)-1L;
 
 	return 0;
 }
@@ -752,15 +757,20 @@ static int au8522_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		dprintk("%s() Checking VSB_8\n", __func__);
 		reg = au8522_readreg(state, 0x4088);
 		if ((reg & 0x03) == 0x03)
-			*status |= FE_HAS_LOCK | FE_HAS_SYNC | FE_HAS_VITERBI;
+			*status |= FE_HAS_SYNC | FE_HAS_VITERBI;
 	} else {
 		dprintk("%s() Checking QAM\n", __func__);
 		reg = au8522_readreg(state, 0x4541);
 		if (reg & 0x80)
 			*status |= FE_HAS_VITERBI;
 		if (reg & 0x20)
-			*status |= FE_HAS_LOCK | FE_HAS_SYNC;
+			*status |= FE_HAS_SYNC;
 	}
+	if (*status & FE_HAS_SYNC && (!state->config->flakiness || (*status &
+			FE_HAS_VITERBI && state->lock_time < get_seconds())))
+		*status |= FE_HAS_LOCK;
+	else if (~(*status | ~(FE_HAS_SYNC | FE_HAS_VITERBI)))
+		state->lock_time = get_seconds() + LOCK_DELAY;
 
 	switch (state->config->status_mode) {
 	case AU8522_DEMODLOCKING:
@@ -786,7 +796,7 @@ static int au8522_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	}
 	state->fe_status = *status;
 
-	if (*status & FE_HAS_LOCK)
+	if (*status & FE_HAS_SYNC)
 		/* turn on LED, if it isn't on already */
 		au8522_led_ctrl(state, -1);
 	else
diff --git a/drivers/media/dvb/frontends/au8522_priv.h b/drivers/media/dvb/frontends/au8522_priv.h
index 609cf04..30611f6 100644
--- a/drivers/media/dvb/frontends/au8522_priv.h
+++ b/drivers/media/dvb/frontends/au8522_priv.h
@@ -53,6 +53,7 @@ struct au8522_state {
 	struct dvb_frontend frontend;
 
 	u32 current_frequency;
+	unsigned long lock_time;
 	fe_modulation_t current_modulation;
 
 	u32 fe_status;
diff --git a/drivers/media/video/au0828/au0828-cards.c b/drivers/media/video/au0828/au0828-cards.c
index 57dd919..fd70c90 100644
--- a/drivers/media/video/au0828/au0828-cards.c
+++ b/drivers/media/video/au0828/au0828-cards.c
@@ -116,6 +116,15 @@ struct au0828_board au0828_boards[] = {
 		.tuner_addr = ADDR_UNSET,
 		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
 	},
+	[AU0828_BOARD_SYNTEK_TELEDONGLE] = {
+		.name = "Syntek Teledongle [EXPERIMENTAL]",
+		.tuner_type = UNSET,
+		.tuner_addr = ADDR_UNSET,
+		.joined_rx = 1,
+		.i2c_clk_divider = 0x4,
+		.i2c_clk_divider_tx = 0x8,
+		.i2c_clk_divider_rx = 0x20,
+	},
 };
 
 /* Tuner callback function for au0828 boards. Currently only needed
@@ -292,6 +301,22 @@ void au0828_gpio_setup(struct au0828_dev *dev)
 		au0828_write(dev, REG_000, 0xa0);
 		msleep(250);
 		break;
+	case AU0828_BOARD_SYNTEK_TELEDONGLE: /* FIXME */
+		au0828_write(dev, REG_003, 0x0);
+		au0828_write(dev, REG_002, 0xec);
+		au0828_write(dev, REG_001, 0x0);
+		au0828_write(dev, REG_000, 0x0);
+		msleep(750);
+
+		au0828_write(dev, 0x601, 0x1);
+		au0828_write(dev, REG_003, 0x0);
+		au0828_write(dev, REG_001, 0x0);
+		au0828_write(dev, REG_002, 0xec);
+		au0828_write(dev, REG_000, 0x80 | 0x40 | 0x20);
+		msleep(100);
+
+		au0828_write(dev, 0x601, 0x5);
+		break;
 	}
 }
 
@@ -325,6 +350,12 @@ struct usb_device_id au0828_usb_id_table[] = {
 		.driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL },
 	{ USB_DEVICE(0x2040, 0x8200),
 		.driver_info = AU0828_BOARD_HAUPPAUGE_WOODBURY },
+#if 0
+	{ USB_DEVICE(0x05e1, 0x0400),
+		.driver_info = AU0828_BOARD_SYNTEK_TELEDONGLE },
+#endif
+	{ USB_DEVICE(0x05e1, 0x0480),
+		.driver_info = AU0828_BOARD_SYNTEK_TELEDONGLE },
 	{ },
 };
 
diff --git a/drivers/media/video/au0828/au0828-cards.h b/drivers/media/video/au0828/au0828-cards.h
index 48a1882..67169f8 100644
--- a/drivers/media/video/au0828/au0828-cards.h
+++ b/drivers/media/video/au0828/au0828-cards.h
@@ -25,3 +25,4 @@
 #define AU0828_BOARD_DVICO_FUSIONHDTV7	3
 #define AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL	4
 #define AU0828_BOARD_HAUPPAUGE_WOODBURY	5
+#define AU0828_BOARD_SYNTEK_TELEDONGLE	6
diff --git a/drivers/media/video/au0828/au0828-dvb.c b/drivers/media/video/au0828/au0828-dvb.c
index b8a4b52..193aed4 100644
--- a/drivers/media/video/au0828/au0828-dvb.c
+++ b/drivers/media/video/au0828/au0828-dvb.c
@@ -30,12 +30,17 @@
 #include "xc5000.h"
 #include "mxl5007t.h"
 #include "tda18271.h"
+#include "mt2131.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define _AU0828_BULKPIPE 0x83
 #define _BULKPIPESIZE 0xe522
 
+static int flakiness = -1;
+module_param(flakiness, int, 0644);
+MODULE_PARM_DESC(flakiness, "override whether to delay signal lock report");
+
 static u8 hauppauge_hvr950q_led_states[] = {
 	0x00, /* off */
 	0x02, /* yellow */
@@ -92,6 +97,17 @@ static struct tda18271_config hauppauge_woodbury_tunerconfig = {
 	.gate    = TDA18271_GATE_DIGITAL,
 };
 
+static struct mt2131_config syntek_mt2130_tunerconfig = {
+	0x60
+};
+
+static struct au8522_config syntek_teledongle_config = {
+	.demod_address = 0x8e >> 1,
+	.status_mode   = AU8522_DEMODLOCKING,
+	.qam_if        = AU8522_IF_6MHZ,
+	.vsb_if        = AU8522_IF_6MHZ,
+};
+
 /*-------------------------------------------------------------------*/
 static void urb_completion(struct urb *purb)
 {
@@ -381,16 +397,22 @@ int au0828_dvb_register(struct au0828_dev *dev)
 	switch (dev->boardnr) {
 	case AU0828_BOARD_HAUPPAUGE_HVR850:
 	case AU0828_BOARD_HAUPPAUGE_HVR950Q:
+		memcpy(&dvb->demod_cfg, &hauppauge_hvr950q_config,
+		       sizeof(struct au8522_config));
+
 		dvb->frontend = dvb_attach(au8522_attach,
-				&hauppauge_hvr950q_config,
+				&dvb->demod_cfg,
 				&dev->i2c_adap);
 		if (dvb->frontend != NULL)
 			dvb_attach(xc5000_attach, dvb->frontend, &dev->i2c_adap,
 				   &hauppauge_hvr950q_tunerconfig);
 		break;
 	case AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL:
+		memcpy(&dvb->demod_cfg, &hauppauge_hvr950q_config,
+		       sizeof(struct au8522_config));
+
 		dvb->frontend = dvb_attach(au8522_attach,
-				&hauppauge_hvr950q_config,
+				&dvb->demod_cfg,
 				&dev->i2c_adap);
 		if (dvb->frontend != NULL)
 			dvb_attach(mxl5007t_attach, dvb->frontend,
@@ -398,8 +420,11 @@ int au0828_dvb_register(struct au0828_dev *dev)
 				   &mxl5007t_hvr950q_config);
 		break;
 	case AU0828_BOARD_HAUPPAUGE_WOODBURY:
+		memcpy(&dvb->demod_cfg, &hauppauge_woodbury_config,
+		       sizeof(struct au8522_config));
+
 		dvb->frontend = dvb_attach(au8522_attach,
-				&hauppauge_woodbury_config,
+				&dvb->demod_cfg,
 				&dev->i2c_adap);
 		if (dvb->frontend != NULL)
 			dvb_attach(tda18271_attach, dvb->frontend,
@@ -407,8 +432,11 @@ int au0828_dvb_register(struct au0828_dev *dev)
 				   &hauppauge_woodbury_tunerconfig);
 		break;
 	case AU0828_BOARD_DVICO_FUSIONHDTV7:
+		memcpy(&dvb->demod_cfg, &fusionhdtv7usb_config,
+		       sizeof(struct au8522_config));
+
 		dvb->frontend = dvb_attach(au8522_attach,
-				&fusionhdtv7usb_config,
+				&dvb->demod_cfg,
 				&dev->i2c_adap);
 		if (dvb->frontend != NULL) {
 			dvb_attach(xc5000_attach, dvb->frontend,
@@ -416,6 +444,36 @@ int au0828_dvb_register(struct au0828_dev *dev)
 				&hauppauge_hvr950q_tunerconfig);
 		}
 		break;
+	case AU0828_BOARD_SYNTEK_TELEDONGLE:
+		/* hauppauge_woodbury_config is used for TDA18271c2 + AU8522
+		 * frontends, but we will need to use a different configuration
+		 * if the tuner is an MT2131 rather than TDA18271 */
+		memcpy(&dvb->demod_cfg, &hauppauge_woodbury_config,
+		       sizeof(struct au8522_config));
+
+		dvb->demod_cfg.flakiness = 1;
+		dvb->frontend = dvb_attach(au8522_attach,
+					   &dvb->demod_cfg, &dev->i2c_adap);
+		if (dvb->frontend != NULL) {
+			if (dvb_attach(tda18271_attach, dvb->frontend,
+				     0x60, &dev->i2c_adap,
+				     &hauppauge_woodbury_tunerconfig) != NULL)
+				break;
+			/* FIXME:
+			 * I have tested various au8522 configurations in
+			 * combination with the mt2131. The driver finds the
+			 * hardware and attaches correctly, but it is unable
+			 * to lock on to any services. */
+			if (dvb_attach(mt2131_attach, dvb->frontend,
+				       &dev->i2c_adap,
+				       &syntek_mt2130_tunerconfig, 0) != NULL)
+				/* replace the demod configuration with the
+				 * AU8522 + MT2131 configuration */
+				memcpy(&dvb->demod_cfg,
+				       &syntek_teledongle_config,
+				       sizeof(struct au8522_config));
+		}
+		break;
 	default:
 		printk(KERN_WARNING "The frontend of your DVB/ATSC card "
 		       "isn't supported yet\n");
@@ -426,6 +484,8 @@ int au0828_dvb_register(struct au0828_dev *dev)
 		       __func__);
 		return -1;
 	}
+	if (flakiness + 1)
+		dvb->demod_cfg.flakiness = flakiness;
 	/* define general-purpose callback pointer */
 	dvb->frontend->callback = au0828_tuner_callback;
 
diff --git a/drivers/media/video/au0828/au0828-i2c.c b/drivers/media/video/au0828/au0828-i2c.c
index cbdb65c..a3f8aec 100644
--- a/drivers/media/video/au0828/au0828-i2c.c
+++ b/drivers/media/video/au0828/au0828-i2c.c
@@ -141,13 +141,16 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 {
 	int i, strobe = 0;
 	struct au0828_dev *dev = i2c_adap->algo_data;
+	unsigned char clk_divider = joined_rlen ?
+		dev->board.i2c_clk_divider_rx : dev->board.i2c_clk_divider_tx;
 
 	dprintk(4, "%s()\n", __func__);
 
 	au0828_write(dev, AU0828_I2C_MULTIBYTE_MODE_2FF, 0x01);
 
 	/* Set the I2C clock */
-	au0828_write(dev, AU0828_I2C_CLK_DIVIDER_202,
+	au0828_write(dev, AU0828_I2C_CLK_DIVIDER_202, clk_divider &&
+		     msg->addr == 0x60 ? clk_divider :
 		     dev->board.i2c_clk_divider);
 
 	/* Hardware needs 8 bit addresses */
@@ -204,7 +207,7 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 		}
 
 	}
-	if (!i2c_wait_done(i2c_adap))
+	if (!(joined_rlen && dev->board.joined_rx) && !i2c_wait_done(i2c_adap))
 		return -EIO;
 
 	dprintk(4, "\n");
@@ -221,14 +224,18 @@ static int i2c_readbytes(struct i2c_adapter *i2c_adap,
 
 	dprintk(4, "%s()\n", __func__);
 
-	au0828_write(dev, AU0828_I2C_MULTIBYTE_MODE_2FF, 0x01);
+	if (!joined || !dev->board.joined_rx) {
+		au0828_write(dev, AU0828_I2C_MULTIBYTE_MODE_2FF, 0x01);
 
-	/* Set the I2C clock */
-	au0828_write(dev, AU0828_I2C_CLK_DIVIDER_202,
-		     dev->board.i2c_clk_divider);
+		/* Set the I2C clock */
+		au0828_write(dev, AU0828_I2C_CLK_DIVIDER_202,
+			     dev->board.i2c_clk_divider_rx && msg->addr ==
+			     0x60 ? dev->board.i2c_clk_divider_rx :
+			     dev->board.i2c_clk_divider);
 
-	/* Hardware needs 8 bit addresses */
-	au0828_write(dev, AU0828_I2C_DEST_ADDR_203, msg->addr << 1);
+		/* Hardware needs 8 bit addresses */
+		au0828_write(dev, AU0828_I2C_DEST_ADDR_203, msg->addr << 1);
+	}
 
 	dprintk(4, " RECV:\n");
 
diff --git a/drivers/media/video/au0828/au0828.h b/drivers/media/video/au0828/au0828.h
index 207f32d..b756219 100644
--- a/drivers/media/video/au0828/au0828.h
+++ b/drivers/media/video/au0828/au0828.h
@@ -40,6 +40,8 @@
 #include "au0828-reg.h"
 #include "au0828-cards.h"
 
+#include "au8522.h"
+
 #define DRIVER_NAME "au0828"
 #define URB_COUNT   16
 #define URB_BUFSIZE (0xe522)
@@ -79,9 +81,9 @@ struct au0828_input {
 
 struct au0828_board {
 	char *name;
-	unsigned int tuner_type;
+	unsigned int tuner_type, joined_rx;
 	unsigned char tuner_addr;
-	unsigned char i2c_clk_divider;
+	unsigned char i2c_clk_divider, i2c_clk_divider_rx, i2c_clk_divider_tx;
 	struct au0828_input input[AU0828_MAX_INPUT];
 
 };
@@ -95,6 +97,7 @@ struct au0828_dvb {
 	struct dmx_frontend fe_hw;
 	struct dmx_frontend fe_mem;
 	struct dvb_net net;
+	struct au8522_config demod_cfg;
 	int feeding;
 };
 

--=-wnZ1o+IOjWmLSrikUfGx--

