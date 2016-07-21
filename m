Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52884 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbcGUUS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 16:18:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 04/12] [media] v4l2-device.rst: do cross references with kernel-doc
Date: Thu, 21 Jul 2016 17:18:09 -0300
Message-Id: <91add281537412fafb840f6d36fb4377cdc45737.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This document describes the main kAPI interfaces for the
v4l2-device.h header. Add cross references to the documentation
produced via kernel-doc.

While here, also use monotonic font for constants.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-device.rst | 130 ++++++++++++++++---------------
 1 file changed, 66 insertions(+), 64 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-device.rst b/Documentation/media/kapi/v4l2-device.rst
index 6d521b313beb..8e275d0ff0f5 100644
--- a/Documentation/media/kapi/v4l2-device.rst
+++ b/Documentation/media/kapi/v4l2-device.rst
@@ -1,67 +1,69 @@
 V4L2 Device register logic
 --------------------------
 
-Each device instance is represented by a struct v4l2_device (v4l2-device.h).
+Each device instance is represented by a struct :c:type:`v4l2_device`.
 Very simple devices can just allocate this struct, but most of the time you
 would embed this struct inside a larger struct.
 
-You must register the device instance:
+You must register the device instance by calling:
 
-.. code-block:: none
+	:cpp:func:`v4l2_device_register <v4l2_device_register>`
+	(dev, :c:type:`v4l2_dev <v4l2_device>`).
 
-	v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev);
-
-Registration will initialize the v4l2_device struct. If the dev->driver_data
-field is NULL, it will be linked to v4l2_dev.
+Registration will initialize the :c:type:`v4l2_device` struct. If the
+dev->driver_data field is ``NULL``, it will be linked to
+:c:type:`v4l2_dev <v4l2_device>` argument.
 
 Drivers that want integration with the media device framework need to set
 dev->driver_data manually to point to the driver-specific device structure
-that embed the struct v4l2_device instance. This is achieved by a
-dev_set_drvdata() call before registering the V4L2 device instance. They must
-also set the struct v4l2_device mdev field to point to a properly initialized
-and registered media_device instance.
-
-If v4l2_dev->name is empty then it will be set to a value derived from dev
-(driver name followed by the bus_id, to be precise). If you set it up before
-calling v4l2_device_register then it will be untouched. If dev is NULL, then
-you **must** setup v4l2_dev->name before calling v4l2_device_register.
-
-You can use v4l2_device_set_name() to set the name based on a driver name and
-a driver-global atomic_t instance. This will generate names like ivtv0, ivtv1,
-etc. If the name ends with a digit, then it will insert a dash: cx18-0,
-cx18-1, etc. This function returns the instance number.
-
-The first 'dev' argument is normally the struct device pointer of a pci_dev,
-usb_interface or platform_device. It is rare for dev to be NULL, but it happens
-with ISA devices or when one device creates multiple PCI devices, thus making
-it impossible to associate v4l2_dev with a particular parent.
-
-You can also supply a notify() callback that can be called by sub-devices to
-notify you of events. Whether you need to set this depends on the sub-device.
-Any notifications a sub-device supports must be defined in a header in
-include/media/<subdevice>.h.
-
-You unregister with:
-
-.. code-block:: none
-
-	v4l2_device_unregister(struct v4l2_device *v4l2_dev);
-
-If the dev->driver_data field points to v4l2_dev, it will be reset to NULL.
-Unregistering will also automatically unregister all subdevs from the device.
+that embed the struct :c:type:`v4l2_device` instance. This is achieved by a
+``dev_set_drvdata()`` call before registering the V4L2 device instance.
+They must also set the struct :c:type:`v4l2_device` mdev field to point to a
+properly initialized and registered :c:type:`media_device` instance.
+
+If :c:type:`v4l2_dev <v4l2_device>`\ ->name is empty then it will be set to a
+value derived from dev (driver name followed by the bus_id, to be precise).
+If you set it up before  calling :cpp:func:`v4l2_device_register` then it will
+be untouched. If dev is ``NULL``, then you **must** setup
+:c:type:`v4l2_dev <v4l2_device>`\ ->name before calling
+:cpp:func:`v4l2_device_register`.
+
+You can use :cpp:func:`v4l2_device_set_name` to set the name based on a driver
+name and a driver-global atomic_t instance. This will generate names like
+``ivtv0``, ``ivtv1``, etc. If the name ends with a digit, then it will insert
+a dash: ``cx18-0``, ``cx18-1``, etc. This function returns the instance number.
+
+The first ``dev`` argument is normally the ``struct device`` pointer of a
+``pci_dev``, ``usb_interface`` or ``platform_device``. It is rare for dev to
+be ``NULL``, but it happens with ISA devices or when one device creates
+multiple PCI devices, thus making it impossible to associate
+:c:type:`v4l2_dev <v4l2_device>` with a particular parent.
+
+You can also supply a ``notify()`` callback that can be called by sub-devices
+to notify you of events. Whether you need to set this depends on the
+sub-device. Any notifications a sub-device supports must be defined in a header
+in ``include/media/subdevice.h``.
+
+V4L2 devices are unregistered by calling:
+
+	:cpp:func:`v4l2_device_unregister`
+	(:c:type:`v4l2_dev <v4l2_device>`).
+
+If the dev->driver_data field points to :c:type:`v4l2_dev <v4l2_device>`,
+it will be reset to ``NULL``. Unregistering will also automatically unregister
+all subdevs from the device.
 
 If you have a hotpluggable device (e.g. a USB device), then when a disconnect
-happens the parent device becomes invalid. Since v4l2_device has a pointer to
-that parent device it has to be cleared as well to mark that the parent is
-gone. To do this call:
+happens the parent device becomes invalid. Since :c:type:`v4l2_device` has a
+pointer to that parent device it has to be cleared as well to mark that the
+parent is gone. To do this call:
 
-.. code-block:: none
-
-	v4l2_device_disconnect(struct v4l2_device *v4l2_dev);
+	:cpp:func:`v4l2_device_disconnect`
+	(:c:type:`v4l2_dev <v4l2_device>`).
 
 This does *not* unregister the subdevs, so you still need to call the
-v4l2_device_unregister() function for that. If your driver is not hotpluggable,
-then there is no need to call v4l2_device_disconnect().
+:cpp:func:`v4l2_device_unregister` function for that. If your driver is not
+hotpluggable, then there is no need to call :cpp:func:`v4l2_device_disconnect`.
 
 Sometimes you need to iterate over all devices registered by a specific
 driver. This is usually the case if multiple device drivers use the same
@@ -70,7 +72,7 @@ hardware. The same is true for alsa drivers for example.
 
 You can iterate over all registered devices as follows:
 
-.. code-block:: none
+.. code-block:: c
 
 	static int callback(struct device *dev, void *p)
 	{
@@ -102,7 +104,7 @@ commonly used to map a device instance to an index of a module option array.
 
 The recommended approach is as follows:
 
-.. code-block:: none
+.. code-block:: c
 
 	static atomic_t drv_instance = ATOMIC_INIT(0);
 
@@ -113,28 +115,28 @@ The recommended approach is as follows:
 	}
 
 If you have multiple device nodes then it can be difficult to know when it is
-safe to unregister v4l2_device for hotpluggable devices. For this purpose
-v4l2_device has refcounting support. The refcount is increased whenever
-video_register_device is called and it is decreased whenever that device node
-is released. When the refcount reaches zero, then the v4l2_device release()
-callback is called. You can do your final cleanup there.
+safe to unregister :c:type:`v4l2_device` for hotpluggable devices. For this
+purpose :c:type:`v4l2_device` has refcounting support. The refcount is
+increased whenever :cpp:func:`video_register_device` is called and it is
+decreased whenever that device node is released. When the refcount reaches
+zero, then the :c:type:`v4l2_device` release() callback is called. You can
+do your final cleanup there.
 
 If other device nodes (e.g. ALSA) are created, then you can increase and
 decrease the refcount manually as well by calling:
 
-.. code-block:: none
-
-	void v4l2_device_get(struct v4l2_device *v4l2_dev);
+	:cpp:func:`v4l2_device_get`
+	(:c:type:`v4l2_dev <v4l2_device>`).
 
 or:
 
-.. code-block:: none
+	:cpp:func:`v4l2_device_put`
+	(:c:type:`v4l2_dev <v4l2_device>`).
 
-	int v4l2_device_put(struct v4l2_device *v4l2_dev);
-
-Since the initial refcount is 1 you also need to call v4l2_device_put in the
-disconnect() callback (for USB devices) or in the remove() callback (for e.g.
-PCI devices), otherwise the refcount will never reach 0.
+Since the initial refcount is 1 you also need to call
+:cpp:func:`v4l2_device_put` in the ``disconnect()`` callback (for USB devices)
+or in the ``remove()`` callback (for e.g. PCI devices), otherwise the refcount
+will never reach 0.
 
 V4L2 device kAPI
 ^^^^^^^^^^^^^^^^
-- 
2.7.4

