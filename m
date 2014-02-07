Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64947 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaBGVLv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 16:11:51 -0500
From: Bryan Wu <cooloney@gmail.com>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH] media: soc-camera: support deferred probing of clients and OF cameras
Date: Fri,  7 Feb 2014 13:11:44 -0800
Message-Id: <1391807504-8946-1-git-send-email-pengw@nvidia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Currently soc-camera doesn't work with independently registered I2C client
devices, it has to register them itself. This patch adds support for such
configurations, in which case client drivers have to request deferred
probing until their host becomes available and enables the data interface.

With OF we aren't getting platform data any more. To minimise changes we
create all the missing data ourselves, including compulsory struct
soc_camera_link objects. Host-client linking is now done, based on the OF
data. Media bus numbers also have to be assigned dynamically.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Bryan Wu <pengw@nvidia.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 396 ++++++++++++++++++++++++-
 include/media/soc_camera.h                     |   9 +
 2 files changed, 399 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 4b8c024..560d5ab 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -23,6 +23,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
@@ -36,6 +37,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-of.h>
 #include <media/videobuf-core.h>
 #include <media/videobuf2-core.h>
 
@@ -49,6 +51,7 @@
 	 vb2_is_streaming(&(icd)->vb2_vidq))
 
 #define MAP_MAX_NUM 32
+static DECLARE_BITMAP(host_map, MAP_MAX_NUM);
 static DECLARE_BITMAP(device_map, MAP_MAX_NUM);
 static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
@@ -58,6 +61,17 @@ static LIST_HEAD(devices);
  */
 static DEFINE_MUTEX(list_lock);
 
+struct soc_camera_of_client {
+	struct soc_camera_desc *sdesc;
+	struct v4l2_of_endpoint ep;
+	struct platform_device *pdev;
+	struct dev_archdata archdata;
+	struct device_node *link_node;
+	union {
+		struct i2c_board_info i2c_info;
+	};
+};
+
 struct soc_camera_async_client {
 	struct v4l2_async_subdev *sensor;
 	struct v4l2_async_notifier notifier;
@@ -67,6 +81,8 @@ struct soc_camera_async_client {
 
 static int soc_camera_video_start(struct soc_camera_device *icd);
 static int video_dev_create(struct soc_camera_device *icd);
+static void soc_camera_of_i2c_info(struct device_node *node,
+				  struct soc_camera_of_client *sofc);
 
 int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc *ssdd,
 			struct v4l2_clk *clk)
@@ -817,6 +833,7 @@ static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
 	if (icd->streamer != file)
 		return POLLERR;
 
+	mutex_lock(&list_lock);
 	mutex_lock(&ici->host_lock);
 	if (ici->ops->init_videobuf && list_empty(&icd->vb_vidq.stream))
 		dev_err(icd->pdev, "Trying to poll with no queued buffers!\n");
@@ -1169,6 +1186,144 @@ static void scan_add_host(struct soc_camera_host *ici)
 	mutex_unlock(&list_lock);
 }
 
+static struct soc_camera_of_client *
+soc_camera_of_alloc_client(const struct soc_camera_host *ici,
+			  struct device_node *ep)
+{
+	struct soc_camera_of_client *sofc;
+	struct soc_camera_desc *sdesc;
+	int i, ret;
+
+	sofc = devm_kzalloc(ici->v4l2_dev.dev, sizeof(*sofc), GFP_KERNEL);
+	if (!sofc)
+		return NULL;
+
+	sdesc = devm_kzalloc(ici->v4l2_dev.dev, sizeof(*sdesc), GFP_KERNEL);
+	if (!sdesc)
+		return NULL;
+
+	sdesc->host_desc.host_wait = true;
+
+	mutex_lock(&list_lock);
+	i = find_first_zero_bit(device_map, MAP_MAX_NUM);
+	if (i < MAP_MAX_NUM)
+		set_bit(i, device_map);
+	mutex_unlock(&list_lock);
+	if (i >= MAP_MAX_NUM)
+		return NULL;
+	sofc->pdev = platform_device_alloc("soc-camera-pdrv", i);
+	if (!sofc->pdev)
+		return NULL;
+
+	sdesc->host_desc.ep = &sofc->ep;
+	sdesc->host_desc.bus_id = ici->nr;
+
+	ret = platform_device_add_data(sofc->pdev, sdesc, sizeof(*sdesc));
+	if (ret < 0)
+		return NULL;
+	sofc->sdesc = sofc->pdev->dev.platform_data;
+
+	soc_camera_of_i2c_info(ep, sofc);
+
+	return sofc;
+}
+
+static int soc_camera_of_register_client(struct soc_camera_of_client *sofc)
+{
+	return platform_device_add(sofc->pdev);
+}
+
+struct soc_camera_wait_pdev {
+	struct notifier_block nb;
+	struct completion complete;
+	struct soc_camera_desc *sdesc;
+};
+
+static int wait_complete(struct notifier_block *nb,
+			 unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct soc_camera_wait_pdev *wait = container_of(nb,
+					struct soc_camera_wait_pdev, nb);
+
+	if (dev->platform_data == wait->sdesc &&
+	    action == BUS_NOTIFY_BOUND_DRIVER) {
+		complete(&wait->complete);
+		return NOTIFY_OK;
+	}
+	return NOTIFY_DONE;
+}
+
+static void scan_of_host(struct soc_camera_host *ici)
+{
+	struct soc_camera_of_client *sofc;
+	struct soc_camera_device *icd;
+	struct device_node *node = NULL;
+
+	for (;;) {
+		struct soc_camera_wait_pdev wait = {
+			.nb.notifier_call = wait_complete,
+		};
+		int ret;
+
+		node = v4l2_of_get_next_endpoint(ici->v4l2_dev.dev->of_node,
+					       node);
+		if (!node)
+			break;
+
+		if (ici->ops->of_node_internal &&
+		    ici->ops->of_node_internal(node)) {
+			/* No icd is needed for this link */
+			of_node_put(node);
+			continue;
+		}
+
+		sofc = soc_camera_of_alloc_client(ici, node);
+		if (!sofc) {
+			dev_err(ici->v4l2_dev.dev,
+				"%s(): failed to create a client device\n",
+				__func__);
+			of_node_put(node);
+			break;
+		}
+		v4l2_of_parse_endpoint(node, &sofc->ep);
+
+		init_completion(&wait.complete);
+		wait.sdesc = sofc->sdesc;
+		bus_register_notifier(&platform_bus_type, &wait.nb);
+
+		ret = soc_camera_of_register_client(sofc);
+		if (ret < 0) {
+			/* Useless thing, but keep trying */
+			platform_device_put(sofc->pdev);
+			of_node_put(node);
+			continue;
+		}
+
+		wait_for_completion(&wait.complete);
+		/* soc_camera_pdrv_probe() probed successfully */
+		bus_unregister_notifier(&platform_bus_type, &wait.nb);
+
+		icd = platform_get_drvdata(sofc->pdev);
+		if (!icd) {
+			/* Cannot be... */
+			platform_device_put(sofc->pdev);
+			of_node_put(node);
+			continue;
+		}
+
+		icd->parent = ici->v4l2_dev.dev;
+		mutex_lock(&list_lock);
+		ret = soc_camera_probe(ici, icd);
+		mutex_unlock(&list_lock);
+		sofc->link_node = node;
+		/*
+		 * We could destroy the icd in there error case here, but the
+		 * non-OF version doesn't do that, so, we can keep it around too
+		 */
+	}
+}
+
 /*
  * It is invalid to call v4l2_clk_enable() after a successful probing
  * asynchronously outside of V4L2 operations, i.e. with .host_lock not held.
@@ -1231,6 +1386,7 @@ static int soc_camera_dyn_pdev(struct soc_camera_desc *sdesc,
 {
 	struct platform_device *pdev;
 	int ret, i;
+	struct v4l2_of_endpoint *ep = sdesc->host_desc.ep;
 
 	mutex_lock(&list_lock);
 	i = find_first_zero_bit(device_map, MAP_MAX_NUM);
@@ -1252,6 +1408,17 @@ static int soc_camera_dyn_pdev(struct soc_camera_desc *sdesc,
 
 	sasc->pdev = pdev;
 
+	if (ep) {
+		struct soc_camera_of_client *sofc = container_of(ep,
+					struct soc_camera_of_client, ep);
+		struct device_node *node = sofc->link_node;
+		/* Don't dead-lock: remove the device here under the lock */
+		clear_bit(sofc->pdev->id, device_map);
+		if (node)
+			of_node_put(node);
+		platform_device_unregister(sofc->pdev);
+	}
+
 	return 0;
 }
 
@@ -1318,6 +1485,161 @@ eusrfmt:
 }
 
 #ifdef CONFIG_I2C_BOARDINFO
+static void soc_camera_of_i2c_ifill(struct soc_camera_of_client *sofc,
+		struct i2c_client *client)
+{
+	struct i2c_board_info *info = &sofc->i2c_info;
+	struct soc_camera_desc *sdesc = sofc->sdesc;
+
+	/* on OF I2C devices platform_data == NULL */
+	info->flags = client->flags;
+	info->addr = client->addr;
+	info->irq = client->irq;
+	info->archdata = &sofc->archdata;
+
+	/* archdata is always empty on OF I2C devices */
+	strlcpy(info->type, client->name, sizeof(info->type));
+
+	sdesc->host_desc.i2c_adapter_id = client->adapter->nr;
+}
+
+static bool soc_camera_i2c_client_match(struct soc_camera_desc *sdesc,
+		struct i2c_client *client)
+{
+	if (sdesc->host_desc.ep) {
+		struct device_node *of_node = sdesc->host_desc.board_info->of_node;
+		struct i2c_client *expected;
+
+		expected = of_find_i2c_device_by_node(of_node);
+		if (!expected)
+			return false;
+
+		put_device(&expected->dev);
+
+		return expected == client;
+	}
+
+	return client->addr == sdesc->host_desc.board_info->addr &&
+		client->adapter->nr == sdesc->host_desc.i2c_adapter_id;
+}
+
+static int soc_camera_i2c_notify(struct notifier_block *nb,
+				 unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct i2c_client *client = to_i2c_client(dev);
+	struct soc_camera_device *icd = container_of(nb, struct soc_camera_device, notifier);
+	struct soc_camera_desc *sdesc = to_soc_camera_desc(icd);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct v4l2_of_endpoint *ep;
+	struct v4l2_subdev_platform_data *sd_pdata;
+	struct i2c_adapter *adap = NULL;
+	struct v4l2_subdev *subdev;
+	int ret;
+
+	dev_dbg(dev, "%s(%lu): %x on %u\n", __func__, action,
+		client->addr, client->adapter->nr);
+
+	if (!soc_camera_i2c_client_match(sdesc, client))
+		return NOTIFY_DONE;
+
+	ep = sdesc->host_desc.ep;
+	sd_pdata = &sdesc->subdev_desc.sd_pdata;
+
+	switch (action) {
+	case BUS_NOTIFY_BIND_DRIVER:
+		client->dev.platform_data = sdesc;
+		if (ep) {
+			struct soc_camera_of_client *sofc = container_of(ep,
+						struct soc_camera_of_client, ep);
+			soc_camera_of_i2c_ifill(sofc, client);
+		}
+
+		return NOTIFY_OK;
+	case BUS_NOTIFY_BOUND_DRIVER:
+		adap = i2c_get_adapter(sdesc->host_desc.i2c_adapter_id);
+		if (!adap)
+			break;
+
+		if (!try_module_get(dev->driver->owner))
+			/* clean up */
+			break;
+
+		subdev = i2c_get_clientdata(client);
+
+		if (v4l2_device_register_subdev(&ici->v4l2_dev, subdev))
+			subdev = NULL;
+
+		module_put(dev->driver->owner);
+
+		if (!subdev)
+			break;
+		client = v4l2_get_subdevdata(subdev);
+		icd->control = &client->dev;
+		mutex_lock(&ici->host_lock);
+		ret = soc_camera_probe_finish(icd);
+		mutex_unlock(&ici->host_lock);
+		if (ret < 0)
+			break;
+
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	if (adap)
+		i2c_put_adapter(adap);
+	if (icd->vdev) {
+		video_device_release(icd->vdev);
+		icd->vdev = NULL;
+	}
+	regulator_bulk_free(sd_pdata->num_regulators, sd_pdata->regulators);
+	v4l2_ctrl_handler_free(&icd->ctrl_handler);
+
+	return NOTIFY_DONE;
+}
+
+static void soc_camera_of_i2c_info(struct device_node *node,
+		struct soc_camera_of_client *sofc)
+{
+	struct i2c_client *client;
+	struct soc_camera_desc *sdesc = sofc->sdesc;
+	struct i2c_board_info *info = &sofc->i2c_info;
+	struct device_node *port, *sensor, *bus;
+
+	port = v4l2_of_get_remote_port(node);
+	if (!port)
+		return;
+
+	/* Check the bus */
+	sensor = of_get_parent(port);
+	bus = of_get_parent(sensor);
+
+	if (of_node_cmp(bus->name, "i2c")) {
+		of_node_put(port);
+		of_node_put(sensor);
+		of_node_put(bus);
+		return;
+	}
+
+	info->of_node = sensor;
+	sdesc->host_desc.board_info = info;
+
+	client = of_find_i2c_device_by_node(sensor);
+	/*
+	 * of_i2c_register_devices() took a reference to the OF node, it is not
+	 * dropped, when the I2C device is removed, so, we don't need an
+	 * additional reference.
+	 */
+	of_node_put(sensor);
+	if (client) {
+		soc_camera_of_i2c_ifill(sofc, client);
+		put_device(&client->dev);
+	}
+
+	/* client hasn't attached to I2C yet */
+}
+
 static int soc_camera_i2c_init(struct soc_camera_device *icd,
 			       struct soc_camera_desc *sdesc)
 {
@@ -1336,6 +1658,15 @@ static int soc_camera_i2c_init(struct soc_camera_device *icd,
 		return -EPROBE_DEFER;
 	}
 
+	if (sdesc->host_desc.host_wait) {
+		int ret;
+		icd->notifier.notifier_call = soc_camera_i2c_notify;
+		ret = bus_register_notifier(&i2c_bus_type, &icd->notifier);
+		if (!ret)
+			return -EPROBE_DEFER;
+		return ret;
+	}
+
 	ici = to_soc_camera_host(icd->parent);
 	adap = i2c_get_adapter(shd->i2c_adapter_id);
 	if (!adap) {
@@ -1375,6 +1706,7 @@ static int soc_camera_i2c_init(struct soc_camera_device *icd,
 		ret = -ENODEV;
 		goto ei2cnd;
 	}
+	mutex_unlock(&list_lock);
 
 	client = v4l2_get_subdevdata(subdev);
 
@@ -1413,6 +1745,27 @@ static void soc_camera_i2c_free(struct soc_camera_device *icd)
 	icd->clk = NULL;
 }
 
+static void soc_camera_i2c_reprobe(struct soc_camera_device *icd)
+{
+	struct i2c_client *client =
+		to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_adapter *adap;
+
+	if (icd->notifier.notifier_call == soc_camera_i2c_notify)
+		bus_unregister_notifier(&i2c_bus_type, &icd->notifier);
+
+	if (!icd->control)
+		return;
+
+	adap = client->adapter;
+
+	icd->control = NULL;
+	v4l2_device_unregister_subdev(i2c_get_clientdata(client));
+	/* Put device back in deferred-probing state */
+	i2c_unregister_device(client);
+	i2c_new_device(adap, icd->sdesc->host_desc.board_info);
+}
+
 /*
  * V4L2 asynchronous notifier callbacks. They are all called under a v4l2-async
  * internal global mutex, therefore cannot race against other asynchronous
@@ -1577,6 +1930,8 @@ static void scan_async_host(struct soc_camera_host *ici)
 #define soc_camera_i2c_init(icd, sdesc)	(-ENODEV)
 #define soc_camera_i2c_free(icd)	do {} while (0)
 #define scan_async_host(ici)		do {} while (0)
+#define soc_camera_i2c_reprobe(icd)	do {} while (0)
+#define soc_camera_of_i2c_info(node, sofc)	do {} while (0)
 #endif
 
 /* Called during host-driver probe */
@@ -1615,7 +1970,9 @@ static int soc_camera_probe(struct soc_camera_host *ici,
 	/* Non-i2c cameras, e.g., soc_camera_platform, have no board_info */
 	if (shd->board_info) {
 		ret = soc_camera_i2c_init(icd, sdesc);
-		if (ret < 0 && ret != -EPROBE_DEFER)
+		if (ret == -EPROBE_DEFER)
+			return 0;
+		if (ret < 0)
 			goto eadd;
 	} else if (!shd->add_device || !shd->del_device) {
 		ret = -EINVAL;
@@ -1697,7 +2054,10 @@ static int soc_camera_remove(struct soc_camera_device *icd)
 	}
 
 	if (sdesc->host_desc.board_info) {
-		soc_camera_i2c_free(icd);
+		if (sdesc->host_desc.host_wait)
+			soc_camera_i2c_reprobe(icd);
+		else
+			soc_camera_i2c_free(icd);
 	} else {
 		struct device *dev = to_soc_camera_control(icd);
 		struct device_driver *drv = dev ? dev->driver : NULL;
@@ -1813,17 +2173,34 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 		ici->ops->enum_framesizes = default_enum_framesizes;
 
 	mutex_lock(&list_lock);
-	list_for_each_entry(ix, &hosts, list) {
-		if (ix->nr == ici->nr) {
+	if (ici->nr == (unsigned char)-1) {
+		/* E.g. OF host: dynamic number */
+		/* TODO: consider using IDR */
+		ici->nr = find_first_zero_bit(host_map, MAP_MAX_NUM);
+		if (ici->nr >= MAP_MAX_NUM) {
 			ret = -EBUSY;
 			goto edevreg;
 		}
+	} else {
+		if (ici->nr >= MAP_MAX_NUM) {
+			ret = -EINVAL;
+			goto edevreg;
+		}
+
+		list_for_each_entry(ix, &hosts, list) {
+			if (ix->nr == ici->nr) {
+				ret = -EBUSY;
+				goto edevreg;
+			}
+		}
 	}
 
 	ret = v4l2_device_register(ici->v4l2_dev.dev, &ici->v4l2_dev);
 	if (ret < 0)
 		goto edevreg;
 
+	set_bit(ici->nr, host_map);
+
 	list_add_tail(&ici->list, &hosts);
 	mutex_unlock(&list_lock);
 
@@ -1837,9 +2214,11 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 		 * dynamically!
 		 */
 		scan_async_host(ici);
-	else
+	else if (!ici->v4l2_dev.dev->of_node)
 		/* Legacy: static platform devices from board data */
 		scan_add_host(ici);
+	else	/* Scan subdevices from OF info */
+		scan_of_host(ici);
 
 	return 0;
 
@@ -1857,6 +2236,8 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 	LIST_HEAD(notifiers);
 
 	mutex_lock(&list_lock);
+
+	clear_bit(ici->nr, host_map);
 	list_del(&ici->list);
 	list_for_each_entry(icd, &devices, list)
 		if (icd->iface == ici->nr && icd->sasc) {
@@ -1875,7 +2256,10 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 	mutex_lock(&list_lock);
 
 	list_for_each_entry_safe(icd, tmp, &devices, list)
-		if (icd->iface == ici->nr)
+		if (icd->iface == ici->nr &&
+		    icd->parent == ici->v4l2_dev.dev &&
+		    (to_soc_camera_control(icd) ||
+			icd->sdesc->host_desc.host_wait))
 			soc_camera_remove(icd);
 
 	mutex_unlock(&list_lock);
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 865246b..8b9e73f 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -51,6 +51,7 @@ struct soc_camera_device {
 	/* soc_camera.c private count. Only accessed with .host_lock held */
 	int use_count;
 	struct file *streamer;		/* stream owner */
+	struct notifier_block notifier;	/* Bus-event notifier */
 	struct v4l2_clk *clk;
 	/* Asynchronous subdevice management */
 	struct soc_camera_async_client *sasc;
@@ -90,6 +91,8 @@ struct soc_camera_host {
 	unsigned int *asd_sizes;	/* 0-terminated array of asd group sizes */
 };
 
+struct device_node;
+
 struct soc_camera_host_ops {
 	struct module *owner;
 	int (*add)(struct soc_camera_device *);
@@ -128,6 +131,7 @@ struct soc_camera_host_ops {
 	int (*set_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
 	int (*enum_framesizes)(struct soc_camera_device *, struct v4l2_frmsizeenum *);
 	unsigned int (*poll)(struct file *, poll_table *);
+	bool (*of_node_internal)(const struct device_node *);
 };
 
 #define SOCAM_SENSOR_INVERT_PCLK	(1 << 0)
@@ -138,6 +142,7 @@ struct soc_camera_host_ops {
 
 struct i2c_board_info;
 struct regulator_bulk_data;
+struct v4l2_of_endpoint;
 
 struct soc_camera_subdev_desc {
 	/* Per camera SOCAM_SENSOR_* bus flags */
@@ -177,7 +182,9 @@ struct soc_camera_host_desc {
 	int bus_id;
 	int i2c_adapter_id;
 	struct i2c_board_info *board_info;
+	struct v4l2_of_endpoint *ep;
 	const char *module_name;
+	bool host_wait;
 
 	/*
 	 * For non-I2C devices platform has to provide methods to add a device
@@ -242,7 +249,9 @@ struct soc_camera_link {
 	int bus_id;
 	int i2c_adapter_id;
 	struct i2c_board_info *board_info;
+	struct v4l2_of_endpoint *ep;
 	const char *module_name;
+	bool host_wait;
 
 	/*
 	 * For non-I2C devices platform has to provide methods to add a device
-- 
1.8.3.2

