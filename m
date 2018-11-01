Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:40444 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728380AbeKBIiW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 04:38:22 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 30/30] rcar-csi2: expose the subdevice internal routing
Date: Fri,  2 Nov 2018 00:31:44 +0100
Message-Id: <20181101233144.31507-31-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Expose the subdevice internal routing from the single multiplexed sink
pad to its source pads by implementing .get_routing(). This information
is used to do link validation at stream start and allows user-space to
view the route configuration.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 53 +++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 00564c969dd021db..f51b6fbc6042ac1d 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -342,6 +342,14 @@ static int rcsi2_pad_to_vc(unsigned int pad)
 	return pad - RCAR_CSI2_SOURCE_VC0;
 }
 
+static int rcsi2_vc_to_pad(unsigned int vc)
+{
+	if (vc > 3)
+		return -EINVAL;
+
+	return vc + RCAR_CSI2_SOURCE_VC0;
+}
+
 struct rcar_csi2_info {
 	int (*init_phtw)(struct rcar_csi2 *priv, unsigned int mbps);
 	int (*confirm_start)(struct rcar_csi2 *priv);
@@ -705,9 +713,54 @@ static const struct v4l2_subdev_video_ops rcar_csi2_video_ops = {
 	.s_stream = rcsi2_s_stream,
 };
 
+static int rcsi2_get_routing(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_routing *routing)
+{
+	struct rcar_csi2 *priv = sd_to_csi2(sd);
+	struct v4l2_mbus_frame_desc fd;
+	struct v4l2_subdev_route *r = routing->routes;
+	unsigned int i;
+	int ret;
+
+	/* Get information about multiplexed link */
+	ret = rcsi2_get_remote_frame_desc(priv, &fd);
+	if (ret)
+		return ret;
+
+	if (routing->num_routes < fd.num_entries) {
+		routing->num_routes = fd.num_entries;
+		return -ENOSPC;
+	}
+
+	routing->num_routes = fd.num_entries;
+
+	for (i = 0; i < fd.num_entries; i++) {
+		struct v4l2_mbus_frame_desc_entry *entry = &fd.entry[i];
+		int source_pad;
+
+		source_pad = rcsi2_vc_to_pad(entry->bus.csi2.channel);
+		if (source_pad < 0) {
+			dev_err(priv->dev, "Virtual Channel out of range: %u\n",
+				entry->bus.csi2.channel);
+			return -ENOSPC;
+		}
+
+		r->sink_pad = RCAR_CSI2_SINK;
+		r->sink_stream = entry->stream;
+		r->source_pad = source_pad;
+		r->source_stream = 0;
+		r->flags = V4L2_SUBDEV_ROUTE_FL_ACTIVE |
+			V4L2_SUBDEV_ROUTE_FL_IMMUTABLE;
+		r++;
+	}
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops rcar_csi2_pad_ops = {
 	.set_fmt = rcsi2_set_pad_format,
 	.get_fmt = rcsi2_get_pad_format,
+	.get_routing = rcsi2_get_routing,
 };
 
 static const struct v4l2_subdev_ops rcar_csi2_subdev_ops = {
-- 
2.19.1
