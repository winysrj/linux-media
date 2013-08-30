Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:37350 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab3H3CSA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 22:18:00 -0400
Received: by mail-pa0-f51.google.com with SMTP id lf1so1687007pab.24
        for <linux-media@vger.kernel.org>; Thu, 29 Aug 2013 19:17:59 -0700 (PDT)
From: Pawel Osciak <posciak@chromium.org>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Pawel Osciak <posciak@chromium.org>
Subject: [PATCH v1 19/19] uvcvideo: Add support for UVC 1.5 VP8 simulcast.
Date: Fri, 30 Aug 2013 11:17:18 +0900
Message-Id: <1377829038-4726-20-git-send-email-posciak@chromium.org>
In-Reply-To: <1377829038-4726-1-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simulcast allows streaming up to 4 sub-streams (layers) from one video
streaming interface. Those stream are captured by the same sensor, but
encoding parameters can be set for each stream stream separately. Those
parameters may include properties such as resolution, bitrate, etc. Each
layer may be controlled separately and can be paused or resumed as needed,
without influencing other layers.

In V4L2, we create a separate video node for each stream and allow opening
and controlling them separately. Setting resolution, controls and
streamon/streamoff can be done independently on each node. Due to the
limitations inherent to the nature of simulcast though, those nodes do not
behave in a completely independent way with regards to format settings and
buffer allocation. When simulcast format is selected for one of the nodes,
it is set for all simulcast nodes and cannot be changed until all nodes are
idle. Once buffers are allocated for any of the nodes, the format cannot
be changed back to non-simulcast until buffers for all nodes have been
freed.

Internally, we assign and manage a separate video buffer queue for each
simulcast layer.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c   | 283 +++++++++++++++++++++++++++++++++++
 drivers/media/usb/uvc/uvc_driver.c | 176 +++++++++++++++-------
 drivers/media/usb/uvc/uvc_entity.c | 114 ++++++++++----
 drivers/media/usb/uvc/uvc_isight.c |   8 +-
 drivers/media/usb/uvc/uvc_queue.c  |  11 +-
 drivers/media/usb/uvc/uvc_v4l2.c   | 257 ++++++++++++++++++++++++++------
 drivers/media/usb/uvc/uvc_video.c  | 298 +++++++++++++++++++++++++++----------
 drivers/media/usb/uvc/uvcvideo.h   | 119 +++++++++++++--
 include/uapi/linux/usb/video.h     |   6 +
 9 files changed, 1046 insertions(+), 226 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index cd02c99..6a39020c 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -358,6 +358,14 @@ static struct uvc_control_info uvc_ctrls[] = {
 	 */
 	{
 		.entity		= UVC_GUID_UVC_ENCODING,
+		.selector	= UVC_EU_SELECT_LAYER_CONTROL,
+		.index		= 0,
+		.size		= 2,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_ENCODING,
 		.selector	= UVC_EU_PROFILE_TOOLSET_CONTROL,
 		.index		= 1,
 		.size		= 6,
@@ -367,6 +375,16 @@ static struct uvc_control_info uvc_ctrls[] = {
 	},
 	{
 		.entity		= UVC_GUID_UVC_ENCODING,
+		.selector	= UVC_EU_VIDEO_RESOLUTION_CONTROL,
+		.index		= 2,
+		.size		= 4,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
+				| UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
+				| UVC_CTRL_FLAG_GET_DEF
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_ENCODING,
 		.selector	= UVC_EU_MIN_FRAME_INTERVAL_CONTROL,
 		.index		= 3,
 		.size		= 4,
@@ -505,6 +523,14 @@ static struct uvc_control_info uvc_ctrls[] = {
 	},
 	{
 		.entity		= UVC_GUID_UVC_ENCODING,
+		.selector	= UVC_EU_START_OR_STOP_LAYER_CONTROL,
+		.index		= 18,
+		.size		= 1,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_ENCODING,
 		.selector	= UVC_EU_ERROR_RESILIENCY_CONTROL,
 		.index		= 19,
 		.size		= 2,
@@ -1131,6 +1157,16 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.v4l2_type	= V4L2_CTRL_TYPE_BITMASK,
 		.data_type	= UVC_CTRL_DATA_TYPE_BITMASK,
 	},
+	{
+		.id		= V4L2_CID_ENCODER_TEMPORAL_LAYER_ENABLE,
+		.name		= "Encoder, temporal layer enable",
+		.entity		= UVC_GUID_UVC_ENCODING,
+		.selector	= UVC_EU_START_OR_STOP_LAYER_CONTROL,
+		.size		= 1,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
+		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
+	},
 };
 
 /* ------------------------------------------------------------------------
@@ -1918,6 +1954,20 @@ int uvc_ctrl_get(struct uvc_video_chain *chain, struct v4l2_ext_control *xctrl,
 	return __uvc_ctrl_get(chain, ctrl, mapping, &xctrl->value);
 }
 
+int uvc_ctrl_set_raw_val(struct uvc_control *ctrl,
+				struct uvc_control_mapping *mapping, u32 value)
+{
+	struct uvc_device *dev = ctrl->entity->chain->dev;
+
+	mapping->set(mapping, value,
+			uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
+
+	return uvc_query_ctrl(dev, UVC_SET_CUR, ctrl->entity->id,
+				dev->intfnum, ctrl->info.selector,
+				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
+				ctrl->info.size);
+}
+
 int uvc_ctrl_set(struct uvc_video_chain *chain, struct v4l2_ext_control *xctrl,
 		 bool streaming)
 {
@@ -2307,6 +2357,239 @@ done:
 }
 
 /* --------------------------------------------------------------------------
+ * Non-exported encoder controls
+ */
+/* Must be called under chain lock */
+int __uvc_video_layer_select(struct uvc_stream_layer *layer, int temporal_id)
+{
+	struct uvc_streaming *stream = layer->stream;
+	struct uvc_video_chain *chain = stream->chain;
+	struct uvc_control *ctrl;
+	__u8 data[2];
+
+	if (!chain->encoding || !chain->layer_ctrl)
+		return 0;
+
+	uvc_trace(UVC_TRACE_CONTROL, "Selecting layer: %d temporal_id: %d\n",
+			layer->layer_id, temporal_id);
+
+	if (uvc_cur_fmt_has_tmprl_layers(stream)) {
+		if (temporal_id > stream->cur_frame->bmScalabilityCapabilities
+			&& temporal_id != UVC_VP8_TEMPORAL_LAYOUT_WILDCARD) {
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "Invalid temporal id %d\n", temporal_id);
+			return -EINVAL;
+		}
+	} else {
+		temporal_id = 0;
+	}
+
+	ctrl = chain->layer_ctrl;
+
+	memset(data, 0, 2);
+	__uvc_set_le_value(3, 7, temporal_id, data, false);
+	__uvc_set_le_value(3, 10, layer->layer_id, data, true);
+
+	return uvc_query_ctrl(chain->dev, UVC_SET_CUR, ctrl->entity->id,
+			      chain->dev->intfnum, ctrl->info.selector,
+			      data, ctrl->info.size);
+}
+
+bool uvc_is_layer_negotiated(struct uvc_streaming *stream, int layer_id)
+{
+	if (layer_id > stream->num_layers)
+		return false;
+
+	if (stream->ctrl.bmLayoutPerStream[layer_id] & 0x1)
+		return true;
+	else
+		return false;
+}
+
+/* Must be called under stream->mutex. */
+int uvc_ctrl_layer_enable(struct uvc_stream_layer *layer, int enable)
+{
+	struct uvc_video_chain *chain = layer->stream->chain;
+	struct uvc_control *ctrl;
+	__u8 data[4];
+	int ret;
+
+	if (!chain->encoding || !chain->startstop_ctrl)
+		return -EINVAL;
+
+	if (layer->stream->streaming_layers) {
+		/* We are streaming. If we can't enable/disable during
+		 * streaming, check if stream has already been enabled on P&C,
+		 * if so, it couldn't have been changed during streaming, so
+		 * just return success. If it hasn't been enabled on P&C,
+		 * we can't do it now so return EBUSY.
+		 */
+		if (!(layer->stream->simulcast_caps
+				 & UVC_SIMUL_CAP_STARTSTOP_LAYER_STREAMTIME)) {
+			if (uvc_is_layer_negotiated(layer->stream,
+							layer->layer_id))
+				return 0;
+			else
+				return -EBUSY;
+		} /* else we can enable/disable and will do so below. */
+	} else if (!(layer->stream->simulcast_caps
+				& UVC_SIMUL_CAP_STARTSTOP_LAYER)) {
+		/* Not streaming, but change not allowed even now.
+		 * If the layer has been negotiated on P&C, then it's already
+		 * enabled, return success, else we can't enable it at all.
+		 */
+		if (uvc_is_layer_negotiated(layer->stream, layer->layer_id))
+			return 0;
+		else
+			return -EBUSY;
+	} /* else not streaming and can enable/disable, do so below. */
+
+	ret = __uvc_ctrl_lock(chain);
+	if (ret < 0)
+		return ret;
+
+	/* TODO: might need to cache current temporal id configuration
+	 * for suspend/resume.
+	 */
+	ret = __uvc_video_layer_select(layer, 0x7);
+	if (ret)
+		goto unlock;
+
+	ctrl = chain->startstop_ctrl;
+	memset(data, 0, 4);
+	__uvc_set_le_value(1, 0, !!enable, data, false);
+	ret = uvc_query_ctrl(chain->dev, UVC_SET_CUR, ctrl->entity->id,
+			     chain->dev->intfnum, ctrl->info.selector,
+			     data, ctrl->info.size);
+unlock:
+	__uvc_ctrl_unlock(chain);
+	return ret;
+}
+
+int __uvc_video_layer_query_resolution(struct uvc_stream_layer *layer,
+					int width, int height,
+					__u8 query)
+{
+	struct uvc_video_chain *chain = layer->stream->chain;
+	struct uvc_control *ctrl;
+	__u8 data[4];
+	int ret;
+
+	ret = __uvc_ctrl_lock(chain);
+	if (ret < 0)
+		return ret;
+
+	ret = __uvc_video_layer_select(layer, 0);
+	if (ret)
+		goto unlock;
+
+	ctrl = chain->res_ctrl;
+	memset(data, 0, 4);
+	__uvc_set_le_value(16, 0, width, data, false);
+	__uvc_set_le_value(16, 16, height, data, true);
+	ret = uvc_query_ctrl(chain->dev, query, ctrl->entity->id,
+			     chain->dev->intfnum, ctrl->info.selector,
+			     data, ctrl->info.size);
+
+	if (ret == 0 && (query == UVC_SET_CUR || query == UVC_GET_CUR)) {
+		layer->width = __uvc_get_le_value(16, 0, data,
+						UVC_CTRL_DATA_TYPE_UNSIGNED);
+		layer->height = __uvc_get_le_value(16, 16, data,
+						UVC_CTRL_DATA_TYPE_UNSIGNED);
+	}
+
+unlock:
+	__uvc_ctrl_unlock(chain);
+	return ret;
+}
+
+int uvc_video_layer_set_resolution(struct uvc_stream_layer *layer,
+					int width, int height)
+{
+	struct uvc_video_chain *chain = layer->stream->chain;
+	int ret;
+
+	/* TODO: will fail if not exactly supported resolution. Not a huge
+	 * problem, but would be nice to use bResolutionScaling in format
+	 * descriptors to adjust to the nearest supported resolution instead.
+	 */
+	if (!chain->encoding || !chain->res_ctrl)
+		return -EINVAL;
+
+	if (layer->stream->streaming_layers) {
+		if (!(layer->stream->simulcast_caps
+			 & UVC_SIMUL_CAP_RES_STREAMTIME))
+			return -EBUSY;
+	} else if (!(layer->stream->simulcast_caps & UVC_SIMUL_CAP_RES)) {
+		/* This function is only called if we are simulcasting.
+		 * Resolution control has to be usable in that case at least
+		 * when not streaming, otherwise there would be no other
+		 * way to set/get stream resolution. So if we get here,
+		 * the device is not really usable.
+		 */
+		return -EINVAL;
+	}
+
+	ret = __uvc_video_layer_query_resolution(layer, width, height,
+						 UVC_SET_CUR);
+	if (ret == 0) {
+		uvc_trace(UVC_TRACE_CONTROL,
+			"Layer %d resolution set to %dx%d\n",
+			layer->layer_id, width, height);
+	}
+
+	return ret;
+}
+
+int uvc_video_layer_get_resolution(struct uvc_stream_layer *layer)
+{
+	struct uvc_video_chain *chain = layer->stream->chain;
+
+	if (!chain->encoding || !uvc_is_simulcasting(layer->stream)
+			|| !chain->res_ctrl) {
+		layer->width = layer->stream->cur_frame->wWidth;
+		layer->height = layer->stream->cur_frame->wHeight;
+		return 0;
+	}
+
+	return __uvc_video_layer_query_resolution(layer, 0, 0, UVC_GET_CUR);
+}
+
+void uvc_ctrl_simulcast_init(struct uvc_streaming *stream)
+{
+	struct uvc_control *ctrl;
+
+	ctrl = stream->chain->startstop_ctrl;
+	if (ctrl) {
+		if (ctrl->on_init)
+			stream->simulcast_caps |= UVC_SIMUL_CAP_STARTSTOP_LAYER;
+		if (ctrl->in_runtime)
+			stream->simulcast_caps |=
+				UVC_SIMUL_CAP_STARTSTOP_LAYER_STREAMTIME;
+	}
+
+	ctrl = stream->chain->res_ctrl;
+	if (ctrl) {
+		if (ctrl->on_init)
+			stream->simulcast_caps |= UVC_SIMUL_CAP_RES;
+		if (ctrl->in_runtime)
+			stream->simulcast_caps |=
+				UVC_SIMUL_CAP_RES_STREAMTIME;
+	}
+
+	uvc_trace(UVC_TRACE_CONTROL, "Available simulcast capabilities: "
+			"start/stop layer: %c (while streaming: %c), "
+			"resolution change: %c (while streaming: %c).\n",
+		stream->simulcast_caps
+			& UVC_SIMUL_CAP_STARTSTOP_LAYER ? 'Y' : 'N',
+		stream->simulcast_caps
+			& UVC_SIMUL_CAP_STARTSTOP_LAYER_STREAMTIME ? 'Y' : 'N',
+		stream->simulcast_caps & UVC_SIMUL_CAP_RES ? 'Y' : 'N',
+		stream->simulcast_caps
+			& UVC_SIMUL_CAP_RES_STREAMTIME ? 'Y' : 'N');
+}
+
+/* --------------------------------------------------------------------------
  * Suspend/resume
  */
 
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 27a7a11..ea5b63a 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -402,14 +402,23 @@ static int uvc_parse_format(struct uvc_device *dev,
 		break;
 
 	case UVC_VS_FORMAT_VP8:
+	case UVC_VS_FORMAT_VP8_SIMULCAST:
 		if (buflen < 13)
 			goto format_error;
 
 		format->bpp = 0;
 		format->flags = UVC_FMT_FLAG_COMPRESSED;
 		ftype = UVC_VS_FRAME_VP8;
-		strlcpy(format->name, "VP8", sizeof(format->name));
-		format->fcc = V4L2_PIX_FMT_VP8;
+		if (buffer[2] == UVC_VS_FORMAT_VP8) {
+			strlcpy(format->name, "VP8", sizeof(format->name));
+			format->fcc = V4L2_PIX_FMT_VP8;
+		} else {
+			strlcpy(format->name, "VP8 Simulcast",
+					sizeof(format->name));
+			format->fcc = V4L2_PIX_FMT_VP8_SIMULCAST;
+			streaming->num_layers = UVC_SIMULCAST_MAX_LAYERS;
+			format->flags |= UVC_FMT_FLAG_SIMULCAST;
+		}
 
 		break;
 
@@ -635,6 +644,12 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	streaming->dev = dev;
 	streaming->intf = usb_get_intf(intf);
 	streaming->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
+	streaming->num_layers = 1;
+	atomic_set(&dev->num_vdevs, 0);
+	streaming->streaming_layers = 0;
+	streaming->allocated_layers = 0;
+	for (i = 0; i < UVC_SIMULCAST_MAX_LAYERS; ++i)
+		streaming->layers[i].layer_id = i;
 
 	/* The Pico iMage webcam has its class-specific interface descriptors
 	 * after the endpoint descriptors.
@@ -731,6 +746,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		case UVC_VS_FORMAT_MJPEG:
 		case UVC_VS_FORMAT_FRAME_BASED:
 		case UVC_VS_FORMAT_VP8:
+		case UVC_VS_FORMAT_VP8_SIMULCAST:
 			nformats++;
 			break;
 
@@ -804,6 +820,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		case UVC_VS_FORMAT_DV:
 		case UVC_VS_FORMAT_FRAME_BASED:
 		case UVC_VS_FORMAT_VP8:
+		case UVC_VS_FORMAT_VP8_SIMULCAST:
 			format->frame = frame;
 			ret = uvc_parse_format(dev, streaming, format,
 				&interval, buffer, buflen);
@@ -1732,6 +1749,7 @@ static int uvc_scan_device(struct uvc_device *dev)
 static void uvc_delete(struct uvc_device *dev)
 {
 	struct list_head *p, *n;
+	int i;
 
 	usb_put_intf(dev->intf);
 	usb_put_dev(dev->udev);
@@ -1760,16 +1778,17 @@ static void uvc_delete(struct uvc_device *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 		uvc_mc_cleanup_entity(entity);
 #endif
-		if (entity->vdev) {
-			video_device_release(entity->vdev);
-			entity->vdev = NULL;
-		}
 		kfree(entity);
 	}
 
 	list_for_each_safe(p, n, &dev->streams) {
 		struct uvc_streaming *streaming;
 		streaming = list_entry(p, struct uvc_streaming, list);
+		for (i = 0; i < streaming->num_layers; ++i) {
+			if (streaming->vdev[i])
+				video_device_release(streaming->vdev[i]);
+			streaming->vdev[i] = NULL;
+		}
 		usb_driver_release_interface(&uvc_driver.driver,
 			streaming->intf);
 		usb_put_intf(streaming->intf);
@@ -1783,13 +1802,13 @@ static void uvc_delete(struct uvc_device *dev)
 
 static void uvc_release(struct video_device *vdev)
 {
-	struct uvc_streaming *stream = video_get_drvdata(vdev);
-	struct uvc_device *dev = stream->dev;
+	struct uvc_stream_layer *layer = video_get_drvdata(vdev);
+	struct uvc_device *dev = layer->stream->dev;
 
-	/* Decrement the registered streams count and delete the device when it
+	/* Decrement the registered vdevs count and delete the device when it
 	 * reaches zero.
 	 */
-	if (atomic_dec_and_test(&dev->nstreams))
+	if (atomic_dec_and_test(&dev->num_vdevs))
 		uvc_delete(dev);
 }
 
@@ -1799,20 +1818,23 @@ static void uvc_release(struct video_device *vdev)
 static void uvc_unregister_video(struct uvc_device *dev)
 {
 	struct uvc_streaming *stream;
+	int i;
 
 	/* Unregistering all video devices might result in uvc_delete() being
 	 * called from inside the loop if there's no open file handle. To avoid
-	 * that, increment the stream count before iterating over the streams
+	 * that, increment the vdevs count before iterating over the vdevs
 	 * and decrement it when done.
 	 */
-	atomic_inc(&dev->nstreams);
+	atomic_inc(&dev->num_vdevs);
 
 	list_for_each_entry(stream, &dev->streams, list) {
-		if (stream->vdev == NULL)
-			continue;
+		for (i = 0; i < stream->num_layers; ++i) {
+			if (stream->vdev[i] == NULL)
+				continue;
 
-		video_unregister_device(stream->vdev);
-		stream->vdev = NULL;
+			video_unregister_device(stream->vdev[i]);
+			stream->vdev[i] = NULL;
+		}
 
 		uvc_debugfs_cleanup_stream(stream);
 	}
@@ -1820,7 +1842,7 @@ static void uvc_unregister_video(struct uvc_device *dev)
 	/* Decrement the stream count and call uvc_delete explicitly if there
 	 * are no stream left.
 	 */
-	if (atomic_dec_and_test(&dev->nstreams))
+	if (atomic_dec_and_test(&dev->num_vdevs))
 		uvc_delete(dev);
 }
 
@@ -1828,7 +1850,9 @@ static int uvc_register_video(struct uvc_device *dev,
 		struct uvc_streaming *stream)
 {
 	struct video_device *vdev;
+	struct uvc_stream_layer *layer;
 	int ret;
+	int i;
 
 	/* Initialize the streaming interface with default streaming
 	 * parameters.
@@ -1843,39 +1867,60 @@ static int uvc_register_video(struct uvc_device *dev,
 	uvc_debugfs_init_stream(stream);
 
 	/* Register the device with V4L. */
-	vdev = video_device_alloc();
-	if (vdev == NULL) {
-		uvc_printk(KERN_ERR, "Failed to allocate video device (%d).\n",
-			   ret);
-		return -ENOMEM;
-	}
+	for (i = 0; i < stream->num_layers; ++i) {
+		/* Register the device with V4L. */
+		vdev = video_device_alloc();
+		if (vdev == NULL) {
+			uvc_printk(KERN_ERR,
+				"Failed to allocate video device (%d).\n", ret);
+			return -ENOMEM;
+		}
 
-	/* We already hold a reference to dev->udev. The video device will be
-	 * unregistered before the reference is released, so we don't need to
-	 * get another one.
-	 */
-	vdev->v4l2_dev = &dev->vdev;
-	vdev->fops = &uvc_fops;
-	vdev->release = uvc_release;
-	vdev->prio = &stream->chain->prio;
-	set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
-	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
-		vdev->vfl_dir = VFL_DIR_TX;
-	strlcpy(vdev->name, dev->name, sizeof vdev->name);
-
-	/* Set the driver data before calling video_register_device, otherwise
-	 * uvc_v4l2_open might race us.
-	 */
-	stream->vdev = vdev;
-	video_set_drvdata(vdev, stream);
+		/* We already hold a reference to dev->udev. The video device
+		 * will be unregistered before the reference is released,
+		 * so we don't need to get another one.
+		 */
+		vdev->v4l2_dev = &dev->vdev;
+		vdev->fops = &uvc_fops;
+		vdev->release = uvc_release;
+		vdev->prio = &stream->chain->prio;
+		set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
+		if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			vdev->vfl_dir = VFL_DIR_TX;
+		strlcpy(vdev->name, dev->name, sizeof(vdev->name));
+
+		/* Set the driver data before calling video_register_device,
+		 * otherwise uvc_v4l2_open might race us.
+		 */
+		stream->vdev[i] = vdev;
+		layer = &stream->layers[i];
+		layer->layer_id = i;
+		layer->stream = stream;
+		uvc_video_layer_get_resolution(layer);
+		atomic_set(&layer->active, 0);
+		video_set_drvdata(vdev, layer);
+		ret = uvc_queue_init(&layer->queue, stream->type,
+					!uvc_no_drop_param, stream);
+		if (ret < 0) {
+			uvc_printk(KERN_ERR,
+				"Failed to initialize video queue.\n");
+			stream->vdev[i] = NULL;
+			video_device_release(vdev);
+			return ret;
+		}
 
-	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
-	if (ret < 0) {
-		uvc_printk(KERN_ERR, "Failed to register video device (%d).\n",
-			   ret);
-		stream->vdev = NULL;
-		video_device_release(vdev);
-		return ret;
+		ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+		if (ret < 0) {
+			uvc_printk(KERN_ERR,
+				"Failed to register video device (%d).\n", ret);
+			stream->vdev[i] = NULL;
+			video_device_release(vdev);
+			return ret;
+		}
+
+		atomic_inc(&dev->num_vdevs);
+		uvc_trace(UVC_TRACE_PROBE,
+			"Registered video device /dev/video%d\n", vdev->minor);
 	}
 
 	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -1883,7 +1928,6 @@ static int uvc_register_video(struct uvc_device *dev,
 	else
 		stream->chain->caps |= V4L2_CAP_VIDEO_OUTPUT;
 
-	atomic_inc(&dev->nstreams);
 	return 0;
 }
 
@@ -1897,6 +1941,7 @@ static int uvc_register_terms(struct uvc_device *dev,
 	struct uvc_entity *term;
 	struct uvc_chain_entry *entry;
 	int ret;
+	int i;
 
 	list_for_each_entry(entry, &chain->entities, chain_entry) {
 		term = entry->entity;
@@ -1915,7 +1960,8 @@ static int uvc_register_terms(struct uvc_device *dev,
 		if (ret < 0)
 			return ret;
 
-		term->vdev = stream->vdev;
+		for (i = 0; i < stream->num_layers; ++i)
+			term->vdev[i] = stream->vdev[i];
 	}
 
 	return 0;
@@ -1924,9 +1970,30 @@ static int uvc_register_terms(struct uvc_device *dev,
 static int uvc_register_chains(struct uvc_device *dev)
 {
 	struct uvc_video_chain *chain;
+	struct uvc_control *ctrl;
 	int ret;
+	int i;
 
 	list_for_each_entry(chain, &dev->chains, list) {
+		if (chain->encoding) {
+			for (i = 0; i < chain->encoding->ncontrols; ++i) {
+				ctrl = &chain->encoding->controls[i];
+				if (!ctrl->initialized)
+					continue;
+				switch (ctrl->info.selector) {
+				case UVC_EU_SELECT_LAYER_CONTROL:
+					chain->layer_ctrl = ctrl;
+					break;
+				case UVC_EU_VIDEO_RESOLUTION_CONTROL:
+					chain->res_ctrl = ctrl;
+					break;
+				case UVC_EU_START_OR_STOP_LAYER_CONTROL:
+					chain->startstop_ctrl = ctrl;
+					break;
+				}
+			}
+		}
+
 		ret = uvc_register_terms(dev, chain);
 		if (ret < 0)
 			return ret;
@@ -1934,7 +2001,7 @@ static int uvc_register_chains(struct uvc_device *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 		ret = uvc_mc_register_entities(chain);
 		if (ret < 0) {
-			uvc_printk(KERN_INFO, "Failed to register entites "
+			uvc_printk(KERN_INFO, "Failed to register entities "
 				"(%d).\n", ret);
 		}
 #endif
@@ -1954,13 +2021,14 @@ static int uvc_probe(struct usb_interface *intf,
 	struct uvc_device *dev;
 	int ret;
 
-	if (id->idVendor && id->idProduct)
+	if (id->idVendor && id->idProduct) {
 		uvc_trace(UVC_TRACE_PROBE, "Probing known UVC device %s "
 				"(%04x:%04x)\n", udev->devpath, id->idVendor,
 				id->idProduct);
-	else
+	} else {
 		uvc_trace(UVC_TRACE_PROBE, "Probing generic UVC device %s\n",
 				udev->devpath);
+	}
 
 	/* Allocate memory for the device and initialize it. */
 	if ((dev = kzalloc(sizeof *dev, GFP_KERNEL)) == NULL)
@@ -1969,7 +2037,7 @@ static int uvc_probe(struct usb_interface *intf,
 	INIT_LIST_HEAD(&dev->entities);
 	INIT_LIST_HEAD(&dev->chains);
 	INIT_LIST_HEAD(&dev->streams);
-	atomic_set(&dev->nstreams, 0);
+	atomic_set(&dev->num_vdevs, 0);
 	atomic_set(&dev->nmappings, 0);
 	mutex_init(&dev->lock);
 
diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index 657f49a..e1a4afc 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -23,20 +23,13 @@
  * Video subdevices registration and unregistration
  */
 
-static int uvc_mc_register_entity(struct uvc_video_chain *chain,
-	struct uvc_entity *entity)
+static int uvc_mc_register_media_entity(struct uvc_entity *entity,
+					struct media_entity *sink)
 {
 	const u32 flags = MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE;
-	struct media_entity *sink;
 	unsigned int i;
 	int ret;
 
-	sink = (UVC_ENTITY_TYPE(entity) == UVC_TT_STREAMING)
-	     ? (entity->vdev ? &entity->vdev->entity : NULL)
-	     : &entity->subdev.entity;
-	if (sink == NULL)
-		return 0;
-
 	for (i = 0; i < entity->num_pads; ++i) {
 		struct media_entity *source;
 		struct uvc_entity *remote;
@@ -45,12 +38,17 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
 		if (!(entity->pads[i].flags & MEDIA_PAD_FL_SINK))
 			continue;
 
-		remote = uvc_entity_by_id(chain->dev, entity->baSourceID[i]);
+		remote = uvc_entity_by_id(entity->chain->dev,
+						entity->baSourceID[i]);
 		if (remote == NULL)
 			return -EINVAL;
 
+		/*
+		 * Take vdev[0], because it has to be an ITERM to be a source
+		 * and we don't create more than 1 vdev for those.
+		 */
 		source = (UVC_ENTITY_TYPE(remote) == UVC_TT_STREAMING)
-		       ? (remote->vdev ? &remote->vdev->entity : NULL)
+		       ? (remote->vdev[0] ? &remote->vdev[0]->entity : NULL)
 		       : &remote->subdev.entity;
 		if (source == NULL)
 			continue;
@@ -62,10 +60,36 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
 			return ret;
 	}
 
-	if (UVC_ENTITY_TYPE(entity) == UVC_TT_STREAMING)
-		return 0;
+	return 0;
+}
 
-	return v4l2_device_register_subdev(&chain->dev->vdev, &entity->subdev);
+static int uvc_mc_register_entity(struct uvc_video_chain *chain,
+					struct uvc_entity *entity)
+{
+	struct media_entity *mentity;
+	int ret = 0;
+	int i;
+
+	if (UVC_ENTITY_TYPE(entity) == UVC_TT_STREAMING) {
+		for (i = 0; i < UVC_SIMULCAST_MAX_LAYERS; ++i) {
+			if (entity->vdev[i]) {
+				mentity = &entity->vdev[i]->entity;
+				ret = uvc_mc_register_media_entity(entity,
+								   mentity);
+				if (ret < 0)
+					return ret;
+			}
+		}
+	} else {
+		mentity = &entity->subdev.entity;
+		ret = uvc_mc_register_media_entity(entity, mentity);
+		if (ret < 0)
+			return ret;
+		ret = v4l2_device_register_subdev(&chain->dev->vdev,
+						  &entity->subdev);
+	}
+
+	return ret;
 }
 
 static struct v4l2_subdev_ops uvc_subdev_ops = {
@@ -73,15 +97,26 @@ static struct v4l2_subdev_ops uvc_subdev_ops = {
 
 void uvc_mc_cleanup_entity(struct uvc_entity *entity)
 {
-	if (UVC_ENTITY_TYPE(entity) != UVC_TT_STREAMING)
+	int i;
+
+	if (UVC_ENTITY_TYPE(entity) != UVC_TT_STREAMING) {
 		media_entity_cleanup(&entity->subdev.entity);
-	else if (entity->vdev != NULL)
-		media_entity_cleanup(&entity->vdev->entity);
+	} else {
+		for (i = 0; i < UVC_SIMULCAST_MAX_LAYERS; ++i) {
+			if (entity->vdev[i] != NULL)
+				media_entity_cleanup(&entity->vdev[i]->entity);
+		}
+	}
+
+	entity->registered = false;
 }
 
 static int uvc_mc_init_entity(struct uvc_entity *entity)
 {
-	int ret;
+	struct media_pad *pads;
+	struct device *dev = &entity->chain->dev->udev->dev;
+	int ret = 0;
+	int i;
 
 	if (UVC_ENTITY_TYPE(entity) != UVC_TT_STREAMING) {
 		v4l2_subdev_init(&entity->subdev, &uvc_subdev_ops);
@@ -90,13 +125,42 @@ static int uvc_mc_init_entity(struct uvc_entity *entity)
 
 		ret = media_entity_init(&entity->subdev.entity,
 					entity->num_pads, entity->pads, 0);
-	} else if (entity->vdev != NULL) {
-		ret = media_entity_init(&entity->vdev->entity,
-					entity->num_pads, entity->pads, 0);
-		if (entity->flags & UVC_ENTITY_FLAG_DEFAULT)
-			entity->vdev->entity.flags |= MEDIA_ENT_FL_DEFAULT;
-	} else
-		ret = 0;
+	} else {
+		for (i = 0; i < UVC_SIMULCAST_MAX_LAYERS; ++i) {
+			if (entity->vdev[i] != NULL) {
+				/*
+				 * As we may have multiple media entities
+				 * (vdevs) per one STREAMING UVC entity in
+				 * simulcast situations, we have separate memory
+				 * allocated for pads for each media entity
+				 * to have its own.
+				 */
+				pads = devm_kzalloc(dev,
+					sizeof(*pads) * entity->num_pads,
+					GFP_KERNEL);
+				if (!pads) {
+					ret = -ENOMEM;
+					goto cleanup;
+				}
+				memcpy(pads, entity->pads,
+					sizeof(*pads) * entity->num_pads);
+
+				ret = media_entity_init(
+					&entity->vdev[i]->entity,
+					entity->num_pads, pads, 0);
+				if (ret)
+					goto cleanup;
+			}
+		}
+	}
+
+	return ret;
+
+cleanup:
+	for (i = i - 1; i >= 0; ++i) {
+		if (entity->vdev[i] != NULL)
+			media_entity_cleanup(&entity->vdev[i]->entity);
+	}
 
 	return ret;
 }
diff --git a/drivers/media/usb/uvc/uvc_isight.c b/drivers/media/usb/uvc/uvc_isight.c
index ab01286..c105dd7 100644
--- a/drivers/media/usb/uvc/uvc_isight.c
+++ b/drivers/media/usb/uvc/uvc_isight.c
@@ -103,8 +103,9 @@ void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream)
 {
 	int ret, i;
 	struct uvc_buffer *buf;
+	struct uvc_video_queue *queue = &stream->layers[0].queue;
 
-	buf = uvc_queue_get_first_buf(&stream->queue);
+	buf = uvc_queue_get_first_buf(queue);
 
 	for (i = 0; i < urb->number_of_packets; ++i) {
 		if (urb->iso_frame_desc[i].status < 0) {
@@ -122,7 +123,7 @@ void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream)
 		 * processes the data of the first payload of the new frame.
 		 */
 		do {
-			ret = isight_decode(&stream->queue, buf,
+			ret = isight_decode(queue, buf,
 					urb->transfer_buffer +
 					urb->iso_frame_desc[i].offset,
 					urb->iso_frame_desc[i].actual_length);
@@ -132,8 +133,7 @@ void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream)
 
 			if (buf->state == UVC_BUF_STATE_DONE ||
 			    buf->state == UVC_BUF_STATE_ERROR)
-				buf = uvc_queue_next_buffer(&stream->queue,
-							buf);
+				buf = uvc_queue_next_buffer(queue, buf);
 		} while (ret == -EAGAIN);
 	}
 }
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 55d2670..379e994 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -45,15 +45,13 @@ static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
-	struct uvc_streaming *stream =
-			container_of(queue, struct uvc_streaming, queue);
 
 	if (*nbuffers > UVC_MAX_VIDEO_BUFFERS)
 		*nbuffers = UVC_MAX_VIDEO_BUFFERS;
 
 	*nplanes = 1;
 
-	sizes[0] = stream->ctrl.dwMaxVideoFrameSize;
+	sizes[0] = queue->stream->ctrl.dwMaxVideoFrameSize;
 
 	return 0;
 }
@@ -107,11 +105,9 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 static int uvc_buffer_finish(struct vb2_buffer *vb)
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
-	struct uvc_streaming *stream =
-			container_of(queue, struct uvc_streaming, queue);
 	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
 
-	uvc_video_clock_update(stream, &vb->v4l2_buf, buf);
+	uvc_video_clock_update(queue->stream, &vb->v4l2_buf, buf);
 	return 0;
 }
 
@@ -139,7 +135,7 @@ static struct vb2_ops uvc_queue_qops = {
 };
 
 int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
-		    int drop_corrupted)
+		    int drop_corrupted, struct uvc_streaming *stream)
 {
 	int ret;
 
@@ -158,6 +154,7 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 	spin_lock_init(&queue->irqlock);
 	INIT_LIST_HEAD(&queue->irqqueue);
 	queue->flags = drop_corrupted ? UVC_QUEUE_DROP_CORRUPTED : 0;
+	queue->stream = stream;
 
 	return 0;
 }
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index decd65f..dbbe93b 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -143,12 +143,63 @@ static __u32 uvc_try_frame_interval(struct uvc_frame *frame, __u32 interval)
 	return interval;
 }
 
+static void uvc_init_vp8_probe_features(struct v4l2_format *fmt,
+		struct uvc_streaming *stream, struct uvc_frame *frame,
+		struct uvc_streaming_control *probe)
+{
+	int i;
+	__u16 layout = 0;
+	int num_streams;
+	int num_temprl_layers;
+
+	for (i = 0; i < UVC_NUM_SIMULCAST_STREAMS; ++i)
+		probe->bmLayoutPerStream[i] = 0;
+
+	/* Values to request in P&C. */
+	num_streams = fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_VP8 ?
+			1 : stream->num_layers;
+
+	if (frame->bmSupportedUsages
+			& UVC_FRM_VP8_USAGE_REAL_TIME_TEMPORAL_LAYERS) {
+		/* Temporal layering supported, specify config for each
+		 * temporal layer for each stream.
+		 */
+		probe->bUsage = 2;
+		num_temprl_layers = frame->bmScalabilityCapabilities + 1;
+		num_temprl_layers = clamp(num_temprl_layers, 1,
+						UVC_VP8_MAX_TEMPORAL_LAYERS);
+
+		/* Allow all special frames for all temporal layers. */
+		for (i = 0; i < num_temprl_layers; ++i)
+			layout |= UVC_VP8_TEMPORAL_LAYOUT_WILDCARD_LAYER(i);
+		layout |= UVC_VP8_TEMPRL_LAYOUT_NUM(num_temprl_layers);
+		/* Stream enable */
+		layout |= 0x1;
+
+	} else if (frame->bmSupportedUsages & UVC_FRM_VP8_USAGE_REAL_TIME) {
+		probe->bUsage = 1;
+		/* Stream enable */
+		layout = 0x1;
+
+	} else {
+		/* Let the device decide. */
+		probe->bUsage = 0;
+		return;
+	}
+
+	for (i = 0; i < num_streams; ++i)
+		probe->bmLayoutPerStream[i] = layout;
+
+	probe->bmRateControlModes = 0x1111;
+}
+
 static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 	struct v4l2_format *fmt, struct uvc_streaming_control *probe,
 	struct uvc_format **uvc_format, struct uvc_frame **uvc_frame)
 {
 	struct uvc_format *format = NULL;
 	struct uvc_frame *frame = NULL;
+	struct uvc_frame *simulcast_frame = NULL;
 	__u16 rw, rh;
 	unsigned int d, maxd;
 	unsigned int i;
@@ -218,7 +269,26 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 	memset(probe, 0, sizeof *probe);
 	probe->bmHint = 1;	/* dwFrameInterval */
 	probe->bFormatIndex = format->index;
-	probe->bFrameIndex = frame->bFrameIndex;
+	/*
+	 * If we are doing simulcast, we'd like to select the highest possible
+	 * resolution available and then scale down and back up as needed
+	 * via set resolution EU control.
+	 */
+	if (fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_VP8_SIMULCAST) {
+		/* TODO: resolution-framerate tradeoff negotiation logic
+		 * for simulcast would be nice to have. */
+		simulcast_frame = &format->frame[0];
+		for (i = 0; i < format->nframes; ++i) {
+			if (format->frame[i].wWidth > simulcast_frame->wWidth)
+				simulcast_frame = &format->frame[i];
+		}
+		uvc_trace(UVC_TRACE_FORMAT, "Selected %dx%d max resolution "
+				"for simulcast\n", simulcast_frame->wWidth,
+				simulcast_frame->wHeight);
+		probe->bFrameIndex = simulcast_frame->bFrameIndex;
+	} else {
+		probe->bFrameIndex = frame->bFrameIndex;
+	}
 	probe->dwFrameInterval = uvc_try_frame_interval(frame, interval);
 	/* Some webcams stall the probe control set request when the
 	 * dwMaxVideoFrameSize field is set to zero. The UVC specification
@@ -237,6 +307,12 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 		probe->dwMaxVideoFrameSize =
 			stream->ctrl.dwMaxVideoFrameSize;
 
+	/* UVC 1.5 features */
+	if (uvc_get_probe_ctrl_size(stream) > 34
+		&& (fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_VP8
+		|| fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_VP8_SIMULCAST))
+			uvc_init_vp8_probe_features(fmt, stream, frame, probe);
+
 	/* Probe the device. */
 	ret = uvc_probe_video(stream, probe);
 	mutex_unlock(&stream->mutex);
@@ -260,11 +336,12 @@ done:
 	return ret;
 }
 
-static int uvc_v4l2_get_format(struct uvc_streaming *stream,
-	struct v4l2_format *fmt)
+static int uvc_v4l2_get_format(struct uvc_stream_layer *layer,
+				struct v4l2_format *fmt)
 {
 	struct uvc_format *format;
 	struct uvc_frame *frame;
+	struct uvc_streaming *stream = layer->stream;
 	int ret = 0;
 
 	if (fmt->type != stream->type)
@@ -280,8 +357,11 @@ static int uvc_v4l2_get_format(struct uvc_streaming *stream,
 	}
 
 	fmt->fmt.pix.pixelformat = format->fcc;
-	fmt->fmt.pix.width = frame->wWidth;
-	fmt->fmt.pix.height = frame->wHeight;
+	ret = uvc_video_layer_get_resolution(layer);
+	if (ret)
+		goto done;
+	fmt->fmt.pix.width = layer->width;
+	fmt->fmt.pix.height = layer->height;
 	fmt->fmt.pix.field = V4L2_FIELD_NONE;
 	fmt->fmt.pix.bytesperline = format->bpp * frame->wWidth / 8;
 	fmt->fmt.pix.sizeimage = stream->ctrl.dwMaxVideoFrameSize;
@@ -293,13 +373,15 @@ done:
 	return ret;
 }
 
-static int uvc_v4l2_set_format(struct uvc_streaming *stream,
-	struct v4l2_format *fmt)
+static int uvc_v4l2_set_format(struct uvc_stream_layer *layer,
+				struct v4l2_format *fmt)
 {
 	struct uvc_streaming_control probe;
 	struct uvc_format *format;
 	struct uvc_frame *frame;
+	struct uvc_streaming *stream = layer->stream;
 	int ret;
+	int i;
 
 	if (fmt->type != stream->type)
 		return -EINVAL;
@@ -309,18 +391,50 @@ static int uvc_v4l2_set_format(struct uvc_streaming *stream,
 		return ret;
 
 	mutex_lock(&stream->mutex);
+	if (stream->allocated_layers == 0) {
+		/* No queue has yet allocated buffers, so we can
+		 * set format via a commit.
+		 */
+		stream->ctrl = probe;
+		uvc_update_stream_format(stream, format, frame);
 
-	if (uvc_queue_allocated(&stream->queue)) {
-		ret = -EBUSY;
-		goto done;
-	}
+		/* Commit the streaming parameters. */
+		ret = uvc_commit_video(stream, &stream->ctrl);
+		if (ret < 0) {
+			uvc_trace(UVC_TRACE_FORMAT,
+					"Failed committing video\n");
+			goto end;
+		}
 
-	stream->ctrl = probe;
-	stream->cur_format = format;
-	stream->cur_frame = frame;
+		if (uvc_is_simulcasting(stream)) {
+			ret = uvc_video_layer_set_resolution(layer,
+				fmt->fmt.pix.width, fmt->fmt.pix.height);
+			if (ret)
+				goto end;
+			for (i = 0; i < stream->num_negotiated_layers; ++i) {
+				uvc_video_layer_get_resolution(
+							&stream->layers[i]);
+			}
+		}
+	} else {
+		/* At least one queue has already allocated buffers, so we
+		 * can only change resolution and only if simulcasting.
+		 */
+		if (fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_VP8_SIMULCAST
+		    && fmt->fmt.pix.pixelformat == stream->cur_format->fcc) {
+			ret = uvc_video_layer_set_resolution(layer,
+				fmt->fmt.pix.width, fmt->fmt.pix.height);
+		} else {
+			uvc_trace(UVC_TRACE_FORMAT, "Cannot change format, "
+					"already initialized/streaming.\n");
+			ret = -EBUSY;
+		}
+	}
 
-done:
+end:
 	mutex_unlock(&stream->mutex);
+	if (ret < 0)
+		uvc_trace(UVC_TRACE_FORMAT, "Failed setting format\n");
 	return ret;
 }
 
@@ -382,7 +496,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 
 	mutex_lock(&stream->mutex);
 
-	if (uvc_queue_streaming(&stream->queue)) {
+	if (stream->allocated_layers != 0) {
 		mutex_unlock(&stream->mutex);
 		return -EBUSY;
 	}
@@ -399,8 +513,15 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 	}
 
 	stream->ctrl = probe;
+
+	ret = uvc_commit_video(stream, &stream->ctrl);
 	mutex_unlock(&stream->mutex);
 
+	if (ret < 0) {
+		uvc_trace(UVC_TRACE_FORMAT, "Failed committing video\n");
+		return ret;
+	}
+
 	/* Return the actual frame period. */
 	timeperframe.numerator = probe.dwFrameInterval;
 	timeperframe.denominator = 10000000;
@@ -449,8 +570,8 @@ static int uvc_acquire_privileges(struct uvc_fh *handle)
 		return 0;
 
 	/* Check if the device already has a privileged handle. */
-	if (atomic_inc_return(&handle->stream->active) != 1) {
-		atomic_dec(&handle->stream->active);
+	if (atomic_inc_return(&handle->layer->active) != 1) {
+		atomic_dec(&handle->layer->active);
 		return -EBUSY;
 	}
 
@@ -461,7 +582,7 @@ static int uvc_acquire_privileges(struct uvc_fh *handle)
 static void uvc_dismiss_privileges(struct uvc_fh *handle)
 {
 	if (handle->state == UVC_HANDLE_ACTIVE)
-		atomic_dec(&handle->stream->active);
+		atomic_dec(&handle->layer->active);
 
 	handle->state = UVC_HANDLE_PASSIVE;
 }
@@ -478,11 +599,16 @@ static int uvc_has_privileges(struct uvc_fh *handle)
 static int uvc_v4l2_open(struct file *file)
 {
 	struct uvc_streaming *stream;
+	struct uvc_stream_layer *layer;
 	struct uvc_fh *handle;
 	int ret = 0;
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_open\n");
-	stream = video_drvdata(file);
+	layer = video_drvdata(file);
+	WARN_ON(!layer);
+	stream = layer->stream;
+	WARN_ON(!stream);
+	WARN_ON(!stream->dev);
 
 	if (stream->dev->state & UVC_DEV_DISCONNECTED)
 		return -ENODEV;
@@ -512,10 +638,10 @@ static int uvc_v4l2_open(struct file *file)
 	stream->dev->users++;
 	mutex_unlock(&stream->dev->lock);
 
-	v4l2_fh_init(&handle->vfh, stream->vdev);
+	v4l2_fh_init(&handle->vfh, stream->vdev[layer->layer_id]);
 	v4l2_fh_add(&handle->vfh);
 	handle->chain = stream->chain;
-	handle->stream = stream;
+	handle->layer = layer;
 	handle->state = UVC_HANDLE_PASSIVE;
 	file->private_data = handle;
 
@@ -525,14 +651,19 @@ static int uvc_v4l2_open(struct file *file)
 static int uvc_v4l2_release(struct file *file)
 {
 	struct uvc_fh *handle = file->private_data;
-	struct uvc_streaming *stream = handle->stream;
+	struct uvc_streaming *stream = handle->layer->stream;
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_release\n");
 
 	/* Only free resources if this is a privileged handle. */
 	if (uvc_has_privileges(handle)) {
-		uvc_video_enable(stream, 0);
-		uvc_free_buffers(&stream->queue);
+		mutex_lock(&stream->mutex);
+
+		uvc_video_layer_disable(handle->layer);
+		clear_bit(handle->layer->layer_id, &stream->allocated_layers);
+
+		mutex_unlock(&stream->mutex);
+		uvc_free_buffers(&handle->layer->queue);
 	}
 
 	/* Release the file handle. */
@@ -556,7 +687,7 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	struct video_device *vdev = video_devdata(file);
 	struct uvc_fh *handle = file->private_data;
 	struct uvc_video_chain *chain = handle->chain;
-	struct uvc_streaming *stream = handle->stream;
+	struct uvc_streaming *stream = handle->layer->stream;
 	long ret = 0;
 
 	switch (cmd) {
@@ -612,6 +743,12 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (ret < 0)
 			return ret;
 
+		ret = __uvc_video_layer_select(handle->layer, 0);
+		if (ret < 0) {
+			uvc_ctrl_rollback(handle);
+			return ret;
+		}
+
 		ret = uvc_ctrl_get(chain, &xctrl,
 					uvc_is_stream_streaming(stream));
 		uvc_ctrl_rollback(handle);
@@ -637,6 +774,13 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (ret < 0)
 			return ret;
 
+		/* Apply to all temporal layers. */
+		ret = __uvc_video_layer_select(handle->layer, 0x7);
+		if (ret < 0) {
+			uvc_ctrl_rollback(handle);
+			return ret;
+		}
+
 		ret = uvc_ctrl_set(chain, &xctrl,
 					uvc_is_stream_streaming(stream));
 		if (ret < 0) {
@@ -663,6 +807,13 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (ret < 0)
 			return ret;
 
+		ret = __uvc_video_layer_select(handle->layer,
+						ctrls->reserved[0]);
+		if (ret < 0) {
+			uvc_ctrl_rollback(handle);
+			return ret;
+		}
+
 		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
 			ret = uvc_ctrl_get(chain, ctrl,
 					uvc_is_stream_streaming(stream));
@@ -692,6 +843,13 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (ret < 0)
 			return ret;
 
+		ret = __uvc_video_layer_select(handle->layer,
+						ctrls->reserved[0]);
+		if (ret < 0) {
+			uvc_ctrl_rollback(handle);
+			return ret;
+		}
+
 		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
 			ret = uvc_ctrl_set(chain, ctrl,
 					uvc_is_stream_streaming(stream));
@@ -845,10 +1003,10 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if ((ret = uvc_acquire_privileges(handle)) < 0)
 			return ret;
 
-		return uvc_v4l2_set_format(stream, arg);
+		return uvc_v4l2_set_format(handle->layer, arg);
 
 	case VIDIOC_G_FMT:
-		return uvc_v4l2_get_format(stream, arg);
+		return uvc_v4l2_get_format(handle->layer, arg);
 
 	/* Frame size enumeration */
 	case VIDIOC_ENUM_FRAMESIZES:
@@ -990,15 +1148,18 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			return ret;
 
 		mutex_lock(&stream->mutex);
-		ret = uvc_alloc_buffers(&stream->queue, arg);
-		mutex_unlock(&stream->mutex);
-		if (ret < 0)
-			return ret;
-
-		if (ret == 0)
+		ret = uvc_alloc_buffers(&handle->layer->queue, arg);
+		if (ret > 0) {
+			set_bit(handle->layer->layer_id,
+				&stream->allocated_layers);
+			ret = 0;
+		} else if (ret == 0) {
+			clear_bit(handle->layer->layer_id,
+					&stream->allocated_layers);
 			uvc_dismiss_privileges(handle);
+		}
+		mutex_unlock(&stream->mutex);
 
-		ret = 0;
 		break;
 
 	case VIDIOC_QUERYBUF:
@@ -1008,20 +1169,20 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
 
-		return uvc_query_buffer(&stream->queue, buf);
+		return uvc_query_buffer(&handle->layer->queue, buf);
 	}
 
 	case VIDIOC_QBUF:
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
 
-		return uvc_queue_buffer(&stream->queue, arg);
+		return uvc_queue_buffer(&handle->layer->queue, arg);
 
 	case VIDIOC_DQBUF:
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
 
-		return uvc_dequeue_buffer(&stream->queue, arg,
+		return uvc_dequeue_buffer(&handle->layer->queue, arg,
 			file->f_flags & O_NONBLOCK);
 
 	case VIDIOC_STREAMON:
@@ -1039,10 +1200,9 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			return -EBUSY;
 
 		mutex_lock(&stream->mutex);
-		ret = uvc_video_enable(stream, 1);
+		ret = uvc_video_layer_enable(handle->layer);
 		mutex_unlock(&stream->mutex);
-		if (ret < 0)
-			return ret;
+
 		break;
 	}
 
@@ -1060,7 +1220,11 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
 
-		return uvc_video_enable(stream, 0);
+		mutex_lock(&stream->mutex);
+		uvc_video_layer_disable(handle->layer);
+		mutex_unlock(&stream->mutex);
+
+		break;
 	}
 
 	case VIDIOC_SUBSCRIBE_EVENT:
@@ -1334,21 +1498,19 @@ static ssize_t uvc_v4l2_read(struct file *file, char __user *data,
 static int uvc_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct uvc_fh *handle = file->private_data;
-	struct uvc_streaming *stream = handle->stream;
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_mmap\n");
 
-	return uvc_queue_mmap(&stream->queue, vma);
+	return uvc_queue_mmap(&handle->layer->queue, vma);
 }
 
 static unsigned int uvc_v4l2_poll(struct file *file, poll_table *wait)
 {
 	struct uvc_fh *handle = file->private_data;
-	struct uvc_streaming *stream = handle->stream;
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_poll\n");
 
-	return uvc_queue_poll(&stream->queue, file, wait);
+	return uvc_queue_poll(&handle->layer->queue, file, wait);
 }
 
 #ifndef CONFIG_MMU
@@ -1357,11 +1519,10 @@ static unsigned long uvc_v4l2_get_unmapped_area(struct file *file,
 		unsigned long flags)
 {
 	struct uvc_fh *handle = file->private_data;
-	struct uvc_streaming *stream = handle->stream;
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_get_unmapped_area\n");
 
-	return uvc_queue_get_unmapped_area(&stream->queue, pgoff);
+	return uvc_queue_get_unmapped_area(&handle->layer->queue, pgoff);
 }
 #endif
 
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 0291817..2d1ed2e 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -344,6 +344,14 @@ static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 		ret = 0;
 	}
 
+	/* Set EU control streaming state for each layer. */
+	if (uvc_is_eu_active(stream)) {
+		for (i = 0; i < stream->num_negotiated_layers; ++i) {
+			uvc_ctrl_layer_enable(&stream->layers[i],
+				 !!test_bit(i, &stream->streaming_layers));
+		}
+	}
+
 	kfree(data);
 	return ret;
 }
@@ -404,13 +412,17 @@ int uvc_probe_video(struct uvc_streaming *stream,
 		probe->wPFrameRate = probe_min.wPFrameRate;
 		probe->wCompQuality = probe_max.wCompQuality;
 		probe->wCompWindowSize = probe_min.wCompWindowSize;
+
+		/* TODO: negotiate bmLayoutPerStream for simulcast if
+		 * adjusted by the camera.
+		 */
 	}
 
 done:
 	return ret;
 }
 
-static int uvc_commit_video(struct uvc_streaming *stream,
+int uvc_commit_video(struct uvc_streaming *stream,
 			    struct uvc_streaming_control *probe)
 {
 	return uvc_set_video_ctrl(stream, probe, 0);
@@ -808,7 +820,7 @@ static void uvc_video_stats_update(struct uvc_streaming *stream)
 	uvc_trace(UVC_TRACE_STATS, "frame %u stats: %u/%u/%u packets, "
 		  "%u/%u/%u pts (%searly %sinitial), %u/%u scr, "
 		  "last pts/stc/sof %u/%u/%u\n",
-		  stream->sequence, frame->first_data,
+		  stream->layers[stream->layer_id].sequence, frame->first_data,
 		  frame->nb_packets - frame->nb_empty, frame->nb_packets,
 		  frame->nb_pts_diffs, frame->last_pts_diff, frame->nb_pts,
 		  frame->has_early_pts ? "" : "!",
@@ -943,13 +955,14 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 		struct uvc_buffer *buf, struct uvc_payload_header *header)
 {
 	u8 fid = header->fid;
+	struct uvc_stream_layer *layer = uvc_get_curr_layer(stream);
 
 	/* Increase the sequence number regardless of any buffer states, so
 	 * that discontinuous sequence numbers always indicate lost frames.
 	 */
-	if (stream->last_fid != fid) {
-		stream->sequence++;
-		if (stream->sequence)
+	if (layer->last_fid != fid) {
+		layer->sequence++;
+		if (layer->sequence)
 			uvc_video_stats_update(stream);
 	}
 
@@ -960,7 +973,9 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	 * NULL.
 	 */
 	if (buf == NULL) {
-		stream->last_fid = fid;
+		uvc_trace(UVC_TRACE_FRAME, "No buffers available for layer %d, "
+				"dropping payload\n", layer->layer_id);
+		layer->last_fid = fid;
 		return -ENODATA;
 	}
 
@@ -982,12 +997,13 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	if (buf->state != UVC_BUF_STATE_ACTIVE) {
 		struct timespec ts;
 
-		if (fid == stream->last_fid) {
+		if (fid == layer->last_fid) {
 			uvc_trace(UVC_TRACE_FRAME, "Dropping payload (out of "
-				"sync).\n");
+				"sync: fid: %d, last: %d) for layer: %d.\n",
+				fid, layer->last_fid, layer->layer_id);
 			if ((stream->dev->quirks & UVC_QUIRK_STREAM_NO_FID) &&
 			    (header->has_eof))
-				stream->last_fid ^= UVC_STREAM_FID;
+				layer->last_fid ^= UVC_STREAM_FID;
 			return -ENODATA;
 		}
 
@@ -996,7 +1012,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 		else
 			ktime_get_real_ts(&ts);
 
-		buf->buf.v4l2_buf.sequence = stream->sequence;
+		buf->buf.v4l2_buf.sequence = layer->sequence;
 		buf->buf.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
 		buf->buf.v4l2_buf.timestamp.tv_usec =
 			ts.tv_nsec / NSEC_PER_USEC;
@@ -1012,7 +1028,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	 * last payload can be lost anyway). We thus must check if the FID has
 	 * been toggled.
 	 *
-	 * stream->last_fid is initialized to -1, so the first isochronous
+	 * layer->last_fid is initialized to -1, so the first isochronous
 	 * frame will never trigger an end of frame detection.
 	 *
 	 * Empty buffers (bytesused == 0) don't trigger end of frame detection
@@ -1020,14 +1036,14 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	 * avoids detecting end of frame conditions at FID toggling if the
 	 * previous payload had the EOF bit set.
 	 */
-	if (fid != stream->last_fid && buf->bytesused != 0) {
+	if (fid != layer->last_fid && buf->bytesused != 0) {
 		uvc_trace(UVC_TRACE_FRAME, "Frame complete (FID bit "
 				"toggled).\n");
 		buf->state = UVC_BUF_STATE_READY;
 		return -EAGAIN;
 	}
 
-	stream->last_fid = fid;
+	layer->last_fid = fid;
 
 	return 0;
 }
@@ -1060,6 +1076,8 @@ static void uvc_video_decode_data(struct uvc_streaming *stream,
 static void uvc_video_decode_end(struct uvc_streaming *stream,
 		struct uvc_buffer *buf, struct uvc_payload_header *header)
 {
+	struct uvc_stream_layer *layer = uvc_get_curr_layer(stream);
+
 	/* Mark the buffer as done if the EOF marker is set. */
 	if (header->has_eof && buf->bytesused != 0) {
 		uvc_trace(UVC_TRACE_FRAME, "Frame complete (EOF found).\n");
@@ -1067,7 +1085,7 @@ static void uvc_video_decode_end(struct uvc_streaming *stream,
 			uvc_trace(UVC_TRACE_FRAME, "EOF in empty payload.\n");
 		buf->state = UVC_BUF_STATE_READY;
 		if (stream->dev->quirks & UVC_QUIRK_STREAM_NO_FID)
-			stream->last_fid ^= UVC_STREAM_FID;
+			layer->last_fid ^= UVC_STREAM_FID;
 	}
 }
 
@@ -1087,14 +1105,14 @@ static int uvc_video_encode_header(struct uvc_streaming *stream,
 {
 	data[0] = 2;	/* Header length */
 	data[1] = UVC_STREAM_EOH | UVC_STREAM_EOF
-		| (stream->last_fid & UVC_STREAM_FID);
+		| (stream->layers[0].last_fid & UVC_STREAM_FID);
 	return 2;
 }
 
 static int uvc_video_encode_data(struct uvc_streaming *stream,
 		struct uvc_buffer *buf, __u8 *data, int len)
 {
-	struct uvc_video_queue *queue = &stream->queue;
+	struct uvc_video_queue *queue = &stream->layers[0].queue;
 	unsigned int nbytes;
 	void *mem;
 
@@ -1110,6 +1128,37 @@ static int uvc_video_encode_data(struct uvc_streaming *stream,
 	return nbytes;
 }
 
+static int uvc_video_decode_layer_id(struct uvc_streaming *stream,
+					struct uvc_payload_header *header)
+{
+	unsigned int layer_id;
+
+	if (header->has_sli) {
+		layer_id = (header->sli >> UVC_STREAM_STREAM_ID_SHIFT)
+			  & UVC_STREAM_STREAM_ID_MASK;
+		if (layer_id >= stream->num_layers) {
+			uvc_trace(UVC_TRACE_FRAME, "Invalid layer id (%d)\n",
+					layer_id);
+			return -EINVAL;
+		}
+
+		stream->prev_layer_id = stream->layer_id;
+		stream->layer_id = layer_id;
+		stream->temporal_id = (header->sli >> UVC_STREAM_TMPRL_ID_SHIFT)
+				    & UVC_STREAM_TEMPRL_ID_MASK;
+
+		header->buf_flags |= (stream->temporal_id
+					& V4L2_BUF_FLAG_LAYER_STRUCTURE_MASK)
+				  << V4L2_BUF_FLAG_LAYER_STRUCTURE_SHIFT;
+	} else {
+		stream->prev_layer_id = stream->layer_id;
+		stream->layer_id = 0;
+		stream->temporal_id = 0;
+	}
+
+	return 0;
+}
+
 static int uvc_video_parse_header(struct uvc_streaming *stream,
 		const __u8 *data, int len, struct uvc_payload_header *header)
 {
@@ -1138,7 +1187,8 @@ static int uvc_video_parse_header(struct uvc_streaming *stream,
 
 	header->buf_flags = 0;
 
-	if (stream->cur_format->fcc == V4L2_PIX_FMT_VP8) {
+	if (stream->cur_format->fcc == V4L2_PIX_FMT_VP8
+		|| stream->cur_format->fcc == V4L2_PIX_FMT_VP8_SIMULCAST) {
 		/* VP8 payload has 2 additional bytes of BFH. */
 		header->length += 2;
 		off += 2;
@@ -1203,6 +1253,7 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream)
 	unsigned int len;
 	u8 *mem;
 	int ret, i;
+	struct uvc_video_queue *queue;
 	struct uvc_buffer *buf = NULL;
 	struct uvc_payload_header header;
 
@@ -1223,12 +1274,17 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream)
 		if (ret < 0)
 			continue;
 
-		buf = uvc_queue_get_first_buf(&stream->queue);
+		ret = uvc_video_decode_layer_id(stream, &header);
+		if (ret < 0)
+			continue;
+
+		queue = &stream->layers[stream->layer_id].queue;
+		buf = uvc_queue_get_first_buf(queue);
+
 		do {
 			ret = uvc_video_decode_start(stream, buf, &header);
 			if (ret == -EAGAIN)
-				buf = uvc_queue_next_buffer(&stream->queue,
-							    buf);
+				buf = uvc_queue_next_buffer(queue, buf);
 		} while (ret == -EAGAIN);
 
 		if (ret < 0)
@@ -1249,7 +1305,7 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream)
 			      UVC_FMT_FLAG_COMPRESSED))
 				buf->error = 1;
 
-			buf = uvc_queue_next_buffer(&stream->queue, buf);
+			buf = uvc_queue_next_buffer(queue, buf);
 		}
 	}
 }
@@ -1258,6 +1314,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream)
 {
 	u8 *mem;
 	int len, ret;
+	struct uvc_video_queue *queue;
 	struct uvc_payload_header header;
 	struct uvc_buffer *buf;
 
@@ -1276,7 +1333,12 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream)
 	if (ret < 0)
 		return;
 
-	buf = uvc_queue_get_first_buf(&stream->queue);
+	ret = uvc_video_decode_layer_id(stream, &header);
+	if (ret < 0)
+		return;
+
+	queue = &stream->layers[stream->layer_id].queue;
+	buf = uvc_queue_get_first_buf(queue);
 
 	/* If the URB is the first of its payload, decode and save the
 	 * header.
@@ -1285,8 +1347,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream)
 		do {
 			ret = uvc_video_decode_start(stream, buf, &header);
 			if (ret == -EAGAIN)
-				buf = uvc_queue_next_buffer(&stream->queue,
-							    buf);
+				buf = uvc_queue_next_buffer(queue, buf);
 		} while (ret == -EAGAIN);
 
 		/* If an error occurred skip the rest of the payload. */
@@ -1320,8 +1381,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream)
 		if (!stream->bulk.skip_payload && buf != NULL) {
 			uvc_video_decode_end(stream, buf, &header);
 			if (buf->state == UVC_BUF_STATE_READY)
-				buf = uvc_queue_next_buffer(&stream->queue,
-							    buf);
+				buf = uvc_queue_next_buffer(queue, buf);
 		}
 
 		stream->bulk.header_size = 0;
@@ -1334,9 +1394,10 @@ static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream)
 {
 	u8 *mem = urb->transfer_buffer;
 	int len = stream->urb_size, ret;
+	struct uvc_stream_layer *layer = &stream->layers[0];
 	struct uvc_buffer *buf;
 
-	buf = uvc_queue_get_first_buf(&stream->queue);
+	buf = uvc_queue_get_first_buf(&layer->queue);
 	if (buf == NULL) {
 		urb->transfer_buffer_length = 0;
 		return;
@@ -1357,14 +1418,15 @@ static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream)
 	stream->bulk.payload_size += ret;
 	len -= ret;
 
-	if (buf->bytesused == stream->queue.buf_used ||
+	if (buf->bytesused == layer->queue.buf_used ||
 	    stream->bulk.payload_size == stream->bulk.max_payload_size) {
-		if (buf->bytesused == stream->queue.buf_used) {
-			stream->queue.buf_used = 0;
+		if (buf->bytesused == layer->queue.buf_used) {
+			layer->queue.buf_used = 0;
 			buf->state = UVC_BUF_STATE_READY;
-			buf->buf.v4l2_buf.sequence = ++stream->sequence;
-			uvc_queue_next_buffer(&stream->queue, buf);
-			stream->last_fid ^= UVC_STREAM_FID;
+			buf->buf.v4l2_buf.sequence =
+				++layer->sequence;
+			uvc_queue_next_buffer(&layer->queue, buf);
+			layer->last_fid ^= UVC_STREAM_FID;
 		}
 
 		stream->bulk.header_size = 0;
@@ -1378,6 +1440,7 @@ static void uvc_video_complete(struct urb *urb)
 {
 	struct uvc_streaming *stream = urb->context;
 	int ret;
+	int i;
 
 	switch (urb->status) {
 	case 0:
@@ -1393,7 +1456,9 @@ static void uvc_video_complete(struct urb *urb)
 
 	case -ECONNRESET:	/* usb_unlink_urb() called. */
 	case -ESHUTDOWN:	/* The endpoint is being disabled. */
-		uvc_queue_cancel(&stream->queue, urb->status == -ESHUTDOWN);
+		for (i = 0; i < stream->num_layers; ++i)
+			uvc_queue_cancel(&stream->layers[i].queue,
+						urb->status == -ESHUTDOWN);
 		return;
 	}
 
@@ -1648,8 +1713,10 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 	unsigned int i;
 	int ret;
 
-	stream->sequence = -1;
-	stream->last_fid = -1;
+	for (i = 0; i < stream->num_layers; ++i) {
+		stream->layers[i].sequence = -1;
+		stream->layers[i].last_fid = -1;
+	}
 	stream->bulk.header_size = 0;
 	stream->bulk.skip_payload = 0;
 	stream->bulk.payload_size = 0;
@@ -1748,7 +1815,7 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
  */
 int uvc_video_suspend(struct uvc_streaming *stream)
 {
-	if (!uvc_queue_streaming(&stream->queue))
+	if (stream->streaming_layers == 0)
 		return 0;
 
 	stream->frozen = 1;
@@ -1761,13 +1828,14 @@ int uvc_video_suspend(struct uvc_streaming *stream)
  * Reconfigure the video interface and restart streaming if it was enabled
  * before suspend.
  *
- * If an error occurs, disable the video queue. This will wake all pending
+ * If an error occurs, disable video queues. This will wake all pending
  * buffers, making sure userspace applications are notified of the problem
  * instead of waiting forever.
  */
 int uvc_video_resume(struct uvc_streaming *stream, int reset)
 {
 	int ret;
+	int i;
 
 	/* If the bus has been reset on resume, set the alternate setting to 0.
 	 * This should be the default value, but some devices crash or otherwise
@@ -1782,18 +1850,23 @@ int uvc_video_resume(struct uvc_streaming *stream, int reset)
 	uvc_video_clock_reset(stream);
 
 	ret = uvc_commit_video(stream, &stream->ctrl);
-	if (ret < 0) {
-		uvc_queue_enable(&stream->queue, 0);
-		return ret;
-	}
+	if (ret < 0)
+		goto fail;
 
-	if (!uvc_queue_streaming(&stream->queue))
+	/* At least one queue must be streaming for us to re-enable video. */
+	if (stream->streaming_layers == 0)
 		return 0;
 
 	ret = uvc_init_video(stream, GFP_NOIO);
 	if (ret < 0)
-		uvc_queue_enable(&stream->queue, 0);
+		goto fail;
 
+	return 0;
+
+fail:
+	for (i = 0; i < stream->num_layers; ++i)
+		uvc_queue_enable(&stream->layers[i].queue, 0);
+	stream->streaming_layers = 0;
 	return ret;
 }
 
@@ -1824,13 +1897,6 @@ int uvc_video_init(struct uvc_streaming *stream)
 		return -EINVAL;
 	}
 
-	atomic_set(&stream->active, 0);
-
-	/* Initialize the video buffers queue. */
-	ret = uvc_queue_init(&stream->queue, stream->type, !uvc_no_drop_param);
-	if (ret)
-		return ret;
-
 	/* Alternate setting 0 should be the default, yet the XBox Live Vision
 	 * Cam (and possibly other devices) crash or otherwise misbehave if
 	 * they don't receive a SET_INTERFACE request before any other video
@@ -1884,9 +1950,7 @@ int uvc_video_init(struct uvc_streaming *stream)
 	probe->bFormatIndex = format->index;
 	probe->bFrameIndex = frame->bFrameIndex;
 
-	stream->def_format = format;
-	stream->cur_format = format;
-	stream->cur_frame = frame;
+	uvc_update_stream_format(stream, format, frame);
 
 	/* Select the video decoding function */
 	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
@@ -1906,37 +1970,43 @@ int uvc_video_init(struct uvc_streaming *stream)
 		}
 	}
 
+	/* If an encoding unit is present, initialize simulcast capabilities. */
+	uvc_ctrl_simulcast_init(stream);
+
 	return 0;
 }
 
 /*
- * Enable or disable the video stream.
+ * Called on STREAMOFF/release for the last layer to be disabled.
  */
-int uvc_video_enable(struct uvc_streaming *stream, int enable)
+static void uvc_video_disable(struct uvc_streaming *stream)
+{
+	uvc_trace(UVC_TRACE_VIDEO, "Disabling video\n");
+
+	uvc_uninit_video(stream, 1);
+	usb_set_interface(stream->dev->udev, stream->intfnum, 0);
+	uvc_video_clock_cleanup(stream);
+	/*
+	 * UVC standard unfortunately specifies that after setting interface
+	 * to 0, EU state is undefined until next commit.
+	 * So commit to be able to query EU controls.
+	 */
+	uvc_commit_video(stream, &stream->ctrl);
+}
+
+/*
+ * Called on STREAMON for the first layer to be enabled.
+ */
+static int uvc_video_enable(struct uvc_streaming *stream)
 {
 	int ret;
 
-	if (!enable) {
-		uvc_uninit_video(stream, 1);
-		usb_set_interface(stream->dev->udev, stream->intfnum, 0);
-		uvc_queue_enable(&stream->queue, 0);
-		uvc_video_clock_cleanup(stream);
-		return 0;
-	}
+	uvc_trace(UVC_TRACE_VIDEO, "Enabling video\n");
 
 	ret = uvc_video_clock_init(stream);
 	if (ret < 0)
 		return ret;
 
-	ret = uvc_queue_enable(&stream->queue, 1);
-	if (ret < 0)
-		goto error_queue;
-
-	/* Commit the streaming parameters. */
-	ret = uvc_commit_video(stream, &stream->ctrl);
-	if (ret < 0)
-		goto error_commit;
-
 	ret = uvc_init_video(stream, GFP_KERNEL);
 	if (ret < 0)
 		goto error_video;
@@ -1944,11 +2014,89 @@ int uvc_video_enable(struct uvc_streaming *stream, int enable)
 	return 0;
 
 error_video:
+	uvc_printk(KERN_ERR, "Failed to enable video!\n");
 	usb_set_interface(stream->dev->udev, stream->intfnum, 0);
-error_commit:
-	uvc_queue_enable(&stream->queue, 0);
-error_queue:
 	uvc_video_clock_cleanup(stream);
 
 	return ret;
 }
+
+/* Must be called with stream->mutex taken. */
+int uvc_video_layer_enable(struct uvc_stream_layer *layer)
+{
+	struct uvc_streaming *stream = layer->stream;
+	int ret = 0;
+
+	uvc_trace(UVC_TRACE_VIDEO, "Enabling layer: %d\n", layer->layer_id);
+
+	ret = uvc_queue_enable(&layer->queue, 1);
+	/* This will also guarantee that we don't enable streaming more than
+	 * once on this layer.
+	 */
+	if (ret)
+		return ret;
+
+	/* Enable via EU control first if present/possible. This will not enable
+	 * streaming if video is not active.
+	 */
+	if (uvc_is_eu_active(stream)) {
+		ret = uvc_ctrl_layer_enable(layer, 1);
+		if (ret) {
+			uvc_queue_enable(&layer->queue, 0);
+			return ret;
+		}
+	}
+
+	if (stream->streaming_layers == 0) {
+		ret = uvc_video_enable(stream);
+		if (ret) {
+			uvc_ctrl_layer_enable(layer, 0);
+			uvc_queue_enable(&layer->queue, 0);
+			return ret;
+		}
+	}
+
+	set_bit(layer->layer_id, &stream->streaming_layers);
+	return ret;
+}
+
+/* Must be called with stream->mutex taken. */
+void uvc_video_layer_disable(struct uvc_stream_layer *layer)
+{
+	struct uvc_streaming *stream = layer->stream;
+
+	uvc_trace(UVC_TRACE_VIDEO, "Disabling layer: %d\n", layer->layer_id);
+
+	if (uvc_is_eu_active(stream))
+		uvc_ctrl_layer_enable(layer, 0);
+
+	clear_bit(layer->layer_id, &stream->streaming_layers);
+	if (stream->streaming_layers == 0)
+		uvc_video_disable(stream);
+
+	uvc_queue_enable(&layer->queue, 0);
+}
+
+void uvc_update_stream_format(struct uvc_streaming *stream,
+			struct uvc_format *format, struct uvc_frame *frame)
+{
+	int i;
+
+	stream->def_format = format;
+	stream->cur_format = format;
+	stream->cur_frame = frame;
+	stream->num_negotiated_layers = 0;
+
+	if (uvc_is_eu_active(stream)) {
+		for (i = 0; i < stream->num_layers; ++i) {
+			stream->num_negotiated_layers +=
+				uvc_is_layer_negotiated(stream, i) ? 1 : 0;
+		}
+	} else {
+		stream->num_negotiated_layers = 1;
+	}
+
+	uvc_trace(UVC_TRACE_PROBE, "Negotiated max layers: %d\n",
+			stream->num_negotiated_layers);
+}
+
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index fb21459..1df0960 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -130,6 +130,19 @@
 #define UVC_MAX_CONTROL_MAPPINGS	1024
 #define UVC_MAX_CONTROL_MENU_ENTRIES	32
 
+#define UVC_SIMULCAST_MAX_LAYERS	(UVC_NUM_SIMULCAST_STREAMS)
+#define UVC_VP8_MAX_TEMPORAL_LAYERS	4
+
+/* VP8 format/P&C features */
+#define UVC_FRM_VP8_USAGE_REAL_TIME			(1 << 1)
+#define UVC_FRM_VP8_USAGE_REAL_TIME_TEMPORAL_LAYERS	(1 << 2)
+
+/* VP8 P&C stream layout configuration (bmLayoutPerStream). */
+#define UVC_VP8_TEMPORAL_LAYOUT_WILDCARD		0x7
+#define UVC_VP8_TEMPORAL_LAYOUT_WILDCARD_LAYER(layer)	\
+	((UVC_VP8_TEMPORAL_LAYOUT_WILDCARD) << (3 + (layer) * 3))
+#define UVC_VP8_TEMPRL_LAYOUT_NUM(n)			((((n) - 1) & 0x3) << 1)
+
 /* Devices quirks */
 #define UVC_QUIRK_STATUS_INTERVAL	0x00000001
 #define UVC_QUIRK_PROBE_MINMAX		0x00000002
@@ -144,6 +157,7 @@
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
 #define UVC_FMT_FLAG_STREAM		0x00000002
+#define UVC_FMT_FLAG_SIMULCAST		0x00000004
 
 /* v4l2_buffer codec flags */
 #define UVC_V4L2_BUFFER_CODEC_FLAGS	(V4L2_BUF_FLAG_KEYFRAME | \
@@ -251,7 +265,7 @@ struct uvc_entity {
 	char name[64];
 
 	/* Media controller-related fields. */
-	struct video_device *vdev;
+	struct video_device *vdev[UVC_SIMULCAST_MAX_LAYERS];
 	struct v4l2_subdev subdev;
 	unsigned int num_pads;
 	unsigned int num_links;
@@ -392,6 +406,8 @@ struct uvc_video_queue {
 
 	spinlock_t irqlock;			/* Protects irqqueue */
 	struct list_head irqqueue;
+
+	struct uvc_streaming *stream;
 };
 
 struct uvc_video_pipeline {
@@ -409,6 +425,10 @@ struct uvc_video_chain {
 	struct uvc_entity *selector;		/* Selector unit */
 	struct uvc_entity *encoding;		/* Encoding unit */
 
+	struct uvc_control *layer_ctrl;
+	struct uvc_control *res_ctrl;
+	struct uvc_control *startstop_ctrl;
+
 	struct uvc_video_pipeline *pipeline;    /* Pipeline this chain
 						   belongs to */
 
@@ -484,12 +504,30 @@ struct uvc_payload_header {
 	__u32 buf_flags; /* v4l2_buffer flags */
 };
 
+struct uvc_stream_layer {
+	int layer_id;
+	int width;
+	int height;
+
+	__u32 sequence;
+	__u8 last_fid;
+
+	struct uvc_video_queue queue;
+	struct uvc_streaming *stream;
+
+	atomic_t active;
+};
+
+#define UVC_SIMUL_CAP_STARTSTOP_LAYER			(1 << 0)
+#define UVC_SIMUL_CAP_STARTSTOP_LAYER_STREAMTIME	(1 << 1)
+#define UVC_SIMUL_CAP_RES				(1 << 2)
+#define UVC_SIMUL_CAP_RES_STREAMTIME			(1 << 3)
+
 struct uvc_streaming {
 	struct list_head list;
 	struct uvc_device *dev;
-	struct video_device *vdev;
+	struct video_device *vdev[UVC_SIMULCAST_MAX_LAYERS];
 	struct uvc_video_chain *chain;
-	atomic_t active;
 
 	struct usb_interface *intf;
 	int intfnum;
@@ -506,13 +544,17 @@ struct uvc_streaming {
 	struct uvc_format *cur_format;
 	struct uvc_frame *cur_frame;
 	/* Protect access to ctrl, cur_format, cur_frame and hardware video
-	 * probe control.
+	 * probe control as well as layer allocated/streaming state.
 	 */
 	struct mutex mutex;
 
 	/* Buffers queue. */
 	unsigned int frozen : 1;
-	struct uvc_video_queue queue;
+
+	/* Protected by mutex. */
+	unsigned long allocated_layers;
+	unsigned long streaming_layers;
+
 	void (*decode) (struct urb *urb, struct uvc_streaming *video);
 
 	/* Context data used by the bulk completion handler. */
@@ -529,9 +571,6 @@ struct uvc_streaming {
 	dma_addr_t urb_dma[UVC_URBS];
 	unsigned int urb_size;
 
-	__u32 sequence;
-	__u8 last_fid;
-
 	/* debugfs */
 	struct dentry *debugfs_dir;
 	struct {
@@ -557,6 +596,19 @@ struct uvc_streaming {
 
 		spinlock_t lock;
 	} clock;
+
+	/* Max number of layers this streaming interface
+	 * can potentially support.
+	 */
+	int num_layers;
+	/* Negotiated in P&C. */
+	int num_negotiated_layers;
+	struct uvc_stream_layer layers[UVC_SIMULCAST_MAX_LAYERS];
+	unsigned long simulcast_caps;
+
+	int layer_id;
+	int prev_layer_id;
+	int temporal_id;
 };
 
 enum uvc_device_state {
@@ -589,7 +641,7 @@ struct uvc_device {
 
 	/* Video Streaming interfaces */
 	struct list_head streams;
-	atomic_t nstreams;
+	atomic_t num_vdevs;
 
 	/* Status Interrupt Endpoint */
 	struct usb_host_endpoint *int_ep;
@@ -607,7 +659,7 @@ enum uvc_handle_state {
 struct uvc_fh {
 	struct v4l2_fh vfh;
 	struct uvc_video_chain *chain;
-	struct uvc_streaming *stream;
+	struct uvc_stream_layer *layer;
 	enum uvc_handle_state state;
 };
 
@@ -677,7 +729,8 @@ extern struct uvc_entity *uvc_entity_by_id(struct uvc_device *dev, int id);
 
 /* Video buffers queue management. */
 extern int uvc_queue_init(struct uvc_video_queue *queue,
-		enum v4l2_buf_type type, int drop_corrupted);
+		enum v4l2_buf_type type, int drop_corrupted,
+		struct uvc_streaming *stream);
 extern int uvc_alloc_buffers(struct uvc_video_queue *queue,
 		struct v4l2_requestbuffers *rb);
 extern void uvc_free_buffers(struct uvc_video_queue *queue);
@@ -717,17 +770,21 @@ extern void uvc_mc_cleanup_entity(struct uvc_entity *entity);
 extern int uvc_video_init(struct uvc_streaming *stream);
 extern int uvc_video_suspend(struct uvc_streaming *stream);
 extern int uvc_video_resume(struct uvc_streaming *stream, int reset);
-extern int uvc_video_enable(struct uvc_streaming *stream, int enable);
+int uvc_video_layer_enable(struct uvc_stream_layer *layer);
+void uvc_video_layer_disable(struct uvc_stream_layer *layer);
 extern int uvc_probe_video(struct uvc_streaming *stream,
 		struct uvc_streaming_control *probe);
+int uvc_commit_video(struct uvc_streaming *stream,
+			    struct uvc_streaming_control *probe);
 extern int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 		__u8 intfnum, __u8 cs, void *data, __u16 size);
 void uvc_video_clock_update(struct uvc_streaming *stream,
 			    struct v4l2_buffer *v4l2_buf,
 			    struct uvc_buffer *buf);
+int uvc_get_probe_ctrl_size(struct uvc_streaming *stream);
 static inline bool uvc_is_stream_streaming(struct uvc_streaming *stream)
 {
-	return vb2_is_streaming(&stream->queue.queue);
+	return stream->streaming_layers != 0;
 }
 
 /* Status */
@@ -773,6 +830,13 @@ extern int uvc_ctrl_set(struct uvc_video_chain *chain,
 extern int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		struct uvc_xu_control_query *xqry);
 
+int uvc_ctrl_layer_enable(struct uvc_stream_layer *layer, int enable);
+int uvc_video_layer_set_resolution(struct uvc_stream_layer *layer,
+					int width, int height);
+int uvc_video_layer_get_resolution(struct uvc_stream_layer *layer);
+void uvc_ctrl_simulcast_init(struct uvc_streaming *stream);
+int __uvc_video_layer_select(struct uvc_stream_layer *layer, int temporal_id);
+
 /* Utility functions */
 extern void uvc_simplify_fraction(uint32_t *numerator, uint32_t *denominator,
 		unsigned int n_terms, unsigned int threshold);
@@ -781,6 +845,35 @@ extern uint32_t uvc_fraction_to_interval(uint32_t numerator,
 extern struct usb_host_endpoint *uvc_find_endpoint(
 		struct usb_host_interface *alts, __u8 epaddr);
 
+void uvc_update_stream_format(struct uvc_streaming *stream,
+			struct uvc_format *format, struct uvc_frame *frame);
+bool uvc_is_layer_negotiated(struct uvc_streaming *stream, int layer_id);
+
+static inline bool uvc_is_simulcasting(struct uvc_streaming *stream)
+{
+	return stream->cur_format
+		&& (stream->cur_format->flags & UVC_FMT_FLAG_SIMULCAST);
+}
+
+static inline bool uvc_is_eu_active(struct uvc_streaming *stream)
+{
+	return stream->cur_format
+		&& (stream->cur_format->fcc == V4L2_PIX_FMT_VP8
+		    || stream->cur_format->fcc == V4L2_PIX_FMT_VP8_SIMULCAST);
+}
+
+static inline struct uvc_stream_layer *uvc_get_curr_layer(
+		struct uvc_streaming *stream)
+{
+	return &stream->layers[stream->layer_id];
+}
+
+static inline bool uvc_cur_fmt_has_tmprl_layers(struct uvc_streaming *stream)
+{
+	return stream->cur_format->fcc == V4L2_PIX_FMT_VP8
+		|| stream->cur_format->fcc == V4L2_PIX_FMT_VP8_SIMULCAST;
+}
+
 /* Quirks support */
 void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream);
 
diff --git a/include/uapi/linux/usb/video.h b/include/uapi/linux/usb/video.h
index fd1d4b0..4bb4057 100644
--- a/include/uapi/linux/usb/video.h
+++ b/include/uapi/linux/usb/video.h
@@ -56,6 +56,7 @@
 #define UVC_VS_FORMAT_STREAM_BASED			0x12
 #define UVC_VS_FORMAT_VP8				0x16
 #define UVC_VS_FRAME_VP8				0x17
+#define UVC_VS_FORMAT_VP8_SIMULCAST                     0x18
 
 /* A.7. Video Class-Specific Endpoint Descriptor Subtypes */
 #define UVC_EP_UNDEFINED				0x00
@@ -202,6 +203,11 @@
 #define UVC_STREAM_VP8_ARF				(1 << 1)
 #define UVC_STREAM_VP8_PRF				(1 << 0)
 
+#define UVC_STREAM_STREAM_ID_SHIFT			10
+#define UVC_STREAM_STREAM_ID_MASK			0x3
+#define UVC_STREAM_TMPRL_ID_SHIFT			7
+#define UVC_STREAM_TEMPRL_ID_MASK			0x3
+
 /* 4.1.2. Control Capabilities */
 #define UVC_CONTROL_CAP_GET				(1 << 0)
 #define UVC_CONTROL_CAP_SET				(1 << 1)
-- 
1.8.4

