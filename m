Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:47156 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751460AbdJ1UlG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 16:41:06 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 2/9] media: staging/imx: remove static media link arrays
Date: Sat, 28 Oct 2017 13:36:42 -0700
Message-Id: <1509223009-6392-3-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
References: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the static list of media links that were formed at probe time.
These links can instead be created after all registered async subdevices
have been bound in imx_media_probe_complete().

The media links between subdevices that exist in the device tree, can
be created post-async completion by using v4l2_fwnode_parse_link() for
each endpoint node of that subdevice. Note this approach assumes
device-tree ports are equivalent to media pads (pad index equals
port id), and that device-tree endpoints are equivalent to media
links between pads.

Because links are no longer parsed by imx_media_of_parse(), its sole
function is now only to add subdevices that it encounters by walking
the OF graph to the async list, so the function has been renamed
imx_media_add_of_subdevs().

Similarly, the media links between the IPU-internal subdevice pads (the
CSI source pads, and all pads between the vdic, ic-prp, ic-prpenc, and
ic-prpvf subdevices), can be created post-async completion by looping
through the subdevice's media pads and using the const internal_subdev
table.

Because links are no longer parsed by imx_media_add_internal_subdevs(),
this function no longer needs an array of CSI subdevs to form links
from.

In summary, the following functions, which were used to form a list
of media links at probe time, are removed:

imx_media_add_pad_link()
add_internal_links()
of_add_pad_link()

replaced by these functions, called at probe time, which only populate
the async subdev list:

imx_media_add_of_subdevs()
imx_media_add_internal_subdevs()

and these functions, called at async completion, which create the
media links:

imx_media_create_of_links()
imx_media_create_csi_of_links()
imx_media_create_internal_links()

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-dev.c         | 130 +++----------
 drivers/staging/media/imx/imx-media-internal-sd.c | 219 +++++++++++++---------
 drivers/staging/media/imx/imx-media-of.c          | 189 ++++++++++++-------
 drivers/staging/media/imx/imx-media.h             |  39 +---
 4 files changed, 281 insertions(+), 296 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 701f8c9..f63808f 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/fs.h>
 #include <linux/module.h>
+#include <linux/of_graph.h>
 #include <linux/of_platform.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
@@ -128,50 +129,6 @@ imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 }
 
 /*
- * Adds an imx-media link to a subdev pad's link list. This is called
- * during driver load when forming the links between subdevs.
- *
- * @pad: the local pad
- * @remote_node: the device node of the remote subdev
- * @remote_devname: the device name of the remote subdev
- * @local_pad: local pad index
- * @remote_pad: remote pad index
- */
-int imx_media_add_pad_link(struct imx_media_dev *imxmd,
-			   struct imx_media_pad *pad,
-			   struct device_node *remote_node,
-			   const char *remote_devname,
-			   int local_pad, int remote_pad)
-{
-	struct imx_media_link *link;
-	int link_idx, ret = 0;
-
-	mutex_lock(&imxmd->mutex);
-
-	link_idx = pad->num_links;
-	if (link_idx >= IMX_MEDIA_MAX_LINKS) {
-		dev_err(imxmd->md.dev, "%s: too many links!\n", __func__);
-		ret = -ENOSPC;
-		goto out;
-	}
-
-	link = &pad->link[link_idx];
-
-	link->remote_sd_node = remote_node;
-	if (remote_devname)
-		strncpy(link->remote_devname, remote_devname,
-			sizeof(link->remote_devname));
-
-	link->local_pad = local_pad;
-	link->remote_pad = remote_pad;
-
-	pad->num_links++;
-out:
-	mutex_unlock(&imxmd->mutex);
-	return ret;
-}
-
-/*
  * get IPU from this CSI and add it to the list of IPUs
  * the media driver will control.
  */
@@ -240,76 +197,38 @@ static int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
 }
 
 /*
- * Create a single source->sink media link given a subdev and a single
- * link from one of its source pads. Called after all subdevs have
- * registered.
- */
-static int imx_media_create_link(struct imx_media_dev *imxmd,
-				 struct imx_media_subdev *src,
-				 struct imx_media_link *link)
-{
-	struct imx_media_subdev *sink;
-	u16 source_pad, sink_pad;
-	int ret;
-
-	sink = imx_media_find_async_subdev(imxmd, link->remote_sd_node,
-					   link->remote_devname);
-	if (!sink) {
-		v4l2_warn(&imxmd->v4l2_dev, "%s: no sink for %s:%d\n",
-			  __func__, src->sd->name, link->local_pad);
-		return 0;
-	}
-
-	source_pad = link->local_pad;
-	sink_pad = link->remote_pad;
-
-	v4l2_info(&imxmd->v4l2_dev, "%s: %s:%d -> %s:%d\n", __func__,
-		  src->sd->name, source_pad, sink->sd->name, sink_pad);
-
-	ret = media_create_pad_link(&src->sd->entity, source_pad,
-				    &sink->sd->entity, sink_pad, 0);
-	if (ret)
-		v4l2_err(&imxmd->v4l2_dev,
-			 "create_pad_link failed: %d\n", ret);
-
-	return ret;
-}
-
-/*
- * create the media links from all imx-media pads and their links.
+ * create the media links from all pads and their links.
  * Called after all subdevs have registered.
  */
 static int imx_media_create_links(struct imx_media_dev *imxmd)
 {
 	struct imx_media_subdev *imxsd;
-	struct imx_media_link *link;
-	struct imx_media_pad *pad;
-	int num_pads, i, j, k;
-	int ret = 0;
+	struct v4l2_subdev *sd;
+	int i, ret;
 
 	for (i = 0; i < imxmd->num_subdevs; i++) {
 		imxsd = &imxmd->subdev[i];
-		num_pads = imxsd->num_sink_pads + imxsd->num_src_pads;
-
-		for (j = 0; j < num_pads; j++) {
-			pad = &imxsd->pad[j];
-
-			/* only create the source->sink links */
-			if (!(pad->pad.flags & MEDIA_PAD_FL_SOURCE))
-				continue;
-
-			for (k = 0; k < pad->num_links; k++) {
-				link = &pad->link[k];
+		sd = imxsd->sd;
 
-				ret = imx_media_create_link(imxmd, imxsd, link);
-				if (ret)
-					goto out;
-			}
+		if (((sd->grp_id & IMX_MEDIA_GRP_ID_CSI) || imxsd->pdev)) {
+			/* this is an internal subdev or a CSI */
+			ret = imx_media_create_internal_links(imxmd, imxsd);
+			if (ret)
+				return ret;
+			/*
+			 * the CSIs straddle between the external and the IPU
+			 * internal entities, so create the external links
+			 * to the CSI sink pads.
+			 */
+			if (sd->grp_id & IMX_MEDIA_GRP_ID_CSI)
+				imx_media_create_csi_of_links(imxmd, imxsd);
+		} else {
+			/* this is an external fwnode subdev */
+			imx_media_create_of_links(imxmd, imxsd);
 		}
 	}
 
-out:
-	return ret;
+	return 0;
 }
 
 /*
@@ -542,7 +461,6 @@ static int imx_media_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *node = dev->of_node;
-	struct imx_media_subdev *csi[4] = {0};
 	struct imx_media_dev *imxmd;
 	int ret;
 
@@ -573,14 +491,14 @@ static int imx_media_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(imxmd->v4l2_dev.dev, imxmd);
 
-	ret = imx_media_of_parse(imxmd, &csi, node);
+	ret = imx_media_add_of_subdevs(imxmd, node);
 	if (ret) {
 		v4l2_err(&imxmd->v4l2_dev,
-			 "imx_media_of_parse failed with %d\n", ret);
+			 "add_of_subdevs failed with %d\n", ret);
 		goto unreg_dev;
 	}
 
-	ret = imx_media_add_internal_subdevs(imxmd, csi);
+	ret = imx_media_add_internal_subdevs(imxmd);
 	if (ret) {
 		v4l2_err(&imxmd->v4l2_dev,
 			 "add_internal_subdevs failed with %d\n", ret);
diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
index cdfbf40..3e60df5 100644
--- a/drivers/staging/media/imx/imx-media-internal-sd.c
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -60,14 +60,19 @@ static const struct internal_subdev_id {
 	},
 };
 
+struct internal_subdev;
+
 struct internal_link {
-	const struct internal_subdev_id *remote_id;
+	const struct internal_subdev *remote;
+	int local_pad;
 	int remote_pad;
 };
 
+/* max links per internal-sd pad */
+#define MAX_INTERNAL_LINKS  8
+
 struct internal_pad {
-	bool devnode; /* does this pad link to a device node */
-	struct internal_link link[IMX_MEDIA_MAX_LINKS];
+	struct internal_link link[MAX_INTERNAL_LINKS];
 };
 
 static const struct internal_subdev {
@@ -75,7 +80,7 @@ static const struct internal_subdev {
 	struct internal_pad pad[IMX_MEDIA_MAX_PADS];
 	int num_sink_pads;
 	int num_src_pads;
-} internal_subdev[num_isd] = {
+} int_subdev[num_isd] = {
 	[isd_csi0] = {
 		.id = &isd_id[isd_csi0],
 		.num_sink_pads = CSI_NUM_SINK_PADS,
@@ -83,17 +88,16 @@ static const struct internal_subdev {
 		.pad[CSI_SRC_PAD_DIRECT] = {
 			.link = {
 				{
-					.remote_id = &isd_id[isd_ic_prp],
+					.local_pad = CSI_SRC_PAD_DIRECT,
+					.remote = &int_subdev[isd_ic_prp],
 					.remote_pad = PRP_SINK_PAD,
 				}, {
-					.remote_id =  &isd_id[isd_vdic],
+					.local_pad = CSI_SRC_PAD_DIRECT,
+					.remote = &int_subdev[isd_vdic],
 					.remote_pad = VDIC_SINK_PAD_DIRECT,
 				},
 			},
 		},
-		.pad[CSI_SRC_PAD_IDMAC] = {
-			.devnode = true,
-		},
 	},
 
 	[isd_csi1] = {
@@ -103,30 +107,27 @@ static const struct internal_subdev {
 		.pad[CSI_SRC_PAD_DIRECT] = {
 			.link = {
 				{
-					.remote_id = &isd_id[isd_ic_prp],
+					.local_pad = CSI_SRC_PAD_DIRECT,
+					.remote = &int_subdev[isd_ic_prp],
 					.remote_pad = PRP_SINK_PAD,
 				}, {
-					.remote_id =  &isd_id[isd_vdic],
+					.local_pad = CSI_SRC_PAD_DIRECT,
+					.remote = &int_subdev[isd_vdic],
 					.remote_pad = VDIC_SINK_PAD_DIRECT,
 				},
 			},
 		},
-		.pad[CSI_SRC_PAD_IDMAC] = {
-			.devnode = true,
-		},
 	},
 
 	[isd_vdic] = {
 		.id = &isd_id[isd_vdic],
 		.num_sink_pads = VDIC_NUM_SINK_PADS,
 		.num_src_pads = VDIC_NUM_SRC_PADS,
-		.pad[VDIC_SINK_PAD_IDMAC] = {
-			.devnode = true,
-		},
 		.pad[VDIC_SRC_PAD_DIRECT] = {
 			.link = {
 				{
-					.remote_id =  &isd_id[isd_ic_prp],
+					.local_pad = VDIC_SRC_PAD_DIRECT,
+					.remote = &int_subdev[isd_ic_prp],
 					.remote_pad = PRP_SINK_PAD,
 				},
 			},
@@ -140,7 +141,8 @@ static const struct internal_subdev {
 		.pad[PRP_SRC_PAD_PRPENC] = {
 			.link = {
 				{
-					.remote_id = &isd_id[isd_ic_prpenc],
+					.local_pad = PRP_SRC_PAD_PRPENC,
+					.remote = &int_subdev[isd_ic_prpenc],
 					.remote_pad = 0,
 				},
 			},
@@ -148,7 +150,8 @@ static const struct internal_subdev {
 		.pad[PRP_SRC_PAD_PRPVF] = {
 			.link = {
 				{
-					.remote_id = &isd_id[isd_ic_prpvf],
+					.local_pad = PRP_SRC_PAD_PRPVF,
+					.remote = &int_subdev[isd_ic_prpvf],
 					.remote_pad = 0,
 				},
 			},
@@ -159,68 +162,114 @@ static const struct internal_subdev {
 		.id = &isd_id[isd_ic_prpenc],
 		.num_sink_pads = PRPENCVF_NUM_SINK_PADS,
 		.num_src_pads = PRPENCVF_NUM_SRC_PADS,
-		.pad[PRPENCVF_SRC_PAD] = {
-			.devnode = true,
-		},
 	},
 
 	[isd_ic_prpvf] = {
 		.id = &isd_id[isd_ic_prpvf],
 		.num_sink_pads = PRPENCVF_NUM_SINK_PADS,
 		.num_src_pads = PRPENCVF_NUM_SRC_PADS,
-		.pad[PRPENCVF_SRC_PAD] = {
-			.devnode = true,
-		},
 	},
 };
 
-/* form a device name given a group id and ipu id */
-static inline void isd_id_to_devname(char *devname, int sz,
-				     const struct internal_subdev_id *id,
-				     int ipu_id)
+/* form a device name given an internal subdev and ipu id */
+static inline void isd_to_devname(char *devname, int sz,
+				  const struct internal_subdev *isd,
+				  int ipu_id)
 {
-	int pdev_id = ipu_id * num_isd + id->index;
+	int pdev_id = ipu_id * num_isd + isd->id->index;
 
-	snprintf(devname, sz, "%s.%d", id->name, pdev_id);
+	snprintf(devname, sz, "%s.%d", isd->id->name, pdev_id);
 }
 
-/* adds the links from given internal subdev */
-static int add_internal_links(struct imx_media_dev *imxmd,
-			      const struct internal_subdev *isd,
-			      struct imx_media_subdev *imxsd,
-			      int ipu_id)
+static const struct internal_subdev *find_intsd_by_grp_id(u32 grp_id)
 {
-	int i, num_pads, ret;
+	enum isd_enum i;
+
+	for (i = 0; i < num_isd; i++) {
+		const struct internal_subdev *isd = &int_subdev[i];
 
-	num_pads = isd->num_sink_pads + isd->num_src_pads;
+		if (isd->id->grp_id == grp_id)
+			return isd;
+	}
 
-	for (i = 0; i < num_pads; i++) {
-		const struct internal_pad *intpad = &isd->pad[i];
-		struct imx_media_pad *pad = &imxsd->pad[i];
-		int j;
+	return NULL;
+}
 
-		/* init the pad flags for this internal subdev */
-		pad->pad.flags = (i < isd->num_sink_pads) ?
-			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
-		/* export devnode pad flag to the subdevs */
-		pad->devnode = intpad->devnode;
+static struct imx_media_subdev *find_sink(struct imx_media_dev *imxmd,
+					  struct imx_media_subdev *src,
+					  const struct internal_link *link)
+{
+	char sink_devname[32];
+	int ipu_id;
+
+	/*
+	 * retrieve IPU id from subdev name, note: can't get this from
+	 * struct imx_media_internal_sd_platformdata because if src is
+	 * a CSI, it has different struct ipu_client_platformdata which
+	 * does not contain IPU id.
+	 */
+	if (sscanf(src->sd->name, "ipu%d", &ipu_id) != 1)
+		return NULL;
+
+	isd_to_devname(sink_devname, sizeof(sink_devname),
+		       link->remote, ipu_id - 1);
+
+	return imx_media_find_async_subdev(imxmd, NULL, sink_devname);
+}
 
-		for (j = 0; ; j++) {
-			const struct internal_link *link;
-			char remote_devname[32];
+static int create_ipu_internal_link(struct imx_media_dev *imxmd,
+				    struct imx_media_subdev *src,
+				    const struct internal_link *link)
+{
+	struct imx_media_subdev *sink;
+	int ret;
+
+	sink = find_sink(imxmd, src, link);
+	if (!sink)
+		return -ENODEV;
 
+	v4l2_info(&imxmd->v4l2_dev, "%s:%d -> %s:%d\n",
+		  src->sd->name, link->local_pad,
+		  sink->sd->name, link->remote_pad);
+
+	ret = media_create_pad_link(&src->sd->entity, link->local_pad,
+				    &sink->sd->entity, link->remote_pad, 0);
+	if (ret)
+		v4l2_err(&imxmd->v4l2_dev,
+			 "create_pad_link failed: %d\n", ret);
+
+	return ret;
+}
+
+int imx_media_create_internal_links(struct imx_media_dev *imxmd,
+				    struct imx_media_subdev *imxsd)
+{
+	struct v4l2_subdev *sd = imxsd->sd;
+	const struct internal_subdev *intsd;
+	const struct internal_pad *intpad;
+	const struct internal_link *link;
+	struct media_pad *pad;
+	int i, j, ret;
+
+	intsd = find_intsd_by_grp_id(imxsd->sd->grp_id);
+	if (!intsd)
+		return -ENODEV;
+
+	/* create the source->sink links */
+	for (i = 0; i < sd->entity.num_pads; i++) {
+		intpad = &intsd->pad[i];
+		pad = &sd->entity.pads[i];
+
+		if (!(pad->flags & MEDIA_PAD_FL_SOURCE))
+			continue;
+
+		for (j = 0; ; j++) {
 			link = &intpad->link[j];
 
-			if (!link->remote_id)
+			if (!link->remote)
 				break;
 
-			isd_id_to_devname(remote_devname,
-					  sizeof(remote_devname),
-					  link->remote_id, ipu_id);
-
-			ret = imx_media_add_pad_link(imxmd, pad,
-						     NULL, remote_devname,
-						     i, link->remote_pad);
+			ret = create_ipu_internal_link(imxmd, imxsd, link);
 			if (ret)
 				return ret;
 		}
@@ -230,10 +279,9 @@ static int add_internal_links(struct imx_media_dev *imxmd,
 }
 
 /* register an internal subdev as a platform device */
-static struct imx_media_subdev *
-add_internal_subdev(struct imx_media_dev *imxmd,
-		    const struct internal_subdev *isd,
-		    int ipu_id)
+static int add_internal_subdev(struct imx_media_dev *imxmd,
+			       const struct internal_subdev *isd,
+			       int ipu_id)
 {
 	struct imx_media_internal_sd_platformdata pdata;
 	struct platform_device_info pdevinfo = {0};
@@ -258,73 +306,58 @@ add_internal_subdev(struct imx_media_dev *imxmd,
 
 	pdev = platform_device_register_full(&pdevinfo);
 	if (IS_ERR(pdev))
-		return ERR_CAST(pdev);
+		return PTR_ERR(pdev);
 
 	imxsd = imx_media_add_async_subdev(imxmd, NULL, pdev);
 	if (IS_ERR(imxsd))
-		return imxsd;
+		return PTR_ERR(imxsd);
 
 	imxsd->num_sink_pads = isd->num_sink_pads;
 	imxsd->num_src_pads = isd->num_src_pads;
 
-	return imxsd;
+	return 0;
 }
 
 /* adds the internal subdevs in one ipu */
-static int add_ipu_internal_subdevs(struct imx_media_dev *imxmd,
-				    struct imx_media_subdev *csi0,
-				    struct imx_media_subdev *csi1,
-				    int ipu_id)
+static int add_ipu_internal_subdevs(struct imx_media_dev *imxmd, int ipu_id)
 {
 	enum isd_enum i;
-	int ret;
 
 	for (i = 0; i < num_isd; i++) {
-		const struct internal_subdev *isd = &internal_subdev[i];
-		struct imx_media_subdev *imxsd;
+		const struct internal_subdev *isd = &int_subdev[i];
+		int ret;
 
 		/*
 		 * the CSIs are represented in the device-tree, so those
-		 * devices are added already, and are added to the async
-		 * subdev list by of_parse_subdev(), so we are given those
-		 * subdevs as csi0 and csi1.
+		 * devices are already added to the async subdev list by
+		 * of_parse_subdev().
 		 */
 		switch (isd->id->grp_id) {
 		case IMX_MEDIA_GRP_ID_CSI0:
-			imxsd = csi0;
-			break;
 		case IMX_MEDIA_GRP_ID_CSI1:
-			imxsd = csi1;
+			ret = 0;
 			break;
 		default:
-			imxsd = add_internal_subdev(imxmd, isd, ipu_id);
+			ret = add_internal_subdev(imxmd, isd, ipu_id);
 			break;
 		}
 
-		if (IS_ERR(imxsd))
-			return PTR_ERR(imxsd);
-
-		/* add the links from this subdev */
-		if (imxsd) {
-			ret = add_internal_links(imxmd, isd, imxsd, ipu_id);
-			if (ret)
-				return ret;
-		}
+		if (ret)
+			return ret;
 	}
 
 	return 0;
 }
 
-int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd,
-				   struct imx_media_subdev *csi[4])
+int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd)
 {
 	int ret;
 
-	ret = add_ipu_internal_subdevs(imxmd, csi[0], csi[1], 0);
+	ret = add_ipu_internal_subdevs(imxmd, 0);
 	if (ret)
 		goto remove;
 
-	ret = add_ipu_internal_subdevs(imxmd, csi[2], csi[3], 1);
+	ret = add_ipu_internal_subdevs(imxmd, 1);
 	if (ret)
 		goto remove;
 
diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index 883ad85..d35c99e 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -20,20 +20,6 @@
 #include <video/imx-ipu-v3.h>
 #include "imx-media.h"
 
-static int of_add_pad_link(struct imx_media_dev *imxmd,
-			   struct imx_media_pad *pad,
-			   struct device_node *local_sd_node,
-			   struct device_node *remote_sd_node,
-			   int local_pad, int remote_pad)
-{
-	dev_dbg(imxmd->md.dev, "%s: adding %s:%d -> %s:%d\n", __func__,
-		local_sd_node->name, local_pad,
-		remote_sd_node->name, remote_pad);
-
-	return imx_media_add_pad_link(imxmd, pad, remote_sd_node, NULL,
-				      local_pad, remote_pad);
-}
-
 static int of_get_port_count(const struct device_node *np)
 {
 	struct device_node *ports, *child;
@@ -53,12 +39,10 @@ static int of_get_port_count(const struct device_node *np)
 }
 
 /*
- * find the remote device node and remote port id (remote pad #)
- * given local endpoint node
+ * find the remote device node given local endpoint node
  */
-static void of_get_remote_pad(struct device_node *epnode,
-			      struct device_node **remote_node,
-			      int *remote_pad)
+static void of_get_remote(struct device_node *epnode,
+			  struct device_node **remote_node)
 {
 	struct device_node *rp, *rpp;
 	struct device_node *remote;
@@ -69,12 +53,9 @@ static void of_get_remote_pad(struct device_node *epnode,
 	if (of_device_is_compatible(rpp, "fsl,imx6q-ipu")) {
 		/* the remote is one of the CSI ports */
 		remote = rp;
-		*remote_pad = 0;
 		of_node_put(rpp);
 	} else {
 		remote = rpp;
-		if (of_property_read_u32(rp, "reg", remote_pad))
-			*remote_pad = 0;
 		of_node_put(rp);
 	}
 
@@ -88,7 +69,7 @@ static void of_get_remote_pad(struct device_node *epnode,
 
 static int
 of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
-		bool is_csi_port, struct imx_media_subdev **subdev)
+		bool is_csi_port)
 {
 	struct imx_media_subdev *imxsd;
 	int i, num_pads, ret;
@@ -96,7 +77,6 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 	if (!of_device_is_available(sd_np)) {
 		dev_dbg(imxmd->md.dev, "%s: %s not enabled\n", __func__,
 			sd_np->name);
-		*subdev = NULL;
 		/* unavailable is not an error */
 		return 0;
 	}
@@ -107,14 +87,12 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 	if (ret) {
 		if (ret == -EEXIST) {
 			/* already added, everything is fine */
-			*subdev = NULL;
 			return 0;
 		}
 
 		/* other error, can't continue */
 		return ret;
 	}
-	*subdev = imxsd;
 
 	if (is_csi_port) {
 		/*
@@ -160,14 +138,6 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 
 	for (i = 0; i < num_pads; i++) {
 		struct device_node *epnode = NULL, *port, *remote_np;
-		struct imx_media_subdev *remote_imxsd;
-		struct imx_media_pad *pad;
-		int remote_pad;
-
-		/* init this pad */
-		pad = &imxsd->pad[i];
-		pad->pad.flags = (i < imxsd->num_sink_pads) ?
-			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
 
 		if (is_csi_port)
 			port = (i < imxsd->num_sink_pads) ? sd_np : NULL;
@@ -177,19 +147,13 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 			continue;
 
 		for_each_child_of_node(port, epnode) {
-			of_get_remote_pad(epnode, &remote_np, &remote_pad);
+			of_get_remote(epnode, &remote_np);
 			if (!remote_np)
 				continue;
 
-			ret = of_add_pad_link(imxmd, pad, sd_np, remote_np,
-					      i, remote_pad);
-			if (ret)
-				break;
-
 			if (i < imxsd->num_sink_pads) {
 				/* follow sink endpoints upstream */
-				ret = of_parse_subdev(imxmd, remote_np,
-						      false, &remote_imxsd);
+				ret = of_parse_subdev(imxmd, remote_np, false);
 				if (ret)
 					break;
 			}
@@ -209,13 +173,10 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 	return ret;
 }
 
-int imx_media_of_parse(struct imx_media_dev *imxmd,
-		       struct imx_media_subdev *(*csi)[4],
-		       struct device_node *np)
+int imx_media_add_of_subdevs(struct imx_media_dev *imxmd,
+			     struct device_node *np)
 {
-	struct imx_media_subdev *lcsi;
 	struct device_node *csi_np;
-	u32 ipu_id, csi_id;
 	int i, ret;
 
 	for (i = 0; ; i++) {
@@ -223,33 +184,125 @@ int imx_media_of_parse(struct imx_media_dev *imxmd,
 		if (!csi_np)
 			break;
 
-		ret = of_parse_subdev(imxmd, csi_np, true, &lcsi);
+		ret = of_parse_subdev(imxmd, csi_np, true);
+		of_node_put(csi_np);
 		if (ret)
-			goto err_put;
+			return ret;
+	}
 
-		ret = of_property_read_u32(csi_np, "reg", &csi_id);
-		if (ret) {
-			dev_err(imxmd->md.dev,
-				"%s: csi port missing reg property!\n",
-				__func__);
-			goto err_put;
-		}
+	return 0;
+}
 
-		ipu_id = of_alias_get_id(csi_np->parent, "ipu");
-		of_node_put(csi_np);
+/*
+ * Create a single media link to/from imxsd using a fwnode link.
+ *
+ * NOTE: this function assumes an OF port node is equivalent to
+ * a media pad (port id equal to media pad index), and that an
+ * OF endpoint node is equivalent to a media link.
+ */
+static int create_of_link(struct imx_media_dev *imxmd,
+			  struct imx_media_subdev *imxsd,
+			  struct v4l2_fwnode_link *link)
+{
+	struct v4l2_subdev *sd = imxsd->sd;
+	struct imx_media_subdev *remote;
+	struct v4l2_subdev *src, *sink;
+	int src_pad, sink_pad;
 
-		if (ipu_id > 1 || csi_id > 1) {
-			dev_err(imxmd->md.dev,
-				"%s: invalid ipu/csi id (%u/%u)\n",
-				__func__, ipu_id, csi_id);
-			return -EINVAL;
-		}
+	if (link->local_port >= sd->entity.num_pads)
+		return -EINVAL;
+
+	remote = imx_media_find_async_subdev(imxmd,
+					     to_of_node(link->remote_node),
+					     NULL);
+	if (!remote)
+		return 0;
 
-		(*csi)[ipu_id * 2 + csi_id] = lcsi;
+	if (sd->entity.pads[link->local_port].flags & MEDIA_PAD_FL_SINK) {
+		src = remote->sd;
+		src_pad = link->remote_port;
+		sink = sd;
+		sink_pad = link->local_port;
+	} else {
+		src = sd;
+		src_pad = link->local_port;
+		sink = remote->sd;
+		sink_pad = link->remote_port;
+	}
+
+	/* make sure link doesn't already exist before creating */
+	if (media_entity_find_link(&src->entity.pads[src_pad],
+				   &sink->entity.pads[sink_pad]))
+		return 0;
+
+	v4l2_info(sd->v4l2_dev, "%s:%d -> %s:%d\n",
+		  src->name, src_pad, sink->name, sink_pad);
+
+	return media_create_pad_link(&src->entity, src_pad,
+				     &sink->entity, sink_pad, 0);
+}
+
+/*
+ * Create media links to/from imxsd using its device-tree endpoints.
+ */
+int imx_media_create_of_links(struct imx_media_dev *imxmd,
+			      struct imx_media_subdev *imxsd)
+{
+	struct v4l2_subdev *sd = imxsd->sd;
+	struct v4l2_fwnode_link link;
+	struct device_node *ep;
+	int ret;
+
+	for_each_endpoint_of_node(sd->dev->of_node, ep) {
+		ret = v4l2_fwnode_parse_link(of_fwnode_handle(ep), &link);
+		if (ret)
+			continue;
+
+		ret = create_of_link(imxmd, imxsd, &link);
+		v4l2_fwnode_put_link(&link);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Create media links to the given CSI subdevice's sink pads,
+ * using its device-tree endpoints.
+ */
+int imx_media_create_csi_of_links(struct imx_media_dev *imxmd,
+				  struct imx_media_subdev *csi)
+{
+	struct device_node *csi_np = csi->sd->dev->of_node;
+	struct fwnode_handle *fwnode, *csi_ep;
+	struct v4l2_fwnode_link link;
+	struct device_node *ep;
+	int ret;
+
+	link.local_node = of_fwnode_handle(csi_np);
+	link.local_port = CSI_SINK_PAD;
+
+	for_each_child_of_node(csi_np, ep) {
+		csi_ep = of_fwnode_handle(ep);
+
+		fwnode = fwnode_graph_get_remote_endpoint(csi_ep);
+		if (!fwnode)
+			continue;
+
+		fwnode = fwnode_get_parent(fwnode);
+		fwnode_property_read_u32(fwnode, "reg", &link.remote_port);
+		fwnode = fwnode_get_next_parent(fwnode);
+		if (is_of_node(fwnode) &&
+		    of_node_cmp(to_of_node(fwnode)->name, "ports") == 0)
+			fwnode = fwnode_get_next_parent(fwnode);
+		link.remote_node = fwnode;
+
+		ret = create_of_link(imxmd, csi, &link);
+		fwnode_handle_put(link.remote_node);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
-err_put:
-	of_node_put(csi_np);
-	return ret;
 }
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index 17422f9..6c0e443 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -35,8 +35,6 @@
 #define IMX_MEDIA_MAX_SUBDEVS       32
 /* max pads per subdev */
 #define IMX_MEDIA_MAX_PADS          16
-/* max links per pad */
-#define IMX_MEDIA_MAX_LINKS          8
 
 /*
  * Pad definitions for the subdevs with multiple source or
@@ -119,19 +117,7 @@ static inline struct imx_media_buffer *to_imx_media_vb(struct vb2_buffer *vb)
 	return container_of(vbuf, struct imx_media_buffer, vbuf);
 }
 
-struct imx_media_link {
-	struct device_node *remote_sd_node;
-	char               remote_devname[32];
-	int                local_pad;
-	int                remote_pad;
-};
-
 struct imx_media_pad {
-	struct media_pad  pad;
-	struct imx_media_link link[IMX_MEDIA_MAX_LINKS];
-	bool devnode; /* does this pad link to a device node */
-	int num_links;
-
 	/*
 	 * list of video devices that can be reached from this pad,
 	 * list is only valid for source pads.
@@ -154,7 +140,7 @@ struct imx_media_subdev {
 	int num_sink_pads;
 	int num_src_pads;
 
-	/* the platform device if this is an internal subdev */
+	/* the platform device if this is an IPU-internal subdev */
 	struct platform_device *pdev;
 	/* the devname is needed for async devname match */
 	char devname[32];
@@ -225,17 +211,13 @@ struct imx_media_subdev *
 imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 			   struct device_node *np,
 			   struct platform_device *pdev);
-int imx_media_add_pad_link(struct imx_media_dev *imxmd,
-			   struct imx_media_pad *pad,
-			   struct device_node *remote_node,
-			   const char *remote_devname,
-			   int local_pad, int remote_pad);
 
 void imx_media_grp_id_to_sd_name(char *sd_name, int sz,
 				 u32 grp_id, int ipu_id);
 
-int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd,
-				   struct imx_media_subdev *csi[4]);
+int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd);
+int imx_media_create_internal_links(struct imx_media_dev *imxmd,
+				    struct imx_media_subdev *imxsd);
 void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd);
 
 struct imx_media_subdev *
@@ -284,13 +266,12 @@ struct imx_media_fim *imx_media_fim_init(struct v4l2_subdev *sd);
 void imx_media_fim_free(struct imx_media_fim *fim);
 
 /* imx-media-of.c */
-struct imx_media_subdev *
-imx_media_of_find_subdev(struct imx_media_dev *imxmd,
-			 struct device_node *np,
-			 const char *name);
-int imx_media_of_parse(struct imx_media_dev *dev,
-		       struct imx_media_subdev *(*csi)[4],
-		       struct device_node *np);
+int imx_media_add_of_subdevs(struct imx_media_dev *dev,
+			     struct device_node *np);
+int imx_media_create_of_links(struct imx_media_dev *imxmd,
+			      struct imx_media_subdev *imxsd);
+int imx_media_create_csi_of_links(struct imx_media_dev *imxmd,
+				  struct imx_media_subdev *csi);
 
 /* imx-media-capture.c */
 struct imx_media_video_dev *
-- 
2.7.4
