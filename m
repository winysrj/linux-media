Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 1 Aug 2008 11:25:13 +1000
From: Anton Blanchard <anton@samba.org>
To: linux-dvb@linuxtv.org
Message-ID: <20080801012513.GC7094@kryten>
References: <20080801012319.GB7094@kryten>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080801012319.GB7094@kryten>
Cc: linuxdvb@itee.uq.edu.au, stev391@email.com
Subject: [linux-dvb] [PATCH 2/4] Switch Hauppauge HVR1400 and HVR1500 to
	common cx23885	tuner callback
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


The Hauppauge HVR1400 and HVR1500 can now use the common cx23885 tuner
callback.

Signed-off-by: Anton Blanchard <anton@samba.org>
---
Note: There are no in tree users of XC2028_RESET_CLK, I wonder if we should
just remove it.

Index: v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-01 11:00:37.000000000 +1000
+++ v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-01 11:03:28.000000000 +1000
@@ -27,6 +27,7 @@
 
 #include "compat.h"
 #include "cx23885.h"
+#include "tuner-xc2028.h"
 
 /* ------------------------------------------------------------------ */
 /* board config info                                                  */
@@ -332,8 +333,10 @@
 	}
 
 	switch(dev->board) {
+	case CX23885_BOARD_HAUPPAUGE_HVR1400:
+	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
-		/* Tuner Reset Command from xc5000 */
+		/* Tuner Reset Command */
 		if (command == 0)
 			bitmask = 0x04;
 		break;
@@ -368,6 +371,17 @@
 	return cx23885_tuner_callback(dev, bus->nr, command, arg);
 }
 
+int cx23885_xc3028_tuner_callback(void *priv, int command, int arg)
+{
+	struct cx23885_tsport *port = priv;
+	struct cx23885_dev *dev = port->dev;
+
+	if (command == XC2028_RESET_CLK)
+		return 0;
+
+	return cx23885_tuner_callback(dev, port->nr, command, arg);
+}
+
 void cx23885_gpio_setup(struct cx23885_dev *dev)
 {
 	switch(dev->board) {
Index: v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/cx23885/cx23885-dvb.c	2008-08-01 11:00:37.000000000 +1000
+++ v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c	2008-08-01 11:00:54.000000000 +1000
@@ -304,36 +304,6 @@
 	.output_mode = OUTMODE_MPEG2_SERIAL,
 };
 
-static int cx23885_hvr1500_xc3028_callback(void *ptr, int command, int arg)
-{
-	struct cx23885_tsport *port = ptr;
-	struct cx23885_dev *dev = port->dev;
-
-	switch (command) {
-	case XC2028_TUNER_RESET:
-		/* Send the tuner in then out of reset */
-		/* GPIO-2 xc3028 tuner */
-		dprintk(1, "%s: XC2028_TUNER_RESET %d\n", __func__, arg);
-
-		cx_set(GP0_IO, 0x00040000);
-		cx_clear(GP0_IO, 0x00000004);
-		msleep(5);
-
-		cx_set(GP0_IO, 0x00040004);
-		msleep(5);
-		break;
-	case XC2028_RESET_CLK:
-		dprintk(1, "%s: XC2028_RESET_CLK %d\n", __func__, arg);
-		break;
-	default:
-		dprintk(1, "%s: unknown command %d, arg %d\n", __func__,
-			command, arg);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int dvb_register(struct cx23885_tsport *port)
 {
 	struct cx23885_dev *dev = port->dev;
@@ -427,7 +397,7 @@
 			struct xc2028_config cfg = {
 				.i2c_adap  = &i2c_bus->i2c_adap,
 				.i2c_addr  = 0x61,
-				.callback  = cx23885_hvr1500_xc3028_callback,
+				.callback  = cx23885_xc3028_tuner_callback,
 			};
 			static struct xc2028_ctrl ctl = {
 				.fname       = "xc3028-v27.fw",
@@ -466,7 +436,7 @@
 			struct xc2028_config cfg = {
 				.i2c_adap  = &dev->i2c_bus[1].i2c_adap,
 				.i2c_addr  = 0x64,
-				.callback  = cx23885_hvr1500_xc3028_callback,
+				.callback  = cx23885_xc3028_tuner_callback,
 			};
 			static struct xc2028_ctrl ctl = {
 				.fname   = "xc3028L-v36.fw",
Index: v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/cx23885/cx23885.h	2008-08-01 11:00:37.000000000 +1000
+++ v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h	2008-08-01 11:00:54.000000000 +1000
@@ -411,6 +411,7 @@
 extern const unsigned int cx23885_idcount;
 
 extern int cx23885_xc5000_tuner_callback(void *priv, int command, int arg);
+extern int cx23885_xc3028_tuner_callback(void *priv, int command, int arg);
 extern void cx23885_card_list(struct cx23885_dev *dev);
 extern int  cx23885_ir_init(struct cx23885_dev *dev);
 extern void cx23885_gpio_setup(struct cx23885_dev *dev);

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
