Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51973 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbeHJQvm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 12:51:42 -0400
Received: by mail-wm0-f68.google.com with SMTP id y2-v6so2108004wma.1
        for <linux-media@vger.kernel.org>; Fri, 10 Aug 2018 07:21:33 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v7 01/12] media: staging/imx: refactor imx media device probe
Date: Fri, 10 Aug 2018 15:20:34 +0100
Message-Id: <20180810142045.27657-2-rui.silva@linaro.org>
In-Reply-To: <20180810142045.27657-1-rui.silva@linaro.org>
References: <20180810142045.27657-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refactor and move media device initialization code to a new common module, so it
can be used by other devices, this will allow for example a near to introduce
imx7 CSI driver, to use this media device.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/Makefile        |  1 +
 drivers/staging/media/imx/imx-media-dev.c | 88 ++++++-----------------
 drivers/staging/media/imx/imx-media-of.c  |  6 +-
 drivers/staging/media/imx/imx-media.h     | 15 ++++
 4 files changed, 40 insertions(+), 70 deletions(-)

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
 
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 659420ec4b2e..b06c300d12e0 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -107,9 +107,9 @@ static int imx_media_get_ipu(struct imx_media_dev *imxmd,
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
@@ -293,7 +293,7 @@ static int imx_media_create_pad_vdev_lists(struct imx_media_dev *imxmd)
 }
 
 /* async subdev complete notifier */
-static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
+int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
 {
 	struct imx_media_dev *imxmd = notifier2dev(notifier);
 	int ret;
@@ -317,11 +317,6 @@ static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
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
@@ -365,8 +360,8 @@ static int imx_media_inherit_controls(struct imx_media_dev *imxmd,
 	return ret;
 }
 
-static int imx_media_link_notify(struct media_link *link, u32 flags,
-				 unsigned int notification)
+int imx_media_link_notify(struct media_link *link, u32 flags,
+			  unsigned int notification)
 {
 	struct media_entity *source = link->source->entity;
 	struct imx_media_pad_vdev *pad_vdev;
@@ -429,10 +424,6 @@ static int imx_media_link_notify(struct media_link *link, u32 flags,
 	return ret;
 }
 
-static const struct media_device_ops imx_media_md_ops = {
-	.link_notify = imx_media_link_notify,
-};
-
 static int imx_media_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -440,76 +431,38 @@ static int imx_media_probe(struct platform_device *pdev)
 	struct imx_media_dev *imxmd;
 	int ret;
 
-	imxmd = devm_kzalloc(dev, sizeof(*imxmd), GFP_KERNEL);
-	if (!imxmd)
-		return -ENOMEM;
-
-	dev_set_drvdata(dev, imxmd);
 
-	strlcpy(imxmd->md.model, "imx-media", sizeof(imxmd->md.model));
-	imxmd->md.ops = &imx_media_md_ops;
-	imxmd->md.dev = dev;
 
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
-	if (list_empty(&imxmd->notifier.asd_list)) {
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
-		goto del_int;
-	}
+	ret = imx_media_dev_notifier_register(imxmd);
+	if (ret < 0)
+ 		goto del_int;
 
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
 
@@ -522,10 +475,9 @@ static int imx_media_remove(struct platform_device *pdev)
 
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
index bc7feb81937c..b7f11c36461b 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -226,6 +226,19 @@ int imx_media_add_async_subdev(struct imx_media_dev *imxmd,
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
+void imx_media_dev_cleanup(struct imx_media_dev *imxmd);
+void imx_media_dev_notifier_unregister(struct imx_media_dev *imxmd);
+
 /* imx-media-fim.c */
 struct imx_media_fim;
 void imx_media_fim_eof_monitor(struct imx_media_fim *fim, ktime_t timestamp);
@@ -249,6 +262,8 @@ int imx_media_create_of_links(struct imx_media_dev *imxmd,
 			      struct v4l2_subdev *sd);
 int imx_media_create_csi_of_links(struct imx_media_dev *imxmd,
 				  struct v4l2_subdev *csi);
+int imx_media_of_add_csi(struct imx_media_dev *imxmd,
+			 struct device_node *csi_np);
 
 /* imx-media-capture.c */
 struct imx_media_video_dev *
-- 
2.18.0
