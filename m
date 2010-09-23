Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:42704 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab0IWLfO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 07:35:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v5 02/12] media: Media device
Date: Thu, 23 Sep 2010 13:34:46 +0200
Message-Id: <1285241696-16826-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285241696-16826-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285241696-16826-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The media_device structure abstracts functions common to all kind of
media devices (v4l2, dvb, alsa, ...). It manages media entities and
offers a userspace API to discover and configure the media device
internal topology.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media-entities.tmpl      |    2 +
 Documentation/DocBook/media.tmpl               |    3 +
 Documentation/DocBook/v4l/media-controller.xml |   27 +++++++
 Documentation/media-framework.txt              |   68 ++++++++++++++++
 drivers/media/Makefile                         |    2 +-
 drivers/media/media-device.c                   |   98 ++++++++++++++++++++++++
 include/media/media-device.h                   |   64 +++++++++++++++
 7 files changed, 263 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/media-controller.xml
 create mode 100644 Documentation/media-framework.txt
 create mode 100644 drivers/media/media-device.c
 create mode 100644 include/media/media-device.h

diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
index 6ae9715..e2af2c0 100644
--- a/Documentation/DocBook/media-entities.tmpl
+++ b/Documentation/DocBook/media-entities.tmpl
@@ -318,6 +318,8 @@
 <!ENTITY sub-media-entities SYSTEM "media-entities.tmpl">
 <!ENTITY sub-media-indices SYSTEM "media-indices.tmpl">
 
+<!ENTITY sub-media-controller SYSTEM "v4l/media-controller.xml">
+
 <!-- Function Reference -->
 <!ENTITY close SYSTEM "v4l/func-close.xml">
 <!ENTITY ioctl SYSTEM "v4l/func-ioctl.xml">
diff --git a/Documentation/DocBook/media.tmpl b/Documentation/DocBook/media.tmpl
index f11048d..5371797 100644
--- a/Documentation/DocBook/media.tmpl
+++ b/Documentation/DocBook/media.tmpl
@@ -105,6 +105,9 @@ Foundation. A copy of the license is included in the chapter entitled
 <chapter id="remote_controllers">
 &sub-remote_controllers;
 </chapter>
+<chapter id="media_controller">
+&sub-media-controller;
+</chapter>
 </part>
 
 &sub-fdl-appendix;
diff --git a/Documentation/DocBook/v4l/media-controller.xml b/Documentation/DocBook/v4l/media-controller.xml
new file mode 100644
index 0000000..a52cc70
--- /dev/null
+++ b/Documentation/DocBook/v4l/media-controller.xml
@@ -0,0 +1,27 @@
+<title>Media Controller</title>
+
+<section id="media-controller-intro">
+  <title>Introduction</title>
+  <para>Media devices increasingly handle multiple related functions. Many USB
+  cameras include microphones, video capture hardware can also output video, or
+  SoC camera interfaces also perform memory-to-memory operations similar to
+  video codecs.</para>
+  <para>Independent functions, even when implemented in the same hardware, can
+  be modelled as separate devices. A USB camera with a microphone will be
+  presented to userspace applications as V4L2 and ALSA capture devices. The
+  devices' relationships (when using a webcam, end-users shouldn't have to
+  manually select the associated USB microphone), while not made available
+  directly to applications by the drivers, can usually be retrieved from sysfs.
+  </para>
+  <para>With more and more advanced SoC devices being introduced, the current
+  approach will not scale. Device topologies are getting increasingly complex
+  and can't always be represented by a tree structure. Hardware blocks are
+  shared between different functions, creating dependencies between seemingly
+  unrelated devices.</para>
+  <para>Kernel abstraction APIs such as V4L2 and ALSA provide means for
+  applications to access hardware parameters. As newer hardware expose an
+  increasingly high number of those parameters, drivers need to guess what
+  applications really require based on limited information, thereby implementing
+  policies that belong to userspace.</para>
+  <para>The media controller API aims at solving those problems.</para>
+</section>
diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
new file mode 100644
index 0000000..84fa43a
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
+The media controller API is documented in DocBook format in
+Documentation/DocBook/v4l/media-controller.xml. This document will focus on
+the kernel-side implementation of the media framework.
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
+ - dev must point to the parent device (usually a pci_dev, usb_interface or
+   platform_device instance).
+
+ - model must be filled with the device model name as a NUL-terminated UTF-8
+   string. The device/model revision must not be stored in this field.
+
+The following fields are optional:
+
+ - serial is a unique serial number stored as a NUL-terminated ASCII string.
+   The field is big enough to store a GUID in text form. If the hardware
+   doesn't provide a unique serial number this field must be left empty.
+
+ - bus_info represents the location of the device in the system as a
+   NUL-terminated ASCII string. For PCI/PCIe devices bus_info must be set to
+   "PCI:" (or "PCIe:") followed by the value of pci_name(). For USB devices,
+   the usb_make_path() function must be used. This field is used by
+   applications to distinguish between otherwise identical devices that don't
+   provide a serial number.
+
+ - hw_revision is the hardware device revision in a driver-specific format.
+   When possible the revision should be formatted with the KERNEL_VERSION
+   macro.
+
+ - driver_version is formatted with the KERNEL_VERSION macro. The version
+   minor must be incremented when new features are added to the userspace API
+   without breaking binary compatibility. The version major must be
+   incremented when binary compatibility is broken.
+
+Upon successful registration a character device named media[0-9]+ is created.
+The device major and minor numbers are dynamic. The model name is exported as
+a sysfs attribute.
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
index 0000000..781c641
--- /dev/null
+++ b/drivers/media/media-device.c
@@ -0,0 +1,98 @@
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
+/* -----------------------------------------------------------------------------
+ * sysfs
+ */
+
+static ssize_t show_model(struct device *cd,
+			  struct device_attribute *attr, char *buf)
+{
+	struct media_device *mdev = to_media_device(to_media_devnode(cd));
+
+	return sprintf(buf, "%.*s\n", (int)sizeof(mdev->model), mdev->model);
+}
+
+static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
+
+/* -----------------------------------------------------------------------------
+ * Registration/unregistration
+ */
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
+ * - dev must point to the parent device
+ * - model must be filled with the device model name
+ */
+int __must_check media_device_register(struct media_device *mdev)
+{
+	int ret;
+
+	if (WARN_ON(mdev->dev == NULL || mdev->model[0] == 0))
+		return 0;
+
+	/* Register the device node. */
+	mdev->devnode.fops = &media_device_fops;
+	mdev->devnode.parent = mdev->dev;
+	mdev->devnode.release = media_device_release;
+	ret = media_devnode_register(&mdev->devnode);
+	if (ret < 0)
+		return ret;
+
+	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
+	if (ret < 0) {
+		media_devnode_unregister(&mdev->devnode);
+		return ret;
+	}
+
+	return 0;
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
+	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
+	media_devnode_unregister(&mdev->devnode);
+}
+EXPORT_SYMBOL_GPL(media_device_unregister);
diff --git a/include/media/media-device.h b/include/media/media-device.h
new file mode 100644
index 0000000..301017a
--- /dev/null
+++ b/include/media/media-device.h
@@ -0,0 +1,64 @@
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
+/**
+ * struct media_device - Media device
+ * @dev:	Parent device
+ * @devnode:	Media device node
+ * @model:	Device model name
+ * @serial:	Device serial number (optional)
+ * @bus_info:	Unique and stable device location identifier
+ * @hw_revision: Hardware device revision
+ * @driver_version: Device driver version
+ *
+ * This structure represents an abstract high-level media device. It allows easy
+ * access to entities and provides basic media device-level support. The
+ * structure can be allocated directly or embedded in a larger structure.
+ *
+ * The parent @dev is a physical device. It must be set before registering the
+ * media device.
+ *
+ * @model is a descriptive model name exported through sysfs. It doesn't have to
+ * be unique.
+ */
+struct media_device {
+	/* dev->driver_data points to this struct. */
+	struct device *dev;
+	struct media_devnode devnode;
+
+	u8 model[32];
+	u8 serial[40];
+	u8 bus_info[32];
+	u32 hw_revision;
+	u32 driver_version;
+};
+
+int __must_check media_device_register(struct media_device *mdev);
+void media_device_unregister(struct media_device *mdev);
+
+#endif
-- 
1.7.2.2

