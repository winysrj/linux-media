Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3240 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaHTW7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 14/29] ngene: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:13 +0200
Message-Id: <1408575568-20562-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/ngene/ngene-core.c:188:27: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:190:25: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:199:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:260:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:263:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:282:32: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:283:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:284:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:285:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:286:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:287:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:288:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:292:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:293:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:294:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:295:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:296:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:297:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:303:17: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:316:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:368:17: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:372:9: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1160:28: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1199:20: warning: incorrect type in assignment (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1213:30: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1214:30: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1223:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1225:24: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1227:31: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1296:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1297:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1298:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1299:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1300:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1301:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1302:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1363:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1365:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1376:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1391:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-core.c:1596:18: warning: Using plain integer as NULL pointer
drivers/media/pci/ngene/ngene-core.c:1615:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-cards.c:699:29: warning: Using plain integer as NULL pointer
drivers/media/pci/ngene/ngene-cards.c:699:32: warning: Using plain integer as NULL pointer
drivers/media/pci/ngene/ngene-cards.c:699:35: warning: Using plain integer as NULL pointer
drivers/media/pci/ngene/ngene-cards.c:699:38: warning: Using plain integer as NULL pointer
drivers/media/pci/ngene/ngene-dvb.c:84:59: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ngene/ngene-dvb.c:93:20: warning: incorrect type in initializer (incompatible argument 2 (different address spaces))
drivers/media/pci/ngene/ngene-dvb.c:94:20: warning: incorrect type in initializer (incompatible argument 2 (different address spaces))
drivers/media/pci/ngene/ngene-dvb.c:100:20: warning: Using plain integer as NULL pointer

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/ngene/ngene-cards.c |  2 +-
 drivers/media/pci/ngene/ngene-core.c  | 14 ++++++--------
 drivers/media/pci/ngene/ngene-dvb.c   |  5 ++---
 drivers/media/pci/ngene/ngene.h       |  2 +-
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 9e82d21..039bed3 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -696,7 +696,7 @@ static struct ngene_info ngene_info_m780 = {
 	.demod_attach   = { NULL, demod_attach_lg330x },
 
 	/* Ensure these are NULL else the frame will call them (as funcs) */
-	.tuner_attach   = { 0, 0, 0, 0 },
+	.tuner_attach   = { NULL, NULL, NULL, NULL },
 	.fe_config      = { NULL, &aver_m780 },
 	.avf            = { 0 },
 
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 826228c..05886c1 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -57,15 +57,13 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define dprintk	if (debug) printk
 
-#define ngwriteb(dat, adr)         writeb((dat), (char *)(dev->iomem + (adr)))
-#define ngwritel(dat, adr)         writel((dat), (char *)(dev->iomem + (adr)))
-#define ngwriteb(dat, adr)         writeb((dat), (char *)(dev->iomem + (adr)))
+#define ngwriteb(dat, adr)         writeb((dat), dev->iomem + (adr))
+#define ngwritel(dat, adr)         writel((dat), dev->iomem + (adr))
+#define ngwriteb(dat, adr)         writeb((dat), dev->iomem + (adr))
 #define ngreadl(adr)               readl(dev->iomem + (adr))
 #define ngreadb(adr)               readb(dev->iomem + (adr))
-#define ngcpyto(adr, src, count)   memcpy_toio((char *) \
-				   (dev->iomem + (adr)), (src), (count))
-#define ngcpyfrom(dst, adr, count) memcpy_fromio((dst), (char *) \
-				   (dev->iomem + (adr)), (count))
+#define ngcpyto(adr, src, count)   memcpy_toio(dev->iomem + (adr), (src), (count))
+#define ngcpyfrom(dst, adr, count) memcpy_fromio((dst), dev->iomem + (adr), (count))
 
 /****************************************************************************/
 /* nGene interrupt handler **************************************************/
@@ -1593,7 +1591,7 @@ static void cxd_detach(struct ngene *dev)
 
 	dvb_ca_en50221_release(ci->en);
 	kfree(ci->en);
-	ci->en = 0;
+	ci->en = NULL;
 }
 
 /***********************************/
diff --git a/drivers/media/pci/ngene/ngene-dvb.c b/drivers/media/pci/ngene/ngene-dvb.c
index fcb16a6..a8a4045 100644
--- a/drivers/media/pci/ngene/ngene-dvb.c
+++ b/drivers/media/pci/ngene/ngene-dvb.c
@@ -47,7 +47,7 @@
 /* COMMAND API interface ****************************************************/
 /****************************************************************************/
 
-static ssize_t ts_write(struct file *file, const char *buf,
+static ssize_t ts_write(struct file *file, const char __user *buf,
 			size_t count, loff_t *ppos)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -64,7 +64,7 @@ static ssize_t ts_write(struct file *file, const char *buf,
 	return count;
 }
 
-static ssize_t ts_read(struct file *file, char *buf,
+static ssize_t ts_read(struct file *file, char __user *buf,
 		       size_t count, loff_t *ppos)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -97,7 +97,6 @@ static const struct file_operations ci_fops = {
 };
 
 struct dvb_device ngene_dvbdev_ci = {
-	.priv    = 0,
 	.readers = -1,
 	.writers = -1,
 	.users   = -1,
diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
index 22c39ff..51e2fbd 100644
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -737,7 +737,7 @@ typedef void (tx_cb_t)(struct ngene *, u32);
 struct ngene {
 	int                   nr;
 	struct pci_dev       *pci_dev;
-	unsigned char        *iomem;
+	unsigned char __iomem *iomem;
 
 	/*struct i2c_adapter  i2c_adapter;*/
 
-- 
2.1.0.rc1

