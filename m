Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:42758 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbeCUAiY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 20:38:24 -0400
Received: by mail-pg0-f67.google.com with SMTP id f10so1156042pgs.9
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2018 17:38:23 -0700 (PDT)
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
Subject: [PATCH v3 07/13] media: imx: csi: Register a subdev notifier
Date: Tue, 20 Mar 2018 17:37:23 -0700
Message-Id: <1521592649-7264-8-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1521592649-7264-1-git-send-email-steve_longerbeam@mentor.com>
References: <1521592649-7264-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse neighbor remote devices on the CSI port, add them to a subdev
notifier, and register the subdev notifier for the CSI, by calling
v4l2_async_register_fwnode_subdev().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 5a195f8..87cf277 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1736,6 +1736,13 @@ static const struct v4l2_subdev_internal_ops csi_internal_ops = {
 	.unregistered = csi_unregistered,
 };
 
+static int imx_csi_parse_endpoint(struct device *dev,
+				  struct v4l2_fwnode_endpoint *vep,
+				  struct v4l2_async_subdev *asd)
+{
+	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -EINVAL;
+}
+
 static int imx_csi_probe(struct platform_device *pdev)
 {
 	struct ipu_client_platformdata *pdata;
@@ -1802,7 +1809,9 @@ static int imx_csi_probe(struct platform_device *pdev)
 		goto free;
 	}
 
-	ret = v4l2_async_register_subdev(&priv->sd);
+	ret = v4l2_async_register_fwnode_subdev(
+		&priv->sd, sizeof(struct v4l2_async_subdev),
+		NULL, 0, imx_csi_parse_endpoint);
 	if (ret)
 		goto free;
 
-- 
2.7.4
