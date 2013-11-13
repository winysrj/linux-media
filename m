Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:53214 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185Ab3KMJYL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Nov 2013 04:24:11 -0500
From: Denis Carikli <denis@eukrea.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, Denis Carikli <denis@eukrea.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	devicetree@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	driverdev-devel@linuxdriverproject.org,
	David Airlie <airlied@linux.ie>, linux-media@vger.kernel.org,
	=?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [PATCHv4][ 3/7] staging: imx-drm: Add RGB666 support for parallel display.
Date: Wed, 13 Nov 2013 10:23:19 +0100
Message-Id: <1384334603-14208-3-git-send-email-denis@eukrea.com>
In-Reply-To: <1384334603-14208-1-git-send-email-denis@eukrea.com>
References: <1384334603-14208-1-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: devicetree@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: driverdev-devel@linuxdriverproject.org
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Eric Bénard <eric@eukrea.com>
Signed-off-by: Denis Carikli <denis@eukrea.com>
---
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
index d0e3bc3..bcc7680 100644
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
+	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 2, 17, 0xfc); /* red */
+	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 1, 11, 0xfc); /* green */
+	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 0, 5, 0xfc); /* blue */
+
 	return 0;
 }
 
diff --git a/drivers/staging/imx-drm/parallel-display.c b/drivers/staging/imx-drm/parallel-display.c
index b34f3a3..46b6fce 100644
--- a/drivers/staging/imx-drm/parallel-display.c
+++ b/drivers/staging/imx-drm/parallel-display.c
@@ -248,6 +248,8 @@ static int imx_pd_probe(struct platform_device *pdev)
 			imxpd->interface_pix_fmt = V4L2_PIX_FMT_RGB565;
 		else if (!strcmp(fmt, "bgr666"))
 			imxpd->interface_pix_fmt = V4L2_PIX_FMT_BGR666;
+		else if (!strcmp(fmt, "rgb666"))
+			imxpd->interface_pix_fmt = V4L2_PIX_FMT_RGB666;
 	}
 
 	imxpd->dev = &pdev->dev;
-- 
1.7.9.5

