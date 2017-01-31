Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:44259 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbdAaPt5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 10:49:57 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com, Wolfram Sang <wsa@the-dreams.de>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 11/11] media: rcar-vin: register the video device early
Date: Tue, 31 Jan 2017 16:40:16 +0100
Message-Id: <20170131154016.15526-12-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To support unbind and rebinding of video source subdevices while keeping
a constant video device the subdevice needs to be attached when the
first user opens the video device and detached when the last user closes
it.

This changes the rcar-vin behavior in such way that the video device is
registered at probe time while attaching to a subdeivce is done only
when the video device is opened. If at that time there is no subdevice
bound to the rcar-vin driver the open will fail with -EBUSY until a
subdevice are bound to the rcar-vin driver using the V4L2 asynchronous
subdevice API.

This changes fix an OPS when first unbinding a subdevice and later
rebinding it.

 # echo 2-0020 > /sys/bus/i2c/drivers/adv7180/unbind
 # echo 2-0020 > /sys/bus/i2c/drivers/adv7180/bind

 adv7180 2-0020: chip found @ 0x20 (e6530000.i2c)
 kobject (eaaab118): tried to init an initialized object, something is seriously wrong.
 CPU: 0 PID: 1640 Comm: bash Not tainted 4.10.0-rc4-00029-g19b80f8913cad837 #1
 Hardware name: Generic R8A7791 (Flattened Device Tree)
 Backtrace:
 [<c010a858>] (dump_backtrace) from [<c010aaa4>] (show_stack+0x18/0x1c)
  r7:00000016 r6:60070013 r5:00000000 r4:c0a14dd8
 [<c010aa8c>] (show_stack) from [<c02de09c>] (dump_stack+0x84/0xa0)
 [<c02de018>] (dump_stack) from [<c02dfee4>] (kobject_init+0x3c/0x98)
  r7:00000016 r6:eaaab2e4 r5:c0a1f4dc r4:eaaab118
 [<c02dfea8>] (kobject_init) from [<c03b9244>] (device_initialize+0x28/0xb0)
  r5:c0a70be8 r4:eaaab110
 [<c03b921c>] (device_initialize) from [<c03baa34>] (device_register+0x14/0x20)
  r5:eaaab110 r4:eaaab110
 [<c03baa20>] (device_register) from [<c04a02c0>] (__video_register_device+0xb38/0x11cc)
  r5:eaaab110 r4:eaaab020
 [<c049f788>] (__video_register_device) from [<c04c91a0>] (rvin_v4l2_probe+0x17c/0x1e8)
  r10:00000000 r9:eaa3c050 r8:c0a270a8 r7:eaaab3a0 r6:eaaab020 r5:c0790068
  r4:eaaab010
 [<c04c9024>] (rvin_v4l2_probe) from [<c04c6da0>] (rvin_digital_notify_complete+0x174/0x184)
  r7:00002006 r6:eaaab010 r5:00000000 r4:eaaab3e0
 [<c04c6c2c>] (rvin_digital_notify_complete) from [<c04af180>] (v4l2_async_test_notify+0xe8/0xf0)
  r7:eaaab410 r6:eaa3c050 r5:c04c6c2c r4:eaaab3e0
 [<c04af098>] (v4l2_async_test_notify) from [<c04af560>] (v4l2_async_register_subdev+0xa4/0xcc)
  r7:eaa3c0fc r6:c0a27094 r5:eaaab3e0 r4:eaa3c050
 [<c04af4bc>] (v4l2_async_register_subdev) from [<c0497740>] (adv7180_probe+0x350/0x3e0)
  r9:eaa3c050 r8:00000000 r7:00000000 r6:00000000 r5:eb2cbe00 r4:eaa3c010
 [<c04973f0>] (adv7180_probe) from [<c048e9f4>] (i2c_device_probe+0x238/0x250)
  r9:0000000e r8:c0a264dc r7:eb2cbe20 r6:c0a264dc r5:c04973f0 r4:eb2cbe00
 [<c048e7bc>] (i2c_device_probe) from [<c03bd4f4>] (driver_probe_device+0x1f8/0x2c0)
  r9:0000000e r8:c0a264dc r7:00000000 r6:c0a70c18 r5:c0a70c0c r4:eb2cbe20
 [<c03bd2fc>] (driver_probe_device) from [<c03bbcd0>] (bind_store+0x94/0xe8)
  r10:00000000 r9:00000051 r8:00000007 r7:c0a26058 r6:eb2cbe54 r5:c0a264dc
  r4:eb2cbe20 r3:ea60b000
 [<c03bbc3c>] (bind_store) from [<c03bb710>] (drv_attr_store+0x2c/0x38)
  r9:00000051 r8:eb2daa0c r7:ea58ff80 r6:eb2daa00 r5:ea87a4c0 r4:c03bbc3c
 [<c03bb6e4>] (drv_attr_store) from [<c023e5e4>] (sysfs_kf_write+0x40/0x4c)
  r5:ea87a4c0 r4:c03bb6e4
 [<c023e5a4>] (sysfs_kf_write) from [<c023dc50>] (kernfs_fop_write+0x13c/0x1ac)
  r5:ea87a4c0 r4:00000007
 [<c023db14>] (kernfs_fop_write) from [<c01e0c78>] (__vfs_write+0x34/0x114)
  r9:ea58e000 r8:00000000 r7:00000007 r6:ea58ff80 r5:ea52a480 r4:c023db14
 [<c01e0c44>] (__vfs_write) from [<c01e0ee4>] (vfs_write+0xc4/0x150)
  r7:ea58ff80 r6:00167028 r5:00000007 r4:ea52a480
 [<c01e0e20>] (vfs_write) from [<c01e1038>] (SyS_write+0x48/0x80)
  r9:ea58e000 r8:c0106ee4 r7:00000007 r6:00167028 r5:ea52a480 r4:ea52a480
 [<c01e0ff0>] (SyS_write) from [<c0106d20>] (ret_fast_syscall+0x0/0x3c)
  r7:00000004 r6:b6dfed50 r5:00167028 r4:00000007

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c |  10 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 226 ++++++++++++++--------------
 drivers/media/platform/rcar-vin/rcar-vin.h  |   2 +
 3 files changed, 121 insertions(+), 117 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 50058fe9e37d8771..c86e71ad369cb929 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -107,7 +107,7 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 		return ret;
 	}
 
-	return rvin_v4l2_probe(vin);
+	return 0;
 }
 
 static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
@@ -118,7 +118,6 @@ static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
 
 	if (vin->digital.subdev == subdev) {
 		vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
-		rvin_v4l2_remove(vin);
 		vin->digital.subdev = NULL;
 		return;
 	}
@@ -283,6 +282,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
 
 	vin->dev = &pdev->dev;
 	vin->chip = (enum chip_id)match->data;
+	vin->last_input = NULL;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (mem == NULL)
@@ -304,6 +304,10 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error;
 
+	ret = rvin_v4l2_probe(vin);
+	if (ret)
+		goto error;
+
 	pm_suspend_ignore_children(&pdev->dev, true);
 	pm_runtime_enable(&pdev->dev);
 
@@ -324,6 +328,8 @@ static int rcar_vin_remove(struct platform_device *pdev)
 
 	v4l2_async_notifier_unregister(&vin->notifier);
 
+	rvin_v4l2_remove(vin);
+
 	rvin_dma_remove(vin);
 
 	return 0;
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 929f58b49b06154d..47137d770290084a 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -483,6 +483,94 @@ static int rvin_cropcap(struct file *file, void *priv,
 	return v4l2_subdev_call(sd, video, g_pixelaspect, &crop->pixelaspect);
 }
 
+static int rvin_attach_subdevices(struct rvin_dev *vin)
+{
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &fmt.format;
+	struct v4l2_subdev *sd = vin_to_source(vin);
+	struct rvin_graph_entity *rent;
+	struct v4l2_format f;
+	int ret;
+
+	rent = vin_to_entity(vin);
+	if (!rent)
+		return -ENODEV;
+
+	ret = v4l2_subdev_call(sd, core, s_power, 1);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		return ret;
+
+	if (rent != vin->last_input) {
+		/* Input source have changed, reset our format */
+
+		vin->vdev.tvnorms = 0;
+		ret = v4l2_subdev_call(sd, video, g_tvnorms,
+				       &vin->vdev.tvnorms);
+		if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+			goto error;
+
+		/* Free old controls (safe even if there where none) */
+		v4l2_ctrl_handler_free(&vin->ctrl_handler);
+
+		ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
+		if (ret < 0)
+			goto error;
+
+		/* Add new controls */
+		ret = v4l2_ctrl_add_handler(&vin->ctrl_handler,
+					    sd->ctrl_handler, NULL);
+		if (ret < 0)
+			goto error;
+
+		v4l2_ctrl_handler_setup(&vin->ctrl_handler);
+
+		fmt.pad = rent->source_pad_idx;
+
+		/* Try to improve our guess of a reasonable window format */
+		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
+		if (ret)
+			goto error;
+
+		/* Set default format */
+		vin->format.width	= mf->width;
+		vin->format.height	= mf->height;
+		vin->format.colorspace	= mf->colorspace;
+		vin->format.field	= mf->field;
+		vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
+
+		/* Set initial crop and compose */
+		vin->crop.top = vin->crop.left = 0;
+		vin->crop.width = mf->width;
+		vin->crop.height = mf->height;
+
+		vin->compose.top = vin->compose.left = 0;
+		vin->compose.width = mf->width;
+		vin->compose.height = mf->height;
+
+		f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		f.fmt.pix = vin->format;
+		ret = __rvin_s_fmt_vid_cap(vin, &f);
+		if (ret)
+			goto error;
+	}
+
+	vin->last_input = rent;
+
+	return 0;
+error:
+	v4l2_subdev_call(sd, core, s_power, 0);
+	return ret;
+}
+
+static void rvin_detach_subdevices(struct rvin_dev *vin)
+{
+	struct v4l2_subdev *sd = vin_to_source(vin);
+
+	v4l2_subdev_call(sd, core, s_power, 0);
+}
+
 static int rvin_enum_input(struct file *file, void *priv,
 			   struct v4l2_input *i)
 {
@@ -741,80 +829,6 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
  * File Operations
  */
 
-static int rvin_power_on(struct rvin_dev *vin)
-{
-	int ret;
-	struct v4l2_subdev *sd = vin_to_source(vin);
-
-	pm_runtime_get_sync(vin->v4l2_dev.dev);
-
-	ret = v4l2_subdev_call(sd, core, s_power, 1);
-	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
-		return ret;
-	return 0;
-}
-
-static int rvin_power_off(struct rvin_dev *vin)
-{
-	int ret;
-	struct v4l2_subdev *sd = vin_to_source(vin);
-
-	ret = v4l2_subdev_call(sd, core, s_power, 0);
-
-	pm_runtime_put(vin->v4l2_dev.dev);
-
-	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
-		return ret;
-
-	return 0;
-}
-
-static int rvin_initialize_device(struct file *file)
-{
-	struct rvin_dev *vin = video_drvdata(file);
-	int ret;
-
-	struct v4l2_format f = {
-		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
-		.fmt.pix = {
-			.width		= vin->format.width,
-			.height		= vin->format.height,
-			.field		= vin->format.field,
-			.colorspace	= vin->format.colorspace,
-			.pixelformat	= vin->format.pixelformat,
-		},
-	};
-
-	ret = rvin_power_on(vin);
-	if (ret < 0)
-		return ret;
-
-	pm_runtime_enable(&vin->vdev.dev);
-	ret = pm_runtime_resume(&vin->vdev.dev);
-	if (ret < 0 && ret != -ENOSYS)
-		goto eresume;
-
-	/*
-	 * Try to configure with default parameters. Notice: this is the
-	 * very first open, so, we cannot race against other calls,
-	 * apart from someone else calling open() simultaneously, but
-	 * .host_lock is protecting us against it.
-	 */
-	ret = rvin_s_fmt_vid_cap(file, NULL, &f);
-	if (ret < 0)
-		goto esfmt;
-
-	v4l2_ctrl_handler_setup(&vin->ctrl_handler);
-
-	return 0;
-esfmt:
-	pm_runtime_disable(&vin->vdev.dev);
-eresume:
-	rvin_power_off(vin);
-
-	return ret;
-}
-
 static int rvin_open(struct file *file)
 {
 	struct rvin_dev *vin = video_drvdata(file);
@@ -826,17 +840,31 @@ static int rvin_open(struct file *file)
 
 	ret = v4l2_fh_open(file);
 	if (ret)
-		goto unlock;
+		goto err_out;
 
-	if (!v4l2_fh_is_singular_file(file))
-		goto unlock;
+	/* If there is no subdevice there is not much we can do */
+	if (!vin_to_source(vin)) {
+		ret = -EBUSY;
+		goto err_open;
+	}
 
-	if (rvin_initialize_device(file)) {
-		v4l2_fh_release(file);
-		ret = -ENODEV;
+	if (v4l2_fh_is_singular_file(file)) {
+		pm_runtime_get_sync(vin->dev);
+		ret = rvin_attach_subdevices(vin);
+		if (ret) {
+			vin_err(vin, "Error attaching subdevice\n");
+			goto err_power;
+		}
 	}
 
-unlock:
+	mutex_unlock(&vin->lock);
+
+	return 0;
+err_power:
+	pm_runtime_put(vin->dev);
+err_open:
+	v4l2_fh_release(file);
+err_out:
 	mutex_unlock(&vin->lock);
 	return ret;
 }
@@ -860,9 +888,8 @@ static int rvin_release(struct file *file)
 	 * Then de-initialize hw module.
 	 */
 	if (fh_singular) {
-		pm_runtime_suspend(&vin->vdev.dev);
-		pm_runtime_disable(&vin->vdev.dev);
-		rvin_power_off(vin);
+		rvin_detach_subdevices(vin);
+		pm_runtime_put(vin->dev);
 	}
 
 	mutex_unlock(&vin->lock);
@@ -910,41 +937,10 @@ static void rvin_notify(struct v4l2_subdev *sd,
 int rvin_v4l2_probe(struct rvin_dev *vin)
 {
 	struct video_device *vdev = &vin->vdev;
-	struct v4l2_subdev *sd = vin_to_source(vin);
 	int ret;
 
-	v4l2_set_subdev_hostdata(sd, vin);
-
 	vin->v4l2_dev.notify = rvin_notify;
 
-	ret = v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
-	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
-		return ret;
-
-	if (vin->vdev.tvnorms == 0) {
-		/* Disable the STD API if there are no tvnorms defined */
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_G_STD);
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_S_STD);
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_QUERYSTD);
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_ENUMSTD);
-	}
-
-	/* Add the controls */
-	/*
-	 * Currently the subdev with the largest number of controls (13) is
-	 * ov6550. So let's pick 16 as a hint for the control handler. Note
-	 * that this is a hint only: too large and you waste some memory, too
-	 * small and there is a (very) small performance hit when looking up
-	 * controls in the internal hash.
-	 */
-	ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
-	if (ret < 0)
-		return ret;
-
-	ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, sd->ctrl_handler, NULL);
-	if (ret < 0)
-		return ret;
-
 	/* video node */
 	vdev->fops = &rvin_fops;
 	vdev->v4l2_dev = &vin->v4l2_dev;
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index d31212a992e15506..2a1b1908ec1d52b5 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -111,6 +111,7 @@ struct rvin_graph_entity {
  * @sequence:		V4L2 buffers sequence number
  * @state:		keeps track of operation state
  *
+ * @last_input:		points to the last active input source
  * @source:		active format from the video source
  * @format:		active V4L2 pixel format
  *
@@ -138,6 +139,7 @@ struct rvin_dev {
 	unsigned int sequence;
 	enum rvin_dma_state state;
 
+	struct rvin_graph_entity *last_input;
 	struct rvin_source_fmt source;
 	struct v4l2_pix_format format;
 
-- 
2.11.0

