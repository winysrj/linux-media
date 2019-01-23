Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F81C282C2
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEC9520870
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:52:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="gilSA5MU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfAWKwx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:52:53 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36899 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfAWKwx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 05:52:53 -0500
Received: by mail-wm1-f68.google.com with SMTP id g67so1488921wmd.2
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 02:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LjxkiVwNlc79xcX+LzRgJ6nLLFQrFujTHIfXpzjjP/0=;
        b=gilSA5MUoQQRxu1ka5rHm2n+WimCpuI5k+75IQjfifHG/2qbuN1R1l2xYcSJBseY7/
         gOHHNEAH2Feqb0Z33piNxNT2sEKz74rCHG4Iorq7nNyVjEenQXQqPSBGNfG2eEBn3Eb4
         4SXyvipLYi9a8F0J6jMgCNwTA4baVk+o1ujg0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LjxkiVwNlc79xcX+LzRgJ6nLLFQrFujTHIfXpzjjP/0=;
        b=DU9r9WK+3A0juMjZVdOGLctEthadL9lIuL0GaRAXr5TicZIOBzobVJaU0kbR+yyGgM
         CJTLNlT6DLTPF/8PB79cuBBpZKT5+XVVno8gxbcYJGiCPeCwMmmWaRL/POfTTx70YtmJ
         K5VLRmsdhs8c6fAicfwiIPHQtYYqnC2WCGilhsnJ+O75G4AHccGJZGtI2Ga1rbSH3F9G
         /UbyuWOHYSdtk4v1xRzoiI1urJb0dpJUGKrune26/Xlx6hiAicjwpKktzZEpRgLhikBX
         FVVWwkfHY3vuYk3MURSXUy88//nVrFrOVFoaCHg5gy/yhrvkbbjVcRvRE6E3vYV6++KY
         7lQw==
X-Gm-Message-State: AJcUukegWZ+6NuJrlo1S/Ce0/l9/Sb6YY7fRdOOcBBZS9/uC1JKaqV+j
        t8Lh9XWGZXGqYCL6zECrA05dVw==
X-Google-Smtp-Source: ALg8bN7SgXmyIlGSXO+KS+R1cQ7fJ8WzMzDIM8HtXgUTYanAs+aMVk1EjQ1G4GP8+leas2LktxXArQ==
X-Received: by 2002:a7b:cb96:: with SMTP id m22mr2268013wmi.39.1548240769459;
        Wed, 23 Jan 2019 02:52:49 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id 143sm120717646wml.14.2019.01.23.02.52.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 02:52:49 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v10 02/13] media: staging/imx: rearrange group id to take in account IPU
Date:   Wed, 23 Jan 2019 10:52:11 +0000
Message-Id: <20190123105222.2378-3-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190123105222.2378-1-rui.silva@linaro.org>
References: <20190123105222.2378-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Some imx system do not have IPU, so prepare the imx media drivers to
support this kind of devices. Rename the group ids to include an _IPU_
prefix, add a new group id to support systems with only a CSI without
IPU, and also rename the create internal links to make it clear that
only systems with IPU have internal subdevices.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/imx-ic-common.c     |  6 ++---
 drivers/staging/media/imx/imx-ic-prp.c        | 16 ++++++-------
 drivers/staging/media/imx/imx-media-csi.c     |  6 ++---
 drivers/staging/media/imx/imx-media-dev.c     | 22 ++++++++++--------
 .../staging/media/imx/imx-media-internal-sd.c | 20 ++++++++--------
 drivers/staging/media/imx/imx-media-utils.c   | 12 +++++-----
 drivers/staging/media/imx/imx-media.h         | 23 ++++++++++---------
 7 files changed, 55 insertions(+), 50 deletions(-)

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
index 98923fc844ce..2702548f83cf 100644
--- a/drivers/staging/media/imx/imx-ic-prp.c
+++ b/drivers/staging/media/imx/imx-ic-prp.c
@@ -77,7 +77,7 @@ static int prp_start(struct prp_priv *priv)
 	priv->ipu = priv->md->ipu[ic_priv->ipu_id];
 
 	/* set IC to receive from CSI or VDI depending on source */
-	src_is_vdic = !!(priv->src_sd->grp_id & IMX_MEDIA_GRP_ID_VDIC);
+	src_is_vdic = !!(priv->src_sd->grp_id & IMX_MEDIA_GRP_ID_IPU_VDIC);
 
 	ipu_set_ic_src_mux(priv->ipu, priv->csi_id, src_is_vdic);
 
@@ -237,8 +237,8 @@ static int prp_link_setup(struct media_entity *entity,
 				ret = -EBUSY;
 				goto out;
 			}
-			if (priv->sink_sd_prpenc && (remote_sd->grp_id &
-						     IMX_MEDIA_GRP_ID_VDIC)) {
+			if (priv->sink_sd_prpenc &&
+			    (remote_sd->grp_id & IMX_MEDIA_GRP_ID_IPU_VDIC)) {
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
index 4223f8d418ae..a12fa1dd989e 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1029,10 +1029,10 @@ static int csi_link_setup(struct media_entity *entity,
 
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
@@ -1877,7 +1877,7 @@ static int imx_csi_probe(struct platform_device *pdev)
 	priv->sd.owner = THIS_MODULE;
 	priv->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 	priv->sd.grp_id = priv->csi_id ?
-		IMX_MEDIA_GRP_ID_CSI1 : IMX_MEDIA_GRP_ID_CSI0;
+		IMX_MEDIA_GRP_ID_IPU_CSI1 : IMX_MEDIA_GRP_ID_IPU_CSI0;
 	imx_media_grp_id_to_sd_name(priv->sd.name, sizeof(priv->sd.name),
 				    priv->sd.grp_id, ipu_get_num(priv->ipu));
 
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 21f65af5c738..c8fc514f890e 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -125,7 +125,7 @@ int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
 
 	mutex_lock(&imxmd->mutex);
 
-	if (sd->grp_id & IMX_MEDIA_GRP_ID_CSI) {
+	if (sd->grp_id & IMX_MEDIA_GRP_ID_IPU_CSI) {
 		ret = imx_media_get_ipu(imxmd, sd);
 		if (ret)
 			goto out;
@@ -149,13 +149,13 @@ static int imx_media_create_links(struct v4l2_async_notifier *notifier)
 
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
@@ -163,9 +163,13 @@ static int imx_media_create_links(struct v4l2_async_notifier *notifier)
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
index 0eaa353d5cb3..3e35d01d18dd 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -696,20 +696,20 @@ void imx_media_grp_id_to_sd_name(char *sd_name, int sz, u32 grp_id, int ipu_id)
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
index b7f11c36461b..a8fc084a33fc 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -251,8 +251,8 @@ void imx_media_fim_free(struct imx_media_fim *fim);
 
 /* imx-media-internal-sd.c */
 int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd);
-int imx_media_create_internal_links(struct imx_media_dev *imxmd,
-				    struct v4l2_subdev *sd);
+int imx_media_create_ipu_internal_links(struct imx_media_dev *imxmd,
+					struct v4l2_subdev *sd);
 void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd);
 
 /* imx-media-of.c */
@@ -278,14 +278,15 @@ void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
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
2.20.1

