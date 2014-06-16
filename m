Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:33486 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbaFPKMO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 06:12:14 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 875B6CA8EE1
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 12:12:11 +0200 (CEST)
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
Subject: [PATCH v14 04/10] imx-drm: use defines for clock polarity settings
Date: Mon, 16 Jun 2014 12:11:18 +0200
Message-Id: <1402913484-25910-4-git-send-email-denis@eukrea.com>
In-Reply-To: <1402913484-25910-1-git-send-email-denis@eukrea.com>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Denis Carikli <denis@eukrea.com>
---
ChangeLog v13->v14:
- Rebased
ChangeLog 12->v13:
- No changes
ChangeLog 11->v12:
- Improved the define names to match the hardware:
  ENABLE_POL is not a clock signal but instead an enable signal.

ChangeLog v9->v10:
- New patch which was splitted out from:
  "staging: imx-drm: Use de-active and pixelclk-active display-timings.".
- Fixes many issues in "staging: imx-drm: Use de-active and pixelclk-active
  display-timings.":
  - More clear meaning of the polarity settings.
  - The SET_CLK_POL and SET_DE_POL masks are not
    needed anymore.
---
 drivers/gpu/ipu-v3/ipu-di.c          |    4 ++--
 drivers/staging/imx-drm/ipuv3-crtc.c |    4 ++--
 include/video/imx-ipu-v3.h           |    8 +++++++-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-di.c b/drivers/gpu/ipu-v3/ipu-di.c
index c490ba4..d00f357 100644
--- a/drivers/gpu/ipu-v3/ipu-di.c
+++ b/drivers/gpu/ipu-v3/ipu-di.c
@@ -595,7 +595,7 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 		}
 	}
 
-	if (sig->clk_pol)
+	if (sig->clk_pol == CLK_POL_POSEDGE)
 		di_gen |= DI_GEN_POLARITY_DISP_CLK;
 
 	ipu_di_write(di, di_gen, DI_GENERAL);
@@ -606,7 +606,7 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 	reg = ipu_di_read(di, DI_POL);
 	reg &= ~(DI_POL_DRDY_DATA_POLARITY | DI_POL_DRDY_POLARITY_15);
 
-	if (sig->enable_pol)
+	if (sig->enable_pol == ENABLE_POL_HIGH)
 		reg |= DI_POL_DRDY_POLARITY_15;
 	if (sig->data_pol)
 		reg |= DI_POL_DRDY_DATA_POLARITY;
diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index 720868b..7fec438 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -165,8 +165,8 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
 		sig_cfg.Vsync_pol = 1;
 
-	sig_cfg.enable_pol = 1;
-	sig_cfg.clk_pol = 0;
+	sig_cfg.enable_pol = ENABLE_POL_HIGH;
+	sig_cfg.clk_pol = CLK_POL_NEGEDGE;
 	sig_cfg.width = mode->hdisplay;
 	sig_cfg.height = mode->vdisplay;
 	sig_cfg.pixel_fmt = out_pixel_fmt;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 3e43e22..8888305 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -27,6 +27,12 @@ enum ipuv3_type {
 
 #define IPU_PIX_FMT_GBR24	v4l2_fourcc('G', 'B', 'R', '3')
 
+#define CLK_POL_NEGEDGE		0
+#define CLK_POL_POSEDGE		1
+
+#define ENABLE_POL_LOW		0
+#define ENABLE_POL_HIGH		1
+
 /*
  * Bitfield of Display Interface signal polarities.
  */
@@ -37,7 +43,7 @@ struct ipu_di_signal_cfg {
 	unsigned clksel_en:1;
 	unsigned clkidle_en:1;
 	unsigned data_pol:1;	/* true = inverted */
-	unsigned clk_pol:1;	/* true = rising edge */
+	unsigned clk_pol:1;
 	unsigned enable_pol:1;
 	unsigned Hsync_pol:1;	/* true = active high */
 	unsigned Vsync_pol:1;
-- 
1.7.9.5

