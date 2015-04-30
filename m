Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbbD3OI5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:57 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 16/22] saa7134-i2c: make debug macros to use pr_fmt()
Date: Thu, 30 Apr 2015 11:08:36 -0300
Message-Id: <150633176e3df02a8c84ee396af6989d0230ff0c.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Converting debug prints to use pr_foo() is not trivial, as the
result will be a way worse than what's provided here, due to the
pieces of the code that prints the I2C transfers. Those use a
lot pr_cont(), and, depending on using either level 1 or 2,
a different set of macros are selected.

So, let's replace d1printk() and d2printk() macros by i2c_dbg()
and i2c_count() adding a debug level there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index 2dcc497fb166..b140143dba7d 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -41,8 +41,11 @@ static unsigned int i2c_scan;
 module_param(i2c_scan, int, 0444);
 MODULE_PARM_DESC(i2c_scan,"scan i2c bus at insmod time");
 
-#define d1printk if (1 == i2c_debug) printk
-#define d2printk if (2 == i2c_debug) printk
+#define i2c_dbg(level, fmt, arg...)    if (i2c_debug == level) \
+	printk(KERN_DEBUG pr_fmt("i2c: " fmt), ## arg)
+
+#define i2c_cont(level, fmt, arg...)    if (i2c_debug == level) \
+	pr_cont(fmt, ## arg)
 
 #define I2C_WAIT_DELAY  32
 #define I2C_WAIT_RETRY  16
@@ -90,23 +93,20 @@ static inline enum i2c_status i2c_get_status(struct saa7134_dev *dev)
 	enum i2c_status status;
 
 	status = saa_readb(SAA7134_I2C_ATTR_STATUS) & 0x0f;
-	d2printk(KERN_DEBUG "%s: i2c stat <= %s\n",dev->name,
-		 str_i2c_status[status]);
+	i2c_dbg(2, "i2c stat <= %s\n", str_i2c_status[status]);
 	return status;
 }
 
 static inline void i2c_set_status(struct saa7134_dev *dev,
 				  enum i2c_status status)
 {
-	d2printk(KERN_DEBUG "%s: i2c stat => %s\n",dev->name,
-		 str_i2c_status[status]);
+	i2c_dbg(2, "i2c stat => %s\n", str_i2c_status[status]);
 	saa_andorb(SAA7134_I2C_ATTR_STATUS,0x0f,status);
 }
 
 static inline void i2c_set_attr(struct saa7134_dev *dev, enum i2c_attr attr)
 {
-	d2printk(KERN_DEBUG "%s: i2c attr => %s\n",dev->name,
-		 str_i2c_attr[attr]);
+	i2c_dbg(2, "i2c attr => %s\n", str_i2c_attr[attr]);
 	saa_andorb(SAA7134_I2C_ATTR_STATUS,0xc0,attr << 6);
 }
 
@@ -169,7 +169,7 @@ static int i2c_reset(struct saa7134_dev *dev)
 	enum i2c_status status;
 	int count;
 
-	d2printk(KERN_DEBUG "%s: i2c reset\n",dev->name);
+	i2c_dbg(2, "i2c reset\n");
 	status = i2c_get_status(dev);
 	if (!i2c_is_error(status))
 		return true;
@@ -207,7 +207,7 @@ static inline int i2c_send_byte(struct saa7134_dev *dev,
 //	dword |= 0x40 << 16;  /* 400 kHz */
 	dword |= 0xf0 << 24;
 	saa_writel(SAA7134_I2C_ATTR_STATUS >> 2, dword);
-	d2printk(KERN_DEBUG "%s: i2c data => 0x%x\n",dev->name,data);
+	i2c_dbg(2, "i2c data => 0x%x\n", data);
 
 	if (!i2c_is_busy_wait(dev))
 		return -EIO;
@@ -229,7 +229,7 @@ static inline int i2c_recv_byte(struct saa7134_dev *dev)
 	if (i2c_is_error(status))
 		return -EIO;
 	data = saa_readb(SAA7134_I2C_DATA);
-	d2printk(KERN_DEBUG "%s: i2c data <= 0x%x\n",dev->name,data);
+	i2c_dbg(2, "i2c data <= 0x%x\n", data);
 	return data;
 }
 
@@ -246,12 +246,12 @@ static int saa7134_i2c_xfer(struct i2c_adapter *i2c_adap,
 		if (!i2c_reset(dev))
 			return -EIO;
 
-	d2printk("start xfer\n");
-	d1printk(KERN_DEBUG "%s: i2c xfer:",dev->name);
+	i2c_dbg(2, "start xfer\n");
+	i2c_dbg(1, "i2c xfer:");
 	for (i = 0; i < num; i++) {
 		if (!(msgs[i].flags & I2C_M_NOSTART) || 0 == i) {
 			/* send address */
-			d2printk("send address\n");
+			i2c_dbg(2, "send address\n");
 			addr  = msgs[i].addr << 1;
 			if (msgs[i].flags & I2C_M_RD)
 				addr |= 1;
@@ -263,50 +263,50 @@ static int saa7134_i2c_xfer(struct i2c_adapter *i2c_adap,
 				 * needed to talk to the mt352 demux
 				 * thanks to pinnacle for the hint */
 				int quirk = 0xfe;
-				d1printk(" [%02x quirk]",quirk);
+				i2c_cont(1, " [%02x quirk]",quirk);
 				i2c_send_byte(dev,START,quirk);
 				i2c_recv_byte(dev);
 			}
-			d1printk(" < %02x", addr);
+			i2c_cont(1, " < %02x", addr);
 			rc = i2c_send_byte(dev,START,addr);
 			if (rc < 0)
 				 goto err;
 		}
 		if (msgs[i].flags & I2C_M_RD) {
 			/* read bytes */
-			d2printk("read bytes\n");
+			i2c_dbg(2, "read bytes\n");
 			for (byte = 0; byte < msgs[i].len; byte++) {
-				d1printk(" =");
+				i2c_cont(1, " =");
 				rc = i2c_recv_byte(dev);
 				if (rc < 0)
 					goto err;
-				d1printk("%02x", rc);
+				i2c_cont(1, "%02x", rc);
 				msgs[i].buf[byte] = rc;
 			}
 			/* discard mysterious extra byte when reading
 			   from Samsung S5H1411.  i2c bus gets error
 			   if we do not. */
 			if (0x19 == msgs[i].addr) {
-				d1printk(" ?");
+				i2c_cont(1, " ?");
 				rc = i2c_recv_byte(dev);
 				if (rc < 0)
 					goto err;
-				d1printk("%02x", rc);
+				i2c_cont(1, "%02x", rc);
 			}
 		} else {
 			/* write bytes */
-			d2printk("write bytes\n");
+			i2c_dbg(2, "write bytes\n");
 			for (byte = 0; byte < msgs[i].len; byte++) {
 				data = msgs[i].buf[byte];
-				d1printk(" %02x", data);
+				i2c_cont(1, " %02x", data);
 				rc = i2c_send_byte(dev,CONTINUE,data);
 				if (rc < 0)
 					goto err;
 			}
 		}
 	}
-	d2printk("xfer done\n");
-	d1printk(" >");
+	i2c_dbg(2, "xfer done\n");
+	i2c_cont(1, " >");
 	i2c_set_attr(dev,STOP);
 	rc = -EIO;
 	if (!i2c_is_busy_wait(dev))
@@ -317,12 +317,12 @@ static int saa7134_i2c_xfer(struct i2c_adapter *i2c_adap,
 	/* ensure that the bus is idle for at least one bit slot */
 	msleep(1);
 
-	d1printk("\n");
+	i2c_cont(1, "\n");
 	return num;
  err:
 	if (1 == i2c_debug) {
 		status = i2c_get_status(dev);
-		printk(" ERROR: %s\n",str_i2c_status[status]);
+		i2c_cont(1, " ERROR: %s\n", str_i2c_status[status]);
 	}
 	return rc;
 }
-- 
2.1.0

