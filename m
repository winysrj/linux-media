Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:33442 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965801AbcKLNNp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 08:13:45 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 13/32] media: rcar-vin: register the video device early
Date: Sat, 12 Nov 2016 14:11:57 +0100
Message-Id: <20161112131216.22635-14-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is done to prepare for Gen3 support where there can be more then
one video pipeline which can terminate in a particular VIN instance.
Each pipeline have its own set of subdevices so to attach to a specific
subdevice at probe time is not possible. The pipelines will be
configured using the media controller API.

This patch changes the rcar-vin behavior so that the video device is
registered at probe time but attaching to a subdeivce is only once the
video device node is opened. If at that time there is no video source
subdevice for the VIN to use the open will fail with -EBUSY.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c |  10 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 226 ++++++++++++++--------------
 drivers/media/platform/rcar-vin/rcar-vin.h  |   2 +
 3 files changed, 121 insertions(+), 117 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 50058fe..5807d8d 100644
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
 
@@ -322,6 +326,8 @@ static int rcar_vin_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 
+	rvin_v4l2_remove(vin);
+
 	v4l2_async_notifier_unregister(&vin->notifier);
 
 	rvin_dma_remove(vin);
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 929f58b..47137d7 100644
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
index d31212a..2a1b190 100644
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
2.10.2

