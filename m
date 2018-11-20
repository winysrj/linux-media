Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:50184 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727355AbeKTUcu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 15:32:50 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
Subject: [PATCH v3 13/14] [media] marvell-ccic: use async notifier to get the sensor
Date: Tue, 20 Nov 2018 11:03:18 +0100
Message-Id: <20181120100318.367987-14-lkundrak@v3.sk>
In-Reply-To: <20181120100318.367987-1-lkundrak@v3.sk>
References: <20181120100318.367987-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An instance of a sensor on DT-based MMP2 platform is always going to be
created asynchronously.

Let's move the manual device creation away from the core to the Cafe
driver (used on OLPC XO-1, not present in DT) and set up appropriate
async matches: I2C on Cafe, FWNODE on MMP (OLPC XO-1.75).

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

---
Changes since v2:
- Moved a typo fix hunk that was accidentally in the following patch
  here, to unbreak build.

 .../media/platform/marvell-ccic/cafe-driver.c |  49 ++++--
 .../media/platform/marvell-ccic/mcam-core.c   | 157 ++++++++++++------
 .../media/platform/marvell-ccic/mcam-core.h   |   5 +-
 .../media/platform/marvell-ccic/mmp-driver.c  |  27 +--
 .../linux/platform_data/media/mmp-camera.h    |   1 -
 5 files changed, 162 insertions(+), 77 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/cafe-driver.c b/drivers/=
media/platform/marvell-ccic/cafe-driver.c
index 2986cb4b88d0..658294d319c0 100644
--- a/drivers/media/platform/marvell-ccic/cafe-driver.c
+++ b/drivers/media/platform/marvell-ccic/cafe-driver.c
@@ -8,6 +8,7 @@
  *
  * Copyright 2006-11 One Laptop Per Child Association, Inc.
  * Copyright 2006-11 Jonathan Corbet <corbet@lwn.net>
+ * Copyright 2018 Lubomir Rintel <lkundrak@v3.sk>
  *
  * Written by Jonathan Corbet, corbet@lwn.net.
  *
@@ -27,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
+#include <media/i2c/ov7670.h>
 #include <linux/device.h>
 #include <linux/wait.h>
 #include <linux/delay.h>
@@ -52,6 +54,7 @@ struct cafe_camera {
 	int registered;			/* Fully initialized? */
 	struct mcam_camera mcam;
 	struct pci_dev *pdev;
+	struct i2c_adapter *i2c_adapter;
 	wait_queue_head_t smbus_wait;	/* Waiting on i2c events */
 };
=20
@@ -351,15 +354,15 @@ static int cafe_smbus_setup(struct cafe_camera *cam=
)
 		return ret;
 	}
=20
-	cam->mcam.i2c_adapter =3D adap;
+	cam->i2c_adapter =3D adap;
 	cafe_smbus_enable_irq(cam);
 	return 0;
 }
=20
 static void cafe_smbus_shutdown(struct cafe_camera *cam)
 {
-	i2c_del_adapter(cam->mcam.i2c_adapter);
-	kfree(cam->mcam.i2c_adapter);
+	i2c_del_adapter(cam->i2c_adapter);
+	kfree(cam->i2c_adapter);
 }
=20
=20
@@ -452,6 +455,29 @@ static irqreturn_t cafe_irq(int irq, void *data)
 	return IRQ_RETVAL(handled);
 }
=20
+/* ---------------------------------------------------------------------=
----- */
+
+static struct ov7670_config sensor_cfg =3D {
+	/*
+	 * Exclude QCIF mode, because it only captures a tiny portion
+	 * of the sensor FOV
+	 */
+	.min_width =3D 320,
+	.min_height =3D 240,
+
+	/*
+	 * Set the clock speed for the XO 1; I don't believe this
+	 * driver has ever run anywhere else.
+	 */
+	.clock_speed =3D 45,
+	.use_smbus =3D 1,
+};
+
+struct i2c_board_info ov7670_info =3D {
+	.type =3D "ov7670",
+	.addr =3D 0x42 >> 1,
+	.platform_data =3D &sensor_cfg,
+};
=20
 /* ---------------------------------------------------------------------=
----- */
 /*
@@ -481,12 +507,6 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 	mcam->plat_power_down =3D cafe_ctlr_power_down;
 	mcam->dev =3D &pdev->dev;
 	snprintf(mcam->bus_info, sizeof(mcam->bus_info), "PCI:%s", pci_name(pde=
v));
-	/*
-	 * Set the clock speed for the XO 1; I don't believe this
-	 * driver has ever run anywhere else.
-	 */
-	mcam->clock_speed =3D 45;
-	mcam->use_smbus =3D 1;
 	/*
 	 * Vmalloc mode for buffers is traditional with this driver.
 	 * We *might* be able to run DMA_contig, especially on a system
@@ -527,12 +547,21 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto out_pdown;
=20
+	mcam->asd.match_type =3D V4L2_ASYNC_MATCH_I2C;
+	mcam->asd.match.i2c.adapter_id =3D i2c_adapter_id(cam->i2c_adapter);
+	mcam->asd.match.i2c.address =3D ov7670_info.addr;
+
 	ret =3D mccic_register(mcam);
-	if (ret =3D=3D 0) {
+	if (ret)
+		goto out_smbus_shutdown;
+
+	if (i2c_new_device(cam->i2c_adapter, &ov7670_info)) {
 		cam->registered =3D 1;
 		return 0;
 	}
=20
+	mccic_shutdown(mcam);
+out_smbus_shutdown:
 	cafe_smbus_shutdown(cam);
 out_pdown:
 	cafe_ctlr_power_down(mcam);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/me=
dia/platform/marvell-ccic/mcam-core.c
index 0113b8d37d03..87812b7287f0 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -4,6 +4,7 @@
  * so it needs platform-specific support outside of the core.
  *
  * Copyright 2011 Jonathan Corbet corbet@lwn.net
+ * Copyright 2018 Lubomir Rintel <lkundrak@v3.sk>
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -26,7 +27,6 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
-#include <media/i2c/ov7670.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-dma-sg.h>
@@ -93,6 +93,9 @@ MODULE_PARM_DESC(buffer_mode,
 #define sensor_call(cam, o, f, args...) \
 	v4l2_subdev_call(cam->sensor, o, f, ##args)
=20
+#define notifier_to_mcam(notifier) \
+	container_of(notifier, struct mcam_camera, notifier)
+
 static struct mcam_format_struct {
 	__u8 *desc;
 	__u32 pixelformat;
@@ -1715,23 +1718,94 @@ EXPORT_SYMBOL_GPL(mccic_irq);
 /*
  * Registration and such.
  */
-static struct ov7670_config sensor_cfg =3D {
+
+static int mccic_notify_bound(struct v4l2_async_notifier *notifier,
+	struct v4l2_subdev *subdev, struct v4l2_async_subdev *asd)
+{
+	struct mcam_camera *cam =3D notifier_to_mcam(notifier);
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	if (cam->sensor) {
+		cam_err(cam, "sensor already bound\n");
+		ret =3D -EBUSY;
+		goto out;
+	}
+
+	v4l2_set_subdev_hostdata(subdev, cam);
+	cam->sensor =3D subdev;
+
+	ret =3D mcam_cam_init(cam);
+	if (ret) {
+		cam->sensor =3D NULL;
+		goto out;
+	}
+
+	ret =3D mcam_setup_vb2(cam);
+	if (ret) {
+		cam->sensor =3D NULL;
+		goto out;
+	}
+
+	cam->vdev =3D mcam_v4l_template;
+	cam->vdev.v4l2_dev =3D &cam->v4l2_dev;
+	cam->vdev.lock =3D &cam->s_mutex;
+	cam->vdev.queue =3D &cam->vb_queue;
+	video_set_drvdata(&cam->vdev, cam);
+	ret =3D video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		cam->sensor =3D NULL;
+		goto out;
+	}
+
+	cam_dbg(cam, "sensor %s bound\n", subdev->name);
+out:
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static void mccic_notify_unbind(struct v4l2_async_notifier *notifier,
+	struct v4l2_subdev *subdev, struct v4l2_async_subdev *asd)
+{
+	struct mcam_camera *cam =3D notifier_to_mcam(notifier);
+
+	mutex_lock(&cam->s_mutex);
+	if (cam->sensor !=3D subdev) {
+		cam_err(cam, "sensor %s not bound\n", subdev->name);
+		goto out;
+	}
+
+	video_unregister_device(&cam->vdev);
+	cam->sensor =3D NULL;
+	cam_dbg(cam, "sensor %s unbound\n", subdev->name);
+
+out:
+	mutex_unlock(&cam->s_mutex);
+}
+
+static int mccic_notify_complete(struct v4l2_async_notifier *notifier)
+{
+	struct mcam_camera *cam =3D notifier_to_mcam(notifier);
+	int ret;
+
 	/*
-	 * Exclude QCIF mode, because it only captures a tiny portion
-	 * of the sensor FOV
+	 * Get the v4l2 setup done.
 	 */
-	.min_width =3D 320,
-	.min_height =3D 240,
-};
+	ret =3D v4l2_ctrl_handler_init(&cam->ctrl_handler, 10);
+	if (!ret)
+		cam->v4l2_dev.ctrl_handler =3D &cam->ctrl_handler;
+
+	return ret;
+}
=20
+static const struct v4l2_async_notifier_operations mccic_notify_ops =3D =
{
+	.bound =3D mccic_notify_bound,
+	.unbind =3D mccic_notify_unbind,
+	.complete =3D mccic_notify_complete,
+};
=20
 int mccic_register(struct mcam_camera *cam)
 {
-	struct i2c_board_info ov7670_info =3D {
-		.type =3D "ov7670",
-		.addr =3D 0x42 >> 1,
-		.platform_data =3D &sensor_cfg,
-	};
 	int ret;
=20
 	/*
@@ -1744,17 +1818,20 @@ int mccic_register(struct mcam_camera *cam)
 		printk(KERN_ERR "marvell-cam: Cafe can't do S/G I/O, attempting vmallo=
c mode instead\n");
 		cam->buffer_mode =3D B_vmalloc;
 	}
+
 	if (!mcam_buffer_mode_supported(cam->buffer_mode)) {
 		printk(KERN_ERR "marvell-cam: buffer mode %d unsupported\n",
 				cam->buffer_mode);
-		return -EINVAL;
+		ret =3D -EINVAL;
+		goto out;
 	}
+
 	/*
 	 * Register with V4L
 	 */
 	ret =3D v4l2_device_register(cam->dev, &cam->v4l2_dev);
 	if (ret)
-		return ret;
+		goto out;
=20
 	mutex_init(&cam->s_mutex);
 	cam->state =3D S_NOTREADY;
@@ -1764,43 +1841,20 @@ int mccic_register(struct mcam_camera *cam)
 	mcam_ctlr_init(cam);
=20
 	/*
-	 * Get the v4l2 setup done.
+	 * Register sensor notifier.
 	 */
-	ret =3D v4l2_ctrl_handler_init(&cam->ctrl_handler, 10);
-	if (ret)
-		goto out_unregister;
-	cam->v4l2_dev.ctrl_handler =3D &cam->ctrl_handler;
-
-	/*
-	 * Try to find the sensor.
-	 */
-	sensor_cfg.clock_speed =3D cam->clock_speed;
-	sensor_cfg.use_smbus =3D cam->use_smbus;
-	cam->sensor =3D v4l2_i2c_new_subdev_board(&cam->v4l2_dev,
-			cam->i2c_adapter, &ov7670_info, NULL);
-	if (cam->sensor =3D=3D NULL) {
-		ret =3D -ENODEV;
-		goto out_unregister;
+	v4l2_async_notifier_init(&cam->notifier);
+	ret =3D v4l2_async_notifier_add_subdev(&cam->notifier, &cam->asd);
+	if (ret) {
+		cam_warn(cam, "failed to add subdev to a notifier");
+		goto out;
 	}
=20
-	ret =3D mcam_cam_init(cam);
-	if (ret)
-		goto out_unregister;
-
-	ret =3D mcam_setup_vb2(cam);
-	if (ret)
-		goto out_unregister;
-
-	mutex_lock(&cam->s_mutex);
-	cam->vdev =3D mcam_v4l_template;
-	cam->vdev.v4l2_dev =3D &cam->v4l2_dev;
-	cam->vdev.lock =3D &cam->s_mutex;
-	cam->vdev.queue =3D &cam->vb_queue;
-	video_set_drvdata(&cam->vdev, cam);
-	ret =3D video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
-	if (ret) {
-		mutex_unlock(&cam->s_mutex);
-		goto out_unregister;
+	cam->notifier.ops =3D &mccic_notify_ops;
+	ret =3D v4l2_async_notifier_register(&cam->v4l2_dev, &cam->notifier);
+	if (ret < 0) {
+		cam_warn(cam, "failed to register a sensor notifier");
+		goto out;
 	}
=20
 	/*
@@ -1811,11 +1865,10 @@ int mccic_register(struct mcam_camera *cam)
 			cam_warn(cam, "Unable to alloc DMA buffers at load will try again lat=
er.");
 	}
=20
-	mutex_unlock(&cam->s_mutex);
 	return 0;
=20
-out_unregister:
-	v4l2_ctrl_handler_free(&cam->ctrl_handler);
+out:
+	v4l2_async_notifier_unregister(&cam->notifier);
 	v4l2_device_unregister(&cam->v4l2_dev);
 	return ret;
 }
@@ -1835,8 +1888,8 @@ void mccic_shutdown(struct mcam_camera *cam)
 	}
 	if (cam->buffer_mode =3D=3D B_vmalloc)
 		mcam_free_dma_bufs(cam);
-	video_unregister_device(&cam->vdev);
 	v4l2_ctrl_handler_free(&cam->ctrl_handler);
+	v4l2_async_notifier_unregister(&cam->notifier);
 	v4l2_device_unregister(&cam->v4l2_dev);
 }
 EXPORT_SYMBOL_GPL(mccic_shutdown);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/me=
dia/platform/marvell-ccic/mcam-core.h
index b828b1bb59d3..4a72213aca1a 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -102,14 +102,11 @@ struct mcam_camera {
 	 * These fields should be set by the platform code prior to
 	 * calling mcam_register().
 	 */
-	struct i2c_adapter *i2c_adapter;
 	unsigned char __iomem *regs;
 	unsigned regs_size; /* size in bytes of the register space */
 	spinlock_t dev_lock;
 	struct device *dev; /* For messages, dma alloc */
 	enum mcam_chip_id chip_id;
-	short int clock_speed;	/* Sensor clock speed, default 30 */
-	short int use_smbus;	/* SMBUS or straight I2c? */
 	enum mcam_buffer_mode buffer_mode;
=20
 	int mclk_src;	/* which clock source the mclk derives from */
@@ -150,6 +147,8 @@ struct mcam_camera {
 	 * Subsystem structures.
 	 */
 	struct video_device vdev;
+	struct v4l2_async_notifier notifier;
+	struct v4l2_async_subdev asd;
 	struct v4l2_subdev *sensor;
=20
 	/* Videobuf2 stuff */
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/m=
edia/platform/marvell-ccic/mmp-driver.c
index 05b9fa8c6a6f..efbffb06e25c 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -3,6 +3,7 @@
  * to work with the Armada 610 as used in the OLPC 1.75 system.
  *
  * Copyright 2011 Jonathan Corbet <corbet@lwn.net>
+ * Copyright 2018 Lubomir Rintel <lkundrak@v3.sk>
  *
  * This file may be distributed under the terms of the GNU General
  * Public License, version 2.
@@ -11,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
@@ -316,6 +316,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 	struct mmp_camera *cam;
 	struct mcam_camera *mcam;
 	struct resource *res;
+	struct fwnode_handle *ep;
 	struct mmp_camera_platform_data *pdata;
 	int ret;
=20
@@ -330,7 +331,6 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam->plat_power_down =3D mmpcam_power_down;
 	mcam->calc_dphy =3D mmpcam_calc_dphy;
 	mcam->dev =3D &pdev->dev;
-	mcam->use_smbus =3D 0;
 	pdata =3D pdev->dev.platform_data;
 	if (pdata) {
 		mcam->mclk_src =3D pdata->mclk_src;
@@ -374,15 +374,6 @@ static int mmpcam_probe(struct platform_device *pdev=
)
 	cam->power_regs =3D devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(cam->power_regs))
 		return PTR_ERR(cam->power_regs);
-	/*
-	 * Find the i2c adapter.  This assumes, of course, that the
-	 * i2c bus is already up and functioning.
-	 */
-	mcam->i2c_adapter =3D platform_get_drvdata(pdata->i2c_device);
-	if (mcam->i2c_adapter =3D=3D NULL) {
-		dev_err(&pdev->dev, "No i2c adapter\n");
-		return -ENODEV;
-	}
 	/*
 	 * Sensor GPIO pins.
 	 */
@@ -405,6 +396,19 @@ static int mmpcam_probe(struct platform_device *pdev=
)
=20
 	mcam_init_clk(mcam);
=20
+	/*
+	 * Create a match of the sensor against its OF node.
+	 */
+	ep =3D fwnode_graph_get_next_endpoint(of_fwnode_handle(pdev->dev.of_nod=
e),
+					    NULL);
+	if (!ep)
+		return -ENODEV;
+
+	mcam->asd.match_type =3D V4L2_ASYNC_MATCH_FWNODE;
+	mcam->asd.match.fwnode =3D fwnode_graph_get_remote_port_parent(ep);
+
+	fwnode_handle_put(ep);
+
 	/*
 	 * Power the device up and hand it off to the core.
 	 */
@@ -414,6 +418,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 	ret =3D mccic_register(mcam);
 	if (ret)
 		goto out_power_down;
+
 	/*
 	 * Finally, set up our IRQ now that the core is ready to
 	 * deal with it.
diff --git a/include/linux/platform_data/media/mmp-camera.h b/include/lin=
ux/platform_data/media/mmp-camera.h
index 4c3a80a45883..c573ebc40035 100644
--- a/include/linux/platform_data/media/mmp-camera.h
+++ b/include/linux/platform_data/media/mmp-camera.h
@@ -12,7 +12,6 @@ enum dphy3_algo {
 };
=20
 struct mmp_camera_platform_data {
-	struct platform_device *i2c_device;
 	int sensor_power_gpio;
 	int sensor_reset_gpio;
 	enum v4l2_mbus_type bus_type;
--=20
2.19.1
