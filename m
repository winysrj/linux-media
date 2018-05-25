Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:41316 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030721AbeEYXxq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 19:53:46 -0400
Received: by mail-pl0-f68.google.com with SMTP id az12-v6so3974282plb.8
        for <linux-media@vger.kernel.org>; Fri, 25 May 2018 16:53:46 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 1/6] media: imx-csi: Fix interlaced bt.656
Date: Fri, 25 May 2018 16:53:31 -0700
Message-Id: <1527292416-26187-2-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
References: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The output pad's field type was being passed to ipu_csi_init_interface(),
in order to deal with field type 'alternate' at the sink pad, which
must be translated to either 'seq-tb' or 'seq-bt' to be understood by
ipu_csi_init_interface(). Doing so breaks the CSI interface setup if
the output pad field type is set to 'none' and the input bus type is
BT.656.

So remove that code and pass unmodified sink pad field type to
ipu_csi_init_interface(). The latter function will have to explicity
deal with field type 'alternate' when setting up the CSI interface
for BT.656 busses.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 95d7805..9bc555c 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -629,12 +629,10 @@ static void csi_idmac_stop(struct csi_priv *priv)
 /* Update the CSI whole sensor and active windows */
 static int csi_setup(struct csi_priv *priv)
 {
-	struct v4l2_mbus_framefmt *infmt, *outfmt;
+	struct v4l2_mbus_framefmt *infmt;
 	struct v4l2_mbus_config mbus_cfg;
-	struct v4l2_mbus_framefmt if_fmt;
 
 	infmt = &priv->format_mbus[CSI_SINK_PAD];
-	outfmt = &priv->format_mbus[priv->active_output_pad];
 
 	/* compose mbus_config from the upstream endpoint */
 	mbus_cfg.type = priv->upstream_ep.bus_type;
@@ -642,20 +640,13 @@ static int csi_setup(struct csi_priv *priv)
 		priv->upstream_ep.bus.mipi_csi2.flags :
 		priv->upstream_ep.bus.parallel.flags;
 
-	/*
-	 * we need to pass input frame to CSI interface, but
-	 * with translated field type from output format
-	 */
-	if_fmt = *infmt;
-	if_fmt.field = outfmt->field;
-
 	ipu_csi_set_window(priv->csi, &priv->crop);
 
 	ipu_csi_set_downsize(priv->csi,
 			     priv->crop.width == 2 * priv->compose.width,
 			     priv->crop.height == 2 * priv->compose.height);
 
-	ipu_csi_init_interface(priv->csi, &mbus_cfg, &if_fmt);
+	ipu_csi_init_interface(priv->csi, &mbus_cfg, infmt);
 
 	ipu_csi_set_dest(priv->csi, priv->dest);
 
-- 
2.7.4
