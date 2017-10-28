Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:45747 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751822AbdJ1UlH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 16:41:07 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 3/9] media: staging/imx: of: allow for recursing downstream
Date: Sat, 28 Oct 2017 13:36:43 -0700
Message-Id: <1509223009-6392-4-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
References: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calling of_parse_subdev() recursively to a downstream path that has
already been followed is ok, it just means that call will return
immediately since the subdevice was already added to the async list.

With that there is no need to determine whether a subdevice's port
is a sink or source, so 'num_{sink|src}_pads' is no longer used and
is removed.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-internal-sd.c | 17 -----
 drivers/staging/media/imx/imx-media-of.c          | 78 ++++++-----------------
 drivers/staging/media/imx/imx-media.h             | 14 ----
 3 files changed, 21 insertions(+), 88 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
index 3e60df5..53f2383 100644
--- a/drivers/staging/media/imx/imx-media-internal-sd.c
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -78,13 +78,9 @@ struct internal_pad {
 static const struct internal_subdev {
 	const struct internal_subdev_id *id;
 	struct internal_pad pad[IMX_MEDIA_MAX_PADS];
-	int num_sink_pads;
-	int num_src_pads;
 } int_subdev[num_isd] = {
 	[isd_csi0] = {
 		.id = &isd_id[isd_csi0],
-		.num_sink_pads = CSI_NUM_SINK_PADS,
-		.num_src_pads = CSI_NUM_SRC_PADS,
 		.pad[CSI_SRC_PAD_DIRECT] = {
 			.link = {
 				{
@@ -102,8 +98,6 @@ static const struct internal_subdev {
 
 	[isd_csi1] = {
 		.id = &isd_id[isd_csi1],
-		.num_sink_pads = CSI_NUM_SINK_PADS,
-		.num_src_pads = CSI_NUM_SRC_PADS,
 		.pad[CSI_SRC_PAD_DIRECT] = {
 			.link = {
 				{
@@ -121,8 +115,6 @@ static const struct internal_subdev {
 
 	[isd_vdic] = {
 		.id = &isd_id[isd_vdic],
-		.num_sink_pads = VDIC_NUM_SINK_PADS,
-		.num_src_pads = VDIC_NUM_SRC_PADS,
 		.pad[VDIC_SRC_PAD_DIRECT] = {
 			.link = {
 				{
@@ -136,8 +128,6 @@ static const struct internal_subdev {
 
 	[isd_ic_prp] = {
 		.id = &isd_id[isd_ic_prp],
-		.num_sink_pads = PRP_NUM_SINK_PADS,
-		.num_src_pads = PRP_NUM_SRC_PADS,
 		.pad[PRP_SRC_PAD_PRPENC] = {
 			.link = {
 				{
@@ -160,14 +150,10 @@ static const struct internal_subdev {
 
 	[isd_ic_prpenc] = {
 		.id = &isd_id[isd_ic_prpenc],
-		.num_sink_pads = PRPENCVF_NUM_SINK_PADS,
-		.num_src_pads = PRPENCVF_NUM_SRC_PADS,
 	},
 
 	[isd_ic_prpvf] = {
 		.id = &isd_id[isd_ic_prpvf],
-		.num_sink_pads = PRPENCVF_NUM_SINK_PADS,
-		.num_src_pads = PRPENCVF_NUM_SRC_PADS,
 	},
 };
 
@@ -312,9 +298,6 @@ static int add_internal_subdev(struct imx_media_dev *imxmd,
 	if (IS_ERR(imxsd))
 		return PTR_ERR(imxsd);
 
-	imxsd->num_sink_pads = isd->num_sink_pads;
-	imxsd->num_src_pads = isd->num_src_pads;
-
 	return 0;
 }
 
diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index d35c99e..a085e52 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -41,11 +41,12 @@ static int of_get_port_count(const struct device_node *np)
 /*
  * find the remote device node given local endpoint node
  */
-static void of_get_remote(struct device_node *epnode,
+static bool of_get_remote(struct device_node *epnode,
 			  struct device_node **remote_node)
 {
 	struct device_node *rp, *rpp;
 	struct device_node *remote;
+	bool is_csi_port;
 
 	rp = of_graph_get_remote_port(epnode);
 	rpp = of_graph_get_remote_port_parent(epnode);
@@ -54,9 +55,11 @@ static void of_get_remote(struct device_node *epnode,
 		/* the remote is one of the CSI ports */
 		remote = rp;
 		of_node_put(rpp);
+		is_csi_port = true;
 	} else {
 		remote = rpp;
 		of_node_put(rp);
+		is_csi_port = false;
 	}
 
 	if (!of_device_is_available(remote)) {
@@ -65,6 +68,8 @@ static void of_get_remote(struct device_node *epnode,
 	} else {
 		*remote_node = remote;
 	}
+
+	return is_csi_port;
 }
 
 static int
@@ -72,7 +77,7 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 		bool is_csi_port)
 {
 	struct imx_media_subdev *imxsd;
-	int i, num_pads, ret;
+	int i, num_ports, ret;
 
 	if (!of_device_is_available(sd_np)) {
 		dev_dbg(imxmd->md.dev, "%s: %s not enabled\n", __func__,
@@ -94,77 +99,36 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 		return ret;
 	}
 
-	if (is_csi_port) {
-		/*
-		 * the ipu-csi has one sink port and two source ports.
-		 * The source ports are not represented in the device tree,
-		 * but are described by the internal pads and links later.
-		 */
-		num_pads = CSI_NUM_PADS;
-		imxsd->num_sink_pads = CSI_NUM_SINK_PADS;
-	} else if (of_device_is_compatible(sd_np, "fsl,imx6-mipi-csi2")) {
-		num_pads = of_get_port_count(sd_np);
-		/* the mipi csi2 receiver has only one sink port */
-		imxsd->num_sink_pads = 1;
-	} else if (of_device_is_compatible(sd_np, "video-mux")) {
-		num_pads = of_get_port_count(sd_np);
-		/* for the video mux, all but the last port are sinks */
-		imxsd->num_sink_pads = num_pads - 1;
-	} else {
-		num_pads = of_get_port_count(sd_np);
-		if (num_pads != 1) {
-			/* confused, but no reason to give up here */
-			dev_warn(imxmd->md.dev,
-				 "%s: unknown device %s with %d ports\n",
-				 __func__, sd_np->name, num_pads);
-			return 0;
-		}
+	/*
+	 * the ipu-csi has one sink port. The source pads are not
+	 * represented in the device tree by port nodes, but are
+	 * described by the internal pads and links later.
+	 */
+	num_ports = is_csi_port ? 1 : of_get_port_count(sd_np);
 
-		/*
-		 * we got to this node from this single source port,
-		 * there are no sink pads.
-		 */
-		imxsd->num_sink_pads = 0;
-	}
-
-	if (imxsd->num_sink_pads >= num_pads)
-		return -EINVAL;
-
-	imxsd->num_src_pads = num_pads - imxsd->num_sink_pads;
-
-	dev_dbg(imxmd->md.dev, "%s: %s has %d pads (%d sink, %d src)\n",
-		__func__, sd_np->name, num_pads,
-		imxsd->num_sink_pads, imxsd->num_src_pads);
-
-	for (i = 0; i < num_pads; i++) {
+	for (i = 0; i < num_ports; i++) {
 		struct device_node *epnode = NULL, *port, *remote_np;
 
-		if (is_csi_port)
-			port = (i < imxsd->num_sink_pads) ? sd_np : NULL;
-		else
-			port = of_graph_get_port_by_id(sd_np, i);
+		port = is_csi_port ? sd_np : of_graph_get_port_by_id(sd_np, i);
 		if (!port)
 			continue;
 
 		for_each_child_of_node(port, epnode) {
-			of_get_remote(epnode, &remote_np);
+			bool remote_is_csi;
+
+			remote_is_csi = of_get_remote(epnode, &remote_np);
 			if (!remote_np)
 				continue;
 
-			if (i < imxsd->num_sink_pads) {
-				/* follow sink endpoints upstream */
-				ret = of_parse_subdev(imxmd, remote_np, false);
-				if (ret)
-					break;
-			}
-
+			ret = of_parse_subdev(imxmd, remote_np, remote_is_csi);
 			of_node_put(remote_np);
+			if (ret)
+				break;
 		}
 
 		if (port != sd_np)
 			of_node_put(port);
 		if (ret) {
-			of_node_put(remote_np);
 			of_node_put(epnode);
 			break;
 		}
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index 6c0e443..925b46b 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -49,9 +49,6 @@ enum {
 	CSI_NUM_PADS,
 };
 
-#define CSI_NUM_SINK_PADS 1
-#define CSI_NUM_SRC_PADS  2
-
 /* ipu_vdic */
 enum {
 	VDIC_SINK_PAD_DIRECT = 0,
@@ -60,9 +57,6 @@ enum {
 	VDIC_NUM_PADS,
 };
 
-#define VDIC_NUM_SINK_PADS 2
-#define VDIC_NUM_SRC_PADS  1
-
 /* ipu_ic_prp */
 enum {
 	PRP_SINK_PAD = 0,
@@ -71,9 +65,6 @@ enum {
 	PRP_NUM_PADS,
 };
 
-#define PRP_NUM_SINK_PADS 1
-#define PRP_NUM_SRC_PADS  2
-
 /* ipu_ic_prpencvf */
 enum {
 	PRPENCVF_SINK_PAD = 0,
@@ -81,9 +72,6 @@ enum {
 	PRPENCVF_NUM_PADS,
 };
 
-#define PRPENCVF_NUM_SINK_PADS 1
-#define PRPENCVF_NUM_SRC_PADS  1
-
 /* How long to wait for EOF interrupts in the buffer-capture subdevs */
 #define IMX_MEDIA_EOF_TIMEOUT       1000
 
@@ -137,8 +125,6 @@ struct imx_media_subdev {
 	struct v4l2_subdev       *sd; /* set when bound */
 
 	struct imx_media_pad     pad[IMX_MEDIA_MAX_PADS];
-	int num_sink_pads;
-	int num_src_pads;
 
 	/* the platform device if this is an IPU-internal subdev */
 	struct platform_device *pdev;
-- 
2.7.4
