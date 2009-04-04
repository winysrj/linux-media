Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:45101 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZDDM1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 08:27:00 -0400
Date: Sat, 4 Apr 2009 14:26:51 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Andy Walls <awalls@radix.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>
Subject: [PATCH 1/6] cx18: Fix the handling of i2c bus registration error
Message-ID: <20090404142651.44757ccb@hyperion.delvare>
In-Reply-To: <20090404142427.6e81f316@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Return actual error values as returned by the i2c subsystem, rather
  than 0 or 1.
* If the registration of the second bus fails, unregister the first one
  before exiting, otherwise we are leaking resources.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@radix.net>
---
 linux/drivers/media/video/cx18/cx18-i2c.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/cx18/cx18-i2c.c	2009-03-01 16:09:09.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/cx18/cx18-i2c.c	2009-04-03 18:45:18.000000000 +0200
@@ -214,7 +214,7 @@ static struct i2c_algo_bit_data cx18_i2c
 /* init + register i2c algo-bit adapter */
 int init_cx18_i2c(struct cx18 *cx)
 {
-	int i;
+	int i, err;
 	CX18_DEBUG_I2C("i2c init\n");
 
 	for (i = 0; i < 2; i++) {
@@ -273,8 +273,18 @@ int init_cx18_i2c(struct cx18 *cx)
 	cx18_call_hw(cx, CX18_HW_GPIO_RESET_CTRL,
 		     core, reset, (u32) CX18_GPIO_RESET_I2C);
 
-	return i2c_bit_add_bus(&cx->i2c_adap[0]) ||
-		i2c_bit_add_bus(&cx->i2c_adap[1]);
+	err = i2c_bit_add_bus(&cx->i2c_adap[0]);
+	if (err)
+		goto err;
+	err = i2c_bit_add_bus(&cx->i2c_adap[1]);
+	if (err)
+		goto err_del_bus_0;
+	return 0;
+
+ err_del_bus_0:
+ 	i2c_del_adapter(&cx->i2c_adap[0]);
+ err:
+	return err;
 }
 
 void exit_cx18_i2c(struct cx18 *cx)

-- 
Jean Delvare
