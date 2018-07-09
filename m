Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:46696 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933437AbeGIWj7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 18:39:59 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 12/17] media: staging/imx: Rename root notifier
Date: Mon,  9 Jul 2018 15:39:12 -0700
Message-Id: <1531175957-1973-13-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
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
index ae87c81..982e455 100644
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
index 57bd094..227b79c 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -150,7 +150,7 @@ struct imx_media_dev {
 
 	/* for async subdev registration */
 	struct list_head asd_list;
-	struct v4l2_async_notifier subdev_notifier;
+	struct v4l2_async_notifier notifier;
 };
 
 enum codespace_sel {
-- 
2.7.4
