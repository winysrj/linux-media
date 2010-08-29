Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17875 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab0H2KxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Aug 2010 06:53:09 -0400
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L7W00KKOU8JEP@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Sun, 29 Aug 2010 11:53:07 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L7W005TZU8IC2@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Sun, 29 Aug 2010 11:53:07 +0100 (BST)
Date: Sun, 29 Aug 2010 19:52:59 +0900
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 1/2] v4l: add subdev pool
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.nazarewicz@samsung.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1283079180-4702-1-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

The new functionality to v4l2_subdev API is introduced.
The drivers are allowed to register their V4L2 subdevs into
the subdev pool. The subdev can be later accessed by its
name.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
---
 drivers/media/video/Kconfig       |    6 ++
 drivers/media/video/v4l2-common.c |  165 +++++++++++++++++++++++++++++++++++++
 include/media/v4l2-subdev.h       |   59 +++++++++++++
 3 files changed, 230 insertions(+), 0 deletions(-)

Hello everyone,

This patchset adds support for registering V4L2 subdevices into a pool. The
subdevices can be acquired from the pool by its name.

=======================
   Current behavior
=======================

Analyze following scenario depicted on figure below. The sensor is a camera
which grabs a picture and sends it to image processor (IPROC).  The IPROC
performs format conversion, scaling, rotation, etc...  The output picture is
stored in memory.  The driver for IPROC is a V4L2 device.  It communicates with
sensor via the V4L2 subdevice API.  The IPROC driver is responsible for the
initialization of the sensor's subdevice which is usually obtained by calling
one of the two functions: v4l2_i2c_new_subdev or v4l2_spi_new_subdev.  In both
cases the IPROC driver has to know what kind of sensor it is dealing with.
Moreover, it requires I2C/SPI board info to be provided to properly configure
the subdev.

\---------+        +-----------------+
  sensor | -----> | IMAGE PROCESSOR | -----> MEMORY
/---------+        +-----------------+

More complex scenario is shown on figure below.  There are two IPROC devices.
The first one is connected to I2C camera, the second one is connected to SPI
sensor.  The same driver code is used for both processors; therefore SPI/I2C
board info has to be provided in the platform data of the IPROC driver.
Additionally there must be separate code for initialization of the I2C and SPI
cameras.  The driver code becomes more complicated if other types of sensors
are used.

\------------+        +-------------------+
  I2C sensor | -----> | IMAGE PROCESSOR 0 | -----> MEMORY
/------------+        +-------------------+

\------------+        +-------------------+
  SPI sensor | -----> | IMAGE PROCESSOR 1 | -----> MEMORY
/------------+        +-------------------+

=======================
        Purpose
=======================

The proposed functionality simplifies V4L2 sudevice management by introducing a
pool of named subdevs.  The main idea is to split subdev creation from
acquiring the subdev by other drivers.  The registration is performed in a
sensor's probe function.  The subdev is registered in the pool and then it can
be accessed by V4L2 devices using subdev's name.

=======================
         Usage
=======================

------ API ------------

Four new API functions are introduced:

Registration of subdev:

    int v4l2_subdev_pool_register(struct v4l2_subdev *sd,
                                   struct module *owner)
where:
    sd     - the subdevice to be registered in the pool; it must have
             name set.
    module - module that registered a subdev; this protects subdev
             from being unregistered while the subdev is in use.

Unregistering function:

    void v4l2_subdev_pool_unregister(struct v4l2_subdev *sd)

where:
    sd     - subdev to unregister; subdev has to be registered with
             v4l2_subdev_pool_register() first and cannot be used by
             any device.

Acquiring a subdev:

    struct v4l2_subdev *v4l2_subdev_pool_get(char *name)

where:
    name   - the name of subdev in the pool

Releasing a subdev:

    void v4l2_subdev_pool_put(struct v4l2_subdev *sd)

where:
    sd     - subdev to released, subdev has to be obtained by
             v4l2_subdev_pool_get() first.

----- Usage example ---------

The process of registering the I2C subdevice might be following:

    static int sensor_driver_probe(struct i2c_client *client,
                                   const struct i2c_device_id *id)
    {
    	struct v4l2_subdev *sd;
    	int ret;
    	/* ... basic initalization ... */
    	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
    	/* ... setting up subdevice ... */
    	v4l2_i2c_subdev_init(sd, client, &sensor_driver_ops);
	/* setting subdev's name */
	sprintf(sd->name, "sensor_driver");

    	ret = v4l2_subdev_named_register(sd, THIS_MODULE);
    	if (ret) {
    		/* ... error logs + deinitialization ... */
    	}
    	return ret;
    }

The named subdev has to be unregistered at removal of driver module:

    static int sensor_driver_remove(struct i2c_client *client)
    {
    	struct v4l2_subdev *sd = i2c_get_clientdata(client);
    	v4l2_subdev_named_unregister(sd);
    	kfree(sd);
    	return 0;
    }

Finally, the board info has to be registered during platform initialization by
calling i2c_register_board_info().

The V4L2 device that uses a subdev must have the name of slave subdevice.  This
information should be added to devices platform data.

    struct consumer_platform_data {
    	char *slave;
    	/* ... */
    };

    static struct consumer_platform_data platform_data = {
    	.slave = "sensor_driver",
    	... other fields ...
    };

    int consumer_probe(struct platform_device *pdev)
    {
    	/*
    	 * ... initalization, storing platform data to variable
    	 * platform_data ...
    	 */
    	struct v4l2_subdev *sd;
    	sd = v4l2_subdev_named_get(platform_data->slave);
    	if(sd == NULL) {
    		/* ... error info and cleanup ... */
    	}
    	/* ... other task, storing variable sd in device private data ... */
    }

In order to release the subdev please use following template:

    static int fimc_remove(struct platform_device *pdev)
    {
    	struct v4l2_subdev *sd;
    	/* ... obtaining variable sd from device private data ... */
    	v4l2_subdev_named_put(sd);
    	/* ... cleanup .... */
    }

And that's all.  In order to change sensor all one need to do is to change
fields in platform_data variable.  Additionally the drive does not have to
recognize the type of sensor (I2C/SPI/other).


======================
    IMPLEMENTATION
======================

The call to the v4l2_subdev_named_register() function is called, a struct
v4l2_subdev_pool_node object is created and added to the subdev_pool_list list.
All operations on that list are protected by the subdev_pool_mutex mutex.

When driver requests a named subdevice, by calling the v4l2_subdev_named_get()
function, the subdev_pool_list list is traversed in search for a node with
given name.  If no such node is found function returns NULL otherwise, if the
subdevice is not already acquired, the use count of the subdevice's registering
module is increased, subdevice is moved to subdev_acquired_list. The pointer to
the subdevice is returned.

Important thing to note is that try_module_get() may fail if the module is
being removed -- in such situation function returns NULL.  This prevents the
subdevice from being acquired while the module is being removed.

Because the patchset adds a pointer to the v4l2_subdev_pool_node structure, all
that the v4l2_subdev_named_put() needs to do is decrease the use count of the
sebdevice's registering module and move subdev from subdev_acquire_list list
back to subdev_pool_list list.

The last function, v4l2_subdev_named_unregister(), simply removes the
v4l2_subdev_pool_node from the subdev_pool_list list so that the named
subdevice is no longer available.


All comment are welcome. Especially requirements for registering subdevs for
I2C/SPI devices during platform initialization should be examined.

--
Best regards,
Tomasz Stanislawski
Linux Platform Group
Samsung Poland R&D Center

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f6e4d04..e968944 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -49,6 +49,12 @@ config V4L2_MEM2MEM_DEV
 	tristate
 	depends on VIDEOBUF_GEN
 
+config V4L2_SUBDEV_POOL
+	bool
+	help
+	  This symbol is selected by drivers that use subdev pool API.
+	  Drivers that use this API must depend on VIDEO_V4L2_COMMON.
+
 #
 # Multimedia Video device configuration
 #
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 8ee1179..d3d0639 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -676,3 +676,168 @@ int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);
+
+#ifdef CONFIG_V4L2_SUBDEV_POOL
+
+struct v4l2_subdev_pool_node {
+	struct list_head list;
+	struct module *owner;
+	struct v4l2_subdev *sd;
+};
+
+/* container for available subdevs */
+static LIST_HEAD(subdev_pool_list);
+
+/* cintainer for acquired subdevs */
+static LIST_HEAD(subdev_acquired_list);
+
+/* protects subdev_pool_list and subdev_acquired_list */
+static DEFINE_MUTEX(subdev_pool_mutex);
+
+/*
+ * find a pool node that suit to given name from given list
+ * lock subdev_pool_mutex must be down before calling this function
+ */
+static struct v4l2_subdev_pool_node *
+__find_subdev_node_by_name(char *name, struct list_head *head)
+{
+	struct v4l2_subdev_pool_node *node;
+	list_for_each_entry(node, head, list)
+		if (strcmp(node->sd->name, name) == 0)
+			return node;
+	return NULL;
+}
+
+/*
+ * find a pool node associated with given subdev from given list
+ * lock subdev_pool_mutex must be down before calling this function
+ */
+static struct v4l2_subdev_pool_node *
+__find_subdev_node_by_sd(struct v4l2_subdev *sd, struct list_head *head)
+{
+	struct v4l2_subdev_pool_node *node;
+	list_for_each_entry(node, head, list)
+		if (node->sd == sd)
+			return node;
+	return NULL;
+}
+
+int v4l2_subdev_pool_register(struct v4l2_subdev *sd, struct module *owner)
+{
+	int ret;
+	struct v4l2_subdev_pool_node *node;
+	if (WARN_ON(!sd || !sd->name[0]))
+		return -EINVAL;
+	printk(KERN_INFO "%s(%s)\n", __func__, sd->name);
+
+	/* allocation and initialization of new node */
+	node = kmalloc(sizeof *node, GFP_KERNEL);
+	if (node == NULL)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&node->list);
+	node->owner = owner;
+	node->sd = sd;
+
+	mutex_lock(&subdev_pool_mutex);
+	/* checking if subdev is already present in the pool */
+	if (__find_subdev_node_by_name(sd->name, &subdev_pool_list) ||
+	    __find_subdev_node_by_name(sd->name, &subdev_acquired_list)) {
+		WARN(1, "subdev(%s) is already registered\n", sd->name);
+		ret = -EBUSY;
+	} else {
+		/* adding subdev to the pool */
+		list_add_tail(&node->list, &subdev_pool_list);
+		ret = 0;
+	}
+
+	mutex_unlock(&subdev_pool_mutex);
+	/* releasing resources if necessary */
+	if (ret)
+		kfree(node);
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_subdev_pool_register);
+
+void v4l2_subdev_pool_unregister(struct v4l2_subdev *sd)
+{
+	struct v4l2_subdev_pool_node *node;
+	int in_use = 0;
+
+	if (WARN_ON(!sd))
+		return;
+
+	printk(KERN_INFO "%s(%s)\n", __func__, sd->name);
+	mutex_lock(&subdev_pool_mutex);
+
+	node = __find_subdev_node_by_sd(sd, &subdev_pool_list);
+	if (node) {
+		list_del(&node->list);
+	} else {
+		in_use = !!__find_subdev_node_by_sd(sd, &subdev_acquired_list);
+		WARN(!in_use, "tried to unregister not-registered subdev\n");
+	}
+
+	mutex_unlock(&subdev_pool_mutex);
+
+	/*
+	 * Unregistering subdev is use means problem with management
+	 * of module's reference counting. It is a driver bug.
+	 */
+	BUG_ON(in_use);
+
+	kfree(node);
+}
+EXPORT_SYMBOL(v4l2_subdev_pool_unregister);
+
+struct v4l2_subdev *v4l2_subdev_pool_get(char *name)
+{
+	struct v4l2_subdev_pool_node *node;
+	struct v4l2_subdev *sd = NULL;
+	printk(KERN_INFO "%s(%s)\n", __func__, name);
+	mutex_lock(&subdev_pool_mutex);
+	/* checking if subdev is present in pool */
+	node = __find_subdev_node_by_name(name, &subdev_pool_list);
+	if (node == NULL)
+		goto cleanup;
+	/*
+	 * Increasing reference counter for module that REGISTERED
+	 * subdev. It protects the subdev from being unregistered
+	 * while the subdev is in use.
+	 */
+	if (!try_module_get(node->owner))
+		goto cleanup;
+
+	/* moving node from available subdevs list to acquired list */
+	list_del(&node->list);
+	list_add(&node->list, &subdev_acquired_list);
+	sd = node->sd;
+
+cleanup:
+	mutex_unlock(&subdev_pool_mutex);
+	return sd;
+}
+EXPORT_SYMBOL(v4l2_subdev_pool_get);
+
+void v4l2_subdev_pool_put(struct v4l2_subdev *sd)
+{
+	struct v4l2_subdev_pool_node *node;
+
+	if (WARN_ON(!sd))
+		return;
+
+	printk(KERN_INFO "%s(%s)\n", __func__, sd->name);
+	mutex_lock(&subdev_pool_mutex);
+
+	node = __find_subdev_node_by_sd(sd, &subdev_acquired_list);
+	if (!WARN_ON(!node)) {
+		list_del(&node->list);
+		list_add(&node->list, &subdev_pool_list);
+		module_put(node->owner);
+	}
+
+	mutex_unlock(&subdev_pool_mutex);
+}
+EXPORT_SYMBOL(v4l2_subdev_pool_put);
+
+#endif /* CONFIG_V4L2_SUBDEV_POOL */
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 4a97d73..0c44b4f 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -483,4 +483,63 @@ static inline void v4l2_subdev_init(struct v4l2_subdev *sd,
 	((!(sd) || !(sd)->v4l2_dev || !(sd)->v4l2_dev->notify) ? -ENODEV : \
 	 (sd)->v4l2_dev->notify((sd), (notification), (arg)))
 
+#ifdef CONFIG_V4L2_SUBDEV_POOL
+
+/*
+ * API for acquiring subdevices from the pool
+ */
+
+/**
+ * v4l2_subdev_pool_register() - registering subdev to the subdev pool
+ * @sd:		pointer to a subdev to be registered
+ * @owner:	the module that registers the subdev, protects module from
+ *		being unloaded while subdev is in use by other driver
+ *
+ * returns 0 on success
+ */
+int v4l2_subdev_pool_register(struct v4l2_subdev *sd, struct module *owner);
+
+/**
+ * v4l2_subdev_pool_unregister() - unregistering subdev from the subdev pool
+ * @sd:		pointer to a subdev to be unregistered
+ */
+void v4l2_subdev_pool_unregister(struct v4l2_subdev *sd);
+
+/**
+ * v4l2_subdev_pool_get() - acquires subdev in the pool using name
+ * @name:	name of desired subdev
+ *
+ * returns pointer to required subdev or NULL if the subdev is not avaliable
+ */
+struct v4l2_subdev *v4l2_subdev_pool_get(char *name);
+
+/**
+ * releasing subdev aquired using v4l2_subdev_pool_get
+ * @sd:		pointer to a subdev to be returned to pool
+ */
+void v4l2_subdev_pool_put(struct v4l2_subdev *sd);
+
+#else
+
+static inline int
+v4l2_subdev_pool_register(struct v4l2_subdev *sd, struct module *owner)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void v4l2_subdev_pool_unregister(struct v4l2_subdev *sd)
+{
+}
+
+static inline struct v4l2_subdev *v4l2_subdev_pool_get(char *name)
+{
+	return NULL;
+}
+
+static inline void v4l2_subdev_pool_put(struct v4l2_subdev *sd)
+{
+}
+
+#endif /* CONFIG_V4L2_SUBDEV_POOL */
+
 #endif
-- 
1.7.1

