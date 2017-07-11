Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:63458 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932158AbdGKNUa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 09:20:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Marek Vasut <marex@denx.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] [media] staging/imx: remove confusing IS_ERR_OR_NULL usage
Date: Tue, 11 Jul 2017 15:18:35 +0200
Message-Id: <20170711132001.2266388-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While looking at a compiler warning, I noticed the use of
IS_ERR_OR_NULL, which is generally a sign of a bad API design
and should be avoided.

In this driver, this is fairly easy, we can simply stop storing
error pointers in persistent structures, and change the two
functions that might return either a NULL pointer or an error
code to consistently return error pointers when failing.

of_parse_subdev() now separates the error code and the pointer
it looks up, to clarify the interface. There are two cases
where this function originally returns 'NULL', and I have
changed that to '0' for success to keep the current behavior,
though returning an error would also make sense there.

Fixes: e130291212df ("[media] media: Add i.MX media core driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: fix type mismatch
v3: rework of_parse_subdev() as well.
---
 drivers/staging/media/imx/imx-ic-prpencvf.c | 41 ++++++++++++-----------
 drivers/staging/media/imx/imx-media-csi.c   | 30 ++++++++++-------
 drivers/staging/media/imx/imx-media-dev.c   |  4 +--
 drivers/staging/media/imx/imx-media-of.c    | 50 ++++++++++++++++-------------
 drivers/staging/media/imx/imx-media-vdic.c  | 37 +++++++++++----------
 5 files changed, 90 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index ed363fe3b3d0..7a9d9f32f989 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -134,19 +134,19 @@ static inline struct prp_priv *sd_to_priv(struct v4l2_subdev *sd)
 
 static void prp_put_ipu_resources(struct prp_priv *priv)
 {
-	if (!IS_ERR_OR_NULL(priv->ic))
+	if (priv->ic)
 		ipu_ic_put(priv->ic);
 	priv->ic = NULL;
 
-	if (!IS_ERR_OR_NULL(priv->out_ch))
+	if (priv->out_ch)
 		ipu_idmac_put(priv->out_ch);
 	priv->out_ch = NULL;
 
-	if (!IS_ERR_OR_NULL(priv->rot_in_ch))
+	if (priv->rot_in_ch)
 		ipu_idmac_put(priv->rot_in_ch);
 	priv->rot_in_ch = NULL;
 
-	if (!IS_ERR_OR_NULL(priv->rot_out_ch))
+	if (priv->rot_out_ch)
 		ipu_idmac_put(priv->rot_out_ch);
 	priv->rot_out_ch = NULL;
 }
@@ -154,43 +154,46 @@ static void prp_put_ipu_resources(struct prp_priv *priv)
 static int prp_get_ipu_resources(struct prp_priv *priv)
 {
 	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	struct ipu_ic *ic;
+	struct ipuv3_channel *out_ch, *rot_in_ch, *rot_out_ch;
 	int ret, task = ic_priv->task_id;
 
 	priv->ipu = priv->md->ipu[ic_priv->ipu_id];
 
-	priv->ic = ipu_ic_get(priv->ipu, task);
-	if (IS_ERR(priv->ic)) {
+	ic = ipu_ic_get(priv->ipu, task);
+	if (IS_ERR(ic)) {
 		v4l2_err(&ic_priv->sd, "failed to get IC\n");
-		ret = PTR_ERR(priv->ic);
+		ret = PTR_ERR(ic);
 		goto out;
 	}
+	priv->ic = ic;
 
-	priv->out_ch = ipu_idmac_get(priv->ipu,
-				     prp_channel[task].out_ch);
-	if (IS_ERR(priv->out_ch)) {
+	out_ch = ipu_idmac_get(priv->ipu, prp_channel[task].out_ch);
+	if (IS_ERR(out_ch)) {
 		v4l2_err(&ic_priv->sd, "could not get IDMAC channel %u\n",
 			 prp_channel[task].out_ch);
-		ret = PTR_ERR(priv->out_ch);
+		ret = PTR_ERR(out_ch);
 		goto out;
 	}
+	priv->out_ch = out_ch;
 
-	priv->rot_in_ch = ipu_idmac_get(priv->ipu,
-					prp_channel[task].rot_in_ch);
-	if (IS_ERR(priv->rot_in_ch)) {
+	rot_in_ch = ipu_idmac_get(priv->ipu, prp_channel[task].rot_in_ch);
+	if (IS_ERR(rot_in_ch)) {
 		v4l2_err(&ic_priv->sd, "could not get IDMAC channel %u\n",
 			 prp_channel[task].rot_in_ch);
-		ret = PTR_ERR(priv->rot_in_ch);
+		ret = PTR_ERR(rot_in_ch);
 		goto out;
 	}
+	priv->rot_in_ch = rot_in_ch;
 
-	priv->rot_out_ch = ipu_idmac_get(priv->ipu,
-					 prp_channel[task].rot_out_ch);
-	if (IS_ERR(priv->rot_out_ch)) {
+	rot_out_ch = ipu_idmac_get(priv->ipu, prp_channel[task].rot_out_ch);
+	if (IS_ERR(rot_out_ch)) {
 		v4l2_err(&ic_priv->sd, "could not get IDMAC channel %u\n",
 			 prp_channel[task].rot_out_ch);
-		ret = PTR_ERR(priv->rot_out_ch);
+		ret = PTR_ERR(rot_out_ch);
 		goto out;
 	}
+	priv->rot_out_ch = rot_out_ch;
 
 	return 0;
 out:
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index a2d26693912e..17fd1e61dd5d 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -122,11 +122,11 @@ static inline struct csi_priv *sd_to_dev(struct v4l2_subdev *sdev)
 
 static void csi_idmac_put_ipu_resources(struct csi_priv *priv)
 {
-	if (!IS_ERR_OR_NULL(priv->idmac_ch))
+	if (priv->idmac_ch)
 		ipu_idmac_put(priv->idmac_ch);
 	priv->idmac_ch = NULL;
 
-	if (!IS_ERR_OR_NULL(priv->smfc))
+	if (priv->smfc)
 		ipu_smfc_put(priv->smfc);
 	priv->smfc = NULL;
 }
@@ -134,23 +134,27 @@ static void csi_idmac_put_ipu_resources(struct csi_priv *priv)
 static int csi_idmac_get_ipu_resources(struct csi_priv *priv)
 {
 	int ch_num, ret;
+	struct ipu_smfc *smfc;
+	struct ipuv3_channel *idmac_ch;
 
 	ch_num = IPUV3_CHANNEL_CSI0 + priv->smfc_id;
 
-	priv->smfc = ipu_smfc_get(priv->ipu, ch_num);
-	if (IS_ERR(priv->smfc)) {
+	smfc = ipu_smfc_get(priv->ipu, ch_num);
+	if (IS_ERR(smfc)) {
 		v4l2_err(&priv->sd, "failed to get SMFC\n");
-		ret = PTR_ERR(priv->smfc);
+		ret = PTR_ERR(smfc);
 		goto out;
 	}
+	priv->smfc = smfc;
 
-	priv->idmac_ch = ipu_idmac_get(priv->ipu, ch_num);
-	if (IS_ERR(priv->idmac_ch)) {
+	idmac_ch = ipu_idmac_get(priv->ipu, ch_num);
+	if (IS_ERR(idmac_ch)) {
 		v4l2_err(&priv->sd, "could not get IDMAC channel %u\n",
 			 ch_num);
-		ret = PTR_ERR(priv->idmac_ch);
+		ret = PTR_ERR(idmac_ch);
 		goto out;
 	}
+	priv->idmac_ch = idmac_ch;
 
 	return 0;
 out:
@@ -1583,6 +1587,7 @@ static int csi_unsubscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
 static int csi_registered(struct v4l2_subdev *sd)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct ipu_csi *csi;
 	int i, ret;
 	u32 code;
 
@@ -1590,11 +1595,12 @@ static int csi_registered(struct v4l2_subdev *sd)
 	priv->md = dev_get_drvdata(sd->v4l2_dev->dev);
 
 	/* get handle to IPU CSI */
-	priv->csi = ipu_csi_get(priv->ipu, priv->csi_id);
-	if (IS_ERR(priv->csi)) {
+	csi = ipu_csi_get(priv->ipu, priv->csi_id);
+	if (IS_ERR(csi)) {
 		v4l2_err(&priv->sd, "failed to get CSI%d\n", priv->csi_id);
-		return PTR_ERR(priv->csi);
+		return PTR_ERR(csi);
 	}
+	priv->csi = csi;
 
 	for (i = 0; i < CSI_NUM_PADS; i++) {
 		priv->pad[i].flags = (i == CSI_SINK_PAD) ?
@@ -1663,7 +1669,7 @@ static void csi_unregistered(struct v4l2_subdev *sd)
 	if (priv->fim)
 		imx_media_fim_free(priv->fim);
 
-	if (!IS_ERR_OR_NULL(priv->csi))
+	if (priv->csi)
 		ipu_csi_put(priv->csi);
 }
 
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 48cbc7716758..d96f4512224f 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -87,11 +87,11 @@ imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 	if (pdev)
 		devname = dev_name(&pdev->dev);
 
-	/* return NULL if this subdev already added */
+	/* return -EEXIST if this subdev already added */
 	if (imx_media_find_async_subdev(imxmd, np, devname)) {
 		dev_dbg(imxmd->md.dev, "%s: already added %s\n",
 			__func__, np ? np->name : devname);
-		imxsd = NULL;
+		imxsd = ERR_PTR(-EEXIST);
 		goto out;
 	}
 
diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index b026fe66467c..12df09f52490 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -100,9 +100,9 @@ static void of_get_remote_pad(struct device_node *epnode,
 	}
 }
 
-static struct imx_media_subdev *
+static int
 of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
-		bool is_csi_port)
+		bool is_csi_port, struct imx_media_subdev **subdev)
 {
 	struct imx_media_subdev *imxsd;
 	int i, num_pads, ret;
@@ -110,13 +110,25 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 	if (!of_device_is_available(sd_np)) {
 		dev_dbg(imxmd->md.dev, "%s: %s not enabled\n", __func__,
 			sd_np->name);
-		return NULL;
+		*subdev = NULL;
+		/* unavailable is not an error */
+		return 0;
 	}
 
 	/* register this subdev with async notifier */
 	imxsd = imx_media_add_async_subdev(imxmd, sd_np, NULL);
-	if (IS_ERR_OR_NULL(imxsd))
-		return imxsd;
+	ret = PTR_ERR_OR_ZERO(imxsd);
+	if (ret) {
+		if (ret == -EEXIST) {
+			/* already added, everything is fine */
+			*subdev = NULL;
+			return 0;
+		}
+
+		/* other error, can't continue */
+		return ret;
+	}
+	*subdev = imxsd;
 
 	if (is_csi_port) {
 		/*
@@ -137,10 +149,11 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 	} else {
 		num_pads = of_get_port_count(sd_np);
 		if (num_pads != 1) {
+			/* confused, but no reason to give up here */
 			dev_warn(imxmd->md.dev,
 				 "%s: unknown device %s with %d ports\n",
 				 __func__, sd_np->name, num_pads);
-			return NULL;
+			return 0;
 		}
 
 		/*
@@ -151,7 +164,7 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 	}
 
 	if (imxsd->num_sink_pads >= num_pads)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	imxsd->num_src_pads = num_pads - imxsd->num_sink_pads;
 
@@ -191,20 +204,15 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 
 			ret = of_add_pad_link(imxmd, pad, sd_np, remote_np,
 					      i, remote_pad);
-			if (ret) {
-				imxsd = ERR_PTR(ret);
+			if (ret)
 				break;
-			}
 
 			if (i < imxsd->num_sink_pads) {
 				/* follow sink endpoints upstream */
-				remote_imxsd = of_parse_subdev(imxmd,
-							       remote_np,
-							       false);
-				if (IS_ERR(remote_imxsd)) {
-					imxsd = remote_imxsd;
+				ret = of_parse_subdev(imxmd, remote_np,
+						      false, &remote_imxsd);
+				if (ret)
 					break;
-				}
 			}
 
 			of_node_put(remote_np);
@@ -212,14 +220,14 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 
 		if (port != sd_np)
 			of_node_put(port);
-		if (IS_ERR(imxsd)) {
+		if (ret) {
 			of_node_put(remote_np);
 			of_node_put(epnode);
 			break;
 		}
 	}
 
-	return imxsd;
+	return ret;
 }
 
 int imx_media_of_parse(struct imx_media_dev *imxmd,
@@ -236,11 +244,9 @@ int imx_media_of_parse(struct imx_media_dev *imxmd,
 		if (!csi_np)
 			break;
 
-		lcsi = of_parse_subdev(imxmd, csi_np, true);
-		if (IS_ERR(lcsi)) {
-			ret = PTR_ERR(lcsi);
+		ret = of_parse_subdev(imxmd, csi_np, true, &lcsi);
+		if (ret)
 			goto err_put;
-		}
 
 		ret = of_property_read_u32(csi_np, "reg", &csi_id);
 		if (ret) {
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 7eabdc4aa79f..433474d58e3e 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -126,15 +126,15 @@ struct vdic_priv {
 
 static void vdic_put_ipu_resources(struct vdic_priv *priv)
 {
-	if (!IS_ERR_OR_NULL(priv->vdi_in_ch_p))
+	if (priv->vdi_in_ch_p)
 		ipu_idmac_put(priv->vdi_in_ch_p);
 	priv->vdi_in_ch_p = NULL;
 
-	if (!IS_ERR_OR_NULL(priv->vdi_in_ch))
+	if (priv->vdi_in_ch)
 		ipu_idmac_put(priv->vdi_in_ch);
 	priv->vdi_in_ch = NULL;
 
-	if (!IS_ERR_OR_NULL(priv->vdi_in_ch_n))
+	if (priv->vdi_in_ch_n)
 		ipu_idmac_put(priv->vdi_in_ch_n);
 	priv->vdi_in_ch_n = NULL;
 
@@ -146,40 +146,43 @@ static void vdic_put_ipu_resources(struct vdic_priv *priv)
 static int vdic_get_ipu_resources(struct vdic_priv *priv)
 {
 	int ret, err_chan;
+	struct ipuv3_channel *ch;
+	struct ipu_vdi *vdi;
 
 	priv->ipu = priv->md->ipu[priv->ipu_id];
 
-	priv->vdi = ipu_vdi_get(priv->ipu);
-	if (IS_ERR(priv->vdi)) {
+	vdi = ipu_vdi_get(priv->ipu);
+	if (IS_ERR(vdi)) {
 		v4l2_err(&priv->sd, "failed to get VDIC\n");
-		ret = PTR_ERR(priv->vdi);
+		ret = PTR_ERR(vdi);
 		goto out;
 	}
+	priv->vdi = vdi;
 
 	if (!priv->csi_direct) {
-		priv->vdi_in_ch_p = ipu_idmac_get(priv->ipu,
-						  IPUV3_CHANNEL_MEM_VDI_PREV);
-		if (IS_ERR(priv->vdi_in_ch_p)) {
+		ch = ipu_idmac_get(priv->ipu, IPUV3_CHANNEL_MEM_VDI_PREV);
+		if (IS_ERR(ch)) {
 			err_chan = IPUV3_CHANNEL_MEM_VDI_PREV;
-			ret = PTR_ERR(priv->vdi_in_ch_p);
+			ret = PTR_ERR(ch);
 			goto out_err_chan;
 		}
+		priv->vdi_in_ch_p = ch;
 
-		priv->vdi_in_ch = ipu_idmac_get(priv->ipu,
-						IPUV3_CHANNEL_MEM_VDI_CUR);
-		if (IS_ERR(priv->vdi_in_ch)) {
+		ch = ipu_idmac_get(priv->ipu, IPUV3_CHANNEL_MEM_VDI_CUR);
+		if (IS_ERR(ch)) {
 			err_chan = IPUV3_CHANNEL_MEM_VDI_CUR;
-			ret = PTR_ERR(priv->vdi_in_ch);
+			ret = PTR_ERR(ch);
 			goto out_err_chan;
 		}
+		priv->vdi_in_ch = ch;
 
-		priv->vdi_in_ch_n = ipu_idmac_get(priv->ipu,
-						  IPUV3_CHANNEL_MEM_VDI_NEXT);
+		ch = ipu_idmac_get(priv->ipu, IPUV3_CHANNEL_MEM_VDI_NEXT);
 		if (IS_ERR(priv->vdi_in_ch_n)) {
 			err_chan = IPUV3_CHANNEL_MEM_VDI_NEXT;
-			ret = PTR_ERR(priv->vdi_in_ch_n);
+			ret = PTR_ERR(ch);
 			goto out_err_chan;
 		}
+		priv->vdi_in_ch_n = ch;
 	}
 
 	return 0;
-- 
2.9.0
