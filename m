Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2BAC282CC
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D761C214DA
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:00:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="VVO/cs+y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbfBDMAz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 07:00:55 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41540 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728786AbfBDMAy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2019 07:00:54 -0500
Received: by mail-wr1-f67.google.com with SMTP id x10so14081467wrs.8
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2019 04:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j7uriWHtbXMd4oYn60G3Oqrc1/rrzjF3pgxMYb53O6k=;
        b=VVO/cs+y9fdr/pJL2K/oAGxb4X9sKfvFIgLxVGVtz4gmokV48B53tsaoybfB7n8q7r
         xDmO+11X3zIu/CmsyJFPt8h8WFbSSXFCZeE4JVZCsNv3ZzVTJKr3N0wAgo7Dwr5oHQ6r
         +xH/YbjxwjFhBEpy8GlMLXRCfCyFXZgzN9joY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j7uriWHtbXMd4oYn60G3Oqrc1/rrzjF3pgxMYb53O6k=;
        b=rHjHI1o0zKW6+wCL/OaV7vBIph2pTW754r2is0JvGJMREHUSIj96S3uRDlmyprbXCC
         ktSsT0yJcBUa4U5ixX+b0ZxMExf3B5YLsPt+W31iZC6JTvYhalIbzx5qEXZOQbsgfUGM
         f5d7W/SILSV7jOUVXLoOSKgz4VoGsTdbsLI+GgzzMhH/fbqTlR8FFIrTiwznz2WskQJj
         n2j9nujnGnWL6QViiqEuMvkTMMaAmwqqpMo6x6biIEwDP+UVzF2mP+kdtPGLNb99QEzT
         pXjMFRFXmjGqECxRhnWnb2UioX7AsTC3yABwRgU7SBi9qH5ISIogrdQlFIn6TwLcyj47
         ebSA==
X-Gm-Message-State: AJcUukdeduWvlGoAKEKGLmGoiNLEXUJKELqHyoWVQwrA5MgSIcya7Q5d
        +d9rEgGDHEobNb5CK3SM1T+prA==
X-Google-Smtp-Source: ALg8bN62/7jIqY7FBrhybCYe9D7soauWEybsOWymz+q+UTvpmffF+Wp3Uh6IhuErc1djmbC9d0S52A==
X-Received: by 2002:a05:6000:120a:: with SMTP id e10mr49261988wrx.85.1549281651770;
        Mon, 04 Feb 2019 04:00:51 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id s8sm15404543wrn.44.2019.02.04.04.00.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 04:00:51 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v12 01/13] media: staging/imx: refactor imx media device probe
Date:   Mon,  4 Feb 2019 12:00:27 +0000
Message-Id: <20190204120039.1198-2-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190204120039.1198-1-rui.silva@linaro.org>
References: <20190204120039.1198-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Refactor and move media device initialization code to a new common
module, so it can be used by other devices, this will allow for example
a near to introduce imx7 CSI driver, to use this media device.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/Makefile            |  1 +
 .../staging/media/imx/imx-media-dev-common.c  | 89 +++++++++++++++++++
 drivers/staging/media/imx/imx-media-dev.c     | 81 ++++-------------
 drivers/staging/media/imx/imx-media-of.c      |  6 +-
 drivers/staging/media/imx/imx-media.h         | 12 +++
 5 files changed, 123 insertions(+), 66 deletions(-)
 create mode 100644 drivers/staging/media/imx/imx-media-dev-common.c

diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
index 698a4210316e..a30b3033f9a3 100644
--- a/drivers/staging/media/imx/Makefile
+++ b/drivers/staging/media/imx/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 imx-media-objs := imx-media-dev.o imx-media-internal-sd.o imx-media-of.o
+imx-media-objs += imx-media-dev-common.o
 imx-media-common-objs := imx-media-utils.o imx-media-fim.o
 imx-media-ic-objs := imx-ic-common.o imx-ic-prp.o imx-ic-prpencvf.o
 
diff --git a/drivers/staging/media/imx/imx-media-dev-common.c b/drivers/staging/media/imx/imx-media-dev-common.c
new file mode 100644
index 000000000000..8156bc8a6207
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-dev-common.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL
+/*
+ * V4L2 Media Controller Driver for Freescale common i.MX5/6/7 SOC
+ *
+ * Copyright (c) 2018 Linaro Ltd
+ * Copyright (c) 2016 Mentor Graphics Inc.
+ */
+
+#include <linux/of_graph.h>
+#include <linux/of_platform.h>
+#include "imx-media.h"
+
+static const struct v4l2_async_notifier_operations imx_media_subdev_ops = {
+	.bound = imx_media_subdev_bound,
+	.complete = imx_media_probe_complete,
+};
+
+static const struct media_device_ops imx_media_md_ops = {
+	.link_notify = imx_media_link_notify,
+};
+
+struct imx_media_dev *imx_media_dev_init(struct device *dev)
+{
+	struct imx_media_dev *imxmd;
+	int ret;
+
+	imxmd = devm_kzalloc(dev, sizeof(*imxmd), GFP_KERNEL);
+	if (!imxmd)
+		return ERR_PTR(-ENOMEM);
+
+	dev_set_drvdata(dev, imxmd);
+
+	strlcpy(imxmd->md.model, "imx-media", sizeof(imxmd->md.model));
+	imxmd->md.ops = &imx_media_md_ops;
+	imxmd->md.dev = dev;
+
+	mutex_init(&imxmd->mutex);
+
+	imxmd->v4l2_dev.mdev = &imxmd->md;
+	strlcpy(imxmd->v4l2_dev.name, "imx-media",
+		sizeof(imxmd->v4l2_dev.name));
+
+	media_device_init(&imxmd->md);
+
+	ret = v4l2_device_register(dev, &imxmd->v4l2_dev);
+	if (ret < 0) {
+		v4l2_err(&imxmd->v4l2_dev,
+			 "Failed to register v4l2_device: %d\n", ret);
+		goto cleanup;
+	}
+
+	dev_set_drvdata(imxmd->v4l2_dev.dev, imxmd);
+
+	INIT_LIST_HEAD(&imxmd->vdev_list);
+
+	v4l2_async_notifier_init(&imxmd->notifier);
+
+	return imxmd;
+
+cleanup:
+	media_device_cleanup(&imxmd->md);
+
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(imx_media_dev_init);
+
+int imx_media_dev_notifier_register(struct imx_media_dev *imxmd)
+{
+	int ret;
+
+	/* no subdevs? just bail */
+	if (list_empty(&imxmd->notifier.asd_list)) {
+		v4l2_err(&imxmd->v4l2_dev, "no subdevs\n");
+		return -ENODEV;
+	}
+
+	/* prepare the async subdev notifier and register it */
+	imxmd->notifier.ops = &imx_media_subdev_ops;
+	ret = v4l2_async_notifier_register(&imxmd->v4l2_dev,
+					   &imxmd->notifier);
+	if (ret) {
+		v4l2_err(&imxmd->v4l2_dev,
+			 "v4l2_async_notifier_register failed with %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_dev_notifier_register);
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 4b344a4a3706..6e36693d7598 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -116,9 +116,9 @@ static int imx_media_get_ipu(struct imx_media_dev *imxmd,
 }
 
 /* async subdev bound notifier */
-static int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
-				  struct v4l2_subdev *sd,
-				  struct v4l2_async_subdev *asd)
+int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
+			   struct v4l2_subdev *sd,
+			   struct v4l2_async_subdev *asd)
 {
 	struct imx_media_dev *imxmd = notifier2dev(notifier);
 	int ret = 0;
@@ -302,7 +302,7 @@ static int imx_media_create_pad_vdev_lists(struct imx_media_dev *imxmd)
 }
 
 /* async subdev complete notifier */
-static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
+int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
 {
 	struct imx_media_dev *imxmd = notifier2dev(notifier);
 	int ret;
@@ -326,11 +326,6 @@ static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
 	return media_device_register(&imxmd->md);
 }
 
-static const struct v4l2_async_notifier_operations imx_media_subdev_ops = {
-	.bound = imx_media_subdev_bound,
-	.complete = imx_media_probe_complete,
-};
-
 /*
  * adds controls to a video device from an entity subdevice.
  * Continues upstream from the entity's sink pads.
@@ -374,8 +369,8 @@ static int imx_media_inherit_controls(struct imx_media_dev *imxmd,
 	return ret;
 }
 
-static int imx_media_link_notify(struct media_link *link, u32 flags,
-				 unsigned int notification)
+int imx_media_link_notify(struct media_link *link, u32 flags,
+			  unsigned int notification)
 {
 	struct media_entity *source = link->source->entity;
 	struct imx_media_pad_vdev *pad_vdev;
@@ -438,10 +433,6 @@ static int imx_media_link_notify(struct media_link *link, u32 flags,
 	return ret;
 }
 
-static const struct media_device_ops imx_media_md_ops = {
-	.link_notify = imx_media_link_notify,
-};
-
 static int imx_media_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -449,76 +440,38 @@ static int imx_media_probe(struct platform_device *pdev)
 	struct imx_media_dev *imxmd;
 	int ret;
 
-	imxmd = devm_kzalloc(dev, sizeof(*imxmd), GFP_KERNEL);
-	if (!imxmd)
-		return -ENOMEM;
-
-	dev_set_drvdata(dev, imxmd);
-
-	strscpy(imxmd->md.model, "imx-media", sizeof(imxmd->md.model));
-	imxmd->md.ops = &imx_media_md_ops;
-	imxmd->md.dev = dev;
-
-	mutex_init(&imxmd->mutex);
-
-	imxmd->v4l2_dev.mdev = &imxmd->md;
-	strscpy(imxmd->v4l2_dev.name, "imx-media",
-		sizeof(imxmd->v4l2_dev.name));
-
-	media_device_init(&imxmd->md);
-
-	ret = v4l2_device_register(dev, &imxmd->v4l2_dev);
-	if (ret < 0) {
-		v4l2_err(&imxmd->v4l2_dev,
-			 "Failed to register v4l2_device: %d\n", ret);
-		goto cleanup;
-	}
-
-	dev_set_drvdata(imxmd->v4l2_dev.dev, imxmd);
-
-	INIT_LIST_HEAD(&imxmd->vdev_list);
-
-	v4l2_async_notifier_init(&imxmd->notifier);
+	imxmd = imx_media_dev_init(dev);
+	if (IS_ERR(imxmd))
+		return PTR_ERR(imxmd);
 
 	ret = imx_media_add_of_subdevs(imxmd, node);
 	if (ret) {
 		v4l2_err(&imxmd->v4l2_dev,
 			 "add_of_subdevs failed with %d\n", ret);
-		goto notifier_cleanup;
+		goto cleanup;
 	}
 
 	ret = imx_media_add_internal_subdevs(imxmd);
 	if (ret) {
 		v4l2_err(&imxmd->v4l2_dev,
 			 "add_internal_subdevs failed with %d\n", ret);
-		goto notifier_cleanup;
-	}
-
-	/* no subdevs? just bail */
-	if (list_empty(&imxmd->notifier.asd_list)) {
-		ret = -ENODEV;
-		goto notifier_cleanup;
+		goto cleanup;
 	}
 
-	/* prepare the async subdev notifier and register it */
-	imxmd->notifier.ops = &imx_media_subdev_ops;
-	ret = v4l2_async_notifier_register(&imxmd->v4l2_dev,
-					   &imxmd->notifier);
-	if (ret) {
-		v4l2_err(&imxmd->v4l2_dev,
-			 "v4l2_async_notifier_register failed with %d\n", ret);
+	ret = imx_media_dev_notifier_register(imxmd);
+	if (ret)
 		goto del_int;
-	}
 
 	return 0;
 
 del_int:
 	imx_media_remove_internal_subdevs(imxmd);
-notifier_cleanup:
+
+cleanup:
 	v4l2_async_notifier_cleanup(&imxmd->notifier);
 	v4l2_device_unregister(&imxmd->v4l2_dev);
-cleanup:
 	media_device_cleanup(&imxmd->md);
+
 	return ret;
 }
 
@@ -532,8 +485,8 @@ static int imx_media_remove(struct platform_device *pdev)
 	v4l2_async_notifier_unregister(&imxmd->notifier);
 	imx_media_remove_internal_subdevs(imxmd);
 	v4l2_async_notifier_cleanup(&imxmd->notifier);
-	v4l2_device_unregister(&imxmd->v4l2_dev);
 	media_device_unregister(&imxmd->md);
+	v4l2_device_unregister(&imxmd->v4l2_dev);
 	media_device_cleanup(&imxmd->md);
 
 	return 0;
diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index a01327f6e045..03446335ac03 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -20,7 +20,8 @@
 #include <video/imx-ipu-v3.h>
 #include "imx-media.h"
 
-static int of_add_csi(struct imx_media_dev *imxmd, struct device_node *csi_np)
+int imx_media_of_add_csi(struct imx_media_dev *imxmd,
+			 struct device_node *csi_np)
 {
 	int ret;
 
@@ -45,6 +46,7 @@ static int of_add_csi(struct imx_media_dev *imxmd, struct device_node *csi_np)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(imx_media_of_add_csi);
 
 int imx_media_add_of_subdevs(struct imx_media_dev *imxmd,
 			     struct device_node *np)
@@ -57,7 +59,7 @@ int imx_media_add_of_subdevs(struct imx_media_dev *imxmd,
 		if (!csi_np)
 			break;
 
-		ret = of_add_csi(imxmd, csi_np);
+		ret = imx_media_of_add_csi(imxmd, csi_np);
 		of_node_put(csi_np);
 		if (ret)
 			return ret;
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index bc7feb81937c..27623bb5af4a 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -226,6 +226,16 @@ int imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 			       struct fwnode_handle *fwnode,
 			       struct platform_device *pdev);
 
+int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
+			   struct v4l2_subdev *sd,
+			   struct v4l2_async_subdev *asd);
+int imx_media_link_notify(struct media_link *link, u32 flags,
+			  unsigned int notification);
+int imx_media_probe_complete(struct v4l2_async_notifier *notifier);
+
+struct imx_media_dev *imx_media_dev_init(struct device *dev);
+int imx_media_dev_notifier_register(struct imx_media_dev *imxmd);
+
 /* imx-media-fim.c */
 struct imx_media_fim;
 void imx_media_fim_eof_monitor(struct imx_media_fim *fim, ktime_t timestamp);
@@ -249,6 +259,8 @@ int imx_media_create_of_links(struct imx_media_dev *imxmd,
 			      struct v4l2_subdev *sd);
 int imx_media_create_csi_of_links(struct imx_media_dev *imxmd,
 				  struct v4l2_subdev *csi);
+int imx_media_of_add_csi(struct imx_media_dev *imxmd,
+			 struct device_node *csi_np);
 
 /* imx-media-capture.c */
 struct imx_media_video_dev *
-- 
2.20.1

