Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51139 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022Ab0GNN3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jul 2010 09:29:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH 02/10] media: Media device
Date: Wed, 14 Jul 2010 15:30:11 +0200
Message-Id: <1279114219-27389-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media_device structure abstracts functions common to all kind of
media devices (v4l2, dvb, alsa, ...). It manages media entities and
offers a userspace API to discover and configure the media device
internal topology.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/media-framework.txt |   68 ++++++++++++++++++++++++++++++++
 drivers/media/Makefile            |    2 +-
 drivers/media/media-device.c      |   77 +++++++++++++++++++++++++++++++++++++
 include/media/media-device.h      |   53 +++++++++++++++++++++++++
 4 files changed, 199 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/media-framework.txt
 create mode 100644 drivers/media/media-device.c
 create mode 100644 include/media/media-device.h

diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
new file mode 100644
index 0000000..b942c8f
--- /dev/null
+++ b/Documentation/media-framework.txt
@@ -0,0 +1,68 @@
+Linux kernel media framework
+============================
+
+This document describes the Linux kernel media framework, its data structures,
+functions and their usage.
+
+
+Introduction
+------------
+
+Media devices increasingly handle multiple related functions. Many USB cameras
+include microphones, video capture hardware can also output video, or SoC
+camera interfaces also perform memory-to-memory operations similar to video
+codecs.
+
+Independent functions, even when implemented in the same hardware, can be
+modeled by separate devices. A USB camera with a microphone will be presented
+to userspace applications as V4L2 and ALSA capture devices. The devices
+relationships (when using a webcam, end-users shouldn't have to manually
+select the associated USB microphone), while not made available directly to
+applications by the drivers, can usually be retrieved from sysfs.
+
+With more and more advanced SoC devices being introduced, the current approach
+will not scale. Device topologies are getting increasingly complex and can't
+always be represented by a tree structure. Hardware blocks are shared between
+different functions, creating dependencies between seemingly unrelated
+devices.
+
+Kernel abstraction APIs such as V4L2 and ALSA provide means for applications
+to access hardware parameters. As newer hardware expose an increasingly high
+number of those parameters, drivers need to guess what applications really
+require based on limited information, thereby implementing policies that
+belong to userspace.
+
+The media kernel API aims at solving those problems.
+
+
+Media device
+------------
+
+A media device is represented by a struct media_device instance, defined in
+include/media/media-device.h. Allocation of the structure is handled by the
+media device driver, usually by embedding the media_device instance in a
+larger driver-specific structure.
+
+Drivers register media device instances by calling
+
+	media_device_register(struct media_device *mdev);
+
+The caller is responsible for initializing the media_device structure before
+registration. The following fields must be set:
+
+ - dev should point to the parent device (usually a pci_dev, usb_interface or
+   platform_device instance). In the rare case when no parent device is
+   available (with ISA devices for instance), the field can be set to NULL.
+ - name should be set to the device name. If the name is empty a parent device
+   must be set. In that case the name will be set to the parent device driver
+   name followed by a space and the parent device name.
+
+Upon successful registration a character device named media[0-9]+ is created.
+The device major and minor numbers are dynamic.
+
+Drivers unregister media device instances by calling
+
+	media_device_unregister(struct media_device *mdev);
+
+Unregistering a media device that hasn't been registered is *NOT* safe.
+
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index c1b5938..f8d8dcb 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
-media-objs	:= media-devnode.o
+media-objs	:= media-device.o media-devnode.o
 
 obj-$(CONFIG_MEDIA_SUPPORT)	+= media.o
 
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
new file mode 100644
index 0000000..a4d3db5
--- /dev/null
+++ b/drivers/media/media-device.c
@@ -0,0 +1,77 @@
+/*
+ *  Media device support.
+ *
+ *  Copyright (C) 2010  Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#include <media/media-device.h>
+#include <media/media-devnode.h>
+
+static const struct media_file_operations media_device_fops = {
+	.owner = THIS_MODULE,
+};
+
+static void media_device_release(struct media_devnode *mdev)
+{
+}
+
+/**
+ * media_device_register - register a media device
+ * @mdev:	The media device
+ *
+ * The caller is responsible for initializing the media device before
+ * registration. The following fields must be set:
+ *
+ * - dev should point to the parent device. The field can be NULL when no
+ *   parent device is available (for instance with ISA devices).
+ * - name should be set to the device name. If the name is empty a parent
+ *   device must be set. In that case the name will be set to the parent
+ *   device driver name followed by a space and the parent device name.
+ */
+int __must_check media_device_register(struct media_device *mdev)
+{
+	/* If dev == NULL, then name must be filled in by the caller */
+	if (mdev->dev == NULL && WARN_ON(!mdev->name[0]))
+		return 0;
+
+	/* Set name to driver name + device name if it is empty. */
+	if (!mdev->name[0])
+		snprintf(mdev->name, sizeof(mdev->name), "%s %s",
+			mdev->dev->driver->name, dev_name(mdev->dev));
+
+	/* Register the device node. */
+	mdev->devnode.fops = &media_device_fops;
+	mdev->devnode.parent = mdev->dev;
+	strlcpy(mdev->devnode.name, mdev->name, sizeof(mdev->devnode.name));
+	mdev->devnode.release = media_device_release;
+	return media_devnode_register(&mdev->devnode, MEDIA_TYPE_DEVICE);
+}
+EXPORT_SYMBOL_GPL(media_device_register);
+
+/**
+ * media_device_unregister - unregister a media device
+ * @mdev:	The media device
+ *
+ */
+void media_device_unregister(struct media_device *mdev)
+{
+	media_devnode_unregister(&mdev->devnode);
+}
+EXPORT_SYMBOL_GPL(media_device_unregister);
diff --git a/include/media/media-device.h b/include/media/media-device.h
new file mode 100644
index 0000000..6c1fc4a
--- /dev/null
+++ b/include/media/media-device.h
@@ -0,0 +1,53 @@
+/*
+ *  Media device support header.
+ *
+ *  Copyright (C) 2010  Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _MEDIA_DEVICE_H
+#define _MEDIA_DEVICE_H
+
+#include <linux/device.h>
+#include <linux/list.h>
+
+#include <media/media-devnode.h>
+
+/* Each instance of a media device should create the media_device struct,
+ * either stand-alone or embedded in a larger struct.
+ *
+ * It allows easy access to sub-devices (see v4l2-subdev.h) and provides
+ * basic media device-level support.
+ */
+
+#define MEDIA_DEVICE_NAME_SIZE (20 + 16)
+
+struct media_device {
+	/* dev->driver_data points to this struct.
+	 * Note: dev might be NULL if there is no parent device
+	 * as is the case with e.g. ISA devices.
+	 */
+	struct device *dev;
+	struct media_devnode devnode;
+
+	/* unique device name, by default the driver name + bus ID */
+	char name[MEDIA_DEVICE_NAME_SIZE];
+};
+
+int __must_check media_device_register(struct media_device *mdev);
+void media_device_unregister(struct media_device *mdev);
+
+#endif
-- 
1.7.1

