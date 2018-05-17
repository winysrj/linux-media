Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:43382 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbeEQMuy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 08:50:54 -0400
Received: by mail-wr0-f196.google.com with SMTP id v15-v6so5558481wrm.10
        for <linux-media@vger.kernel.org>; Thu, 17 May 2018 05:50:53 -0700 (PDT)
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
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v4 01/12] media: staging/imx: refactor imx media device probe
Date: Thu, 17 May 2018 13:50:22 +0100
Message-Id: <20180517125033.18050-2-rui.silva@linaro.org>
In-Reply-To: <20180517125033.18050-1-rui.silva@linaro.org>
References: <20180517125033.18050-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refactor and move media device initialization code to a new common module, so it
can be used by other devices, this will allow for example a near to introduce
imx7 CSI driver, to use this media device.

Also introduce a new flag to control the presence of IPU or not (imx6/5 has
this but imx7 does not).

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/Makefile            |   1 +
 .../staging/media/imx/imx-media-dev-common.c  | 102 ++++++++++++++++++
 drivers/staging/media/imx/imx-media-dev.c     |  89 ++++-----------
 .../staging/media/imx/imx-media-internal-sd.c |   3 +
 drivers/staging/media/imx/imx-media-of.c      |   6 +-
 drivers/staging/media/imx/imx-media.h         |  18 ++++
 6 files changed, 150 insertions(+), 69 deletions(-)
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
index 000000000000..7e9613ca5b5f
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-dev-common.c
@@ -0,0 +1,102 @@
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
+struct imx_media_dev *imx_media_dev_init(struct device *dev, bool ipu_present)
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
+	imxmd->ipu_present = ipu_present;
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
+	if (imxmd->notifier.num_subdevs == 0) {
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
+
+void imx_media_dev_cleanup(struct imx_media_dev *imxmd)
+{
+	v4l2_device_unregister(&imxmd->v4l2_dev);
+	media_device_cleanup(&imxmd->md);
+}
+EXPORT_SYMBOL_GPL(imx_media_dev_cleanup);
+
+void imx_media_dev_notifier_unregister(struct imx_media_dev *imxmd)
+{
+	v4l2_async_notifier_cleanup(&imxmd->notifier);
+}
+EXPORT_SYMBOL_GPL(imx_media_dev_notifier_unregister);
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 7e7bd1c6c81b..6160070b72fb 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -87,6 +87,9 @@ static int imx_media_get_ipu(struct imx_media_dev *imxmd,
 	struct ipu_soc *ipu;
 	int ipu_id;
 
+	if (!imxmd->ipu_present)
+		return 0;
+
 	ipu = dev_get_drvdata(csi_sd->dev->parent);
 	if (!ipu) {
 		v4l2_err(&imxmd->v4l2_dev,
@@ -107,9 +110,9 @@ static int imx_media_get_ipu(struct imx_media_dev *imxmd,
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
@@ -293,7 +296,7 @@ static int imx_media_create_pad_vdev_lists(struct imx_media_dev *imxmd)
 }
 
 /* async subdev complete notifier */
-static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
+int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
 {
 	struct imx_media_dev *imxmd = notifier2dev(notifier);
 	int ret;
@@ -317,11 +320,6 @@ static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
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
@@ -365,8 +363,8 @@ static int imx_media_inherit_controls(struct imx_media_dev *imxmd,
 	return ret;
 }
 
-static int imx_media_link_notify(struct media_link *link, u32 flags,
-				 unsigned int notification)
+int imx_media_link_notify(struct media_link *link, u32 flags,
+			  unsigned int notification)
 {
 	struct media_entity *source = link->source->entity;
 	struct imx_media_pad_vdev *pad_vdev;
@@ -429,10 +427,6 @@ static int imx_media_link_notify(struct media_link *link, u32 flags,
 	return ret;
 }
 
-static const struct media_device_ops imx_media_md_ops = {
-	.link_notify = imx_media_link_notify,
-};
-
 static int imx_media_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -440,74 +434,36 @@ static int imx_media_probe(struct platform_device *pdev)
 	struct imx_media_dev *imxmd;
 	int ret;
 
-	imxmd = devm_kzalloc(dev, sizeof(*imxmd), GFP_KERNEL);
-	if (!imxmd)
-		return -ENOMEM;
-
-	dev_set_drvdata(dev, imxmd);
-
-	strlcpy(imxmd->md.model, "imx-media", sizeof(imxmd->md.model));
-	imxmd->md.ops = &imx_media_md_ops;
-	imxmd->md.dev = dev;
-
-	mutex_init(&imxmd->mutex);
-
-	imxmd->v4l2_dev.mdev = &imxmd->md;
-	strlcpy(imxmd->v4l2_dev.name, "imx-media",
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
+	imxmd = imx_media_dev_init(dev, true);
+	if (IS_ERR(imxmd))
+		return PTR_ERR(imxmd);
 
 	ret = imx_media_add_of_subdevs(imxmd, node);
 	if (ret) {
 		v4l2_err(&imxmd->v4l2_dev,
 			 "add_of_subdevs failed with %d\n", ret);
-		goto notifier_cleanup;
+		goto dev_cleanup;
 	}
 
 	ret = imx_media_add_internal_subdevs(imxmd);
 	if (ret) {
 		v4l2_err(&imxmd->v4l2_dev,
 			 "add_internal_subdevs failed with %d\n", ret);
-		goto notifier_cleanup;
-	}
-
-	/* no subdevs? just bail */
-	if (imxmd->notifier.num_subdevs == 0) {
-		ret = -ENODEV;
-		goto notifier_cleanup;
+		goto dev_cleanup;
 	}
 
-	/* prepare the async subdev notifier and register it */
-	imxmd->notifier.ops = &imx_media_subdev_ops;
-	ret = v4l2_async_notifier_register(&imxmd->v4l2_dev,
-					   &imxmd->notifier);
-	if (ret) {
-		v4l2_err(&imxmd->v4l2_dev,
-			 "v4l2_async_notifier_register failed with %d\n", ret);
+	ret = imx_media_dev_notifier_register(imxmd);
+	if (ret < 0)
 		goto del_int;
-	}
 
 	return 0;
 
 del_int:
 	imx_media_remove_internal_subdevs(imxmd);
-notifier_cleanup:
-	v4l2_async_notifier_cleanup(&imxmd->notifier);
-	v4l2_device_unregister(&imxmd->v4l2_dev);
-cleanup:
-	media_device_cleanup(&imxmd->md);
+
+dev_cleanup:
+	imx_media_dev_cleanup(imxmd);
+
 	return ret;
 }
 
@@ -520,10 +476,9 @@ static int imx_media_remove(struct platform_device *pdev)
 
 	v4l2_async_notifier_unregister(&imxmd->notifier);
 	imx_media_remove_internal_subdevs(imxmd);
-	v4l2_async_notifier_cleanup(&imxmd->notifier);
-	v4l2_device_unregister(&imxmd->v4l2_dev);
+	imx_media_dev_notifier_unregister(imxmd);
 	media_device_unregister(&imxmd->md);
-	media_device_cleanup(&imxmd->md);
+	imx_media_dev_cleanup(imxmd);
 
 	return 0;
 }
diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
index 0fdc45dbfb76..2bcdc232369a 100644
--- a/drivers/staging/media/imx/imx-media-internal-sd.c
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -238,6 +238,9 @@ int imx_media_create_internal_links(struct imx_media_dev *imxmd,
 	struct media_pad *pad;
 	int i, j, ret;
 
+	if (!imxmd->ipu_present)
+		return 0;
+
 	intsd = find_intsd_by_grp_id(sd->grp_id);
 	if (!intsd)
 		return -ENODEV;
diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index 1c9175433ba6..a0020cc7b3f3 100644
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
index 44532cd5b812..6fb0f9f68169 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -147,6 +147,9 @@ struct imx_media_dev {
 
 	/* for async subdev registration */
 	struct v4l2_async_notifier notifier;
+
+	/* indicator to if the system has IPU */
+	bool ipu_present;
 };
 
 enum codespace_sel {
@@ -224,6 +227,19 @@ int imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 			       struct fwnode_handle *fwnode,
 			       struct platform_device *pdev);
 
+int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
+			   struct v4l2_subdev *sd,
+			   struct v4l2_async_subdev *asd);
+int imx_media_link_notify(struct media_link *link, u32 flags,
+			  unsigned int notification);
+int imx_media_probe_complete(struct v4l2_async_notifier *notifier);
+
+struct imx_media_dev *imx_media_dev_init(struct device *dev, bool ipu_present);
+int imx_media_dev_notifier_register(struct imx_media_dev *imxmd);
+
+void imx_media_dev_cleanup(struct imx_media_dev *imxmd);
+void imx_media_dev_notifier_unregister(struct imx_media_dev *imxmd);
+
 /* imx-media-fim.c */
 struct imx_media_fim;
 void imx_media_fim_eof_monitor(struct imx_media_fim *fim, ktime_t timestamp);
@@ -247,6 +263,8 @@ int imx_media_create_of_links(struct imx_media_dev *imxmd,
 			      struct v4l2_subdev *sd);
 int imx_media_create_csi_of_links(struct imx_media_dev *imxmd,
 				  struct v4l2_subdev *csi);
+int imx_media_of_add_csi(struct imx_media_dev *imxmd,
+			 struct device_node *csi_np);
 
 /* imx-media-capture.c */
 struct imx_media_video_dev *
-- 
2.17.0
