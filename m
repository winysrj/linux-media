Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:37517 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988AbaDGMpv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Apr 2014 08:45:51 -0400
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
Subject: [PATCH v12][ 08/12] imx-drm: Use drm_display_mode timings flags.
Date: Mon,  7 Apr 2014 14:44:47 +0200
Message-Id: <1396874691-27954-8-git-send-email-denis@eukrea.com>
In-Reply-To: <1396874691-27954-1-git-send-email-denis@eukrea.com>
References: <1396874691-27954-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The previous hardware behaviour was kept if the
flags are not set.

Signed-off-by: Denis Carikli <denis@eukrea.com>
---
ChangeLog v11->v12:
- Rebased: It now uses the following new flags defines names:
  CLK_POL, ENABLE_POL
- The inversions in ipuv3-crtc.c are now fixed.
- ipuv3-crtc.c was still using mode->private_flags
  from the previous versions of this patchset, that's now fixed.

ChangeLog v10->v11:
- This patch was splitted-out and adapted from:
  "Prepare imx-drm for extra display-timings retrival."
- The display-timings dt specific part was removed.
- The flags names were changed to use the DRM ones from:
  "drm: drm_display_mode: add signal polarity flags"
---
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h |    6 ++++--
 drivers/staging/imx-drm/ipu-v3/ipu-di.c     |    7 ++++++-
 drivers/staging/imx-drm/ipuv3-crtc.c        |   20 ++++++++++++++++++--
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
index eba8893..c934394 100644
--- a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
+++ b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
@@ -29,9 +29,11 @@ enum ipuv3_type {
 
 #define CLK_POL_NEGEDGE		0
 #define CLK_POL_POSEDGE		1
+#define CLK_POL_PRESERVE	2
 
 #define ENABLE_POL_LOW		0
 #define ENABLE_POL_HIGH		1
+#define ENABLE_POL_PRESERVE	2
 
 /*
  * Bitfield of Display Interface signal polarities.
@@ -43,10 +45,10 @@ struct ipu_di_signal_cfg {
 	unsigned clksel_en:1;
 	unsigned clkidle_en:1;
 	unsigned data_pol:1;	/* true = inverted */
-	unsigned clk_pol:1;
-	unsigned enable_pol:1;
 	unsigned Hsync_pol:1;	/* true = active high */
 	unsigned Vsync_pol:1;
+	u8 clk_pol;
+	u8 enable_pol;
 
 	u16 width;
 	u16 height;
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-di.c b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
index 0ce3f52..c00b0ba 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-di.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
@@ -597,6 +597,8 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 
 	if (sig->clk_pol == CLK_POL_POSEDGE)
 		di_gen |= DI_GEN_POLARITY_DISP_CLK;
+	else if (sig->clk_pol == CLK_POL_NEGEDGE)
+		di_gen &= ~DI_GEN_POLARITY_DISP_CLK;
 
 	ipu_di_write(di, di_gen, DI_GENERAL);
 
@@ -604,10 +606,13 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 		     DI_SYNC_AS_GEN);
 
 	reg = ipu_di_read(di, DI_POL);
-	reg &= ~(DI_POL_DRDY_DATA_POLARITY | DI_POL_DRDY_POLARITY_15);
+	reg &= ~(DI_POL_DRDY_DATA_POLARITY);
 
 	if (sig->enable_pol == ENABLE_POL_HIGH)
 		reg |= DI_POL_DRDY_POLARITY_15;
+	else if (sig->enable_pol == ENABLE_POL_LOW)
+		reg &= ~DI_POL_DRDY_POLARITY_15;
+
 	if (sig->data_pol)
 		reg |= DI_POL_DRDY_DATA_POLARITY;
 
diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index 9ba089c..b59b745 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -157,8 +157,24 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
 		sig_cfg.Vsync_pol = 1;
 
-	sig_cfg.enable_pol = ENABLE_POL_HIGH;
-	sig_cfg.clk_pol = CLK_POL_NEGEDGE;
+	if (mode->pol_flags & DRM_MODE_FLAG_POL_PIXDATA_POSEDGE)
+		sig_cfg.clk_pol = CLK_POL_POSEDGE;
+	else if (mode->pol_flags & DRM_MODE_FLAG_POL_PIXDATA_NEGEDGE)
+		sig_cfg.clk_pol = CLK_POL_NEGEDGE;
+	else if (mode->pol_flags & DRM_MODE_FLAG_POL_PIXDATA_PRESERVE)
+		sig_cfg.clk_pol = CLK_POL_PRESERVE;
+	else
+		sig_cfg.clk_pol = CLK_POL_NEGEDGE;
+
+	if (mode->pol_flags & DRM_MODE_FLAG_POL_DE_HIGH)
+		sig_cfg.enable_pol = ENABLE_POL_HIGH;
+	else if (mode->pol_flags & DRM_MODE_FLAG_POL_DE_LOW)
+		sig_cfg.enable_pol = ENABLE_POL_LOW;
+	else if (mode->pol_flags & DRM_MODE_FLAG_POL_DE_PRESERVE)
+		sig_cfg.enable_pol = ENABLE_POL_PRESERVE;
+	else
+		sig_cfg.enable_pol = ENABLE_POL_HIGH;
+
 	sig_cfg.width = mode->hdisplay;
 	sig_cfg.height = mode->vdisplay;
 	sig_cfg.pixel_fmt = out_pixel_fmt;
-- 
1.7.9.5

