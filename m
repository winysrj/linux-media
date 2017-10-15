Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37294 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751343AbdJOUwD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 16:52:03 -0400
Received: by mail-wm0-f67.google.com with SMTP id r68so6159621wmr.4
        for <linux-media@vger.kernel.org>; Sun, 15 Oct 2017 13:52:02 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 2/8] [media] ddbridge: fixup checkpatch-strict issues
Date: Sun, 15 Oct 2017 22:51:51 +0200
Message-Id: <20171015205157.14342-3-d.scheller.oss@gmail.com>
In-Reply-To: <20171015205157.14342-1-d.scheller.oss@gmail.com>
References: <20171015205157.14342-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fixes several alignment, braces, space-before-cast, camelcase et al issues
reported by checkpatch --strict, plus a few more checkpatch didn't report.

Three checks are left after this though:
- one CamelCase in ddbridge-core, related to defines/vars/enums referenced
  from the stv090x demod driver
- one macro argument reuse in ddbridge-core aswell
- one unbalanced braces around else in ddbridge-main, which is due to
  #ifdefs related to CONFIG_PCI_MSI, which preferrably should be kept
  as-is for readability.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c  | 131 ++++++++++++++--------------
 drivers/media/pci/ddbridge/ddbridge-hw.c    |   8 +-
 drivers/media/pci/ddbridge/ddbridge-i2c.c   |  16 ++--
 drivers/media/pci/ddbridge/ddbridge-main.c  |  23 ++---
 drivers/media/pci/ddbridge/ddbridge-maxs8.c |  44 ++++++----
 drivers/media/pci/ddbridge/ddbridge-regs.h  |  32 +++----
 drivers/media/pci/ddbridge/ddbridge.h       |  89 ++++++++++---------
 7 files changed, 179 insertions(+), 164 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 653e7986923c..0eaa2efdcc54 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -112,7 +112,6 @@ static void ddb_set_dma_tables(struct ddb *dev)
 	}
 }
 
-
 /****************************************************************************/
 /****************************************************************************/
 /****************************************************************************/
@@ -210,8 +209,9 @@ static int ddb_redirect(u32 i, u32 p)
 		if (input->redi) {
 			input2->redi = input->redi;
 			input->redi = NULL;
-		} else
+		} else {
 			input2->redi = input;
+		}
 	}
 	input->redo = port->output;
 	port->output->redi = input;
@@ -357,9 +357,9 @@ static void calc_con(struct ddb_output *output, u32 *con, u32 *con2, u32 flags)
 				max_bitrate = 0;
 				gap = 0;
 				if (bitrate != 72000) {
-					if (bitrate >= 96000)
+					if (bitrate >= 96000) {
 						*con |= 0x800;
-					else {
+					} else {
 						*con |= 0x1000;
 						nco = (bitrate * 8192 + 71999)
 							/ 72000;
@@ -506,7 +506,6 @@ static void ddb_input_start(struct ddb_input *input)
 	}
 }
 
-
 static void ddb_input_start_all(struct ddb_input *input)
 {
 	struct ddb_input *i = input;
@@ -572,7 +571,7 @@ static ssize_t ddb_output_write(struct ddb_output *output,
 	while (left) {
 		len = output->dma->size - output->dma->coff;
 		if ((((output->dma->cbuf + 1) % output->dma->num) == idx) &&
-		    (off == 0)) {
+		    off == 0) {
 			if (len <= 188)
 				break;
 			len -= 188;
@@ -593,7 +592,8 @@ static ssize_t ddb_output_write(struct ddb_output *output,
 				   buf, len))
 			return -EIO;
 		if (alt_dma)
-			dma_sync_single_for_device(dev->dev,
+			dma_sync_single_for_device(
+				dev->dev,
 				output->dma->pbuf[output->dma->cbuf],
 				output->dma->size, DMA_TO_DEVICE);
 		left -= len;
@@ -632,7 +632,7 @@ static u32 ddb_input_avail(struct ddb_input *input)
 }
 
 static ssize_t ddb_input_read(struct ddb_input *input,
-		__user u8 *buf, size_t count)
+			      __user u8 *buf, size_t count)
 {
 	struct ddb *dev = input->port->dev;
 	u32 left = count;
@@ -648,7 +648,8 @@ static ssize_t ddb_input_read(struct ddb_input *input,
 		if (free > left)
 			free = left;
 		if (alt_dma)
-			dma_sync_single_for_cpu(dev->dev,
+			dma_sync_single_for_cpu(
+				dev->dev,
 				input->dma->pbuf[input->dma->cbuf],
 				input->dma->size, DMA_FROM_DEVICE);
 		ret = copy_to_user(buf, input->dma->vbuf[input->dma->cbuf] +
@@ -792,8 +793,10 @@ static int ts_open(struct inode *inode, struct file *file)
 	} else if ((file->f_flags & O_ACCMODE) == O_WRONLY) {
 		if (!output)
 			return -EINVAL;
-	} else
+	} else {
 		return -EINVAL;
+	}
+
 	err = dvb_generic_open(inode, file);
 	if (err < 0)
 		return err;
@@ -822,7 +825,6 @@ static struct dvb_device dvbdev_ci = {
 	.fops    = &ci_fops,
 };
 
-
 /****************************************************************************/
 /****************************************************************************/
 
@@ -914,7 +916,7 @@ static int demod_attach_stv0367(struct ddb_input *input)
 
 	/* attach frontend */
 	dvb->fe = dvb_attach(stv0367ddb_attach,
-		&ddb_stv0367_config[(input->nr & 1)], i2c);
+			     &ddb_stv0367_config[(input->nr & 1)], i2c);
 
 	if (!dvb->fe) {
 		dev_err(dev, "No stv0367 found!\n");
@@ -1017,7 +1019,7 @@ static int tuner_attach_tda18212(struct ddb_input *input, u32 porttype)
 
 	/* perform tuner init/attach */
 	client = i2c_new_device(adapter, &board_info);
-	if (client == NULL || client->dev.driver == NULL)
+	if (!client || !client->dev.driver)
 		goto err;
 
 	if (!try_module_get(client->dev.driver->owner)) {
@@ -1132,7 +1134,7 @@ static int tuner_attach_stv6110(struct ddb_input *input, int type)
 		return -ENODEV;
 	}
 	dev_info(dev, "attach tuner input %d adr %02x\n",
-		input->nr, tunerconf->addr);
+		 input->nr, tunerconf->addr);
 
 	feconf->tuner_init          = ctl->tuner_init;
 	feconf->tuner_sleep         = ctl->tuner_sleep;
@@ -1262,7 +1264,8 @@ static void dvb_input_detach(struct ddb_input *input)
 			dvb_frontend_detach(dvb->fe2);
 		if (dvb->fe)
 			dvb_frontend_detach(dvb->fe);
-		dvb->fe = dvb->fe2 = NULL;
+		dvb->fe = NULL;
+		dvb->fe2 = NULL;
 		/* fallthrough */
 	case 0x20:
 		client = dvb->i2c_client[0];
@@ -1406,7 +1409,8 @@ static int dvb_input_attach(struct ddb_input *input)
 		DMX_SECTION_FILTERING | DMX_MEMORY_BASED_FILTERING;
 	dvbdemux->start_feed = start_feed;
 	dvbdemux->stop_feed = stop_feed;
-	dvbdemux->filternum = dvbdemux->feednum = 256;
+	dvbdemux->filternum = 256;
+	dvbdemux->feednum = 256;
 	ret = dvb_dmx_init(dvbdemux);
 	if (ret < 0)
 		return ret;
@@ -1433,7 +1437,8 @@ static int dvb_input_attach(struct ddb_input *input)
 		return ret;
 	dvb->attached = 0x20;
 
-	dvb->fe = dvb->fe2 = NULL;
+	dvb->fe = NULL;
+	dvb->fe2 = NULL;
 	switch (port->type) {
 	case DDB_TUNER_MXL5XX:
 		if (fe_attach_mxl5xx(input) < 0)
@@ -1700,11 +1705,11 @@ static int init_xo2_ci(struct ddb_port *port)
 
 	if (data[0] > 1)  {
 		dev_info(dev->dev, "Port %d: invalid XO2 CI %02x\n",
-			port->nr, data[0]);
+			 port->nr, data[0]);
 		return -1;
 	}
 	dev_info(dev->dev, "Port %d: DuoFlex CI %u.%u\n",
-		port->nr, data[0], data[1]);
+		 port->nr, data[0], data[1]);
 
 	i2c_read_reg(i2c, 0x10, 0x08, &val);
 	if (val != 0) {
@@ -1715,7 +1720,6 @@ static int init_xo2_ci(struct ddb_port *port)
 	i2c_write_reg(i2c, 0x10, 0x08, 3);
 	usleep_range(2000, 3000);
 
-
 	/* speed: 0=55,1=75,2=90,3=104 MBit/s */
 	i2c_write_reg(i2c, 0x10, 0x09, 1);
 
@@ -1818,7 +1822,7 @@ static void ddb_port_probe(struct ddb_port *port)
 				  port->i2c->regs + I2C_TIMING);
 		} else {
 			dev_info(dev->dev, "Port %d: Uninitialized DuoFlex\n",
-			       port->nr);
+				 port->nr);
 			return;
 		}
 	} else if (port_has_xo2(port, &type, &id)) {
@@ -1909,7 +1913,6 @@ static void ddb_port_probe(struct ddb_port *port)
 	}
 }
 
-
 /****************************************************************************/
 /****************************************************************************/
 /****************************************************************************/
@@ -1999,7 +2002,7 @@ static int slot_reset(struct dvb_ca_en50221 *ca, int slot)
 		  CI_CONTROL(ci->nr));
 	ddbwritel(ci->port->dev, CI_ENABLE | CI_POWER_ON | CI_RESET_CAM,
 		  CI_CONTROL(ci->nr));
-	udelay(20);
+	usleep_range(20, 25);
 	ddbwritel(ci->port->dev, CI_ENABLE | CI_POWER_ON,
 		  CI_CONTROL(ci->nr));
 	return 0;
@@ -2264,7 +2267,7 @@ static int ddb_port_attach(struct ddb_port *port)
 	case DDB_PORT_LOOP:
 		ret = dvb_register_device(port->dvb[0].adap,
 					  &port->dvb[0].dev,
-					  &dvbdev_ci, (void *) port->output,
+					  &dvbdev_ci, (void *)port->output,
 					  DVB_DEVICE_SEC, 0);
 		break;
 	default:
@@ -2323,7 +2326,6 @@ void ddb_ports_detach(struct ddb *dev)
 	dvb_unregister_adapters(dev);
 }
 
-
 /* Copy input DMA pointers to output DMA and ACK. */
 
 static void input_write_output(struct ddb_input *input,
@@ -2350,16 +2352,18 @@ static void input_write_dvb(struct ddb_input *input,
 	struct ddb *dev = input->port->dev;
 	int ack = 1;
 
-	dma = dma2 = input->dma;
-	/* if there also is an output connected, do not ACK.
+	dma = input->dma;
+	dma2 = input->dma;
+	/*
+	 * if there also is an output connected, do not ACK.
 	 * input_write_output will ACK.
 	 */
 	if (input->redo) {
 		dma2 = input->redo->dma;
 		ack = 0;
 	}
-	while (dma->cbuf != ((dma->stat >> 11) & 0x1f)
-	       || (4 & dma->ctrl)) {
+	while (dma->cbuf != ((dma->stat >> 11) & 0x1f) ||
+	       (4 & dma->ctrl)) {
 		if (4 & dma->ctrl) {
 			/* dev_err(dev->dev, "Overflow dma %d\n", dma->nr); */
 			ack = 1;
@@ -2382,7 +2386,7 @@ static void input_write_dvb(struct ddb_input *input,
 static void input_work(struct work_struct *work)
 {
 	struct ddb_dma *dma = container_of(work, struct ddb_dma, work);
-	struct ddb_input *input = (struct ddb_input *) dma->io;
+	struct ddb_input *input = (struct ddb_input *)dma->io;
 	struct ddb *dev = input->port->dev;
 	unsigned long flags;
 
@@ -2404,11 +2408,11 @@ static void input_work(struct work_struct *work)
 
 static void input_handler(unsigned long data)
 {
-	struct ddb_input *input = (struct ddb_input *) data;
+	struct ddb_input *input = (struct ddb_input *)data;
 	struct ddb_dma *dma = input->dma;
 
-
-	/* If there is no input connected, input_tasklet() will
+	/*
+	 * If there is no input connected, input_tasklet() will
 	 * just copy pointers and ACK. So, there is no need to go
 	 * through the tasklet scheduler.
 	 */
@@ -2420,7 +2424,7 @@ static void input_handler(unsigned long data)
 
 static void output_handler(unsigned long data)
 {
-	struct ddb_output *output = (struct ddb_output *) data;
+	struct ddb_output *output = (struct ddb_output *)data;
 	struct ddb_dma *dma = output->dma;
 	struct ddb *dev = output->port->dev;
 
@@ -2509,10 +2513,10 @@ static void ddb_input_init(struct ddb_port *port, int nr, int pnr, int anr)
 			dma_nr += 32 + (port->lnr - 1) * 8;
 
 		dev_dbg(dev->dev, "init link %u, input %u, handler %u\n",
-			 port->lnr, nr, dma_nr + base);
+			port->lnr, nr, dma_nr + base);
 
 		dev->handler[0][dma_nr + base] = input_handler;
-		dev->handler_data[0][dma_nr + base] = (unsigned long) input;
+		dev->handler_data[0][dma_nr + base] = (unsigned long)input;
 		ddb_dma_init(input, dma_nr, 0);
 	}
 }
@@ -2531,14 +2535,14 @@ static void ddb_output_init(struct ddb_port *port, int nr)
 		(rm->output->base + rm->output->size * nr);
 
 	dev_dbg(dev->dev, "init link %u, output %u, regs %08x\n",
-		 port->lnr, nr, output->regs);
+		port->lnr, nr, output->regs);
 
 	if (dev->has_dma) {
 		const struct ddb_regmap *rm0 = io_regmap(output, 0);
 		u32 base = rm0->irq_base_odma;
 
 		dev->handler[0][nr + base] = output_handler;
-		dev->handler_data[0][nr + base] = (unsigned long) output;
+		dev->handler_data[0][nr + base] = (unsigned long)output;
 		ddb_dma_init(output, nr, 1);
 	}
 }
@@ -2606,7 +2610,7 @@ void ddb_ports_init(struct ddb *dev)
 			port->dvb[0].adap = &dev->adap[2 * p];
 			port->dvb[1].adap = &dev->adap[2 * p + 1];
 
-			if ((port->class == DDB_PORT_NONE) && i && p &&
+			if (port->class == DDB_PORT_NONE && i && p &&
 			    dev->port[p - 1].type == DDB_CI_EXTERNAL_XO2) {
 				port->class = DDB_PORT_CI;
 				port->type = DDB_CI_EXTERNAL_XO2_B;
@@ -2615,8 +2619,8 @@ void ddb_ports_init(struct ddb *dev)
 			}
 
 			dev_info(dev->dev, "Port %u: Link %u, Link Port %u (TAB %u): %s\n",
-				port->pnr, port->lnr, port->nr, port->nr + 1,
-				port->name);
+				 port->pnr, port->lnr, port->nr, port->nr + 1,
+				 port->name);
 
 			if (port->class == DDB_PORT_CI &&
 			    port->type == DDB_CI_EXTERNAL_XO2) {
@@ -2738,7 +2742,7 @@ static void irq_handle_io(struct ddb *dev, u32 s)
 
 irqreturn_t ddb_irq_handler0(int irq, void *dev_id)
 {
-	struct ddb *dev = (struct ddb *) dev_id;
+	struct ddb *dev = (struct ddb *)dev_id;
 	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
 
 	do {
@@ -2755,7 +2759,7 @@ irqreturn_t ddb_irq_handler0(int irq, void *dev_id)
 
 irqreturn_t ddb_irq_handler1(int irq, void *dev_id)
 {
-	struct ddb *dev = (struct ddb *) dev_id;
+	struct ddb *dev = (struct ddb *)dev_id;
 	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
 
 	do {
@@ -2772,7 +2776,7 @@ irqreturn_t ddb_irq_handler1(int irq, void *dev_id)
 
 irqreturn_t ddb_irq_handler(int irq, void *dev_id)
 {
-	struct ddb *dev = (struct ddb *) dev_id;
+	struct ddb *dev = (struct ddb *)dev_id;
 	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
 	int ret = IRQ_HANDLED;
 
@@ -2809,7 +2813,7 @@ static int reg_wait(struct ddb *dev, u32 reg, u32 bit)
 }
 
 static int flashio(struct ddb *dev, u32 lnr, u8 *wbuf, u32 wlen, u8 *rbuf,
-	u32 rlen)
+		   u32 rlen)
 {
 	u32 data, shift;
 	u32 tag = DDB_LINK_TAG(lnr);
@@ -2820,7 +2824,7 @@ static int flashio(struct ddb *dev, u32 lnr, u8 *wbuf, u32 wlen, u8 *rbuf,
 		ddbwritel(dev, 1, tag | SPI_CONTROL);
 	while (wlen > 4) {
 		/* FIXME: check for big-endian */
-		data = swab32(*(u32 *) wbuf);
+		data = swab32(*(u32 *)wbuf);
 		wbuf += 4;
 		wlen -= 4;
 		ddbwritel(dev, data, tag | SPI_DATA);
@@ -2860,12 +2864,12 @@ static int flashio(struct ddb *dev, u32 lnr, u8 *wbuf, u32 wlen, u8 *rbuf,
 		if (reg_wait(dev, tag | SPI_CONTROL, 4))
 			goto fail;
 		data = ddbreadl(dev, tag | SPI_DATA);
-		*(u32 *) rbuf = swab32(data);
+		*(u32 *)rbuf = swab32(data);
 		rbuf += 4;
 		rlen -= 4;
 	}
 	ddbwritel(dev, 0x0003 | ((rlen << (8 + 3)) & 0x1F00),
-		tag | SPI_CONTROL);
+		  tag | SPI_CONTROL);
 	ddbwritel(dev, 0xffffffff, tag | SPI_DATA);
 	if (reg_wait(dev, tag | SPI_CONTROL, 4))
 		goto fail;
@@ -3008,7 +3012,7 @@ static ssize_t fan_store(struct device *device, struct device_attribute *d,
 }
 
 static ssize_t fanspeed_show(struct device *device,
-			struct device_attribute *attr, char *buf)
+			     struct device_attribute *attr, char *buf)
 {
 	struct ddb *dev = dev_get_drvdata(device);
 	int num = attr->attr.name[8] - 0x30;
@@ -3046,7 +3050,7 @@ static ssize_t temp_show(struct device *device,
 }
 
 static ssize_t ctemp_show(struct device *device,
-		struct device_attribute *attr, char *buf)
+			  struct device_attribute *attr, char *buf)
 {
 	struct ddb *dev = dev_get_drvdata(device);
 	struct i2c_adapter *adap;
@@ -3073,7 +3077,6 @@ static ssize_t led_show(struct device *device,
 	return sprintf(buf, "%d\n", dev->leds & (1 << num) ? 1 : 0);
 }
 
-
 static void ddb_set_led(struct ddb *dev, int num, int val)
 {
 	if (!dev->link[0].info->led_num)
@@ -3160,7 +3163,7 @@ static ssize_t bsnr_show(struct device *device,
 }
 
 static ssize_t bpsnr_show(struct device *device,
-			 struct device_attribute *attr, char *buf)
+			  struct device_attribute *attr, char *buf)
 {
 	struct ddb *dev = dev_get_drvdata(device);
 	unsigned char snr[32];
@@ -3205,7 +3208,6 @@ static ssize_t gap_show(struct device *device,
 	int num = attr->attr.name[3] - 0x30;
 
 	return sprintf(buf, "%d\n", dev->port[num].gap);
-
 }
 
 static ssize_t gap_store(struct device *device, struct device_attribute *attr,
@@ -3251,7 +3253,7 @@ static ssize_t regmap_show(struct device *device,
 }
 
 static ssize_t fmode_show(struct device *device,
-			 struct device_attribute *attr, char *buf)
+			  struct device_attribute *attr, char *buf)
 {
 	int num = attr->attr.name[5] - 0x30;
 	struct ddb *dev = dev_get_drvdata(device);
@@ -3269,7 +3271,7 @@ static ssize_t devid_show(struct device *device,
 }
 
 static ssize_t fmode_store(struct device *device, struct device_attribute *attr,
-			  const char *buf, size_t count)
+			   const char *buf, size_t count)
 {
 	struct ddb *dev = dev_get_drvdata(device);
 	int num = attr->attr.name[5] - 0x30;
@@ -3384,7 +3386,7 @@ static void ddb_device_attrs_del(struct ddb *dev)
 		device_remove_file(dev->ddb_dev, &ddb_attrs_snr[i]);
 		device_remove_file(dev->ddb_dev, &ddb_attrs_ctemp[i]);
 	}
-	for (i = 0; ddb_attrs[i].attr.name != NULL; i++)
+	for (i = 0; ddb_attrs[i].attr.name; i++)
 		device_remove_file(dev->ddb_dev, &ddb_attrs[i]);
 }
 
@@ -3392,7 +3394,7 @@ static int ddb_device_attrs_add(struct ddb *dev)
 {
 	int i;
 
-	for (i = 0; ddb_attrs[i].attr.name != NULL; i++)
+	for (i = 0; ddb_attrs[i].attr.name; i++)
 		if (device_create_file(dev->ddb_dev, &ddb_attrs[i]))
 			goto fail;
 	for (i = 0; i < dev->link[0].info->temp_num; i++)
@@ -3444,8 +3446,9 @@ int ddb_device_create(struct ddb *dev)
 		device_destroy(&ddb_class, MKDEV(ddb_major, dev->nr));
 		ddbs[dev->nr] = NULL;
 		dev->ddb_dev = ERR_PTR(-ENODEV);
-	} else
+	} else {
 		ddb_num++;
+	}
 fail:
 	mutex_unlock(&ddb_mutex);
 	return res;
@@ -3497,7 +3500,7 @@ static void tempmon_setfan(struct ddb_link *link)
 
 static void temp_handler(unsigned long data)
 {
-	struct ddb_link *link = (struct ddb_link *) data;
+	struct ddb_link *link = (struct ddb_link *)data;
 
 	spin_lock(&link->temp_lock);
 	tempmon_setfan(link);
@@ -3516,10 +3519,10 @@ static int tempmon_init(struct ddb_link *link, int first_time)
 			30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80 };
 
 		memcpy(link->temp_tab, temperature_table,
-			sizeof(temperature_table));
+		       sizeof(temperature_table));
 	}
 	dev->handler[l][link->info->tempmon_irq] = temp_handler;
-	dev->handler_data[l][link->info->tempmon_irq] = (unsigned long) link;
+	dev->handler_data[l][link->info->tempmon_irq] = (unsigned long)link;
 	ddblwritel(link, (TEMPMON_CONTROL_OVERTEMP | TEMPMON_CONTROL_AUTOSCAN |
 			  TEMPMON_CONTROL_INTENABLE),
 		   TEMPMON_CONTROL);
@@ -3571,11 +3574,11 @@ static int ddb_init_boards(struct ddb *dev)
 			ddbwritel(dev, 0, DDB_LINK_TAG(l) | BOARD_CONTROL);
 			msleep(100);
 			ddbwritel(dev, info->board_control_2,
-				DDB_LINK_TAG(l) | BOARD_CONTROL);
+				  DDB_LINK_TAG(l) | BOARD_CONTROL);
 			usleep_range(2000, 3000);
 			ddbwritel(dev,
-				info->board_control_2 | info->board_control,
-				DDB_LINK_TAG(l) | BOARD_CONTROL);
+				  info->board_control_2 | info->board_control,
+				  DDB_LINK_TAG(l) | BOARD_CONTROL);
 			usleep_range(2000, 3000);
 		}
 		ddb_init_tempmon(link);
diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.c b/drivers/media/pci/ddbridge/ddbridge-hw.c
index 48248bcd59c2..c6d14925e2fc 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.c
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.c
@@ -185,7 +185,7 @@ static const struct ddb_info ddb_ctv7 = {
 	.board_control_2 = 4,
 };
 
-static const struct ddb_info ddb_satixS2v3 = {
+static const struct ddb_info ddb_satixs2v3 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Mystique SaTiX-S2 V3 DVB adapter",
 	.regmap   = &octopus_map,
@@ -336,7 +336,7 @@ static const struct ddb_device_id ddb_device_ids[] = {
 	DDB_DEVID(0x0006, 0x0022, ddb_v7),
 	DDB_DEVID(0x0006, 0x0024, ddb_v7a),
 	DDB_DEVID(0x0003, 0x0030, ddb_dvbct),
-	DDB_DEVID(0x0003, 0xdb03, ddb_satixS2v3),
+	DDB_DEVID(0x0003, 0xdb03, ddb_satixs2v3),
 	DDB_DEVID(0x0006, 0x0031, ddb_ctv7),
 	DDB_DEVID(0x0006, 0x0032, ddb_ctv7),
 	DDB_DEVID(0x0006, 0x0033, ddb_ctv7),
@@ -367,8 +367,8 @@ const struct ddb_info *get_ddb_info(u16 vendor, u16 device,
 		if (vendor == id->vendor &&
 		    device == id->device &&
 		    subvendor == id->subvendor &&
-		    ((subdevice == id->subdevice) ||
-		     (id->subdevice == 0xffff)))
+		    (subdevice == id->subdevice ||
+		     id->subdevice == 0xffff))
 			return id->info;
 	}
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
index e4d39c3270ae..82a9a0e806fc 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.c
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -81,7 +81,7 @@ static int ddb_i2c_cmd(struct ddb_i2c *i2c, u32 adr, u32 cmd)
 static int ddb_i2c_master_xfer(struct i2c_adapter *adapter,
 			       struct i2c_msg msg[], int num)
 {
-	struct ddb_i2c *i2c = (struct ddb_i2c *) i2c_get_adapdata(adapter);
+	struct ddb_i2c *i2c = (struct ddb_i2c *)i2c_get_adapdata(adapter);
 	struct ddb *dev = i2c->dev;
 	u8 addr = 0;
 
@@ -149,7 +149,7 @@ void ddb_i2c_release(struct ddb *dev)
 
 static void i2c_handler(unsigned long priv)
 {
-	struct ddb_i2c *i2c = (struct ddb_i2c *) priv;
+	struct ddb_i2c *i2c = (struct ddb_i2c *)priv;
 
 	complete(&i2c->completion);
 }
@@ -171,20 +171,20 @@ static int ddb_i2c_add(struct ddb *dev, struct ddb_i2c *i2c,
 		(regmap->i2c->base + regmap->i2c->size * i);
 	ddbwritel(dev, I2C_SPEED_100, i2c->regs + I2C_TIMING);
 	ddbwritel(dev, ((i2c->rbuf & 0xffff) << 16) | (i2c->wbuf & 0xffff),
-		i2c->regs + I2C_TASKADDRESS);
+		  i2c->regs + I2C_TASKADDRESS);
 	init_completion(&i2c->completion);
 
 	adap = &i2c->adap;
 	i2c_set_adapdata(adap, i2c);
 #ifdef I2C_ADAP_CLASS_TV_DIGITAL
-	adap->class = I2C_ADAP_CLASS_TV_DIGITAL|I2C_CLASS_TV_ANALOG;
+	adap->class = I2C_ADAP_CLASS_TV_DIGITAL | I2C_CLASS_TV_ANALOG;
 #else
 #ifdef I2C_CLASS_TV_ANALOG
 	adap->class = I2C_CLASS_TV_ANALOG;
 #endif
 #endif
 	snprintf(adap->name, I2C_NAME_SIZE, "ddbridge_%02x.%x.%x",
-		dev->nr, i2c->link, i);
+		 dev->nr, i2c->link, i);
 	adap->algo = &ddb_i2c_algo;
 	adap->algo_data = (void *)i2c;
 	adap->dev.parent = dev->dev;
@@ -210,7 +210,7 @@ int ddb_i2c_init(struct ddb *dev)
 			if (!(dev->link[l].info->i2c_mask & (1 << i)))
 				continue;
 			i2c = &dev->i2c[num];
-			dev->handler_data[l][i + base] = (unsigned long) i2c;
+			dev->handler_data[l][i + base] = (unsigned long)i2c;
 			dev->handler[l][i + base] = i2c_handler;
 			stat = ddb_i2c_add(dev, i2c, regmap, l, i, num);
 			if (stat)
@@ -224,7 +224,9 @@ int ddb_i2c_init(struct ddb *dev)
 			adap = &i2c->adap;
 			i2c_del_adapter(adap);
 		}
-	} else
+	} else {
 		dev->i2c_num = num;
+	}
+
 	return stat;
 }
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index ccac7fe31336..26497d6b1395 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -107,7 +107,7 @@ static void ddb_irq_exit(struct ddb *dev)
 
 static void ddb_remove(struct pci_dev *pdev)
 {
-	struct ddb *dev = (struct ddb *) pci_get_drvdata(pdev);
+	struct ddb *dev = (struct ddb *)pci_get_drvdata(pdev);
 
 	ddb_device_destroy(dev);
 	ddb_ports_detach(dev);
@@ -132,9 +132,10 @@ static void ddb_irq_msi(struct ddb *dev, int nr)
 		if (stat >= 1) {
 			dev->msi = stat;
 			dev_info(dev->dev, "using %d MSI interrupt(s)\n",
-				dev->msi);
-		} else
+				 dev->msi);
+		} else {
 			dev_info(dev->dev, "MSI not available.\n");
+		}
 	}
 }
 #endif
@@ -160,11 +161,11 @@ static int ddb_irq_init(struct ddb *dev)
 		irq_flag = 0;
 	if (dev->msi == 2) {
 		stat = request_irq(dev->pdev->irq, ddb_irq_handler0,
-				   irq_flag, "ddbridge", (void *) dev);
+				   irq_flag, "ddbridge", (void *)dev);
 		if (stat < 0)
 			return stat;
 		stat = request_irq(dev->pdev->irq + 1, ddb_irq_handler1,
-				   irq_flag, "ddbridge", (void *) dev);
+				   irq_flag, "ddbridge", (void *)dev);
 		if (stat < 0) {
 			free_irq(dev->pdev->irq, dev);
 			return stat;
@@ -173,7 +174,7 @@ static int ddb_irq_init(struct ddb *dev)
 #endif
 	{
 		stat = request_irq(dev->pdev->irq, ddb_irq_handler,
-				   irq_flag, "ddbridge", (void *) dev);
+				   irq_flag, "ddbridge", (void *)dev);
 		if (stat < 0)
 			return stat;
 	}
@@ -188,7 +189,7 @@ static int ddb_irq_init(struct ddb *dev)
 }
 
 static int ddb_probe(struct pci_dev *pdev,
-			       const struct pci_device_id *id)
+		     const struct pci_device_id *id)
 {
 	struct ddb *dev;
 	int stat = 0;
@@ -202,8 +203,8 @@ static int ddb_probe(struct pci_dev *pdev,
 		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
 			return -ENODEV;
 
-	dev = vzalloc(sizeof(struct ddb));
-	if (dev == NULL)
+	dev = vzalloc(sizeof(*dev));
+	if (!dev)
 		return -ENOMEM;
 
 	mutex_init(&dev->mutex);
@@ -242,7 +243,7 @@ static int ddb_probe(struct pci_dev *pdev,
 	dev->link[0].ids.regmapid = ddbreadl(dev, 4);
 
 	dev_info(&pdev->dev, "HW %08x REGMAP %08x\n",
-		dev->link[0].ids.hwid, dev->link[0].ids.regmapid);
+		 dev->link[0].ids.hwid, dev->link[0].ids.regmapid);
 
 	ddbwritel(dev, 0, DMA_BASE_READ);
 	ddbwritel(dev, 0, DMA_BASE_WRITE);
@@ -317,7 +318,7 @@ static __init int module_init_ddbridge(void)
 	if (ddb_class_create() < 0)
 		return -1;
 	ddb_wq = create_workqueue("ddbridge");
-	if (ddb_wq == NULL)
+	if (!ddb_wq)
 		goto exit1;
 	stat = pci_register_driver(&ddb_pci_driver);
 	if (stat < 0)
diff --git a/drivers/media/pci/ddbridge/ddbridge-maxs8.c b/drivers/media/pci/ddbridge/ddbridge-maxs8.c
index f8a53bc7c86c..06d57a4772fa 100644
--- a/drivers/media/pci/ddbridge/ddbridge-maxs8.c
+++ b/drivers/media/pci/ddbridge/ddbridge-maxs8.c
@@ -68,7 +68,7 @@ static int lnb_command(struct ddb *dev, u32 link, u32 lnb, u32 cmd)
 	}
 	if (c == 10)
 		dev_info(dev->dev, "%s lnb = %08x  cmd = %08x\n",
-			__func__, lnb, cmd);
+			 __func__, lnb, cmd);
 	return 0;
 }
 
@@ -123,7 +123,7 @@ static int lnb_set_sat(struct ddb *dev, u32 link, u32 input, u32 sat, u32 band,
 }
 
 static int lnb_set_tone(struct ddb *dev, u32 link, u32 input,
-	enum fe_sec_tone_mode tone)
+			enum fe_sec_tone_mode tone)
 {
 	int s = 0;
 	u32 mask = (1ULL << input);
@@ -149,7 +149,7 @@ static int lnb_set_tone(struct ddb *dev, u32 link, u32 input,
 }
 
 static int lnb_set_voltage(struct ddb *dev, u32 link, u32 input,
-	enum fe_sec_voltage voltage)
+			   enum fe_sec_voltage voltage)
 {
 	int s = 0;
 
@@ -291,34 +291,45 @@ static int max_set_voltage(struct dvb_frontend *fe, enum fe_sec_voltage voltage)
 
 		if (nv != ov) {
 			if (nv) {
-				lnb_set_voltage(dev,
-					port->lnr, 0, SEC_VOLTAGE_13);
+				lnb_set_voltage(
+					dev, port->lnr,
+					0, SEC_VOLTAGE_13);
 				if (fmode == 1) {
-					lnb_set_voltage(dev, port->lnr,
+					lnb_set_voltage(
+						dev, port->lnr,
 						0, SEC_VOLTAGE_13);
 					if (old_quattro) {
-						lnb_set_voltage(dev, port->lnr,
+						lnb_set_voltage(
+							dev, port->lnr,
 							1, SEC_VOLTAGE_18);
-						lnb_set_voltage(dev, port->lnr,
+						lnb_set_voltage(
+							dev, port->lnr,
 							2, SEC_VOLTAGE_13);
 					} else {
-						lnb_set_voltage(dev, port->lnr,
+						lnb_set_voltage(
+							dev, port->lnr,
 							1, SEC_VOLTAGE_13);
-						lnb_set_voltage(dev, port->lnr,
+						lnb_set_voltage(
+							dev, port->lnr,
 							2, SEC_VOLTAGE_18);
 					}
-					lnb_set_voltage(dev, port->lnr,
+					lnb_set_voltage(
+						dev, port->lnr,
 						3, SEC_VOLTAGE_18);
 				}
 			} else {
-				lnb_set_voltage(dev, port->lnr,
+				lnb_set_voltage(
+					dev, port->lnr,
 					0, SEC_VOLTAGE_OFF);
 				if (fmode == 1) {
-					lnb_set_voltage(dev, port->lnr,
+					lnb_set_voltage(
+						dev, port->lnr,
 						1, SEC_VOLTAGE_OFF);
-					lnb_set_voltage(dev, port->lnr,
+					lnb_set_voltage(
+						dev, port->lnr,
 						2, SEC_VOLTAGE_OFF);
-					lnb_set_voltage(dev, port->lnr,
+					lnb_set_voltage(
+						dev, port->lnr,
 						3, SEC_VOLTAGE_OFF);
 				}
 			}
@@ -331,7 +342,6 @@ static int max_set_voltage(struct dvb_frontend *fe, enum fe_sec_voltage voltage)
 
 static int max_enable_high_lnb_voltage(struct dvb_frontend *fe, long arg)
 {
-
 	return 0;
 }
 
@@ -414,7 +424,7 @@ int fe_attach_mxl5xx(struct ddb_input *input)
 		tuner = 0;
 
 	dvb->fe = dvb_attach(mxl5xx_attach, i2c, &cfg,
-		demod, tuner, &dvb->set_input);
+			     demod, tuner, &dvb->set_input);
 
 	if (!dvb->fe) {
 		dev_err(dev->dev, "No MXL5XX found!\n");
diff --git a/drivers/media/pci/ddbridge/ddbridge-regs.h b/drivers/media/pci/ddbridge/ddbridge-regs.h
index 9d44f8d3af75..23d74ff83fe4 100644
--- a/drivers/media/pci/ddbridge/ddbridge-regs.h
+++ b/drivers/media/pci/ddbridge/ddbridge-regs.h
@@ -95,27 +95,27 @@
 #define DMA_BASE_WRITE        (0x100)
 #define DMA_BASE_READ         (0x140)
 
-#define TS_CONTROL(_io)         (_io->regs + 0x00)
-#define TS_CONTROL2(_io)        (_io->regs + 0x04)
+#define TS_CONTROL(_io)         ((_io)->regs + 0x00)
+#define TS_CONTROL2(_io)        ((_io)->regs + 0x04)
 
 /* ------------------------------------------------------------------------- */
 /* DMA  Buffer */
 
-#define DMA_BUFFER_CONTROL(_dma)       (_dma->regs + 0x00)
-#define DMA_BUFFER_ACK(_dma)           (_dma->regs + 0x04)
-#define DMA_BUFFER_CURRENT(_dma)       (_dma->regs + 0x08)
-#define DMA_BUFFER_SIZE(_dma)          (_dma->regs + 0x0c)
+#define DMA_BUFFER_CONTROL(_dma)       ((_dma)->regs + 0x00)
+#define DMA_BUFFER_ACK(_dma)           ((_dma)->regs + 0x04)
+#define DMA_BUFFER_CURRENT(_dma)       ((_dma)->regs + 0x08)
+#define DMA_BUFFER_SIZE(_dma)          ((_dma)->regs + 0x0c)
 
 /* ------------------------------------------------------------------------- */
 /* CI Interface (only CI-Bridge) */
 
-#define CI_BASE                     (0x400)
-#define CI_CONTROL(i)               (CI_BASE + (i) * 32 + 0x00)
+#define CI_BASE                         (0x400)
+#define CI_CONTROL(i)                   (CI_BASE + (i) * 32 + 0x00)
 
-#define CI_DO_ATTRIBUTE_RW(i)       (CI_BASE + (i) * 32 + 0x04)
-#define CI_DO_IO_RW(i)              (CI_BASE + (i) * 32 + 0x08)
-#define CI_READDATA(i)              (CI_BASE + (i) * 32 + 0x0c)
-#define CI_DO_READ_ATTRIBUTES(i)    (CI_BASE + (i) * 32 + 0x10)
+#define CI_DO_ATTRIBUTE_RW(i)           (CI_BASE + (i) * 32 + 0x04)
+#define CI_DO_IO_RW(i)                  (CI_BASE + (i) * 32 + 0x08)
+#define CI_READDATA(i)                  (CI_BASE + (i) * 32 + 0x0c)
+#define CI_DO_READ_ATTRIBUTES(i)        (CI_BASE + (i) * 32 + 0x10)
 
 #define CI_RESET_CAM                    (0x00000001)
 #define CI_POWER_ON                     (0x00000002)
@@ -132,7 +132,7 @@
 #define CI_BUFFER_BASE                  (0x3000)
 #define CI_BUFFER_SIZE                  (0x0800)
 
-#define CI_BUFFER(i)                  (CI_BUFFER_BASE + (i) * CI_BUFFER_SIZE)
+#define CI_BUFFER(i)                    (CI_BUFFER_BASE + (i) * CI_BUFFER_SIZE)
 
 /* ------------------------------------------------------------------------- */
 /* LNB commands (mxl5xx / Max S8) */
@@ -140,7 +140,7 @@
 #define LNB_BASE			(0x400)
 #define LNB_CONTROL(i)			(LNB_BASE + (i) * 0x20 + 0x00)
 
-#define LNB_CMD				(7ULL <<  0)
+#define LNB_CMD				(7ULL << 0)
 #define LNB_CMD_NOP			0
 #define LNB_CMD_INIT			1
 #define LNB_CMD_LOW			3
@@ -148,8 +148,8 @@
 #define LNB_CMD_OFF			5
 #define LNB_CMD_DISEQC			6
 
-#define LNB_BUSY			(1ULL <<  4)
-#define LNB_TONE			(1ULL << 15)
+#define LNB_BUSY			BIT_ULL(4)
+#define LNB_TONE			BIT_ULL(15)
 
 #define LNB_BUF_LEVEL(i)		(LNB_BASE + (i) * 0x20 + 0x10)
 #define LNB_BUF_WRITE(i)		(LNB_BASE + (i) * 0x20 + 0x14)
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index e9afa96bd9df..e8432e49564c 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -143,11 +143,11 @@ struct ddb_info {
 #define DMA_MAX_BUFS 32      /* hardware table limit */
 
 #define INPUT_DMA_BUFS 8
-#define INPUT_DMA_SIZE (128*47*21)
+#define INPUT_DMA_SIZE (128 * 47 * 21)
 #define INPUT_DMA_IRQ_DIV 1
 
 #define OUTPUT_DMA_BUFS 8
-#define OUTPUT_DMA_SIZE (128*47*21)
+#define OUTPUT_DMA_SIZE (128 * 47 * 21)
 #define OUTPUT_DMA_IRQ_DIV 1
 
 struct ddb;
@@ -166,7 +166,7 @@ struct ddb_dma {
 	u32                    bufval;
 
 	struct work_struct     work;
-	spinlock_t             lock;
+	spinlock_t             lock; /* DMA lock */
 	wait_queue_head_t      wq;
 	int                    running;
 	u32                    stat;
@@ -196,17 +196,16 @@ struct ddb_dvb {
 
 	int (*i2c_gate_ctrl)(struct dvb_frontend *, int);
 	int (*set_voltage)(struct dvb_frontend *fe,
-		enum fe_sec_voltage voltage);
+			   enum fe_sec_voltage voltage);
 	int (*set_input)(struct dvb_frontend *fe, int input);
 	int (*diseqc_send_master_cmd)(struct dvb_frontend *fe,
-		struct dvb_diseqc_master_cmd *cmd);
+				      struct dvb_diseqc_master_cmd *cmd);
 };
 
 struct ddb_ci {
 	struct dvb_ca_en50221  en;
 	struct ddb_port       *port;
 	u32                    nr;
-	struct mutex           lock;
 };
 
 struct ddb_io {
@@ -240,7 +239,7 @@ struct ddb_port {
 	u32                    regs;
 	u32                    lnr;
 	struct ddb_i2c        *i2c;
-	struct mutex           i2c_gate_lock;
+	struct mutex           i2c_gate_lock; /* I2C access lock */
 	u32                    class;
 #define DDB_PORT_NONE           0
 #define DDB_PORT_CI             1
@@ -297,7 +296,7 @@ struct ddb_port {
 #define TS_CAPTURE_LEN  (4096)
 
 struct ddb_lnb {
-	struct mutex           lock;
+	struct mutex           lock; /* lock lnb access */
 	u32                    tone;
 	enum fe_sec_voltage    oldvoltage[4];
 	u32                    voltage[4];
@@ -310,54 +309,54 @@ struct ddb_link {
 	const struct ddb_info *info;
 	u32                    nr;
 	u32                    regs;
-	spinlock_t             lock;
-	struct mutex           flash_mutex;
+	spinlock_t             lock; /* lock link access */
+	struct mutex           flash_mutex; /* lock flash access */
 	struct ddb_lnb         lnb;
 	struct tasklet_struct  tasklet;
 	struct ddb_ids         ids;
 
-	spinlock_t             temp_lock;
+	spinlock_t             temp_lock; /* lock temp chip access */
 	int                    overtemperature_error;
 	u8                     temp_tab[11];
 };
 
 struct ddb {
-	struct pci_dev        *pdev;
-	struct platform_device *pfdev;
-	struct device         *dev;
+	struct pci_dev          *pdev;
+	struct platform_device  *pfdev;
+	struct device           *dev;
 
-	int                    msi;
+	int                      msi;
 	struct workqueue_struct *wq;
-	u32                    has_dma;
-
-	struct ddb_link        link[DDB_MAX_LINK];
-	unsigned char __iomem *regs;
-	u32                    regs_len;
-	u32                    port_num;
-	struct ddb_port        port[DDB_MAX_PORT];
-	u32                    i2c_num;
-	struct ddb_i2c         i2c[DDB_MAX_I2C];
-	struct ddb_input       input[DDB_MAX_INPUT];
-	struct ddb_output      output[DDB_MAX_OUTPUT];
-	struct dvb_adapter     adap[DDB_MAX_INPUT];
-	struct ddb_dma         idma[DDB_MAX_INPUT];
-	struct ddb_dma         odma[DDB_MAX_OUTPUT];
-
-	void                   (*handler[4][256])(unsigned long);
-	unsigned long          handler_data[4][256];
-
-	struct device         *ddb_dev;
-	u32                    ddb_dev_users;
-	u32                    nr;
-	u8                     iobuf[1028];
-
-	u8                     leds;
-	u32                    ts_irq;
-	u32                    i2c_irq;
-
-	struct mutex           mutex;
-
-	u8                     tsbuf[TS_CAPTURE_LEN];
+	u32                      has_dma;
+
+	struct ddb_link          link[DDB_MAX_LINK];
+	unsigned char __iomem   *regs;
+	u32                      regs_len;
+	u32                      port_num;
+	struct ddb_port          port[DDB_MAX_PORT];
+	u32                      i2c_num;
+	struct ddb_i2c           i2c[DDB_MAX_I2C];
+	struct ddb_input         input[DDB_MAX_INPUT];
+	struct ddb_output        output[DDB_MAX_OUTPUT];
+	struct dvb_adapter       adap[DDB_MAX_INPUT];
+	struct ddb_dma           idma[DDB_MAX_INPUT];
+	struct ddb_dma           odma[DDB_MAX_OUTPUT];
+
+	void                     (*handler[4][256])(unsigned long);
+	unsigned long            handler_data[4][256];
+
+	struct device           *ddb_dev;
+	u32                      ddb_dev_users;
+	u32                      nr;
+	u8                       iobuf[1028];
+
+	u8                       leds;
+	u32                      ts_irq;
+	u32                      i2c_irq;
+
+	struct mutex             mutex; /* lock access to global ddb array */
+
+	u8                       tsbuf[TS_CAPTURE_LEN];
 };
 
 /****************************************************************************/
-- 
2.13.6
