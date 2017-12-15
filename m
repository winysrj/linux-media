Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37838 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754645AbdLOBFm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 20:05:42 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 6/9] media: staging/imx: remove static subdev arrays
Date: Thu, 14 Dec 2017 17:04:44 -0800
Message-Id: <1513299887-16804-7-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1513299887-16804-1-git-send-email-steve_longerbeam@mentor.com>
References: <1513299887-16804-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For more complex OF graphs, there will be more async subdevices
registered. Remove the static subdev[IMX_MEDIA_MAX_SUBDEVS] array,
so that imx-media places no limits on the number of async subdevs
that can be added and registered.

There were two uses for 'struct imx_media_subdev'. First was to act
as the async subdev list to be passed to v4l2_async_notifier_register().

Second was to aid in inheriting subdev controls to the capture devices,
and this is done by creating a list of capture devices that can be reached
from a subdev's source pad. So 'struct imx_media_subdev' also contained
a static array of 'struct imx_media_pad' for placing the capture device
lists at each pad.

'struct imx_media_subdev' has been completely removed. Instead, at async
completion, allocate an array of 'struct imx_media_pad' and attach it to
the subdev's host_priv pointer, in order to support subdev controls
inheritance.

Likewise, remove static async_ptrs[IMX_MEDIA_MAX_SUBDEVS] array.
Instead, allocate a 'struct imx_media_async_subdev' when forming
the async list, and add it to an asd_list list_head in
imx_media_add_async_subdev(). At async completion, allocate the
asd pointer list and pull the asd's off asd_list for
v4l2_async_notifier_register().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-ic-prp.c            |   4 +-
 drivers/staging/media/imx/imx-media-csi.c         |   9 +-
 drivers/staging/media/imx/imx-media-dev.c         | 215 ++++++++++++----------
 drivers/staging/media/imx/imx-media-internal-sd.c |  51 +++--
 drivers/staging/media/imx/imx-media-of.c          |  31 ++--
 drivers/staging/media/imx/imx-media-utils.c       |  43 ++---
 drivers/staging/media/imx/imx-media.h             |  81 ++++----
 7 files changed, 216 insertions(+), 218 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
index 9e41987..c6d7e80 100644
--- a/drivers/staging/media/imx/imx-ic-prp.c
+++ b/drivers/staging/media/imx/imx-ic-prp.c
@@ -300,7 +300,7 @@ static int prp_link_validate(struct v4l2_subdev *sd,
 {
 	struct imx_ic_priv *ic_priv = v4l2_get_subdevdata(sd);
 	struct prp_priv *priv = ic_priv->prp_priv;
-	struct imx_media_subdev *csi;
+	struct v4l2_subdev *csi;
 	int ret;
 
 	ret = v4l2_subdev_link_validate_default(sd, link,
@@ -333,7 +333,7 @@ static int prp_link_validate(struct v4l2_subdev *sd,
 	}
 
 	if (csi) {
-		switch (csi->sd->grp_id) {
+		switch (csi->grp_id) {
 		case IMX_MEDIA_GRP_ID_CSI0:
 			priv->csi_id = 0;
 			break;
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index d7a4b7c..eb7be50 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -138,7 +138,6 @@ static int csi_get_upstream_endpoint(struct csi_priv *priv,
 				     struct v4l2_fwnode_endpoint *ep)
 {
 	struct device_node *endpoint, *port;
-	struct imx_media_subdev *imxsd;
 	struct media_entity *src;
 	struct v4l2_subdev *sd;
 	struct media_pad *pad;
@@ -154,10 +153,10 @@ static int csi_get_upstream_endpoint(struct csi_priv *priv,
 		 * CSI-2 receiver if it is in the path, otherwise stay
 		 * with video mux.
 		 */
-		imxsd = imx_media_find_upstream_subdev(priv->md, src,
-						       IMX_MEDIA_GRP_ID_CSI2);
-		if (!IS_ERR(imxsd))
-			src = &imxsd->sd->entity;
+		sd = imx_media_find_upstream_subdev(priv->md, src,
+						    IMX_MEDIA_GRP_ID_CSI2);
+		if (!IS_ERR(sd))
+			src = &sd->entity;
 	}
 
 	/* get source pad of entity directly upstream from src */
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 0369c35..71586ae 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -33,28 +33,28 @@ static inline struct imx_media_dev *notifier2dev(struct v4l2_async_notifier *n)
 }
 
 /*
- * Find a subdev by fwnode or device name. This is called during
+ * Find an asd by fwnode or device name. This is called during
  * driver load to form the async subdev list and bind them.
  */
-struct imx_media_subdev *
-imx_media_find_async_subdev(struct imx_media_dev *imxmd,
-			    struct fwnode_handle *fwnode,
-			    const char *devname)
+static struct v4l2_async_subdev *
+find_async_subdev(struct imx_media_dev *imxmd,
+		  struct fwnode_handle *fwnode,
+		  const char *devname)
 {
-	struct imx_media_subdev *imxsd;
-	int i;
+	struct imx_media_async_subdev *imxasd;
+	struct v4l2_async_subdev *asd;
 
-	for (i = 0; i < imxmd->subdev_notifier.num_subdevs; i++) {
-		imxsd = &imxmd->subdev[i];
-		switch (imxsd->asd.match_type) {
+	list_for_each_entry(imxasd, &imxmd->asd_list, list) {
+		asd = &imxasd->asd;
+		switch (asd->match_type) {
 		case V4L2_ASYNC_MATCH_FWNODE:
-			if (fwnode && imxsd->asd.match.fwnode.fwnode == fwnode)
-				return imxsd;
+			if (fwnode && asd->match.fwnode.fwnode == fwnode)
+				return asd;
 			break;
 		case V4L2_ASYNC_MATCH_DEVNAME:
-			if (devname &&
-			    !strcmp(imxsd->asd.match.device_name.name, devname))
-				return imxsd;
+			if (devname && !strcmp(asd->match.device_name.name,
+					       devname))
+				return asd;
 			break;
 		default:
 			break;
@@ -72,51 +72,47 @@ imx_media_find_async_subdev(struct imx_media_dev *imxmd,
  * given platform_device. This is called during driver load when
  * forming the async subdev list.
  */
-struct imx_media_subdev *
-imx_media_add_async_subdev(struct imx_media_dev *imxmd,
-			   struct fwnode_handle *fwnode,
-			   struct platform_device *pdev)
+int imx_media_add_async_subdev(struct imx_media_dev *imxmd,
+			       struct fwnode_handle *fwnode,
+			       struct platform_device *pdev)
 {
 	struct device_node *np = to_of_node(fwnode);
-	struct imx_media_subdev *imxsd;
+	struct imx_media_async_subdev *imxasd;
 	struct v4l2_async_subdev *asd;
 	const char *devname = NULL;
-	int sd_idx;
+	int ret = 0;
 
 	mutex_lock(&imxmd->mutex);
 
 	if (pdev)
 		devname = dev_name(&pdev->dev);
 
-	/* return -EEXIST if this subdev already added */
-	if (imx_media_find_async_subdev(imxmd, fwnode, devname)) {
+	/* return -EEXIST if this asd already added */
+	if (find_async_subdev(imxmd, fwnode, devname)) {
 		dev_dbg(imxmd->md.dev, "%s: already added %s\n",
 			__func__, np ? np->name : devname);
-		imxsd = ERR_PTR(-EEXIST);
+		ret = -EEXIST;
 		goto out;
 	}
 
-	sd_idx = imxmd->subdev_notifier.num_subdevs;
-	if (sd_idx >= IMX_MEDIA_MAX_SUBDEVS) {
-		dev_err(imxmd->md.dev, "%s: too many subdevs! can't add %s\n",
-			__func__, np ? np->name : devname);
-		imxsd = ERR_PTR(-ENOSPC);
+	imxasd = devm_kzalloc(imxmd->md.dev, sizeof(*imxasd), GFP_KERNEL);
+	if (!imxasd) {
+		ret = -ENOMEM;
 		goto out;
 	}
+	asd = &imxasd->asd;
 
-	imxsd = &imxmd->subdev[sd_idx];
-
-	asd = &imxsd->asd;
 	if (fwnode) {
 		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
 		asd->match.fwnode.fwnode = fwnode;
 	} else {
 		asd->match_type = V4L2_ASYNC_MATCH_DEVNAME;
 		asd->match.device_name.name = devname;
-		imxsd->pdev = pdev;
+		imxasd->pdev = pdev;
 	}
 
-	imxmd->async_ptrs[sd_idx] = asd;
+	list_add_tail(&imxasd->list, &imxmd->asd_list);
+
 	imxmd->subdev_notifier.num_subdevs++;
 
 	dev_dbg(imxmd->md.dev, "%s: added %s, match type %s\n",
@@ -124,7 +120,7 @@ imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 
 out:
 	mutex_unlock(&imxmd->mutex);
-	return imxsd;
+	return ret;
 }
 
 /*
@@ -162,56 +158,48 @@ static int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
 				  struct v4l2_async_subdev *asd)
 {
 	struct imx_media_dev *imxmd = notifier2dev(notifier);
-	struct imx_media_subdev *imxsd;
 	int ret = 0;
 
 	mutex_lock(&imxmd->mutex);
 
-	imxsd = imx_media_find_async_subdev(imxmd, sd->fwnode,
-					    dev_name(sd->dev));
-	if (!imxsd) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (sd->grp_id & IMX_MEDIA_GRP_ID_CSI) {
 		ret = imx_media_get_ipu(imxmd, sd);
 		if (ret)
-			goto out_unlock;
+			goto out;
 	}
 
-	/* attach the subdev */
-	imxsd->sd = sd;
+	v4l2_info(&imxmd->v4l2_dev, "subdev %s bound\n", sd->name);
 out:
-	if (ret)
-		v4l2_warn(&imxmd->v4l2_dev,
-			  "Received unknown subdev %s\n", sd->name);
-	else
-		v4l2_info(&imxmd->v4l2_dev,
-			  "Registered subdev %s\n", sd->name);
-
-out_unlock:
 	mutex_unlock(&imxmd->mutex);
 	return ret;
 }
 
 /*
- * create the media links from all pads and their links.
- * Called after all subdevs have registered.
+ * create the media links for all subdevs that registered async.
+ * Called after all async subdevs have bound.
  */
-static int imx_media_create_links(struct imx_media_dev *imxmd)
+static int imx_media_create_links(struct v4l2_async_notifier *notifier)
 {
-	struct imx_media_subdev *imxsd;
+	struct imx_media_dev *imxmd = notifier2dev(notifier);
 	struct v4l2_subdev *sd;
-	int i, ret;
-
-	for (i = 0; i < imxmd->num_subdevs; i++) {
-		imxsd = &imxmd->subdev[i];
-		sd = imxsd->sd;
+	int ret;
 
-		if (((sd->grp_id & IMX_MEDIA_GRP_ID_CSI) || imxsd->pdev)) {
-			/* this is an internal subdev or a CSI */
-			ret = imx_media_create_internal_links(imxmd, imxsd);
+	/*
+	 * Only links are created between subdevices that are known
+	 * to the async notifier. If there are other non-async subdevices,
+	 * they were created internally by some subdevice (smiapp is one
+	 * example). In those cases it is expected the subdevice is
+	 * responsible for creating those internal links.
+	 */
+	list_for_each_entry(sd, &notifier->done, async_list) {
+		switch (sd->grp_id) {
+		case IMX_MEDIA_GRP_ID_VDIC:
+		case IMX_MEDIA_GRP_ID_IC_PRP:
+		case IMX_MEDIA_GRP_ID_IC_PRPENC:
+		case IMX_MEDIA_GRP_ID_IC_PRPVF:
+		case IMX_MEDIA_GRP_ID_CSI0:
+		case IMX_MEDIA_GRP_ID_CSI1:
+			ret = imx_media_create_internal_links(imxmd, sd);
 			if (ret)
 				return ret;
 			/*
@@ -220,10 +208,12 @@ static int imx_media_create_links(struct imx_media_dev *imxmd)
 			 * to the CSI sink pads.
 			 */
 			if (sd->grp_id & IMX_MEDIA_GRP_ID_CSI)
-				imx_media_create_csi_of_links(imxmd, imxsd);
-		} else {
+				imx_media_create_csi_of_links(imxmd, sd);
+			break;
+		default:
 			/* this is an external fwnode subdev */
-			imx_media_create_of_links(imxmd, imxsd);
+			imx_media_create_of_links(imxmd, sd);
+			break;
 		}
 	}
 
@@ -239,7 +229,6 @@ static int imx_media_add_vdev_to_pad(struct imx_media_dev *imxmd,
 				     struct media_pad *srcpad)
 {
 	struct media_entity *entity = srcpad->entity;
-	struct imx_media_subdev *imxsd;
 	struct imx_media_pad *imxpad;
 	struct media_link *link;
 	struct v4l2_subdev *sd;
@@ -250,14 +239,18 @@ static int imx_media_add_vdev_to_pad(struct imx_media_dev *imxmd,
 		return 0;
 
 	sd = media_entity_to_v4l2_subdev(entity);
-	imxsd = imx_media_find_subdev_by_sd(imxmd, sd);
-	if (IS_ERR(imxsd)) {
-		v4l2_err(&imxmd->v4l2_dev, "failed to find subdev for entity %s, sd %p err %ld\n",
-			 entity->name, sd, PTR_ERR(imxsd));
+
+	imxpad = to_imx_media_pad(sd, srcpad->index);
+	if (!imxpad) {
+		v4l2_warn(&imxmd->v4l2_dev, "%s:%u has no vdev list!\n",
+			  entity->name, srcpad->index);
+		/*
+		 * shouldn't happen, but no reason to fail driver load,
+		 * just skip this entity.
+		 */
 		return 0;
 	}
 
-	imxpad = &imxsd->pad[srcpad->index];
 	vdev_idx = imxpad->num_vdevs;
 
 	/* just return if we've been here before */
@@ -296,6 +289,27 @@ static int imx_media_add_vdev_to_pad(struct imx_media_dev *imxmd,
 	return 0;
 }
 
+static int imx_media_alloc_pad_vdev_lists(struct imx_media_dev *imxmd)
+{
+	struct imx_media_pad *imxpads;
+	struct media_entity *entity;
+	struct v4l2_subdev *sd;
+
+	list_for_each_entry(sd, &imxmd->v4l2_dev.subdevs, list) {
+		entity = &sd->entity;
+		imxpads = devm_kzalloc(imxmd->md.dev,
+				       entity->num_pads * sizeof(*imxpads),
+				       GFP_KERNEL);
+		if (!imxpads)
+			return -ENOMEM;
+
+		/* attach imxpads to the subdev's host private pointer */
+		sd->host_priv = imxpads;
+	}
+
+	return 0;
+}
+
 /* form the vdev lists in all imx-media source pads */
 static int imx_media_create_pad_vdev_lists(struct imx_media_dev *imxmd)
 {
@@ -303,6 +317,10 @@ static int imx_media_create_pad_vdev_lists(struct imx_media_dev *imxmd)
 	struct media_link *link;
 	int i, ret;
 
+	ret = imx_media_alloc_pad_vdev_lists(imxmd);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < imxmd->num_vdevs; i++) {
 		vdev = imxmd->vdev[i];
 		link = list_first_entry(&vdev->vfd->entity.links,
@@ -319,20 +337,11 @@ static int imx_media_create_pad_vdev_lists(struct imx_media_dev *imxmd)
 static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
 {
 	struct imx_media_dev *imxmd = notifier2dev(notifier);
-	int i, ret;
+	int ret;
 
 	mutex_lock(&imxmd->mutex);
 
-	/* make sure all subdevs were bound */
-	for (i = 0; i < imxmd->num_subdevs; i++) {
-		if (!imxmd->subdev[i].sd) {
-			v4l2_err(&imxmd->v4l2_dev, "unbound subdev!\n");
-			ret = -ENODEV;
-			goto unlock;
-		}
-	}
-
-	ret = imx_media_create_links(imxmd);
+	ret = imx_media_create_links(notifier);
 	if (ret)
 		goto unlock;
 
@@ -401,7 +410,6 @@ static int imx_media_link_notify(struct media_link *link, u32 flags,
 				 unsigned int notification)
 {
 	struct media_entity *source = link->source->entity;
-	struct imx_media_subdev *imxsd;
 	struct imx_media_pad *imxpad;
 	struct imx_media_dev *imxmd;
 	struct video_device *vfd;
@@ -421,10 +429,11 @@ static int imx_media_link_notify(struct media_link *link, u32 flags,
 
 	imxmd = dev_get_drvdata(sd->v4l2_dev->dev);
 
-	imxsd = imx_media_find_subdev_by_sd(imxmd, sd);
-	if (IS_ERR(imxsd))
-		return PTR_ERR(imxsd);
-	imxpad = &imxsd->pad[pad_idx];
+	imxpad = to_imx_media_pad(sd, pad_idx);
+	if (!imxpad) {
+		/* shouldn't happen, but no reason to fail link setup */
+		return 0;
+	}
 
 	/*
 	 * Before disabling a link, reset controls for all video
@@ -468,8 +477,10 @@ static int imx_media_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *node = dev->of_node;
+	struct imx_media_async_subdev *imxasd;
+	struct v4l2_async_subdev **subdevs;
 	struct imx_media_dev *imxmd;
-	int ret;
+	int num_subdevs, i, ret;
 
 	imxmd = devm_kzalloc(dev, sizeof(*imxmd), GFP_KERNEL);
 	if (!imxmd)
@@ -498,6 +509,8 @@ static int imx_media_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(imxmd->v4l2_dev.dev, imxmd);
 
+	INIT_LIST_HEAD(&imxmd->asd_list);
+
 	ret = imx_media_add_of_subdevs(imxmd, node);
 	if (ret) {
 		v4l2_err(&imxmd->v4l2_dev,
@@ -512,15 +525,27 @@ static int imx_media_probe(struct platform_device *pdev)
 		goto unreg_dev;
 	}
 
+	num_subdevs = imxmd->subdev_notifier.num_subdevs;
+
 	/* no subdevs? just bail */
-	imxmd->num_subdevs = imxmd->subdev_notifier.num_subdevs;
-	if (imxmd->num_subdevs == 0) {
+	if (num_subdevs == 0) {
 		ret = -ENODEV;
 		goto unreg_dev;
 	}
 
+	subdevs = devm_kzalloc(imxmd->md.dev, sizeof(*subdevs) * num_subdevs,
+			       GFP_KERNEL);
+	if (!subdevs) {
+		ret = -ENOMEM;
+		goto unreg_dev;
+	}
+
+	i = 0;
+	list_for_each_entry(imxasd, &imxmd->asd_list, list)
+		subdevs[i++] = &imxasd->asd;
+
 	/* prepare the async subdev notifier and register it */
-	imxmd->subdev_notifier.subdevs = imxmd->async_ptrs;
+	imxmd->subdev_notifier.subdevs = subdevs;
 	imxmd->subdev_notifier.ops = &imx_media_subdev_ops;
 	ret = v4l2_async_notifier_register(&imxmd->v4l2_dev,
 					   &imxmd->subdev_notifier);
diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
index 53f2383..70833fe 100644
--- a/drivers/staging/media/imx/imx-media-internal-sd.c
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -68,6 +68,8 @@ struct internal_link {
 	int remote_pad;
 };
 
+/* max pads per internal-sd */
+#define MAX_INTERNAL_PADS   8
 /* max links per internal-sd pad */
 #define MAX_INTERNAL_LINKS  8
 
@@ -77,7 +79,7 @@ struct internal_pad {
 
 static const struct internal_subdev {
 	const struct internal_subdev_id *id;
-	struct internal_pad pad[IMX_MEDIA_MAX_PADS];
+	struct internal_pad pad[MAX_INTERNAL_PADS];
 } int_subdev[num_isd] = {
 	[isd_csi0] = {
 		.id = &isd_id[isd_csi0],
@@ -181,9 +183,9 @@ static const struct internal_subdev *find_intsd_by_grp_id(u32 grp_id)
 	return NULL;
 }
 
-static struct imx_media_subdev *find_sink(struct imx_media_dev *imxmd,
-					  struct imx_media_subdev *src,
-					  const struct internal_link *link)
+static struct v4l2_subdev *find_sink(struct imx_media_dev *imxmd,
+				     struct v4l2_subdev *src,
+				     const struct internal_link *link)
 {
 	char sink_devname[32];
 	int ipu_id;
@@ -194,20 +196,20 @@ static struct imx_media_subdev *find_sink(struct imx_media_dev *imxmd,
 	 * a CSI, it has different struct ipu_client_platformdata which
 	 * does not contain IPU id.
 	 */
-	if (sscanf(src->sd->name, "ipu%d", &ipu_id) != 1)
+	if (sscanf(src->name, "ipu%d", &ipu_id) != 1)
 		return NULL;
 
 	isd_to_devname(sink_devname, sizeof(sink_devname),
 		       link->remote, ipu_id - 1);
 
-	return imx_media_find_async_subdev(imxmd, NULL, sink_devname);
+	return imx_media_find_subdev_by_devname(imxmd, sink_devname);
 }
 
 static int create_ipu_internal_link(struct imx_media_dev *imxmd,
-				    struct imx_media_subdev *src,
+				    struct v4l2_subdev *src,
 				    const struct internal_link *link)
 {
-	struct imx_media_subdev *sink;
+	struct v4l2_subdev *sink;
 	int ret;
 
 	sink = find_sink(imxmd, src, link);
@@ -215,11 +217,11 @@ static int create_ipu_internal_link(struct imx_media_dev *imxmd,
 		return -ENODEV;
 
 	v4l2_info(&imxmd->v4l2_dev, "%s:%d -> %s:%d\n",
-		  src->sd->name, link->local_pad,
-		  sink->sd->name, link->remote_pad);
+		  src->name, link->local_pad,
+		  sink->name, link->remote_pad);
 
-	ret = media_create_pad_link(&src->sd->entity, link->local_pad,
-				    &sink->sd->entity, link->remote_pad, 0);
+	ret = media_create_pad_link(&src->entity, link->local_pad,
+				    &sink->entity, link->remote_pad, 0);
 	if (ret)
 		v4l2_err(&imxmd->v4l2_dev,
 			 "create_pad_link failed: %d\n", ret);
@@ -228,16 +230,15 @@ static int create_ipu_internal_link(struct imx_media_dev *imxmd,
 }
 
 int imx_media_create_internal_links(struct imx_media_dev *imxmd,
-				    struct imx_media_subdev *imxsd)
+				    struct v4l2_subdev *sd)
 {
-	struct v4l2_subdev *sd = imxsd->sd;
 	const struct internal_subdev *intsd;
 	const struct internal_pad *intpad;
 	const struct internal_link *link;
 	struct media_pad *pad;
 	int i, j, ret;
 
-	intsd = find_intsd_by_grp_id(imxsd->sd->grp_id);
+	intsd = find_intsd_by_grp_id(sd->grp_id);
 	if (!intsd)
 		return -ENODEV;
 
@@ -255,7 +256,7 @@ int imx_media_create_internal_links(struct imx_media_dev *imxmd,
 			if (!link->remote)
 				break;
 
-			ret = create_ipu_internal_link(imxmd, imxsd, link);
+			ret = create_ipu_internal_link(imxmd, sd, link);
 			if (ret)
 				return ret;
 		}
@@ -271,7 +272,6 @@ static int add_internal_subdev(struct imx_media_dev *imxmd,
 {
 	struct imx_media_internal_sd_platformdata pdata;
 	struct platform_device_info pdevinfo = {0};
-	struct imx_media_subdev *imxsd;
 	struct platform_device *pdev;
 
 	pdata.grp_id = isd->id->grp_id;
@@ -294,11 +294,7 @@ static int add_internal_subdev(struct imx_media_dev *imxmd,
 	if (IS_ERR(pdev))
 		return PTR_ERR(pdev);
 
-	imxsd = imx_media_add_async_subdev(imxmd, NULL, pdev);
-	if (IS_ERR(imxsd))
-		return PTR_ERR(imxsd);
-
-	return 0;
+	return imx_media_add_async_subdev(imxmd, NULL, pdev);
 }
 
 /* adds the internal subdevs in one ipu */
@@ -353,13 +349,12 @@ int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd)
 
 void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd)
 {
-	struct imx_media_subdev *imxsd;
-	int i;
+	struct imx_media_async_subdev *imxasd;
 
-	for (i = 0; i < imxmd->subdev_notifier.num_subdevs; i++) {
-		imxsd = &imxmd->subdev[i];
-		if (!imxsd->pdev)
+	list_for_each_entry(imxasd, &imxmd->asd_list, list) {
+		if (!imxasd->pdev)
 			continue;
-		platform_device_unregister(imxsd->pdev);
+
+		platform_device_unregister(imxasd->pdev);
 	}
 }
diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index eb7a7f2..acde372 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -76,7 +76,6 @@ static int
 of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 		bool is_csi_port)
 {
-	struct imx_media_subdev *imxsd;
 	int i, num_ports, ret;
 
 	if (!of_device_is_available(sd_np)) {
@@ -87,9 +86,8 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 	}
 
 	/* register this subdev with async notifier */
-	imxsd = imx_media_add_async_subdev(imxmd, of_fwnode_handle(sd_np),
-					   NULL);
-	ret = PTR_ERR_OR_ZERO(imxsd);
+	ret = imx_media_add_async_subdev(imxmd, of_fwnode_handle(sd_np),
+					 NULL);
 	if (ret) {
 		if (ret == -EEXIST) {
 			/* already added, everything is fine */
@@ -159,37 +157,35 @@ int imx_media_add_of_subdevs(struct imx_media_dev *imxmd,
 }
 
 /*
- * Create a single media link to/from imxsd using a fwnode link.
+ * Create a single media link to/from sd using a fwnode link.
  *
  * NOTE: this function assumes an OF port node is equivalent to
  * a media pad (port id equal to media pad index), and that an
  * OF endpoint node is equivalent to a media link.
  */
 static int create_of_link(struct imx_media_dev *imxmd,
-			  struct imx_media_subdev *imxsd,
+			  struct v4l2_subdev *sd,
 			  struct v4l2_fwnode_link *link)
 {
-	struct v4l2_subdev *sd = imxsd->sd;
-	struct imx_media_subdev *remote;
-	struct v4l2_subdev *src, *sink;
+	struct v4l2_subdev *remote, *src, *sink;
 	int src_pad, sink_pad;
 
 	if (link->local_port >= sd->entity.num_pads)
 		return -EINVAL;
 
-	remote = imx_media_find_async_subdev(imxmd, link->remote_node, NULL);
+	remote = imx_media_find_subdev_by_fwnode(imxmd, link->remote_node);
 	if (!remote)
 		return 0;
 
 	if (sd->entity.pads[link->local_port].flags & MEDIA_PAD_FL_SINK) {
-		src = remote->sd;
+		src = remote;
 		src_pad = link->remote_port;
 		sink = sd;
 		sink_pad = link->local_port;
 	} else {
 		src = sd;
 		src_pad = link->local_port;
-		sink = remote->sd;
+		sink = remote;
 		sink_pad = link->remote_port;
 	}
 
@@ -206,12 +202,11 @@ static int create_of_link(struct imx_media_dev *imxmd,
 }
 
 /*
- * Create media links to/from imxsd using its device-tree endpoints.
+ * Create media links to/from sd using its device-tree endpoints.
  */
 int imx_media_create_of_links(struct imx_media_dev *imxmd,
-			      struct imx_media_subdev *imxsd)
+			      struct v4l2_subdev *sd)
 {
-	struct v4l2_subdev *sd = imxsd->sd;
 	struct v4l2_fwnode_link link;
 	struct device_node *ep;
 	int ret;
@@ -221,7 +216,7 @@ int imx_media_create_of_links(struct imx_media_dev *imxmd,
 		if (ret)
 			continue;
 
-		ret = create_of_link(imxmd, imxsd, &link);
+		ret = create_of_link(imxmd, sd, &link);
 		v4l2_fwnode_put_link(&link);
 		if (ret)
 			return ret;
@@ -235,9 +230,9 @@ int imx_media_create_of_links(struct imx_media_dev *imxmd,
  * using its device-tree endpoints.
  */
 int imx_media_create_csi_of_links(struct imx_media_dev *imxmd,
-				  struct imx_media_subdev *csi)
+				  struct v4l2_subdev *csi)
 {
-	struct device_node *csi_np = csi->sd->dev->of_node;
+	struct device_node *csi_np = csi->dev->of_node;
 	struct fwnode_handle *fwnode, *csi_ep;
 	struct v4l2_fwnode_link link;
 	struct device_node *ep;
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 51d7e18..e143a88 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -668,38 +668,35 @@ void imx_media_grp_id_to_sd_name(char *sd_name, int sz, u32 grp_id, int ipu_id)
 }
 EXPORT_SYMBOL_GPL(imx_media_grp_id_to_sd_name);
 
-struct imx_media_subdev *
-imx_media_find_subdev_by_sd(struct imx_media_dev *imxmd,
-			    struct v4l2_subdev *sd)
+struct v4l2_subdev *
+imx_media_find_subdev_by_fwnode(struct imx_media_dev *imxmd,
+				struct fwnode_handle *fwnode)
 {
-	struct imx_media_subdev *imxsd;
-	int i;
+	struct v4l2_subdev *sd;
 
-	for (i = 0; i < imxmd->num_subdevs; i++) {
-		imxsd = &imxmd->subdev[i];
-		if (sd == imxsd->sd)
-			return imxsd;
+	list_for_each_entry(sd, &imxmd->v4l2_dev.subdevs, list) {
+		if (sd->fwnode == fwnode)
+			return sd;
 	}
 
-	return ERR_PTR(-ENODEV);
+	return NULL;
 }
-EXPORT_SYMBOL_GPL(imx_media_find_subdev_by_sd);
+EXPORT_SYMBOL_GPL(imx_media_find_subdev_by_fwnode);
 
-struct imx_media_subdev *
-imx_media_find_subdev_by_id(struct imx_media_dev *imxmd, u32 grp_id)
+struct v4l2_subdev *
+imx_media_find_subdev_by_devname(struct imx_media_dev *imxmd,
+				 const char *devname)
 {
-	struct imx_media_subdev *imxsd;
-	int i;
+	struct v4l2_subdev *sd;
 
-	for (i = 0; i < imxmd->num_subdevs; i++) {
-		imxsd = &imxmd->subdev[i];
-		if (imxsd->sd && imxsd->sd->grp_id == grp_id)
-			return imxsd;
+	list_for_each_entry(sd, &imxmd->v4l2_dev.subdevs, list) {
+		if (!strcmp(devname, dev_name(sd->dev)))
+			return sd;
 	}
 
-	return ERR_PTR(-ENODEV);
+	return NULL;
 }
-EXPORT_SYMBOL_GPL(imx_media_find_subdev_by_id);
+EXPORT_SYMBOL_GPL(imx_media_find_subdev_by_devname);
 
 /*
  * Adds a video device to the master video device list. This is called by
@@ -842,7 +839,7 @@ EXPORT_SYMBOL_GPL(imx_media_find_upstream_pad);
  * the current pipeline.
  * Must be called with mdev->graph_mutex held.
  */
-struct imx_media_subdev *
+struct v4l2_subdev *
 imx_media_find_upstream_subdev(struct imx_media_dev *imxmd,
 			       struct media_entity *start_entity,
 			       u32 grp_id)
@@ -853,7 +850,7 @@ imx_media_find_upstream_subdev(struct imx_media_dev *imxmd,
 	if (!sd)
 		return ERR_PTR(-ENODEV);
 
-	return imx_media_find_subdev_by_sd(imxmd, sd);
+	return sd;
 }
 EXPORT_SYMBOL_GPL(imx_media_find_upstream_subdev);
 
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index 32ec8d2..5089a0d 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -11,6 +11,7 @@
 #ifndef _IMX_MEDIA_H
 #define _IMX_MEDIA_H
 
+#include <linux/platform_device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-fwnode.h>
@@ -18,23 +19,8 @@
 #include <media/videobuf2-dma-contig.h>
 #include <video/imx-ipu-v3.h>
 
-/*
- * This is somewhat arbitrary, but we need at least:
- * - 4 video devices per IPU
- * - 3 IC subdevs per IPU
- * - 1 VDIC subdev per IPU
- * - 2 CSI subdevs per IPU
- * - 1 mipi-csi2 receiver subdev
- * - 2 video-mux subdevs
- * - 2 camera sensor subdevs per IPU (1 parallel, 1 mipi-csi2)
- *
- */
 /* max video devices */
 #define IMX_MEDIA_MAX_VDEVS          8
-/* max subdevices */
-#define IMX_MEDIA_MAX_SUBDEVS       32
-/* max pads per subdev */
-#define IMX_MEDIA_MAX_PADS          16
 
 /*
  * Pad definitions for the subdevs with multiple source or
@@ -105,6 +91,7 @@ static inline struct imx_media_buffer *to_imx_media_vb(struct vb2_buffer *vb)
 	return container_of(vbuf, struct imx_media_buffer, vbuf);
 }
 
+/* to support control inheritance to video devices */
 struct imx_media_pad {
 	/*
 	 * list of video devices that can be reached from this pad,
@@ -114,22 +101,34 @@ struct imx_media_pad {
 	int num_vdevs;
 };
 
+static inline struct imx_media_pad *
+to_imx_media_pad(struct v4l2_subdev *sd, int pad_index)
+{
+	struct imx_media_pad *imxpads = sd->host_priv;
+
+	return imxpads ? &imxpads[pad_index] : NULL;
+}
+
 struct imx_media_internal_sd_platformdata {
 	char sd_name[V4L2_SUBDEV_NAME_SIZE];
 	u32 grp_id;
 	int ipu_id;
 };
 
-struct imx_media_subdev {
-	struct v4l2_async_subdev asd;
-	struct v4l2_subdev       *sd; /* set when bound */
-
-	struct imx_media_pad     pad[IMX_MEDIA_MAX_PADS];
 
-	/* the platform device if this is an IPU-internal subdev */
+struct imx_media_async_subdev {
+	struct v4l2_async_subdev asd;
+	/* the platform device of IPU-internal subdevs */
 	struct platform_device *pdev;
+	struct list_head list;
 };
 
+static inline struct imx_media_async_subdev *
+to_imx_media_asd(struct v4l2_async_subdev *asd)
+{
+	return container_of(asd, struct imx_media_async_subdev, asd);
+}
+
 struct imx_media_dev {
 	struct media_device md;
 	struct v4l2_device  v4l2_dev;
@@ -139,10 +138,6 @@ struct imx_media_dev {
 
 	struct mutex mutex; /* protect elements below */
 
-	/* master subdevice list */
-	struct imx_media_subdev subdev[IMX_MEDIA_MAX_SUBDEVS];
-	int num_subdevs;
-
 	/* master video device list */
 	struct imx_media_video_dev *vdev[IMX_MEDIA_MAX_VDEVS];
 	int num_vdevs;
@@ -151,7 +146,7 @@ struct imx_media_dev {
 	struct ipu_soc *ipu[2];
 
 	/* for async subdev registration */
-	struct v4l2_async_subdev *async_ptrs[IMX_MEDIA_MAX_SUBDEVS];
+	struct list_head asd_list;
 	struct v4l2_async_notifier subdev_notifier;
 };
 
@@ -172,7 +167,6 @@ int imx_media_enum_mbus_format(u32 *code, u32 index, enum codespace_sel cs_sel,
 const struct imx_media_pixfmt *
 imx_media_find_ipu_format(u32 code, enum codespace_sel cs_sel);
 int imx_media_enum_ipu_format(u32 *code, u32 index, enum codespace_sel cs_sel);
-
 int imx_media_init_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
 			    u32 width, u32 height, u32 code, u32 field,
 			    const struct imx_media_pixfmt **cc);
@@ -186,30 +180,23 @@ int imx_media_mbus_fmt_to_ipu_image(struct ipu_image *image,
 				    struct v4l2_mbus_framefmt *mbus);
 int imx_media_ipu_image_to_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
 				    struct ipu_image *image);
-
-struct imx_media_subdev *
-imx_media_find_async_subdev(struct imx_media_dev *imxmd,
-			    struct fwnode_handle *fwnode,
-			    const char *devname);
-struct imx_media_subdev *
-imx_media_add_async_subdev(struct imx_media_dev *imxmd,
-			   struct fwnode_handle *fwnode,
-			   struct platform_device *pdev);
-
+int imx_media_add_async_subdev(struct imx_media_dev *imxmd,
+			       struct fwnode_handle *fwnode,
+			       struct platform_device *pdev);
 void imx_media_grp_id_to_sd_name(char *sd_name, int sz,
 				 u32 grp_id, int ipu_id);
 
 int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd);
 int imx_media_create_internal_links(struct imx_media_dev *imxmd,
-				    struct imx_media_subdev *imxsd);
+				    struct v4l2_subdev *sd);
 void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd);
 
-struct imx_media_subdev *
-imx_media_find_subdev_by_sd(struct imx_media_dev *imxmd,
-			    struct v4l2_subdev *sd);
-struct imx_media_subdev *
-imx_media_find_subdev_by_id(struct imx_media_dev *imxmd,
-			    u32 grp_id);
+struct v4l2_subdev *
+imx_media_find_subdev_by_fwnode(struct imx_media_dev *imxmd,
+				struct fwnode_handle *fwnode);
+struct v4l2_subdev *
+imx_media_find_subdev_by_devname(struct imx_media_dev *imxmd,
+				 const char *devname);
 int imx_media_add_video_device(struct imx_media_dev *imxmd,
 			       struct imx_media_video_dev *vdev);
 int imx_media_find_mipi_csi2_channel(struct imx_media_dev *imxmd,
@@ -218,7 +205,7 @@ struct media_pad *
 imx_media_find_upstream_pad(struct imx_media_dev *imxmd,
 			    struct media_entity *start_entity,
 			    u32 grp_id);
-struct imx_media_subdev *
+struct v4l2_subdev *
 imx_media_find_upstream_subdev(struct imx_media_dev *imxmd,
 			       struct media_entity *start_entity,
 			       u32 grp_id);
@@ -253,9 +240,9 @@ void imx_media_fim_free(struct imx_media_fim *fim);
 int imx_media_add_of_subdevs(struct imx_media_dev *dev,
 			     struct device_node *np);
 int imx_media_create_of_links(struct imx_media_dev *imxmd,
-			      struct imx_media_subdev *imxsd);
+			      struct v4l2_subdev *sd);
 int imx_media_create_csi_of_links(struct imx_media_dev *imxmd,
-				  struct imx_media_subdev *csi);
+				  struct v4l2_subdev *csi);
 
 /* imx-media-capture.c */
 struct imx_media_video_dev *
-- 
2.7.4
