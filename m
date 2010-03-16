Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:58133 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934469Ab0CPCuD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 22:50:03 -0400
Received: by bwz1 with SMTP id 1so3535801bwz.21
        for <linux-media@vger.kernel.org>; Mon, 15 Mar 2010 19:50:00 -0700 (PDT)
Date: Tue, 16 Mar 2010 11:50:59 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Add SPI support to V4L2
Message-ID: <20100316115059.7e1c0530@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/NiFe61vPTmUEVC+QeD2Q8he"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/NiFe61vPTmUEVC+QeD2Q8he
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Add support SPI bus to v4l2. Useful for control some device with SPI bus like
hardware MPEG2 encoders and etc.

diff -r b6b82258cf5e linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/v4l2-common.c	Tue Mar 16 05:06:04 2010 +0900
@@ -63,6 +63,10 @@
 
 #include <linux/videodev2.h>
 #include "compat.h"
+
+#if defined(CONFIG_SPI)
+#include <linux/spi/spi.h>
+#endif
 
 MODULE_AUTHOR("Bill Dirks, Justin Schoeman, Gerd Knorr");
 MODULE_DESCRIPTION("misc helper functions for v4l2 device drivers");
@@ -1069,6 +1073,66 @@
 
 #endif /* defined(CONFIG_I2C) */
 
+#if defined(CONFIG_SPI)
+
+/* Load a spi sub-device. */
+
+void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
+		const struct v4l2_subdev_ops *ops)
+{
+	v4l2_subdev_init(sd, ops);
+	sd->flags |= V4L2_SUBDEV_FL_IS_SPI;
+	/* the owner is the same as the spi_device's driver owner */
+	sd->owner = spi->dev.driver->owner;
+	/* spi_device and v4l2_subdev point to one another */
+	v4l2_set_subdevdata(sd, spi);
+	spi_set_drvdata(spi, sd);
+	/* initialize name */
+	strlcpy(sd->name, spi->dev.driver->name, sizeof(sd->name));
+}
+EXPORT_SYMBOL_GPL(v4l2_spi_subdev_init);
+
+struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
+		struct spi_master *master, struct spi_board_info *info)
+{
+	struct v4l2_subdev *sd = NULL;
+	struct spi_device *spi = NULL;
+
+	BUG_ON(!v4l2_dev);
+
+	if (info->modalias)
+		request_module(info->modalias);
+
+	spi = spi_new_device(master, info);
+
+	if (spi == NULL || spi->dev.driver == NULL)
+		goto error;
+
+	if (!try_module_get(spi->dev.driver->owner))
+		goto error;
+
+	sd = spi_get_drvdata(spi);
+
+	/* Register with the v4l2_device which increases the module's
+	   use count as well. */
+	if (v4l2_device_register_subdev(v4l2_dev, sd))
+		sd = NULL;
+
+	/* Decrease the module use count to match the first try_module_get. */
+	module_put(spi->dev.driver->owner);
+
+error:
+	/* If we have a client but no subdev, then something went wrong and
+	   we must unregister the client. */
+	if (spi && sd == NULL)
+		spi_unregister_device(spi);
+
+	return sd;
+}
+EXPORT_SYMBOL_GPL(v4l2_spi_new_subdev);
+
+#endif /* defined(CONFIG_SPI) */
+
 /* Clamp x to be between min and max, aligned to a multiple of 2^align.  min
  * and max don't have to be aligned, but there must be at least one valid
  * value.  E.g., min=17,max=31,align=4 is not allowed as there are no multiples
diff -r b6b82258cf5e linux/drivers/media/video/v4l2-device.c
--- a/linux/drivers/media/video/v4l2-device.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/v4l2-device.c	Tue Mar 16 05:06:04 2010 +0900
@@ -24,6 +24,10 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include "compat.h"
+
+#if defined(CONFIG_SPI)
+#include <linux/spi/spi.h>
+#endif
 
 int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
 {
@@ -100,6 +104,14 @@
 		}
 #endif
 #endif
+#if defined(CONFIG_SPI)
+		if (sd->flags & V4L2_SUBDEV_FL_IS_SPI) {
+			struct spi_device *spi = v4l2_get_subdevdata(sd);
+
+			if (spi)
+				spi_unregister_device(spi);
+		}
+#endif
 	}
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister);
diff -r b6b82258cf5e linux/include/media/v4l2-common.h
--- a/linux/include/media/v4l2-common.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-common.h	Tue Mar 16 05:06:04 2010 +0900
@@ -191,6 +191,24 @@
 
 /* ------------------------------------------------------------------------- */
 
+/* SPI Helper functions */
+#if defined(CONFIG_SPI)
+
+#include <linux/spi/spi.h>
+
+struct spi_device;
+
+/* Load an spi module and return an initialized v4l2_subdev struct.
+   The client_type argument is the name of the chip that's on the adapter. */
+struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
+		struct spi_master *master, struct spi_board_info *info);
+
+/* Initialize an v4l2_subdev with data from an spi_device struct */
+void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
+		const struct v4l2_subdev_ops *ops);
+#endif
+/* ------------------------------------------------------------------------- */
+
 /* Note: these remaining ioctls/structs should be removed as well, but they are
    still used in tuner-simple.c (TUNER_SET_CONFIG), cx18/ivtv (RESET) and
    v4l2-int-device.h (v4l2_routing). To remove these ioctls some more cleanup
diff -r b6b82258cf5e linux/include/media/v4l2-subdev.h
--- a/linux/include/media/v4l2-subdev.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-subdev.h	Tue Mar 16 05:06:04 2010 +0900
@@ -387,6 +387,8 @@
 
 /* Set this flag if this subdev is a i2c device. */
 #define V4L2_SUBDEV_FL_IS_I2C (1U << 0)
+/* Set this flag if this subdev is a spi device. */
+#define V4L2_SUBDEV_FL_IS_SPI (1U << 1)
 
 /* Each instance of a subdev driver should create this struct, either
    stand-alone or embedded in a larger struct.

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.

--MP_/NiFe61vPTmUEVC+QeD2Q8he
Content-Type: text/x-patch; name=v4l2_spi.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=v4l2_spi.patch

diff -r b6b82258cf5e linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/v4l2-common.c	Tue Mar 16 05:06:04 2010 +0900
@@ -63,6 +63,10 @@
 
 #include <linux/videodev2.h>
 #include "compat.h"
+
+#if defined(CONFIG_SPI)
+#include <linux/spi/spi.h>
+#endif
 
 MODULE_AUTHOR("Bill Dirks, Justin Schoeman, Gerd Knorr");
 MODULE_DESCRIPTION("misc helper functions for v4l2 device drivers");
@@ -1069,6 +1073,66 @@
 
 #endif /* defined(CONFIG_I2C) */
 
+#if defined(CONFIG_SPI)
+
+/* Load a spi sub-device. */
+
+void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
+		const struct v4l2_subdev_ops *ops)
+{
+	v4l2_subdev_init(sd, ops);
+	sd->flags |= V4L2_SUBDEV_FL_IS_SPI;
+	/* the owner is the same as the spi_device's driver owner */
+	sd->owner = spi->dev.driver->owner;
+	/* spi_device and v4l2_subdev point to one another */
+	v4l2_set_subdevdata(sd, spi);
+	spi_set_drvdata(spi, sd);
+	/* initialize name */
+	strlcpy(sd->name, spi->dev.driver->name, sizeof(sd->name));
+}
+EXPORT_SYMBOL_GPL(v4l2_spi_subdev_init);
+
+struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
+		struct spi_master *master, struct spi_board_info *info)
+{
+	struct v4l2_subdev *sd = NULL;
+	struct spi_device *spi = NULL;
+
+	BUG_ON(!v4l2_dev);
+
+	if (info->modalias)
+		request_module(info->modalias);
+
+	spi = spi_new_device(master, info);
+
+	if (spi == NULL || spi->dev.driver == NULL)
+		goto error;
+
+	if (!try_module_get(spi->dev.driver->owner))
+		goto error;
+
+	sd = spi_get_drvdata(spi);
+
+	/* Register with the v4l2_device which increases the module's
+	   use count as well. */
+	if (v4l2_device_register_subdev(v4l2_dev, sd))
+		sd = NULL;
+
+	/* Decrease the module use count to match the first try_module_get. */
+	module_put(spi->dev.driver->owner);
+
+error:
+	/* If we have a client but no subdev, then something went wrong and
+	   we must unregister the client. */
+	if (spi && sd == NULL)
+		spi_unregister_device(spi);
+
+	return sd;
+}
+EXPORT_SYMBOL_GPL(v4l2_spi_new_subdev);
+
+#endif /* defined(CONFIG_SPI) */
+
 /* Clamp x to be between min and max, aligned to a multiple of 2^align.  min
  * and max don't have to be aligned, but there must be at least one valid
  * value.  E.g., min=17,max=31,align=4 is not allowed as there are no multiples
diff -r b6b82258cf5e linux/drivers/media/video/v4l2-device.c
--- a/linux/drivers/media/video/v4l2-device.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/v4l2-device.c	Tue Mar 16 05:06:04 2010 +0900
@@ -24,6 +24,10 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include "compat.h"
+
+#if defined(CONFIG_SPI)
+#include <linux/spi/spi.h>
+#endif
 
 int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
 {
@@ -100,6 +104,14 @@
 		}
 #endif
 #endif
+#if defined(CONFIG_SPI)
+		if (sd->flags & V4L2_SUBDEV_FL_IS_SPI) {
+			struct spi_device *spi = v4l2_get_subdevdata(sd);
+
+			if (spi)
+				spi_unregister_device(spi);
+		}
+#endif
 	}
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister);
diff -r b6b82258cf5e linux/include/media/v4l2-common.h
--- a/linux/include/media/v4l2-common.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-common.h	Tue Mar 16 05:06:04 2010 +0900
@@ -191,6 +191,24 @@
 
 /* ------------------------------------------------------------------------- */
 
+/* SPI Helper functions */
+#if defined(CONFIG_SPI)
+
+#include <linux/spi/spi.h>
+
+struct spi_device;
+
+/* Load an spi module and return an initialized v4l2_subdev struct.
+   The client_type argument is the name of the chip that's on the adapter. */
+struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
+		struct spi_master *master, struct spi_board_info *info);
+
+/* Initialize an v4l2_subdev with data from an spi_device struct */
+void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
+		const struct v4l2_subdev_ops *ops);
+#endif
+/* ------------------------------------------------------------------------- */
+
 /* Note: these remaining ioctls/structs should be removed as well, but they are
    still used in tuner-simple.c (TUNER_SET_CONFIG), cx18/ivtv (RESET) and
    v4l2-int-device.h (v4l2_routing). To remove these ioctls some more cleanup
diff -r b6b82258cf5e linux/include/media/v4l2-subdev.h
--- a/linux/include/media/v4l2-subdev.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-subdev.h	Tue Mar 16 05:06:04 2010 +0900
@@ -387,6 +387,8 @@
 
 /* Set this flag if this subdev is a i2c device. */
 #define V4L2_SUBDEV_FL_IS_I2C (1U << 0)
+/* Set this flag if this subdev is a spi device. */
+#define V4L2_SUBDEV_FL_IS_SPI (1U << 1)
 
 /* Each instance of a subdev driver should create this struct, either
    stand-alone or embedded in a larger struct.

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/NiFe61vPTmUEVC+QeD2Q8he--
