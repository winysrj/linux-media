Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:23997 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbZB0N7g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 08:59:36 -0500
Date: Fri, 27 Feb 2009 14:59:19 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Old Video ML <video4linux-list@redhat.com>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: Conversion of vino driver for SGI to not use the legacy decoder
 API
Message-ID: <20090227145919.19e298b1@hyperion.delvare>
In-Reply-To: <200902271312.10467.hverkuil@xs4all.nl>
References: <20090226214742.6576f30b@pedra.chehab.org>
	<20090227082216.574b42cf@pedra.chehab.org>
	<200902271253.28283.hverkuil@xs4all.nl>
	<200902271312.10467.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, 27 Feb 2009 13:12:10 +0100, Hans Verkuil wrote:
> Jean, if you are interested in doing this, then use my v4l-dvb-vino2 tree as 
> the starting point. It would be nice to get it all done in one go.

Here you go. The patch below adds the i2c-algo-sgi code to vino. Then
we can delete i2c-algo-sgi altogether, but as this driver isn't part of
the v4l-dvb tree, this has to go through another route (likely my i2c
tree.)

==========

Merge i2c-algo-sgi into its only user, vino. This is a very simple
copy-and-paste approach, although a number of further cleanups are
possible.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
Note: totally untested!

 linux/drivers/media/video/Kconfig |    1 
 linux/drivers/media/video/vino.c  |  169 ++++++++++++++++++++++++++++++++++---
 2 files changed, 156 insertions(+), 14 deletions(-)

--- v4l-dvb-vino2.orig/linux/drivers/media/video/Kconfig	2009-02-27 13:21:39.000000000 +0100
+++ v4l-dvb-vino2/linux/drivers/media/video/Kconfig	2009-02-27 13:46:55.000000000 +0100
@@ -582,7 +582,6 @@ config VIDEO_SAA5249
 config VIDEO_VINO
 	tristate "SGI Vino Video For Linux (EXPERIMENTAL)"
 	depends on I2C && SGI_IP22 && EXPERIMENTAL && VIDEO_V4L2
-	select I2C_ALGO_SGI
 	select VIDEO_SAA7191 if VIDEO_HELPER_CHIPS_AUTO
 	help
 	  Say Y here to build in support for the Vino video input system found
--- v4l-dvb-vino2.orig/linux/drivers/media/video/vino.c	2009-02-27 13:21:40.000000000 +0100
+++ v4l-dvb-vino2/linux/drivers/media/video/vino.c	2009-02-27 14:56:52.000000000 +0100
@@ -33,7 +33,6 @@
 #include <linux/kmod.h>
 
 #include <linux/i2c.h>
-#include <linux/i2c-algo-sgi.h>
 
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
@@ -141,6 +140,20 @@ MODULE_LICENSE("GPL");
 
 #define VINO_DATA_NORM_COUNT		4
 
+/* I2C controller flags */
+#define SGI_I2C_FORCE_IDLE		(0 << 0)
+#define SGI_I2C_NOT_IDLE		(1 << 0)
+#define SGI_I2C_WRITE			(0 << 1)
+#define SGI_I2C_READ			(1 << 1)
+#define SGI_I2C_RELEASE_BUS		(0 << 2)
+#define SGI_I2C_HOLD_BUS		(1 << 2)
+#define SGI_I2C_XFER_DONE		(0 << 4)
+#define SGI_I2C_XFER_BUSY		(1 << 4)
+#define SGI_I2C_ACK			(0 << 5)
+#define SGI_I2C_NACK			(1 << 5)
+#define SGI_I2C_BUS_OK			(0 << 7)
+#define SGI_I2C_BUS_ERR			(1 << 7)
+
 /* Internal data structure definitions */
 
 struct vino_input {
@@ -640,6 +653,17 @@ struct v4l2_queryctrl vino_saa7191_v4l2_
 
 /* VINO I2C bus functions */
 
+struct i2c_algo_sgi_data {
+	void *data;	/* private data for lowlevel routines */
+	unsigned (*getctrl)(void *data);
+	void (*setctrl)(void *data, unsigned val);
+	unsigned (*rdata)(void *data);
+	void (*wdata)(void *data, unsigned val);
+
+	int xfer_timeout;
+	int ack_timeout;
+};
+
 unsigned i2c_vino_getctrl(void *data)
 {
 	return vino->i2c_control;
@@ -670,6 +694,134 @@ static struct i2c_algo_sgi_data i2c_sgi_
 	.ack_timeout  = 1000,
 };
 
+static int wait_xfer_done(struct i2c_algo_sgi_data *adap)
+{
+	int i;
+
+	for (i = 0; i < adap->xfer_timeout; i++) {
+		if ((adap->getctrl(adap->data) & SGI_I2C_XFER_BUSY) == 0)
+			return 0;
+		udelay(1);
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int wait_ack(struct i2c_algo_sgi_data *adap)
+{
+	int i;
+
+	if (wait_xfer_done(adap))
+		return -ETIMEDOUT;
+	for (i = 0; i < adap->ack_timeout; i++) {
+		if ((adap->getctrl(adap->data) & SGI_I2C_NACK) == 0)
+			return 0;
+		udelay(1);
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int force_idle(struct i2c_algo_sgi_data *adap)
+{
+	int i;
+
+	adap->setctrl(adap->data, SGI_I2C_FORCE_IDLE);
+	for (i = 0; i < adap->xfer_timeout; i++) {
+		if ((adap->getctrl(adap->data) & SGI_I2C_NOT_IDLE) == 0)
+			goto out;
+		udelay(1);
+	}
+	return -ETIMEDOUT;
+out:
+	if (adap->getctrl(adap->data) & SGI_I2C_BUS_ERR)
+		return -EIO;
+	return 0;
+}
+
+static int do_address(struct i2c_algo_sgi_data *adap, unsigned int addr,
+		      int rd)
+{
+	if (rd)
+		adap->setctrl(adap->data, SGI_I2C_NOT_IDLE);
+	/* Check if bus is idle, eventually force it to do so */
+	if (adap->getctrl(adap->data) & SGI_I2C_NOT_IDLE)
+		if (force_idle(adap))
+			return -EIO;
+	/* Write out the i2c chip address and specify operation */
+	adap->setctrl(adap->data,
+		      SGI_I2C_HOLD_BUS | SGI_I2C_WRITE | SGI_I2C_NOT_IDLE);
+	if (rd)
+		addr |= 1;
+	adap->wdata(adap->data, addr);
+	if (wait_ack(adap))
+		return -EIO;
+	return 0;
+}
+
+static int i2c_read(struct i2c_algo_sgi_data *adap, unsigned char *buf,
+		    unsigned int len)
+{
+	int i;
+
+	adap->setctrl(adap->data,
+		      SGI_I2C_HOLD_BUS | SGI_I2C_READ | SGI_I2C_NOT_IDLE);
+	for (i = 0; i < len; i++) {
+		if (wait_xfer_done(adap))
+			return -EIO;
+		buf[i] = adap->rdata(adap->data);
+	}
+	adap->setctrl(adap->data, SGI_I2C_RELEASE_BUS | SGI_I2C_FORCE_IDLE);
+
+	return 0;
+
+}
+
+static int i2c_write(struct i2c_algo_sgi_data *adap, unsigned char *buf,
+		     unsigned int len)
+{
+	int i;
+
+	/* We are already in write state */
+	for (i = 0; i < len; i++) {
+		adap->wdata(adap->data, buf[i]);
+		if (wait_ack(adap))
+			return -EIO;
+	}
+	return 0;
+}
+
+static int sgi_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
+		    int num)
+{
+	struct i2c_algo_sgi_data *adap = i2c_adap->algo_data;
+	struct i2c_msg *p;
+	int i, err = 0;
+
+	for (i = 0; !err && i < num; i++) {
+		p = &msgs[i];
+		err = do_address(adap, p->addr, p->flags & I2C_M_RD);
+		if (err || !p->len)
+			continue;
+		if (p->flags & I2C_M_RD)
+			err = i2c_read(adap, p->buf, p->len);
+		else
+			err = i2c_write(adap, p->buf, p->len);
+	}
+
+	return (err < 0) ? err : i;
+}
+
+static u32 sgi_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_SMBUS_EMUL;
+}
+
+static const struct i2c_algorithm sgi_algo = {
+	.master_xfer	= sgi_xfer,
+	.functionality	= sgi_func,
+};
+
 /*
  * There are two possible clients on VINO I2C bus, so we limit usage only
  * to them.
@@ -727,21 +879,12 @@ static struct i2c_adapter vino_i2c_adapt
 {
 	.name			= "VINO I2C bus",
 	.id			= I2C_HW_SGI_VINO,
+	.algo			= &sgi_algo,
 	.algo_data		= &i2c_sgi_vino_data,
 	.client_register	= &i2c_vino_client_reg,
 	.client_unregister	= &i2c_vino_client_unreg,
 };
 
-static int vino_i2c_add_bus(void)
-{
-	return i2c_sgi_add_bus(&vino_i2c_adapter);
-}
-
-static int vino_i2c_del_bus(void)
-{
-	return i2c_del_adapter(&vino_i2c_adapter);
-}
-
 static int i2c_camera_command(unsigned int cmd, void *arg)
 {
 	return vino_drvdata->camera.driver->
@@ -4079,7 +4222,7 @@ static void vino_module_cleanup(int stag
 		video_unregister_device(vino_drvdata->a.vdev);
 		vino_drvdata->a.vdev = NULL;
 	case 9:
-		vino_i2c_del_bus();
+		i2c_del_adapter(&vino_i2c_adapter);
 	case 8:
 		free_irq(SGI_VINO_IRQ, NULL);
 	case 7:
@@ -4301,7 +4444,7 @@ static int __init vino_module_init(void)
 	}
 	vino_init_stage++;
 
-	ret = vino_i2c_add_bus();
+	ret = i2c_add_adapter(&vino_i2c_adapter);
 	if (ret) {
 		printk(KERN_ERR "VINO I2C bus registration failed\n");
 		vino_module_cleanup(vino_init_stage);

-- 
Jean Delvare
