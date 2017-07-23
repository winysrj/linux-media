Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38645 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751440AbdGWSQg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 14:16:36 -0400
Received: by mail-wm0-f68.google.com with SMTP id r123so769554wmb.5
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 11:16:35 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH RESEND 01/14] [media] ddbridge: move/reorder functions
Date: Sun, 23 Jul 2017 20:16:17 +0200
Message-Id: <20170723181630.19526-2-d.scheller.oss@gmail.com>
In-Reply-To: <20170723181630.19526-1-d.scheller.oss@gmail.com>
References: <20170723181630.19526-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The functions in ddbridge-core.c have been moved to different positions in
newer versions of the dddvb vendor driver package (most notably in version
0.9.9b). Perform the same code move to keep the diff of the upcoming
code bump simpler.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
Tested-by: Jasmin Jessich <jasmin@anw.at>
Tested-by: Dietmar Spingler <d_spingler@freenet.de>
Tested-by: Manfred Knick <Manfred.Knick@t-online.de>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 660 ++++++++++++++---------------
 1 file changed, 327 insertions(+), 333 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index ec41804d78c7..d6dcc42ff222 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -404,43 +404,6 @@ static void ddb_buffers_free(struct ddb *dev)
 	}
 }
 
-static void ddb_input_start(struct ddb_input *input)
-{
-	struct ddb *dev = input->port->dev;
-
-	spin_lock_irq(&input->lock);
-	input->cbuf = 0;
-	input->coff = 0;
-
-	/* reset */
-	ddbwritel(0, TS_INPUT_CONTROL(input->nr));
-	ddbwritel(2, TS_INPUT_CONTROL(input->nr));
-	ddbwritel(0, TS_INPUT_CONTROL(input->nr));
-
-	ddbwritel((1 << 16) |
-		  (input->dma_buf_num << 11) |
-		  (input->dma_buf_size >> 7),
-		  DMA_BUFFER_SIZE(input->nr));
-	ddbwritel(0, DMA_BUFFER_ACK(input->nr));
-
-	ddbwritel(1, DMA_BASE_WRITE);
-	ddbwritel(3, DMA_BUFFER_CONTROL(input->nr));
-	ddbwritel(9, TS_INPUT_CONTROL(input->nr));
-	input->running = 1;
-	spin_unlock_irq(&input->lock);
-}
-
-static void ddb_input_stop(struct ddb_input *input)
-{
-	struct ddb *dev = input->port->dev;
-
-	spin_lock_irq(&input->lock);
-	ddbwritel(0, TS_INPUT_CONTROL(input->nr));
-	ddbwritel(0, DMA_BUFFER_CONTROL(input->nr));
-	input->running = 0;
-	spin_unlock_irq(&input->lock);
-}
-
 static void ddb_output_start(struct ddb_output *output)
 {
 	struct ddb *dev = output->port->dev;
@@ -477,6 +440,43 @@ static void ddb_output_stop(struct ddb_output *output)
 	spin_unlock_irq(&output->lock);
 }
 
+static void ddb_input_stop(struct ddb_input *input)
+{
+	struct ddb *dev = input->port->dev;
+
+	spin_lock_irq(&input->lock);
+	ddbwritel(0, TS_INPUT_CONTROL(input->nr));
+	ddbwritel(0, DMA_BUFFER_CONTROL(input->nr));
+	input->running = 0;
+	spin_unlock_irq(&input->lock);
+}
+
+static void ddb_input_start(struct ddb_input *input)
+{
+	struct ddb *dev = input->port->dev;
+
+	spin_lock_irq(&input->lock);
+	input->cbuf = 0;
+	input->coff = 0;
+
+	/* reset */
+	ddbwritel(0, TS_INPUT_CONTROL(input->nr));
+	ddbwritel(2, TS_INPUT_CONTROL(input->nr));
+	ddbwritel(0, TS_INPUT_CONTROL(input->nr));
+
+	ddbwritel((1 << 16) |
+		  (input->dma_buf_num << 11) |
+		  (input->dma_buf_size >> 7),
+		  DMA_BUFFER_SIZE(input->nr));
+	ddbwritel(0, DMA_BUFFER_ACK(input->nr));
+
+	ddbwritel(1, DMA_BASE_WRITE);
+	ddbwritel(3, DMA_BUFFER_CONTROL(input->nr));
+	ddbwritel(9, TS_INPUT_CONTROL(input->nr));
+	input->running = 1;
+	spin_unlock_irq(&input->lock);
+}
+
 static u32 ddb_output_free(struct ddb_output *output)
 {
 	u32 idx, off, stat = output->stat;
@@ -595,7 +595,98 @@ static ssize_t ddb_input_read(struct ddb_input *input, __user u8 *buf, size_t co
 	return count;
 }
 
-/******************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+static ssize_t ts_write(struct file *file, const __user char *buf,
+			size_t count, loff_t *ppos)
+{
+	struct dvb_device *dvbdev = file->private_data;
+	struct ddb_output *output = dvbdev->priv;
+	size_t left = count;
+	int stat;
+
+	while (left) {
+		if (ddb_output_free(output) < 188) {
+			if (file->f_flags & O_NONBLOCK)
+				break;
+			if (wait_event_interruptible(
+				    output->wq, ddb_output_free(output) >= 188) < 0)
+				break;
+		}
+		stat = ddb_output_write(output, buf, left);
+		if (stat < 0)
+			break;
+		buf += stat;
+		left -= stat;
+	}
+	return (left == count) ? -EAGAIN : (count - left);
+}
+
+static ssize_t ts_read(struct file *file, __user char *buf,
+		       size_t count, loff_t *ppos)
+{
+	struct dvb_device *dvbdev = file->private_data;
+	struct ddb_output *output = dvbdev->priv;
+	struct ddb_input *input = output->port->input[0];
+	int left, read;
+
+	count -= count % 188;
+	left = count;
+	while (left) {
+		if (ddb_input_avail(input) < 188) {
+			if (file->f_flags & O_NONBLOCK)
+				break;
+			if (wait_event_interruptible(
+				    input->wq, ddb_input_avail(input) >= 188) < 0)
+				break;
+		}
+		read = ddb_input_read(input, buf, left);
+		if (read < 0)
+			return read;
+		left -= read;
+		buf += read;
+	}
+	return (left == count) ? -EAGAIN : (count - left);
+}
+
+static unsigned int ts_poll(struct file *file, poll_table *wait)
+{
+	/*
+	struct dvb_device *dvbdev = file->private_data;
+	struct ddb_output *output = dvbdev->priv;
+	struct ddb_input *input = output->port->input[0];
+	*/
+	unsigned int mask = 0;
+
+#if 0
+	if (data_avail_to_read)
+		mask |= POLLIN | POLLRDNORM;
+	if (data_avail_to_write)
+		mask |= POLLOUT | POLLWRNORM;
+
+	poll_wait(file, &read_queue, wait);
+	poll_wait(file, &write_queue, wait);
+#endif
+	return mask;
+}
+
+static const struct file_operations ci_fops = {
+	.owner   = THIS_MODULE,
+	.read    = ts_read,
+	.write   = ts_write,
+	.open    = dvb_generic_open,
+	.release = dvb_generic_release,
+	.poll    = ts_poll,
+};
+
+static struct dvb_device dvbdev_ci = {
+	.readers = -1,
+	.writers = -1,
+	.users   = -1,
+	.fops    = &ci_fops,
+};
+
 /******************************************************************************/
 /******************************************************************************/
 
@@ -1261,251 +1352,72 @@ static int dvb_input_attach(struct ddb_input *input)
 	return 0;
 }
 
-/****************************************************************************/
-/****************************************************************************/
-
-static ssize_t ts_write(struct file *file, const __user char *buf,
-			size_t count, loff_t *ppos)
+static int port_has_ci(struct ddb_port *port)
 {
-	struct dvb_device *dvbdev = file->private_data;
-	struct ddb_output *output = dvbdev->priv;
-	size_t left = count;
-	int stat;
-
-	while (left) {
-		if (ddb_output_free(output) < 188) {
-			if (file->f_flags & O_NONBLOCK)
-				break;
-			if (wait_event_interruptible(
-				    output->wq, ddb_output_free(output) >= 188) < 0)
-				break;
-		}
-		stat = ddb_output_write(output, buf, left);
-		if (stat < 0)
-			break;
-		buf += stat;
-		left -= stat;
-	}
-	return (left == count) ? -EAGAIN : (count - left);
+	u8 val;
+	return i2c_read_reg(&port->i2c->adap, 0x40, 0, &val) ? 0 : 1;
 }
 
-static ssize_t ts_read(struct file *file, __user char *buf,
-		       size_t count, loff_t *ppos)
+static int port_has_xo2(struct ddb_port *port, u8 *type, u8 *id)
 {
-	struct dvb_device *dvbdev = file->private_data;
-	struct ddb_output *output = dvbdev->priv;
-	struct ddb_input *input = output->port->input[0];
-	int left, read;
+	u8 probe[1] = { 0x00 }, data[4];
 
-	count -= count % 188;
-	left = count;
-	while (left) {
-		if (ddb_input_avail(input) < 188) {
-			if (file->f_flags & O_NONBLOCK)
-				break;
-			if (wait_event_interruptible(
-				    input->wq, ddb_input_avail(input) >= 188) < 0)
-				break;
-		}
-		read = ddb_input_read(input, buf, left);
-		if (read < 0)
-			return read;
-		left -= read;
-		buf += read;
+	*type = DDB_XO2_TYPE_NONE;
+
+	if (i2c_io(&port->i2c->adap, 0x10, probe, 1, data, 4))
+		return 0;
+	if (data[0] == 'D' && data[1] == 'F') {
+		*id = data[2];
+		*type = DDB_XO2_TYPE_DUOFLEX;
+		return 1;
 	}
-	return (left == count) ? -EAGAIN : (count - left);
+	if (data[0] == 'C' && data[1] == 'I') {
+		*id = data[2];
+		*type = DDB_XO2_TYPE_CI;
+		return 1;
+	}
+	return 0;
 }
 
-static unsigned int ts_poll(struct file *file, poll_table *wait)
+static int port_has_stv0900(struct ddb_port *port)
 {
-	/*
-	struct dvb_device *dvbdev = file->private_data;
-	struct ddb_output *output = dvbdev->priv;
-	struct ddb_input *input = output->port->input[0];
-	*/
-	unsigned int mask = 0;
-
-#if 0
-	if (data_avail_to_read)
-		mask |= POLLIN | POLLRDNORM;
-	if (data_avail_to_write)
-		mask |= POLLOUT | POLLWRNORM;
-
-	poll_wait(file, &read_queue, wait);
-	poll_wait(file, &write_queue, wait);
-#endif
-	return mask;
+	u8 val;
+	if (i2c_read_reg16(&port->i2c->adap, 0x69, 0xf100, &val) < 0)
+		return 0;
+	return 1;
 }
 
-static const struct file_operations ci_fops = {
-	.owner   = THIS_MODULE,
-	.read    = ts_read,
-	.write   = ts_write,
-	.open    = dvb_generic_open,
-	.release = dvb_generic_release,
-	.poll    = ts_poll,
-};
-
-static struct dvb_device dvbdev_ci = {
-	.readers = -1,
-	.writers = -1,
-	.users   = -1,
-	.fops    = &ci_fops,
-};
-
-/****************************************************************************/
-/****************************************************************************/
-/****************************************************************************/
-
-static void input_tasklet(unsigned long data)
-{
-	struct ddb_input *input = (struct ddb_input *) data;
-	struct ddb *dev = input->port->dev;
-
-	spin_lock(&input->lock);
-	if (!input->running) {
-		spin_unlock(&input->lock);
-		return;
-	}
-	input->stat = ddbreadl(DMA_BUFFER_CURRENT(input->nr));
-
-	if (input->port->class == DDB_PORT_TUNER) {
-		if (4&ddbreadl(DMA_BUFFER_CONTROL(input->nr)))
-			dev_err(&dev->pdev->dev, "Overflow input %d\n", input->nr);
-		while (input->cbuf != ((input->stat >> 11) & 0x1f)
-		       || (4 & safe_ddbreadl(dev, DMA_BUFFER_CONTROL(input->nr)))) {
-			dvb_dmx_swfilter_packets(&input->demux,
-						 input->vbuf[input->cbuf],
-						 input->dma_buf_size / 188);
-
-			input->cbuf = (input->cbuf + 1) % input->dma_buf_num;
-			ddbwritel((input->cbuf << 11),
-				  DMA_BUFFER_ACK(input->nr));
-			input->stat = ddbreadl(DMA_BUFFER_CURRENT(input->nr));
-		       }
-	}
-	if (input->port->class == DDB_PORT_CI)
-		wake_up(&input->wq);
-	spin_unlock(&input->lock);
-}
-
-static void output_tasklet(unsigned long data)
-{
-	struct ddb_output *output = (struct ddb_output *) data;
-	struct ddb *dev = output->port->dev;
-
-	spin_lock(&output->lock);
-	if (!output->running) {
-		spin_unlock(&output->lock);
-		return;
-	}
-	output->stat = ddbreadl(DMA_BUFFER_CURRENT(output->nr + 8));
-	wake_up(&output->wq);
-	spin_unlock(&output->lock);
-}
-
-
-static struct cxd2099_cfg cxd_cfg = {
-	.bitrate =  62000,
-	.adr     =  0x40,
-	.polarity = 1,
-	.clock_mode = 1,
-	.max_i2c = 512,
-};
-
-static int ddb_ci_attach(struct ddb_port *port)
-{
-	int ret;
-
-	ret = dvb_register_adapter(&port->output->adap,
-				   "DDBridge",
-				   THIS_MODULE,
-				   &port->dev->pdev->dev,
-				   adapter_nr);
-	if (ret < 0)
-		return ret;
-	port->en = cxd2099_attach(&cxd_cfg, port, &port->i2c->adap);
-	if (!port->en) {
-		dvb_unregister_adapter(&port->output->adap);
-		return -ENODEV;
-	}
-	ddb_input_start(port->input[0]);
-	ddb_output_start(port->output);
-	dvb_ca_en50221_init(&port->output->adap,
-			    port->en, 0, 1);
-	ret = dvb_register_device(&port->output->adap, &port->output->dev,
-				  &dvbdev_ci, (void *) port->output,
-				  DVB_DEVICE_SEC, 0);
-	return ret;
-}
-
-static int ddb_port_attach(struct ddb_port *port)
+static int port_has_stv0900_aa(struct ddb_port *port, u8 *id)
 {
-	struct device *dev = &port->dev->pdev->dev;
-	int ret = 0;
-
-	switch (port->class) {
-	case DDB_PORT_TUNER:
-		ret = dvb_input_attach(port->input[0]);
-		if (ret < 0)
-			break;
-		ret = dvb_input_attach(port->input[1]);
-		break;
-	case DDB_PORT_CI:
-		ret = ddb_ci_attach(port);
-		break;
-	default:
-		break;
-	}
-	if (ret < 0)
-		dev_err(dev, "port_attach on port %d failed\n", port->nr);
-	return ret;
+	if (i2c_read_reg16(&port->i2c->adap, 0x68, 0xf100, id) < 0)
+		return 0;
+	return 1;
 }
 
-static int ddb_ports_attach(struct ddb *dev)
+static int port_has_drxks(struct ddb_port *port)
 {
-	int i, ret = 0;
-	struct ddb_port *port;
-
-	for (i = 0; i < dev->info->port_num; i++) {
-		port = &dev->port[i];
-		ret = ddb_port_attach(port);
-		if (ret < 0)
-			break;
-	}
-	return ret;
+	u8 val;
+	if (i2c_read(&port->i2c->adap, 0x29, &val) < 0)
+		return 0;
+	if (i2c_read(&port->i2c->adap, 0x2a, &val) < 0)
+		return 0;
+	return 1;
 }
 
-static void ddb_ports_detach(struct ddb *dev)
+static int port_has_stv0367(struct ddb_port *port)
 {
-	int i;
-	struct ddb_port *port;
-
-	for (i = 0; i < dev->info->port_num; i++) {
-		port = &dev->port[i];
-		switch (port->class) {
-		case DDB_PORT_TUNER:
-			dvb_input_detach(port->input[0]);
-			dvb_input_detach(port->input[1]);
-			break;
-		case DDB_PORT_CI:
-			dvb_unregister_device(port->output->dev);
-			if (port->en) {
-				ddb_input_stop(port->input[0]);
-				ddb_output_stop(port->output);
-				dvb_ca_en50221_release(port->en);
-				kfree(port->en);
-				port->en = NULL;
-				dvb_unregister_adapter(&port->output->adap);
-			}
-			break;
-		}
-	}
+	u8 val;
+	if (i2c_read_reg16(&port->i2c->adap, 0x1e, 0xf000, &val) < 0)
+		return 0;
+	if (val != 0x60)
+		return 0;
+	if (i2c_read_reg16(&port->i2c->adap, 0x1f, 0xf000, &val) < 0)
+		return 0;
+	if (val != 0x60)
+		return 0;
+	return 1;
 }
 
-/****************************************************************************/
-/****************************************************************************/
-
 static int init_xo2(struct ddb_port *port)
 {
 	struct i2c_adapter *i2c = &port->i2c->adap;
@@ -1547,75 +1459,6 @@ static int init_xo2(struct ddb_port *port)
 	return 0;
 }
 
-static int port_has_xo2(struct ddb_port *port, u8 *type, u8 *id)
-{
-	u8 probe[1] = { 0x00 }, data[4];
-
-	*type = DDB_XO2_TYPE_NONE;
-
-	if (i2c_io(&port->i2c->adap, 0x10, probe, 1, data, 4))
-		return 0;
-	if (data[0] == 'D' && data[1] == 'F') {
-		*id = data[2];
-		*type = DDB_XO2_TYPE_DUOFLEX;
-		return 1;
-	}
-	if (data[0] == 'C' && data[1] == 'I') {
-		*id = data[2];
-		*type = DDB_XO2_TYPE_CI;
-		return 1;
-	}
-	return 0;
-}
-
-/****************************************************************************/
-/****************************************************************************/
-
-static int port_has_ci(struct ddb_port *port)
-{
-	u8 val;
-	return i2c_read_reg(&port->i2c->adap, 0x40, 0, &val) ? 0 : 1;
-}
-
-static int port_has_stv0900(struct ddb_port *port)
-{
-	u8 val;
-	if (i2c_read_reg16(&port->i2c->adap, 0x69, 0xf100, &val) < 0)
-		return 0;
-	return 1;
-}
-
-static int port_has_stv0900_aa(struct ddb_port *port, u8 *id)
-{
-	if (i2c_read_reg16(&port->i2c->adap, 0x68, 0xf100, id) < 0)
-		return 0;
-	return 1;
-}
-
-static int port_has_drxks(struct ddb_port *port)
-{
-	u8 val;
-	if (i2c_read(&port->i2c->adap, 0x29, &val) < 0)
-		return 0;
-	if (i2c_read(&port->i2c->adap, 0x2a, &val) < 0)
-		return 0;
-	return 1;
-}
-
-static int port_has_stv0367(struct ddb_port *port)
-{
-	u8 val;
-	if (i2c_read_reg16(&port->i2c->adap, 0x1e, 0xf000, &val) < 0)
-		return 0;
-	if (val != 0x60)
-		return 0;
-	if (i2c_read_reg16(&port->i2c->adap, 0x1f, 0xf000, &val) < 0)
-		return 0;
-	if (val != 0x60)
-		return 0;
-	return 1;
-}
-
 static int port_has_cxd28xx(struct ddb_port *port, u8 *id)
 {
 	struct i2c_adapter *i2c = &port->i2c->adap;
@@ -1758,6 +1601,158 @@ static void ddb_port_probe(struct ddb_port *port)
 			 port->nr, port->nr+1, modname);
 }
 
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+static struct cxd2099_cfg cxd_cfg = {
+	.bitrate =  62000,
+	.adr     =  0x40,
+	.polarity = 1,
+	.clock_mode = 1,
+	.max_i2c = 512,
+};
+
+static int ddb_ci_attach(struct ddb_port *port)
+{
+	int ret;
+
+	ret = dvb_register_adapter(&port->output->adap,
+				   "DDBridge",
+				   THIS_MODULE,
+				   &port->dev->pdev->dev,
+				   adapter_nr);
+	if (ret < 0)
+		return ret;
+	port->en = cxd2099_attach(&cxd_cfg, port, &port->i2c->adap);
+	if (!port->en) {
+		dvb_unregister_adapter(&port->output->adap);
+		return -ENODEV;
+	}
+	ddb_input_start(port->input[0]);
+	ddb_output_start(port->output);
+	dvb_ca_en50221_init(&port->output->adap,
+			    port->en, 0, 1);
+	ret = dvb_register_device(&port->output->adap, &port->output->dev,
+				  &dvbdev_ci, (void *) port->output,
+				  DVB_DEVICE_SEC, 0);
+	return ret;
+}
+
+static int ddb_port_attach(struct ddb_port *port)
+{
+	struct device *dev = &port->dev->pdev->dev;
+	int ret = 0;
+
+	switch (port->class) {
+	case DDB_PORT_TUNER:
+		ret = dvb_input_attach(port->input[0]);
+		if (ret < 0)
+			break;
+		ret = dvb_input_attach(port->input[1]);
+		break;
+	case DDB_PORT_CI:
+		ret = ddb_ci_attach(port);
+		break;
+	default:
+		break;
+	}
+	if (ret < 0)
+		dev_err(dev, "port_attach on port %d failed\n", port->nr);
+	return ret;
+}
+
+static int ddb_ports_attach(struct ddb *dev)
+{
+	int i, ret = 0;
+	struct ddb_port *port;
+
+	for (i = 0; i < dev->info->port_num; i++) {
+		port = &dev->port[i];
+		ret = ddb_port_attach(port);
+		if (ret < 0)
+			break;
+	}
+	return ret;
+}
+
+static void ddb_ports_detach(struct ddb *dev)
+{
+	int i;
+	struct ddb_port *port;
+
+	for (i = 0; i < dev->info->port_num; i++) {
+		port = &dev->port[i];
+		switch (port->class) {
+		case DDB_PORT_TUNER:
+			dvb_input_detach(port->input[0]);
+			dvb_input_detach(port->input[1]);
+			break;
+		case DDB_PORT_CI:
+			dvb_unregister_device(port->output->dev);
+			if (port->en) {
+				ddb_input_stop(port->input[0]);
+				ddb_output_stop(port->output);
+				dvb_ca_en50221_release(port->en);
+				kfree(port->en);
+				port->en = NULL;
+				dvb_unregister_adapter(&port->output->adap);
+			}
+			break;
+		}
+	}
+}
+
+static void input_tasklet(unsigned long data)
+{
+	struct ddb_input *input = (struct ddb_input *) data;
+	struct ddb *dev = input->port->dev;
+
+	spin_lock(&input->lock);
+	if (!input->running) {
+		spin_unlock(&input->lock);
+		return;
+	}
+	input->stat = ddbreadl(DMA_BUFFER_CURRENT(input->nr));
+
+	if (input->port->class == DDB_PORT_TUNER) {
+		if (4&ddbreadl(DMA_BUFFER_CONTROL(input->nr)))
+			dev_err(&dev->pdev->dev, "Overflow input %d\n", input->nr);
+		while (input->cbuf != ((input->stat >> 11) & 0x1f)
+		       || (4 & safe_ddbreadl(dev, DMA_BUFFER_CONTROL(input->nr)))) {
+			dvb_dmx_swfilter_packets(&input->demux,
+						 input->vbuf[input->cbuf],
+						 input->dma_buf_size / 188);
+
+			input->cbuf = (input->cbuf + 1) % input->dma_buf_num;
+			ddbwritel((input->cbuf << 11),
+				  DMA_BUFFER_ACK(input->nr));
+			input->stat = ddbreadl(DMA_BUFFER_CURRENT(input->nr));
+		       }
+	}
+	if (input->port->class == DDB_PORT_CI)
+		wake_up(&input->wq);
+	spin_unlock(&input->lock);
+}
+
+static void output_tasklet(unsigned long data)
+{
+	struct ddb_output *output = (struct ddb_output *) data;
+	struct ddb *dev = output->port->dev;
+
+	spin_lock(&output->lock);
+	if (!output->running) {
+		spin_unlock(&output->lock);
+		return;
+	}
+	output->stat = ddbreadl(DMA_BUFFER_CURRENT(output->nr + 8));
+	wake_up(&output->wq);
+	spin_unlock(&output->lock);
+}
+
+/****************************************************************************/
+/****************************************************************************/
+
 static void ddb_input_init(struct ddb_port *port, int nr)
 {
 	struct ddb *dev = port->dev;
@@ -2084,7 +2079,6 @@ static void ddb_device_destroy(struct ddb *dev)
 	device_destroy(ddb_class, MKDEV(ddb_major, 0));
 }
 
-
 /****************************************************************************/
 /****************************************************************************/
 /****************************************************************************/
-- 
2.13.0
