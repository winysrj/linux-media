Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52898 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbcGUUS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 16:18:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 03/12] [media] v4l2-device.rst: add contents from v4l2-framework
Date: Thu, 21 Jul 2016 17:18:08 -0300
Message-Id: <bb61b13a9d596b158d4c7c2ca0500f4678c511b1.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Part of the contents of v4l2-framework is related to the
kAPI defined by v4l2-device. Move such contents to the
v4l2-device.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-device.rst    | 140 +++++++++++++++++++++++++++-
 Documentation/media/kapi/v4l2-framework.rst | 139 ---------------------------
 2 files changed, 139 insertions(+), 140 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-device.rst b/Documentation/media/kapi/v4l2-device.rst
index e324fbcb0353..6d521b313beb 100644
--- a/Documentation/media/kapi/v4l2-device.rst
+++ b/Documentation/media/kapi/v4l2-device.rst
@@ -1,4 +1,142 @@
-V4L2 Device kAPI
+V4L2 Device register logic
+--------------------------
+
+Each device instance is represented by a struct v4l2_device (v4l2-device.h).
+Very simple devices can just allocate this struct, but most of the time you
+would embed this struct inside a larger struct.
+
+You must register the device instance:
+
+.. code-block:: none
+
+	v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev);
+
+Registration will initialize the v4l2_device struct. If the dev->driver_data
+field is NULL, it will be linked to v4l2_dev.
+
+Drivers that want integration with the media device framework need to set
+dev->driver_data manually to point to the driver-specific device structure
+that embed the struct v4l2_device instance. This is achieved by a
+dev_set_drvdata() call before registering the V4L2 device instance. They must
+also set the struct v4l2_device mdev field to point to a properly initialized
+and registered media_device instance.
+
+If v4l2_dev->name is empty then it will be set to a value derived from dev
+(driver name followed by the bus_id, to be precise). If you set it up before
+calling v4l2_device_register then it will be untouched. If dev is NULL, then
+you **must** setup v4l2_dev->name before calling v4l2_device_register.
+
+You can use v4l2_device_set_name() to set the name based on a driver name and
+a driver-global atomic_t instance. This will generate names like ivtv0, ivtv1,
+etc. If the name ends with a digit, then it will insert a dash: cx18-0,
+cx18-1, etc. This function returns the instance number.
+
+The first 'dev' argument is normally the struct device pointer of a pci_dev,
+usb_interface or platform_device. It is rare for dev to be NULL, but it happens
+with ISA devices or when one device creates multiple PCI devices, thus making
+it impossible to associate v4l2_dev with a particular parent.
+
+You can also supply a notify() callback that can be called by sub-devices to
+notify you of events. Whether you need to set this depends on the sub-device.
+Any notifications a sub-device supports must be defined in a header in
+include/media/<subdevice>.h.
+
+You unregister with:
+
+.. code-block:: none
+
+	v4l2_device_unregister(struct v4l2_device *v4l2_dev);
+
+If the dev->driver_data field points to v4l2_dev, it will be reset to NULL.
+Unregistering will also automatically unregister all subdevs from the device.
+
+If you have a hotpluggable device (e.g. a USB device), then when a disconnect
+happens the parent device becomes invalid. Since v4l2_device has a pointer to
+that parent device it has to be cleared as well to mark that the parent is
+gone. To do this call:
+
+.. code-block:: none
+
+	v4l2_device_disconnect(struct v4l2_device *v4l2_dev);
+
+This does *not* unregister the subdevs, so you still need to call the
+v4l2_device_unregister() function for that. If your driver is not hotpluggable,
+then there is no need to call v4l2_device_disconnect().
+
+Sometimes you need to iterate over all devices registered by a specific
+driver. This is usually the case if multiple device drivers use the same
+hardware. E.g. the ivtvfb driver is a framebuffer driver that uses the ivtv
+hardware. The same is true for alsa drivers for example.
+
+You can iterate over all registered devices as follows:
+
+.. code-block:: none
+
+	static int callback(struct device *dev, void *p)
+	{
+		struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
+
+		/* test if this device was inited */
+		if (v4l2_dev == NULL)
+			return 0;
+		...
+		return 0;
+	}
+
+	int iterate(void *p)
+	{
+		struct device_driver *drv;
+		int err;
+
+		/* Find driver 'ivtv' on the PCI bus.
+		pci_bus_type is a global. For USB busses use usb_bus_type. */
+		drv = driver_find("ivtv", &pci_bus_type);
+		/* iterate over all ivtv device instances */
+		err = driver_for_each_device(drv, NULL, p, callback);
+		put_driver(drv);
+		return err;
+	}
+
+Sometimes you need to keep a running counter of the device instance. This is
+commonly used to map a device instance to an index of a module option array.
+
+The recommended approach is as follows:
+
+.. code-block:: none
+
+	static atomic_t drv_instance = ATOMIC_INIT(0);
+
+	static int drv_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
+	{
+		...
+		state->instance = atomic_inc_return(&drv_instance) - 1;
+	}
+
+If you have multiple device nodes then it can be difficult to know when it is
+safe to unregister v4l2_device for hotpluggable devices. For this purpose
+v4l2_device has refcounting support. The refcount is increased whenever
+video_register_device is called and it is decreased whenever that device node
+is released. When the refcount reaches zero, then the v4l2_device release()
+callback is called. You can do your final cleanup there.
+
+If other device nodes (e.g. ALSA) are created, then you can increase and
+decrease the refcount manually as well by calling:
+
+.. code-block:: none
+
+	void v4l2_device_get(struct v4l2_device *v4l2_dev);
+
+or:
+
+.. code-block:: none
+
+	int v4l2_device_put(struct v4l2_device *v4l2_dev);
+
+Since the initial refcount is 1 you also need to call v4l2_device_put in the
+disconnect() callback (for USB devices) or in the remove() callback (for e.g.
+PCI devices), otherwise the refcount will never reach 0.
+
+V4L2 device kAPI
 ^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/v4l2-device.h
diff --git a/Documentation/media/kapi/v4l2-framework.rst b/Documentation/media/kapi/v4l2-framework.rst
index 740875ddfcec..1fdc96bd7411 100644
--- a/Documentation/media/kapi/v4l2-framework.rst
+++ b/Documentation/media/kapi/v4l2-framework.rst
@@ -80,145 +80,6 @@ The V4L2 framework also optionally integrates with the media framework. If a
 driver sets the struct v4l2_device mdev field, sub-devices and video nodes
 will automatically appear in the media framework as entities.
 
-
-struct v4l2_device
-------------------
-
-Each device instance is represented by a struct v4l2_device (v4l2-device.h).
-Very simple devices can just allocate this struct, but most of the time you
-would embed this struct inside a larger struct.
-
-You must register the device instance:
-
-.. code-block:: none
-
-	v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev);
-
-Registration will initialize the v4l2_device struct. If the dev->driver_data
-field is NULL, it will be linked to v4l2_dev.
-
-Drivers that want integration with the media device framework need to set
-dev->driver_data manually to point to the driver-specific device structure
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
-
-If you have a hotpluggable device (e.g. a USB device), then when a disconnect
-happens the parent device becomes invalid. Since v4l2_device has a pointer to
-that parent device it has to be cleared as well to mark that the parent is
-gone. To do this call:
-
-.. code-block:: none
-
-	v4l2_device_disconnect(struct v4l2_device *v4l2_dev);
-
-This does *not* unregister the subdevs, so you still need to call the
-v4l2_device_unregister() function for that. If your driver is not hotpluggable,
-then there is no need to call v4l2_device_disconnect().
-
-Sometimes you need to iterate over all devices registered by a specific
-driver. This is usually the case if multiple device drivers use the same
-hardware. E.g. the ivtvfb driver is a framebuffer driver that uses the ivtv
-hardware. The same is true for alsa drivers for example.
-
-You can iterate over all registered devices as follows:
-
-.. code-block:: none
-
-	static int callback(struct device *dev, void *p)
-	{
-		struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
-
-		/* test if this device was inited */
-		if (v4l2_dev == NULL)
-			return 0;
-		...
-		return 0;
-	}
-
-	int iterate(void *p)
-	{
-		struct device_driver *drv;
-		int err;
-
-		/* Find driver 'ivtv' on the PCI bus.
-		pci_bus_type is a global. For USB busses use usb_bus_type. */
-		drv = driver_find("ivtv", &pci_bus_type);
-		/* iterate over all ivtv device instances */
-		err = driver_for_each_device(drv, NULL, p, callback);
-		put_driver(drv);
-		return err;
-	}
-
-Sometimes you need to keep a running counter of the device instance. This is
-commonly used to map a device instance to an index of a module option array.
-
-The recommended approach is as follows:
-
-.. code-block:: none
-
-	static atomic_t drv_instance = ATOMIC_INIT(0);
-
-	static int drv_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
-	{
-		...
-		state->instance = atomic_inc_return(&drv_instance) - 1;
-	}
-
-If you have multiple device nodes then it can be difficult to know when it is
-safe to unregister v4l2_device for hotpluggable devices. For this purpose
-v4l2_device has refcounting support. The refcount is increased whenever
-video_register_device is called and it is decreased whenever that device node
-is released. When the refcount reaches zero, then the v4l2_device release()
-callback is called. You can do your final cleanup there.
-
-If other device nodes (e.g. ALSA) are created, then you can increase and
-decrease the refcount manually as well by calling:
-
-.. code-block:: none
-
-	void v4l2_device_get(struct v4l2_device *v4l2_dev);
-
-or:
-
-.. code-block:: none
-
-	int v4l2_device_put(struct v4l2_device *v4l2_dev);
-
-Since the initial refcount is 1 you also need to call v4l2_device_put in the
-disconnect() callback (for USB devices) or in the remove() callback (for e.g.
-PCI devices), otherwise the refcount will never reach 0.
-
 struct v4l2_subdev
 ------------------
 
-- 
2.7.4

