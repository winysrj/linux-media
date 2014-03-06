Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:35578 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaCFQCL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Mar 2014 11:02:11 -0500
From: Denis Carikli <denis@eukrea.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Denis Carikli <denis@eukrea.com>
Subject: [PATCH v9][ 2/8] staging: imx-drm: Add RGB666 support for parallel display.
Date: Thu,  6 Mar 2014 17:01:41 +0100
Message-Id: <1394121702-13257-2-git-send-email-denis@eukrea.com>
In-Reply-To: <1394121702-13257-1-git-send-email-denis@eukrea.com>
References: <1394121702-13257-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Denis Carikli <denis@eukrea.com>
---
ChangeLog v8->v9:
- Removed the Cc. They are now set in git-send-email directly.
- Rebased.

ChangeLog v7->v8:
- Shrinked even more the Cc list.

ChangeLog v6->v7:
- Shrinked even more the Cc list.

ChangeLog v5->v6:
- Remove people not concerned by this patch from the Cc list.

ChangeLog v3->v5:
- Use the correct RGB order.

ChangeLog v2->v3:
- Added some interested people in the Cc list.
- Removed the commit message long desciption that was just a copy of the short
  description.
- Rebased the patch.
- Fixed a copy-paste error in the ipu_dc_map_clear parameter.
---
 .../bindings/staging/imx-drm/fsl-imx-drm.txt       |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c            |    9 +++++++++
 drivers/staging/imx-drm/parallel-display.c         |    2 ++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt b/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
index b876d49..2d24425 100644
--- a/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
+++ b/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
@@ -29,7 +29,7 @@ Required properties:
 - crtc: the crtc this display is connected to, see below
 Optional properties:
 - interface_pix_fmt: How this display is connected to the
-  crtc. Currently supported types: "rgb24", "rgb565", "bgr666"
+  crtc. Currently supported types: "rgb24", "rgb565", "bgr666", "rgb666"
 - edid: verbatim EDID data block describing attached display.
 - ddc: phandle describing the i2c bus handling the display data
   channel
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
index d5de8bb..6f9abe8 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
@@ -92,6 +92,7 @@ enum ipu_dc_map {
 	IPU_DC_MAP_GBR24, /* TVEv2 */
 	IPU_DC_MAP_BGR666,
 	IPU_DC_MAP_BGR24,
+	IPU_DC_MAP_RGB666,
 };
 
 struct ipu_dc {
@@ -155,6 +156,8 @@ static int ipu_pixfmt_to_map(u32 fmt)
 		return IPU_DC_MAP_BGR666;
 	case V4L2_PIX_FMT_BGR24:
 		return IPU_DC_MAP_BGR24;
+	case V4L2_PIX_FMT_RGB666:
+		return IPU_DC_MAP_RGB666;
 	default:
 		return -EINVAL;
 	}
@@ -404,6 +407,12 @@ int ipu_dc_init(struct ipu_soc *ipu, struct device *dev,
 	ipu_dc_map_config(priv, IPU_DC_MAP_BGR24, 1, 15, 0xff); /* green */
 	ipu_dc_map_config(priv, IPU_DC_MAP_BGR24, 0, 23, 0xff); /* blue */
 
+	/* rgb666 */
+	ipu_dc_map_clear(priv, IPU_DC_MAP_RGB666);
+	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 0, 5, 0xfc); /* blue */
+	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 1, 11, 0xfc); /* green */
+	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 2, 17, 0xfc); /* red */
+
 	return 0;
 }
 
diff --git a/drivers/staging/imx-drm/parallel-display.c b/drivers/staging/imx-drm/parallel-display.c
index c60b6c6..01b7ce5 100644
--- a/drivers/staging/imx-drm/parallel-display.c
+++ b/drivers/staging/imx-drm/parallel-display.c
@@ -219,6 +219,8 @@ static int imx_pd_bind(struct device *dev, struct device *master, void *data)
 			imxpd->interface_pix_fmt = V4L2_PIX_FMT_RGB565;
 		else if (!strcmp(fmt, "bgr666"))
 			imxpd->interface_pix_fmt = V4L2_PIX_FMT_BGR666;
+		else if (!strcmp(fmt, "rgb666"))
+			imxpd->interface_pix_fmt = V4L2_PIX_FMT_RGB666;
 	}
 
 	panel_node = of_parse_phandle(np, "fsl,panel", 0);
-- 
1.7.9.5

