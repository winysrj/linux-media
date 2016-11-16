Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49676 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753592AbcKPQnP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:15 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH 24/35] [media] dibx000_common: use pr_foo() instead of printk()
Date: Wed, 16 Nov 2016 14:42:56 -0200
Message-Id: <d3ef66d7b2f2516e27a613e95f37fe03411f4eb7.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dprintk() macro relies on continuation lines. This is not
a good practice and will break after commit 563873318d32
("Merge branch 'printk-cleanups").

So, instead of directly calling printk(), use pr_foo() macros,
adding a \n leading char on each macro call.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/dibx000_common.c | 36 +++++++++++++++-------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-frontends/dibx000_common.c b/drivers/media/dvb-frontends/dibx000_common.c
index 723358d7ca84..e81f10eba5be 100644
--- a/drivers/media/dvb-frontends/dibx000_common.c
+++ b/drivers/media/dvb-frontends/dibx000_common.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
@@ -8,14 +10,18 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "turn on debugging (default: 0)");
 
-#define dprintk(args...) do { if (debug) { printk(KERN_DEBUG "DiBX000: "); printk(args); printk("\n"); } } while (0)
+#define dprintk(fmt, arg...) do {					\
+	if (debug)							\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__ , ##arg);				\
+} while(0)
 
 static int dibx000_write_word(struct dibx000_i2c_master *mst, u16 reg, u16 val)
 {
 	int ret;
 
 	if (mutex_lock_interruptible(&mst->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return -EINVAL;
 	}
 
@@ -41,7 +47,7 @@ static u16 dibx000_read_word(struct dibx000_i2c_master *mst, u16 reg)
 	u16 ret;
 
 	if (mutex_lock_interruptible(&mst->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return 0;
 	}
 
@@ -59,7 +65,7 @@ static u16 dibx000_read_word(struct dibx000_i2c_master *mst, u16 reg)
 	mst->msg[1].len = 2;
 
 	if (i2c_transfer(mst->i2c_adap, mst->msg, 2) != 2)
-		dprintk("i2c read error on %d", reg);
+		dprintk("i2c read error on %d\n", reg);
 
 	ret = (mst->i2c_read_buffer[0] << 8) | mst->i2c_read_buffer[1];
 	mutex_unlock(&mst->i2c_buffer_lock);
@@ -192,7 +198,7 @@ static int dibx000_i2c_select_interface(struct dibx000_i2c_master *mst,
 					enum dibx000_i2c_interface intf)
 {
 	if (mst->device_rev > DIB3000MC && mst->selected_interface != intf) {
-		dprintk("selecting interface: %d", intf);
+		dprintk("selecting interface: %d\n", intf);
 		mst->selected_interface = intf;
 		return dibx000_write_word(mst, mst->base_reg + 4, intf);
 	}
@@ -290,7 +296,7 @@ static int dibx000_i2c_gated_gpio67_xfer(struct i2c_adapter *i2c_adap,
 	dibx000_i2c_select_interface(mst, DIBX000_I2C_INTERFACE_GPIO_6_7);
 
 	if (mutex_lock_interruptible(&mst->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return -EINVAL;
 	}
 
@@ -337,7 +343,7 @@ static int dibx000_i2c_gated_tuner_xfer(struct i2c_adapter *i2c_adap,
 	dibx000_i2c_select_interface(mst, DIBX000_I2C_INTERFACE_TUNER);
 
 	if (mutex_lock_interruptible(&mst->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return -EINVAL;
 	}
 	memset(mst->msg, 0, sizeof(struct i2c_msg) * (2 + num));
@@ -391,7 +397,7 @@ struct i2c_adapter *dibx000_get_i2c_adapter(struct dibx000_i2c_master *mst,
 			i2c = &mst->master_i2c_adap_gpio67;
 		break;
 	default:
-		printk(KERN_ERR "DiBX000: incorrect I2C interface selected\n");
+		pr_err("incorrect I2C interface selected\n");
 		break;
 	}
 
@@ -434,7 +440,7 @@ int dibx000_init_i2c_master(struct dibx000_i2c_master *mst, u16 device_rev,
 
 	mutex_init(&mst->i2c_buffer_lock);
 	if (mutex_lock_interruptible(&mst->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return -EINVAL;
 	}
 	memset(mst->msg, 0, sizeof(struct i2c_msg));
@@ -456,29 +462,25 @@ int dibx000_init_i2c_master(struct dibx000_i2c_master *mst, u16 device_rev,
 	if (i2c_adapter_init
 			(&mst->gated_tuner_i2c_adap, &dibx000_i2c_gated_tuner_algo,
 			 "DiBX000 tuner I2C bus", mst) != 0)
-		printk(KERN_ERR
-				"DiBX000: could not initialize the tuner i2c_adapter\n");
+		pr_err("could not initialize the tuner i2c_adapter\n");
 
 	mst->master_i2c_adap_gpio12.dev.parent = mst->i2c_adap->dev.parent;
 	if (i2c_adapter_init
 			(&mst->master_i2c_adap_gpio12, &dibx000_i2c_master_gpio12_xfer_algo,
 			 "DiBX000 master GPIO12 I2C bus", mst) != 0)
-		printk(KERN_ERR
-				"DiBX000: could not initialize the master i2c_adapter\n");
+		pr_err("could not initialize the master i2c_adapter\n");
 
 	mst->master_i2c_adap_gpio34.dev.parent = mst->i2c_adap->dev.parent;
 	if (i2c_adapter_init
 			(&mst->master_i2c_adap_gpio34, &dibx000_i2c_master_gpio34_xfer_algo,
 			 "DiBX000 master GPIO34 I2C bus", mst) != 0)
-		printk(KERN_ERR
-				"DiBX000: could not initialize the master i2c_adapter\n");
+		pr_err("could not initialize the master i2c_adapter\n");
 
 	mst->master_i2c_adap_gpio67.dev.parent = mst->i2c_adap->dev.parent;
 	if (i2c_adapter_init
 			(&mst->master_i2c_adap_gpio67, &dibx000_i2c_gated_gpio67_algo,
 			 "DiBX000 master GPIO67 I2C bus", mst) != 0)
-		printk(KERN_ERR
-				"DiBX000: could not initialize the master i2c_adapter\n");
+		pr_err("could not initialize the master i2c_adapter\n");
 
 	/* initialize the i2c-master by closing the gate */
 	dibx000_i2c_gate_ctrl(mst, mst->i2c_write_buffer, 0, 0);
-- 
2.7.4


