Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:51863 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbeEVOxC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 10:53:02 -0400
Received: by mail-wm0-f67.google.com with SMTP id j4-v6so584951wme.1
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 07:53:01 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        linux-clk@vger.kernel.org, Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v6 02/13] media: staging/imx: rearrange group id to take in account IPU
Date: Tue, 22 May 2018 15:52:34 +0100
Message-Id: <20180522145245.3143-3-rui.silva@linaro.org>
In-Reply-To: <20180522145245.3143-1-rui.silva@linaro.org>
References: <20180522145245.3143-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some imx system do not have IPU, so prepare the imx media drivers to support
this kind of devices. Rename the group ids to include an _IPU_ prefix, add a new
group id to support systems with only a CSI without IPU, and also
rename the create internal links to make it clear that only systems with IPU
have internal subdevices.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/imx-ic-common.c     |  6 ++---
 drivers/staging/media/imx/imx-ic-prp.c        | 14 +++++------
 drivers/staging/media/imx/imx-media-csi.c     |  6 ++---
 drivers/staging/media/imx/imx-media-dev.c     | 22 ++++++++++--------
 .../staging/media/imx/imx-media-internal-sd.c | 20 ++++++++--------
 drivers/staging/media/imx/imx-media-utils.c   | 12 +++++-----
 drivers/staging/media/imx/imx-media.h         | 23 ++++++++++---------
 7 files changed, 54 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-common.c b/drivers/staging/media/imx/imx-ic-common.c
index cfdd4900a3be..765919487a73 100644
--- a/drivers/staging/media/imx/imx-ic-common.c
+++ b/drivers/staging/media/imx/imx-ic-common.c
@@ -41,13 +41,13 @@ static int imx_ic_probe(struct platform_device *pdev)
 	pdata = priv->dev->platform_data;
 	priv->ipu_id = pdata->ipu_id;
 	switch (pdata->grp_id) {
-	case IMX_MEDIA_GRP_ID_IC_PRP:
+	case IMX_MEDIA_GRP_ID_IPU_IC_PRP:
 		priv->task_id = IC_TASK_PRP;
 		break;
-	case IMX_MEDIA_GRP_ID_IC_PRPENC:
+	case IMX_MEDIA_GRP_ID_IPU_IC_PRPENC:
 		priv->task_id = IC_TASK_ENCODER;
 		break;
-	case IMX_MEDIA_GRP_ID_IC_PRPVF:
+	case IMX_MEDIA_GRP_ID_IPU_IC_PRPVF:
 		priv->task_id = IC_TASK_VIEWFINDER;
 		break;
 	default:
diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
index 98923fc844ce..795ca61f7cea 100644
--- a/drivers/staging/media/imx/imx-ic-prp.c
+++ b/drivers/staging/media/imx/imx-ic-prp.c
@@ -77,7 +77,7 @@ static int prp_start(struct prp_priv *priv)
 	priv->ipu = priv->md->ipu[ic_priv->ipu_id];
 
 	/* set IC to receive from CSI or VDI depending on source */
-	src_is_vdic = !!(priv->src_sd->grp_id & IMX_MEDIA_GRP_ID_VDIC);
+	src_is_vdic = !!(priv->src_sd->grp_id & IMX_MEDIA_GRP_ID_IPU_VDIC);
 
 	ipu_set_ic_src_mux(priv->ipu, priv->csi_id, src_is_vdic);
 
@@ -238,7 +238,7 @@ static int prp_link_setup(struct media_entity *entity,
 				goto out;
 			}
 			if (priv->sink_sd_prpenc && (remote_sd->grp_id &
-						     IMX_MEDIA_GRP_ID_VDIC)) {
+						     IMX_MEDIA_GRP_ID_IPU_VDIC)) {
 				ret = -EINVAL;
 				goto out;
 			}
@@ -259,7 +259,7 @@ static int prp_link_setup(struct media_entity *entity,
 				goto out;
 			}
 			if (priv->src_sd && (priv->src_sd->grp_id &
-					     IMX_MEDIA_GRP_ID_VDIC)) {
+					     IMX_MEDIA_GRP_ID_IPU_VDIC)) {
 				ret = -EINVAL;
 				goto out;
 			}
@@ -309,13 +309,13 @@ static int prp_link_validate(struct v4l2_subdev *sd,
 		return ret;
 
 	csi = imx_media_find_upstream_subdev(priv->md, &ic_priv->sd.entity,
-					     IMX_MEDIA_GRP_ID_CSI);
+					     IMX_MEDIA_GRP_ID_IPU_CSI);
 	if (IS_ERR(csi))
 		csi = NULL;
 
 	mutex_lock(&priv->lock);
 
-	if (priv->src_sd->grp_id & IMX_MEDIA_GRP_ID_VDIC) {
+	if (priv->src_sd->grp_id & IMX_MEDIA_GRP_ID_IPU_VDIC) {
 		/*
 		 * the ->PRPENC link cannot be enabled if the source
 		 * is the VDIC
@@ -334,10 +334,10 @@ static int prp_link_validate(struct v4l2_subdev *sd,
 
 	if (csi) {
 		switch (csi->grp_id) {
-		case IMX_MEDIA_GRP_ID_CSI0:
+		case IMX_MEDIA_GRP_ID_IPU_CSI0:
 			priv->csi_id = 0;
 			break;
-		case IMX_MEDIA_GRP_ID_CSI1:
+		case IMX_MEDIA_GRP_ID_IPU_CSI1:
 			priv->csi_id = 1;
 			break;
 		default:
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 436f3b8a141b..8a86d111e935 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -981,10 +981,10 @@ static int csi_link_setup(struct media_entity *entity,
 
 		remote_sd = media_entity_to_v4l2_subdev(remote->entity);
 		switch (remote_sd->grp_id) {
-		case IMX_MEDIA_GRP_ID_VDIC:
+		case IMX_MEDIA_GRP_ID_IPU_VDIC:
 			priv->dest = IPU_CSI_DEST_VDIC;
 			break;
-		case IMX_MEDIA_GRP_ID_IC_PRP:
+		case IMX_MEDIA_GRP_ID_IPU_IC_PRP:
 			priv->dest = IPU_CSI_DEST_IC;
 			break;
 		default:
@@ -1829,7 +1829,7 @@ static int imx_csi_probe(struct platform_device *pdev)
 	priv->sd.owner = THIS_MODULE;
 	priv->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 	priv->sd.grp_id = priv->csi_id ?
-		IMX_MEDIA_GRP_ID_CSI1 : IMX_MEDIA_GRP_ID_CSI0;
+		IMX_MEDIA_GRP_ID_IPU_CSI1 : IMX_MEDIA_GRP_ID_IPU_CSI0;
 	imx_media_grp_id_to_sd_name(priv->sd.name, sizeof(priv->sd.name),
 				    priv->sd.grp_id, ipu_get_num(priv->ipu));
 
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 70fcaf2d358a..9c4d70649857 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -116,7 +116,7 @@ int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
 
 	mutex_lock(&imxmd->mutex);
 
-	if (sd->grp_id & IMX_MEDIA_GRP_ID_CSI) {
+	if (sd->grp_id & IMX_MEDIA_GRP_ID_IPU_CSI) {
 		ret = imx_media_get_ipu(imxmd, sd);
 		if (ret)
 			goto out;
@@ -140,13 +140,13 @@ static int imx_media_create_links(struct v4l2_async_notifier *notifier)
 
 	list_for_each_entry(sd, &imxmd->v4l2_dev.subdevs, list) {
 		switch (sd->grp_id) {
-		case IMX_MEDIA_GRP_ID_VDIC:
-		case IMX_MEDIA_GRP_ID_IC_PRP:
-		case IMX_MEDIA_GRP_ID_IC_PRPENC:
-		case IMX_MEDIA_GRP_ID_IC_PRPVF:
-		case IMX_MEDIA_GRP_ID_CSI0:
-		case IMX_MEDIA_GRP_ID_CSI1:
-			ret = imx_media_create_internal_links(imxmd, sd);
+		case IMX_MEDIA_GRP_ID_IPU_VDIC:
+		case IMX_MEDIA_GRP_ID_IPU_IC_PRP:
+		case IMX_MEDIA_GRP_ID_IPU_IC_PRPENC:
+		case IMX_MEDIA_GRP_ID_IPU_IC_PRPVF:
+		case IMX_MEDIA_GRP_ID_IPU_CSI0:
+		case IMX_MEDIA_GRP_ID_IPU_CSI1:
+			ret = imx_media_create_ipu_internal_links(imxmd, sd);
 			if (ret)
 				return ret;
 			/*
@@ -154,9 +154,13 @@ static int imx_media_create_links(struct v4l2_async_notifier *notifier)
 			 * internal entities, so create the external links
 			 * to the CSI sink pads.
 			 */
-			if (sd->grp_id & IMX_MEDIA_GRP_ID_CSI)
+			if (sd->grp_id & IMX_MEDIA_GRP_ID_IPU_CSI)
 				imx_media_create_csi_of_links(imxmd, sd);
 			break;
+		case IMX_MEDIA_GRP_ID_CSI:
+			imx_media_create_csi_of_links(imxmd, sd);
+
+			break;
 		default:
 			/*
 			 * if this subdev has fwnode links, create media
diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
index 0fdc45dbfb76..5e10d95e5529 100644
--- a/drivers/staging/media/imx/imx-media-internal-sd.c
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -30,32 +30,32 @@ static const struct internal_subdev_id {
 } isd_id[num_isd] = {
 	[isd_csi0] = {
 		.index = isd_csi0,
-		.grp_id = IMX_MEDIA_GRP_ID_CSI0,
+		.grp_id = IMX_MEDIA_GRP_ID_IPU_CSI0,
 		.name = "imx-ipuv3-csi",
 	},
 	[isd_csi1] = {
 		.index = isd_csi1,
-		.grp_id = IMX_MEDIA_GRP_ID_CSI1,
+		.grp_id = IMX_MEDIA_GRP_ID_IPU_CSI1,
 		.name = "imx-ipuv3-csi",
 	},
 	[isd_vdic] = {
 		.index = isd_vdic,
-		.grp_id = IMX_MEDIA_GRP_ID_VDIC,
+		.grp_id = IMX_MEDIA_GRP_ID_IPU_VDIC,
 		.name = "imx-ipuv3-vdic",
 	},
 	[isd_ic_prp] = {
 		.index = isd_ic_prp,
-		.grp_id = IMX_MEDIA_GRP_ID_IC_PRP,
+		.grp_id = IMX_MEDIA_GRP_ID_IPU_IC_PRP,
 		.name = "imx-ipuv3-ic",
 	},
 	[isd_ic_prpenc] = {
 		.index = isd_ic_prpenc,
-		.grp_id = IMX_MEDIA_GRP_ID_IC_PRPENC,
+		.grp_id = IMX_MEDIA_GRP_ID_IPU_IC_PRPENC,
 		.name = "imx-ipuv3-ic",
 	},
 	[isd_ic_prpvf] = {
 		.index = isd_ic_prpvf,
-		.grp_id = IMX_MEDIA_GRP_ID_IC_PRPVF,
+		.grp_id = IMX_MEDIA_GRP_ID_IPU_IC_PRPVF,
 		.name = "imx-ipuv3-ic",
 	},
 };
@@ -229,8 +229,8 @@ static int create_ipu_internal_link(struct imx_media_dev *imxmd,
 	return ret;
 }
 
-int imx_media_create_internal_links(struct imx_media_dev *imxmd,
-				    struct v4l2_subdev *sd)
+int imx_media_create_ipu_internal_links(struct imx_media_dev *imxmd,
+					struct v4l2_subdev *sd)
 {
 	const struct internal_subdev *intsd;
 	const struct internal_pad *intpad;
@@ -312,8 +312,8 @@ static int add_ipu_internal_subdevs(struct imx_media_dev *imxmd, int ipu_id)
 		 * of_parse_subdev().
 		 */
 		switch (isd->id->grp_id) {
-		case IMX_MEDIA_GRP_ID_CSI0:
-		case IMX_MEDIA_GRP_ID_CSI1:
+		case IMX_MEDIA_GRP_ID_IPU_CSI0:
+		case IMX_MEDIA_GRP_ID_IPU_CSI1:
 			ret = 0;
 			break;
 		default:
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index fab98fc0d6a0..7a429e3d32cb 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -686,20 +686,20 @@ void imx_media_grp_id_to_sd_name(char *sd_name, int sz, u32 grp_id, int ipu_id)
 	int id;
 
 	switch (grp_id) {
-	case IMX_MEDIA_GRP_ID_CSI0...IMX_MEDIA_GRP_ID_CSI1:
-		id = (grp_id >> IMX_MEDIA_GRP_ID_CSI_BIT) - 1;
+	case IMX_MEDIA_GRP_ID_IPU_CSI0...IMX_MEDIA_GRP_ID_IPU_CSI1:
+		id = (grp_id >> IMX_MEDIA_GRP_ID_IPU_CSI_BIT) - 1;
 		snprintf(sd_name, sz, "ipu%d_csi%d", ipu_id + 1, id);
 		break;
-	case IMX_MEDIA_GRP_ID_VDIC:
+	case IMX_MEDIA_GRP_ID_IPU_VDIC:
 		snprintf(sd_name, sz, "ipu%d_vdic", ipu_id + 1);
 		break;
-	case IMX_MEDIA_GRP_ID_IC_PRP:
+	case IMX_MEDIA_GRP_ID_IPU_IC_PRP:
 		snprintf(sd_name, sz, "ipu%d_ic_prp", ipu_id + 1);
 		break;
-	case IMX_MEDIA_GRP_ID_IC_PRPENC:
+	case IMX_MEDIA_GRP_ID_IPU_IC_PRPENC:
 		snprintf(sd_name, sz, "ipu%d_ic_prpenc", ipu_id + 1);
 		break;
-	case IMX_MEDIA_GRP_ID_IC_PRPVF:
+	case IMX_MEDIA_GRP_ID_IPU_IC_PRPVF:
 		snprintf(sd_name, sz, "ipu%d_ic_prpvf", ipu_id + 1);
 		break;
 	default:
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index 8ec9738aced9..394b7486af6d 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -249,8 +249,8 @@ void imx_media_fim_free(struct imx_media_fim *fim);
 
 /* imx-media-internal-sd.c */
 int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd);
-int imx_media_create_internal_links(struct imx_media_dev *imxmd,
-				    struct v4l2_subdev *sd);
+int imx_media_create_ipu_internal_links(struct imx_media_dev *imxmd,
+					struct v4l2_subdev *sd);
 void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd);
 
 /* imx-media-of.c */
@@ -276,14 +276,15 @@ void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
 void imx_media_capture_device_error(struct imx_media_video_dev *vdev);
 
 /* subdev group ids */
-#define IMX_MEDIA_GRP_ID_CSI2      BIT(8)
-#define IMX_MEDIA_GRP_ID_CSI_BIT   9
-#define IMX_MEDIA_GRP_ID_CSI       (0x3 << IMX_MEDIA_GRP_ID_CSI_BIT)
-#define IMX_MEDIA_GRP_ID_CSI0      BIT(IMX_MEDIA_GRP_ID_CSI_BIT)
-#define IMX_MEDIA_GRP_ID_CSI1      (2 << IMX_MEDIA_GRP_ID_CSI_BIT)
-#define IMX_MEDIA_GRP_ID_VDIC      BIT(11)
-#define IMX_MEDIA_GRP_ID_IC_PRP    BIT(12)
-#define IMX_MEDIA_GRP_ID_IC_PRPENC BIT(13)
-#define IMX_MEDIA_GRP_ID_IC_PRPVF  BIT(14)
+#define IMX_MEDIA_GRP_ID_CSI2          BIT(8)
+#define IMX_MEDIA_GRP_ID_CSI           BIT(9)
+#define IMX_MEDIA_GRP_ID_IPU_CSI_BIT   10
+#define IMX_MEDIA_GRP_ID_IPU_CSI       (0x3 << IMX_MEDIA_GRP_ID_IPU_CSI_BIT)
+#define IMX_MEDIA_GRP_ID_IPU_CSI0      BIT(IMX_MEDIA_GRP_ID_IPU_CSI_BIT)
+#define IMX_MEDIA_GRP_ID_IPU_CSI1      (2 << IMX_MEDIA_GRP_ID_IPU_CSI_BIT)
+#define IMX_MEDIA_GRP_ID_IPU_VDIC      BIT(12)
+#define IMX_MEDIA_GRP_ID_IPU_IC_PRP    BIT(13)
+#define IMX_MEDIA_GRP_ID_IPU_IC_PRPENC BIT(14)
+#define IMX_MEDIA_GRP_ID_IPU_IC_PRPVF  BIT(15)
 
 #endif
-- 
2.17.0
