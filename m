Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:51951 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab0BPRVz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2010 12:21:55 -0500
Received: from localhost (localhost [127.0.0.1])
	by bamako.nerim.net (Postfix) with ESMTP id 05B0B39DFA5
	for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 18:21:52 +0100 (CET)
Received: from bamako.nerim.net ([127.0.0.1])
	by localhost (bamako.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YhxBP0xfScPI for <linux-media@vger.kernel.org>;
	Tue, 16 Feb 2010 18:21:51 +0100 (CET)
Received: from hyperion.delvare (jdelvare.pck.nerim.net [62.212.121.182])
	by bamako.nerim.net (Postfix) with ESMTP id C264A39DF99
	for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 18:21:50 +0100 (CET)
Date: Tue, 16 Feb 2010 18:21:52 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] bttv: Move I2C IR initialization
Message-ID: <20100216182152.44129e46@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move I2C IR initialization from just after I2C bus setup to right
before non-I2C IR initialization. This avoids the case where an I2C IR
device is blocking audio support (at least the PV951 suffers from
this). It is also more logical to group IR support together,
regardless of the connectivity.

This fixes bug #15184:
http://bugzilla.kernel.org/show_bug.cgi?id=15184

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
As this fixes a regression, I suggest pushing to Linus quickly. This is
a candidate for 2.6.32-stable too.

 linux/drivers/media/video/bt8xx/bttv-driver.c |    1 +
 linux/drivers/media/video/bt8xx/bttv-i2c.c    |   10 +++++++---
 linux/drivers/media/video/bt8xx/bttvp.h       |    1 +
 3 files changed, 9 insertions(+), 3 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/bt8xx/bttv-i2c.c	2009-12-11 09:47:47.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/bt8xx/bttv-i2c.c	2010-02-16 18:14:34.000000000 +0100
@@ -409,9 +409,14 @@ int __devinit init_bttv_i2c(struct bttv
 	}
 	if (0 == btv->i2c_rc && i2c_scan)
 		do_i2c_scan(btv->c.v4l2_dev.name, &btv->i2c_client);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
 
-	/* Instantiate the IR receiver device, if present */
+	return btv->i2c_rc;
+}
+
+/* Instantiate the I2C IR receiver device, if present */
+void __devinit init_bttv_i2c_ir(struct bttv *btv)
+{
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
 	if (0 == btv->i2c_rc) {
 		struct i2c_board_info info;
 		/* The external IR receiver is at i2c address 0x34 (0x35 for
@@ -432,7 +437,6 @@ int __devinit init_bttv_i2c(struct bttv
 		i2c_new_probed_device(&btv->c.i2c_adap, &info, addr_list);
 	}
 #endif
-	return btv->i2c_rc;
 }
 
 int __devexit fini_bttv_i2c(struct bttv *btv)
--- v4l-dvb.orig/linux/drivers/media/video/bt8xx/bttvp.h	2009-04-06 10:10:24.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/bt8xx/bttvp.h	2010-02-16 18:13:31.000000000 +0100
@@ -281,6 +281,7 @@ extern unsigned int bttv_debug;
 extern unsigned int bttv_gpio;
 extern void bttv_gpio_tracking(struct bttv *btv, char *comment);
 extern int init_bttv_i2c(struct bttv *btv);
+extern void init_bttv_i2c_ir(struct bttv *btv);
 extern int fini_bttv_i2c(struct bttv *btv);
 
 #define bttv_printk if (bttv_verbose) printk
--- v4l-dvb.orig/linux/drivers/media/video/bt8xx/bttv-driver.c	2009-12-11 09:47:47.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/bt8xx/bttv-driver.c	2010-02-16 18:13:31.000000000 +0100
@@ -4498,6 +4498,7 @@ static int __devinit bttv_probe(struct p
 		request_modules(btv);
 	}
 
+	init_bttv_i2c_ir(btv);
 	bttv_input_init(btv);
 
 	/* everything is fine */


-- 
Jean Delvare
