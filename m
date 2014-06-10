Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:45791 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaFJK0M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jun 2014 06:26:12 -0400
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
Subject: [PATCH v13 07/10] imx-drm: Use drm_display_mode timings flags.
Date: Tue, 10 Jun 2014 12:25:48 +0200
Message-Id: <1402395951-7988-7-git-send-email-denis@eukrea.com>
In-Reply-To: <1402395951-7988-1-git-send-email-denis@eukrea.com>
References: <1402395951-7988-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The previous hardware behaviour was kept if the
flags are not set.

Signed-off-by: Denis Carikli <denis@eukrea.com>
---
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
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h |    4 ++--
 drivers/staging/imx-drm/ipu-v3/ipu-di.c     |    2 ++
 drivers/staging/imx-drm/ipuv3-crtc.c        |   18 ++++++++++++++++--
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
index 015e3bf..94b0d8e 100644
--- a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
+++ b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
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
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-di.c b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
index 0ce3f52..faf08e2 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-di.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
@@ -597,6 +597,8 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 
 	if (sig->clk_pol == CLK_POL_POSEDGE)
 		di_gen |= DI_GEN_POLARITY_DISP_CLK;
+	else if (sig->clk_pol == CLK_POL_NEGEDGE)
+		di_gen &= ~DI_GEN_POLARITY_DISP_CLK;
 
 	ipu_di_write(di, di_gen, DI_GENERAL);
 
diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index ba9eea3..10b46b5 100644
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
-- 
1.7.9.5

