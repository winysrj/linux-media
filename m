Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:40005 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbeBXSzk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Feb 2018 13:55:40 -0500
Received: by mail-wm0-f65.google.com with SMTP id t6so1951712wmt.5
        for <linux-media@vger.kernel.org>; Sat, 24 Feb 2018 10:55:39 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 02/12] [media] ngene: convert kernellog printing from printk() to dev_*() macros
Date: Sat, 24 Feb 2018 19:55:24 +0100
Message-Id: <20180224185534.13792-3-d.scheller.oss@gmail.com>
In-Reply-To: <20180224185534.13792-1-d.scheller.oss@gmail.com>
References: <20180224185534.13792-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Convert all printk() and pr_*() kernel log printing to rather use the
dev_*() macros. Not only is it discouraged to use printk() (checkpatch
even complains about that), but also this helps identifying the exact PCI
device for any printed event, and it makes almost all printing shorter
in terms of code style since there's no need to use KERN_* DEVICE_NAME
any more (dev_*() will take care of this).

Since the dprintk macro define isn't used anymore, remove it.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ngene/ngene-cards.c | 75 ++++++++++++++++++++---------------
 drivers/media/pci/ngene/ngene-core.c  | 75 +++++++++++++++++------------------
 drivers/media/pci/ngene/ngene-dvb.c   |  4 +-
 3 files changed, 84 insertions(+), 70 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 49f78bb31537..16666de8cbee 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -23,6 +23,8 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
@@ -48,6 +50,7 @@
 
 static int tuner_attach_stv6110(struct ngene_channel *chan)
 {
+	struct device *pdev = &chan->dev->pci_dev->dev;
 	struct i2c_adapter *i2c;
 	struct stv090x_config *feconf = (struct stv090x_config *)
 		chan->dev->card_info->fe_config[chan->number];
@@ -63,7 +66,7 @@ static int tuner_attach_stv6110(struct ngene_channel *chan)
 
 	ctl = dvb_attach(stv6110x_attach, chan->fe, tunerconf, i2c);
 	if (ctl == NULL) {
-		printk(KERN_ERR	DEVICE_NAME ": No STV6110X found!\n");
+		dev_err(pdev, "No STV6110X found!\n");
 		return -ENODEV;
 	}
 
@@ -100,6 +103,7 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 static int tuner_attach_tda18271(struct ngene_channel *chan)
 {
+	struct device *pdev = &chan->dev->pci_dev->dev;
 	struct i2c_adapter *i2c;
 	struct dvb_frontend *fe;
 
@@ -110,7 +114,7 @@ static int tuner_attach_tda18271(struct ngene_channel *chan)
 	if (chan->fe->ops.i2c_gate_ctrl)
 		chan->fe->ops.i2c_gate_ctrl(chan->fe, 0);
 	if (!fe) {
-		printk(KERN_ERR "No TDA18271 found!\n");
+		dev_err(pdev, "No TDA18271 found!\n");
 		return -ENODEV;
 	}
 
@@ -128,6 +132,7 @@ static int tuner_attach_probe(struct ngene_channel *chan)
 
 static int demod_attach_stv0900(struct ngene_channel *chan)
 {
+	struct device *pdev = &chan->dev->pci_dev->dev;
 	struct i2c_adapter *i2c;
 	struct stv090x_config *feconf = (struct stv090x_config *)
 		chan->dev->card_info->fe_config[chan->number];
@@ -144,7 +149,7 @@ static int demod_attach_stv0900(struct ngene_channel *chan)
 			(chan->number & 1) == 0 ? STV090x_DEMODULATOR_0
 						: STV090x_DEMODULATOR_1);
 	if (chan->fe == NULL) {
-		printk(KERN_ERR	DEVICE_NAME ": No STV0900 found!\n");
+		dev_err(pdev, "No STV0900 found!\n");
 		return -ENODEV;
 	}
 
@@ -154,7 +159,7 @@ static int demod_attach_stv0900(struct ngene_channel *chan)
 
 	if (!dvb_attach(lnbh24_attach, chan->fe, i2c, 0,
 			0, chan->dev->card_info->lnb[chan->number])) {
-		printk(KERN_ERR DEVICE_NAME ": No LNBH24 found!\n");
+		dev_err(pdev, "No LNBH24 found!\n");
 		dvb_frontend_detach(chan->fe);
 		chan->fe = NULL;
 		return -ENODEV;
@@ -211,6 +216,7 @@ static int port_has_drxk(struct i2c_adapter *i2c, int port)
 static int demod_attach_drxk(struct ngene_channel *chan,
 			     struct i2c_adapter *i2c)
 {
+	struct device *pdev = &chan->dev->pci_dev->dev;
 	struct drxk_config config;
 
 	memset(&config, 0, sizeof(config));
@@ -220,7 +226,7 @@ static int demod_attach_drxk(struct ngene_channel *chan,
 
 	chan->fe = dvb_attach(drxk_attach, &config, i2c);
 	if (!chan->fe) {
-		printk(KERN_ERR "No DRXK found!\n");
+		dev_err(pdev, "No DRXK found!\n");
 		return -ENODEV;
 	}
 	chan->fe->sec_priv = chan;
@@ -231,6 +237,7 @@ static int demod_attach_drxk(struct ngene_channel *chan,
 
 static int cineS2_probe(struct ngene_channel *chan)
 {
+	struct device *pdev = &chan->dev->pci_dev->dev;
 	struct i2c_adapter *i2c;
 	struct stv090x_config *fe_conf;
 	u8 buf[3];
@@ -269,14 +276,14 @@ static int cineS2_probe(struct ngene_channel *chan)
 		}
 		rc = i2c_transfer(i2c, &i2c_msg, 1);
 		if (rc != 1) {
-			printk(KERN_ERR DEVICE_NAME ": could not setup DPNx\n");
+			dev_err(pdev, "Could not setup DPNx\n");
 			return -EIO;
 		}
 	} else if (port_has_drxk(i2c, chan->number^2)) {
 		chan->demod_type = 1;
 		demod_attach_drxk(chan, i2c);
 	} else {
-		printk(KERN_ERR "No demod found on chan %d\n", chan->number);
+		dev_err(pdev, "No demod found on chan %d\n", chan->number);
 		return -ENODEV;
 	}
 	return 0;
@@ -299,9 +306,11 @@ static struct mt2131_config m780_tunerconfig = {
  */
 static int demod_attach_lg330x(struct ngene_channel *chan)
 {
+	struct device *pdev = &chan->dev->pci_dev->dev;
+
 	chan->fe = dvb_attach(lgdt330x_attach, &aver_m780, &chan->i2c_adapter);
 	if (chan->fe == NULL) {
-		printk(KERN_ERR	DEVICE_NAME ": No LGDT330x found!\n");
+		dev_err(pdev, "No LGDT330x found!\n");
 		return -ENODEV;
 	}
 
@@ -313,6 +322,7 @@ static int demod_attach_lg330x(struct ngene_channel *chan)
 
 static int demod_attach_drxd(struct ngene_channel *chan)
 {
+	struct device *pdev = &chan->dev->pci_dev->dev;
 	struct drxd_config *feconf;
 
 	feconf = chan->dev->card_info->fe_config[chan->number];
@@ -320,7 +330,7 @@ static int demod_attach_drxd(struct ngene_channel *chan)
 	chan->fe = dvb_attach(drxd_attach, feconf, chan,
 			&chan->i2c_adapter, &chan->dev->pci_dev->dev);
 	if (!chan->fe) {
-		pr_err("No DRXD found!\n");
+		dev_err(pdev, "No DRXD found!\n");
 		return -ENODEV;
 	}
 	return 0;
@@ -328,6 +338,7 @@ static int demod_attach_drxd(struct ngene_channel *chan)
 
 static int tuner_attach_dtt7520x(struct ngene_channel *chan)
 {
+	struct device *pdev = &chan->dev->pci_dev->dev;
 	struct drxd_config *feconf;
 
 	feconf = chan->dev->card_info->fe_config[chan->number];
@@ -335,7 +346,7 @@ static int tuner_attach_dtt7520x(struct ngene_channel *chan)
 	if (!dvb_attach(dvb_pll_attach, chan->fe, feconf->pll_address,
 			&chan->i2c_adapter,
 			feconf->pll_type)) {
-		pr_err("No pll(%d) found!\n", feconf->pll_type);
+		dev_err(pdev, "No pll(%d) found!\n", feconf->pll_type);
 		return -ENODEV;
 	}
 	return 0;
@@ -371,12 +382,13 @@ static int tuner_attach_dtt7520x(struct ngene_channel *chan)
 static int i2c_write_eeprom(struct i2c_adapter *adapter,
 			    u8 adr, u16 reg, u8 data)
 {
+	struct device *pdev = adapter->dev.parent;
 	u8 m[3] = {(reg >> 8), (reg & 0xff), data};
 	struct i2c_msg msg = {.addr = adr, .flags = 0, .buf = m,
 			      .len = sizeof(m)};
 
 	if (i2c_transfer(adapter, &msg, 1) != 1) {
-		pr_err(DEVICE_NAME ": Error writing EEPROM!\n");
+		dev_err(pdev, "Error writing EEPROM!\n");
 		return -EIO;
 	}
 	return 0;
@@ -385,6 +397,7 @@ static int i2c_write_eeprom(struct i2c_adapter *adapter,
 static int i2c_read_eeprom(struct i2c_adapter *adapter,
 			   u8 adr, u16 reg, u8 *data, int len)
 {
+	struct device *pdev = adapter->dev.parent;
 	u8 msg[2] = {(reg >> 8), (reg & 0xff)};
 	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
 				   .buf = msg, .len = 2 },
@@ -392,7 +405,7 @@ static int i2c_read_eeprom(struct i2c_adapter *adapter,
 				   .buf = data, .len = len} };
 
 	if (i2c_transfer(adapter, msgs, 2) != 2) {
-		pr_err(DEVICE_NAME ": Error reading EEPROM\n");
+		dev_err(pdev, "Error reading EEPROM\n");
 		return -EIO;
 	}
 	return 0;
@@ -401,6 +414,7 @@ static int i2c_read_eeprom(struct i2c_adapter *adapter,
 static int ReadEEProm(struct i2c_adapter *adapter,
 		      u16 Tag, u32 MaxLen, u8 *data, u32 *pLength)
 {
+	struct device *pdev = adapter->dev.parent;
 	int status = 0;
 	u16 Addr = MICNG_EE_START, Length, tag = 0;
 	u8  EETag[3];
@@ -416,9 +430,8 @@ static int ReadEEProm(struct i2c_adapter *adapter,
 		Addr += sizeof(u16) + 1 + EETag[2];
 	}
 	if (Addr + sizeof(u16) + 1 + EETag[2] > MICNG_EE_END) {
-		pr_err(DEVICE_NAME
-		       ": Reached EOEE @ Tag = %04x Length = %3d\n",
-		       tag, EETag[2]);
+		dev_err(pdev, "Reached EOEE @ Tag = %04x Length = %3d\n",
+			tag, EETag[2]);
 		return -1;
 	}
 	Length = EETag[2];
@@ -441,6 +454,7 @@ static int ReadEEProm(struct i2c_adapter *adapter,
 static int WriteEEProm(struct i2c_adapter *adapter,
 		       u16 Tag, u32 Length, u8 *data)
 {
+	struct device *pdev = adapter->dev.parent;
 	int status = 0;
 	u16 Addr = MICNG_EE_START;
 	u8 EETag[3];
@@ -458,9 +472,8 @@ static int WriteEEProm(struct i2c_adapter *adapter,
 		Addr += sizeof(u16) + 1 + EETag[2];
 	}
 	if (Addr + sizeof(u16) + 1 + EETag[2] > MICNG_EE_END) {
-		pr_err(DEVICE_NAME
-		       ": Reached EOEE @ Tag = %04x Length = %3d\n",
-		       tag, EETag[2]);
+		dev_err(pdev, "Reached EOEE @ Tag = %04x Length = %3d\n",
+			tag, EETag[2]);
 		return -1;
 	}
 
@@ -487,13 +500,11 @@ static int WriteEEProm(struct i2c_adapter *adapter,
 			if (status)
 				break;
 			if (Tmp != data[i])
-				pr_err(DEVICE_NAME
-				       "eeprom write error\n");
+				dev_err(pdev, "eeprom write error\n");
 			retry -= 1;
 		}
 		if (status) {
-			pr_err(DEVICE_NAME
-			       ": Timeout polling eeprom\n");
+			dev_err(pdev, "Timeout polling eeprom\n");
 			break;
 		}
 	}
@@ -532,19 +543,20 @@ static int eeprom_write_ushort(struct i2c_adapter *adapter, u16 tag, u16 data)
 static s16 osc_deviation(void *priv, s16 deviation, int flag)
 {
 	struct ngene_channel *chan = priv;
+	struct device *pdev = &chan->dev->pci_dev->dev;
 	struct i2c_adapter *adap = &chan->i2c_adapter;
 	u16 data = 0;
 
 	if (flag) {
 		data = (u16) deviation;
-		pr_info(DEVICE_NAME ": write deviation %d\n",
-		       deviation);
+		dev_info(pdev, "write deviation %d\n",
+			 deviation);
 		eeprom_write_ushort(adap, 0x1000 + chan->number, data);
 	} else {
 		if (eeprom_read_ushort(adap, 0x1000 + chan->number, &data))
 			data = 0;
-		pr_info(DEVICE_NAME ": read deviation %d\n",
-		       (s16) data);
+		dev_info(pdev, "read deviation %d\n",
+			 (s16)data);
 	}
 
 	return (s16) data;
@@ -771,7 +783,7 @@ MODULE_DEVICE_TABLE(pci, ngene_id_tbl);
 static pci_ers_result_t ngene_error_detected(struct pci_dev *dev,
 					     enum pci_channel_state state)
 {
-	printk(KERN_ERR DEVICE_NAME ": PCI error\n");
+	dev_err(&dev->dev, "PCI error\n");
 	if (state == pci_channel_io_perm_failure)
 		return PCI_ERS_RESULT_DISCONNECT;
 	if (state == pci_channel_io_frozen)
@@ -781,13 +793,13 @@ static pci_ers_result_t ngene_error_detected(struct pci_dev *dev,
 
 static pci_ers_result_t ngene_slot_reset(struct pci_dev *dev)
 {
-	printk(KERN_INFO DEVICE_NAME ": slot reset\n");
+	dev_info(&dev->dev, "slot reset\n");
 	return 0;
 }
 
 static void ngene_resume(struct pci_dev *dev)
 {
-	printk(KERN_INFO DEVICE_NAME ": resume\n");
+	dev_info(&dev->dev, "resume\n");
 }
 
 static const struct pci_error_handlers ngene_errors = {
@@ -807,8 +819,9 @@ static struct pci_driver ngene_pci_driver = {
 
 static __init int module_init_ngene(void)
 {
-	printk(KERN_INFO
-	       "nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas\n");
+	/* pr_*() since we don't have a device to use with dev_*() yet */
+	pr_info("nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas\n");
+
 	return pci_register_driver(&ngene_pci_driver);
 }
 
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 80db777cb7ec..a63f019fb62f 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -51,8 +51,6 @@ MODULE_PARM_DESC(debug, "Print debugging information.");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-#define dprintk	if (debug) printk
-
 #define ngwriteb(dat, adr)         writeb((dat), dev->iomem + (adr))
 #define ngwritel(dat, adr)         writel((dat), dev->iomem + (adr))
 #define ngwriteb(dat, adr)         writeb((dat), dev->iomem + (adr))
@@ -86,6 +84,7 @@ static void event_tasklet(unsigned long data)
 static void demux_tasklet(unsigned long data)
 {
 	struct ngene_channel *chan = (struct ngene_channel *)data;
+	struct device *pdev = &chan->dev->pci_dev->dev;
 	struct SBufferHeader *Cur = chan->nextBuffer;
 
 	spin_lock_irq(&chan->state_lock);
@@ -124,16 +123,15 @@ static void demux_tasklet(unsigned long data)
 					chan->HWState = HWSTATE_RUN;
 				}
 			} else {
-				printk(KERN_ERR DEVICE_NAME ": OOPS\n");
+				dev_err(pdev, "OOPS\n");
 				if (chan->HWState == HWSTATE_RUN) {
 					Cur->ngeneBuffer.SR.Flags &= ~0x40;
 					break;	/* Stop processing stream */
 				}
 			}
 			if (chan->AudioDTOUpdated) {
-				printk(KERN_INFO DEVICE_NAME
-				       ": Update AudioDTO = %d\n",
-				       chan->AudioDTOValue);
+				dev_info(pdev, "Update AudioDTO = %d\n",
+					 chan->AudioDTOValue);
 				Cur->ngeneBuffer.SR.DTOUpdate =
 					chan->AudioDTOValue;
 				chan->AudioDTOUpdated = 0;
@@ -173,6 +171,7 @@ static void demux_tasklet(unsigned long data)
 static irqreturn_t irq_handler(int irq, void *dev_id)
 {
 	struct ngene *dev = (struct ngene *)dev_id;
+	struct device *pdev = &dev->pci_dev->dev;
 	u32 icounts = 0;
 	irqreturn_t rc = IRQ_NONE;
 	u32 i = MAX_STREAM;
@@ -213,7 +212,7 @@ static irqreturn_t irq_handler(int irq, void *dev_id)
 				*(dev->EventBuffer);
 			dev->EventQueueWriteIndex = nextWriteIndex;
 		} else {
-			printk(KERN_ERR DEVICE_NAME ": event overflow\n");
+			dev_err(pdev, "event overflow\n");
 			dev->EventQueueOverflowCount += 1;
 			dev->EventQueueOverflowFlag = 1;
 		}
@@ -249,23 +248,25 @@ static irqreturn_t irq_handler(int irq, void *dev_id)
 
 static void dump_command_io(struct ngene *dev)
 {
+	struct device *pdev = &dev->pci_dev->dev;
 	u8 buf[8], *b;
 
 	ngcpyfrom(buf, HOST_TO_NGENE, 8);
-	printk(KERN_ERR "host_to_ngene (%04x): %*ph\n", HOST_TO_NGENE, 8, buf);
+	dev_err(pdev, "host_to_ngene (%04x): %*ph\n", HOST_TO_NGENE, 8, buf);
 
 	ngcpyfrom(buf, NGENE_TO_HOST, 8);
-	printk(KERN_ERR "ngene_to_host (%04x): %*ph\n", NGENE_TO_HOST, 8, buf);
+	dev_err(pdev, "ngene_to_host (%04x): %*ph\n", NGENE_TO_HOST, 8, buf);
 
 	b = dev->hosttongene;
-	printk(KERN_ERR "dev->hosttongene (%p): %*ph\n", b, 8, b);
+	dev_err(pdev, "dev->hosttongene (%p): %*ph\n", b, 8, b);
 
 	b = dev->ngenetohost;
-	printk(KERN_ERR "dev->ngenetohost (%p): %*ph\n", b, 8, b);
+	dev_err(pdev, "dev->ngenetohost (%p): %*ph\n", b, 8, b);
 }
 
 static int ngene_command_mutex(struct ngene *dev, struct ngene_command *com)
 {
+	struct device *pdev = &dev->pci_dev->dev;
 	int ret;
 	u8 *tmpCmdDoneByte;
 
@@ -313,9 +314,8 @@ static int ngene_command_mutex(struct ngene *dev, struct ngene_command *com)
 	if (!ret) {
 		/*ngwritel(0, FORCE_NMI);*/
 
-		printk(KERN_ERR DEVICE_NAME
-		       ": Command timeout cmd=%02x prev=%02x\n",
-		       com->cmd.hdr.Opcode, dev->prev_cmd);
+		dev_err(pdev, "Command timeout cmd=%02x prev=%02x\n",
+			com->cmd.hdr.Opcode, dev->prev_cmd);
 		dump_command_io(dev);
 		return -1;
 	}
@@ -553,6 +553,7 @@ static void clear_buffers(struct ngene_channel *chan)
 static int ngene_command_stream_control(struct ngene *dev, u8 stream,
 					u8 control, u8 mode, u8 flags)
 {
+	struct device *pdev = &dev->pci_dev->dev;
 	struct ngene_channel *chan = &dev->channel[stream];
 	struct ngene_command com;
 	u16 BsUVI = ((stream & 1) ? 0x9400 : 0x9300);
@@ -572,8 +573,7 @@ static int ngene_command_stream_control(struct ngene *dev, u8 stream,
 	com.in_len = sizeof(struct FW_STREAM_CONTROL);
 	com.out_len = 0;
 
-	dprintk(KERN_INFO DEVICE_NAME
-		": Stream=%02x, Control=%02x, Mode=%02x\n",
+	dev_dbg(pdev, "Stream=%02x, Control=%02x, Mode=%02x\n",
 		com.cmd.StreamControl.Stream, com.cmd.StreamControl.Control,
 		com.cmd.StreamControl.Mode);
 
@@ -695,23 +695,24 @@ static int ngene_command_stream_control(struct ngene *dev, u8 stream,
 
 void set_transfer(struct ngene_channel *chan, int state)
 {
+	struct device *pdev = &chan->dev->pci_dev->dev;
 	u8 control = 0, mode = 0, flags = 0;
 	struct ngene *dev = chan->dev;
 	int ret;
 
 	/*
-	printk(KERN_INFO DEVICE_NAME ": st %d\n", state);
+	dev_info(pdev, "st %d\n", state);
 	msleep(100);
 	*/
 
 	if (state) {
 		if (chan->running) {
-			printk(KERN_INFO DEVICE_NAME ": already running\n");
+			dev_info(pdev, "already running\n");
 			return;
 		}
 	} else {
 		if (!chan->running) {
-			printk(KERN_INFO DEVICE_NAME ": already stopped\n");
+			dev_info(pdev, "already stopped\n");
 			return;
 		}
 	}
@@ -722,7 +723,7 @@ void set_transfer(struct ngene_channel *chan, int state)
 	if (state) {
 		spin_lock_irq(&chan->state_lock);
 
-		/* printk(KERN_INFO DEVICE_NAME ": lock=%08x\n",
+		/* dev_info(pdev, "lock=%08x\n",
 			  ngreadl(0x9310)); */
 		dvb_ringbuffer_flush(&dev->tsout_rbuf);
 		control = 0x80;
@@ -740,7 +741,7 @@ void set_transfer(struct ngene_channel *chan, int state)
 			chan->pBufferExchange = tsin_exchange;
 		spin_unlock_irq(&chan->state_lock);
 	}
-		/* else printk(KERN_INFO DEVICE_NAME ": lock=%08x\n",
+		/* else dev_info(pdev, "lock=%08x\n",
 			   ngreadl(0x9310)); */
 
 	mutex_lock(&dev->stream_mutex);
@@ -751,8 +752,7 @@ void set_transfer(struct ngene_channel *chan, int state)
 	if (!ret)
 		chan->running = state;
 	else
-		printk(KERN_ERR DEVICE_NAME ": set_transfer %d failed\n",
-		       state);
+		dev_err(pdev, "%s %d failed\n", __func__, state);
 	if (!state) {
 		spin_lock_irq(&chan->state_lock);
 		chan->pBufferExchange = NULL;
@@ -1195,6 +1195,7 @@ static int ngene_get_buffers(struct ngene *dev)
 
 static void ngene_init(struct ngene *dev)
 {
+	struct device *pdev = &dev->pci_dev->dev;
 	int i;
 
 	tasklet_init(&dev->event_tasklet, event_tasklet, (unsigned long)dev);
@@ -1214,12 +1215,12 @@ static void ngene_init(struct ngene *dev)
 	dev->icounts = ngreadl(NGENE_INT_COUNTS);
 
 	dev->device_version = ngreadl(DEV_VER) & 0x0f;
-	printk(KERN_INFO DEVICE_NAME ": Device version %d\n",
-	       dev->device_version);
+	dev_info(pdev, "Device version %d\n", dev->device_version);
 }
 
 static int ngene_load_firm(struct ngene *dev)
 {
+	struct device *pdev = &dev->pci_dev->dev;
 	u32 size;
 	const struct firmware *fw = NULL;
 	u8 *ngene_fw;
@@ -1253,21 +1254,18 @@ static int ngene_load_firm(struct ngene *dev)
 	}
 
 	if (request_firmware(&fw, fw_name, &dev->pci_dev->dev) < 0) {
-		printk(KERN_ERR DEVICE_NAME
-			": Could not load firmware file %s.\n", fw_name);
-		printk(KERN_INFO DEVICE_NAME
-			": Copy %s to your hotplug directory!\n", fw_name);
+		dev_err(pdev, "Could not load firmware file %s.\n", fw_name);
+		dev_info(pdev, "Copy %s to your hotplug directory!\n",
+			 fw_name);
 		return -1;
 	}
 	if (size == 0)
 		size = fw->size;
 	if (size != fw->size) {
-		printk(KERN_ERR DEVICE_NAME
-			": Firmware %s has invalid size!", fw_name);
+		dev_err(pdev, "Firmware %s has invalid size!", fw_name);
 		err = -1;
 	} else {
-		printk(KERN_INFO DEVICE_NAME
-			": Loading firmware file %s.\n", fw_name);
+		dev_info(pdev, "Loading firmware file %s.\n", fw_name);
 		ngene_fw = (u8 *) fw->data;
 		err = ngene_command_load_firmware(dev, ngene_fw, size);
 	}
@@ -1327,6 +1325,7 @@ static int ngene_buffer_config(struct ngene *dev)
 
 static int ngene_start(struct ngene *dev)
 {
+	struct device *pdev = &dev->pci_dev->dev;
 	int stat;
 	int i;
 
@@ -1366,8 +1365,7 @@ static int ngene_start(struct ngene *dev)
 		free_irq(dev->pci_dev->irq, dev);
 		stat = pci_enable_msi(dev->pci_dev);
 		if (stat) {
-			printk(KERN_INFO DEVICE_NAME
-				": MSI not available\n");
+			dev_info(pdev, "MSI not available\n");
 			flags = IRQF_SHARED;
 		} else {
 			flags = 0;
@@ -1570,6 +1568,7 @@ static const struct cxd2099_cfg cxd_cfgtmpl = {
 
 static void cxd_attach(struct ngene *dev)
 {
+	struct device *pdev = &dev->pci_dev->dev;
 	struct ngene_ci *ci = &dev->ci;
 	struct cxd2099_cfg cxd_cfg = cxd_cfgtmpl;
 	struct i2c_client *client;
@@ -1600,7 +1599,7 @@ static void cxd_attach(struct ngene *dev)
 err_i2c:
 	i2c_unregister_device(client);
 err_ret:
-	printk(KERN_ERR DEVICE_NAME ": CXD2099AR attach failed\n");
+	dev_err(pdev, "CXD2099AR attach failed\n");
 	return;
 }
 
@@ -1648,7 +1647,7 @@ void ngene_shutdown(struct pci_dev *pdev)
 	if (!dev || !shutdown_workaround)
 		return;
 
-	printk(KERN_INFO DEVICE_NAME ": shutdown workaround...\n");
+	dev_info(&pdev->dev, "shutdown workaround...\n");
 	ngene_unlink(dev);
 	pci_disable_device(pdev);
 }
@@ -1688,7 +1687,7 @@ int ngene_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 
 	dev->pci_dev = pci_dev;
 	dev->card_info = (struct ngene_info *)id->driver_data;
-	printk(KERN_INFO DEVICE_NAME ": Found %s\n", dev->card_info->name);
+	dev_info(&pci_dev->dev, "Found %s\n", dev->card_info->name);
 
 	pci_set_drvdata(pci_dev, dev);
 
diff --git a/drivers/media/pci/ngene/ngene-dvb.c b/drivers/media/pci/ngene/ngene-dvb.c
index 03fc218a45e9..f71fd41c762c 100644
--- a/drivers/media/pci/ngene/ngene-dvb.c
+++ b/drivers/media/pci/ngene/ngene-dvb.c
@@ -152,7 +152,9 @@ void *tsin_exchange(void *priv, void *buf, u32 len, u32 clock, u32 flags)
 				stripped++;
 
 			if (ok % 100 == 0 && overflow)
-				printk(KERN_WARNING "%s: ok %u overflow %u dropped %u\n", __func__, ok, overflow, stripped);
+				dev_warn(&dev->pci_dev->dev,
+					 "%s: ok %u overflow %u dropped %u\n",
+					 __func__, ok, overflow, stripped);
 #endif
 			buf += 188;
 			len -= 188;
-- 
2.16.1
