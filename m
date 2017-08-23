Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33718 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754151AbdHWQKJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 12:10:09 -0400
Received: by mail-wr0-f193.google.com with SMTP id a47so371452wra.0
        for <linux-media@vger.kernel.org>; Wed, 23 Aug 2017 09:10:09 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH 3/5] [media] ddbridge: fix sparse warnings
Date: Wed, 23 Aug 2017 18:10:00 +0200
Message-Id: <20170823161002.25459-4-d.scheller.oss@gmail.com>
In-Reply-To: <20170823161002.25459-1-d.scheller.oss@gmail.com>
References: <20170823161002.25459-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fix several

  drivers/media/pci/ddbridge/ddbridge-core.c: warning: symbol ... was not declared. Should it be static?
  drivers/media/pci/ddbridge/ddbridge-core.c: warning: Using plain integer as NULL pointer
  drivers/media/pci/ddbridge/ddbridge-io.h: warning: cast removes address space of expression
  drivers/media/pci/ddbridge/ddbridge-io.h: warning: incorrect type in argument 1 (different address spaces)

at multiple places.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 26 +++++++++++++-------------
 drivers/media/pci/ddbridge/ddbridge-io.h   | 12 ++++++------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 281b6739b0c1..f4bd4908acdd 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -69,7 +69,7 @@ MODULE_PARM_DESC(adapter_alloc,
 
 /****************************************************************************/
 
-DEFINE_MUTEX(redirect_lock);
+static DEFINE_MUTEX(redirect_lock);
 
 struct workqueue_struct *ddb_wq;
 
@@ -135,8 +135,8 @@ static void ddb_redirect_dma(struct ddb *dev,
 
 static int ddb_unredirect(struct ddb_port *port)
 {
-	struct ddb_input *oredi, *iredi = 0;
-	struct ddb_output *iredo = 0;
+	struct ddb_input *oredi, *iredi = NULL;
+	struct ddb_output *iredo = NULL;
 
 	/* dev_info(port->dev->dev,
 	 * "unredirect %d.%d\n", port->dev->nr, port->nr);
@@ -160,14 +160,14 @@ static int ddb_unredirect(struct ddb_port *port)
 				ddb_redirect_dma(oredi->port->dev,
 						 oredi->dma, iredo->dma);
 			}
-			port->input[0]->redo = 0;
+			port->input[0]->redo = NULL;
 			ddb_set_dma_table(port->input[0]);
 		}
 		oredi->redi = iredi;
-		port->input[0]->redi = 0;
+		port->input[0]->redi = NULL;
 	}
-	oredi->redo = 0;
-	port->output->redi = 0;
+	oredi->redo = NULL;
+	port->output->redi = NULL;
 
 	ddb_set_dma_table(oredi);
 done:
@@ -209,7 +209,7 @@ static int ddb_redirect(u32 i, u32 p)
 	if (input2) {
 		if (input->redi) {
 			input2->redi = input->redi;
-			input->redi = 0;
+			input->redi = NULL;
 		} else
 			input2->redi = input;
 	}
@@ -811,11 +811,11 @@ static const struct file_operations ci_fops = {
 	.open    = ts_open,
 	.release = ts_release,
 	.poll    = ts_poll,
-	.mmap    = 0,
+	.mmap    = NULL,
 };
 
 static struct dvb_device dvbdev_ci = {
-	.priv    = 0,
+	.priv    = NULL,
 	.readers = 1,
 	.writers = 1,
 	.users   = 2,
@@ -2053,7 +2053,7 @@ static struct dvb_ca_en50221 en_templ = {
 
 static void ci_attach(struct ddb_port *port)
 {
-	struct ddb_ci *ci = 0;
+	struct ddb_ci *ci = NULL;
 
 	ci = kzalloc(sizeof(*ci), GFP_KERNEL);
 	if (!ci)
@@ -2206,7 +2206,7 @@ static void ci_xo2_attach(struct ddb_port *port)
 /****************************************************************************/
 /****************************************************************************/
 
-struct cxd2099_cfg cxd_cfg = {
+static struct cxd2099_cfg cxd_cfg = {
 	.bitrate =  72000,
 	.adr     =  0x40,
 	.polarity = 1,
@@ -3445,7 +3445,7 @@ int ddb_device_create(struct ddb *dev)
 	if (res) {
 		ddb_device_attrs_del(dev);
 		device_destroy(&ddb_class, MKDEV(ddb_major, dev->nr));
-		ddbs[dev->nr] = 0;
+		ddbs[dev->nr] = NULL;
 		dev->ddb_dev = ERR_PTR(-ENODEV);
 	} else
 		ddb_num++;
diff --git a/drivers/media/pci/ddbridge/ddbridge-io.h b/drivers/media/pci/ddbridge/ddbridge-io.h
index ce92e9484075..a4c6bbe09168 100644
--- a/drivers/media/pci/ddbridge/ddbridge-io.h
+++ b/drivers/media/pci/ddbridge/ddbridge-io.h
@@ -27,32 +27,32 @@
 
 static inline u32 ddblreadl(struct ddb_link *link, u32 adr)
 {
-	return readl((char *) (link->dev->regs + (adr)));
+	return readl(link->dev->regs + adr);
 }
 
 static inline void ddblwritel(struct ddb_link *link, u32 val, u32 adr)
 {
-	writel(val, (char *) (link->dev->regs + (adr)));
+	writel(val, link->dev->regs + adr);
 }
 
 static inline u32 ddbreadl(struct ddb *dev, u32 adr)
 {
-	return readl((char *) (dev->regs + (adr)));
+	return readl(dev->regs + adr);
 }
 
 static inline void ddbwritel(struct ddb *dev, u32 val, u32 adr)
 {
-	writel(val, (char *) (dev->regs + (adr)));
+	writel(val, dev->regs + adr);
 }
 
 static inline void ddbcpyto(struct ddb *dev, u32 adr, void *src, long count)
 {
-	return memcpy_toio((char *) (dev->regs + adr), src, count);
+	return memcpy_toio(dev->regs + adr, src, count);
 }
 
 static inline void ddbcpyfrom(struct ddb *dev, void *dst, u32 adr, long count)
 {
-	return memcpy_fromio(dst, (char *) (dev->regs + adr), count);
+	return memcpy_fromio(dst, dev->regs + adr, count);
 }
 
 static inline u32 safe_ddbreadl(struct ddb *dev, u32 adr)
-- 
2.13.0
