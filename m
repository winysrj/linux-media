Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:56271 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751203Ab1GCV2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 17:28:15 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] ddbridge: Codingstyle fixes
Date: Sun, 3 Jul 2011 23:24:07 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107032321.46092@orion.escape-edv.de>
In-Reply-To: <201107032321.46092@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107032324.08288@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Codingstyle fixes

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/media/dvb/ddbridge/ddbridge-core.c |  191 ++++++++++++++++------------
 drivers/media/dvb/ddbridge/ddbridge-regs.h |   62 +++++-----
 drivers/media/dvb/ddbridge/ddbridge.h      |    8 +-
 3 files changed, 144 insertions(+), 117 deletions(-)

diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index ba9974b..81634f1 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -55,7 +55,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 static int i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val)
 {
 	struct i2c_msg msgs[1] = {{.addr = adr,  .flags = I2C_M_RD,
-				   .buf  = val,  .len   = 1 }};
+				   .buf  = val,  .len   = 1 } };
 	return (i2c_transfer(adapter, msgs, 1) == 1) ? 0 : -1;
 }
 
@@ -64,7 +64,7 @@ static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr, u8 reg, u8 *val)
 	struct i2c_msg msgs[2] = {{.addr = adr,  .flags = 0,
 				   .buf  = &reg, .len   = 1 },
 				  {.addr = adr,  .flags = I2C_M_RD,
-				   .buf  = val,  .len   = 1 }};
+				   .buf  = val,  .len   = 1 } };
 	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
 }
 
@@ -75,7 +75,7 @@ static int i2c_read_reg16(struct i2c_adapter *adapter, u8 adr,
 	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
 				   .buf  = msg, .len   = 2},
 				  {.addr = adr, .flags = I2C_M_RD,
-				   .buf  = val, .len   = 1}};
+				   .buf  = val, .len   = 1} };
 	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
 }
 
@@ -89,15 +89,15 @@ static int ddb_i2c_cmd(struct ddb_i2c *i2c, u32 adr, u32 cmd)
 	ddbwritel((adr << 9) | cmd, i2c->regs + I2C_COMMAND);
 	stat = wait_event_timeout(i2c->wq, i2c->done == 1, HZ);
 	if (stat <= 0) {
-		printk("I2C timeout\n");
+		printk(KERN_ERR "I2C timeout\n");
 		{ /* MSI debugging*/
 			u32 istat = ddbreadl(INTERRUPT_STATUS);
-			printk("IRS %08x\n", istat);
+			printk(KERN_ERR "IRS %08x\n", istat);
 			ddbwritel(istat, INTERRUPT_ACK);
 		}
 		return -EIO;
 	}
-	val=ddbreadl(i2c->regs+I2C_COMMAND);
+	val = ddbreadl(i2c->regs+I2C_COMMAND);
 	if (val & 0x70000)
 		return -EIO;
 	return 0;
@@ -108,7 +108,7 @@ static int ddb_i2c_master_xfer(struct i2c_adapter *adapter,
 {
 	struct ddb_i2c *i2c = (struct ddb_i2c *)i2c_get_adapdata(adapter);
 	struct ddb *dev = i2c->dev;
-	u8 addr=0;
+	u8 addr = 0;
 
 	if (num)
 		addr = msg[0].addr;
@@ -116,7 +116,7 @@ static int ddb_i2c_master_xfer(struct i2c_adapter *adapter,
 	if (num == 2 && msg[1].flags & I2C_M_RD &&
 	    !(msg[0].flags & I2C_M_RD)) {
 		memcpy_toio(dev->regs + I2C_TASKMEM_BASE + i2c->wbuf,
-			    msg[0].buf,msg[0].len);
+			    msg[0].buf, msg[0].len);
 		ddbwritel(msg[0].len|(msg[1].len << 16),
 			  i2c->regs+I2C_TASKLENGTH);
 		if (!ddb_i2c_cmd(i2c, addr, 1)) {
@@ -128,7 +128,7 @@ static int ddb_i2c_master_xfer(struct i2c_adapter *adapter,
 	}
 
 	if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
-		ddbcpyto(I2C_TASKMEM_BASE + i2c->wbuf,msg[0].buf, msg[0].len);
+		ddbcpyto(I2C_TASKMEM_BASE + i2c->wbuf, msg[0].buf, msg[0].len);
 		ddbwritel(msg[0].len, i2c->regs + I2C_TASKLENGTH);
 		if (!ddb_i2c_cmd(i2c, addr, 2))
 			return num;
@@ -217,6 +217,7 @@ static int ddb_i2c_init(struct ddb *dev)
 /******************************************************************************/
 /******************************************************************************/
 
+#if 0
 static void set_table(struct ddb *dev, u32 off,
 		      dma_addr_t *pbuf, u32 num)
 {
@@ -230,6 +231,7 @@ static void set_table(struct ddb *dev, u32 off,
 		ddbwritel(mem >> 32, base + i * 8 + 4);
 	}
 }
+#endif
 
 static void ddb_address_table(struct ddb *dev)
 {
@@ -401,7 +403,7 @@ static void ddb_output_start(struct ddb_output *output)
 
 	ddbwritel(1, DMA_BASE_READ);
 	ddbwritel(3, DMA_BUFFER_CONTROL(output->nr + 8));
-	//ddbwritel(0xbd, TS_OUTPUT_CONTROL(output->nr));
+	/* ddbwritel(0xbd, TS_OUTPUT_CONTROL(output->nr)); */
 	ddbwritel(0x1d, TS_OUTPUT_CONTROL(output->nr));
 	output->running = 1;
 	spin_unlock_irq(&output->lock);
@@ -438,7 +440,7 @@ static u32 ddb_output_free(struct ddb_output *output)
 	return 0;
 }
 
-static ssize_t ddb_output_write(struct ddb_output* output,
+static ssize_t ddb_output_write(struct ddb_output *output,
 				const u8 *buf, size_t count)
 {
 	struct ddb *dev = output->port->dev;
@@ -452,9 +454,9 @@ static ssize_t ddb_output_write(struct ddb_output* output,
 		len = output->dma_buf_size - output->coff;
 		if ((((output->cbuf + 1) % output->dma_buf_num) == idx) &&
 		    (off == 0)) {
-			if (len<=188)
+			if (len <= 188)
 				break;
-			len-=188;
+			len -= 188;
 		}
 		if (output->cbuf == idx) {
 			if (off > output->coff) {
@@ -496,7 +498,7 @@ static u32 ddb_input_avail(struct ddb_input *input)
 	off = (stat & 0x7ff) << 7;
 
 	if (ctrl & 4) {
-		printk("IA %d %d %08x\n", idx, off, ctrl);
+		printk(KERN_ERR "IA %d %d %08x\n", idx, off, ctrl);
 		ddbwritel(input->stat, DMA_BUFFER_ACK(input->nr));
 		return 0;
 	}
@@ -545,7 +547,7 @@ static struct ddb_input *fe2input(struct ddb *dev, struct dvb_frontend *fe)
 	int i;
 
 	for (i = 0; i < dev->info->port_num * 2; i++) {
-		if (dev->input[i].fe==fe)
+		if (dev->input[i].fe == fe)
 			return &dev->input[i];
 	}
 	return NULL;
@@ -573,11 +575,11 @@ static int demod_attach_drxk(struct ddb_input *input)
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
 	struct dvb_frontend *fe;
 
-	fe=input->fe = dvb_attach(drxk_attach,
-				  i2c, 0x29 + (input->nr&1),
-				  &input->fe2);
+	fe = input->fe = dvb_attach(drxk_attach,
+				    i2c, 0x29 + (input->nr&1),
+				    &input->fe2);
 	if (!input->fe) {
-		printk("No DRXK found!\n");
+		printk(KERN_ERR "No DRXK found!\n");
 		return -ENODEV;
 	}
 	fe->sec_priv = input;
@@ -595,7 +597,7 @@ static int tuner_attach_tda18271(struct ddb_input *input)
 		input->fe->ops.i2c_gate_ctrl(input->fe, 1);
 	fe = dvb_attach(tda18271c2dd_attach, input->fe, i2c, 0x60);
 	if (!fe) {
-		printk("No TDA18271 found!\n");
+		printk(KERN_ERR "No TDA18271 found!\n");
 		return -ENODEV;
 	}
 	if (input->fe->ops.i2c_gate_ctrl)
@@ -662,17 +664,17 @@ static int demod_attach_stv0900(struct ddb_input *input, int type)
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
 	struct stv090x_config *feconf = type ? &stv0900_aa : &stv0900;
 
-	input->fe=dvb_attach(stv090x_attach, feconf, i2c,
-			     (input->nr & 1) ? STV090x_DEMODULATOR_1
-			     : STV090x_DEMODULATOR_0);
+	input->fe = dvb_attach(stv090x_attach, feconf, i2c,
+			       (input->nr & 1) ? STV090x_DEMODULATOR_1
+			       : STV090x_DEMODULATOR_0);
 	if (!input->fe) {
-		printk("No STV0900 found!\n");
+		printk(KERN_ERR "No STV0900 found!\n");
 		return -ENODEV;
 	}
 	if (!dvb_attach(lnbh24_attach, input->fe, i2c, 0,
 			0, (input->nr & 1) ?
 			(0x09 - type) : (0x0b - type))) {
-		printk("No LNBH24 found!\n");
+		printk(KERN_ERR "No LNBH24 found!\n");
 		return -ENODEV;
 	}
 	return 0;
@@ -688,10 +690,11 @@ static int tuner_attach_stv6110(struct ddb_input *input, int type)
 
 	ctl = dvb_attach(stv6110x_attach, input->fe, tunerconf, i2c);
 	if (!ctl) {
-		printk("No STV6110X found!\n");
+		printk(KERN_ERR "No STV6110X found!\n");
 		return -ENODEV;
 	}
-	printk("attach tuner input %d adr %02x\n", input->nr, tunerconf->addr);
+	printk(KERN_INFO "attach tuner input %d adr %02x\n",
+			 input->nr, tunerconf->addr);
 
 	feconf->tuner_init          = ctl->tuner_init;
 	feconf->tuner_sleep         = ctl->tuner_sleep;
@@ -813,11 +816,11 @@ static int dvb_input_attach(struct ddb_input *input)
 	struct dvb_adapter *adap = &input->adap;
 	struct dvb_demux *dvbdemux = &input->demux;
 
-	ret=dvb_register_adapter(adap, "DDBridge",THIS_MODULE,
+	ret = dvb_register_adapter(adap, "DDBridge", THIS_MODULE,
 				   &input->port->dev->pdev->dev,
 				   adapter_nr);
 	if (ret < 0) {
-		printk("ddbridge: Could not register adapter."
+		printk(KERN_ERR "ddbridge: Could not register adapter."
 		       "Check if you enabled enough adapters in dvb-core!\n");
 		return ret;
 	}
@@ -876,7 +879,7 @@ static int dvb_input_attach(struct ddb_input *input)
 		if (input->fe2) {
 			if (dvb_register_frontend(adap, input->fe2) < 0)
 				return -ENODEV;
-			input->fe2->tuner_priv=input->fe->tuner_priv;
+			input->fe2->tuner_priv = input->fe->tuner_priv;
 			memcpy(&input->fe2->ops.tuner_ops,
 			       &input->fe->ops.tuner_ops,
 			       sizeof(struct dvb_tuner_ops));
@@ -942,9 +945,11 @@ static ssize_t ts_read(struct file *file, char *buf,
 
 static unsigned int ts_poll(struct file *file, poll_table *wait)
 {
+	/*
 	struct dvb_device *dvbdev = file->private_data;
 	struct ddb_output *output = dvbdev->priv;
 	struct ddb_input *input = output->port->input[0];
+	*/
 	unsigned int mask = 0;
 
 #if 0
@@ -959,7 +964,7 @@ static unsigned int ts_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-static struct file_operations ci_fops = {
+static const struct file_operations ci_fops = {
 	.owner   = THIS_MODULE,
 	.read    = ts_read,
 	.write   = ts_write,
@@ -995,7 +1000,7 @@ static void input_tasklet(unsigned long data)
 
 	if (input->port->class == DDB_PORT_TUNER) {
 		if (4&ddbreadl(DMA_BUFFER_CONTROL(input->nr)))
-			printk("Overflow input %d\n", input->nr);
+			printk(KERN_ERR "Overflow input %d\n", input->nr);
 		while (input->cbuf != ((input->stat >> 11) & 0x1f)
 		       || (4&ddbreadl(DMA_BUFFER_CONTROL(input->nr)))) {
 			dvb_dmx_swfilter_packets(&input->demux,
@@ -1056,9 +1061,9 @@ static int ddb_ci_attach(struct ddb_port *port)
 	ddb_output_start(port->output);
 	dvb_ca_en50221_init(&port->output->adap,
 			    port->en, 0, 1);
-	ret=dvb_register_device(&port->output->adap, &port->output->dev,
-				&dvbdev_ci, (void *) port->output,
-				DVB_DEVICE_SEC);
+	ret = dvb_register_device(&port->output->adap, &port->output->dev,
+				  &dvbdev_ci, (void *) port->output,
+				  DVB_DEVICE_SEC);
 	return ret;
 }
 
@@ -1069,7 +1074,7 @@ static int ddb_port_attach(struct ddb_port *port)
 	switch (port->class) {
 	case DDB_PORT_TUNER:
 		ret = dvb_input_attach(port->input[0]);
-		if (ret<0)
+		if (ret < 0)
 			break;
 		ret = dvb_input_attach(port->input[1]);
 		break;
@@ -1080,7 +1085,7 @@ static int ddb_port_attach(struct ddb_port *port)
 		break;
 	}
 	if (ret < 0)
-		printk("port_attach on port %d failed\n", port->nr);
+		printk(KERN_ERR "port_attach on port %d failed\n", port->nr);
 	return ret;
 }
 
@@ -1132,7 +1137,7 @@ static void ddb_ports_detach(struct ddb *dev)
 static int port_has_ci(struct ddb_port *port)
 {
 	u8 val;
-	return (i2c_read_reg(&port->i2c->adap, 0x40, 0, &val) ? 0 : 1);
+	return i2c_read_reg(&port->i2c->adap, 0x40, 0, &val) ? 0 : 1;
 }
 
 static int port_has_stv0900(struct ddb_port *port)
@@ -1188,7 +1193,8 @@ static void ddb_port_probe(struct ddb_port *port)
 		port->type = DDB_TUNER_DVBCT_TR;
 		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
 	}
-	printk("Port %d (TAB %d): %s\n", port->nr, port->nr+1, modname);
+	printk(KERN_INFO "Port %d (TAB %d): %s\n",
+			 port->nr, port->nr+1, modname);
 }
 
 static void ddb_input_init(struct ddb_port *port, int nr)
@@ -1284,26 +1290,42 @@ static irqreturn_t irq_handler(int irq, void *dev_id)
 	do {
 		ddbwritel(s, INTERRUPT_ACK);
 
-		if (s & 0x00000001) irq_handle_i2c(dev, 0);
-		if (s & 0x00000002) irq_handle_i2c(dev, 1);
-		if (s & 0x00000004) irq_handle_i2c(dev, 2);
-		if (s & 0x00000008) irq_handle_i2c(dev, 3);
-
-		if (s & 0x00000100) tasklet_schedule(&dev->input[0].tasklet);
-		if (s & 0x00000200) tasklet_schedule(&dev->input[1].tasklet);
-		if (s & 0x00000400) tasklet_schedule(&dev->input[2].tasklet);
-		if (s & 0x00000800) tasklet_schedule(&dev->input[3].tasklet);
-		if (s & 0x00001000) tasklet_schedule(&dev->input[4].tasklet);
-		if (s & 0x00002000) tasklet_schedule(&dev->input[5].tasklet);
-		if (s & 0x00004000) tasklet_schedule(&dev->input[6].tasklet);
-		if (s & 0x00008000) tasklet_schedule(&dev->input[7].tasklet);
-
-		if (s & 0x00010000) tasklet_schedule(&dev->output[0].tasklet);
-		if (s & 0x00020000) tasklet_schedule(&dev->output[1].tasklet);
-		if (s & 0x00040000) tasklet_schedule(&dev->output[2].tasklet);
-		if (s & 0x00080000) tasklet_schedule(&dev->output[3].tasklet);
-
-		/* if (s & 0x000f0000)	printk("%08x\n", istat); */
+		if (s & 0x00000001)
+			irq_handle_i2c(dev, 0);
+		if (s & 0x00000002)
+			irq_handle_i2c(dev, 1);
+		if (s & 0x00000004)
+			irq_handle_i2c(dev, 2);
+		if (s & 0x00000008)
+			irq_handle_i2c(dev, 3);
+
+		if (s & 0x00000100)
+			tasklet_schedule(&dev->input[0].tasklet);
+		if (s & 0x00000200)
+			tasklet_schedule(&dev->input[1].tasklet);
+		if (s & 0x00000400)
+			tasklet_schedule(&dev->input[2].tasklet);
+		if (s & 0x00000800)
+			tasklet_schedule(&dev->input[3].tasklet);
+		if (s & 0x00001000)
+			tasklet_schedule(&dev->input[4].tasklet);
+		if (s & 0x00002000)
+			tasklet_schedule(&dev->input[5].tasklet);
+		if (s & 0x00004000)
+			tasklet_schedule(&dev->input[6].tasklet);
+		if (s & 0x00008000)
+			tasklet_schedule(&dev->input[7].tasklet);
+
+		if (s & 0x00010000)
+			tasklet_schedule(&dev->output[0].tasklet);
+		if (s & 0x00020000)
+			tasklet_schedule(&dev->output[1].tasklet);
+		if (s & 0x00040000)
+			tasklet_schedule(&dev->output[2].tasklet);
+		if (s & 0x00080000)
+			tasklet_schedule(&dev->output[3].tasklet);
+
+		/* if (s & 0x000f0000)	printk(KERN_DEBUG "%08x\n", istat); */
 	} while ((s = ddbreadl(INTERRUPT_STATUS)));
 
 	return IRQ_HANDLED;
@@ -1325,7 +1347,8 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 		wbuf += 4;
 		wlen -= 4;
 		ddbwritel(data, SPI_DATA);
-		while (ddbreadl(SPI_CONTROL) & 0x0004);
+		while (ddbreadl(SPI_CONTROL) & 0x0004)
+			;
 	}
 
 	if (rlen)
@@ -1333,7 +1356,7 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 	else
 		ddbwritel(0x0003 | ((wlen << (8 + 3)) & 0x1f00), SPI_CONTROL);
 
-	data=0;
+	data = 0;
 	shift = ((4 - wlen) * 8);
 	while (wlen) {
 		data <<= 8;
@@ -1344,7 +1367,8 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 	if (shift)
 		data <<= shift;
 	ddbwritel(data, SPI_DATA);
-	while (ddbreadl(SPI_CONTROL) & 0x0004);
+	while (ddbreadl(SPI_CONTROL) & 0x0004)
+		;
 
 	if (!rlen) {
 		ddbwritel(0, SPI_CONTROL);
@@ -1355,7 +1379,8 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 
 	while (rlen > 4) {
 		ddbwritel(0xffffffff, SPI_DATA);
-		while (ddbreadl(SPI_CONTROL) & 0x0004);
+		while (ddbreadl(SPI_CONTROL) & 0x0004)
+			;
 		data = ddbreadl(SPI_DATA);
 		*(u32 *) rbuf = swab32(data);
 		rbuf += 4;
@@ -1363,7 +1388,8 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 	}
 	ddbwritel(0x0003 | ((rlen << (8 + 3)) & 0x1F00), SPI_CONTROL);
 	ddbwritel(0xffffffff, SPI_DATA);
-	while (ddbreadl(SPI_CONTROL) & 0x0004);
+	while (ddbreadl(SPI_CONTROL) & 0x0004)
+		;
 
 	data = ddbreadl(SPI_DATA);
 	ddbwritel(0, SPI_CONTROL);
@@ -1421,7 +1447,7 @@ static long ddb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&fio, parg, sizeof(fio)))
 			break;
 		if (fio.write_len + fio.read_len > 1028) {
-			printk("IOBUF too small\n");
+			printk(KERN_ERR "IOBUF too small\n");
 			return -ENOMEM;
 		}
 		wbuf = &dev->iobuf[0];
@@ -1444,7 +1470,7 @@ static long ddb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return res;
 }
 
-static struct file_operations ddb_fops={
+static const struct file_operations ddb_fops = {
 	.unlocked_ioctl = ddb_ioctl,
 	.open           = ddb_open,
 };
@@ -1458,7 +1484,8 @@ static char *ddb_devnode(struct device *device, mode_t *mode)
 
 static int ddb_class_create(void)
 {
-	if ((ddb_major = register_chrdev(0, DDB_NAME, &ddb_fops))<0)
+	ddb_major = register_chrdev(0, DDB_NAME, &ddb_fops);
+	if (ddb_major < 0)
 		return ddb_major;
 
 	ddb_class = class_create(THIS_MODULE, DDB_NAME);
@@ -1536,10 +1563,10 @@ static int __devinit ddb_probe(struct pci_dev *pdev,
 			       const struct pci_device_id *id)
 {
 	struct ddb *dev;
-	int stat=0;
+	int stat = 0;
 	int irq_flag = IRQF_SHARED;
 
-	if (pci_enable_device(pdev)<0)
+	if (pci_enable_device(pdev) < 0)
 		return -ENODEV;
 
 	dev = vmalloc(sizeof(struct ddb));
@@ -1550,15 +1577,15 @@ static int __devinit ddb_probe(struct pci_dev *pdev,
 	dev->pdev = pdev;
 	pci_set_drvdata(pdev, dev);
 	dev->info = (struct ddb_info *) id->driver_data;
-	printk("DDBridge driver detected: %s\n", dev->info->name);
+	printk(KERN_INFO "DDBridge driver detected: %s\n", dev->info->name);
 
-	dev->regs = ioremap(pci_resource_start(dev->pdev,0),
-			    pci_resource_len(dev->pdev,0));
+	dev->regs = ioremap(pci_resource_start(dev->pdev, 0),
+			    pci_resource_len(dev->pdev, 0));
 	if (!dev->regs) {
 		stat = -ENOMEM;
 		goto fail;
 	}
-	printk("HW %08x FW %08x\n", ddbreadl(0), ddbreadl(4));
+	printk(KERN_INFO "HW %08x FW %08x\n", ddbreadl(0), ddbreadl(4));
 
 #ifdef CONFIG_PCI_MSI
 	if (pci_msi_enabled())
@@ -1570,9 +1597,9 @@ static int __devinit ddb_probe(struct pci_dev *pdev,
 		dev->msi = 1;
 	}
 #endif
-	if ((stat = request_irq(dev->pdev->irq, irq_handler,
-				irq_flag, "DDBridge",
-				(void *) dev))<0)
+	stat = request_irq(dev->pdev->irq, irq_handler,
+			   irq_flag, "DDBridge", (void *) dev);
+	if (stat < 0)
 		goto fail1;
 	ddbwritel(0, DMA_BASE_WRITE);
 	ddbwritel(0, DMA_BASE_READ);
@@ -1594,18 +1621,18 @@ static int __devinit ddb_probe(struct pci_dev *pdev,
 
 fail3:
 	ddb_ports_detach(dev);
-	printk("fail3\n");
+	printk(KERN_ERR "fail3\n");
 	ddb_ports_release(dev);
 fail2:
-	printk("fail2\n");
+	printk(KERN_ERR "fail2\n");
 	ddb_buffers_free(dev);
 fail1:
-	printk("fail1\n");
+	printk(KERN_ERR "fail1\n");
 	if (dev->msi)
 		pci_disable_msi(dev->pdev);
 	free_irq(dev->pdev->irq, dev);
 fail:
-	printk("fail\n");
+	printk(KERN_ERR "fail\n");
 	ddb_unmap(dev);
 	pci_set_drvdata(pdev, 0);
 	pci_disable_device(pdev);
@@ -1641,7 +1668,7 @@ static struct ddb_info ddb_v6 = {
 
 #define DDVID 0xdd01 /* Digital Devices Vendor ID */
 
-#define DDB_ID(_vend, _dev, _subvend,_subdev,_driverdata) {	\
+#define DDB_ID(_vend, _dev, _subvend, _subdev, _driverdata) {	\
 	.vendor      = _vend,    .device    = _dev, \
 	.subvendor   = _subvend, .subdevice = _subdev, \
 	.driver_data = (unsigned long)&_driverdata }
@@ -1668,7 +1695,7 @@ static struct pci_driver ddb_pci_driver = {
 
 static __init int module_init_ddbridge(void)
 {
-	printk("Digital Devices PCIE bridge driver, "
+	printk(KERN_INFO "Digital Devices PCIE bridge driver, "
 	       "Copyright (C) 2010-11 Digital Devices GmbH\n");
 	if (ddb_class_create())
 		return -1;
diff --git a/drivers/media/dvb/ddbridge/ddbridge-regs.h b/drivers/media/dvb/ddbridge/ddbridge-regs.h
index 0130073..a3ccb31 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-regs.h
+++ b/drivers/media/dvb/ddbridge/ddbridge-regs.h
@@ -21,26 +21,26 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  */
 
-// $Id: DD-DVBBridgeV1.h 273 2010-09-17 05:03:16Z manfred $
+/* DD-DVBBridgeV1.h 273 2010-09-17 05:03:16Z manfred */
 
-// Register Definitions
+/* Register Definitions */
 
 #define CUR_REGISTERMAP_VERSION 0x10000
 
 #define HARDWARE_VERSION       0x00
 #define REGISTERMAP_VERSION    0x04
 
-// --------------------------------------------------------------------------
-// SPI Controller
+/* ------------------------------------------------------------------------- */
+/* SPI Controller */
 
 #define SPI_CONTROL     0x10
 #define SPI_DATA        0x14
 
-// --------------------------------------------------------------------------
+/* ------------------------------------------------------------------------- */
 
-// Interrupt controller
-// How many MSI's are available depends on HW (Min 2 max 8)
-// How many are usable also depends on Host platform
+/* Interrupt controller                                     */
+/* How many MSI's are available depends on HW (Min 2 max 8) */
+/* How many are usable also depends on Host platform        */
 
 #define INTERRUPT_BASE   (0x40)
 
@@ -81,15 +81,15 @@
 #define INTMASK_TSOUTPUT3   (0x00040000)
 #define INTMASK_TSOUTPUT4   (0x00080000)
 
-// --------------------------------------------------------------------------
-// I2C Master Controller
+/* ------------------------------------------------------------------------- */
+/* I2C Master Controller */
 
-#define I2C_BASE        (0x80)  // Byte offset
+#define I2C_BASE        (0x80)  /* Byte offset */
 
 #define I2C_COMMAND     (0x00)
 #define I2C_TIMING      (0x04)
-#define I2C_TASKLENGTH  (0x08)     // High read, low write
-#define I2C_TASKADDRESS (0x0C)     // High read, low write
+#define I2C_TASKLENGTH  (0x08)     /* High read, low write */
+#define I2C_TASKADDRESS (0x0C)     /* High read, low write */
 
 #define I2C_MONITOR     (0x1C)
 
@@ -100,7 +100,7 @@
 
 #define I2C_BASE_N(i)   (I2C_BASE + (i) * 0x20)
 
-#define I2C_TASKMEM_BASE    (0x1000)    // Byte offset
+#define I2C_TASKMEM_BASE    (0x1000)    /* Byte offset */
 #define I2C_TASKMEM_SIZE    (0x1000)
 
 #define I2C_SPEED_400   (0x04030404)
@@ -111,27 +111,27 @@
 #define I2C_SPEED_50    (0x27262727)
 
 
-// --------------------------------------------------------------------------
-// DMA  Controller
+/* ------------------------------------------------------------------------- */
+/* DMA  Controller */
 
 #define DMA_BASE_WRITE        (0x100)
 #define DMA_BASE_READ         (0x140)
 
-#define DMA_CONTROL     (0x00)                  // 64
-#define DMA_ERROR       (0x04)                  // 65 ( only read instance )
-
-#define DMA_DIAG_CONTROL                (0x1C)  // 71
-#define DMA_DIAG_PACKETCOUNTER_LOW      (0x20)  // 72
-#define DMA_DIAG_PACKETCOUNTER_HIGH     (0x24)  // 73
-#define DMA_DIAG_TIMECOUNTER_LOW        (0x28)  // 74
-#define DMA_DIAG_TIMECOUNTER_HIGH       (0x2C)  // 75
-#define DMA_DIAG_RECHECKCOUNTER         (0x30)  // 76  ( Split completions on read )
-#define DMA_DIAG_WAITTIMEOUTINIT        (0x34)  // 77
-#define DMA_DIAG_WAITOVERFLOWCOUNTER    (0x38)  // 78
-#define DMA_DIAG_WAITCOUNTER            (0x3C)  // 79
-
-// --------------------------------------------------------------------------
-// DMA  Buffer
+#define DMA_CONTROL     (0x00)                  /* 64 */
+#define DMA_ERROR       (0x04)                  /* 65 ( only read instance ) */
+
+#define DMA_DIAG_CONTROL                (0x1C)  /* 71 */
+#define DMA_DIAG_PACKETCOUNTER_LOW      (0x20)  /* 72 */
+#define DMA_DIAG_PACKETCOUNTER_HIGH     (0x24)  /* 73 */
+#define DMA_DIAG_TIMECOUNTER_LOW        (0x28)  /* 74 */
+#define DMA_DIAG_TIMECOUNTER_HIGH       (0x2C)  /* 75 */
+#define DMA_DIAG_RECHECKCOUNTER         (0x30)  /* 76  ( Split completions on read ) */
+#define DMA_DIAG_WAITTIMEOUTINIT        (0x34)  /* 77 */
+#define DMA_DIAG_WAITOVERFLOWCOUNTER    (0x38)  /* 78 */
+#define DMA_DIAG_WAITCOUNTER            (0x3C)  /* 79 */
+
+/* ------------------------------------------------------------------------- */
+/* DMA  Buffer */
 
 #define TS_INPUT_BASE       (0x200)
 #define TS_INPUT_CONTROL(i)         (TS_INPUT_BASE + (i) * 16 + 0x00)
diff --git a/drivers/media/dvb/ddbridge/ddbridge.h b/drivers/media/dvb/ddbridge/ddbridge.h
index c836301..6d14893 100644
--- a/drivers/media/dvb/ddbridge/ddbridge.h
+++ b/drivers/media/dvb/ddbridge/ddbridge.h
@@ -177,10 +177,10 @@ struct ddb {
 #define ddbwritel(_val, _adr)        writel((_val), \
 				     (char *) (dev->regs+(_adr)))
 #define ddbreadl(_adr)               readl((char *) (dev->regs+(_adr)))
-#define ddbcpyto(_adr,_src,_count)   memcpy_toio((char *)	\
-				     (dev->regs+(_adr)),(_src),(_count))
-#define ddbcpyfrom(_dst,_adr,_count) memcpy_fromio((_dst),(char *) \
-				     (dev->regs+(_adr)),(_count))
+#define ddbcpyto(_adr, _src, _count) memcpy_toio((char *)	\
+				     (dev->regs+(_adr)), (_src), (_count))
+#define ddbcpyfrom(_dst, _adr, _count) memcpy_fromio((_dst), (char *) \
+				       (dev->regs+(_adr)), (_count))
 
 /****************************************************************************/
 
-- 
1.7.4.1

