Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:47491 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbaFPKLp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 06:11:45 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 2DDFB77D27E
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 12:11:37 +0200 (CEST)
From: Denis Carikli <denis@eukrea.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	Denis Carikli <denis@eukrea.com>
Subject: [PATCH v14 02/10] imx-drm: Add RGB666 support for parallel display.
Date: Mon, 16 Jun 2014 12:11:16 +0200
Message-Id: <1402913484-25910-2-git-send-email-denis@eukrea.com>
In-Reply-To: <1402913484-25910-1-git-send-email-denis@eukrea.com>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Denis Carikli <denis@eukrea.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
ChangeLog v13->v14:
- Rebased
ChangeLog v9->v13:
- Rebased
ChangeLog v8->v9:
- Rebased.
- Added Philipp Zabel's ack.
- Shortened the patch title.

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
 .../bindings/staging/imx-drm/fsl-imx-drm.txt       |    4 ++--
 drivers/gpu/ipu-v3/ipu-dc.c                        |    9 +++++++++
 drivers/staging/imx-drm/parallel-display.c         |    2 ++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt b/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
index e75f0e5..c0eb95a 100644
--- a/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
+++ b/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
@@ -60,8 +60,8 @@ Required properties:
 - compatible: Should be "fsl,imx-parallel-display"
 Optional properties:
 - interface_pix_fmt: How this display is connected to the
-  display interface. Currently supported types: "rgb24", "rgb565", "bgr666"
-  and "lvds666".
+  display interface. Currently supported types: "rgb24", "rgb565", "bgr666",
+  "rgb666" and "lvds666".
 - edid: verbatim EDID data block describing attached display.
 - ddc: phandle describing the i2c bus handling the display data
   channel
diff --git a/drivers/gpu/ipu-v3/ipu-dc.c b/drivers/gpu/ipu-v3/ipu-dc.c
index 2326c75..100d410 100644
--- a/drivers/gpu/ipu-v3/ipu-dc.c
+++ b/drivers/gpu/ipu-v3/ipu-dc.c
@@ -93,6 +93,7 @@ enum ipu_dc_map {
 	IPU_DC_MAP_BGR666,
 	IPU_DC_MAP_LVDS666,
 	IPU_DC_MAP_BGR24,
+	IPU_DC_MAP_RGB666,
 };
 
 struct ipu_dc {
@@ -161,6 +162,8 @@ static int ipu_pixfmt_to_map(u32 fmt)
 		return IPU_DC_MAP_LVDS666;
 	case V4L2_PIX_FMT_BGR24:
 		return IPU_DC_MAP_BGR24;
+	case V4L2_PIX_FMT_RGB666:
+		return IPU_DC_MAP_RGB666;
 	default:
 		return -EINVAL;
 	}
@@ -452,6 +455,12 @@ int ipu_dc_init(struct ipu_soc *ipu, struct device *dev,
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
index b567832..64b34336 100644
--- a/drivers/staging/imx-drm/parallel-display.c
+++ b/drivers/staging/imx-drm/parallel-display.c
@@ -218,6 +218,8 @@ static int imx_pd_bind(struct device *dev, struct device *master, void *data)
 			imxpd->interface_pix_fmt = V4L2_PIX_FMT_RGB565;
 		else if (!strcmp(fmt, "bgr666"))
 			imxpd->interface_pix_fmt = V4L2_PIX_FMT_BGR666;
+		else if (!strcmp(fmt, "rgb666"))
+			imxpd->interface_pix_fmt = V4L2_PIX_FMT_RGB666;
 		else if (!strcmp(fmt, "lvds666"))
 			imxpd->interface_pix_fmt = v4l2_fourcc('L', 'V', 'D', '6');
 	}
-- 
1.7.9.5

