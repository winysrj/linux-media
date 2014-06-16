Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:33465 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaFPKMG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 06:12:06 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 5F3D7D1A770
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 12:12:03 +0200 (CEST)
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
Subject: [PATCH v14 07/10] imx-drm: Use drm_display_mode timings flags.
Date: Mon, 16 Jun 2014 12:11:21 +0200
Message-Id: <1402913484-25910-7-git-send-email-denis@eukrea.com>
In-Reply-To: <1402913484-25910-1-git-send-email-denis@eukrea.com>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The previous hardware behaviour was kept if the
flags are not set.

Signed-off-by: Denis Carikli <denis@eukrea.com>
---
ChangeLog v13->v14:
- Rebased

ChangeLog v12->v13:
- This patch doesn't need the DRM_MODE_FLAG_POL_*_PRESERVE flags anymore.
- code cleanup to improve readability:
  - ENABLE_POL_PRESERVE is now gone
  - Less modifications in ipu_di_init_sync_panel
  - more readable modifications in int ipu_crtc_mode_set
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
 drivers/gpu/ipu-v3/ipu-di.c          |    2 ++
 drivers/staging/imx-drm/ipuv3-crtc.c |   18 ++++++++++++++++--
 include/video/imx-ipu-v3.h           |    4 ++--
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-di.c b/drivers/gpu/ipu-v3/ipu-di.c
index d00f357..1a1e116 100644
--- a/drivers/gpu/ipu-v3/ipu-di.c
+++ b/drivers/gpu/ipu-v3/ipu-di.c
@@ -597,6 +597,8 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 
 	if (sig->clk_pol == CLK_POL_POSEDGE)
 		di_gen |= DI_GEN_POLARITY_DISP_CLK;
+	else if (sig->clk_pol == CLK_POL_NEGEDGE)
+		di_gen &= ~DI_GEN_POLARITY_DISP_CLK;
 
 	ipu_di_write(di, di_gen, DI_GENERAL);
 
diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index 7fec438..7fdf575 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -165,8 +165,22 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
 		sig_cfg.Vsync_pol = 1;
 
-	sig_cfg.enable_pol = ENABLE_POL_HIGH;
-	sig_cfg.clk_pol = CLK_POL_NEGEDGE;
+	if (mode->pol_flags & DRM_MODE_FLAG_POL_PIXDATA_POSEDGE)
+		sig_cfg.clk_pol = CLK_POL_POSEDGE;
+	else if (mode->pol_flags & DRM_MODE_FLAG_POL_PIXDATA_NEGEDGE)
+		sig_cfg.clk_pol = CLK_POL_NEGEDGE;
+	else
+		/* If no PIXDATA flags were set, keep the old behaviour */
+		sig_cfg.clk_pol = CLK_POL_NEGEDGE;
+
+	if (mode->pol_flags & DRM_MODE_FLAG_POL_DE_HIGH)
+		sig_cfg.enable_pol = ENABLE_POL_HIGH;
+	else if (mode->pol_flags & DRM_MODE_FLAG_POL_DE_LOW)
+		sig_cfg.enable_pol = ENABLE_POL_LOW;
+	else
+		/* If no DE flags were set, keep the old behaviour */
+		sig_cfg.enable_pol = ENABLE_POL_HIGH;
+
 	sig_cfg.width = mode->hdisplay;
 	sig_cfg.height = mode->vdisplay;
 	sig_cfg.pixel_fmt = out_pixel_fmt;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 8888305..e660522 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -43,10 +43,10 @@ struct ipu_di_signal_cfg {
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
-- 
1.7.9.5

