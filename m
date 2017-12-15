Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:44416 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754618AbdLOBFj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 20:05:39 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 5/9] media: staging/imx: pass fwnode handle to find/add async subdev
Date: Thu, 14 Dec 2017 17:04:43 -0800
Message-Id: <1513299887-16804-6-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1513299887-16804-1-git-send-email-steve_longerbeam@mentor.com>
References: <1513299887-16804-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pass the subdev's fwnode_handle to imx_media_find_async_subdev() and
imx_media_add_async_subdev(), instead of a device_node.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-dev.c | 20 ++++++++++----------
 drivers/staging/media/imx/imx-media-of.c  |  7 +++----
 drivers/staging/media/imx/imx-media.h     |  4 ++--
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index ab0617d6..0369c35 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -33,15 +33,14 @@ static inline struct imx_media_dev *notifier2dev(struct v4l2_async_notifier *n)
 }
 
 /*
- * Find a subdev by device node or device name. This is called during
+ * Find a subdev by fwnode or device name. This is called during
  * driver load to form the async subdev list and bind them.
  */
 struct imx_media_subdev *
 imx_media_find_async_subdev(struct imx_media_dev *imxmd,
-			    struct device_node *np,
+			    struct fwnode_handle *fwnode,
 			    const char *devname)
 {
-	struct fwnode_handle *fwnode = np ? of_fwnode_handle(np) : NULL;
 	struct imx_media_subdev *imxsd;
 	int i;
 
@@ -67,7 +66,7 @@ imx_media_find_async_subdev(struct imx_media_dev *imxmd,
 
 
 /*
- * Adds a subdev to the async subdev list. If np is non-NULL, adds
+ * Adds a subdev to the async subdev list. If fwnode is non-NULL, adds
  * the async as a V4L2_ASYNC_MATCH_FWNODE match type, otherwise as
  * a V4L2_ASYNC_MATCH_DEVNAME match type using the dev_name of the
  * given platform_device. This is called during driver load when
@@ -75,9 +74,10 @@ imx_media_find_async_subdev(struct imx_media_dev *imxmd,
  */
 struct imx_media_subdev *
 imx_media_add_async_subdev(struct imx_media_dev *imxmd,
-			   struct device_node *np,
+			   struct fwnode_handle *fwnode,
 			   struct platform_device *pdev)
 {
+	struct device_node *np = to_of_node(fwnode);
 	struct imx_media_subdev *imxsd;
 	struct v4l2_async_subdev *asd;
 	const char *devname = NULL;
@@ -89,7 +89,7 @@ imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 		devname = dev_name(&pdev->dev);
 
 	/* return -EEXIST if this subdev already added */
-	if (imx_media_find_async_subdev(imxmd, np, devname)) {
+	if (imx_media_find_async_subdev(imxmd, fwnode, devname)) {
 		dev_dbg(imxmd->md.dev, "%s: already added %s\n",
 			__func__, np ? np->name : devname);
 		imxsd = ERR_PTR(-EEXIST);
@@ -107,9 +107,9 @@ imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 	imxsd = &imxmd->subdev[sd_idx];
 
 	asd = &imxsd->asd;
-	if (np) {
+	if (fwnode) {
 		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-		asd->match.fwnode.fwnode = of_fwnode_handle(np);
+		asd->match.fwnode.fwnode = fwnode;
 	} else {
 		asd->match_type = V4L2_ASYNC_MATCH_DEVNAME;
 		asd->match.device_name.name = devname;
@@ -162,13 +162,13 @@ static int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
 				  struct v4l2_async_subdev *asd)
 {
 	struct imx_media_dev *imxmd = notifier2dev(notifier);
-	struct device_node *np = to_of_node(sd->fwnode);
 	struct imx_media_subdev *imxsd;
 	int ret = 0;
 
 	mutex_lock(&imxmd->mutex);
 
-	imxsd = imx_media_find_async_subdev(imxmd, np, dev_name(sd->dev));
+	imxsd = imx_media_find_async_subdev(imxmd, sd->fwnode,
+					    dev_name(sd->dev));
 	if (!imxsd) {
 		ret = -EINVAL;
 		goto out;
diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index a085e52..eb7a7f2 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -87,7 +87,8 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 	}
 
 	/* register this subdev with async notifier */
-	imxsd = imx_media_add_async_subdev(imxmd, sd_np, NULL);
+	imxsd = imx_media_add_async_subdev(imxmd, of_fwnode_handle(sd_np),
+					   NULL);
 	ret = PTR_ERR_OR_ZERO(imxsd);
 	if (ret) {
 		if (ret == -EEXIST) {
@@ -176,9 +177,7 @@ static int create_of_link(struct imx_media_dev *imxmd,
 	if (link->local_port >= sd->entity.num_pads)
 		return -EINVAL;
 
-	remote = imx_media_find_async_subdev(imxmd,
-					     to_of_node(link->remote_node),
-					     NULL);
+	remote = imx_media_find_async_subdev(imxmd, link->remote_node, NULL);
 	if (!remote)
 		return 0;
 
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index c6cea27..32ec8d2 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -189,11 +189,11 @@ int imx_media_ipu_image_to_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
 
 struct imx_media_subdev *
 imx_media_find_async_subdev(struct imx_media_dev *imxmd,
-			    struct device_node *np,
+			    struct fwnode_handle *fwnode,
 			    const char *devname);
 struct imx_media_subdev *
 imx_media_add_async_subdev(struct imx_media_dev *imxmd,
-			   struct device_node *np,
+			   struct fwnode_handle *fwnode,
 			   struct platform_device *pdev);
 
 void imx_media_grp_id_to_sd_name(char *sd_name, int sz,
-- 
2.7.4
