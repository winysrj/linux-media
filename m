Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45807 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbcGRB41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 05/36] [media] doc-rst: do a poor man's conversion of v4l2-framework
Date: Sun, 17 Jul 2016 22:55:48 -0300
Message-Id: <4c21d4fb1b16eaaa6462e76a0eb6b70235a966ea.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make Sphinx happy with v4l2-framework.rst by putting all C
code inside code-block.

Please note that this is a poor man ReST conversion, as several
of those blocks should actually be converted to use :cpp:func:,
pointing to the kAPI auto-generated documentation.

The problem is that we currently lack kernel-doc documentation
for most of the stuff described there.

So, let's do a poor man's conversion. We should later address
this.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-framework.rst | 356 ++++++++++++++++++----------
 1 file changed, 229 insertions(+), 127 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-framework.rst b/Documentation/media/kapi/v4l2-framework.rst
index cbefc7902f5f..740875ddfcec 100644
--- a/Documentation/media/kapi/v4l2-framework.rst
+++ b/Documentation/media/kapi/v4l2-framework.rst
@@ -57,6 +57,8 @@ All drivers have the following structure:
 
 This is a rough schematic of how it all relates:
 
+.. code-block:: none
+
     device instances
       |
       +-sub-device instances
@@ -88,6 +90,8 @@ would embed this struct inside a larger struct.
 
 You must register the device instance:
 
+.. code-block:: none
+
 	v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev);
 
 Registration will initialize the v4l2_device struct. If the dev->driver_data
@@ -103,7 +107,7 @@ and registered media_device instance.
 If v4l2_dev->name is empty then it will be set to a value derived from dev
 (driver name followed by the bus_id, to be precise). If you set it up before
 calling v4l2_device_register then it will be untouched. If dev is NULL, then
-you *must* setup v4l2_dev->name before calling v4l2_device_register.
+you **must** setup v4l2_dev->name before calling v4l2_device_register.
 
 You can use v4l2_device_set_name() to set the name based on a driver name and
 a driver-global atomic_t instance. This will generate names like ivtv0, ivtv1,
@@ -122,6 +126,8 @@ include/media/<subdevice>.h.
 
 You unregister with:
 
+.. code-block:: none
+
 	v4l2_device_unregister(struct v4l2_device *v4l2_dev);
 
 If the dev->driver_data field points to v4l2_dev, it will be reset to NULL.
@@ -132,6 +138,8 @@ happens the parent device becomes invalid. Since v4l2_device has a pointer to
 that parent device it has to be cleared as well to mark that the parent is
 gone. To do this call:
 
+.. code-block:: none
+
 	v4l2_device_disconnect(struct v4l2_device *v4l2_dev);
 
 This does *not* unregister the subdevs, so you still need to call the
@@ -145,43 +153,47 @@ hardware. The same is true for alsa drivers for example.
 
 You can iterate over all registered devices as follows:
 
-static int callback(struct device *dev, void *p)
-{
-	struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
+.. code-block:: none
 
-	/* test if this device was inited */
-	if (v4l2_dev == NULL)
+	static int callback(struct device *dev, void *p)
+	{
+		struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
+
+		/* test if this device was inited */
+		if (v4l2_dev == NULL)
+			return 0;
+		...
 		return 0;
-	...
-	return 0;
-}
+	}
 
-int iterate(void *p)
-{
-	struct device_driver *drv;
-	int err;
+	int iterate(void *p)
+	{
+		struct device_driver *drv;
+		int err;
 
-	/* Find driver 'ivtv' on the PCI bus.
-	   pci_bus_type is a global. For USB busses use usb_bus_type. */
-	drv = driver_find("ivtv", &pci_bus_type);
-	/* iterate over all ivtv device instances */
-	err = driver_for_each_device(drv, NULL, p, callback);
-	put_driver(drv);
-	return err;
-}
+		/* Find driver 'ivtv' on the PCI bus.
+		pci_bus_type is a global. For USB busses use usb_bus_type. */
+		drv = driver_find("ivtv", &pci_bus_type);
+		/* iterate over all ivtv device instances */
+		err = driver_for_each_device(drv, NULL, p, callback);
+		put_driver(drv);
+		return err;
+	}
 
 Sometimes you need to keep a running counter of the device instance. This is
 commonly used to map a device instance to an index of a module option array.
 
 The recommended approach is as follows:
 
-static atomic_t drv_instance = ATOMIC_INIT(0);
+.. code-block:: none
 
-static int drv_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
-{
-	...
-	state->instance = atomic_inc_return(&drv_instance) - 1;
-}
+	static atomic_t drv_instance = ATOMIC_INIT(0);
+
+	static int drv_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
+	{
+		...
+		state->instance = atomic_inc_return(&drv_instance) - 1;
+	}
 
 If you have multiple device nodes then it can be difficult to know when it is
 safe to unregister v4l2_device for hotpluggable devices. For this purpose
@@ -193,11 +205,15 @@ callback is called. You can do your final cleanup there.
 If other device nodes (e.g. ALSA) are created, then you can increase and
 decrease the refcount manually as well by calling:
 
-void v4l2_device_get(struct v4l2_device *v4l2_dev);
+.. code-block:: none
+
+	void v4l2_device_get(struct v4l2_device *v4l2_dev);
 
 or:
 
-int v4l2_device_put(struct v4l2_device *v4l2_dev);
+.. code-block:: none
+
+	int v4l2_device_put(struct v4l2_device *v4l2_dev);
 
 Since the initial refcount is 1 you also need to call v4l2_device_put in the
 disconnect() callback (for USB devices) or in the remove() callback (for e.g.
@@ -249,35 +265,37 @@ may be NULL if the subdev driver does not support anything from that category.
 
 It looks like this:
 
-struct v4l2_subdev_core_ops {
-	int (*log_status)(struct v4l2_subdev *sd);
-	int (*init)(struct v4l2_subdev *sd, u32 val);
-	...
-};
+.. code-block:: none
 
-struct v4l2_subdev_tuner_ops {
-	...
-};
+	struct v4l2_subdev_core_ops {
+		int (*log_status)(struct v4l2_subdev *sd);
+		int (*init)(struct v4l2_subdev *sd, u32 val);
+		...
+	};
 
-struct v4l2_subdev_audio_ops {
-	...
-};
+	struct v4l2_subdev_tuner_ops {
+		...
+	};
 
-struct v4l2_subdev_video_ops {
-	...
-};
+	struct v4l2_subdev_audio_ops {
+		...
+	};
 
-struct v4l2_subdev_pad_ops {
-	...
-};
+	struct v4l2_subdev_video_ops {
+		...
+	};
 
-struct v4l2_subdev_ops {
-	const struct v4l2_subdev_core_ops  *core;
-	const struct v4l2_subdev_tuner_ops *tuner;
-	const struct v4l2_subdev_audio_ops *audio;
-	const struct v4l2_subdev_video_ops *video;
-	const struct v4l2_subdev_pad_ops *video;
-};
+	struct v4l2_subdev_pad_ops {
+		...
+	};
+
+	struct v4l2_subdev_ops {
+		const struct v4l2_subdev_core_ops  *core;
+		const struct v4l2_subdev_tuner_ops *tuner;
+		const struct v4l2_subdev_audio_ops *audio;
+		const struct v4l2_subdev_video_ops *video;
+		const struct v4l2_subdev_pad_ops *video;
+	};
 
 The core ops are common to all subdevs, the other categories are implemented
 depending on the sub-device. E.g. a video device is unlikely to support the
@@ -288,6 +306,8 @@ to add new ops and categories.
 
 A sub-device driver initializes the v4l2_subdev struct using:
 
+.. code-block:: none
+
 	v4l2_subdev_init(sd, &ops);
 
 Afterwards you need to initialize subdev->name with a unique name and set the
@@ -297,6 +317,8 @@ If integration with the media framework is needed, you must initialize the
 media_entity struct embedded in the v4l2_subdev struct (entity field) by
 calling media_entity_pads_init(), if the entity has pads:
 
+.. code-block:: none
+
 	struct media_pad *pads = &my_sd->pads;
 	int err;
 
@@ -311,6 +333,8 @@ subdev device node (if any) is opened/closed.
 
 Don't forget to cleanup the media entity before the sub-device is destroyed:
 
+.. code-block:: none
+
 	media_entity_cleanup(&sd->entity);
 
 If the subdev driver intends to process video and integrate with the media
@@ -351,6 +375,8 @@ run-time bridge-subdevice interaction is in both cases the same.
 In the synchronous case a device (bridge) driver needs to register the
 v4l2_subdev with the v4l2_device:
 
+.. code-block:: none
+
 	int err = v4l2_device_register_subdev(v4l2_dev, sd);
 
 This can fail if the subdev module disappeared before it could be registered.
@@ -362,16 +388,22 @@ entity will be automatically registered with the media device.
 
 You can unregister a sub-device using:
 
+.. code-block:: none
+
 	v4l2_device_unregister_subdev(sd);
 
 Afterwards the subdev module can be unloaded and sd->dev == NULL.
 
 You can call an ops function either directly:
 
+.. code-block:: none
+
 	err = sd->ops->core->g_std(sd, &norm);
 
 but it is better and easier to use this macro:
 
+.. code-block:: none
+
 	err = v4l2_subdev_call(sd, core, g_std, &norm);
 
 The macro will to the right NULL pointer checks and returns -ENODEV if subdev
@@ -380,11 +412,15 @@ NULL, or the actual result of the subdev->ops->core->g_std ops.
 
 It is also possible to call all or a subset of the sub-devices:
 
+.. code-block:: none
+
 	v4l2_device_call_all(v4l2_dev, 0, core, g_std, &norm);
 
 Any subdev that does not support this ops is skipped and error results are
 ignored. If you want to check for errors use this:
 
+.. code-block:: none
+
 	err = v4l2_device_call_until_err(v4l2_dev, 0, core, g_std, &norm);
 
 Any error except -ENOIOCTLCMD will exit the loop with that error. If no
@@ -509,13 +545,17 @@ you can just create a v4l2_subdev directly.
 A typical state struct would look like this (where 'chipname' is replaced by
 the name of the chip):
 
-struct chipname_state {
-	struct v4l2_subdev sd;
-	...  /* additional state fields */
-};
+.. code-block:: none
+
+	struct chipname_state {
+		struct v4l2_subdev sd;
+		...  /* additional state fields */
+	};
 
 Initialize the v4l2_subdev struct as follows:
 
+.. code-block:: none
+
 	v4l2_i2c_subdev_init(&state->sd, client, subdev_ops);
 
 This function will fill in all the fields of v4l2_subdev and ensure that the
@@ -524,17 +564,23 @@ v4l2_subdev and i2c_client both point to one another.
 You should also add a helper inline function to go from a v4l2_subdev pointer
 to a chipname_state struct:
 
-static inline struct chipname_state *to_state(struct v4l2_subdev *sd)
-{
-	return container_of(sd, struct chipname_state, sd);
-}
+.. code-block:: none
+
+	static inline struct chipname_state *to_state(struct v4l2_subdev *sd)
+	{
+		return container_of(sd, struct chipname_state, sd);
+	}
 
 Use this to go from the v4l2_subdev struct to the i2c_client struct:
 
+.. code-block:: none
+
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
 And this to go from an i2c_client to a v4l2_subdev struct:
 
+.. code-block:: none
+
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 Make sure to call v4l2_device_unregister_subdev(sd) when the remove() callback
@@ -550,8 +596,10 @@ from the remove() callback ensures that this is always done correctly.
 
 The bridge driver also has some helper functions it can use:
 
-struct v4l2_subdev *sd = v4l2_i2c_new_subdev(v4l2_dev, adapter,
-	       "module_foo", "chipid", 0x36, NULL);
+.. code-block:: none
+
+	struct v4l2_subdev *sd = v4l2_i2c_new_subdev(v4l2_dev, adapter,
+					"module_foo", "chipid", 0x36, NULL);
 
 This loads the given module (can be NULL if no module needs to be loaded) and
 calls i2c_new_device() with the given i2c_adapter and chip/address arguments.
@@ -581,15 +629,17 @@ are probed.
 
 For example: this will probe for address 0x10:
 
-struct v4l2_subdev *sd = v4l2_i2c_new_subdev_cfg(v4l2_dev, adapter,
-	       "module_foo", "chipid", 0, NULL, 0, I2C_ADDRS(0x10));
+.. code-block:: none
+
+	struct v4l2_subdev *sd = v4l2_i2c_new_subdev_cfg(v4l2_dev, adapter,
+			  "module_foo", "chipid", 0, NULL, 0, I2C_ADDRS(0x10));
 
 v4l2_i2c_new_subdev_board uses an i2c_board_info struct which is passed
 to the i2c driver and replaces the irq, platform_data and addr arguments.
 
 If the subdev supports the s_config core ops, then that op is called with
 the irq and platform_data arguments after the subdev was setup. The older
-v4l2_i2c_new_(probed_)subdev functions will call s_config as well, but with
+v4l2_i2c_new_(probed\_)subdev functions will call s_config as well, but with
 irq set to 0 and platform_data set to NULL.
 
 struct video_device
@@ -601,6 +651,8 @@ dynamically or embedded in a larger struct.
 
 To allocate it dynamically use:
 
+.. code-block:: none
+
 	struct video_device *vdev = video_device_alloc();
 
 	if (vdev == NULL)
@@ -611,6 +663,8 @@ To allocate it dynamically use:
 If you embed it in a larger struct, then you must set the release()
 callback to your own function:
 
+.. code-block:: none
+
 	struct video_device *vdev = &my_vdev->vdev;
 
 	vdev->release = my_vdev_release;
@@ -684,7 +738,9 @@ In some cases you want to tell the core that a function you had specified in
 your v4l2_ioctl_ops should be ignored. You can mark such ioctls by calling this
 function before video_device_register is called:
 
-void v4l2_disable_ioctl(struct video_device *vdev, unsigned int cmd);
+.. code-block:: none
+
+	void v4l2_disable_ioctl(struct video_device *vdev, unsigned int cmd);
 
 This tends to be needed if based on external factors (e.g. which card is
 being used) you want to turns off certain features in v4l2_ioctl_ops without
@@ -697,6 +753,8 @@ If integration with the media framework is needed, you must initialize the
 media_entity struct embedded in the video_device struct (entity field) by
 calling media_entity_pads_init():
 
+.. code-block:: none
+
 	struct media_pad *pad = &my_vdev->pad;
 	int err;
 
@@ -752,6 +810,8 @@ video_device registration
 Next you register the video device: this will create the character device
 for you.
 
+.. code-block:: none
+
 	err = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
 	if (err) {
 		video_device_release(vdev); /* or kfree(my_vdev); */
@@ -827,16 +887,18 @@ file operations.
 
 It is a bitmask and the following bits can be set:
 
-0x01: Log the ioctl name and error code. VIDIOC_(D)QBUF ioctls are only logged
-      if bit 0x08 is also set.
-0x02: Log the ioctl name arguments and error code. VIDIOC_(D)QBUF ioctls are
-      only logged if bit 0x08 is also set.
-0x04: Log the file operations open, release, read, write, mmap and
-      get_unmapped_area. The read and write operations are only logged if
-      bit 0x08 is also set.
-0x08: Log the read and write file operations and the VIDIOC_QBUF and
-      VIDIOC_DQBUF ioctls.
-0x10: Log the poll file operation.
+.. code-block:: none
+
+	0x01: Log the ioctl name and error code. VIDIOC_(D)QBUF ioctls are only logged
+	      if bit 0x08 is also set.
+	0x02: Log the ioctl name arguments and error code. VIDIOC_(D)QBUF ioctls are
+	      only logged if bit 0x08 is also set.
+	0x04: Log the file operations open, release, read, write, mmap and
+	      get_unmapped_area. The read and write operations are only logged if
+	      bit 0x08 is also set.
+	0x08: Log the read and write file operations and the VIDIOC_QBUF and
+	      VIDIOC_DQBUF ioctls.
+	0x10: Log the poll file operation.
 
 video_device cleanup
 --------------------
@@ -845,6 +907,8 @@ When the video device nodes have to be removed, either during the unload
 of the driver or because the USB device was disconnected, then you should
 unregister them:
 
+.. code-block:: none
+
 	video_unregister_device(vdev);
 
 This will remove the device nodes from sysfs (causing udev to remove them
@@ -861,6 +925,8 @@ callback is called and you can do the final cleanup there.
 Don't forget to cleanup the media entity associated with the video device if
 it has been initialized:
 
+.. code-block:: none
+
 	media_entity_cleanup(&vdev->entity);
 
 This can be done from the release callback.
@@ -875,31 +941,41 @@ There are a few useful helper functions:
 
 You can set/get driver private data in the video_device struct using:
 
-void *video_get_drvdata(struct video_device *vdev);
-void video_set_drvdata(struct video_device *vdev, void *data);
+.. code-block:: none
+
+	void *video_get_drvdata(struct video_device *vdev);
+	void video_set_drvdata(struct video_device *vdev, void *data);
 
 Note that you can safely call video_set_drvdata() before calling
 video_register_device().
 
 And this function:
 
-struct video_device *video_devdata(struct file *file);
+.. code-block:: none
+
+	struct video_device *video_devdata(struct file *file);
 
 returns the video_device belonging to the file struct.
 
 The video_drvdata function combines video_get_drvdata with video_devdata:
 
-void *video_drvdata(struct file *file);
+.. code-block:: none
+
+	void *video_drvdata(struct file *file);
 
 You can go from a video_device struct to the v4l2_device struct using:
 
-struct v4l2_device *v4l2_dev = vdev->v4l2_dev;
+.. code-block:: none
+
+	struct v4l2_device *v4l2_dev = vdev->v4l2_dev;
 
 - Device node name
 
 The video_device node kernel name can be retrieved using
 
-const char *video_device_node_name(struct video_device *vdev);
+.. code-block:: none
+
+	const char *video_device_node_name(struct video_device *vdev);
 
 The name is used as a hint by userspace tools such as udev. The function
 should be used where possible instead of accessing the video_device::num and
@@ -943,64 +1019,74 @@ v4l2_fh_del+v4l2_fh_exit in release().
 Drivers can extract their own file handle structure by using the container_of
 macro. Example:
 
-struct my_fh {
-	int blah;
-	struct v4l2_fh fh;
-};
+.. code-block:: none
 
-...
-
-int my_open(struct file *file)
-{
-	struct my_fh *my_fh;
-	struct video_device *vfd;
-	int ret;
+	struct my_fh {
+		int blah;
+		struct v4l2_fh fh;
+	};
 
 	...
 
-	my_fh = kzalloc(sizeof(*my_fh), GFP_KERNEL);
+	int my_open(struct file *file)
+	{
+		struct my_fh *my_fh;
+		struct video_device *vfd;
+		int ret;
 
-	...
+		...
 
-	v4l2_fh_init(&my_fh->fh, vfd);
+		my_fh = kzalloc(sizeof(*my_fh), GFP_KERNEL);
 
-	...
+		...
 
-	file->private_data = &my_fh->fh;
-	v4l2_fh_add(&my_fh->fh);
-	return 0;
-}
+		v4l2_fh_init(&my_fh->fh, vfd);
 
-int my_release(struct file *file)
-{
-	struct v4l2_fh *fh = file->private_data;
-	struct my_fh *my_fh = container_of(fh, struct my_fh, fh);
+		...
 
-	...
-	v4l2_fh_del(&my_fh->fh);
-	v4l2_fh_exit(&my_fh->fh);
-	kfree(my_fh);
-	return 0;
-}
+		file->private_data = &my_fh->fh;
+		v4l2_fh_add(&my_fh->fh);
+		return 0;
+	}
+
+	int my_release(struct file *file)
+	{
+		struct v4l2_fh *fh = file->private_data;
+		struct my_fh *my_fh = container_of(fh, struct my_fh, fh);
+
+		...
+		v4l2_fh_del(&my_fh->fh);
+		v4l2_fh_exit(&my_fh->fh);
+		kfree(my_fh);
+		return 0;
+	}
 
 Below is a short description of the v4l2_fh functions used:
 
-void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
+.. code-block:: none
+
+	void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 
   Initialise the file handle. This *MUST* be performed in the driver's
   v4l2_file_operations->open() handler.
 
-void v4l2_fh_add(struct v4l2_fh *fh)
+.. code-block:: none
+
+	void v4l2_fh_add(struct v4l2_fh *fh)
 
   Add a v4l2_fh to video_device file handle list. Must be called once the
   file handle is completely initialized.
 
-void v4l2_fh_del(struct v4l2_fh *fh)
+.. code-block:: none
+
+	void v4l2_fh_del(struct v4l2_fh *fh)
 
   Unassociate the file handle from video_device(). The file handle
   exit function may now be called.
 
-void v4l2_fh_exit(struct v4l2_fh *fh)
+.. code-block:: none
+
+	void v4l2_fh_exit(struct v4l2_fh *fh)
 
   Uninitialise the file handle. After uninitialisation the v4l2_fh
   memory can be freed.
@@ -1008,12 +1094,16 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 
 If struct v4l2_fh is not embedded, then you can use these helper functions:
 
-int v4l2_fh_open(struct file *filp)
+.. code-block:: none
+
+	int v4l2_fh_open(struct file *filp)
 
   This allocates a struct v4l2_fh, initializes it and adds it to the struct
   video_device associated with the file struct.
 
-int v4l2_fh_release(struct file *filp)
+.. code-block:: none
+
+	int v4l2_fh_release(struct file *filp)
 
   This deletes it from the struct video_device associated with the file
   struct, uninitialised the v4l2_fh and frees it.
@@ -1027,11 +1117,15 @@ when the last file handle closes. Two helper functions were added to check
 whether the v4l2_fh struct is the only open filehandle of the associated
 device node:
 
-int v4l2_fh_is_singular(struct v4l2_fh *fh)
+.. code-block:: none
+
+	int v4l2_fh_is_singular(struct v4l2_fh *fh)
 
   Returns 1 if the file handle is the only open file handle, else 0.
 
-int v4l2_fh_is_singular_file(struct file *filp)
+.. code-block:: none
+
+	int v4l2_fh_is_singular_file(struct file *filp)
 
   Same, but it calls v4l2_fh_is_singular with filp->private_data.
 
@@ -1075,15 +1169,19 @@ fast.
 
 Useful functions:
 
-void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
+.. code-block:: none
+
+	void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
 
   Queue events to video device. The driver's only responsibility is to fill
   in the type and the data fields. The other fields will be filled in by
   V4L2.
 
-int v4l2_event_subscribe(struct v4l2_fh *fh,
-			 struct v4l2_event_subscription *sub, unsigned elems,
-			 const struct v4l2_subscribed_event_ops *ops)
+.. code-block:: none
+
+	int v4l2_event_subscribe(struct v4l2_fh *fh,
+				 struct v4l2_event_subscription *sub, unsigned elems,
+				 const struct v4l2_subscribed_event_ops *ops)
 
   The video_device->ioctl_ops->vidioc_subscribe_event must check the driver
   is able to produce events with specified event id. Then it calls
@@ -1102,8 +1200,10 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
   All 4 callbacks are optional, if you don't want to specify any callbacks
   the ops argument itself maybe NULL.
 
-int v4l2_event_unsubscribe(struct v4l2_fh *fh,
-			   struct v4l2_event_subscription *sub)
+.. code-block:: none
+
+	int v4l2_event_unsubscribe(struct v4l2_fh *fh,
+				   struct v4l2_event_subscription *sub)
 
   vidioc_unsubscribe_event in struct v4l2_ioctl_ops. A driver may use
   v4l2_event_unsubscribe() directly unless it wants to be involved in
@@ -1112,7 +1212,9 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
   The special type V4L2_EVENT_ALL may be used to unsubscribe all events. The
   drivers may want to handle this in a special way.
 
-int v4l2_event_pending(struct v4l2_fh *fh)
+.. code-block:: none
+
+	int v4l2_event_pending(struct v4l2_fh *fh)
 
   Returns the number of pending events. Useful when implementing poll.
 
-- 
2.7.4

