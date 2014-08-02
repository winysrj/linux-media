Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34503 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbaHBDtO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Aug 2014 23:49:14 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/5] ddbridge: clean up driver for release
Date: Sat,  2 Aug 2014 06:48:55 +0300
Message-Id: <1406951335-24026-6-git-send-email-crope@iki.fi>
In-Reply-To: <1406951335-24026-1-git-send-email-crope@iki.fi>
References: <1406951335-24026-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable driver compilation. Clean up driver.
Remove network streaming and modulator functionality - needs API
first.

Remove few receivers which are not supported due to missing DTV
frontend chipset drivers or due to lack of correct device profile
(+ I don't have hw to implement profile). Those removed receivers
are based of following DTV chipsets:
MaxLinear MxL5xx
STMicroelectronics STV0910
STMicroelectronics STV0367

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/ddbridge/Makefile        |   5 +-
 drivers/media/pci/ddbridge/ddbridge-core.c | 813 ++---------------------------
 drivers/media/pci/ddbridge/ddbridge-i2c.c  |  25 -
 drivers/media/pci/ddbridge/ddbridge.c      |  20 +-
 drivers/media/pci/ddbridge/ddbridge.h      |  16 -
 5 files changed, 65 insertions(+), 814 deletions(-)

diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index 39e922c..2610161 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -2,10 +2,7 @@
 # Makefile for the ddbridge device driver
 #
 
-ddbridge-objs := ddbridge-core.o
-
-#obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
-obj-$() += ddbridge.o
+obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
 ccflags-y += -Idrivers/media/dvb-core/
 ccflags-y += -Idrivers/media/dvb-frontends/
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index a301be6..c66b1b3 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -45,10 +45,7 @@ static struct ddb *ddbs[DDB_MAX_ADAPTER];
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-#include "ddbridge-mod.c"
 #include "ddbridge-i2c.c"
-#include "ddbridge-ns.c"
-
 
 static void ddb_set_dma_table(struct ddb *dev, struct ddb_dma *dma)
 {
@@ -281,9 +278,8 @@ static int ddb_buffers_alloc(struct ddb *dev)
 			if (dma_alloc(dev->pdev, port->input[0]->dma, 0) < 0)
 				return -1;
 		case DDB_PORT_MOD:
-			if (dma_alloc(dev->pdev, port->output->dma, 1) < 0)
-				return -1;
-			break;
+			/* TODO: modulator not supported */
+			return -1;
 		default:
 			break;
 		}
@@ -324,9 +320,9 @@ static void ddb_output_start(struct ddb_output *output)
 		output->dma->stat = 0;
 		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(output->dma->nr));
 	}
-	if (output->port->class == DDB_PORT_MOD)
-		ddbridge_mod_output_start(output);
-	else {
+	if (output->port->class == DDB_PORT_MOD) {
+		/* TODO: modulator not supported */
+	} else {
 		ddbwritel(dev, 0, TS_OUTPUT_CONTROL(output->nr));
 		ddbwritel(dev, 2, TS_OUTPUT_CONTROL(output->nr));
 		ddbwritel(dev, 0, TS_OUTPUT_CONTROL(output->nr));
@@ -363,7 +359,8 @@ static void ddb_output_stop(struct ddb_output *output)
 	if (output->dma)
 		spin_lock_irq(&output->dma->lock);
 	if (output->port->class == DDB_PORT_MOD)
-		ddbridge_mod_output_stop(output);
+		/* TODO: modulator not supported */
+		;
 	else
 		ddbwritel(dev, 0, TS_OUTPUT_CONTROL(output->nr));
 	if (output->dma) {
@@ -422,28 +419,6 @@ static void ddb_input_start(struct ddb_input *input)
 	/*pr_info("input_start %d.%d\n", dev->nr, input->nr);*/
 }
 
-
-static int ddb_dvb_input_start(struct ddb_input *input)
-{
-	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
-
-	if (!dvb->users)
-		ddb_input_start(input);
-
-	return ++dvb->users;
-}
-
-static int ddb_dvb_input_stop(struct ddb_input *input)
-{
-	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
-
-	if (--dvb->users)
-		return dvb->users;
-
-	ddb_input_stop(input);
-	return 0;
-}
-
 static void ddb_input_start_all(struct ddb_input *input)
 {
 	struct ddb_input *i = input;
@@ -496,25 +471,6 @@ static u32 ddb_output_free(struct ddb_output *output)
 	return 0;
 }
 
-#if 0
-static u32 ddb_dma_free(struct ddb_dma *dma)
-{
-	u32 idx, off, stat = dma->stat;
-	s32 p1, p2, diff;
-
-	idx = (stat >> 11) & 0x1f;
-	off = (stat & 0x7ff) << 7;
-
-	p1 = idx * dma->size + off;
-	p2 = dma->cbuf * dma->size + dma->coff;
-
-	diff = p1 - p2;
-	if (diff <= 0)
-		diff += dma->num * dma->size;
-	return diff;
-}
-#endif
-
 static ssize_t ddb_output_write(struct ddb_output *output,
 				const u8 *buf, size_t count)
 {
@@ -570,81 +526,6 @@ static ssize_t ddb_output_write(struct ddb_output *output,
 	return count - left;
 }
 
-#if 0
-static u32 ddb_input_free_bytes(struct ddb_input *input)
-{
-	struct ddb *dev = input->port->dev;
-	u32 idx, off, stat = input->dma->stat;
-	u32 ctrl = ddbreadl(dev, DMA_BUFFER_CONTROL(input->dma->nr));
-
-	idx = (stat >> 11) & 0x1f;
-	off = (stat & 0x7ff) << 7;
-
-	if (ctrl & 4)
-		return 0;
-	if (input->dma->cbuf != idx)
-		return 1;
-	return 0;
-}
-
-
-
-static s32 ddb_output_used_bufs(struct ddb_output *output)
-{
-	u32 idx, off, stat, ctrl;
-	s32 diff;
-
-	spin_lock_irq(&output->dma->lock);
-	stat = output->dma->stat;
-	ctrl = output->dma->ctrl;
-	spin_unlock_irq(&output->dma->lock);
-
-	idx = (stat >> 11) & 0x1f;
-	off = (stat & 0x7ff) << 7;
-
-	if (ctrl & 4)
-		return 0;
-	diff = output->dma->cbuf - idx;
-	if (diff == 0 && off < output->dma->coff)
-		return 0;
-	if (diff <= 0)
-		diff += output->dma->num;
-	return diff;
-}
-
-static s32 ddb_input_free_bufs(struct ddb_input *input)
-{
-	u32 idx, off, stat, ctrl;
-	s32 free;
-
-	spin_lock_irq(&input->dma->lock);
-	ctrl = input->dma->ctrl;
-	stat = input->dma->stat;
-	spin_unlock_irq(&input->dma->lock);
-	if (ctrl & 4)
-		return 0;
-	idx = (stat >> 11) & 0x1f;
-	off = (stat & 0x7ff) << 7;
-	free = input->dma->cbuf - idx;
-	if (free == 0 && off < input->dma->coff)
-		return 0;
-	if (free <= 0)
-		free += input->dma->num;
-	return free - 1;
-}
-
-static u32 ddb_output_ok(struct ddb_output *output)
-{
-	struct ddb_input *input = output->port->input[0];
-	s32 diff;
-
-	diff = ddb_input_free_bufs(input) - ddb_output_used_bufs(output);
-	if (diff > 0)
-		return 1;
-	return 0;
-}
-#endif
-
 static u32 ddb_input_avail(struct ddb_input *input)
 {
 	struct ddb *dev = input->port->dev;
@@ -826,36 +707,6 @@ static int ts_open(struct inode *inode, struct file *file)
 	return err;
 }
 
-static int mod_release(struct inode *inode, struct file *file)
-{
-	struct dvb_device *dvbdev = file->private_data;
-	struct ddb_output *output = dvbdev->priv;
-
-	if ((file->f_flags & O_ACCMODE) == O_WRONLY) {
-		if (!output)
-			return -EINVAL;
-		ddb_output_stop(output);
-	}
-	return dvb_generic_release(inode, file);
-}
-
-static int mod_open(struct inode *inode, struct file *file)
-{
-	int err;
-	struct dvb_device *dvbdev = file->private_data;
-	struct ddb_output *output = dvbdev->priv;
-
-	if ((file->f_flags & O_ACCMODE) == O_WRONLY) {
-		if (!output)
-			return -EINVAL;
-	}
-	err = dvb_generic_open(inode, file);
-	if (err < 0)
-		return err;
-	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
-		ddb_output_start(output);
-	return err;
-}
 static const struct file_operations ci_fops = {
 	.owner   = THIS_MODULE,
 	.read    = ts_read,
@@ -878,44 +729,10 @@ static struct dvb_device dvbdev_ci = {
 /****************************************************************************/
 /****************************************************************************/
 
-static long mod_ioctl(struct file *file,
-		      unsigned int cmd, unsigned long arg)
-{
-	return dvb_usercopy(file, cmd, arg, ddbridge_mod_do_ioctl);
-}
-
-static const struct file_operations mod_fops = {
-	.owner   = THIS_MODULE,
-	.read    = ts_read,
-	.write   = ts_write,
-	.open    = mod_open,
-	.release = mod_release,
-	.poll    = ts_poll,
-	.mmap    = 0,
-	.unlocked_ioctl = mod_ioctl,
-};
-
-static struct dvb_device dvbdev_mod = {
-	.priv    = 0,
-	.readers = 1,
-	.writers = 1,
-	.users   = 2,
-	.fops    = &mod_fops,
-};
-
 
-#if 0
-static struct ddb_input *fe2input(struct ddb *dev, struct dvb_frontend *fe)
-{
-	int i;
 
-	for (i = 0; i < dev->info->port_num * 2; i++) {
-		if (dev->input[i].fe == fe)
-			return &dev->input[i];
-	}
-	return NULL;
-}
-#endif
+/****************************************************************************/
+/****************************************************************************/
 
 static int locked_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
@@ -934,16 +751,19 @@ static int locked_gate_ctrl(struct dvb_frontend *fe, int enable)
 	return status;
 }
 
-#ifdef CONFIG_DVB_DRXK
 static int demod_attach_drxk(struct ddb_input *input)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
 	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 	struct dvb_frontend *fe;
+	struct drxk_config config;
+
+	memset(&config, 0, sizeof(config));
+	config.microcode_name = "drxk_a3.mc";
+	config.qam_demod_parameter_count = 4;
+	config.adr = 0x29 + (input->nr & 1);
 
-	fe = dvb->fe = dvb_attach(drxk_attach,
-				  i2c, 0x29 + (input->nr&1),
-				  &dvb->fe2);
+	fe = dvb->fe = dvb_attach(drxk_attach, &config, i2c);
 	if (!fe) {
 		pr_err("No DRXK found!\n");
 		return -ENODEV;
@@ -953,47 +773,6 @@ static int demod_attach_drxk(struct ddb_input *input)
 	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
 	return 0;
 }
-#endif
-
-#if 0
-struct stv0367_config stv0367_0 = {
-	.demod_address = 0x1f,
-	.xtal = 27000000,
-	.if_khz = 5000,
-	.if_iq_mode = FE_TER_NORMAL_IF_TUNER,
-	.ts_mode = STV0367_SERIAL_PUNCT_CLOCK,
-	.clk_pol = STV0367_RISINGEDGE_CLOCK,
-};
-
-struct stv0367_config stv0367_1 = {
-	.demod_address = 0x1e,
-	.xtal = 27000000,
-	.if_khz = 5000,
-	.if_iq_mode = FE_TER_NORMAL_IF_TUNER,
-	.ts_mode = STV0367_SERIAL_PUNCT_CLOCK,
-	.clk_pol = STV0367_RISINGEDGE_CLOCK,
-};
-
-
-static int demod_attach_stv0367(struct ddb_input *input)
-{
-	struct i2c_adapter *i2c = &input->port->i2c->adap;
-	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
-	struct dvb_frontend *fe;
-
-	fe = dvb->fe = dvb_attach(stv0367ter_attach,
-				  (input->nr & 1) ? &stv0367_1 : &stv0367_0,
-				  i2c);
-	if (!dvb->fe) {
-		pr_err("No stv0367 found!\n");
-		return -ENODEV;
-	}
-	fe->sec_priv = input;
-	dvb->i2c_gate_ctrl = fe->ops.i2c_gate_ctrl;
-	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
-	return 0;
-}
-#endif
 
 struct cxd2843_cfg cxd2843_0 = {
 	.adr = 0x6c,
@@ -1037,36 +816,6 @@ static int demod_attach_cxd2843(struct ddb_input *input, int par)
 	return 0;
 }
 
-struct stv0367_cfg stv0367dd_0 = {
-	.adr = 0x1f,
-	.xtal = 27000000,
-};
-
-struct stv0367_cfg stv0367dd_1 = {
-	.adr = 0x1e,
-	.xtal = 27000000,
-};
-
-static int demod_attach_stv0367dd(struct ddb_input *input)
-{
-	struct i2c_adapter *i2c = &input->port->i2c->adap;
-	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
-	struct dvb_frontend *fe;
-
-	fe = dvb->fe = dvb_attach(stv0367_attach, i2c,
-				  (input->nr & 1) ?
-				  &stv0367dd_1 : &stv0367dd_0,
-				  &dvb->fe2);
-	if (!dvb->fe) {
-		pr_err("No stv0367 found!\n");
-		return -ENODEV;
-	}
-	fe->sec_priv = input;
-	dvb->i2c_gate_ctrl = fe->ops.i2c_gate_ctrl;
-	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
-	return 0;
-}
-
 static int tuner_attach_tda18271(struct ddb_input *input)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
@@ -1085,28 +834,26 @@ static int tuner_attach_tda18271(struct ddb_input *input)
 	return 0;
 }
 
-static int tuner_attach_tda18212dd(struct ddb_input *input)
-{
-	struct i2c_adapter *i2c = &input->port->i2c->adap;
-	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
-	struct dvb_frontend *fe;
-
-	fe = dvb_attach(tda18212dd_attach, dvb->fe, i2c,
-			(input->nr & 1) ? 0x63 : 0x60);
-	if (!fe) {
-		pr_err("No TDA18212 found!\n");
-		return -ENODEV;
-	}
-	return 0;
-}
-
-#ifdef CONFIG_DVB_TDA18212
-struct tda18212_config tda18212_0 = {
+static struct tda18212_config tda18212_config_60 = {
 	.i2c_address = 0x60,
+	.if_dvbt_6 = 3550,
+	.if_dvbt_7 = 3700,
+	.if_dvbt_8 = 4150,
+	.if_dvbt2_6 = 3250,
+	.if_dvbt2_7 = 4000,
+	.if_dvbt2_8 = 4000,
+	.if_dvbc = 5000,
 };
 
-struct tda18212_config tda18212_1 = {
+static struct tda18212_config tda18212_config_63 = {
 	.i2c_address = 0x63,
+	.if_dvbt_6 = 3550,
+	.if_dvbt_7 = 3700,
+	.if_dvbt_8 = 4150,
+	.if_dvbt2_6 = 3250,
+	.if_dvbt2_7 = 4000,
+	.if_dvbt2_8 = 4000,
+	.if_dvbc = 5000,
 };
 
 static int tuner_attach_tda18212(struct ddb_input *input)
@@ -1114,17 +861,20 @@ static int tuner_attach_tda18212(struct ddb_input *input)
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
 	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 	struct dvb_frontend *fe;
-	struct tda18212_config *cfg;
+	struct tda18212_config *config;
+
+	if (input->nr & 1)
+		config = &tda18212_config_63;
+	else
+		config = &tda18212_config_60;
 
-	cfg = (input->nr & 1) ? &tda18212_1 : &tda18212_0;
-	fe = dvb_attach(tda18212_attach, dvb->fe, i2c, cfg);
+	fe = dvb_attach(tda18212_attach, dvb->fe, i2c, config);
 	if (!fe) {
 		pr_err("No TDA18212 found!\n");
 		return -ENODEV;
 	}
 	return 0;
 }
-#endif
 
 /****************************************************************************/
 /****************************************************************************/
@@ -1240,181 +990,6 @@ static int tuner_attach_stv6110(struct ddb_input *input, int type)
 	return 0;
 }
 
-static struct stv0910_cfg stv0910 = {
-	.adr      = 0x68,
-	.parallel = 1,
-	.rptlvl   = 4,
-	.clk      = 30000000,
-};
-
-static int demod_attach_stv0910(struct ddb_input *input, int type)
-{
-	struct i2c_adapter *i2c = &input->port->i2c->adap;
-	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
-
-	dvb->fe = dvb_attach(stv0910_attach, i2c, &stv0910, (input->nr & 1));
-	if (!dvb->fe) {
-		pr_err("No STV0910 found!\n");
-		return -ENODEV;
-	}
-	if (!dvb_attach(lnbh25_attach, dvb->fe, i2c,
-			(input->nr & 1) ? 0x09 : 0x08)) {
-		pr_err("No LNBH25 found!\n");
-		return -ENODEV;
-	}
-	return 0;
-}
-
-static int tuner_attach_stv6111(struct ddb_input *input)
-{
-	struct i2c_adapter *i2c = &input->port->i2c->adap;
-	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
-	struct dvb_frontend *fe;
-
-	fe = dvb_attach(stv6111_attach, dvb->fe, i2c,
-			(input->nr & 1) ? 0x63 : 0x60);
-	if (!fe) {
-		pr_err("No STV6111 found!\n");
-		return -ENODEV;
-	}
-	return 0;
-}
-
-static struct mxl5xx_cfg mxl5xx = {
-	.adr      = 0x60,
-	.type     = 0x01,
-	.clk      = 27000000,
-	.cap      = 12,
-};
-
-static int lnb_command(struct ddb *dev, u32 lnb, u32 cmd)
-{
-	u32 c, v = 0;
-
-	v = LNB_TONE & (dev->lnb_tone << (15 - lnb));
-	pr_info("lnb_control[%u] = %08x\n", lnb, cmd | v);
-	ddbwritel(dev, cmd | v, LNB_CONTROL(lnb));
-	for (c = 0; c < 10; c++) {
-		v = ddbreadl(dev, LNB_CONTROL(lnb));
-		pr_info("ctrl = %08x\n", v);
-		if ((v & LNB_BUSY) == 0)
-			break;
-		msleep(20);
-	}
-	return 0;
-}
-
-static int dd_send_master_cmd(struct dvb_frontend *fe,
-			      struct dvb_diseqc_master_cmd *cmd)
-{
-	struct ddb_input *input = fe->sec_priv;
-	struct ddb_port *port = input->port;
-	struct ddb *dev = port->dev;
-	struct ddb_dvb *dvb = &port->dvb[input->nr & 1];
-	int i;
-
-	mutex_lock(&dev->lnb_lock);
-	ddbwritel(dev, 0, LNB_BUF_LEVEL(dvb->input));
-	for (i = 0; i < cmd->msg_len; i++)
-		ddbwritel(dev, cmd->msg[i], LNB_BUF_WRITE(dvb->input));
-	lnb_command(dev, dvb->input, LNB_CMD_DISEQC);
-	mutex_unlock(&dev->lnb_lock);
-	return 0;
-}
-
-static int dd_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
-{
-	struct ddb_input *input = fe->sec_priv;
-	struct ddb_port *port = input->port;
-	struct ddb *dev = port->dev;
-	struct ddb_dvb *dvb = &port->dvb[input->nr & 1];
-	int s = 0;
-
-	mutex_lock(&dev->lnb_lock);
-	switch (tone) {
-	case SEC_TONE_OFF:
-		dev->lnb_tone &= ~(1ULL << dvb->input);
-		break;
-	case SEC_TONE_ON:
-		dev->lnb_tone |= (1ULL << dvb->input);
-		break;
-	default:
-		s = -EINVAL;
-		break;
-	};
-	if (!s)
-		s = lnb_command(dev, dvb->input, LNB_CMD_NOP);
-	mutex_unlock(&dev->lnb_lock);
-	return 0;
-}
-
-static int dd_enable_high_lnb_voltage(struct dvb_frontend *fe, long arg)
-{
-
-	return 0;
-}
-
-static int dd_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
-{
-	struct ddb_input *input = fe->sec_priv;
-	struct ddb_port *port = input->port;
-	struct ddb *dev = port->dev;
-	struct ddb_dvb *dvb = &port->dvb[input->nr & 1];
-	int s = 0;
-
-	mutex_lock(&dev->lnb_lock);
-	switch (voltage) {
-	case SEC_VOLTAGE_OFF:
-		lnb_command(dev, dvb->input, LNB_CMD_OFF);
-		break;
-	case SEC_VOLTAGE_13:
-		lnb_command(dev, dvb->input, LNB_CMD_LOW);
-		break;
-	case SEC_VOLTAGE_18:
-		lnb_command(dev, dvb->input, LNB_CMD_HIGH);
-		break;
-	default:
-		s = -EINVAL;
-		break;
-	};
-	mutex_unlock(&dev->lnb_lock);
-	return s;
-}
-
-static int dd_set_input(struct dvb_frontend *fe)
-{
-	
-	return 0;
-}
-
-static int fe_attach_mxl5xx(struct ddb_input *input)
-{
-	struct ddb *dev = input->port->dev;
-	struct i2c_adapter *i2c = &dev->i2c[0].adap;
-	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
-	int demod, tuner;
-
-	demod = input->nr;
-	tuner = demod & 3;
-	dvb->fe = dvb_attach(mxl5xx_attach, i2c, &mxl5xx,
-			     demod, tuner);
-	if (!dvb->fe) {
-		pr_err("No MXL5XX found!\n");
-		return -ENODEV;
-	}
-	if (input->nr < 4) 
-		lnb_command(dev, input->nr, LNB_CMD_INIT);
-	dvb->fe->ops.set_voltage = dd_set_voltage;
-	dvb->fe->ops.enable_high_lnb_voltage = dd_enable_high_lnb_voltage;
-	dvb->fe->ops.set_tone = dd_set_tone;
-	dvb->fe->ops.diseqc_send_master_cmd = dd_send_master_cmd;
-	dvb->fe->sec_priv = input;
-	dvb->set_input = dvb->fe->ops.set_input;
-	dvb->fe->ops.set_input = dd_set_input;
-	dvb->input = tuner;
-	return 0;
-}
-
 static int my_dvb_dmx_ts_card_init(struct dvb_demux *dvbdemux, char *id,
 				   int (*start_feed)(struct dvb_demux_feed *),
 				   int (*stop_feed)(struct dvb_demux_feed *),
@@ -1455,29 +1030,6 @@ static int my_dvb_dmxdev_ts_card_init(struct dmxdev *dmxdev,
 	return dvbdemux->dmx.connect_frontend(&dvbdemux->dmx, hw_frontend);
 }
 
-#if 0
-static int start_input(struct ddb_input *input)
-{
-	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
-
-	if (!dvb->users)
-		ddb_input_start_all(input);
-
-	return ++dvb->users;
-}
-
-static int stop_input(struct ddb_input *input)
-{
-	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
-
-	if (--dvb->users)
-		return dvb->users;
-
-	ddb_input_stop_all(input);
-	return 0;
-}
-#endif
-
 static int start_feed(struct dvb_demux_feed *dvbdmxfeed)
 {
 	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
@@ -1520,8 +1072,7 @@ static void dvb_input_detach(struct ddb_input *input)
 		dvb->fe = dvb->fe2 = NULL;
 		/* fallthrough */
 	case 0x21:
-		if (input->port->dev->ns_num)
-			dvb_netstream_release(&dvb->dvbns);
+		/* netstream release */
 		/* fallthrough */
 	case 0x20:
 		dvb_net_release(&dvb->dvbnet);
@@ -1673,16 +1224,14 @@ static int dvb_input_attach(struct ddb_input *input)
 	dvb->attached = 0x20;
 
 	if (input->port->dev->ns_num) {
-		ret = netstream_init(input);
-		if (ret < 0)
-			return ret;
+		/* netstream init */
 		dvb->attached = 0x21;
 	}
 	dvb->fe = dvb->fe2 = 0;
 	switch (port->type) {
 	case DDB_TUNER_MXL5XX:
-		fe_attach_mxl5xx(input);
-		break;
+		dev_notice(port->dev->dev, "MaxLinear MxL5xx not supported\n");
+		return -ENODEV;
 	case DDB_TUNER_DVBS_ST:
 		if (demod_attach_stv0900(input, 0) < 0)
 			return -ENODEV;
@@ -1691,37 +1240,29 @@ static int dvb_input_attach(struct ddb_input *input)
 		break;
 	case DDB_TUNER_DVBS_STV0910:
 	case DDB_TUNER_DVBS_STV0910_P:
-		if (demod_attach_stv0910(input, 0) < 0)
-			return -ENODEV;
-		if (tuner_attach_stv6111(input) < 0)
-			return -ENODEV;
-		break;
+		dev_notice(port->dev->dev, "STMicroelectronics STV0910 not supported\n");
+		return -ENODEV;
 	case DDB_TUNER_DVBS_ST_AA:
 		if (demod_attach_stv0900(input, 1) < 0)
 			return -ENODEV;
 		if (tuner_attach_stv6110(input, 1) < 0)
 			return -ENODEV;
 		break;
-#ifdef CONFIG_DVB_DRXK
 	case DDB_TUNER_DVBCT_TR:
 		if (demod_attach_drxk(input) < 0)
 			return -ENODEV;
 		if (tuner_attach_tda18271(input) < 0)
 			return -ENODEV;
 		break;
-#endif
 	case DDB_TUNER_DVBCT_ST:
-		if (demod_attach_stv0367dd(input) < 0)
-			return -ENODEV;
-		if (tuner_attach_tda18212dd(input) < 0)
-			return -ENODEV;
-		break;
+		dev_notice(port->dev->dev, "STMicroelectronics STV0367 not supported\n");
+		return -ENODEV;
 	case DDB_TUNER_DVBCT2_SONY:
 	case DDB_TUNER_DVBC2T2_SONY:
 	case DDB_TUNER_ISDBT_SONY:
 		if (demod_attach_cxd2843(input, 0) < 0)
 			return -ENODEV;
-		if (tuner_attach_tda18212dd(input) < 0)
+		if (tuner_attach_tda18212(input) < 0)
 			return -ENODEV;
 		break;
 	case DDB_TUNER_DVBCT2_SONY_P:
@@ -1729,7 +1270,7 @@ static int dvb_input_attach(struct ddb_input *input)
 	case DDB_TUNER_ISDBT_SONY_P:
 		if (demod_attach_cxd2843(input, 1) < 0)
 			return -ENODEV;
-		if (tuner_attach_tda18212dd(input) < 0)
+		if (tuner_attach_tda18212(input) < 0)
 			return -ENODEV;
 		break;
 	default:
@@ -1752,7 +1293,6 @@ static int dvb_input_attach(struct ddb_input *input)
 	return 0;
 }
 
-
 static int port_has_encti(struct ddb_port *port)
 {
 	u8 val;
@@ -1841,41 +1381,6 @@ static int port_has_stv0367(struct ddb_port *port)
 	return 1;
 }
 
-#if 0
-static int init_xo2_old(struct ddb_port *port)
-{
-	struct i2c_adapter *i2c = &port->i2c->adap;
-	u8 val;
-	int res;
-
-	res = i2c_read_reg(i2c, 0x10, 0x04, &val);
-	if (res < 0)
-		return res;
-
-	if (val != 0x02)  {
-		pr_info("Port %d: invalid XO2\n", port->nr);
-		return -1;
-	}
-	i2c_write_reg(i2c, 0x10, 0xc0, 0x00); /* Disable XO2 I2C master */
-
-	i2c_read_reg(i2c, 0x10, 0x08, &val);
-	if (val != 0) {
-		i2c_write_reg(i2c, 0x10, 0x08, 0x00);
-		msleep(100);
-	}
-	/* Enable tuner power, disable pll, reset demods */
-	i2c_write_reg(i2c, 0x10, 0x08, 0x04);
-	usleep_range(2000, 3000);
-	/* Release demod resets */
-	i2c_write_reg(i2c, 0x10, 0x08, 0x07);
-	usleep_range(2000, 3000);
-	/* Start XO2 PLL */
-	i2c_write_reg(i2c, 0x10, 0x08, 0x87);
-
-	return 0;
-}
-#endif
-
 static int init_xo2(struct ddb_port *port)
 {
 	struct i2c_adapter *i2c = &port->i2c->adap;
@@ -2235,16 +1740,14 @@ static int ddb_port_attach(struct ddb_port *port)
 		if (ret < 0)
 			break;
 	case DDB_PORT_LOOP:
+		/* XXX: we abuse SEC for CI */
 		ret = dvb_register_device(port->dvb[0].adap,
 					  &port->dvb[0].dev,
 					  &dvbdev_ci, (void *) port->output,
-					  DVB_DEVICE_CI);
+					  DVB_DEVICE_SEC);
 		break;
 	case DDB_PORT_MOD:
-		ret = dvb_register_device(port->dvb[0].adap,
-					  &port->dvb[0].dev,
-					  &dvbdev_mod, (void *) port->output,
-					  DVB_DEVICE_MOD);
+		dev_notice(port->dev->dev, "modulator not supported\n");
 		break;
 	default:
 		break;
@@ -2307,8 +1810,7 @@ static void ddb_ports_detach(struct ddb *dev)
 			}
 			break;
 		case DDB_PORT_MOD:
-			if (port->dvb[0].dev)
-				dvb_unregister_device(port->dvb[0].dev);
+			/* TODO: modulator not supported */
 			break;
 		}
 	}
@@ -2592,10 +2094,7 @@ static void ddb_ports_init(struct ddb *dev)
 			ddb_input_init(port, 2 * i + 1, 1, 2 * i + 1);
 		}
 		if (dev->info->type == DDB_MOD) {
-			ddb_output_init(port, i, i);
-			dev->handler[i + 18] = ddbridge_mod_rate_handler;
-			dev->handler_data[i + 18] =
-				(unsigned long) &dev->output[i];
+			/* TODO: modulator not supported */
 		}
 	}
 }
@@ -2747,168 +2246,6 @@ static irqreturn_t irq_thread(int irq, void *dev_id)
 /****************************************************************************/
 /****************************************************************************/
 
-#ifdef DVB_NSD
-
-static ssize_t nsd_read(struct file *file, char *buf,
-			size_t count, loff_t *ppos)
-{
-	return 0;
-}
-
-static unsigned int nsd_poll(struct file *file, poll_table *wait)
-{
-	return 0;
-}
-
-static int nsd_release(struct inode *inode, struct file *file)
-{
-	return dvb_generic_release(inode, file);
-}
-
-static int nsd_open(struct inode *inode, struct file *file)
-{
-	return dvb_generic_open(inode, file);
-}
-
-static int nsd_do_ioctl(struct file *file, unsigned int cmd, void *parg)
-{
-	struct dvb_device *dvbdev = file->private_data;
-	struct ddb *dev = dvbdev->priv;
-
-	/* unsigned long arg = (unsigned long) parg; */
-	int ret = 0;
-
-	switch (cmd) {
-	case NSD_START_GET_TS:
-	{
-		struct dvb_nsd_ts *ts = parg;
-		u32 ctrl = ((ts->input & 7) << 8) |
-			((ts->filter_mask & 3) << 2);
-		u32 to;
-
-		if (ddbreadl(dev, TS_CAPTURE_CONTROL) & 1) {
-			pr_info("ts capture busy\n");
-			return -EBUSY;
-		}
-		ddb_dvb_input_start(&dev->input[ts->input & 7]);
-
-		ddbwritel(dev, ctrl, TS_CAPTURE_CONTROL);
-		ddbwritel(dev, ts->pid, TS_CAPTURE_PID);
-		ddbwritel(dev, (ts->section_id << 16) |
-			  (ts->table << 8) | ts->section,
-			  TS_CAPTURE_TABLESECTION);
-		/* 1024 ms default timeout if timeout set to 0 */
-		if (ts->timeout)
-			to = ts->timeout;
-		else
-			to = 1024;
-		/* 21 packets default if num set to 0 */
-		if (ts->num)
-			to |= ((u32) ts->num << 16);
-		else
-			to |= (21 << 16);
-		ddbwritel(dev, to, TS_CAPTURE_TIMEOUT);
-		if (ts->mode)
-			ctrl |= 2;
-		ddbwritel(dev, ctrl | 1, TS_CAPTURE_CONTROL);
-		break;
-	}
-	case NSD_POLL_GET_TS:
-	{
-		struct dvb_nsd_ts *ts = parg;
-		u32 ctrl = ddbreadl(dev, TS_CAPTURE_CONTROL);
-
-		if (ctrl & 1)
-			return -EBUSY;
-		if (ctrl & (1 << 14)) {
-			/*pr_info("ts capture timeout\n");*/
-			return -EAGAIN;
-		}
-		ddbcpyfrom(dev, dev->tsbuf, TS_CAPTURE_MEMORY,
-			   TS_CAPTURE_LEN);
-		ts->len = ddbreadl(dev, TS_CAPTURE_RECEIVED) & 0x1fff;
-		if (copy_to_user(ts->ts, dev->tsbuf, ts->len))
-			return -EIO;
-		break;
-	}
-	case NSD_CANCEL_GET_TS:
-	{
-		u32 ctrl = 0;
-		pr_info("cancel ts capture: 0x%x\n", ctrl);
-		ddbwritel(dev, ctrl, TS_CAPTURE_CONTROL);
-		ctrl = ddbreadl(dev, TS_CAPTURE_CONTROL);
-		/*pr_info("control register is 0x%x\n", ctrl);*/
-		break;
-	}
-	case NSD_STOP_GET_TS:
-	{
-		struct dvb_nsd_ts *ts = parg;
-		u32 ctrl = ddbreadl(dev, TS_CAPTURE_CONTROL);
-
-		if (ctrl & 1) {
-			pr_info("cannot stop ts capture, while it was neither finished not canceled\n");
-			return -EBUSY;
-		}
-		/*pr_info("ts capture stopped\n");*/
-		ddb_dvb_input_stop(&dev->input[ts->input & 7]);
-		break;
-	}
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	return ret;
-}
-
-static long nsd_ioctl(struct file *file,
-		      unsigned int cmd, unsigned long arg)
-{
-	return dvb_usercopy(file, cmd, arg, nsd_do_ioctl);
-}
-
-static const struct file_operations nsd_fops = {
-	.owner   = THIS_MODULE,
-	.read    = nsd_read,
-	.open    = nsd_open,
-	.release = nsd_release,
-	.poll    = nsd_poll,
-	.unlocked_ioctl = nsd_ioctl,
-};
-
-static struct dvb_device dvbdev_nsd = {
-	.priv    = 0,
-	.readers = 1,
-	.writers = 1,
-	.users   = 1,
-	.fops    = &nsd_fops,
-};
-
-static int ddb_nsd_attach(struct ddb *dev)
-{
-	int ret;
-
-	ret = dvb_register_device(&dev->adap[0],
-				  &dev->nsd_dev,
-				  &dvbdev_nsd, (void *) dev,
-				  DVB_DEVICE_NSD);
-	return ret;
-}
-
-static void ddb_nsd_detach(struct ddb *dev)
-{
-	if (dev->nsd_dev->users > 2) {
-		wait_event(dev->nsd_dev->wait_queue,
-			   dev->nsd_dev->users == 2);
-	}
-	dvb_unregister_device(dev->nsd_dev);
-}
-
-#endif
-
-/****************************************************************************/
-/****************************************************************************/
-/****************************************************************************/
-
 static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 {
 	u32 data, shift;
@@ -3231,11 +2568,7 @@ static const struct file_operations ddb_fops = {
 	.release        = ddb_release,
 };
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 4, 0))
-static char *ddb_devnode(struct device *device, mode_t *mode)
-#else
 static char *ddb_devnode(struct device *device, umode_t *mode)
-#endif
 {
 	struct ddb *dev = dev_get_drvdata(device);
 
@@ -3317,26 +2650,11 @@ static ssize_t temp_show(struct device *device,
 {
 	struct ddb *dev = dev_get_drvdata(device);
 	struct i2c_adapter *adap;
-	int temp, temp2, temp3, i;
+	int temp, temp2;
 	u8 tmp[2];
 
 	if (dev->info->type == DDB_MOD) {
-		ddbwritel(dev, 1, TEMPMON_CONTROL);
-		for (i = 0; i < 10; i++) {
-			if (0 == (1 & ddbreadl(dev, TEMPMON_CONTROL)))
-				break;
-			usleep_range(1000, 2000);
-		}
-		temp = ddbreadl(dev, TEMPMON_SENSOR1);
-		temp2 = ddbreadl(dev, TEMPMON_SENSOR2);
-		temp = (temp * 1000) >> 8;
-		temp2 = (temp2 * 1000) >> 8;
-		if (ddbreadl(dev, TEMPMON_CONTROL) & 0x8000) {
-			temp3 = ddbreadl(dev, TEMPMON_CORE);
-			temp3 = (temp3 * 1000) >> 8;
-			return sprintf(buf, "%d %d %d\n", temp, temp2, temp3);
-		}
-		return sprintf(buf, "%d %d\n", temp, temp2);
+		/* TODO: modulator not supported */
 	}
 	if (!dev->info->temp_num)
 		return sprintf(buf, "no sensor\n");
@@ -3355,25 +2673,6 @@ static ssize_t temp_show(struct device *device,
 	return sprintf(buf, "%d\n", temp);
 }
 
-#if 0
-static ssize_t qam_show(struct device *device,
-			struct device_attribute *attr, char *buf)
-{
-	struct ddb *dev = dev_get_drvdata(device);
-	struct i2c_adapter *adap;
-	u8 tmp[4];
-	s16 i, q;
-
-	adap = &dev->i2c[1].adap;
-	if (i2c_read_regs16(adap, 0x1f, 0xf480, tmp, 4) < 0)
-		return sprintf(buf, "read_error\n");
-	i = (s16) (((u16) tmp[1]) << 14) | (((u16) tmp[0]) << 6);
-	q = (s16) (((u16) tmp[3]) << 14) | (((u16) tmp[2]) << 6);
-
-	return sprintf(buf, "%d %d\n", i, q);
-}
-#endif
-
 static ssize_t mod_show(struct device *device,
 			struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
index bd0d9b1..6845d2a 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.c
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -161,24 +161,6 @@ static int ddb_i2c_master_xfer(struct i2c_adapter *adapter,
 	return -EIO;
 }
 
-#if 0
-static int ddb_i2c_master_xfer(struct i2c_adapter *adapter,
-			       struct i2c_msg msg[], int num)
-{
-	struct ddb_i2c *i2c = (struct ddb_i2c *) i2c_get_adapdata(adapter);
-	struct ddb *dev = i2c->dev;
-	int ret;
-
-	if (dev->info->type != DDB_OCTONET || i2c->nr == 0 || i2c->nr == 3)
-		return ddb_i2c_master_xfer_locked(adapter, msg, num);
-
-	mutex_lock(&dev->octonet_i2c_lock);
-	ret = ddb_i2c_master_xfer_locked(adapter, msg, num);
-	mutex_unlock(&dev->octonet_i2c_lock);
-	return ret;
-}
-#endif
-
 static u32 ddb_i2c_functionality(struct i2c_adapter *adap)
 {
 	return I2C_FUNC_SMBUS_EMUL;
@@ -231,13 +213,6 @@ static int ddb_i2c_init(struct ddb *dev)
 
 		adap = &i2c->adap;
 		i2c_set_adapdata(adap, i2c);
-#ifdef I2C_ADAP_CLASS_TV_DIGITAL
-		adap->class = I2C_ADAP_CLASS_TV_DIGITAL|I2C_CLASS_TV_ANALOG;
-#else
-#ifdef I2C_CLASS_TV_ANALOG
-		adap->class = I2C_CLASS_TV_ANALOG;
-#endif
-#endif
 		strcpy(adap->name, "ddbridge");
 		adap->algo = &ddb_i2c_algo;
 		adap->algo_data = (void *)i2c;
diff --git a/drivers/media/pci/ddbridge/ddbridge.c b/drivers/media/pci/ddbridge/ddbridge.c
index 70c7ef0..fbd7e4f 100644
--- a/drivers/media/pci/ddbridge/ddbridge.c
+++ b/drivers/media/pci/ddbridge/ddbridge.c
@@ -58,7 +58,7 @@ static void ddb_unmap(struct ddb *dev)
 }
 
 
-static void __devexit ddb_remove(struct pci_dev *pdev)
+static void ddb_remove(struct pci_dev *pdev)
 {
 	struct ddb *dev = (struct ddb *) pci_get_drvdata(pdev);
 
@@ -83,13 +83,7 @@ static void __devexit ddb_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3, 8, 0))
-#define __devinit
-#define __devinitdata
-#endif
-
-static int __devinit ddb_probe(struct pci_dev *pdev,
-			       const struct pci_device_id *id)
+static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct ddb *dev;
 	int stat = 0;
@@ -146,6 +140,7 @@ static int __devinit ddb_probe(struct pci_dev *pdev,
 
 #ifdef CONFIG_PCI_MSI
 	if (msi && pci_msi_enabled()) {
+#define pci_enable_msi_block pci_enable_msi_exact
 		stat = pci_enable_msi_block(dev->pdev, 2);
 		if (stat == 0) {
 			dev->msi = 1;
@@ -216,8 +211,6 @@ static int __devinit ddb_probe(struct pci_dev *pdev,
 		ddbwritel(dev, 1, GPIO_DIRECTION);
 		ddbwritel(dev, 1, GPIO_OUTPUT);
 	}
-	if (dev->info->type == DDB_MOD)
-		ddbridge_mod_init(dev);
 
 	return 0;
 
@@ -373,12 +366,15 @@ static struct ddb_info ddb_dvbct = {
 	.i2c_num  = 3,
 };
 
+/*
+ * TODO: modulator not supported
 static struct ddb_info ddb_mod = {
 	.type     = DDB_MOD,
 	.name     = "Digital Devices DVB-C modulator",
 	.port_num = 10,
 	.temp_num = 1,
 };
+ */
 
 #define DDVID 0xdd01 /* Digital Devices Vendor ID */
 
@@ -387,7 +383,7 @@ static struct ddb_info ddb_mod = {
 	.subvendor   = _subvend, .subdevice = _subdev, \
 	.driver_data = (unsigned long)&_driverdata }
 
-static const struct pci_device_id ddb_id_tbl[] __devinitconst = {
+static const struct pci_device_id ddb_id_tbl[] = {
 	DDB_ID(DDVID, 0x0002, DDVID, 0x0001, ddb_octopus),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0001, ddb_octopus),
 	DDB_ID(DDVID, 0x0005, DDVID, 0x0004, ddb_octopusv3),
@@ -405,7 +401,7 @@ static const struct pci_device_id ddb_id_tbl[] __devinitconst = {
 	DDB_ID(DDVID, 0x0007, DDVID, 0x0023, ddb_s2_48),
 	DDB_ID(DDVID, 0x0011, DDVID, 0x0040, ddb_ci),
 	DDB_ID(DDVID, 0x0011, DDVID, 0x0041, ddb_cis),
-	DDB_ID(DDVID, 0x0201, DDVID, 0x0001, ddb_mod),
+/*	DDB_ID(DDVID, 0x0201, DDVID, 0x0001, ddb_mod), */
 	/* in case sub-ids got deleted in flash */
 	DDB_ID(DDVID, 0x0003, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
 	DDB_ID(DDVID, 0x0011, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 1d028cf..601cf24 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -26,13 +26,6 @@
 #define _DDBRIDGE_H_
 
 #include <linux/version.h>
-
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3, 8, 0))
-#define __devexit
-#define __devinit
-#define __devinitconst
-#endif
-
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -69,7 +62,6 @@
 #include <linux/device.h>
 #include <linux/io.h>
 
-#include "dvb_netstream.h"
 #include "dmxdev.h"
 #include "dvbdev.h"
 #include "dvb_demux.h"
@@ -83,16 +75,9 @@
 #include "stv090x.h"
 #include "lnbh24.h"
 #include "drxk.h"
-#include "stv0367.h"
-#include "stv0367dd.h"
 #include "tda18212.h"
-#include "tda18212dd.h"
 #include "cxd2843.h"
 #include "cxd2099.h"
-#include "stv0910.h"
-#include "stv6111.h"
-#include "lnbh25.h"
-#include "mxl5xx.h"
 
 #define DDB_MAX_I2C     4
 #define DDB_MAX_PORT   10
@@ -201,7 +186,6 @@ struct ddb_dvb {
 	struct dmxdev          dmxdev;
 	struct dvb_demux       demux;
 	struct dvb_net         dvbnet;
-	struct dvb_netstream   dvbns;
 	struct dmx_frontend    hw_frontend;
 	struct dmx_frontend    mem_frontend;
 	int                    users;
-- 
http://palosaari.fi/

