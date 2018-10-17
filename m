Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35977 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbeJQHxg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 03:53:36 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 05/12] media: imx-csi: Input connections to CSI should be optional
Date: Tue, 16 Oct 2018 17:00:20 -0700
Message-Id: <20181017000027.23696-6-slongerbeam@gmail.com>
In-Reply-To: <20181017000027.23696-1-slongerbeam@gmail.com>
References: <20181017000027.23696-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some imx platforms do not have fwnode connections to all CSI input
ports, and should not be treated as an error. This includes the
imx6q SabreAuto, which has no connections to ipu1_csi1 and ipu2_csi0.
Return -ENOTCONN in imx_csi_parse_endpoint() so that v4l2-fwnode
endpoint parsing will not treat an unconnected endpoint as an error.

Fixes: c893500a16baf ("media: imx: csi: Register a subdev notifier")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 176978c7dfe7..8f52428d2c75 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1813,7 +1813,7 @@ static int imx_csi_parse_endpoint(struct device *dev,
 				  struct v4l2_fwnode_endpoint *vep,
 				  struct v4l2_async_subdev *asd)
 {
-	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -EINVAL;
+	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -ENOTCONN;
 }
 
 static int imx_csi_async_register(struct csi_priv *priv)
-- 
2.17.1
