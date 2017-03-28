Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36412 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753706AbdC1An1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 20:43:27 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v6 27/39] media: imx: csi: add support for bayer formats
Date: Mon, 27 Mar 2017 17:40:44 -0700
Message-Id: <1490661656-10318-28-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Russell King <rmk+kernel@armlinux.org.uk>

Bayer formats must be treated as generic data and passthrough mode must
be used.  Add the correct setup for these formats.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

- added check to csi_link_validate() to verify that destination is
  IDMAC output pad when passthrough conditions exist: bayer formats
  and 16-bit parallel buses.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 75 +++++++++++++++++++++++--------
 1 file changed, 57 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 9e2a73c..37c68d8 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -285,10 +285,11 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	struct imx_media_video_dev *vdev = priv->vdev;
 	struct v4l2_of_endpoint *sensor_ep;
 	struct v4l2_mbus_framefmt *infmt;
-	unsigned int burst_size;
 	struct ipu_image image;
+	u32 passthrough_bits;
 	dma_addr_t phys[2];
 	bool passthrough;
+	u32 burst_size;
 	int ret;
 
 	infmt = &priv->format_mbus[CSI_SINK_PAD];
@@ -306,24 +307,52 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	image.phys0 = phys[0];
 	image.phys1 = phys[1];
 
-	ret = ipu_cpmem_set_image(priv->idmac_ch, &image);
-	if (ret)
-		goto unsetup_vb2;
-
-	burst_size = (image.pix.width & 0xf) ? 8 : 16;
-
-	ipu_cpmem_set_burstsize(priv->idmac_ch, burst_size);
-
 	/*
-	 * If the sensor uses 16-bit parallel CSI bus, we must handle
-	 * the data internally in the IPU as 16-bit generic, aka
-	 * passthrough mode.
+	 * Check for conditions that require the IPU to handle the
+	 * data internally as generic data, aka passthrough mode:
+	 * - raw bayer formats
+	 * - the sensor bus is 16-bit parallel
 	 */
-	passthrough = (sensor_ep->bus_type != V4L2_MBUS_CSI2 &&
-		       sensor_ep->bus.parallel.bus_width >= 16);
+	switch (image.pix.pixelformat) {
+	case V4L2_PIX_FMT_SBGGR8:
+	case V4L2_PIX_FMT_SGBRG8:
+	case V4L2_PIX_FMT_SGRBG8:
+	case V4L2_PIX_FMT_SRGGB8:
+		burst_size = 8;
+		passthrough = true;
+		passthrough_bits = 8;
+		break;
+	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16:
+		burst_size = 4;
+		passthrough = true;
+		passthrough_bits = 16;
+		break;
+	default:
+		burst_size = (image.pix.width & 0xf) ? 8 : 16;
+		passthrough = (sensor_ep->bus_type != V4L2_MBUS_CSI2 &&
+			       sensor_ep->bus.parallel.bus_width >= 16);
+		passthrough_bits = 16;
+		break;
+	}
 
-	if (passthrough)
-		ipu_cpmem_set_format_passthrough(priv->idmac_ch, 16);
+	if (passthrough) {
+		ipu_cpmem_set_resolution(priv->idmac_ch, image.rect.width,
+					 image.rect.height);
+		ipu_cpmem_set_stride(priv->idmac_ch, image.pix.bytesperline);
+		ipu_cpmem_set_buffer(priv->idmac_ch, 0, image.phys0);
+		ipu_cpmem_set_buffer(priv->idmac_ch, 1, image.phys1);
+		ipu_cpmem_set_format_passthrough(priv->idmac_ch,
+						 passthrough_bits);
+	} else {
+		ret = ipu_cpmem_set_image(priv->idmac_ch, &image);
+		if (ret)
+			goto unsetup_vb2;
+	}
+
+	ipu_cpmem_set_burstsize(priv->idmac_ch, burst_size);
 
 	/*
 	 * Set the channel for the direct CSI-->memory via SMFC
@@ -737,6 +766,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_format *sink_fmt)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	const struct imx_media_pixfmt *incc;
 	struct v4l2_of_endpoint *sensor_ep;
 	struct imx_media_subdev *sensor;
 	bool is_csi2;
@@ -757,8 +787,17 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 
 	priv->sensor = sensor;
 	sensor_ep = &priv->sensor->sensor_ep;
-
 	is_csi2 = (sensor_ep->bus_type == V4L2_MBUS_CSI2);
+	incc = priv->cc[CSI_SINK_PAD];
+
+	if (priv->dest != IPU_CSI_DEST_IDMAC &&
+	    (incc->bayer || (!is_csi2 &&
+			     sensor_ep->bus.parallel.bus_width >= 16))) {
+		v4l2_err(&priv->sd,
+			 "bayer/16-bit parallel buses must go to IDMAC pad\n");
+		ret = -EINVAL;
+		goto out;
+	}
 
 	if (is_csi2) {
 		int vc_num = 0;
@@ -783,7 +822,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 
 	/* select either parallel or MIPI-CSI2 as input to CSI */
 	ipu_set_csi_src_mux(priv->ipu, priv->csi_id, is_csi2);
-
+out:
 	mutex_unlock(&priv->lock);
 	return ret;
 }
-- 
2.7.4
