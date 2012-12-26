Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64877 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab2LZRtQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 12:49:16 -0500
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 3/6] soc-camera: add V4L2-async support
Date: Wed, 26 Dec 2012 18:49:08 +0100
Message-Id: <1356544151-6313-4-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for asynchronous subdevice probing, using the v4l2-async API.
The legacy synchronous mode is still supported too, which allows to
gradually update drivers and platforms. The selected approach adds a
notifier for each struct soc_camera_device instance, i.e. for each video
device node, even when there are multiple such instances registered with a
single soc-camera host simultaneously.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/soc_camera.c |  532 ++++++++++++++++++++----
 include/media/soc_camera.h                     |   22 +-
 2 files changed, 467 insertions(+), 87 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index a9e6f01..b962aaa 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -21,22 +21,23 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/list.h>
-#include <linux/mutex.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
-#include <linux/pm_runtime.h>
 #include <linux/vmalloc.h>
 
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf-core.h>
 #include <media/videobuf2-core.h>
-#include <media/soc_mediabus.h>
 
 /* Default to VGA resolution */
 #define DEFAULT_WIDTH	640
@@ -47,23 +48,38 @@
 	 (icd)->vb_vidq.streaming :			\
 	 vb2_is_streaming(&(icd)->vb2_vidq))
 
+#define MAP_MAX_NUM 32
+static DECLARE_BITMAP(device_map, MAP_MAX_NUM);
 static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
-static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
+/*
+ * Protects lists and bitmaps of hosts and devices.
+ * Lock nesting: Ok to take ->host_lock under list_lock.
+ */
+static DEFINE_MUTEX(list_lock);
+
+struct soc_camera_async_client {
+	struct v4l2_async_subdev *sensor;
+	struct v4l2_async_notifier notifier;
+	struct platform_device *pdev;
+};
+
+static int soc_camera_video_start(struct soc_camera_device *icd);
+static int video_dev_create(struct soc_camera_device *icd);
 
 int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc *ssdd,
 			struct v4l2_clk *clk)
 {
 	int ret = clk ? v4l2_clk_enable(clk) : 0;
 	if (ret < 0) {
-		dev_err(dev, "Cannot enable clock\n");
+		dev_err(dev, "Cannot enable clock: %d\n", ret);
 		return ret;
 	}
 	ret = regulator_bulk_enable(ssdd->num_regulators,
 					ssdd->regulators);
 	if (ret < 0) {
 		dev_err(dev, "Cannot enable regulators\n");
-		goto eregenable;;
+		goto eregenable;
 	}
 
 	if (ssdd->power) {
@@ -124,15 +140,20 @@ static int __soc_camera_power_on(struct soc_camera_device *icd)
 	int ret;
 
 	if (!icd->clk) {
+		mutex_lock(&ici->clk_lock);
 		ret = ici->ops->add(icd);
+		mutex_unlock(&ici->clk_lock);
 		if (ret < 0)
 			return ret;
 	}
 
 	ret = v4l2_subdev_call(sd, core, s_power, 1);
 	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV) {
-		if (!icd->clk)
+		if (!icd->clk) {
+			mutex_lock(&ici->clk_lock);
 			ici->ops->remove(icd);
+			mutex_unlock(&ici->clk_lock);
+		}
 		return ret;
 	}
 
@@ -146,8 +167,11 @@ static int __soc_camera_power_off(struct soc_camera_device *icd)
 	int ret;
 
 	ret = v4l2_subdev_call(sd, core, s_power, 0);
-	if (!icd->clk)
+	if (!icd->clk) {
+		mutex_lock(&ici->clk_lock);
 		ici->ops->remove(icd);
+		mutex_unlock(&ici->clk_lock);
+	}
 	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
 		return ret;
 
@@ -623,8 +647,8 @@ static int soc_camera_open(struct file *file)
 	return 0;
 
 	/*
-	 * First four errors are entered with the .host_lock held
-	 * and use_count == 1
+	 * All errors are entered with the .host_lock held, first four also
+	 * with use_count == 1
 	 */
 einitvb:
 esfmt:
@@ -1072,7 +1096,8 @@ static int soc_camera_s_register(struct file *file, void *fh,
 }
 #endif
 
-static int soc_camera_probe(struct soc_camera_device *icd);
+static int soc_camera_probe(struct soc_camera_host *ici,
+			    struct soc_camera_device *icd);
 
 /* So far this function cannot fail */
 static void scan_add_host(struct soc_camera_host *ici)
@@ -1081,12 +1106,20 @@ static void scan_add_host(struct soc_camera_host *ici)
 
 	mutex_lock(&list_lock);
 
-	list_for_each_entry(icd, &devices, list) {
+	list_for_each_entry(icd, &devices, list)
 		if (icd->iface == ici->nr) {
+			struct soc_camera_desc *sdesc = to_soc_camera_desc(icd);
+			struct soc_camera_subdev_desc *ssdd = &sdesc->subdev_desc;
+
+			/* The camera could have been already on, try to reset */
+			if (ssdd->reset)
+				ssdd->reset(icd->pdev);
+
 			icd->parent = ici->v4l2_dev.dev;
-			soc_camera_probe(icd);
+
+			/* Ignore errors */
+			soc_camera_probe(ici, icd);
 		}
-	}
 
 	mutex_unlock(&list_lock);
 }
@@ -1099,6 +1132,7 @@ static int soc_camera_clk_enable(struct v4l2_clk *clk)
 {
 	struct soc_camera_device *icd = clk->priv;
 	struct soc_camera_host *ici;
+	int ret;
 
 	if (!icd || !icd->parent)
 		return -ENODEV;
@@ -1112,7 +1146,10 @@ static int soc_camera_clk_enable(struct v4l2_clk *clk)
 	 * If a different client is currently being probed, the host will tell
 	 * you to go
 	 */
-	return ici->ops->add(icd);
+	mutex_lock(&ici->clk_lock);
+	ret = ici->ops->add(icd);
+	mutex_unlock(&ici->clk_lock);
+	return ret;
 }
 
 static void soc_camera_clk_disable(struct v4l2_clk *clk)
@@ -1125,7 +1162,9 @@ static void soc_camera_clk_disable(struct v4l2_clk *clk)
 
 	ici = to_soc_camera_host(icd->parent);
 
+	mutex_lock(&ici->clk_lock);
 	ici->ops->remove(icd);
+	mutex_unlock(&ici->clk_lock);
 
 	module_put(ici->ops->owner);
 }
@@ -1142,18 +1181,108 @@ static const struct v4l2_clk_ops soc_camera_clk_ops = {
 	.disable = soc_camera_clk_disable,
 };
 
+static int soc_camera_dyn_pdev(struct soc_camera_desc *sdesc,
+			       struct soc_camera_async_client *sasc)
+{
+	struct platform_device *pdev;
+	int ret, i;
+
+	mutex_lock(&list_lock);
+	i = find_first_zero_bit(device_map, MAP_MAX_NUM);
+	if (i < MAP_MAX_NUM)
+		set_bit(i, device_map);
+	mutex_unlock(&list_lock);
+	if (i >= MAP_MAX_NUM)
+		return -ENOMEM;
+
+	pdev = platform_device_alloc("soc-camera-pdrv", i);
+	if (!pdev)
+		return -ENOMEM;
+
+	ret = platform_device_add_data(pdev, sdesc, sizeof(*sdesc));
+	if (ret < 0) {
+		platform_device_put(pdev);
+		return ret;
+	}
+
+	sasc->pdev = pdev;
+
+	return 0;
+}
+
+static struct soc_camera_device *soc_camera_add_pdev(struct soc_camera_async_client *sasc)
+{
+	struct platform_device *pdev = sasc->pdev;
+	int ret;
+
+	ret = platform_device_add(pdev);
+	if (ret < 0 || !pdev->dev.driver)
+		return NULL;
+
+	return platform_get_drvdata(pdev);
+}
+
+/* Locking: called with .host_lock held */
+static int soc_camera_probe_finish(struct soc_camera_device *icd)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct v4l2_mbus_framefmt mf;
+	int ret;
+
+	sd->grp_id = soc_camera_grp_id(icd);
+	v4l2_set_subdev_hostdata(sd, icd);
+
+	ret = v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler, NULL);
+	if (ret < 0)
+		return ret;
+
+	/* At this point client .probe() should have run already */
+	ret = soc_camera_init_user_formats(icd);
+	if (ret < 0)
+		return ret;
+
+	icd->field = V4L2_FIELD_ANY;
+
+	ret = soc_camera_video_start(icd);
+	if (ret < 0)
+		goto evidstart;
+
+	/* Try to improve our guess of a reasonable window format */
+	if (!v4l2_subdev_call(sd, video, g_mbus_fmt, &mf)) {
+		icd->user_width		= mf.width;
+		icd->user_height	= mf.height;
+		icd->colorspace		= mf.colorspace;
+		icd->field		= mf.field;
+	}
+
+	return 0;
+
+evidstart:
+	soc_camera_free_user_formats(icd);
+
+	return ret;
+}
+
 #ifdef CONFIG_I2C_BOARDINFO
-static int soc_camera_init_i2c(struct soc_camera_device *icd,
+static int soc_camera_i2c_init(struct soc_camera_device *icd,
 			       struct soc_camera_desc *sdesc)
 {
 	struct i2c_client *client;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct soc_camera_host *ici;
 	struct soc_camera_host_desc *shd = &sdesc->host_desc;
-	struct i2c_adapter *adap = i2c_get_adapter(shd->i2c_adapter_id);
+	struct i2c_adapter *adap;
 	struct v4l2_subdev *subdev;
 	char clk_name[V4L2_SUBDEV_NAME_SIZE];
 	int ret;
 
+	/* First find out how we link the main client */
+	if (icd->sasc) {
+		/* Async non-OF probing handled by the subdevice list */
+		return -EPROBE_DEFER;
+	}
+
+	ici = to_soc_camera_host(icd->parent);
+	adap = i2c_get_adapter(shd->i2c_adapter_id);
 	if (!adap) {
 		dev_err(icd->pdev, "Cannot get I2C adapter #%d. No driver?\n",
 			shd->i2c_adapter_id);
@@ -1161,7 +1290,6 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 	}
 
 	shd->board_info->platform_data = &sdesc->subdev_desc;
-
 	snprintf(clk_name, sizeof(clk_name), "%s %d-%04x",
 		 shd->board_info->type,
 		 shd->i2c_adapter_id, shd->board_info->addr);
@@ -1187,42 +1315,242 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 	return 0;
 ei2cnd:
 	v4l2_clk_unregister(icd->clk);
-	icd->clk = NULL;
 eclkreg:
+	icd->clk = NULL;
 	i2c_put_adapter(adap);
 	return ret;
 }
 
-static void soc_camera_free_i2c(struct soc_camera_device *icd)
+static void soc_camera_i2c_free(struct soc_camera_device *icd)
 {
 	struct i2c_client *client =
 		to_i2c_client(to_soc_camera_control(icd));
 	struct i2c_adapter *adap = client->adapter;
 
 	icd->control = NULL;
+	if (icd->sasc)
+		return;
 	v4l2_device_unregister_subdev(i2c_get_clientdata(client));
 	i2c_unregister_device(client);
 	i2c_put_adapter(adap);
 	v4l2_clk_unregister(icd->clk);
 	icd->clk = NULL;
 }
+
+/*
+ * V4L2 asynchronous notifier callbacks. They are all called under a v4l2-async
+ * internal global mutex, therefore cannot race against other asynchronous
+ * events. Until notifier->complete() (soc_camera_async_complete()) is called,
+ * the video device node is not registered and no V4L fops can occur. Unloading
+ * of the host driver also calls a v4l2-async function, so also there we're
+ * protected.
+ */
+static int soc_camera_async_bind(struct v4l2_async_notifier *notifier,
+				 struct v4l2_async_subdev_list *asdl)
+{
+	struct soc_camera_async_client *sasc = container_of(notifier,
+					struct soc_camera_async_client, notifier);
+	struct i2c_client *client;
+	struct soc_camera_device *icd;
+	struct soc_camera_host *ici;
+	struct soc_camera_subdev_desc *ssdd;
+	char clk_name[V4L2_SUBDEV_NAME_SIZE];
+	int ret;
+
+	/* Only interested in the sensor, run only once */
+	if (sasc->sensor != asdl->asd ||
+	    asdl->asd->hw.bus_type != V4L2_ASYNC_BUS_I2C)
+		return 0;
+
+	/* Sensor probing */
+	client = to_i2c_client(asdl->dev);
+	icd = platform_get_drvdata(sasc->pdev);
+
+	if (icd->clk)
+		return 0;
+
+	ici = container_of(notifier->v4l2_dev, struct soc_camera_host, v4l2_dev);
+	ssdd = &to_soc_camera_desc(icd)->subdev_desc;
+
+	snprintf(clk_name, sizeof(clk_name), "%s %d-%04x",
+		 asdl->dev->driver->name,
+		 i2c_adapter_id(client->adapter), client->addr);
+
+	/*
+	 * It is ok to keep the clock for the whole soc_camera_device life-time,
+	 * in principle it would be more logical to register the clock on icd
+	 * creation, the only problem is, that at that time we don't know the
+	 * driver name yet.
+	 */
+	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk", icd);
+	if (IS_ERR(icd->clk)) {
+		ret = PTR_ERR(icd->clk);
+		icd->clk = NULL;
+		return ret;
+	}
+
+	/*
+	 * Only now we get subdevice-specific information like regulators,
+	 * flags, callbacks, etc.
+	 */
+	if (asdl->dev->platform_data)
+		memcpy(ssdd, asdl->dev->platform_data, sizeof(*ssdd));
+
+	ret = devm_regulator_bulk_get(asdl->dev, ssdd->num_regulators,
+				      ssdd->regulators);
+	if (ret < 0) {
+		v4l2_clk_unregister(icd->clk);
+		icd->clk = NULL;
+		return ret;
+	}
+
+	/* The camera could have been already on, try to reset */
+	if (ssdd->reset)
+		ssdd->reset(icd->pdev);
+
+	icd->parent = ici->v4l2_dev.dev;
+	icd->control = asdl->dev;
+
+	return 0;
+}
+
+static void soc_camera_async_unbind(struct v4l2_async_notifier *notifier,
+				    struct v4l2_async_subdev_list *asdl)
+{
+	struct soc_camera_async_client *sasc = container_of(notifier,
+					struct soc_camera_async_client, notifier);
+	struct soc_camera_device *icd = platform_get_drvdata(sasc->pdev);
+
+	if (icd->clk) {
+		v4l2_clk_unregister(icd->clk);
+		icd->clk = NULL;
+	}
+}
+
+static int soc_camera_async_bound(struct v4l2_async_notifier *notifier,
+				  struct v4l2_async_subdev_list *asdl)
+{
+	struct soc_camera_async_client *sasc = container_of(notifier,
+					struct soc_camera_async_client, notifier);
+	struct soc_camera_device *icd = platform_get_drvdata(sasc->pdev);
+
+	if (!asdl->subdev) {
+		dev_err(icd->parent,
+			"%s(): Subdevice driver hasn't set subdev pointer!\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	asdl->subdev->grp_id = soc_camera_grp_id(icd);
+	v4l2_set_subdev_hostdata(asdl->subdev, icd);
+
+	return 0;
+}
+
+static int soc_camera_async_complete(struct v4l2_async_notifier *notifier)
+{
+	struct soc_camera_async_client *sasc = container_of(notifier,
+					struct soc_camera_async_client, notifier);
+	struct soc_camera_device *icd = platform_get_drvdata(sasc->pdev);
+
+	if (to_soc_camera_control(icd)) {
+		struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+		int ret;
+
+		mutex_lock(&list_lock);
+		ret = soc_camera_probe(ici, icd);
+		mutex_unlock(&list_lock);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int scan_async_group(struct soc_camera_host *ici,
+			    struct v4l2_async_subdev **asd, int size)
+{
+	struct soc_camera_async_subdev *sasd;
+	struct soc_camera_async_client *sasc;
+	struct soc_camera_device *icd;
+	struct soc_camera_desc sdesc = {.host_desc.bus_id = ici->nr,};
+	int ret, i;
+
+	/* First look for a sensor */
+	for (i = 0; i < size; i++) {
+		sasd = container_of(asd[i], struct soc_camera_async_subdev, asd);
+		if (sasd->role == SOCAM_SUBDEV_DATA_SOURCE)
+			break;
+	}
+
+	if (i == size || asd[i]->hw.bus_type != V4L2_ASYNC_BUS_I2C) {
+		/* All useless */
+		dev_err(ici->v4l2_dev.dev, "No I2C data source found!\n");
+		return -ENODEV;
+	}
+
+	/* Or shall this be managed by the soc-camera device? */
+	sasc = devm_kzalloc(ici->v4l2_dev.dev, sizeof(*sasc), GFP_KERNEL);
+	if (!sasc)
+		return -ENOMEM;
+
+	/* HACK: just need a != NULL */
+	sdesc.host_desc.board_info = ERR_PTR(-ENODATA);
+
+	ret = soc_camera_dyn_pdev(&sdesc, sasc);
+	if (ret < 0)
+		return ret;
+
+	sasc->sensor = &sasd->asd;
+
+	icd = soc_camera_add_pdev(sasc);
+	if (!icd) {
+		platform_device_put(sasc->pdev);
+		return -ENOMEM;
+	}
+
+	sasc->notifier.subdev = asd;
+	sasc->notifier.subdev_num = size;
+	sasc->notifier.bind = soc_camera_async_bind;
+	sasc->notifier.bound = soc_camera_async_bound;
+	sasc->notifier.unbind = soc_camera_async_unbind;
+	sasc->notifier.complete = soc_camera_async_complete;
+
+	icd->sasc = sasc;
+
+	ret = v4l2_async_notifier_register(&ici->v4l2_dev, &sasc->notifier);
+	if (ret < 0) {
+		video_device_release(icd->vdev);
+		platform_device_unregister(sasc->pdev);
+		dev_err(ici->v4l2_dev.dev, "group probe failed: %d\n", ret);
+	}
+
+	return ret;
+}
+
+static void scan_async_host(struct soc_camera_host *ici)
+{
+	struct v4l2_async_subdev **asd;
+	int j;
+
+	for (j = 0, asd = ici->asd; ici->asd_sizes[j]; j++) {
+		scan_async_group(ici, asd, ici->asd_sizes[j]);
+		asd += ici->asd_sizes[j];
+	}
+}
 #else
-#define soc_camera_init_i2c(icd, sdesc)	(-ENODEV)
-#define soc_camera_free_i2c(icd)	do {} while (0)
+#define soc_camera_i2c_init(icd, sdesc)	(-ENODEV)
+#define soc_camera_i2c_free(icd)	do {} while (0)
 #endif
 
-static int soc_camera_video_start(struct soc_camera_device *icd);
-static int video_dev_create(struct soc_camera_device *icd);
 /* Called during host-driver probe */
-static int soc_camera_probe(struct soc_camera_device *icd)
+static int soc_camera_probe(struct soc_camera_host *ici,
+			    struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct soc_camera_desc *sdesc = to_soc_camera_desc(icd);
 	struct soc_camera_host_desc *shd = &sdesc->host_desc;
 	struct soc_camera_subdev_desc *ssdd = &sdesc->subdev_desc;
 	struct device *control = NULL;
-	struct v4l2_subdev *sd;
-	struct v4l2_mbus_framefmt mf;
 	int ret;
 
 	dev_info(icd->pdev, "Probing %s\n", dev_name(icd->pdev));
@@ -1238,10 +1566,6 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	if (ret < 0)
 		return ret;
 
-	/* The camera could have been already on, try to reset */
-	if (ssdd->reset)
-		ssdd->reset(icd->pdev);
-
 	/* Must have icd->vdev before registering the device */
 	ret = video_dev_create(icd);
 	if (ret < 0)
@@ -1252,18 +1576,19 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	 * itself is protected against concurrent open() calls, but we also have
 	 * to protect our data also during client probing.
 	 */
-	mutex_lock(&ici->host_lock);
 
 	/* Non-i2c cameras, e.g., soc_camera_platform, have no board_info */
 	if (shd->board_info) {
-		ret = soc_camera_init_i2c(icd, sdesc);
-		if (ret < 0)
+		ret = soc_camera_i2c_init(icd, sdesc);
+		if (ret < 0 && ret != -EPROBE_DEFER)
 			goto eadd;
 	} else if (!ssdd->add_device || !ssdd->del_device) {
 		ret = -EINVAL;
 		goto eadd;
 	} else {
+		mutex_lock(&ici->clk_lock);
 		ret = ici->ops->add(icd);
+		mutex_unlock(&ici->clk_lock);
 		if (ret < 0)
 			goto eadd;
 
@@ -1287,89 +1612,76 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 		}
 	}
 
-	sd = soc_camera_to_subdev(icd);
-	sd->grp_id = soc_camera_grp_id(icd);
-	v4l2_set_subdev_hostdata(sd, icd);
-
-	ret = v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler, NULL);
-	if (ret < 0)
-		goto ectrl;
-
-	/* At this point client .probe() should have run already */
-	ret = soc_camera_init_user_formats(icd);
-	if (ret < 0)
-		goto eiufmt;
-
-	icd->field = V4L2_FIELD_ANY;
-
-	ret = soc_camera_video_start(icd);
-	if (ret < 0)
-		goto evidstart;
-
-	/* Try to improve our guess of a reasonable window format */
-	if (!v4l2_subdev_call(sd, video, g_mbus_fmt, &mf)) {
-		icd->user_width		= mf.width;
-		icd->user_height	= mf.height;
-		icd->colorspace		= mf.colorspace;
-		icd->field		= mf.field;
-	}
-
-	if (!shd->board_info)
-		ici->ops->remove(icd);
-
+	mutex_lock(&ici->host_lock);
+	ret = soc_camera_probe_finish(icd);
 	mutex_unlock(&ici->host_lock);
+	if (ret < 0)
+		goto efinish;
 
 	return 0;
 
-evidstart:
-	soc_camera_free_user_formats(icd);
-eiufmt:
-ectrl:
+efinish:
 	if (shd->board_info) {
-		soc_camera_free_i2c(icd);
+		soc_camera_i2c_free(icd);
 	} else {
 		ssdd->del_device(icd);
 		module_put(control->driver->owner);
 enodrv:
 eadddev:
+		mutex_lock(&ici->clk_lock);
 		ici->ops->remove(icd);
+		mutex_unlock(&ici->clk_lock);
 	}
 eadd:
-	video_device_release(icd->vdev);
-	icd->vdev = NULL;
-	mutex_unlock(&ici->host_lock);
+	if (icd->vdev) {
+		video_device_release(icd->vdev);
+		icd->vdev = NULL;
+	}
 evdc:
 	v4l2_ctrl_handler_free(&icd->ctrl_handler);
+
 	return ret;
 }
 
 /*
  * This is called on device_unregister, which only means we have to disconnect
- * from the host, but not remove ourselves from the device list
+ * from the host, but not remove ourselves from the device list. With
+ * asynchronous client probing this can also be called without
+ * soc_camera_probe_finish() having run. Careful with clean up.
  */
 static int soc_camera_remove(struct soc_camera_device *icd)
 {
 	struct soc_camera_desc *sdesc = to_soc_camera_desc(icd);
 	struct video_device *vdev = icd->vdev;
 
-	BUG_ON(!icd->parent);
-
 	v4l2_ctrl_handler_free(&icd->ctrl_handler);
 	if (vdev) {
 		video_unregister_device(vdev);
 		icd->vdev = NULL;
 	}
 
+	if (icd->sasc)
+		v4l2_async_notifier_unregister(&icd->sasc->notifier);
+
 	if (sdesc->host_desc.board_info) {
-		soc_camera_free_i2c(icd);
+		soc_camera_i2c_free(icd);
 	} else {
-		struct device_driver *drv = to_soc_camera_control(icd)->driver;
+		struct device *dev = to_soc_camera_control(icd);
+		struct device_driver *drv = dev ? dev->driver : NULL;
 		if (drv) {
 			sdesc->subdev_desc.del_device(icd);
 			module_put(drv->owner);
 		}
 	}
-	soc_camera_free_user_formats(icd);
+	if (icd->num_user_formats)
+		soc_camera_free_user_formats(icd);
+	if (icd->clk) {
+		v4l2_clk_unregister(icd->clk);
+		icd->clk = NULL;
+	}
+
+	if (icd->sasc)
+		platform_device_unregister(icd->sasc->pdev);
 
 	return 0;
 }
@@ -1480,7 +1792,18 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	mutex_unlock(&list_lock);
 
 	mutex_init(&ici->host_lock);
-	scan_add_host(ici);
+	mutex_init(&ici->clk_lock);
+
+	if (ici->asd_sizes)
+		/*
+		 * No OF, host with a list of subdevices. Don't try to mix
+		 * modes by initialising some groups statically and some
+		 * dynamically!
+		 */
+		scan_async_host(ici);
+	else
+		/* Legacy: static platform devices from board data */
+		scan_add_host(ici);
 
 	return 0;
 
@@ -1493,13 +1816,13 @@ EXPORT_SYMBOL(soc_camera_host_register);
 /* Unregister all clients! */
 void soc_camera_host_unregister(struct soc_camera_host *ici)
 {
-	struct soc_camera_device *icd;
+	struct soc_camera_device *icd, *tmp;
 
 	mutex_lock(&list_lock);
 
 	list_del(&ici->list);
-	list_for_each_entry(icd, &devices, list)
-		if (icd->iface == ici->nr && to_soc_camera_control(icd))
+	list_for_each_entry_safe(icd, tmp, &devices, list)
+		if (icd->iface == ici->nr)
 			soc_camera_remove(icd);
 
 	mutex_unlock(&list_lock);
@@ -1514,6 +1837,7 @@ static int soc_camera_device_register(struct soc_camera_device *icd)
 	struct soc_camera_device *ix;
 	int num = -1, i;
 
+	mutex_lock(&list_lock);
 	for (i = 0; i < 256 && num < 0; i++) {
 		num = i;
 		/* Check if this index is available on this interface */
@@ -1525,18 +1849,34 @@ static int soc_camera_device_register(struct soc_camera_device *icd)
 		}
 	}
 
-	if (num < 0)
+	if (num < 0) {
 		/*
 		 * ok, we have 256 cameras on this host...
 		 * man, stay reasonable...
 		 */
+		mutex_unlock(&list_lock);
 		return -ENOMEM;
+	}
 
 	icd->devnum		= num;
 	icd->use_count		= 0;
 	icd->host_priv		= NULL;
 
+	/*
+	 * Dynamically allocated devices set the bit earlier, but it doesn't hurt setting
+	 * it again
+	 */
+	i = to_platform_device(icd->pdev)->id;
+	if (i < 0)
+		/* One static (legacy) soc-camera platform device */
+		i = 0;
+	if (i >= MAP_MAX_NUM) {
+		mutex_unlock(&list_lock);
+		return -EBUSY;
+	}
+	set_bit(i, device_map);
 	list_add_tail(&icd->list, &devices);
+	mutex_unlock(&list_lock);
 
 	return 0;
 }
@@ -1636,6 +1976,12 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 	if (!icd)
 		return -ENOMEM;
 
+	/*
+	 * In the asynchronous case ssdd->num_regulators == 0 yet, so, the below
+	 * regulator allocation is a dummy. They will be really requested later
+	 * in soc_camera_async_bind(). Also note, that in that case regulators
+	 * are attached to the I2C device and not to the camera platform device.
+	 */
 	ret = devm_regulator_bulk_get(&pdev->dev, ssdd->num_regulators,
 				      ssdd->regulators);
 	if (ret < 0)
@@ -1660,11 +2006,25 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
 {
 	struct soc_camera_device *icd = platform_get_drvdata(pdev);
+	int i;
 
 	if (!icd)
 		return -EINVAL;
 
-	list_del(&icd->list);
+	i = pdev->id;
+	if (i < 0)
+		i = 0;
+
+	/*
+	 * In synchronous mode with static platform devices this is called in a
+	 * loop from drivers/base/dd.c::driver_detach(), no parallel execution,
+	 * no need to lock. In asynchronous case the caller -
+	 * soc_camera_host_unregister() - already holds the lock
+	 */
+	if (test_bit(i, device_map)) {
+		clear_bit(i, device_map);
+		list_del(&icd->list);
+	}
 
 	return 0;
 }
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index a9888e9..23f588a 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -19,11 +19,13 @@
 #include <linux/videodev2.h>
 #include <media/videobuf-core.h>
 #include <media/videobuf2-core.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 
 struct file;
 struct soc_camera_desc;
+struct soc_camera_async_client;
 
 struct soc_camera_device {
 	struct list_head list;		/* list of all registered devices */
@@ -50,6 +52,9 @@ struct soc_camera_device {
 	int use_count;
 	struct file *streamer;		/* stream owner */
 	struct v4l2_clk *clk;
+	/* Asynchronous subdevice management */
+	struct soc_camera_async_client *sasc;
+	/* video buffer queue */
 	union {
 		struct videobuf_queue vb_vidq;
 		struct vb2_queue vb2_vidq;
@@ -59,15 +64,29 @@ struct soc_camera_device {
 /* Host supports programmable stride */
 #define SOCAM_HOST_CAP_STRIDE		(1 << 0)
 
+enum soc_camera_subdev_role {
+	SOCAM_SUBDEV_DATA_SOURCE = 1,
+	SOCAM_SUBDEV_DATA_SINK,
+	SOCAM_SUBDEV_DATA_PROCESSOR,
+};
+
+struct soc_camera_async_subdev {
+	struct v4l2_async_subdev asd;
+	enum soc_camera_subdev_role role;
+};
+
 struct soc_camera_host {
 	struct v4l2_device v4l2_dev;
 	struct list_head list;
-	struct mutex host_lock;		/* Protect pipeline modifications */
+	struct mutex host_lock;		/* Main synchronisation lock */
+	struct mutex clk_lock;		/* Protect pipeline modifications */
 	unsigned char nr;		/* Host number */
 	u32 capabilities;
 	void *priv;
 	const char *drv_name;
 	struct soc_camera_host_ops *ops;
+	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
+	int *asd_sizes;			/* 0-terminated array of asd group sizes */
 };
 
 struct soc_camera_host_ops {
@@ -158,6 +177,7 @@ struct soc_camera_host_desc {
 };
 
 /*
+ * Platform data for "soc-camera-pdrv"
  * This MUST be kept binary-identical to struct soc_camera_link below, until
  * it is completely replaced by this one, after which we can split it into its
  * two components.
-- 
1.7.2.5

