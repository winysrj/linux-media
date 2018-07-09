Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:46689 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933410AbeGIWjx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 18:39:53 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 08/17] media: imx: csi: Register a subdev notifier
Date: Mon,  9 Jul 2018 15:39:08 -0700
Message-Id: <1531175957-1973-9-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse neighbor remote devices on the CSI port, and add them to a subdev
notifier, by calling v4l2_async_notifier_parse_fwnode_endpoints_by_port()
using the CSI's port id. And register the subdev notifier for the CSI.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes since v5:
- add call to v4l2_async_notifier_init().
Changes since v4:
- none
Changes since v3:
- v4l2_async_register_fwnode_subdev() no longer supports parsing
  port sub-devices, so call
  v4l2_async_notifier_parse_fwnode_endpoints_by_port() directly.
---
 drivers/staging/media/imx/imx-media-csi.c | 57 ++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 4647206..19ef377 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1780,6 +1780,61 @@ static const struct v4l2_subdev_internal_ops csi_internal_ops = {
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
+	v4l2_async_notifier_init(notifier);
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
@@ -1849,7 +1904,7 @@ static int imx_csi_probe(struct platform_device *pdev)
 			goto free;
 	}
 
-	ret = v4l2_async_register_subdev(&priv->sd);
+	ret = imx_csi_async_register(priv);
 	if (ret)
 		goto free;
 
-- 
2.7.4
