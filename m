Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:62828 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbZIBEct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Sep 2009 00:32:49 -0400
Received: by ewy2 with SMTP id 2so443572ewy.17
        for <linux-media@vger.kernel.org>; Tue, 01 Sep 2009 21:32:50 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Sep 2009 00:32:50 -0400
Message-ID: <37219a840909012132l6c04af65hddecd2d52e196bcb@mail.gmail.com>
Subject: [RFC] Allow bridge drivers to have better control over DVB frontend
	operations
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>, Mike Isely <isely@pobox.com>,
	Antti Palosaari <crope@iki.fi>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Over the course of the past year, a number of developers have
expressed a need for giving the bridge drivers better control over
dvb_frontend operations.  Specifically, there is a need for the bridge
driver to receive a DVB frontend IOCTL and have the opportunity to
allow or deny the IOCTL to proceed, as resources permit.

For instance, in the case of a hybrid device, only the bridge driver
knows whether the analog functionality is presently being used.  If
the driver is currently in analog mode, serving video frames, the
driver will have a chance to deny the DVB frontend ioctl request
before dvb-core passes the request on to the frontend driver,
potentially damaging the analog video stream already in progress.

In some cases, the bridge driver might have to perform a setup
operation to use a feature specific to the device.  For instance, the
bridge device may be in a low powered state - this new capability
allows the driver to wake up before passing the command on to the
frontend driver.  This new feature will allow LinuxTV developers to
finally get working on actual power management support within the
v4l/dvb subsystem, without the fear of breaking devices with hybrid
analog / digital functionality.

In other cases, there may be situations in which multiple RF
connectors are available to the tuner, but only the bridge driver will
be aware of this, as this type of thing is specific to the device's
hardware implementation.  As there are many tuners capable of multiple
RF spigots, not all devices actually employ this feature - only the
bridge driver knows what implementations support such features, and
how to enable / disable them.

The possibilities are endless.  I actually did all the heavy lifting
involved in this a few months ago, but haven't had a moment to write
up this RFC until now.

The change to dvb-core that allows this new functionality is posted to
my development repository on kernellabs.com.  I have also included an
example of how this can be used on a digital tuner board with multiple
RF inputs.  The multiple RF input switching is already supported in
today's code, but I promised Mauro that I would present a better
method of doing this before the upcoming merge window.  For your
review and comments, please take a look at the topmost changesets,
starting with "create a standard method for dvb adapter drivers to
override frontend ioctls":

http://kernellabs.com/hg/~mkrufky/fe_ioctl_override

For those that would prefer not to open up a web browser, here are the
core changes (apologies if whitespace becomes broken):

--- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Tue Jun 16
16:08:17 2009 -0400
+++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Sat May 23
17:00:59 2009 -0400
@@ -1594,7 +1594,18 @@
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	int err = -EOPNOTSUPP;
+	int cb_err, err = -EOPNOTSUPP;
+
+	if (fe->dvb->fe_ioctl_override) {
+		cb_err = fe->dvb->fe_ioctl_override(fe, cmd, parg,
+						    DVB_FE_IOCTL_PRE);
+		if (cb_err < 0)
+			return cb_err;
+		if (cb_err > 0)
+			return 0;
+		/* fe_ioctl_override returning 0 allows
+		 * dvb-core to continue handling the ioctl */
+	}

 	switch (cmd) {
 	case FE_GET_INFO: {
@@ -1858,6 +1869,13 @@
 		err = 0;
 		break;
 	};
+
+	if (fe->dvb->fe_ioctl_override) {
+		cb_err = fe->dvb->fe_ioctl_override(fe, cmd, parg,
+						    DVB_FE_IOCTL_POST);
+		if (cb_err < 0)
+			return cb_err;
+	}

 	return err;
 }
--- a/linux/drivers/media/dvb/dvb-core/dvbdev.h	Tue Jun 16 16:08:17 2009 -0400
+++ b/linux/drivers/media/dvb/dvb-core/dvbdev.h	Sat May 23 17:00:59 2009 -0400
@@ -51,6 +51,8 @@
 	module_param_array(adapter_nr, short, NULL, 0444); \
 	MODULE_PARM_DESC(adapter_nr, "DVB adapter numbers")

+struct dvb_frontend;
+
 struct dvb_adapter {
 	int num;
 	struct list_head list_head;
@@ -66,6 +68,32 @@
 	int mfe_shared;			/* indicates mutually exclusive frontends */
 	struct dvb_device *mfe_dvbdev;	/* frontend device in use */
 	struct mutex mfe_lock;		/* access lock for thread creation */
+
+	/* Allow the adapter/bridge driver to perform an action before and/or
+	 * after the core handles an ioctl:
+	 *
+	 * DVB_FE_IOCTL_PRE indicates that the ioctl has not yet been handled.
+	 * DVB_FE_IOCTL_POST indicates that the ioctl has been handled.
+	 *
+	 * When DVB_FE_IOCTL_PRE is passed to the callback as the stage arg:
+	 *
+	 * return 0 to allow dvb-core to handle the ioctl.
+	 * return a positive int to prevent dvb-core from handling the ioctl,
+	 * 	and exit without error.
+	 * return a negative int to prevent dvb-core from handling the ioctl,
+	 * 	and return that value as an error.
+	 *
+	 * When DVB_FE_IOCTL_POST is passed to the callback as the stage arg:
+	 *
+	 * return 0 to allow the dvb_frontend ioctl handler to exit normally.
+	 * return a negative int to cause the dvb_frontend ioctl handler to
+	 * 	return that value as an error.
+	 */
+#define DVB_FE_IOCTL_PRE 0
+#define DVB_FE_IOCTL_POST 1
+	int (*fe_ioctl_override)(struct dvb_frontend *fe,
+				 unsigned int cmd, void *parg,
+				 unsigned int stage);
 };





As you can see from the changeset, this allows the bridge to assert
control both before and after the frontend driver itself handles the
operation.  Depending on the value returned by the bridge driver,
dvb-core can exit with error, proceed unchanged, or exit without
error.

In order to allow some drivers to use the new feature, I had to make a
small change to videobuf-dvb:

--- a/linux/drivers/media/video/videobuf-dvb.c	Tue Jun 16 16:08:17 2009 -0400
+++ b/linux/drivers/media/video/videobuf-dvb.c	Sat May 23 17:00:59 2009 -0400
@@ -144,7 +144,9 @@
 			  struct device *device,
 			  char *adapter_name,
 			  short *adapter_nr,
-			  int mfe_shared)
+			  int mfe_shared,
+			  int (*fe_ioctl_override)(struct dvb_frontend *,
+					unsigned int, void *, unsigned int))
 {
 	int result;

@@ -159,6 +161,7 @@
 	}
 	fe->adapter.priv = adapter_priv;
 	fe->adapter.mfe_shared = mfe_shared;
+	fe->adapter.fe_ioctl_override = fe_ioctl_override;

 	return result;
 }
@@ -258,7 +261,9 @@
 			  void *adapter_priv,
 			  struct device *device,
 			  short *adapter_nr,
-			  int mfe_shared)
+			  int mfe_shared,
+			  int (*fe_ioctl_override)(struct dvb_frontend *,
+					unsigned int, void *, unsigned int))
 {
 	struct list_head *list, *q;
 	struct videobuf_dvb_frontend *fe;
@@ -272,7 +277,7 @@

 	/* Bring up the adapter */
 	res = videobuf_dvb_register_adapter(f, module, adapter_priv, device,
-		fe->dvb.name, adapter_nr, mfe_shared);
+		fe->dvb.name, adapter_nr, mfe_shared, fe_ioctl_override);
 	if (res < 0) {
 		printk(KERN_WARNING "videobuf_dvb_register_adapter failed (errno =
%d)\n", res);
 		return res;
--- a/linux/include/media/videobuf-dvb.h	Tue Jun 16 16:08:17 2009 -0400
+++ b/linux/include/media/videobuf-dvb.h	Sat May 23 17:00:59 2009 -0400
@@ -42,7 +42,9 @@
 			  void *adapter_priv,
 			  struct device *device,
 			  short *adapter_nr,
-			  int mfe_shared);
+			  int mfe_shared,
+			  int (*fe_ioctl_override)(struct dvb_frontend *,
+					unsigned int, void *, unsigned int));

 void videobuf_dvb_unregister_bus(struct videobuf_dvb_frontends *f);

--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c	Tue Jun 16
16:08:17 2009 -0400
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c	Sat May 23
17:00:59 2009 -0400
@@ -856,7 +856,7 @@

 	/* register everything */
 	ret = videobuf_dvb_register_bus(&port->frontends, THIS_MODULE, port,
-		&dev->pci->dev, adapter_nr, 0);
+					&dev->pci->dev, adapter_nr, 0, NULL);

 	/* init CI & MAC */
 	switch (dev->board) {
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Tue Jun 16 16:08:17 2009 -0400
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Sat May 23 17:00:59 2009 -0400
@@ -1180,7 +1180,7 @@

 	/* register everything */
 	return videobuf_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
-		&dev->pci->dev, adapter_nr, mfe_shared);
+					 &dev->pci->dev, adapter_nr, mfe_shared, NULL);

 frontend_detach:
 	core->gate_ctrl = NULL;
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Tue Jun 16
16:08:17 2009 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sat May 23
17:00:59 2009 -0400
@@ -1509,7 +1509,7 @@

 	/* register everything else */
 	ret = videobuf_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
-		&dev->pci->dev, adapter_nr, 0);
+					&dev->pci->dev, adapter_nr, 0, NULL);

 	/* this sequence is necessary to make the tda1004x load its firmware
 	 * and to enter analog mode of hybrid boards




Finally, the actual implementation of this new feature in the cx23885
driver for the sake of RF input switching:

--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c	Sat May 23
17:00:59 2009 -0400
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c	Fri May 08
21:39:24 2009 -0400
@@ -484,9 +484,33 @@
 		}
 		break;
 	}
-	return (port->set_frontend_save) ?
-		port->set_frontend_save(fe, param) : -ENODEV;
+	return 0;
 }
+
+static int cx23885_dvb_fe_ioctl_override(struct dvb_frontend *fe,
+					 unsigned int cmd, void *parg,
+					 unsigned int stage)
+{
+	int err = 0;
+
+	switch (stage) {
+	case DVB_FE_IOCTL_PRE:
+
+		switch (cmd) {
+		case FE_SET_FRONTEND:
+			err = cx23885_dvb_set_frontend(fe,
+				(struct dvb_frontend_parameters *) parg);
+			break;
+		}
+		break;
+
+	case DVB_FE_IOCTL_POST:
+		/* no post-ioctl handling required */
+		break;
+	}
+	return err;
+};
+

 static int dvb_register(struct cx23885_tsport *port)
 {
@@ -527,12 +551,6 @@
 				   0x60, &dev->i2c_bus[1].i2c_adap,
 				   &hauppauge_hvr127x_config);
 		}
-
-		/* FIXME: temporary hack */
-		/* define bridge override to set_frontend */
-		port->set_frontend_save = fe0->dvb.frontend->ops.set_frontend;
-		fe0->dvb.frontend->ops.set_frontend = cx23885_dvb_set_frontend;
-
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1255:
 		i2c_bus = &dev->i2c_bus[0];
@@ -856,7 +874,8 @@

 	/* register everything */
 	ret = videobuf_dvb_register_bus(&port->frontends, THIS_MODULE, port,
-					&dev->pci->dev, adapter_nr, 0, NULL);
+					&dev->pci->dev, adapter_nr, 0,
+					cx23885_dvb_fe_ioctl_override);

 	/* init CI & MAC */
 	switch (dev->board) {
--- a/linux/drivers/media/video/cx23885/cx23885.h	Sat May 23 17:00:59 2009 -0400
+++ b/linux/drivers/media/video/cx23885/cx23885.h	Fri May 08 21:39:24 2009 -0400
@@ -289,10 +289,6 @@
 	/* Allow a single tsport to have multiple frontends */
 	u32                        num_frontends;
 	void                       *port_priv;
-
-	/* FIXME: temporary hack */
-	int (*set_frontend_save) (struct dvb_frontend *,
-				  struct dvb_frontend_parameters *);
 };

 struct cx23885_dev {




Again, the above changeset simply removes the old RF input path
switching hack, and implements the feature using the new frontend
ioctl override method instead.  This is a much cleaner and more more
robust way to handle this, which actually opening doors for other
drivers to handle similar problems in a much more efficient manner.

Please voice your comments about this particular change and any of its
implications in this thread.  If all goes well, I'd like to merge this
into the master repository in time for the next merge window.  Once
this is in the master branch, I can start working on removing other
similar hacks from other drivers in our tree, in favor of this better
method.

Cheers,

Michael Krufky
