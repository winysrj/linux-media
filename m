Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:58517 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729126AbeHNAQl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 20:16:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Peter Seiderer <ps.report@gmx.net>,
        Jan Luebbe <jlu@pengutronix.de>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: imx: work around false-positive warning, again
Date: Mon, 13 Aug 2018 23:32:17 +0200
Message-Id: <20180813213228.2834099-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A warning that I thought to be solved by a previous patch of mine
has resurfaced with gcc-8:

media/imx/imx-media-csi.c: In function 'csi_link_validate':
media/imx/imx-media-csi.c:1025:20: error: 'upstream_ep' may be used uninitialized in this function [-Werror=maybe-uninitialized]
media/imx/imx-media-csi.c:1026:24: error: 'upstream_ep.bus_type' may be used uninitialized in this function [-Werror=maybe-uninitialized]
media/imx/imx-media-csi.c:127:19: error: 'upstream_ep.bus.parallel.bus_width' may be used uninitialized in this function [-Werror=maybe-uninitialized]
media/imx/imx-media-csi.c: In function 'csi_enum_mbus_code':
media/imx/imx-media-csi.c:132:9: error: '*((void *)&upstream_ep+12)' may be used uninitialized in this function [-Werror=maybe-uninitialized]
media/imx/imx-media-csi.c:132:48: error: 'upstream_ep.bus.parallel.bus_width' may be used uninitialized in this function [-Werror=maybe-uninitialized]

I spent some more time digging in this time, and think I have a better
fix, bailing out of the function that either initializes or errors
out here, which simplifies the code enough for gcc to figure out
what is going on. The earlier partial workaround can be removed now,
as the new workaround is better.

Fixes: 890f27693f2a ("media: imx: work around false-positive warning")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/imx/imx-media-csi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index cd2c291e1e94..4acdd7ae612b 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -165,6 +165,9 @@ static int csi_get_upstream_endpoint(struct csi_priv *priv,
 	struct v4l2_subdev *sd;
 	struct media_pad *pad;
 
+	if (!IS_ENABLED(CONFIG_OF))
+		return -ENXIO;
+
 	if (!priv->src_sd)
 		return -EPIPE;
 
@@ -1050,7 +1053,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_format *sink_fmt)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
-	struct v4l2_fwnode_endpoint upstream_ep = {};
+	struct v4l2_fwnode_endpoint upstream_ep;
 	bool is_csi2;
 	int ret;
 
-- 
2.18.0
