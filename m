Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:49332 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab0CQEIt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 00:08:49 -0400
Received: by fxm19 with SMTP id 19so675544fxm.21
        for <linux-media@vger.kernel.org>; Tue, 16 Mar 2010 21:08:46 -0700 (PDT)
Date: Wed, 17 Mar 2010 13:09:47 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [RESEND, PATCH] Add SPI support to V4L2
Message-ID: <20100317130947.4eb84471@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/CVYTTBd/c2D4Sfv.vHgbNPr"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/CVYTTBd/c2D4Sfv.vHgbNPr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Add support SPI bus to v4l2. Useful for control some device with SPI bus like
hardware MPEG2 encoders and etc.

Small patch rework after reply from Hans.

diff -r b6b82258cf5e linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/v4l2-common.c	Wed Mar 17 04:53:52 2010 +0900
@@ -51,6 +51,9 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/i2c.h>
+#if defined(CONFIG_SPI)
+#include <linux/spi/spi.h>
+#endif
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
@@ -1069,6 +1072,66 @@
 
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
+++ b/linux/drivers/media/video/v4l2-device.c	Wed Mar 17 04:53:52 2010 +0900
@@ -21,6 +21,9 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/i2c.h>
+#if defined(CONFIG_SPI)
+#include <linux/spi/spi.h>
+#endif
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include "compat.h"
@@ -100,6 +103,14 @@
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
+++ b/linux/include/media/v4l2-common.h	Wed Mar 17 04:53:52 2010 +0900
@@ -191,6 +191,25 @@
 
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
+
+/* ------------------------------------------------------------------------- */
+
 /* Note: these remaining ioctls/structs should be removed as well, but they are
    still used in tuner-simple.c (TUNER_SET_CONFIG), cx18/ivtv (RESET) and
    v4l2-int-device.h (v4l2_routing). To remove these ioctls some more cleanup
diff -r b6b82258cf5e linux/include/media/v4l2-subdev.h
--- a/linux/include/media/v4l2-subdev.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-subdev.h	Wed Mar 17 04:53:52 2010 +0900
@@ -387,6 +387,8 @@
 
 /* Set this flag if this subdev is a i2c device. */
 #define V4L2_SUBDEV_FL_IS_I2C (1U << 0)
+/* Set this flag if this subdev is a spi device. */
+#define V4L2_SUBDEV_FL_IS_SPI (1U << 1)
 
 /* Each instance of a subdev driver should create this struct, either
    stand-alone or embedded in a larger struct.
diff -r b6b82258cf5e v4l/compat.h
--- a/v4l/compat.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/v4l/compat.h	Wed Mar 17 04:53:52 2010 +0900
@@ -525,5 +525,19 @@
 #define strcasecmp(a, b) strnicmp(a, b, sizeof(a))
 #endif
 
+/* Compatibility code for SPI subsystem */
+#ifdef _LINUX_SPI_H
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 21)
+static inline void spi_set_drvdata(struct spi_device *spi, void *data)
+{
+	dev_set_drvdata(&spi->dev, data);
+}
+
+static inline void spi_get_drvdata(struct spi_device *spi)
+{
+	return dev_get_drvdata(&spi->dev);
+}
+#endif
+#endif
 
 #endif /*  _COMPAT_H */

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>


With my best regards, Dmitry.

--MP_/CVYTTBd/c2D4Sfv.vHgbNPr
Content-Type: text/x-patch; name=v4l2_spi.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=v4l2_spi.patch

diff -r b6b82258cf5e linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/v4l2-common.c	Wed Mar 17 04:53:52 2010 +0900
@@ -51,6 +51,9 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/i2c.h>
+#if defined(CONFIG_SPI)
+#include <linux/spi/spi.h>
+#endif
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
@@ -1069,6 +1072,66 @@
 
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
+++ b/linux/drivers/media/video/v4l2-device.c	Wed Mar 17 04:53:52 2010 +0900
@@ -21,6 +21,9 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/i2c.h>
+#if defined(CONFIG_SPI)
+#include <linux/spi/spi.h>
+#endif
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include "compat.h"
@@ -100,6 +103,14 @@
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
+++ b/linux/include/media/v4l2-common.h	Wed Mar 17 04:53:52 2010 +0900
@@ -191,6 +191,25 @@
 
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
+
+/* ------------------------------------------------------------------------- */
+
 /* Note: these remaining ioctls/structs should be removed as well, but they are
    still used in tuner-simple.c (TUNER_SET_CONFIG), cx18/ivtv (RESET) and
    v4l2-int-device.h (v4l2_routing). To remove these ioctls some more cleanup
diff -r b6b82258cf5e linux/include/media/v4l2-subdev.h
--- a/linux/include/media/v4l2-subdev.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-subdev.h	Wed Mar 17 04:53:52 2010 +0900
@@ -387,6 +387,8 @@
 
 /* Set this flag if this subdev is a i2c device. */
 #define V4L2_SUBDEV_FL_IS_I2C (1U << 0)
+/* Set this flag if this subdev is a spi device. */
+#define V4L2_SUBDEV_FL_IS_SPI (1U << 1)
 
 /* Each instance of a subdev driver should create this struct, either
    stand-alone or embedded in a larger struct.
diff -r b6b82258cf5e v4l/compat.h
--- a/v4l/compat.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/v4l/compat.h	Wed Mar 17 04:53:52 2010 +0900
@@ -525,5 +525,19 @@
 #define strcasecmp(a, b) strnicmp(a, b, sizeof(a))
 #endif
 
+/* Compatibility code for SPI subsystem */
+#ifdef _LINUX_SPI_H
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 21)
+static inline void spi_set_drvdata(struct spi_device *spi, void *data)
+{
+	dev_set_drvdata(&spi->dev, data);
+}
+
+static inline void spi_get_drvdata(struct spi_device *spi)
+{
+	return dev_get_drvdata(&spi->dev);
+}
+#endif
+#endif
 
 #endif /*  _COMPAT_H */

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

--MP_/CVYTTBd/c2D4Sfv.vHgbNPr--
