Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:32636 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab1KIR2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2011 12:28:07 -0500
Date: Wed, 9 Nov 2011 18:27:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@md.metrocast.net>, ivtv-devel@ivtvdriver.org
Subject: [PATCH] [media] video: Drop undue references to i2c-algo-bit
Message-ID: <20111109182753.5f996f3e@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's one comment that has been copied from bttv to many other
media/video drivers:

/* init + register i2c algo-bit adapter */

Meanwhile, many drivers use hardware I2C implementations instead of
relying on i2c-algo-bit, so this comment is misleading. Remove the
reference to "algo-bit" from all drivers, to avoid any confusion. This
is the best way to ensure that the comments won't go out of sync
again. Anyone interested in the implementation details would rather
look at the code itself.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/media/video/au0828/au0828-i2c.c   |    2 +-
 drivers/media/video/bt8xx/bttv-i2c.c      |    2 +-
 drivers/media/video/cx18/cx18-i2c.c       |    2 +-
 drivers/media/video/cx18/cx18-i2c.h       |    2 +-
 drivers/media/video/cx23885/cx23885-i2c.c |    2 +-
 drivers/media/video/cx25821/cx25821-i2c.c |    2 +-
 drivers/media/video/cx88/cx88-i2c.c       |    2 +-
 drivers/media/video/ivtv/ivtv-i2c.h       |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

--- linux-3.2-rc0.orig/drivers/media/video/au0828/au0828-i2c.c	2011-07-22 04:17:23.000000000 +0200
+++ linux-3.2-rc0/drivers/media/video/au0828/au0828-i2c.c	2011-11-07 18:50:50.000000000 +0100
@@ -348,7 +348,7 @@ static void do_i2c_scan(char *name, stru
 	}
 }
 
-/* init + register i2c algo-bit adapter */
+/* init + register i2c adapter */
 int au0828_i2c_register(struct au0828_dev *dev)
 {
 	dprintk(1, "%s()\n", __func__);
--- linux-3.2-rc0.orig/drivers/media/video/bt8xx/bttv-i2c.c	2011-11-06 17:44:24.000000000 +0100
+++ linux-3.2-rc0/drivers/media/video/bt8xx/bttv-i2c.c	2011-11-07 18:51:13.000000000 +0100
@@ -346,7 +346,7 @@ static void do_i2c_scan(char *name, stru
 	}
 }
 
-/* init + register i2c algo-bit adapter */
+/* init + register i2c adapter */
 int __devinit init_bttv_i2c(struct bttv *btv)
 {
 	strlcpy(btv->i2c_client.name, "bttv internal", I2C_NAME_SIZE);
--- linux-3.2-rc0.orig/drivers/media/video/cx18/cx18-i2c.c	2011-07-22 04:17:23.000000000 +0200
+++ linux-3.2-rc0/drivers/media/video/cx18/cx18-i2c.c	2011-11-07 18:50:44.000000000 +0100
@@ -232,7 +232,7 @@ static struct i2c_algo_bit_data cx18_i2c
 	.timeout	= CX18_ALGO_BIT_TIMEOUT*HZ /* jiffies */
 };
 
-/* init + register i2c algo-bit adapter */
+/* init + register i2c adapter */
 int init_cx18_i2c(struct cx18 *cx)
 {
 	int i, err;
--- linux-3.2-rc0.orig/drivers/media/video/cx18/cx18-i2c.h	2011-07-22 04:17:23.000000000 +0200
+++ linux-3.2-rc0/drivers/media/video/cx18/cx18-i2c.h	2011-11-07 18:50:38.000000000 +0100
@@ -24,6 +24,6 @@
 int cx18_i2c_register(struct cx18 *cx, unsigned idx);
 struct v4l2_subdev *cx18_find_hw(struct cx18 *cx, u32 hw);
 
-/* init + register i2c algo-bit adapter */
+/* init + register i2c adapter */
 int init_cx18_i2c(struct cx18 *cx);
 void exit_cx18_i2c(struct cx18 *cx);
--- linux-3.2-rc0.orig/drivers/media/video/cx23885/cx23885-i2c.c	2011-11-06 17:44:24.000000000 +0100
+++ linux-3.2-rc0/drivers/media/video/cx23885/cx23885-i2c.c	2011-11-07 18:51:25.000000000 +0100
@@ -309,7 +309,7 @@ static void do_i2c_scan(char *name, stru
 	}
 }
 
-/* init + register i2c algo-bit adapter */
+/* init + register i2c adapter */
 int cx23885_i2c_register(struct cx23885_i2c *bus)
 {
 	struct cx23885_dev *dev = bus->dev;
--- linux-3.2-rc0.orig/drivers/media/video/cx25821/cx25821-i2c.c	2011-11-06 17:44:24.000000000 +0100
+++ linux-3.2-rc0/drivers/media/video/cx25821/cx25821-i2c.c	2011-11-07 18:51:01.000000000 +0100
@@ -300,7 +300,7 @@ static struct i2c_client cx25821_i2c_cli
 	.name = "cx25821 internal",
 };
 
-/* init + register i2c algo-bit adapter */
+/* init + register i2c adapter */
 int cx25821_i2c_register(struct cx25821_i2c *bus)
 {
 	struct cx25821_dev *dev = bus->dev;
--- linux-3.2-rc0.orig/drivers/media/video/cx88/cx88-i2c.c	2011-07-22 04:17:23.000000000 +0200
+++ linux-3.2-rc0/drivers/media/video/cx88/cx88-i2c.c	2011-11-07 18:51:07.000000000 +0100
@@ -132,7 +132,7 @@ static void do_i2c_scan(const char *name
 	}
 }
 
-/* init + register i2c algo-bit adapter */
+/* init + register i2c adapter */
 int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci)
 {
 	/* Prevents usage of invalid delay values */
--- linux-3.2-rc0.orig/drivers/media/video/ivtv/ivtv-i2c.h	2011-07-22 04:17:23.000000000 +0200
+++ linux-3.2-rc0/drivers/media/video/ivtv/ivtv-i2c.h	2011-11-07 18:50:55.000000000 +0100
@@ -25,7 +25,7 @@ struct i2c_client *ivtv_i2c_new_ir_legac
 int ivtv_i2c_register(struct ivtv *itv, unsigned idx);
 struct v4l2_subdev *ivtv_find_hw(struct ivtv *itv, u32 hw);
 
-/* init + register i2c algo-bit adapter */
+/* init + register i2c adapter */
 int init_ivtv_i2c(struct ivtv *itv);
 void exit_ivtv_i2c(struct ivtv *itv);
 


-- 
Jean Delvare
