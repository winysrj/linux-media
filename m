Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 1 Aug 2008 11:23:19 +1000
From: Anton Blanchard <anton@samba.org>
To: linux-dvb@linuxtv.org
Message-ID: <20080801012319.GB7094@kryten>
MIME-Version: 1.0
Content-Disposition: inline
Cc: linuxdvb@itee.uq.edu.au, stev391@email.com
Subject: [linux-dvb] [PATCH 1/4] Factor out common cx23885 tuner callback
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


Tuners currently hook different things to the private pointer in their
callback function. Longer term we should make that private pointer
consistent, but for now separate out the guts of the cx23885 tuner callback
so we can reuse it.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-01 09:14:25.000000000 +1000
+++ v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-01 10:31:39.000000000 +1000
@@ -320,13 +320,9 @@
 			dev->name, tv.model);
 }
 
-/* Tuner callback function for cx23885 boards. Currently only needed
- * for HVR1500Q, which has an xc5000 tuner.
- */
-int cx23885_tuner_callback(void *priv, int command, int arg)
+static int cx23885_tuner_callback(struct cx23885_dev *dev, int port,
+				  int command, int arg)
 {
-	struct cx23885_i2c *bus = priv;
-	struct cx23885_dev *dev = bus->dev;
 	u32 bitmask = 0;
 
 	if (command != 0) {
@@ -346,9 +342,9 @@
 
 			/* Two identical tuners on two different i2c buses,
 			 * we need to reset the correct gpio. */
-			if (bus->nr == 0)
+			if (port == 0)
 				bitmask = 0x01;
-			else if (bus->nr == 1)
+			else if (port == 1)
 				bitmask = 0x04;
 		}
 		break;
@@ -364,6 +360,14 @@
 	return 0;
 }
 
+int cx23885_xc5000_tuner_callback(void *priv, int command, int arg)
+{
+	struct cx23885_i2c *bus = priv;
+	struct cx23885_dev *dev = bus->dev;
+
+	return cx23885_tuner_callback(dev, bus->nr, command, arg);
+}
+
 void cx23885_gpio_setup(struct cx23885_dev *dev)
 {
 	switch(dev->board) {
Index: v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/cx23885/cx23885-dvb.c	2008-08-01 09:14:25.000000000 +1000
+++ v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c	2008-08-01 10:31:39.000000000 +1000
@@ -189,13 +189,13 @@
 static struct xc5000_config hauppauge_hvr1500q_tunerconfig = {
 	.i2c_address      = 0x61,
 	.if_khz           = 5380,
-	.tuner_callback   = cx23885_tuner_callback
+	.tuner_callback   = cx23885_xc5000_tuner_callback,
 };
 
 static struct xc5000_config dvico_xc5000_tunerconfig = {
 	.i2c_address      = 0x64,
 	.if_khz           = 5380,
-	.tuner_callback   = cx23885_tuner_callback
+	.tuner_callback   = cx23885_xc5000_tuner_callback,
 };
 
 static struct tda829x_config tda829x_no_probe = {
Index: v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/cx23885/cx23885.h	2008-08-01 09:14:25.000000000 +1000
+++ v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h	2008-08-01 10:31:39.000000000 +1000
@@ -410,7 +410,7 @@
 extern struct cx23885_subid cx23885_subids[];
 extern const unsigned int cx23885_idcount;
 
-extern int cx23885_tuner_callback(void *priv, int command, int arg);
+extern int cx23885_xc5000_tuner_callback(void *priv, int command, int arg);
 extern void cx23885_card_list(struct cx23885_dev *dev);
 extern int  cx23885_ir_init(struct cx23885_dev *dev);
 extern void cx23885_gpio_setup(struct cx23885_dev *dev);

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
