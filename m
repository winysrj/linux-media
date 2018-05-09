Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:42941 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965887AbeEIWr1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 18:47:27 -0400
Received: by mail-pl0-f65.google.com with SMTP id u6-v6so93473pls.9
        for <linux-media@vger.kernel.org>; Wed, 09 May 2018 15:47:27 -0700 (PDT)
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
Subject: [PATCH v4 08/14] media: imx: csi: Register a subdev notifier
Date: Wed,  9 May 2018 15:46:57 -0700
Message-Id: <1525906023-827-9-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1525906023-827-1-git-send-email-steve_longerbeam@mentor.com>
References: <1525906023-827-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse neighbor remote devices on the CSI port, and add them to a subdev
notifier, by calling v4l2_async_notifier_parse_fwnode_endpoints_by_port()
using the CSI's port id. And register the subdev notifier for the CSI.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes since v3:
- v4l2_async_register_fwnode_subdev() no longer supports parsing
  port sub-devices, so call
  v4l2_async_notifier_parse_fwnode_endpoints_by_port() directly.
---
 drivers/staging/media/imx/imx-media-csi.c | 55 ++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 16cab40..190f0b4 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1737,6 +1737,59 @@ static const struct v4l2_subdev_internal_ops csi_internal_ops = {
 	.unregistered = csi_unregistered,
 };
 
+static int imx_csi_parse_endpoint(struct device *dev,
+				  struct v4l2_fwnode_endpoint *vep,
+				  struct v4l2_async_subdev *asd)
+{
+	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -EINVAL;
+}
+
+static int imx_csi_async_register(struct csi_priv *priv)
+{
+	struct v4l2_async_notifier *notifier;
+	struct fwnode_handle *fwnode;
+	unsigned int port;
+	int ret;
+
+	notifier = kzalloc(sizeof(*notifier), GFP_KERNEL);
+	if (!notifier)
+		return -ENOMEM;
+
+	fwnode = dev_fwnode(priv->dev);
+
+	/* get this CSI's port id */
+	ret = fwnode_property_read_u32(fwnode, "reg", &port);
+	if (ret < 0)
+		goto out_free;
+
+	ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
+		priv->dev->parent, notifier, sizeof(struct v4l2_async_subdev),
+		port, imx_csi_parse_endpoint);
+	if (ret < 0)
+		goto out_cleanup;
+
+	ret = v4l2_async_subdev_notifier_register(&priv->sd, notifier);
+	if (ret < 0)
+		goto out_cleanup;
+
+	ret = v4l2_async_register_subdev(&priv->sd);
+	if (ret < 0)
+		goto out_unregister;
+
+	priv->sd.subdev_notifier = notifier;
+
+	return 0;
+
+out_unregister:
+	v4l2_async_notifier_unregister(notifier);
+out_cleanup:
+	v4l2_async_notifier_cleanup(notifier);
+out_free:
+	kfree(notifier);
+
+	return ret;
+}
+
 static int imx_csi_probe(struct platform_device *pdev)
 {
 	struct ipu_client_platformdata *pdata;
@@ -1806,7 +1859,7 @@ static int imx_csi_probe(struct platform_device *pdev)
 			goto free;
 	}
 
-	ret = v4l2_async_register_subdev(&priv->sd);
+	ret = imx_csi_async_register(priv);
 	if (ret)
 		goto free;
 
-- 
2.7.4
