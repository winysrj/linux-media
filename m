Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay02.digicable.hu ([92.249.128.188]:38082 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0CFJZ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Mar 2010 04:25:28 -0500
Message-ID: <4B921F84.3000803@freemail.hu>
Date: Sat, 06 Mar 2010 10:25:24 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Douglas Schilling Landgraf <dougsland@redhat.com>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] bttv: fix compiler warning before kernel 2.6.30
References: <20100216182152.44129e46@hyperion.delvare> <4B921F5F.4000905@freemail.hu>
In-Reply-To: <4B921F5F.4000905@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Fix the following compiler warnings when compiling before Linux
kernel version 2.6.30:
  bttv-i2c.c: In function 'init_bttv_i2c':
  bttv-i2c.c:440: warning: control reaches end of non-void function

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 41c5482f2dac linux/drivers/media/video/bt8xx/bttv-i2c.c
--- a/linux/drivers/media/video/bt8xx/bttv-i2c.c	Thu Mar 04 02:49:46 2010 -0300
+++ b/linux/drivers/media/video/bt8xx/bttv-i2c.c	Sat Mar 06 10:22:55 2010 +0100
@@ -409,7 +409,6 @@
 	}
 	if (0 == btv->i2c_rc && i2c_scan)
 		do_i2c_scan(btv->c.v4l2_dev.name, &btv->i2c_client);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)

 	return btv->i2c_rc;
 }
@@ -417,6 +416,7 @@
 /* Instantiate the I2C IR receiver device, if present */
 void __devinit init_bttv_i2c_ir(struct bttv *btv)
 {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
 	if (0 == btv->i2c_rc) {
 		struct i2c_board_info info;
 		/* The external IR receiver is at i2c address 0x34 (0x35 for

