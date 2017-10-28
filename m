Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:46650 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdJ1UlE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 16:41:04 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 1/9] media: staging/imx: get CSI bus type from nearest upstream entity
Date: Sat, 28 Oct 2017 13:36:41 -0700
Message-Id: <1509223009-6392-2-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
References: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The imx-media driver currently supports a device tree graph of
limited complexity. This patch is a first step in allowing imx-media
to work with more general OF graphs.

The CSI subdevice assumes the originating upstream subdevice (the
"sensor") is connected directly to either the CSI mux or the MIPI
CSI-2 receiver. But for more complex graphs, the sensor can be distant,
with possible bridge entities in between. Thus the sensor's bus type
could be quite different from what is entering the CSI. For example
a distant sensor could have a parallel interface, but the stream
entering the i.MX is MIPI CSI-2.

To remove this assumption, get the entering bus config from the entity
that is directly upstream from either the CSI mux, or the CSI-2 receiver.
If the CSI-2 receiver is not in the enabled pipeline, the bus type to the
CSI is parallel, otherwise the CSI is receiving MIPI CSI-2.

Note that we can't use the direct upstream source connected to CSI
(which is either the CSI mux or the CSI-2 receiver) to determine
bus type. The bus entering the CSI from the CSI-2 receiver is a 32-bit
parallel bus containing the demultiplexed MIPI CSI-2 virtual channels.
But the CSI and its IDMAC channels must be configured based on whether
it is receiving data from the CSI-2 receiver or from the CSI mux's
parallel interface pins.

The function csi_get_upstream_endpoint() is used to find this
endpoint. It makes use of a new utility function
imx_media_find_upstream_pad(), that if given a grp_id of 0, will
return the closest upstream pad from start_entity.

With these changes, imx_media_find_sensor() is no longer used and
is removed. As a result there is also no longer a need to identify
any sensor or set the sensor subdev's group id as a method to search
for it. So IMX_MEDIA_GRP_ID_SENSOR is removed. Also the video-mux group
id IMX_MEDIA_GRP_ID_VIDMUX was never used so that is removed as well.
The remaining IMX_MEDIA_GRP_ID_* definitions are entities internal
to the i.MX.

Another use of imx_media_find_sensor() in the CSI was to call the
sensor's g_skip_frames op to determine if a delay was needed before
enabling the CSI at stream on. If necessary this will have to be
re-addressed at a later time.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c   | 188 ++++++++++++++++------------
 drivers/staging/media/imx/imx-media-dev.c   |  12 --
 drivers/staging/media/imx/imx-media-of.c    |  21 ----
 drivers/staging/media/imx/imx-media-utils.c |  63 +++++-----
 drivers/staging/media/imx/imx-media.h       |  27 ++--
 5 files changed, 150 insertions(+), 161 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 6d85611..c45b235 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -13,6 +13,7 @@
 #include <linux/gcd.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/of_graph.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <media/v4l2-ctrls.h>
@@ -99,8 +100,8 @@ struct csi_priv {
 	/* the mipi virtual channel number at link validate */
 	int vc_num;
 
-	/* the attached sensor at stream on */
-	struct imx_media_subdev *sensor;
+	/* the upstream endpoint CSI is receiving from */
+	struct v4l2_fwnode_endpoint upstream_ep;
 
 	spinlock_t irqlock; /* protect eof_irq handler */
 	struct timer_list eof_timeout_timer;
@@ -120,6 +121,71 @@ static inline struct csi_priv *sd_to_dev(struct v4l2_subdev *sdev)
 	return container_of(sdev, struct csi_priv, sd);
 }
 
+static inline bool is_parallel_16bit_bus(struct v4l2_fwnode_endpoint *ep)
+{
+	return ep->bus_type != V4L2_MBUS_CSI2 &&
+		ep->bus.parallel.bus_width >= 16;
+}
+
+/*
+ * Parses the fwnode endpoint from the source pad of the entity
+ * connected to this CSI. This will either be the entity directly
+ * upstream from the CSI-2 receiver, or directly upstream from the
+ * video mux. The endpoint is needed to determine the bus type and
+ * bus config coming into the CSI.
+ */
+static int csi_get_upstream_endpoint(struct csi_priv *priv,
+				     struct v4l2_fwnode_endpoint *ep)
+{
+	struct device_node *endpoint, *port;
+	struct imx_media_subdev *imxsd;
+	struct media_entity *src;
+	struct v4l2_subdev *sd;
+	struct media_pad *pad;
+
+	if (!priv->src_sd)
+		return -EPIPE;
+
+	src = &priv->src_sd->entity;
+
+	if (src->function == MEDIA_ENT_F_VID_MUX) {
+		/*
+		 * CSI is connected directly to video mux, skip up to
+		 * CSI-2 receiver if it is in the path, otherwise stay
+		 * with video mux.
+		 */
+		imxsd = imx_media_find_upstream_subdev(priv->md, src,
+						       IMX_MEDIA_GRP_ID_CSI2);
+		if (!IS_ERR(imxsd))
+			src = &imxsd->sd->entity;
+	}
+
+	/* get source pad of entity directly upstream from src */
+	pad = imx_media_find_upstream_pad(priv->md, src, 0);
+	if (IS_ERR(pad))
+		return PTR_ERR(pad);
+
+	sd = media_entity_to_v4l2_subdev(pad->entity);
+
+	/*
+	 * NOTE: this assumes an OF-graph port id is the same as a
+	 * media pad index.
+	 */
+	port = of_graph_get_port_by_id(sd->dev->of_node, pad->index);
+	if (!port)
+		return -ENODEV;
+
+	endpoint = of_get_next_child(port, NULL);
+	of_node_put(port);
+	if (!endpoint)
+		return -ENODEV;
+
+	v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint), ep);
+	of_node_put(endpoint);
+
+	return 0;
+}
+
 static void csi_idmac_put_ipu_resources(struct csi_priv *priv)
 {
 	if (priv->idmac_ch)
@@ -306,7 +372,6 @@ static void csi_idmac_unsetup_vb2_buf(struct csi_priv *priv,
 static int csi_idmac_setup_channel(struct csi_priv *priv)
 {
 	struct imx_media_video_dev *vdev = priv->vdev;
-	struct v4l2_fwnode_endpoint *sensor_ep;
 	struct v4l2_mbus_framefmt *infmt;
 	struct ipu_image image;
 	u32 passthrough_bits;
@@ -316,7 +381,6 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	int ret;
 
 	infmt = &priv->format_mbus[CSI_SINK_PAD];
-	sensor_ep = &priv->sensor->sensor_ep;
 
 	ipu_cpmem_zero(priv->idmac_ch);
 
@@ -334,7 +398,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	 * Check for conditions that require the IPU to handle the
 	 * data internally as generic data, aka passthrough mode:
 	 * - raw bayer formats
-	 * - the sensor bus is 16-bit parallel
+	 * - the CSI is receiving from a 16-bit parallel bus
 	 */
 	switch (image.pix.pixelformat) {
 	case V4L2_PIX_FMT_SBGGR8:
@@ -358,8 +422,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 		burst_size = (image.pix.width & 0x3f) ?
 			     ((image.pix.width & 0x1f) ?
 			      ((image.pix.width & 0xf) ? 8 : 16) : 32) : 64;
-		passthrough = (sensor_ep->bus_type != V4L2_MBUS_CSI2 &&
-			       sensor_ep->bus.parallel.bus_width >= 16);
+		passthrough = is_parallel_16bit_bus(&priv->upstream_ep);
 		passthrough_bits = 16;
 		/* Skip writing U and V components to odd rows */
 		ipu_cpmem_skip_odd_chroma_rows(priv->idmac_ch);
@@ -368,14 +431,12 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	case V4L2_PIX_FMT_UYVY:
 		burst_size = (image.pix.width & 0x1f) ?
 			     ((image.pix.width & 0xf) ? 8 : 16) : 32;
-		passthrough = (sensor_ep->bus_type != V4L2_MBUS_CSI2 &&
-			       sensor_ep->bus.parallel.bus_width >= 16);
+		passthrough = is_parallel_16bit_bus(&priv->upstream_ep);
 		passthrough_bits = 16;
 		break;
 	default:
 		burst_size = (image.pix.width & 0xf) ? 8 : 16;
-		passthrough = (sensor_ep->bus_type != V4L2_MBUS_CSI2 &&
-			       sensor_ep->bus.parallel.bus_width >= 16);
+		passthrough = is_parallel_16bit_bus(&priv->upstream_ep);
 		passthrough_bits = 16;
 		break;
 	}
@@ -572,22 +633,20 @@ static void csi_idmac_stop(struct csi_priv *priv)
 static int csi_setup(struct csi_priv *priv)
 {
 	struct v4l2_mbus_framefmt *infmt, *outfmt;
-	struct v4l2_mbus_config sensor_mbus_cfg;
-	struct v4l2_fwnode_endpoint *sensor_ep;
+	struct v4l2_mbus_config mbus_cfg;
 	struct v4l2_mbus_framefmt if_fmt;
 
 	infmt = &priv->format_mbus[CSI_SINK_PAD];
 	outfmt = &priv->format_mbus[priv->active_output_pad];
-	sensor_ep = &priv->sensor->sensor_ep;
 
-	/* compose mbus_config from sensor endpoint */
-	sensor_mbus_cfg.type = sensor_ep->bus_type;
-	sensor_mbus_cfg.flags = (sensor_ep->bus_type == V4L2_MBUS_CSI2) ?
-		sensor_ep->bus.mipi_csi2.flags :
-		sensor_ep->bus.parallel.flags;
+	/* compose mbus_config from the upstream endpoint */
+	mbus_cfg.type = priv->upstream_ep.bus_type;
+	mbus_cfg.flags = (priv->upstream_ep.bus_type == V4L2_MBUS_CSI2) ?
+		priv->upstream_ep.bus.mipi_csi2.flags :
+		priv->upstream_ep.bus.parallel.flags;
 
 	/*
-	 * we need to pass input sensor frame to CSI interface, but
+	 * we need to pass input frame to CSI interface, but
 	 * with translated field type from output format
 	 */
 	if_fmt = *infmt;
@@ -599,7 +658,7 @@ static int csi_setup(struct csi_priv *priv)
 			     priv->crop.width == 2 * priv->compose.width,
 			     priv->crop.height == 2 * priv->compose.height);
 
-	ipu_csi_init_interface(priv->csi, &sensor_mbus_cfg, &if_fmt);
+	ipu_csi_init_interface(priv->csi, &mbus_cfg, &if_fmt);
 
 	ipu_csi_set_dest(priv->csi, priv->dest);
 
@@ -615,35 +674,11 @@ static int csi_setup(struct csi_priv *priv)
 static int csi_start(struct csi_priv *priv)
 {
 	struct v4l2_fract *output_fi, *input_fi;
-	u32 bad_frames = 0;
 	int ret;
 
-	if (!priv->sensor) {
-		v4l2_err(&priv->sd, "no sensor attached\n");
-		return -EINVAL;
-	}
-
 	output_fi = &priv->frame_interval[priv->active_output_pad];
 	input_fi = &priv->frame_interval[CSI_SINK_PAD];
 
-	ret = v4l2_subdev_call(priv->sensor->sd, sensor,
-			       g_skip_frames, &bad_frames);
-	if (!ret && bad_frames) {
-		u32 delay_usec;
-
-		/*
-		 * This sensor has bad frames when it is turned on,
-		 * add a delay to avoid them before enabling the CSI
-		 * hardware. Especially for sensors with a bt.656 interface,
-		 * any shifts in the SAV/EAV sync codes will cause the CSI
-		 * to lose vert/horiz sync.
-		 */
-		delay_usec = DIV_ROUND_UP_ULL(
-			(u64)USEC_PER_SEC * input_fi->numerator * bad_frames,
-			input_fi->denominator);
-		usleep_range(delay_usec, delay_usec + 1000);
-	}
-
 	if (priv->dest == IPU_CSI_DEST_IDMAC) {
 		ret = csi_idmac_start(priv);
 		if (ret)
@@ -975,9 +1010,8 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_format *sink_fmt)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
-	struct v4l2_fwnode_endpoint *sensor_ep;
+	struct v4l2_fwnode_endpoint upstream_ep;
 	const struct imx_media_pixfmt *incc;
-	struct imx_media_subdev *sensor;
 	bool is_csi2;
 	int ret;
 
@@ -986,22 +1020,20 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 	if (ret)
 		return ret;
 
-	sensor = __imx_media_find_sensor(priv->md, &priv->sd.entity);
-	if (IS_ERR(sensor)) {
-		v4l2_err(&priv->sd, "no sensor attached\n");
-		return PTR_ERR(priv->sensor);
+	ret = csi_get_upstream_endpoint(priv, &upstream_ep);
+	if (ret) {
+		v4l2_err(&priv->sd, "failed to find upstream endpoint\n");
+		return ret;
 	}
 
 	mutex_lock(&priv->lock);
 
-	priv->sensor = sensor;
-	sensor_ep = &priv->sensor->sensor_ep;
-	is_csi2 = (sensor_ep->bus_type == V4L2_MBUS_CSI2);
+	priv->upstream_ep = upstream_ep;
+	is_csi2 = (upstream_ep.bus_type == V4L2_MBUS_CSI2);
 	incc = priv->cc[CSI_SINK_PAD];
 
 	if (priv->dest != IPU_CSI_DEST_IDMAC &&
-	    (incc->bayer || (!is_csi2 &&
-			     sensor_ep->bus.parallel.bus_width >= 16))) {
+	    (incc->bayer || is_parallel_16bit_bus(&upstream_ep))) {
 		v4l2_err(&priv->sd,
 			 "bayer/16-bit parallel buses must go to IDMAC pad\n");
 		ret = -EINVAL;
@@ -1071,12 +1103,8 @@ static void csi_try_crop(struct csi_priv *priv,
 			 struct v4l2_rect *crop,
 			 struct v4l2_subdev_pad_config *cfg,
 			 struct v4l2_mbus_framefmt *infmt,
-			 struct imx_media_subdev *sensor)
+			 struct v4l2_fwnode_endpoint *upstream_ep)
 {
-	struct v4l2_fwnode_endpoint *sensor_ep;
-
-	sensor_ep = &sensor->sensor_ep;
-
 	crop->width = min_t(__u32, infmt->width, crop->width);
 	if (crop->left + crop->width > infmt->width)
 		crop->left = infmt->width - crop->width;
@@ -1090,7 +1118,7 @@ static void csi_try_crop(struct csi_priv *priv,
 	 * sync, so fix it to NTSC/PAL active lines. NTSC contains
 	 * 2 extra lines of active video that need to be cropped.
 	 */
-	if (sensor_ep->bus_type == V4L2_MBUS_BT656 &&
+	if (upstream_ep->bus_type == V4L2_MBUS_BT656 &&
 	    (V4L2_FIELD_HAS_BOTH(infmt->field) ||
 	     infmt->field == V4L2_FIELD_ALTERNATE)) {
 		crop->height = infmt->height;
@@ -1240,7 +1268,7 @@ static int csi_get_fmt(struct v4l2_subdev *sd,
 }
 
 static void csi_try_fmt(struct csi_priv *priv,
-			struct imx_media_subdev *sensor,
+			struct v4l2_fwnode_endpoint *upstream_ep,
 			struct v4l2_subdev_pad_config *cfg,
 			struct v4l2_subdev_format *sdformat,
 			struct v4l2_rect *crop,
@@ -1308,7 +1336,7 @@ static void csi_try_fmt(struct csi_priv *priv,
 		crop->top = 0;
 		crop->width = sdformat->format.width;
 		crop->height = sdformat->format.height;
-		csi_try_crop(priv, crop, cfg, &sdformat->format, sensor);
+		csi_try_crop(priv, crop, cfg, &sdformat->format, upstream_ep);
 		compose->left = 0;
 		compose->top = 0;
 		compose->width = crop->width;
@@ -1337,20 +1365,20 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 	struct imx_media_video_dev *vdev = priv->vdev;
+	struct v4l2_fwnode_endpoint upstream_ep;
 	const struct imx_media_pixfmt *cc;
-	struct imx_media_subdev *sensor;
 	struct v4l2_pix_format vdev_fmt;
 	struct v4l2_mbus_framefmt *fmt;
 	struct v4l2_rect *crop, *compose;
-	int ret = 0;
+	int ret;
 
 	if (sdformat->pad >= CSI_NUM_PADS)
 		return -EINVAL;
 
-	sensor = imx_media_find_sensor(priv->md, &priv->sd.entity);
-	if (IS_ERR(sensor)) {
-		v4l2_err(&priv->sd, "no sensor attached\n");
-		return PTR_ERR(sensor);
+	ret = csi_get_upstream_endpoint(priv, &upstream_ep);
+	if (ret) {
+		v4l2_err(&priv->sd, "failed to find upstream endpoint\n");
+		return ret;
 	}
 
 	mutex_lock(&priv->lock);
@@ -1363,7 +1391,7 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 	crop = __csi_get_crop(priv, cfg, sdformat->which);
 	compose = __csi_get_compose(priv, cfg, sdformat->which);
 
-	csi_try_fmt(priv, sensor, cfg, sdformat, crop, compose, &cc);
+	csi_try_fmt(priv, &upstream_ep, cfg, sdformat, crop, compose, &cc);
 
 	fmt = __csi_get_fmt(priv, cfg, sdformat->pad, sdformat->which);
 	*fmt = sdformat->format;
@@ -1380,8 +1408,8 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 			format.pad = pad;
 			format.which = sdformat->which;
 			format.format = sdformat->format;
-			csi_try_fmt(priv, sensor, cfg, &format, NULL, compose,
-				    &outcc);
+			csi_try_fmt(priv, &upstream_ep, cfg, &format,
+				    NULL, compose, &outcc);
 
 			outfmt = __csi_get_fmt(priv, cfg, pad, sdformat->which);
 			*outfmt = format.format;
@@ -1476,18 +1504,18 @@ static int csi_set_selection(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_selection *sel)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_fwnode_endpoint upstream_ep;
 	struct v4l2_mbus_framefmt *infmt;
 	struct v4l2_rect *crop, *compose;
-	struct imx_media_subdev *sensor;
-	int pad, ret = 0;
+	int pad, ret;
 
 	if (sel->pad != CSI_SINK_PAD)
 		return -EINVAL;
 
-	sensor = imx_media_find_sensor(priv->md, &priv->sd.entity);
-	if (IS_ERR(sensor)) {
-		v4l2_err(&priv->sd, "no sensor attached\n");
-		return PTR_ERR(sensor);
+	ret = csi_get_upstream_endpoint(priv, &upstream_ep);
+	if (ret) {
+		v4l2_err(&priv->sd, "failed to find upstream endpoint\n");
+		return ret;
 	}
 
 	mutex_lock(&priv->lock);
@@ -1515,7 +1543,7 @@ static int csi_set_selection(struct v4l2_subdev *sd,
 			goto out;
 		}
 
-		csi_try_crop(priv, &sel->r, cfg, infmt, sensor);
+		csi_try_crop(priv, &sel->r, cfg, infmt, &upstream_ep);
 
 		*crop = sel->r;
 
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index b55e5eb..701f8c9 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -222,18 +222,6 @@ static int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
 		ret = imx_media_get_ipu(imxmd, sd);
 		if (ret)
 			goto out_unlock;
-	} else if (sd->entity.function == MEDIA_ENT_F_VID_MUX) {
-		/* this is a video mux */
-		sd->grp_id = IMX_MEDIA_GRP_ID_VIDMUX;
-	} else if (imxsd->num_sink_pads == 0) {
-		/*
-		 * this is an original source of video frames, it
-		 * could be a camera sensor, an analog decoder, or
-		 * a bridge device (HDMI -> MIPI CSI-2 for example).
-		 * This group ID is used to locate the entity that
-		 * is the original source of video in a pipeline.
-		 */
-		sd->grp_id = IMX_MEDIA_GRP_ID_SENSOR;
 	}
 
 	/* attach the subdev */
diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index 12df09f..883ad85 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -34,20 +34,6 @@ static int of_add_pad_link(struct imx_media_dev *imxmd,
 				      local_pad, remote_pad);
 }
 
-static void of_parse_sensor(struct imx_media_dev *imxmd,
-			    struct imx_media_subdev *sensor,
-			    struct device_node *sensor_np)
-{
-	struct device_node *endpoint;
-
-	endpoint = of_graph_get_next_endpoint(sensor_np, NULL);
-	if (endpoint) {
-		v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint),
-					   &sensor->sensor_ep);
-		of_node_put(endpoint);
-	}
-}
-
 static int of_get_port_count(const struct device_node *np)
 {
 	struct device_node *ports, *child;
@@ -172,13 +158,6 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 		__func__, sd_np->name, num_pads,
 		imxsd->num_sink_pads, imxsd->num_src_pads);
 
-	/*
-	 * With no sink, this subdev node is the original source
-	 * of video, parse it's media bus for use by the pipeline.
-	 */
-	if (imxsd->num_sink_pads == 0)
-		of_parse_sensor(imxmd, imxsd, sd_np);
-
 	for (i = 0; i < num_pads; i++) {
 		struct device_node *epnode = NULL, *port, *remote_np;
 		struct imx_media_subdev *remote_imxsd;
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 5952387..51d7e18 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -730,10 +730,11 @@ int imx_media_add_video_device(struct imx_media_dev *imxmd,
 EXPORT_SYMBOL_GPL(imx_media_add_video_device);
 
 /*
- * Search upstream or downstream for a subdevice in the current pipeline
+ * Search upstream/downstream for a subdevice in the current pipeline
  * with given grp_id, starting from start_entity. Returns the subdev's
- * source/sink pad that it was reached from. Must be called with
- * mdev->graph_mutex held.
+ * source/sink pad that it was reached from. If grp_id is zero, just
+ * returns the nearest source/sink pad to start_entity. Must be called
+ * with mdev->graph_mutex held.
  */
 static struct media_pad *
 find_pipeline_pad(struct imx_media_dev *imxmd,
@@ -756,11 +757,16 @@ find_pipeline_pad(struct imx_media_dev *imxmd,
 		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
 			continue;
 
-		sd = media_entity_to_v4l2_subdev(pad->entity);
-		if (sd->grp_id & grp_id)
-			return pad;
+		if (grp_id != 0) {
+			sd = media_entity_to_v4l2_subdev(pad->entity);
+			if (sd->grp_id & grp_id)
+				return pad;
 
-		return find_pipeline_pad(imxmd, pad->entity, grp_id, upstream);
+			return find_pipeline_pad(imxmd, pad->entity,
+						 grp_id, upstream);
+		} else {
+			return pad;
+		}
 	}
 
 	return NULL;
@@ -789,7 +795,6 @@ find_upstream_subdev(struct imx_media_dev *imxmd,
 	return pad ? media_entity_to_v4l2_subdev(pad->entity) : NULL;
 }
 
-
 /*
  * Find the upstream mipi-csi2 virtual channel reached from the given
  * start entity in the current pipeline.
@@ -814,6 +819,25 @@ int imx_media_find_mipi_csi2_channel(struct imx_media_dev *imxmd,
 EXPORT_SYMBOL_GPL(imx_media_find_mipi_csi2_channel);
 
 /*
+ * Find a source pad reached upstream from the given start entity in
+ * the current pipeline. Must be called with mdev->graph_mutex held.
+ */
+struct media_pad *
+imx_media_find_upstream_pad(struct imx_media_dev *imxmd,
+			    struct media_entity *start_entity,
+			    u32 grp_id)
+{
+	struct media_pad *pad;
+
+	pad = find_pipeline_pad(imxmd, start_entity, grp_id, true);
+	if (!pad)
+		return ERR_PTR(-ENODEV);
+
+	return pad;
+}
+EXPORT_SYMBOL_GPL(imx_media_find_upstream_pad);
+
+/*
  * Find a subdev reached upstream from the given start entity in
  * the current pipeline.
  * Must be called with mdev->graph_mutex held.
@@ -833,29 +857,6 @@ imx_media_find_upstream_subdev(struct imx_media_dev *imxmd,
 }
 EXPORT_SYMBOL_GPL(imx_media_find_upstream_subdev);
 
-struct imx_media_subdev *
-__imx_media_find_sensor(struct imx_media_dev *imxmd,
-			struct media_entity *start_entity)
-{
-	return imx_media_find_upstream_subdev(imxmd, start_entity,
-					      IMX_MEDIA_GRP_ID_SENSOR);
-}
-EXPORT_SYMBOL_GPL(__imx_media_find_sensor);
-
-struct imx_media_subdev *
-imx_media_find_sensor(struct imx_media_dev *imxmd,
-		      struct media_entity *start_entity)
-{
-	struct imx_media_subdev *sensor;
-
-	mutex_lock(&imxmd->md.graph_mutex);
-	sensor = __imx_media_find_sensor(imxmd, start_entity);
-	mutex_unlock(&imxmd->md.graph_mutex);
-
-	return sensor;
-}
-EXPORT_SYMBOL_GPL(imx_media_find_sensor);
-
 /*
  * Turn current pipeline streaming on/off starting from entity.
  */
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index d409170..17422f9 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -158,9 +158,6 @@ struct imx_media_subdev {
 	struct platform_device *pdev;
 	/* the devname is needed for async devname match */
 	char devname[32];
-
-	/* if this is a sensor */
-	struct v4l2_fwnode_endpoint sensor_ep;
 };
 
 struct imx_media_dev {
@@ -251,16 +248,14 @@ int imx_media_add_video_device(struct imx_media_dev *imxmd,
 			       struct imx_media_video_dev *vdev);
 int imx_media_find_mipi_csi2_channel(struct imx_media_dev *imxmd,
 				     struct media_entity *start_entity);
+struct media_pad *
+imx_media_find_upstream_pad(struct imx_media_dev *imxmd,
+			    struct media_entity *start_entity,
+			    u32 grp_id);
 struct imx_media_subdev *
 imx_media_find_upstream_subdev(struct imx_media_dev *imxmd,
 			       struct media_entity *start_entity,
 			       u32 grp_id);
-struct imx_media_subdev *
-__imx_media_find_sensor(struct imx_media_dev *imxmd,
-			struct media_entity *start_entity);
-struct imx_media_subdev *
-imx_media_find_sensor(struct imx_media_dev *imxmd,
-		      struct media_entity *start_entity);
 
 struct imx_media_dma_buf {
 	void          *virt;
@@ -310,16 +305,14 @@ void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
 void imx_media_capture_device_error(struct imx_media_video_dev *vdev);
 
 /* subdev group ids */
-#define IMX_MEDIA_GRP_ID_SENSOR    (1 << 8)
-#define IMX_MEDIA_GRP_ID_VIDMUX    (1 << 9)
-#define IMX_MEDIA_GRP_ID_CSI2      (1 << 10)
-#define IMX_MEDIA_GRP_ID_CSI_BIT   11
+#define IMX_MEDIA_GRP_ID_CSI2      (1 << 8)
+#define IMX_MEDIA_GRP_ID_CSI_BIT   9
 #define IMX_MEDIA_GRP_ID_CSI       (0x3 << IMX_MEDIA_GRP_ID_CSI_BIT)
 #define IMX_MEDIA_GRP_ID_CSI0      (1 << IMX_MEDIA_GRP_ID_CSI_BIT)
 #define IMX_MEDIA_GRP_ID_CSI1      (2 << IMX_MEDIA_GRP_ID_CSI_BIT)
-#define IMX_MEDIA_GRP_ID_VDIC      (1 << 13)
-#define IMX_MEDIA_GRP_ID_IC_PRP    (1 << 14)
-#define IMX_MEDIA_GRP_ID_IC_PRPENC (1 << 15)
-#define IMX_MEDIA_GRP_ID_IC_PRPVF  (1 << 16)
+#define IMX_MEDIA_GRP_ID_VDIC      (1 << 11)
+#define IMX_MEDIA_GRP_ID_IC_PRP    (1 << 12)
+#define IMX_MEDIA_GRP_ID_IC_PRPENC (1 << 13)
+#define IMX_MEDIA_GRP_ID_IC_PRPVF  (1 << 14)
 
 #endif
-- 
2.7.4
