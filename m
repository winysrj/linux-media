Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:40019 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753322AbeDBSYj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 14:24:39 -0400
Received: by mail-wm0-f68.google.com with SMTP id x4so28984167wmh.5
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2018 11:24:38 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 08/20] [media] ddbridge: add helper for IRQ handler setup
Date: Mon,  2 Apr 2018 20:24:15 +0200
Message-Id: <20180402182427.20918-9-d.scheller.oss@gmail.com>
In-Reply-To: <20180402182427.20918-1-d.scheller.oss@gmail.com>
References: <20180402182427.20918-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Introduce the ddb_irq_set() helper function (along with a matching
prototype in ddbridge.h) to improve the set up of the IRQ handlers
and handler_data, and rework storing this data into the ddb_link
using a new ddb_irq struct. This also does the necessary rework
of affected variables. And while at it, always do queue_work in
input_handler() as there's not much of a difference to directly
calling input_work if there's no ptr at input->redi, or queueing
this call.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 53 +++++++++++++++++-------------
 drivers/media/pci/ddbridge/ddbridge-i2c.c  |  5 ++-
 drivers/media/pci/ddbridge/ddbridge.h      | 11 +++++--
 3 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index fb9a2cb758e6..be6935bd0cb5 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -108,6 +108,16 @@ static struct ddb *ddbs[DDB_MAX_ADAPTER];
 /****************************************************************************/
 /****************************************************************************/
 
+struct ddb_irq *ddb_irq_set(struct ddb *dev, u32 link, u32 nr,
+			    void (*handler)(void *), void *data)
+{
+	struct ddb_irq *irq = &dev->link[link].irq[nr];
+
+	irq->handler = handler;
+	irq->data = data;
+	return irq;
+}
+
 static void ddb_set_dma_table(struct ddb_io *io)
 {
 	struct ddb *dev = io->port->dev;
@@ -2109,26 +2119,18 @@ static void input_work(struct work_struct *work)
 	spin_unlock_irqrestore(&dma->lock, flags);
 }
 
-static void input_handler(unsigned long data)
+static void input_handler(void *data)
 {
 	struct ddb_input *input = (struct ddb_input *)data;
 	struct ddb_dma *dma = input->dma;
 
-	/*
-	 * If there is no input connected, input_tasklet() will
-	 * just copy pointers and ACK. So, there is no need to go
-	 * through the tasklet scheduler.
-	 */
-	if (input->redi)
-		queue_work(ddb_wq, &dma->work);
-	else
-		input_work(&dma->work);
+	queue_work(ddb_wq, &dma->work);
 }
 
-static void output_handler(unsigned long data)
+static void output_work(struct work_struct *work)
 {
-	struct ddb_output *output = (struct ddb_output *)data;
-	struct ddb_dma *dma = output->dma;
+	struct ddb_dma *dma = container_of(work, struct ddb_dma, work);
+	struct ddb_output *output = (struct ddb_output *)dma->io;
 	struct ddb *dev = output->port->dev;
 
 	spin_lock(&dma->lock);
@@ -2144,6 +2146,14 @@ static void output_handler(unsigned long data)
 	spin_unlock(&dma->lock);
 }
 
+static void output_handler(void *data)
+{
+	struct ddb_output *output = (struct ddb_output *)data;
+	struct ddb_dma *dma = output->dma;
+
+	queue_work(ddb_wq, &dma->work);
+}
+
 /****************************************************************************/
 /****************************************************************************/
 
@@ -2174,6 +2184,7 @@ static void ddb_dma_init(struct ddb_io *io, int nr, int out)
 	spin_lock_init(&dma->lock);
 	init_waitqueue_head(&dma->wq);
 	if (out) {
+		INIT_WORK(&dma->work, output_work);
 		dma->regs = rm->odma->base + rm->odma->size * nr;
 		dma->bufregs = rm->odma_buf->base + rm->odma_buf->size * nr;
 		dma->num = OUTPUT_DMA_BUFS;
@@ -2218,8 +2229,7 @@ static void ddb_input_init(struct ddb_port *port, int nr, int pnr, int anr)
 		dev_dbg(dev->dev, "init link %u, input %u, handler %u\n",
 			port->lnr, nr, dma_nr + base);
 
-		dev->handler[0][dma_nr + base] = input_handler;
-		dev->handler_data[0][dma_nr + base] = (unsigned long)input;
+		ddb_irq_set(dev, 0, dma_nr + base, &input_handler, input);
 		ddb_dma_init(input, dma_nr, 0);
 	}
 }
@@ -2244,8 +2254,7 @@ static void ddb_output_init(struct ddb_port *port, int nr)
 		const struct ddb_regmap *rm0 = io_regmap(output, 0);
 		u32 base = rm0->irq_base_odma;
 
-		dev->handler[0][nr + base] = output_handler;
-		dev->handler_data[0][nr + base] = (unsigned long)output;
+		ddb_irq_set(dev, 0, nr + base, &output_handler, output);
 		ddb_dma_init(output, nr, 1);
 	}
 }
@@ -2389,8 +2398,9 @@ void ddb_ports_release(struct ddb *dev)
 /****************************************************************************/
 
 #define IRQ_HANDLE(_nr) \
-	do { if ((s & (1UL << ((_nr) & 0x1f))) && dev->handler[0][_nr]) \
-		dev->handler[0][_nr](dev->handler_data[0][_nr]); } \
+	do { if ((s & (1UL << ((_nr) & 0x1f))) && \
+		 dev->link[0].irq[_nr].handler) \
+		dev->link[0].irq[_nr].handler(dev->link[0].irq[_nr].data); } \
 	while (0)
 
 static void irq_handle_msg(struct ddb *dev, u32 s)
@@ -3201,7 +3211,7 @@ static void tempmon_setfan(struct ddb_link *link)
 	ddblwritel(link, (pwm << 8), TEMPMON_FANCONTROL);
 }
 
-static void temp_handler(unsigned long data)
+static void temp_handler(void *data)
 {
 	struct ddb_link *link = (struct ddb_link *)data;
 
@@ -3224,8 +3234,7 @@ static int tempmon_init(struct ddb_link *link, int first_time)
 		memcpy(link->temp_tab, temperature_table,
 		       sizeof(temperature_table));
 	}
-	dev->handler[l][link->info->tempmon_irq] = temp_handler;
-	dev->handler_data[l][link->info->tempmon_irq] = (unsigned long)link;
+	ddb_irq_set(dev, l, link->info->tempmon_irq, temp_handler, link);
 	ddblwritel(link, (TEMPMON_CONTROL_OVERTEMP | TEMPMON_CONTROL_AUTOSCAN |
 			  TEMPMON_CONTROL_INTENABLE),
 		   TEMPMON_CONTROL);
diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
index 82a9a0e806fc..667340c86ea7 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.c
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -147,7 +147,7 @@ void ddb_i2c_release(struct ddb *dev)
 	}
 }
 
-static void i2c_handler(unsigned long priv)
+static void i2c_handler(void *priv)
 {
 	struct ddb_i2c *i2c = (struct ddb_i2c *)priv;
 
@@ -210,8 +210,7 @@ int ddb_i2c_init(struct ddb *dev)
 			if (!(dev->link[l].info->i2c_mask & (1 << i)))
 				continue;
 			i2c = &dev->i2c[num];
-			dev->handler_data[l][i + base] = (unsigned long)i2c;
-			dev->handler[l][i + base] = i2c_handler;
+			ddb_irq_set(dev, l, i + base, i2c_handler, i2c);
 			stat = ddb_i2c_add(dev, i2c, regmap, l, i, num);
 			if (stat)
 				break;
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index dbd5f551ce76..de9ddf1068bf 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -305,6 +305,11 @@ struct ddb_lnb {
 	u32                    fmode;
 };
 
+struct ddb_irq {
+	void                   (*handler)(void *);
+	void                  *data;
+};
+
 struct ddb_link {
 	struct ddb            *dev;
 	const struct ddb_info *info;
@@ -319,6 +324,7 @@ struct ddb_link {
 	spinlock_t             temp_lock; /* lock temp chip access */
 	int                    overtemperature_error;
 	u8                     temp_tab[11];
+	struct ddb_irq         irq[256];
 };
 
 struct ddb {
@@ -343,9 +349,6 @@ struct ddb {
 	struct ddb_dma           idma[DDB_MAX_INPUT];
 	struct ddb_dma           odma[DDB_MAX_OUTPUT];
 
-	void                     (*handler[4][256])(unsigned long);
-	unsigned long            handler_data[4][256];
-
 	struct device           *ddb_dev;
 	u32                      ddb_dev_users;
 	u32                      nr;
@@ -369,6 +372,8 @@ int ddbridge_flashread(struct ddb *dev, u32 link, u8 *buf, u32 addr, u32 len);
 /****************************************************************************/
 
 /* ddbridge-core.c */
+struct ddb_irq *ddb_irq_set(struct ddb *dev, u32 link, u32 nr,
+			    void (*handler)(void *), void *data);
 void ddb_ports_detach(struct ddb *dev);
 void ddb_ports_release(struct ddb *dev);
 void ddb_buffers_free(struct ddb *dev);
-- 
2.16.1
