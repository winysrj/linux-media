Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3064 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaHTW7r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 13/29] ddbridge: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:12 +0200
Message-Id: <1408575568-20562-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/ddbridge/ddbridge-core.c:88:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:93:37: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:95:25: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:99:15: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:117:58: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:119:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:123:68: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:130:17: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:131:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:136:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:138:25: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:152:22: warning: symbol 'ddb_i2c_algo' was not declared. Should it be static?
drivers/media/pci/ddbridge/ddbridge-core.c:183:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:184:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:246:25: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:247:25: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:255:25: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:256:25: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:269:35: warning: Using plain integer as NULL pointer
drivers/media/pci/ddbridge/ddbridge-core.c:358:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:359:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:360:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:362:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:366:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:368:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:369:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:370:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:380:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:381:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:393:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:394:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:395:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:396:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:397:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:401:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:403:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:404:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:406:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:416:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:417:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:475:36: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:484:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:494:20: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:501:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:524:36: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:534:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:852:21: warning: Using plain integer as NULL pointer
drivers/media/pci/ddbridge/ddbridge-core.c:973:20: warning: incorrect type in initializer (incompatible argument 2 (different address spaces))
drivers/media/pci/ddbridge/ddbridge-core.c:974:20: warning: incorrect type in initializer (incompatible argument 2 (different address spaces))
drivers/media/pci/ddbridge/ddbridge-core.c:978:20: warning: Using plain integer as NULL pointer
drivers/media/pci/ddbridge/ddbridge-core.c:982:20: warning: Using plain integer as NULL pointer
drivers/media/pci/ddbridge/ddbridge-core.c:1003:23: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1006:23: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1009:30: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1015:25: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1017:39: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1035:24: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1041:20: warning: symbol 'cxd_cfg' was not declared. Should it be static?
drivers/media/pci/ddbridge/ddbridge-core.c:1130:44: warning: Using plain integer as NULL pointer
drivers/media/pci/ddbridge/ddbridge-core.c:1183:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1188:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1193:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1198:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1213:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1214:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1215:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1216:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1231:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1232:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1233:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1289:17: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1333:23: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1295:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1347:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1353:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1354:24: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1359:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1361:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1373:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1374:16: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1378:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1382:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1385:17: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1386:24: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1388:24: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1393:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1394:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1395:16: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1398:16: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1399:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1451:42: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1462:45: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1467:37: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1538:28: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1550:9: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1561:31: warning: Using plain integer as NULL pointer
drivers/media/pci/ddbridge/ddbridge-core.c:1585:19: warning: incorrect type in assignment (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1591:47: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1591:60: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/ddbridge/ddbridge-core.c:1607:9: warning: too many warnings

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 30 ++++++++++++++----------------
 drivers/media/pci/ddbridge/ddbridge.h      | 12 +++++-------
 2 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index da8f848..c82e855 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -149,7 +149,7 @@ static u32 ddb_i2c_functionality(struct i2c_adapter *adap)
 	return I2C_FUNC_SMBUS_EMUL;
 }
 
-struct i2c_algorithm ddb_i2c_algo = {
+static struct i2c_algorithm ddb_i2c_algo = {
 	.master_xfer   = ddb_i2c_master_xfer,
 	.functionality = ddb_i2c_functionality,
 };
@@ -266,7 +266,7 @@ static void io_free(struct pci_dev *pdev, u8 **vbuf,
 	for (i = 0; i < num; i++) {
 		if (vbuf[i]) {
 			pci_free_consistent(pdev, size, vbuf[i], pbuf[i]);
-			vbuf[i] = 0;
+			vbuf[i] = NULL;
 		}
 	}
 }
@@ -440,7 +440,7 @@ static u32 ddb_output_free(struct ddb_output *output)
 }
 
 static ssize_t ddb_output_write(struct ddb_output *output,
-				const u8 *buf, size_t count)
+				const __user u8 *buf, size_t count)
 {
 	struct ddb *dev = output->port->dev;
 	u32 idx, off, stat = output->stat;
@@ -506,7 +506,7 @@ static u32 ddb_input_avail(struct ddb_input *input)
 	return 0;
 }
 
-static ssize_t ddb_input_read(struct ddb_input *input, u8 *buf, size_t count)
+static ssize_t ddb_input_read(struct ddb_input *input, __user u8 *buf, size_t count)
 {
 	struct ddb *dev = input->port->dev;
 	u32 left = count;
@@ -849,7 +849,7 @@ static int dvb_input_attach(struct ddb_input *input)
 		return ret;
 	input->attached = 4;
 
-	input->fe = 0;
+	input->fe = NULL;
 	switch (port->type) {
 	case DDB_TUNER_DVBS_ST:
 		if (demod_attach_stv0900(input, 0) < 0)
@@ -895,7 +895,7 @@ static int dvb_input_attach(struct ddb_input *input)
 /****************************************************************************/
 /****************************************************************************/
 
-static ssize_t ts_write(struct file *file, const char *buf,
+static ssize_t ts_write(struct file *file, const __user char *buf,
 			size_t count, loff_t *ppos)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -920,7 +920,7 @@ static ssize_t ts_write(struct file *file, const char *buf,
 	return (left == count) ? -EAGAIN : (count - left);
 }
 
-static ssize_t ts_read(struct file *file, char *buf,
+static ssize_t ts_read(struct file *file, __user char *buf,
 		       size_t count, loff_t *ppos)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -975,11 +975,9 @@ static const struct file_operations ci_fops = {
 	.open    = dvb_generic_open,
 	.release = dvb_generic_release,
 	.poll    = ts_poll,
-	.mmap    = 0,
 };
 
 static struct dvb_device dvbdev_ci = {
-	.priv    = 0,
 	.readers = -1,
 	.writers = -1,
 	.users   = -1,
@@ -1038,7 +1036,7 @@ static void output_tasklet(unsigned long data)
 }
 
 
-struct cxd2099_cfg cxd_cfg = {
+static struct cxd2099_cfg cxd_cfg = {
 	.bitrate =  62000,
 	.adr     =  0x40,
 	.polarity = 1,
@@ -1127,7 +1125,7 @@ static void ddb_ports_detach(struct ddb *dev)
 				ddb_output_stop(port->output);
 				dvb_ca_en50221_release(port->en);
 				kfree(port->en);
-				port->en = 0;
+				port->en = NULL;
 				dvb_unregister_adapter(&port->output->adap);
 			}
 			break;
@@ -1413,9 +1411,9 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 #define DDB_MAGIC 'd'
 
 struct ddb_flashio {
-	__u8 *write_buf;
+	__user __u8 *write_buf;
 	__u32 write_len;
-	__u8 *read_buf;
+	__user __u8 *read_buf;
 	__u32 read_len;
 };
 
@@ -1439,7 +1437,7 @@ static int ddb_open(struct inode *inode, struct file *file)
 static long ddb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct ddb *dev = file->private_data;
-	void *parg = (void *)arg;
+	__user void *parg = (__user void *)arg;
 	int res;
 
 	switch (cmd) {
@@ -1558,7 +1556,7 @@ static void ddb_remove(struct pci_dev *pdev)
 	ddb_device_destroy(dev);
 
 	ddb_unmap(dev);
-	pci_set_drvdata(pdev, 0);
+	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 }
 
@@ -1637,7 +1635,7 @@ fail1:
 fail:
 	printk(KERN_ERR "fail\n");
 	ddb_unmap(dev);
-	pci_set_drvdata(pdev, 0);
+	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 	return -1;
 }
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 8b1b41d..be87fbd 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -156,7 +156,7 @@ struct ddb_port {
 
 struct ddb {
 	struct pci_dev        *pdev;
-	unsigned char         *regs;
+	unsigned char __iomem *regs;
 	struct ddb_port        port[DDB_MAX_PORT];
 	struct ddb_i2c         i2c[DDB_MAX_I2C];
 	struct ddb_input       input[DDB_MAX_INPUT];
@@ -173,12 +173,10 @@ struct ddb {
 /****************************************************************************/
 
 #define ddbwritel(_val, _adr)        writel((_val), \
-				     (char *) (dev->regs+(_adr)))
-#define ddbreadl(_adr)               readl((char *) (dev->regs+(_adr)))
-#define ddbcpyto(_adr, _src, _count) memcpy_toio((char *)	\
-				     (dev->regs+(_adr)), (_src), (_count))
-#define ddbcpyfrom(_dst, _adr, _count) memcpy_fromio((_dst), (char *) \
-				       (dev->regs+(_adr)), (_count))
+				     dev->regs+(_adr))
+#define ddbreadl(_adr)               readl(dev->regs+(_adr))
+#define ddbcpyto(_adr, _src, _count) memcpy_toio(dev->regs+(_adr), (_src), (_count))
+#define ddbcpyfrom(_dst, _adr, _count) memcpy_fromio((_dst), dev->regs+(_adr), (_count))
 
 /****************************************************************************/
 
-- 
2.1.0.rc1

