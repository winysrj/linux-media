Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:56084 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbcGSOXQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 10:23:16 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 12/16] [media] rcar-vin: allow subdevices to be bound late
Date: Tue, 19 Jul 2016 16:21:03 +0200
Message-Id: <20160719142107.22358-13-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is done to prepare for Gen3 support where there are more than one
subdevice and the usage of them are complex. There is a need to be able
to change which subdevices are involved in capturing during runtime (but
not while streaming). Furthermore the subdevices can be shared by
more then one rcar-vin instance. To be able to facilitate this for Gen3
this patch adds support to select an input (set of subdevices) after the
struct video_device have been registered.

It makes the selection when the first open occurs on the video device,
concurrent opens of the device are stuck with the input which was set by
the first open. A exception to this is if there is only one user of the
video device it is possible to change the input selection using s_input.
If s_input is attempted while there are more then one user of the video
device it will be disallowed with a -EBUSY. If a user tries to open the
video device before it has found a valid input (bound its subdevices) it
will be denied to open the video device with a -EBUSY.

At this point this change is purely academic since the driver in its
current form only supports one subdevice so not much point in trying to
change it. It dose however solve the issue of bind/unbind of subdevices
and still remaining operational.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 106 ++++++++--
 drivers/media/platform/rcar-vin/rcar-dma.c  |   7 -
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 310 +++++++++++++---------------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  27 ++-
 4 files changed, 254 insertions(+), 196 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 6fe9b6c..5171953 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -29,6 +29,45 @@
  * Subdevice group helpers
  */
 
+static unsigned int rvin_pad_idx(struct v4l2_subdev *sd, int direction)
+{
+	unsigned int pad_idx;
+
+	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
+		if (sd->entity.pads[pad_idx].flags == direction)
+			return pad_idx;
+
+	return 0;
+}
+
+int rvin_subdev_get(struct rvin_dev *vin)
+{
+	strncpy(vin->inputs[0].name, "Digital", RVIN_INPUT_NAME_SIZE);
+	vin->inputs[0].sink_idx =
+		rvin_pad_idx(vin->digital.subdev, MEDIA_PAD_FL_SINK);
+	vin->inputs[0].source_idx =
+		rvin_pad_idx(vin->digital.subdev, MEDIA_PAD_FL_SOURCE);
+
+	vin->current_input = 0;
+
+	return 0;
+}
+
+int rvin_subdev_put(struct rvin_dev *vin)
+{
+	vin->current_input = 0;
+
+	return 0;
+}
+
+int rvin_subdev_set_input(struct rvin_dev *vin, struct rvin_input_item *item)
+{
+	if (vin->digital.subdev)
+		return 0;
+
+	return -EBUSY;
+}
+
 int rvin_subdev_get_code(struct rvin_dev *vin, u32 *code)
 {
 	*code = vin->digital.code;
@@ -149,7 +188,7 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 		return ret;
 	}
 
-	return rvin_v4l2_probe(vin);
+	return 0;
 }
 
 static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
@@ -160,7 +199,6 @@ static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
 
 	if (vin->digital.subdev == subdev) {
 		vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
-		rvin_v4l2_remove(vin);
 		vin->digital.subdev = NULL;
 		return;
 	}
@@ -307,24 +345,12 @@ static const struct of_device_id rvin_of_id_table[] = {
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
 
-static int rcar_vin_probe(struct platform_device *pdev)
+static int rvin_probe_channel(struct platform_device *pdev,
+			      struct rvin_dev *vin)
 {
-	const struct of_device_id *match;
-	struct rvin_dev *vin;
 	struct resource *mem;
 	int irq, ret;
 
-	vin = devm_kzalloc(&pdev->dev, sizeof(*vin), GFP_KERNEL);
-	if (!vin)
-		return -ENOMEM;
-
-	match = of_match_device(of_match_ptr(rvin_of_id_table), &pdev->dev);
-	if (!match)
-		return -ENODEV;
-
-	vin->dev = &pdev->dev;
-	vin->chip = (enum chip_id)match->data;
-
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (mem == NULL)
 		return -EINVAL;
@@ -341,18 +367,54 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	return 0;
+}
+
+static int rcar_vin_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	struct rvin_dev *vin;
+	int ret;
+
+	vin = devm_kzalloc(&pdev->dev, sizeof(*vin), GFP_KERNEL);
+	if (!vin)
+		return -ENOMEM;
+
+	match = of_match_device(of_match_ptr(rvin_of_id_table), &pdev->dev);
+	if (!match)
+		return -ENODEV;
+
+	vin->dev = &pdev->dev;
+	vin->chip = (enum chip_id)match->data;
+
+	/* Initialize the top-level structure */
+	ret = v4l2_device_register(vin->dev, &vin->v4l2_dev);
+	if (ret)
+		return ret;
+
+	ret = rvin_probe_channel(pdev, vin);
+	if (ret)
+		goto err_register;
+
 	ret = rvin_digital_graph_init(vin);
 	if (ret < 0)
-		goto error;
+		goto err_dma;
 
-	pm_suspend_ignore_children(&pdev->dev, true);
-	pm_runtime_enable(&pdev->dev);
+	ret = rvin_v4l2_probe(vin);
+	if (ret)
+		goto err_dma;
 
 	platform_set_drvdata(pdev, vin);
 
+	pm_suspend_ignore_children(&pdev->dev, true);
+	pm_runtime_enable(&pdev->dev);
+
 	return 0;
-error:
+
+err_dma:
 	rvin_dma_remove(vin);
+err_register:
+	v4l2_device_unregister(&vin->v4l2_dev);
 
 	return ret;
 }
@@ -363,10 +425,14 @@ static int rcar_vin_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 
+	rvin_v4l2_remove(vin);
+
 	v4l2_async_notifier_unregister(&vin->notifier);
 
 	rvin_dma_remove(vin);
 
+	v4l2_device_unregister(&vin->v4l2_dev);
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 252adae..7e571a8 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1134,8 +1134,6 @@ void rvin_dma_remove(struct rvin_dev *vin)
 		vb2_dma_contig_cleanup_ctx(vin->alloc_ctx);
 
 	mutex_destroy(&vin->lock);
-
-	v4l2_device_unregister(&vin->v4l2_dev);
 }
 
 int rvin_dma_probe(struct rvin_dev *vin, int irq)
@@ -1143,11 +1141,6 @@ int rvin_dma_probe(struct rvin_dev *vin, int irq)
 	struct vb2_queue *q = &vin->queue;
 	int i, ret;
 
-	/* Initialize the top-level structure */
-	ret = v4l2_device_register(vin->dev, &vin->v4l2_dev);
-	if (ret)
-		return ret;
-
 	mutex_init(&vin->lock);
 	INIT_LIST_HEAD(&vin->buf_list);
 
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 90f2725..1b4b1dc 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -114,7 +114,7 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 	if (pad_cfg == NULL)
 		return -ENOMEM;
 
-	format.pad = vin->src_pad_idx;
+	format.pad = vin->inputs[vin->current_input].source_idx;
 
 	ret = rvin_subdev_call(vin, pad, set_fmt, pad_cfg, &format);
 	if (ret < 0 && ret != -ENOIOCTLCMD)
@@ -228,10 +228,8 @@ static int rvin_try_fmt_vid_cap(struct file *file, void *priv,
 				 &source);
 }
 
-static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
-			      struct v4l2_format *f)
+static int __rvin_s_fmt_vid_cap(struct rvin_dev *vin, struct v4l2_format *f)
 {
-	struct rvin_dev *vin = video_drvdata(file);
 	struct rvin_source_fmt source;
 	int ret;
 
@@ -251,6 +249,14 @@ static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
+static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
+			      struct v4l2_format *f)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+
+	return __rvin_s_fmt_vid_cap(vin, f);
+}
+
 static int rvin_g_fmt_vid_cap(struct file *file, void *priv,
 			      struct v4l2_format *f)
 {
@@ -389,16 +395,87 @@ static int rvin_cropcap(struct file *file, void *priv,
 	return rvin_subdev_call(vin, video, cropcap, crop);
 }
 
+static int rvin_attach_subdevices(struct rvin_dev *vin)
+{
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &fmt.format;
+	struct v4l2_format f;
+	int ret;
+
+	ret = rvin_subdev_set_input(vin, &vin->inputs[vin->current_input]);
+	if (ret)
+		return ret;
+
+	ret = rvin_subdev_call(vin, core, s_power, 1);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		return ret;
+
+	vin->vdev.tvnorms = 0;
+	ret = rvin_subdev_call(vin, video, g_tvnorms, &vin->vdev.tvnorms);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		goto error;
+
+	/* Add controlls */
+	ret = rvin_subdev_ctrl_add_handler(vin);
+	if (ret < 0)
+		goto error;
+
+	v4l2_ctrl_handler_setup(&vin->ctrl_handler);
+
+	fmt.pad = vin->inputs[vin->current_input].source_idx;
+
+	/* Try to improve our guess of a reasonable window format */
+	ret = rvin_subdev_call(vin, pad, get_fmt, NULL, &fmt);
+	if (ret)
+		goto error;
+
+	/* Set default format */
+	vin->format.width	= mf->width;
+	vin->format.height	= mf->height;
+	vin->format.colorspace	= mf->colorspace;
+	vin->format.field	= mf->field;
+	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
+
+	/* Set initial crop and compose */
+	vin->crop.top = vin->crop.left = 0;
+	vin->crop.width = mf->width;
+	vin->crop.height = mf->height;
+
+	vin->compose.top = vin->compose.left = 0;
+	vin->compose.width = mf->width;
+	vin->compose.height = mf->height;
+
+	f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	f.fmt.pix = vin->format;
+	ret = __rvin_s_fmt_vid_cap(vin, &f);
+	if (ret)
+		goto error;
+
+	return 0;
+error:
+	rvin_subdev_call(vin, core, s_power, 0);
+	return ret;
+}
+
+static void rvin_detach_subdevices(struct rvin_dev *vin)
+{
+	rvin_subdev_call(vin, core, s_power, 0);
+}
+
 static int rvin_enum_input(struct file *file, void *priv,
 			   struct v4l2_input *i)
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_dv_timings_cap cap;
+	struct rvin_input_item *item;
 	int ret;
 
-	if (i->index != 0)
+	if (i->index >= RVIN_INPUT_MAX)
 		return -EINVAL;
 
+	item = &vin->inputs[i->index];
 
 	ret = rvin_subdev_call_input(vin, i->index, video,
 				     g_input_status, &i->status);
@@ -407,9 +484,10 @@ static int rvin_enum_input(struct file *file, void *priv,
 		return ret;
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
-	strlcpy(i->name, "Digital", sizeof(i->name));
+	strlcpy(i->name, item->name, sizeof(i->name));
 
 	/* Test if pad supports dv_timings_cap */
+	cap.pad = vin->inputs[i->index].sink_idx;
 	ret = rvin_subdev_call_input(vin, i->index, pad, dv_timings_cap, &cap);
 	if (ret) {
 		i->capabilities = V4L2_IN_CAP_STD;
@@ -428,15 +506,28 @@ static int rvin_enum_input(struct file *file, void *priv,
 
 static int rvin_g_input(struct file *file, void *priv, unsigned int *i)
 {
-	*i = 0;
+	struct rvin_dev *vin = video_drvdata(file);
+
+	*i = vin->current_input;
 	return 0;
 }
 
 static int rvin_s_input(struct file *file, void *priv, unsigned int i)
 {
-	if (i > 0)
+	struct rvin_dev *vin = video_drvdata(file);
+	int ret;
+
+	if (i >= RVIN_INPUT_MAX)
 		return -EINVAL;
-	return 0;
+
+	rvin_detach_subdevices(vin);
+
+	ret = rvin_subdev_set_input(vin, &vin->inputs[i]);
+	if (!ret)
+		vin->current_input = i;
+
+	/* Power on new subdevice */
+	return rvin_attach_subdevices(vin);
 }
 
 static int rvin_querystd(struct file *file, void *priv, v4l2_std_id *a)
@@ -451,6 +542,7 @@ static int rvin_s_std(struct file *file, void *priv, v4l2_std_id a)
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev_format fmt = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.pad = vin->inputs[vin->current_input].source_idx,
 	};
 	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	int ret;
@@ -501,10 +593,16 @@ static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
 				struct v4l2_enum_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
+	unsigned int input;
 	int ret;
 
-	ret = rvin_subdev_call_input(vin, timings->pad, pad, enum_dv_timings,
-				     timings);
+	input = timings->pad;
+
+	timings->pad = vin->inputs[input].sink_idx;
+
+	ret = rvin_subdev_call_input(vin, input, pad, enum_dv_timings, timings);
+
+	timings->pad = input;
 
 	return ret;
 }
@@ -547,9 +645,16 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
 			       struct v4l2_dv_timings_cap *cap)
 {
 	struct rvin_dev *vin = video_drvdata(file);
+	unsigned int input;
 	int ret;
 
-	ret = rvin_subdev_call_input(vin, cap->pad, pad, dv_timings_cap, cap);
+	input = cap->pad;
+
+	cap->pad = vin->inputs[input].sink_idx;
+
+	ret = rvin_subdev_call_input(vin, input, pad, dv_timings_cap, cap);
+
+	cap->pad = input;
 
 	return ret;
 }
@@ -599,80 +704,6 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
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
@@ -684,17 +715,30 @@ static int rvin_open(struct file *file)
 
 	ret = v4l2_fh_open(file);
 	if (ret)
-		goto unlock;
+		goto err_out;
 
-	if (!v4l2_fh_is_singular_file(file))
-		goto unlock;
-
-	if (rvin_initialize_device(file)) {
-		v4l2_fh_release(file);
-		ret = -ENODEV;
+	ret = rvin_subdev_get(vin);
+	if (ret)
+		goto err_open;
+
+	if (v4l2_fh_is_singular_file(file)) {
+		pm_runtime_get_sync(vin->dev);
+		ret = rvin_attach_subdevices(vin);
+		if (ret) {
+			vin_err(vin, "Error attaching subdevices\n");
+			goto err_get;
+		}
 	}
 
-unlock:
+	mutex_unlock(&vin->lock);
+
+	return 0;
+err_get:
+	pm_runtime_put(vin->dev);
+	rvin_subdev_put(vin);
+err_open:
+	v4l2_fh_release(file);
+err_out:
 	mutex_unlock(&vin->lock);
 	return ret;
 }
@@ -718,11 +762,12 @@ static int rvin_release(struct file *file)
 	 * Then de-initialize hw module.
 	 */
 	if (fh_singular) {
-		pm_runtime_suspend(&vin->vdev.dev);
-		pm_runtime_disable(&vin->vdev.dev);
-		rvin_power_off(vin);
+		rvin_detach_subdevices(vin);
+		pm_runtime_put(vin->dev);
 	}
 
+	rvin_subdev_put(vin);
+
 	mutex_unlock(&vin->lock);
 
 	return ret;
@@ -767,46 +812,11 @@ static void rvin_notify(struct v4l2_subdev *sd,
 
 int rvin_v4l2_probe(struct rvin_dev *vin)
 {
-	struct v4l2_subdev_format fmt = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	struct video_device *vdev = &vin->vdev;
-	struct v4l2_subdev *sd = vin_to_source(vin);
-	int pad_idx, ret;
-
-	v4l2_set_subdev_hostdata(sd, vin);
+	int ret;
 
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
@@ -819,40 +829,6 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 		V4L2_CAP_READWRITE;
 
-	vin->src_pad_idx = 0;
-	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
-		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SOURCE)
-			break;
-	if (pad_idx >= sd->entity.num_pads)
-		return -EINVAL;
-
-	vin->src_pad_idx = pad_idx;
-	fmt.pad = vin->src_pad_idx;
-
-	/* Try to improve our guess of a reasonable window format */
-	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
-	if (ret) {
-		vin_err(vin, "Failed to get initial format\n");
-		return ret;
-	}
-
-	/* Set default format */
-	vin->format.width	= mf->width;
-	vin->format.height	= mf->height;
-	vin->format.colorspace	= mf->colorspace;
-	vin->format.field	= mf->field;
-	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
-
-
-	/* Set initial crop and compose */
-	vin->crop.top = vin->crop.left = 0;
-	vin->crop.width = mf->width;
-	vin->crop.height = mf->height;
-
-	vin->compose.top = vin->compose.left = 0;
-	vin->compose.width = mf->width;
-	vin->compose.height = mf->height;
-
 	ret = video_register_device(&vin->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret) {
 		vin_err(vin, "Failed to register video device\n");
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index a8c4d72..d58a8c1 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -35,6 +35,21 @@ enum chip_id {
 	RCAR_GEN2,
 };
 
+#define RVIN_INPUT_MAX 1
+#define RVIN_INPUT_NAME_SIZE 32
+
+/**
+ * struct rvin_input_item - One possible input for the channel
+ * @name:       User-friendly name of the input
+ * @sink_idx:   Sink pad number from the subdevice associated with the input
+ * @source_idx: Source pad number from the subdevice associated with the input
+ */
+struct rvin_input_item {
+	char name[RVIN_INPUT_NAME_SIZE];
+	int sink_idx;
+	int source_idx;
+};
+
 /**
  * STOPPED  - No operation in progress
  * RUNNING  - Operation in progress have buffers
@@ -113,6 +128,9 @@ struct rvin_graph_entity {
  *
  * @crop:		active cropping
  * @compose:		active composing
+ *
+ * @current_input:	currently used input in @inputs
+ * @inputs:		list of valid inputs sources
  */
 struct rvin_dev {
 	struct device *dev;
@@ -142,9 +160,10 @@ struct rvin_dev {
 
 	struct v4l2_rect crop;
 	struct v4l2_rect compose;
-};
 
-#define vin_to_source(vin)		vin->digital.subdev
+	int current_input;
+	struct rvin_input_item inputs[RVIN_INPUT_MAX];
+};
 
 /* Debug */
 #define vin_dbg(d, fmt, arg...)		dev_dbg(d->dev, fmt, ##arg)
@@ -173,6 +192,10 @@ void rvin_crop_scale_comp(struct rvin_dev *vin);
 	(v->digital.subdev ?						\
 	 v4l2_subdev_call(v->digital.subdev, o, f, ##args) : -ENODEV)
 
+int rvin_subdev_get(struct rvin_dev *vin);
+int rvin_subdev_put(struct rvin_dev *vin);
+int rvin_subdev_set_input(struct rvin_dev *vin, struct rvin_input_item *item);
+
 int rvin_subdev_get_code(struct rvin_dev *vin, u32 *code);
 int rvin_subdev_get_mbus_cfg(struct rvin_dev *vin,
 			     struct v4l2_mbus_config *mbus_cfg);
-- 
2.9.0

