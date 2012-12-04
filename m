Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:1609 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2LDQIH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2012 11:08:07 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: dheitmueller@kernellabs.com, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 1/2] au0828: remove forced dependency of VIDEO_AU0828 on VIDEO_V4L2
Date: Tue,  4 Dec 2012 11:07:44 -0500
Message-Id: <1354637265-23335-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes the dependendency of VIDEO_AU0828 on VIDEO_V4L2 by
creating a new Kconfig option, VIDEO_AU0828_V4L2, which enables analog
video capture support and depends on VIDEO_V4L2 itself.

With VIDEO_AU0828_V4L2 disabled, the driver will only support digital
television and will not depend on the v4l2-core. With VIDEO_AU0828_V4L2
enabled, the driver will be built with the analog v4l2 support included.

By default, the VIDEO_AU0828_V4L2 option will be set to Y, so as to
preserve the original behavior.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/usb/Kconfig               |    2 +-
 drivers/media/usb/au0828/Kconfig        |   17 ++++++++++++++---
 drivers/media/usb/au0828/Makefile       |    6 +++++-
 drivers/media/usb/au0828/au0828-cards.c |    4 ++++
 drivers/media/usb/au0828/au0828-core.c  |   13 ++++++++++++-
 drivers/media/usb/au0828/au0828-i2c.c   |    4 ++++
 drivers/media/usb/au0828/au0828.h       |    2 ++
 7 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index 6746994..0a7d520 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -21,7 +21,6 @@ endif
 
 if MEDIA_ANALOG_TV_SUPPORT
 	comment "Analog TV USB devices"
-source "drivers/media/usb/au0828/Kconfig"
 source "drivers/media/usb/pvrusb2/Kconfig"
 source "drivers/media/usb/hdpvr/Kconfig"
 source "drivers/media/usb/tlg2300/Kconfig"
@@ -31,6 +30,7 @@ endif
 
 if (MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT)
 	comment "Analog/digital TV USB devices"
+source "drivers/media/usb/au0828/Kconfig"
 source "drivers/media/usb/cx231xx/Kconfig"
 source "drivers/media/usb/tm6000/Kconfig"
 endif
diff --git a/drivers/media/usb/au0828/Kconfig b/drivers/media/usb/au0828/Kconfig
index 1766c0c..953a37c 100644
--- a/drivers/media/usb/au0828/Kconfig
+++ b/drivers/media/usb/au0828/Kconfig
@@ -1,17 +1,28 @@
 
 config VIDEO_AU0828
 	tristate "Auvitek AU0828 support"
-	depends on I2C && INPUT && DVB_CORE && USB && VIDEO_V4L2
+	depends on I2C && INPUT && DVB_CORE && USB
 	select I2C_ALGOBIT
 	select VIDEO_TVEEPROM
 	select VIDEOBUF_VMALLOC
 	select DVB_AU8522_DTV if MEDIA_SUBDRV_AUTOSELECT
-	select DVB_AU8522_V4L if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MXL5007T if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
-	  This is a video4linux driver for Auvitek's USB device.
+	  This is a hybrid analog/digital tv capture driver for
+	  Auvitek's AU0828 USB device.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called au0828
+
+config VIDEO_AU0828_V4L2
+	bool "Auvitek AU0828 v4l2 analog video support"
+	depends on VIDEO_AU0828 && VIDEO_V4L2
+	select DVB_AU8522_V4L if MEDIA_SUBDRV_AUTOSELECT
+	default y
+	---help---
+	  This is a video4linux driver for Auvitek's USB device.
+
+	  Choose Y here to include support for v4l2 analog video
+	  capture within the au0828 driver.
diff --git a/drivers/media/usb/au0828/Makefile b/drivers/media/usb/au0828/Makefile
index 98cc20c..be3bdf6 100644
--- a/drivers/media/usb/au0828/Makefile
+++ b/drivers/media/usb/au0828/Makefile
@@ -1,4 +1,8 @@
-au0828-objs	:= au0828-core.o au0828-i2c.o au0828-cards.o au0828-dvb.o au0828-video.o au0828-vbi.o
+au0828-objs	:= au0828-core.o au0828-i2c.o au0828-cards.o au0828-dvb.o
+
+ifeq ($(CONFIG_VIDEO_AU0828_V4L2),y)
+  au0828-objs   += au0828-video.o au0828-vbi.o
+endif
 
 obj-$(CONFIG_VIDEO_AU0828) += au0828.o
 
diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index cf309d8..7b5b742 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -188,9 +188,11 @@ static void hauppauge_eeprom(struct au0828_dev *dev, u8 *eeprom_data)
 void au0828_card_setup(struct au0828_dev *dev)
 {
 	static u8 eeprom[256];
+#ifdef CONFIG_VIDEO_AU0828_V4L2
 	struct tuner_setup tun_setup;
 	struct v4l2_subdev *sd;
 	unsigned int mode_mask = T_ANALOG_TV;
+#endif
 
 	dprintk(1, "%s()\n", __func__);
 
@@ -211,6 +213,7 @@ void au0828_card_setup(struct au0828_dev *dev)
 		break;
 	}
 
+#ifdef CONFIG_VIDEO_AU0828_V4L2
 	if (AUVI_INPUT(0).type != AU0828_VMUX_UNDEFINED) {
 		/* Load the analog demodulator driver (note this would need to
 		   be abstracted out if we ever need to support a different
@@ -236,6 +239,7 @@ void au0828_card_setup(struct au0828_dev *dev)
 		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_type_addr,
 				     &tun_setup);
 	}
+#endif
 }
 
 /*
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 745a80a..1e6f40e 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -134,13 +134,17 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	/* Digital TV */
 	au0828_dvb_unregister(dev);
 
+#ifdef CONFIG_VIDEO_AU0828_V4L2
 	if (AUVI_INPUT(0).type != AU0828_VMUX_UNDEFINED)
 		au0828_analog_unregister(dev);
+#endif
 
 	/* I2C */
 	au0828_i2c_unregister(dev);
 
+#ifdef CONFIG_VIDEO_AU0828_V4L2
 	v4l2_device_unregister(&dev->v4l2_dev);
+#endif
 
 	usb_set_intfdata(interface, NULL);
 
@@ -155,7 +159,10 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 static int au0828_usb_probe(struct usb_interface *interface,
 	const struct usb_device_id *id)
 {
-	int ifnum, retval;
+	int ifnum;
+#ifdef CONFIG_VIDEO_AU0828_V4L2
+	int retval;
+#endif
 	struct au0828_dev *dev;
 	struct usb_device *usbdev = interface_to_usbdev(interface);
 
@@ -194,6 +201,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	dev->usbdev = usbdev;
 	dev->boardnr = id->driver_info;
 
+#ifdef CONFIG_VIDEO_AU0828_V4L2
 	/* Create the v4l2_device */
 	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
@@ -203,6 +211,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
 		kfree(dev);
 		return -EIO;
 	}
+#endif
 
 	/* Power Up the bridge */
 	au0828_write(dev, REG_600, 1 << 4);
@@ -216,9 +225,11 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	/* Setup */
 	au0828_card_setup(dev);
 
+#ifdef CONFIG_VIDEO_AU0828_V4L2
 	/* Analog TV */
 	if (AUVI_INPUT(0).type != AU0828_VMUX_UNDEFINED)
 		au0828_analog_register(dev, interface);
+#endif
 
 	/* Digital TV */
 	au0828_dvb_register(dev);
diff --git a/drivers/media/usb/au0828/au0828-i2c.c b/drivers/media/usb/au0828/au0828-i2c.c
index 4ded17f..20d69b5 100644
--- a/drivers/media/usb/au0828/au0828-i2c.c
+++ b/drivers/media/usb/au0828/au0828-i2c.c
@@ -378,7 +378,11 @@ int au0828_i2c_register(struct au0828_dev *dev)
 
 	dev->i2c_adap.algo = &dev->i2c_algo;
 	dev->i2c_adap.algo_data = dev;
+#ifdef CONFIG_VIDEO_AU0828_V4L2
 	i2c_set_adapdata(&dev->i2c_adap, &dev->v4l2_dev);
+#else
+	i2c_set_adapdata(&dev->i2c_adap, dev);
+#endif
 	i2c_add_adapter(&dev->i2c_adap);
 
 	dev->i2c_client.adapter = &dev->i2c_adap;
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 66a56ef..e579ff6 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -199,8 +199,10 @@ struct au0828_dev {
 	struct au0828_dvb		dvb;
 	struct work_struct              restart_streaming;
 
+#ifdef CONFIG_VIDEO_AU0828_V4L2
 	/* Analog */
 	struct v4l2_device v4l2_dev;
+#endif
 	int users;
 	unsigned int resources;	/* resources in use */
 	struct video_device *vdev;
-- 
1.7.10.4

