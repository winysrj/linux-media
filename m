Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34980 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753134AbZCRNXJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 09:23:09 -0400
Date: Wed, 18 Mar 2009 14:23:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC] soc-camera -> v4l2-device partial patch for review only
In-Reply-To: <37365.62.70.2.252.1237368437.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.0903181414320.4262@axis700.grange>
References: <37365.62.70.2.252.1237368437.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Below is the first draft version of the first part of the soc-camera -> 
v4l2-device for one configuration (platform, host, and device drivers). It 
converts soc-camera to a platform driver and moves i2c device registration 
from platform into soc_camera.c. Please have a look if I'm doing anything 
obviously wrong. Also notice, that this patch is based on an older 
vkernel, because that's all I have for this platform ATM. Next I'm going 
to convert other platforms / drivers currently in the mainline, and that 
will complete the first step of the conversion. So, soc_camera.[hc] hunks 
should not change any more. I'm keeping the two soc_camera_video_start() 
and soc_camera_video_stop() hooks from device drivers into soc-camera for 
this first step. When converting to v4l2-device automatic module loading 
will make them redundant too.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

diff --git a/arch/arm/mach-mx3/pcm037.c b/arch/arm/mach-mx3/pcm037.c
index 1ff3f29..b2914a6 100644
--- a/arch/arm/mach-mx3/pcm037.c
+++ b/arch/arm/mach-mx3/pcm037.c
@@ -122,15 +122,24 @@ static struct imxi2c_board_data pcm037_i2c_adap[] = {
 };
 
 /* Board I2C devices. */
-static struct soc_camera_link iclink[] = {
+static struct i2c_board_info __initdata pcm037_i2c_devices[] = {
 	{
-		.bus_id	= 0, /* Must match with the camera ID */
+		I2C_BOARD_INFO("mt9t031", 0x5d),
 	},
 };
 
-static struct i2c_board_info __initdata pcm037_i2c_devices[] = {
+static struct soc_camera_link iclink[] = {
 	{
-		I2C_BOARD_INFO("mt9t031", 0x5d),
+		.bus_id		= 0, /* Must match with the camera ID */
+		.board_info	= &pcm037_i2c_devices[0],
+		.i2c_adapter_id	= 2,
+	},
+};
+
+static struct platform_device pcm037_camera = {
+	.name	= "soc-camera-pdrv",
+	.id	= -1,
+	.dev	= {
 		.platform_data = &iclink[0],
 	},
 };
@@ -270,6 +279,7 @@ static struct platform_device *devices[] __initdata = {
 	&pcm037_flash,
 	&pcm037_eth,
 	&otg_udc_device,
+	&pcm037_camera,
 };
 
 static const struct fb_videomode fb_modedb[] = {
@@ -342,10 +352,6 @@ static void __init mxc_board_init(void)
 	/* I2C */
 	mxc_i2c_register_adapters(pcm037_i2c_adap, ARRAY_SIZE(pcm037_i2c_adap));
 
-	/* Cameras and accompanying chips on I2C #2 */
-	i2c_register_board_info(2, pcm037_i2c_devices,
-				ARRAY_SIZE(pcm037_i2c_devices));
-
 	/* Display Interface #3 */
 	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD0, IOMUX_CONFIG_FUNC));
 	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD1, IOMUX_CONFIG_FUNC));
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 54e7cb3..5dce118 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -69,7 +69,7 @@ static const struct soc_camera_data_format mt9t031_colour_formats[] = {
 
 struct mt9t031 {
 	struct i2c_client *client;
-	struct soc_camera_device icd;
+	struct soc_camera_device *icd;
 	int model;	/* V4L2_IDENT_MT9T031* codes from v4l2-chip-ident.h */
 	unsigned char autoexposure;
 	u16 xskip;
@@ -78,8 +78,7 @@ struct mt9t031 {
 
 static int reg_read(struct soc_camera_device *icd, const u8 reg)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
-	struct i2c_client *client = mt9t031->client;
+	struct i2c_client *client = to_i2c_client(icd->control);
 	s32 data = i2c_smbus_read_word_data(client, reg);
 	return data < 0 ? data : swab16(data);
 }
@@ -87,8 +86,8 @@ static int reg_read(struct soc_camera_device *icd, const u8 reg)
 static int reg_write(struct soc_camera_device *icd, const u8 reg,
 		     const u16 data)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
-	return i2c_smbus_write_word_data(mt9t031->client, reg, swab16(data));
+	struct i2c_client *client = to_i2c_client(icd->control);
+	return i2c_smbus_write_word_data(client, reg, swab16(data));
 }
 
 static int reg_set(struct soc_camera_device *icd, const u8 reg,
@@ -193,8 +192,8 @@ static int mt9t031_set_bus_param(struct soc_camera_device *icd,
 
 static unsigned long mt9t031_query_bus_param(struct soc_camera_device *icd)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
-	struct soc_camera_link *icl = mt9t031->client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(icd->control);
+	struct soc_camera_link *icl = dev_get_drvdata(&icd->dev);
 
 	return soc_camera_apply_sensor_flags(icl, MT9T031_BUS_PARAM);
 }
@@ -214,7 +213,8 @@ static void recalculate_limits(struct soc_camera_device *icd,
 static int mt9t031_set_fmt(struct soc_camera_device *icd,
 			   __u32 pixfmt, struct v4l2_rect *rect)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
+	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
 	int ret;
 	const u16 hblank = MT9T031_HORIZONTAL_BLANK,
 		vblank = MT9T031_VERTICAL_BLANK;
@@ -357,12 +357,13 @@ static int mt9t031_try_fmt(struct soc_camera_device *icd,
 static int mt9t031_get_chip_id(struct soc_camera_device *icd,
 			       struct v4l2_chip_ident *id)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
+	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
 
 	if (id->match_type != V4L2_CHIP_MATCH_I2C_ADDR)
 		return -EINVAL;
 
-	if (id->match_chip != mt9t031->client->addr)
+	if (id->match_chip != client->addr)
 		return -ENODEV;
 
 	id->ident	= mt9t031->model;
@@ -375,12 +376,12 @@ static int mt9t031_get_chip_id(struct soc_camera_device *icd,
 static int mt9t031_get_register(struct soc_camera_device *icd,
 				struct v4l2_register *reg)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
 
 	if (reg->match_type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match_chip != mt9t031->client->addr)
+	if (reg->match_chip != client->addr)
 		return -ENODEV;
 
 	reg->val = reg_read(icd, reg->reg);
@@ -394,12 +395,12 @@ static int mt9t031_get_register(struct soc_camera_device *icd,
 static int mt9t031_set_register(struct soc_camera_device *icd,
 				struct v4l2_register *reg)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
 
 	if (reg->match_type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match_chip != mt9t031->client->addr)
+	if (reg->match_chip != client->addr)
 		return -ENODEV;
 
 	if (reg_write(icd, reg->reg, reg->val) < 0)
@@ -485,7 +486,8 @@ static struct soc_camera_ops mt9t031_ops = {
 
 static int mt9t031_get_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
+	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
 	int data;
 
 	switch (ctrl->id) {
@@ -510,7 +512,8 @@ static int mt9t031_get_control(struct soc_camera_device *icd, struct v4l2_contro
 
 static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
+	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
 	const struct v4l2_queryctrl *qctrl;
 	int data;
 
@@ -618,7 +621,8 @@ static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_contro
  * this wasn't our capture interface, so, we wait for the right one */
 static int mt9t031_video_probe(struct soc_camera_device *icd)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
+	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
 	s32 data;
 	int ret;
 
@@ -628,6 +632,11 @@ static int mt9t031_video_probe(struct soc_camera_device *icd)
 	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
 		return -ENODEV;
 
+	/* Switch master clock on */
+	ret = soc_camera_video_start(icd);
+	if (ret)
+		goto evstart;
+
 	/* Enable the chip */
 	data = reg_write(icd, MT9T031_CHIP_ENABLE, 1);
 	dev_dbg(&icd->dev, "write: %d\n", data);
@@ -635,6 +644,8 @@ static int mt9t031_video_probe(struct soc_camera_device *icd)
 	/* Read out the chip version register */
 	data = reg_read(icd, MT9T031_CHIP_VERSION);
 
+	soc_camera_video_stop(icd);
+
 	switch (data) {
 	case 0x1621:
 		mt9t031->model = V4L2_IDENT_MT9T031;
@@ -650,11 +661,6 @@ static int mt9t031_video_probe(struct soc_camera_device *icd)
 
 	dev_info(&icd->dev, "Detected a MT9T031 chip ID %x\n", data);
 
-	/* Now that we know the model, we can start video */
-	ret = soc_camera_video_start(icd);
-	if (ret)
-		goto evstart;
-
 	return 0;
 
 evstart:
@@ -664,22 +670,28 @@ ei2c:
 
 static void mt9t031_video_remove(struct soc_camera_device *icd)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
 
-	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", mt9t031->client->addr,
+	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", client->addr,
 		icd->dev.parent, icd->vdev);
-	soc_camera_video_stop(icd);
+	icd->ops = NULL;
 }
 
 static int mt9t031_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct mt9t031 *mt9t031;
-	struct soc_camera_device *icd;
+	struct soc_camera_device *icd = client->dev.platform_data;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct soc_camera_link *icl;
 	int ret;
 
+	if (!icd) {
+		dev_err(&client->dev, "MT9T031: missing soc-camera data!\n");
+		return -EINVAL;
+	}
+
+	icl = dev_get_drvdata(&icd->dev);
 	if (!icl) {
 		dev_err(&client->dev, "MT9T031 driver needs platform data\n");
 		return -EINVAL;
@@ -695,13 +707,12 @@ static int mt9t031_probe(struct i2c_client *client,
 	if (!mt9t031)
 		return -ENOMEM;
 
-	mt9t031->client = client;
+	mt9t031->client	= client;
+	mt9t031->icd	= icd;
 	i2c_set_clientdata(client, mt9t031);
 
 	/* Second stage probe - when a capture adapter is there */
-	icd = &mt9t031->icd;
 	icd->ops	= &mt9t031_ops;
-	icd->control	= &client->dev;
 	icd->x_min	= MT9T031_COLUMN_SKIP;
 	icd->y_min	= MT9T031_ROW_SKIP;
 	icd->x_current	= icd->x_min;
@@ -711,7 +722,6 @@ static int mt9t031_probe(struct i2c_client *client,
 	icd->height_min	= MT9T031_MIN_HEIGHT;
 	icd->height_max	= MT9T031_MAX_HEIGHT;
 	icd->y_skip_top	= 0;
-	icd->iface	= icl->bus_id;
 	/* Simulated autoexposure. If enabled, we calculate shutter width
 	 * ourselves in the driver based on vertical blanking and frame width */
 	mt9t031->autoexposure = 1;
@@ -719,7 +729,7 @@ static int mt9t031_probe(struct i2c_client *client,
 	mt9t031->xskip = 1;
 	mt9t031->yskip = 1;
 
-	ret = soc_camera_device_register(icd);
+	ret = mt9t031_video_probe(icd);
 	if (ret)
 		goto eisdr;
 
@@ -735,8 +745,9 @@ static int mt9t031_remove(struct i2c_client *client)
 {
 	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
 
-	soc_camera_device_unregister(&mt9t031->icd);
+	mt9t031_video_remove(mt9t031->icd);
 	i2c_set_clientdata(client, NULL);
+	client->driver = NULL;
 	kfree(mt9t031);
 
 	return 0;
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index a925d09..f44e34a 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -502,11 +502,14 @@ static int mx3_camera_add_device(struct soc_camera_device *icd)
 	}
 
 	mx3_camera_activate(mx3_cam, icd);
-	ret = icd->ops->init(icd);
-	if (ret < 0) {
-		clk_disable(mx3_cam->clk);
-		goto einit;
-	}
+	if (icd->ops) {
+		ret = icd->ops->init(icd);
+		if (ret < 0) {
+			clk_disable(mx3_cam->clk);
+			goto einit;
+		}
+	} else
+		ret = 0;
 
 	mx3_cam->icd = icd;
 
@@ -910,9 +913,10 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	camera_flags = icd->ops->query_bus_param(icd);
 
 	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
+	dev_dbg(&ici->dev, "Flags cam: 0x%lx host: 0x%lx common: 0x%lx\n",
+		camera_flags, bus_flags, common_flags);
 	if (!common_flags) {
-		dev_dbg(&ici->dev, "no common flags: camera %lx, host %lx\n",
-			camera_flags, bus_flags);
+		dev_dbg(&ici->dev, "no common flags");
 		return -EINVAL;
 	}
 
@@ -965,8 +969,11 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 			SOCAM_DATAWIDTH_4;
 
 	ret = icd->ops->set_bus_param(icd, common_flags);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_dbg(&ici->dev, "camera set_bus_param(%x) returned %d\n",
+			common_flags, ret);
 		return ret;
+	}
 
 	/*
 	 * So far only gated clock mode is supported. Add a line
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 0ab160b..dad5564 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -16,19 +16,21 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
-#include <linux/list.h>
 #include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/vmalloc.h>
 
+#include <media/soc_camera.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf-core.h>
-#include <media/soc_camera.h>
 
 static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
@@ -230,10 +232,6 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 	struct soc_camera_file *icf;
 	int ret;
 
-	icf = vmalloc(sizeof(*icf));
-	if (!icf)
-		return -ENOMEM;
-
 	/*
 	 * It is safe to dereference these pointers now as long as a user has
 	 * the video device open - we are protected by the held cdev reference.
@@ -241,8 +239,17 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 
 	vdev = video_devdata(file);
 	icd = container_of(vdev->parent, struct soc_camera_device, dev);
+
+	if (!icd->ops)
+		/* No device driver attached */
+		return -ENODEV;
+
 	ici = to_soc_camera_host(icd->dev.parent);
 
+	icf = vmalloc(sizeof(*icf));
+	if (!icf)
+		return -ENOMEM;
+
 	if (!try_module_get(icd->ops->owner)) {
 		dev_err(&icd->dev, "Couldn't lock sensor driver.\n");
 		ret = -EINVAL;
@@ -255,7 +262,7 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 		goto emgi;
 	}
 
-	/* Protect against icd->remove() until we module_get() both drivers. */
+	/* Protect against icd->ops->remove() until we module_get() both drivers. */
 	mutex_lock(&icd->video_lock);
 
 	icf->icd = icd;
@@ -703,26 +710,6 @@ static int soc_camera_s_register(struct file *file, void *fh,
 }
 #endif
 
-static int device_register_link(struct soc_camera_device *icd)
-{
-	int ret = device_register(&icd->dev);
-
-	if (ret < 0) {
-		/* Prevent calling device_unregister() */
-		icd->dev.parent = NULL;
-		dev_err(&icd->dev, "Cannot register device: %d\n", ret);
-	/* Even if probe() was unsuccessful for all registered drivers,
-	 * device_register() returns 0, and we add the link, just to
-	 * document this camera's control device */
-	} else if (icd->control)
-		/* Have to sysfs_remove_link() before device_unregister()? */
-		if (sysfs_create_link(&icd->dev.kobj, &icd->control->kobj,
-				      "control"))
-			dev_warn(&icd->dev,
-				 "Failed creating the control symlink\n");
-	return ret;
-}
-
 /* So far this function cannot fail */
 static void scan_add_host(struct soc_camera_host *ici)
 {
@@ -732,94 +719,60 @@ static void scan_add_host(struct soc_camera_host *ici)
 
 	list_for_each_entry(icd, &devices, list) {
 		if (icd->iface == ici->nr) {
+			int ret;
 			icd->dev.parent = &ici->dev;
-			device_register_link(icd);
-		}
-	}
-
-	mutex_unlock(&list_lock);
-}
-
-/* return: 0 if no match found or a match found and
- * device_register() successful, error code otherwise */
-static int scan_add_device(struct soc_camera_device *icd)
-{
-	struct soc_camera_host *ici;
-	int ret = 0;
-
-	mutex_lock(&list_lock);
-
-	list_add_tail(&icd->list, &devices);
-
-	/* Watch out for class_for_each_device / class_find_device API by
-	 * Dave Young <hidave.darkstar@gmail.com> */
-	list_for_each_entry(ici, &hosts, list) {
-		if (icd->iface == ici->nr) {
-			ret = 1;
-			icd->dev.parent = &ici->dev;
-			break;
+			ret = device_register(&icd->dev);
+			if (ret < 0) {
+				icd->dev.parent = NULL;
+				dev_err(&icd->dev,
+					"Cannot register device: %d\n", ret);
+			}
 		}
 	}
 
 	mutex_unlock(&list_lock);
-
-	if (ret)
-		ret = device_register_link(icd);
-
-	return ret;
 }
 
+static int video_dev_create(struct soc_camera_device *icd);
+/* Called during host-driver probe */
 static int soc_camera_probe(struct device *dev)
 {
 	struct soc_camera_device *icd = to_soc_camera_dev(dev);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_link *icl = dev_get_drvdata(&icd->dev);
 	int ret;
-
-	/*
-	 * Possible race scenario:
-	 * modprobe <camera-host-driver> triggers __func__
-	 * at this moment respective <camera-sensor-driver> gets rmmod'ed
-	 * to protect take module references.
-	 */
-
-	if (!try_module_get(icd->ops->owner)) {
-		dev_err(&icd->dev, "Couldn't lock sensor driver.\n");
-		ret = -EINVAL;
-		goto emgd;
+	struct i2c_client *client;
+	struct i2c_adapter *adap = i2c_get_adapter(icl->i2c_adapter_id);
+	
+	if (!adap) {
+		ret = -ENODEV;
+		goto ei2cga;
 	}
 
-	if (!try_module_get(ici->ops->owner)) {
-		dev_err(&icd->dev, "Couldn't lock capture bus driver.\n");
-		ret = -EINVAL;
-		goto emgi;
+	client = i2c_new_device(adap, icl->board_info);
+	if (!client) {
+		ret = -ENOMEM;
+		goto ei2cnd;
 	}
 
-	mutex_lock(&icd->video_lock);
+	/* Use to_i2c_client(dev) to recover the i2c client */
+	icd->control = &client->dev;
 
-	/* We only call ->add() here to activate and probe the camera.
-	 * We shall ->remove() and deactivate it immediately afterwards. */
-	ret = ici->ops->add(icd);
-	if (ret < 0)
-		goto eiadd;
+	/* Do we have to sysfs_remove_link() before device_unregister()? */
+	if (sysfs_create_link(&dev->kobj, &icd->control->kobj, "control"))
+		dev_warn(dev, "Failed creating the control symlink\n");
 
-	ret = icd->ops->probe(icd);
-	if (ret >= 0) {
-		const struct v4l2_queryctrl *qctrl;
+	ret = video_dev_create(icd);
+	if (ret < 0)
+		goto evdc;
 
-		qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_GAIN);
-		icd->gain = qctrl ? qctrl->default_value : (unsigned short)~0;
-		qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
-		icd->exposure = qctrl ? qctrl->default_value :
-			(unsigned short)~0;
-	}
-	ici->ops->remove(icd);
+	return 0;
 
-eiadd:
-	mutex_unlock(&icd->video_lock);
-	module_put(ici->ops->owner);
-emgi:
-	module_put(icd->ops->owner);
-emgd:
+evdc:
+	i2c_unregister_device(client);
+ei2cnd:
+	i2c_put_adapter(adap);
+ei2cga:
 	return ret;
 }
 
@@ -828,9 +781,22 @@ emgd:
 static int soc_camera_remove(struct device *dev)
 {
 	struct soc_camera_device *icd = to_soc_camera_dev(dev);
+	struct video_device *vdev = icd->vdev;
+
+	BUG_ON(!dev->parent);
 
-	if (icd->ops->remove)
-		icd->ops->remove(icd);
+	if (vdev) {
+		mutex_lock(&icd->video_lock);
+		video_unregister_device(vdev);
+		icd->vdev = NULL;
+		mutex_unlock(&icd->video_lock);
+	}
+
+	if (icd->control) {
+		struct i2c_client *client = to_i2c_client(icd->control);
+		i2c_unregister_device(client);
+		i2c_put_adapter(client->adapter);
+	}
 
 	return 0;
 }
@@ -911,7 +877,6 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	ici->dev.release = dummy_release;
 
 	ret = device_register(&ici->dev);
-
 	if (ret)
 		goto edevr;
 
@@ -939,10 +904,14 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 
 	list_for_each_entry(icd, &devices, list) {
 		if (icd->dev.parent == &ici->dev) {
+			/* The bus->remove will be called */
 			device_unregister(&icd->dev);
 			/* Not before device_unregister(), .remove
 			 * needs parent to call ici->ops->remove() */
 			icd->dev.parent = NULL;
+
+			/* If the host module is loaded again, device_register()
+			 * would complain "already initialised" */
 			memset(&icd->dev.kobj, 0, sizeof(icd->dev.kobj));
 		}
 	}
@@ -954,25 +923,14 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 EXPORT_SYMBOL(soc_camera_host_unregister);
 
 /* Image capture device */
-int soc_camera_device_register(struct soc_camera_device *icd)
+static int soc_camera_device_register(struct soc_camera_device *icd)
 {
 	struct soc_camera_device *ix;
 	int num = -1, i;
 
-	if (!icd || !icd->ops ||
-	    !icd->ops->probe ||
-	    !icd->ops->init ||
-	    !icd->ops->release ||
-	    !icd->ops->start_capture ||
-	    !icd->ops->stop_capture ||
-	    !icd->ops->set_fmt ||
-	    !icd->ops->try_fmt ||
-	    !icd->ops->query_bus_param ||
-	    !icd->ops->set_bus_param)
-		return -EINVAL;
-
 	for (i = 0; i < 256 && num < 0; i++) {
 		num = i;
+		/* Check if this index is available on this interface */
 		list_for_each_entry(ix, &devices, list) {
 			if (ix->iface == icd->iface && ix->devnum == i) {
 				num = -1;
@@ -996,21 +954,17 @@ int soc_camera_device_register(struct soc_camera_device *icd)
 	icd->host_priv		= NULL;
 	mutex_init(&icd->video_lock);
 
-	return scan_add_device(icd);
+	mutex_lock(&list_lock);
+	list_add_tail(&icd->list, &devices);
+	mutex_unlock(&list_lock);
+
+	return 0;
 }
-EXPORT_SYMBOL(soc_camera_device_register);
 
-void soc_camera_device_unregister(struct soc_camera_device *icd)
+static void soc_camera_device_unregister(struct soc_camera_device *icd)
 {
-	mutex_lock(&list_lock);
 	list_del(&icd->list);
-
-	/* The bus->remove will be eventually called */
-	if (icd->dev.parent)
-		device_unregister(&icd->dev);
-	mutex_unlock(&list_lock);
 }
-EXPORT_SYMBOL(soc_camera_device_unregister);
 
 static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 	.vidioc_querycap	 = soc_camera_querycap,
@@ -1041,22 +995,14 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 #endif
 };
 
-/*
- * Usually called from the struct soc_camera_ops .probe() method, i.e., from
- * soc_camera_probe() above with .video_lock held
- */
-int soc_camera_video_start(struct soc_camera_device *icd)
+static int video_dev_create(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	int err = -ENOMEM;
-	struct video_device *vdev;
-
-	if (!icd->dev.parent)
-		return -ENODEV;
+	int ret;
+	struct video_device *vdev = video_device_alloc();
 
-	vdev = video_device_alloc();
 	if (!vdev)
-		goto evidallocd;
+		return -ENOMEM;
 	dev_dbg(&ici->dev, "Allocated video_device %p\n", vdev);
 
 	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
@@ -1067,10 +1013,10 @@ int soc_camera_video_start(struct soc_camera_device *icd)
 	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
 	vdev->release		= video_device_release;
 	vdev->minor		= -1;
-	vdev->tvnorms		= V4L2_STD_UNKNOWN,
+	vdev->tvnorms		= V4L2_STD_UNKNOWN;
 
-	err = video_register_device(vdev, VFL_TYPE_GRABBER, vdev->minor);
-	if (err < 0) {
+	ret = video_register_device(vdev, VFL_TYPE_GRABBER, vdev->minor);
+	if (ret < 0) {
 		dev_err(vdev->parent, "video_register_device failed\n");
 		goto evidregd;
 	}
@@ -1080,27 +1026,99 @@ int soc_camera_video_start(struct soc_camera_device *icd)
 
 evidregd:
 	video_device_release(vdev);
-evidallocd:
-	return err;
+	return ret;
+}
+
+/*
+ * Usually called from the struct soc_camera_ops .probe() method, i.e., from
+ * soc_camera_probe() above with .video_lock held
+ */
+int soc_camera_video_start(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	const struct v4l2_queryctrl *qctrl;
+
+	if (!icd->dev.parent)
+		return -ENODEV;
+
+	if (!icd->ops ||
+	    !icd->ops->probe ||
+	    !icd->ops->init ||
+	    !icd->ops->release ||
+	    !icd->ops->start_capture ||
+	    !icd->ops->stop_capture ||
+	    !icd->ops->set_fmt ||
+	    !icd->ops->try_fmt ||
+	    !icd->ops->query_bus_param ||
+	    !icd->ops->set_bus_param)
+		return -EINVAL;
+
+
+	qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_GAIN);
+	icd->gain = qctrl ? qctrl->default_value : (unsigned short)~0;
+	qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
+	icd->exposure = qctrl ? qctrl->default_value : (unsigned short)~0;
+
+	ici->ops->add(icd);
+
+	return 0;
 }
 EXPORT_SYMBOL(soc_camera_video_start);
 
 void soc_camera_video_stop(struct soc_camera_device *icd)
 {
-	struct video_device *vdev = icd->vdev;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	dev_dbg(&icd->dev, "%s\n", __func__);
 
-	if (!icd->dev.parent || !vdev)
-		return;
-
-	mutex_lock(&icd->video_lock);
-	video_unregister_device(vdev);
-	icd->vdev = NULL;
-	mutex_unlock(&icd->video_lock);
+	ici->ops->remove(icd);
 }
 EXPORT_SYMBOL(soc_camera_video_stop);
 
+static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
+{
+	struct soc_camera_link *icl = pdev->dev.platform_data;
+	struct soc_camera_device *icd;
+
+	if (!icl)
+		return -EINVAL;
+
+	icd = kzalloc(sizeof(*icd), GFP_KERNEL);
+	if (!icd)
+		return -ENOMEM;
+
+	icd->iface = icl->bus_id;
+	icl->board_info->platform_data = icd;
+	platform_set_drvdata(pdev, icd);
+	dev_set_drvdata(&icd->dev, icl);
+
+	return soc_camera_device_register(icd);
+}
+
+/* Only called on rmmod, so, we know all our users - hosts and devices have
+ * been unloaded already */
+static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
+{
+	struct soc_camera_device *icd = platform_get_drvdata(pdev);
+
+	if (!icd)
+		return -EINVAL;
+
+	soc_camera_device_unregister(icd);
+
+	kfree(icd);
+
+	return 0;
+}
+
+static struct platform_driver soc_camera_pdrv = {
+	.remove  = __exit_p(soc_camera_pdrv_remove),
+	.driver  = {
+		.name = "soc-camera-pdrv",
+		.owner = THIS_MODULE,
+	},
+};
+
 static int __init soc_camera_init(void)
 {
 	int ret = bus_register(&soc_camera_bus_type);
@@ -1110,8 +1128,14 @@ static int __init soc_camera_init(void)
 	if (ret)
 		goto edrvr;
 
+	ret = platform_driver_probe(&soc_camera_pdrv, soc_camera_pdrv_probe);
+	if (ret)
+		goto epdr;
+
 	return 0;
 
+epdr:
+	driver_unregister(&ic_drv);
 edrvr:
 	bus_unregister(&soc_camera_bus_type);
 	return ret;
@@ -1119,6 +1143,7 @@ edrvr:
 
 static void __exit soc_camera_exit(void)
 {
+	platform_driver_unregister(&soc_camera_pdrv);
 	driver_unregister(&ic_drv);
 	bus_unregister(&soc_camera_bus_type);
 }
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 93ae932..d087f29 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -12,6 +12,7 @@
 #ifndef SOC_CAMERA_H
 #define SOC_CAMERA_H
 
+#include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <linux/pm.h>
 #include <linux/videodev2.h>
@@ -97,6 +98,8 @@ struct soc_camera_link {
 	unsigned int gpio;
 	/* Per camera SOCAM_SENSOR_* bus flags */
 	unsigned long flags;
+	int i2c_adapter_id;
+	struct i2c_board_info *board_info;
 	/* Optional callbacks to power on or off and reset the sensor */
 	int (*power)(struct device *, int);
 	int (*reset)(struct device *);
@@ -112,17 +115,15 @@ static inline struct soc_camera_host *to_soc_camera_host(struct device *dev)
 	return container_of(dev, struct soc_camera_host, dev);
 }
 
-extern int soc_camera_host_register(struct soc_camera_host *ici);
-extern void soc_camera_host_unregister(struct soc_camera_host *ici);
-extern int soc_camera_device_register(struct soc_camera_device *icd);
-extern void soc_camera_device_unregister(struct soc_camera_device *icd);
+int soc_camera_host_register(struct soc_camera_host *ici);
+void soc_camera_host_unregister(struct soc_camera_host *ici);
 
-extern int soc_camera_video_start(struct soc_camera_device *icd);
-extern void soc_camera_video_stop(struct soc_camera_device *icd);
+int soc_camera_video_start(struct soc_camera_device *icd);
+void soc_camera_video_stop(struct soc_camera_device *icd);
 
-extern const struct soc_camera_data_format *soc_camera_format_by_fourcc(
+const struct soc_camera_data_format *soc_camera_format_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc);
-extern const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
+const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc);
 
 struct soc_camera_data_format {
