Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:40168 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932071AbeCJT7P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Mar 2018 14:59:15 -0500
Received: by mail-pl0-f66.google.com with SMTP id x3-v6so585040plo.7
        for <linux-media@vger.kernel.org>; Sat, 10 Mar 2018 11:59:15 -0800 (PST)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 11/13] media: staging/imx: Rename root notifier
Date: Sat, 10 Mar 2018 11:58:40 -0800
Message-Id: <1520711922-17338-12-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1520711922-17338-1-git-send-email-steve_longerbeam@mentor.com>
References: <1520711922-17338-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename the imx-media root async notifier from "subdev_notifier" to
simply "notifier", so as not to confuse it with true subdev notifiers.
No functional changes.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-dev.c | 14 +++++++-------
 drivers/staging/media/imx/imx-media.h     |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 4d00ed3..dd4702a 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -29,7 +29,7 @@
 
 static inline struct imx_media_dev *notifier2dev(struct v4l2_async_notifier *n)
 {
-	return container_of(n, struct imx_media_dev, subdev_notifier);
+	return container_of(n, struct imx_media_dev, notifier);
 }
 
 /*
@@ -113,7 +113,7 @@ int imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 
 	list_add_tail(&imxasd->list, &imxmd->asd_list);
 
-	imxmd->subdev_notifier.num_subdevs++;
+	imxmd->notifier.num_subdevs++;
 
 	dev_dbg(imxmd->md.dev, "%s: added %s, match type %s\n",
 		__func__, np ? np->name : devname, np ? "FWNODE" : "DEVNAME");
@@ -532,7 +532,7 @@ static int imx_media_probe(struct platform_device *pdev)
 		goto unreg_dev;
 	}
 
-	num_subdevs = imxmd->subdev_notifier.num_subdevs;
+	num_subdevs = imxmd->notifier.num_subdevs;
 
 	/* no subdevs? just bail */
 	if (num_subdevs == 0) {
@@ -552,10 +552,10 @@ static int imx_media_probe(struct platform_device *pdev)
 		subdevs[i++] = &imxasd->asd;
 
 	/* prepare the async subdev notifier and register it */
-	imxmd->subdev_notifier.subdevs = subdevs;
-	imxmd->subdev_notifier.ops = &imx_media_subdev_ops;
+	imxmd->notifier.subdevs = subdevs;
+	imxmd->notifier.ops = &imx_media_subdev_ops;
 	ret = v4l2_async_notifier_register(&imxmd->v4l2_dev,
-					   &imxmd->subdev_notifier);
+					   &imxmd->notifier);
 	if (ret) {
 		v4l2_err(&imxmd->v4l2_dev,
 			 "v4l2_async_notifier_register failed with %d\n", ret);
@@ -580,7 +580,7 @@ static int imx_media_remove(struct platform_device *pdev)
 
 	v4l2_info(&imxmd->v4l2_dev, "Removing imx-media\n");
 
-	v4l2_async_notifier_unregister(&imxmd->subdev_notifier);
+	v4l2_async_notifier_unregister(&imxmd->notifier);
 	imx_media_remove_internal_subdevs(imxmd);
 	v4l2_device_unregister(&imxmd->v4l2_dev);
 	media_device_unregister(&imxmd->md);
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index e945e0e..7edb18a 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -148,7 +148,7 @@ struct imx_media_dev {
 
 	/* for async subdev registration */
 	struct list_head asd_list;
-	struct v4l2_async_notifier subdev_notifier;
+	struct v4l2_async_notifier notifier;
 };
 
 enum codespace_sel {
-- 
2.7.4
