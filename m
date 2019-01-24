Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1766EC282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6666217D7
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:09:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="LEUQ/CPt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbfAXQJk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:09:40 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39781 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbfAXQJj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 11:09:39 -0500
Received: by mail-wm1-f66.google.com with SMTP id y8so3629068wmi.4
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 08:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d2xajMIxBYbswzj5wLbN/npSeaw9FvefRcGi6wwK3oI=;
        b=LEUQ/CPtIORrh49+EuoHZtTBcRH/A2sb7ALk5xVqG8vVIvk5pKHMvY7ra8u983XEuh
         QCKyKXFqmSU3WLD+rGz3RE9vdMkp6EvUzd29fHMtFDLftRakzjvwAaeBw0OlvKn8BYug
         X9IPQsLpmQASj1t28jT7igTE79LRpp+P+0XcI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d2xajMIxBYbswzj5wLbN/npSeaw9FvefRcGi6wwK3oI=;
        b=RffmdrA5lL2W8j+8MH0MWjib0cS6RNAeqZN8BqsMDJbRKcjPTcewZ6ZZsrh6qoYIYL
         ab63DEfY3AhKrbb0yJcMEXffKl+HBjb0G2luepwIc8ziD2NymApU7m/Xd0DpTzP8g5SK
         jzmpGY8kE/sYcCaJJesURHPZcW33IMxtkOSQ+SuRzdSb1IYOq2157WKzh8ytgjbfhutg
         IY7BwSz5/TeNoffZXCJ3jf92Y7o0krQAVfUC/ZHHxQMUmqmfNkdgTZrImXyxfifFn6kv
         /4DivJ0M3LSGNz3+xV65nyUT/gKdkTFavvcBSUzOIf/nKpDyx7eN/ZTbtMhNfgIClAgH
         KipQ==
X-Gm-Message-State: AJcUukcGYOc2UUK7DNHHG0pDd/xbi9eWfk7+yGJxoaj/IQ4Ip3oY3RrJ
        CBkdGaHX0YppOCmlB8hMtqwang==
X-Google-Smtp-Source: ALg8bN7XAkCYDU499Igyh8dMLvwVLETdxFE4scxZMrIpk/CqU2tm4moRr5tjC+48+xt4yf25L/j38g==
X-Received: by 2002:a1c:de57:: with SMTP id v84mr3232769wmg.55.1548346176520;
        Thu, 24 Jan 2019 08:09:36 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id e16sm179880299wrn.72.2019.01.24.08.09.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 08:09:35 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v11 01/13] media: staging/imx: rearrange group id to take in account IPU
Date:   Thu, 24 Jan 2019 16:09:16 +0000
Message-Id: <20190124160928.31884-2-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190124160928.31884-1-rui.silva@linaro.org>
References: <20190124160928.31884-1-rui.silva@linaro.org>
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
index 6e36693d7598..c669d6a9ea76 100644
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
index 27623bb5af4a..ad0fdd4f7d9e 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -248,8 +248,8 @@ void imx_media_fim_free(struct imx_media_fim *fim);
 
 /* imx-media-internal-sd.c */
 int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd);
-int imx_media_create_internal_links(struct imx_media_dev *imxmd,
-				    struct v4l2_subdev *sd);
+int imx_media_create_ipu_internal_links(struct imx_media_dev *imxmd,
+					struct v4l2_subdev *sd);
 void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd);
 
 /* imx-media-of.c */
@@ -275,14 +275,15 @@ void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
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

