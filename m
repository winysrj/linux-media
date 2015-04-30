Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60202 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbbD3OI6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:58 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 22/22] saa7134: replace remaining occurences or printk()
Date: Thu, 30 Apr 2015 11:08:42 -0300
Message-Id: <e0eda5b491b1f6e20b7d530d00375fb51e22c768.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using printk(), use pr_foo() macros.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index ef3c33e3757d..d04fbdb49158 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -386,7 +386,7 @@ static char *i2c_devs[128] = {
 	[ 0x5a >> 1 ] = "remote control",
 };
 
-static void do_i2c_scan(char *name, struct i2c_client *c)
+static void do_i2c_scan(struct i2c_client *c)
 {
 	unsigned char buf;
 	int i,rc;
@@ -396,8 +396,8 @@ static void do_i2c_scan(char *name, struct i2c_client *c)
 		rc = i2c_master_recv(c,&buf,0);
 		if (rc < 0)
 			continue;
-		printk("%s: i2c scan: found device @ 0x%x  [%s]\n",
-		       name, i << 1, i2c_devs[i] ? i2c_devs[i] : "???");
+		pr_info("i2c scan: found device @ 0x%x  [%s]\n",
+			 i << 1, i2c_devs[i] ? i2c_devs[i] : "???");
 	}
 }
 
@@ -415,7 +415,7 @@ int saa7134_i2c_register(struct saa7134_dev *dev)
 
 	saa7134_i2c_eeprom(dev,dev->eedata,sizeof(dev->eedata));
 	if (i2c_scan)
-		do_i2c_scan(dev->name,&dev->i2c_client);
+		do_i2c_scan(&dev->i2c_client);
 
 	/* Instantiate the IR receiver device, if present */
 	saa7134_probe_i2c_ir(dev);
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 89f5fcf12722..c6036557b468 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -831,8 +831,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		break;
 	}
 	if (NULL == ir_codes) {
-		printk("%s: Oops: IR config error [card=%d]\n",
-		       dev->name, dev->board);
+		pr_err("Oops: IR config error [card=%d]\n", dev->board);
 		return -ENODEV;
 	}
 
diff --git a/drivers/media/pci/saa7134/saa7134-tvaudio.c b/drivers/media/pci/saa7134/saa7134-tvaudio.c
index 360f447bd74d..6320b64d3528 100644
--- a/drivers/media/pci/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/pci/saa7134/saa7134-tvaudio.c
@@ -674,12 +674,11 @@ static inline int saa_dsp_wait_bit(struct saa7134_dev *dev, int bit)
 	}
 	while (0 == (state & bit)) {
 		if (unlikely(0 == count)) {
-			printk("%s: dsp access wait timeout [bit=%s]\n",
-			       dev->name,
-			       (bit & SAA7135_DSP_RWSTATE_WRR) ? "WRR" :
-			       (bit & SAA7135_DSP_RWSTATE_RDB) ? "RDB" :
-			       (bit & SAA7135_DSP_RWSTATE_IDA) ? "IDA" :
-			       "???");
+			pr_err("dsp access wait timeout [bit=%s]\n",
+				 (bit & SAA7135_DSP_RWSTATE_WRR) ? "WRR" :
+				 (bit & SAA7135_DSP_RWSTATE_RDB) ? "RDB" :
+				 (bit & SAA7135_DSP_RWSTATE_IDA) ? "IDA" :
+				 "???");
 			return -EIO;
 		}
 		saa_wait(DSP_DELAY);
-- 
2.1.0

