Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:48938 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755615AbcJNRfG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:35:06 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 17/21] [media] imx-ipuv3-csi: support downsizing
Date: Fri, 14 Oct 2016 19:34:37 +0200
Message-Id: <1476466481-24030-18-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the CSI internal horizontal and vertical downsizing.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Rebased onto CSI changes.
---
 drivers/media/platform/imx/imx-ipuv3-csi.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/imx/imx-ipuv3-csi.c b/drivers/media/platform/imx/imx-ipuv3-csi.c
index 7837978..c65f02c 100644
--- a/drivers/media/platform/imx/imx-ipuv3-csi.c
+++ b/drivers/media/platform/imx/imx-ipuv3-csi.c
@@ -175,8 +175,14 @@ static int ipucsi_subdev_set_format(struct v4l2_subdev *sd,
 	} else {
 		struct v4l2_mbus_framefmt *infmt = &ipucsi->format_mbus[0];
 
-		width = infmt->width;
-		height = infmt->height;
+		if (sdformat->format.width < (infmt->width * 3 / 4))
+			width = infmt->width / 2;
+		else
+			width = infmt->width;
+		if (sdformat->format.height < (infmt->height * 3 / 4))
+			height = infmt->height / 2;
+		else
+			height = infmt->height;
 		mbusformat->field = infmt->field;
 		mbusformat->colorspace = infmt->colorspace;
 	}
@@ -237,14 +243,14 @@ static int ipucsi_subdev_s_stream(struct v4l2_subdev *sd, int enable)
 		window.width = fmt[0].width;
 		window.height = fmt[0].height;
 		ipu_csi_set_window(ipucsi->csi, &window);
+		ipu_csi_set_downsize(ipucsi->csi,
+				     fmt[0].width == 2 * fmt[1].width,
+				     fmt[0].height == 2 * fmt[1].height);
 
 		/* Is CSI data source MCT (MIPI)? */
 		mux_mct = (mbus_config.type == V4L2_MBUS_CSI2);
-
 		ipu_set_csi_src_mux(ipucsi->ipu, ipucsi->id, mux_mct);
-		if (mux_mct)
-			ipu_csi_set_mipi_datatype(ipucsi->csi, /*VC*/ 0,
-						  &fmt[0]);
+		ipu_csi_set_mipi_datatype(ipucsi->csi, /*VC*/ 0, &fmt[0]);
 
 		ret = ipu_csi_init_interface(ipucsi->csi, &mbus_config,
 					     &fmt[0]);
-- 
2.9.3

