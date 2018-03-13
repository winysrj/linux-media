Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:54783 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbeCMNOe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 09:14:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: imx: work around false-positive warning
Date: Tue, 13 Mar 2018 14:14:09 +0100
Message-Id: <20180313131422.40710-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The IS_ERR()/PTR_ERR() combination confuses gcc to the point that it
cannot prove the upstream_ep variable to be initialized:

drivers/staging/media/imx/imx-media-csi.c: In function 'csi_link_validate':
drivers/staging/media/imx/imx-media-csi.c:1025:20: error: 'upstream_ep' may be used uninitialized in this function [-Werror=maybe-uninitialized]
  priv->upstream_ep = upstream_ep;
  ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
drivers/staging/media/imx/imx-media-csi.c:1026:24: error: 'upstream_ep.bus_type' may be used uninitialized in this function [-Werror=maybe-uninitialized]
  is_csi2 = (upstream_ep.bus_type == V4L2_MBUS_CSI2);
             ~~~~~~~~~~~^~~~~~~~~
drivers/staging/media/imx/imx-media-csi.c:127:19: error: 'upstream_ep.bus.parallel.bus_width' may be used uninitialized in this function [-Werror=maybe-uninitialized]

I could come up with no good way to rewrite this function, as a last
resort, this adds an explicit zero-intialization of the structure.

Fixes: 52e17089d185 ("media: imx: Don't initialize vars that won't be used")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/imx/imx-media-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 5a195f80a24d..887fed0c3ce0 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1004,7 +1004,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_format *sink_fmt)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
-	struct v4l2_fwnode_endpoint upstream_ep;
+	struct v4l2_fwnode_endpoint upstream_ep = {};
 	const struct imx_media_pixfmt *incc;
 	bool is_csi2;
 	int ret;
-- 
2.9.0
