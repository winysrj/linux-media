Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41867 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750925AbaFYJVH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 05:21:07 -0400
Date: Wed, 25 Jun 2014 10:20:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Denis Carikli <denis@eukrea.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v14 07/10] imx-drm: Use drm_display_mode timings flags.
Message-ID: <20140625092047.GE32514@n2100.arm.linux.org.uk>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com> <1402913484-25910-7-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402913484-25910-7-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 16, 2014 at 12:11:21PM +0200, Denis Carikli wrote:
> The previous hardware behaviour was kept if the
> flags are not set.

I'd like to throw in a patch that I've been carrying for a bit now.
It conflicts with your patches, but I'm happy to fix that conflict
locally (and have been doing so for a while now.)

This is related to a slightly different issue - knowing which types
of bridges are bound to a particualar DI.  This matters in part for
selecting the clock routing - as things currently stand, the last
bridge to call imx_drm_panel_format*() gets its way with this.  With
this change, we can see which bridges are bound, and make the
appropriate decision.  At the moment, we are saved from things going
awry as we don't support cloning outputs.

The relevence to your patch set is that some bridges require clk_pol
to be configured appropriately - HDMI requires clk_pol = 0 in order to
work correctly (with the opposite edge, the image is noisy.)

While this approach only allows us to identify the types of bridges
connected to a DI rather than uniquely identifing the bridges themselves,
I think this is not only an improvement, but also a simplification of
the current code, and allows better decisions about things like clk_pol
to be made.

I'm sending it here because it is relevent to Denis' patch set - I will
also send it out separately if people want it separately, though that
will go to a reduced Cc list.

From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] imx-drm: core: handling of DI clock flags to
 ipu_crtc_mode_set()

We do not need to track the state of the IPU DI's clock flags by having
each display bridge calling back into imx-drm-core, and then back out
into ipuv3-crtc.c.

ipuv3-crtc can instead just scan the list of encoders to retrieve their
type, and build up a picture of which types of encoders are attached.
We can then use this information to configure the IPU DI clocking mode
without any uncertainty - if we have multiple bridges connected to the
same DI, if one of them requires a synchronous DI clock, that's what we
must use.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/staging/imx-drm/imx-drm-core.c |  3 +--
 drivers/staging/imx-drm/imx-drm.h      |  2 +-
 drivers/staging/imx-drm/ipuv3-crtc.c   | 40 +++++++++++++++++++---------------
 3 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index def8280d7ee6..6d9376c760ad 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -115,8 +115,7 @@ int imx_drm_panel_format_pins(struct drm_encoder *encoder,
 	helper = &imx_crtc->imx_drm_helper_funcs;
 	if (helper->set_interface_pix_fmt)
 		return helper->set_interface_pix_fmt(encoder->crtc,
-				encoder->encoder_type, interface_pix_fmt,
-				hsync_pin, vsync_pin);
+				interface_pix_fmt, hsync_pin, vsync_pin);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(imx_drm_panel_format_pins);
diff --git a/drivers/staging/imx-drm/imx-drm.h b/drivers/staging/imx-drm/imx-drm.h
index 7453ae00c412..3c559ccd6af0 100644
--- a/drivers/staging/imx-drm/imx-drm.h
+++ b/drivers/staging/imx-drm/imx-drm.h
@@ -17,7 +17,7 @@ int imx_drm_crtc_id(struct imx_drm_crtc *crtc);
 struct imx_drm_crtc_helper_funcs {
 	int (*enable_vblank)(struct drm_crtc *crtc);
 	void (*disable_vblank)(struct drm_crtc *crtc);
-	int (*set_interface_pix_fmt)(struct drm_crtc *crtc, u32 encoder_type,
+	int (*set_interface_pix_fmt)(struct drm_crtc *crtc,
 			u32 pix_fmt, int hsync_pin, int vsync_pin);
 	const struct drm_crtc_helper_funcs *crtc_helper_funcs;
 	const struct drm_crtc_funcs *crtc_funcs;
diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index 7fec438d8c54..af09032aedb0 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -51,7 +51,6 @@ struct ipu_crtc {
 	struct drm_framebuffer	*newfb;
 	int			irq;
 	u32			interface_pix_fmt;
-	unsigned long		di_clkflags;
 	int			di_hsync_pin;
 	int			di_vsync_pin;
 };
@@ -146,10 +145,13 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 			       int x, int y,
 			       struct drm_framebuffer *old_fb)
 {
+	struct drm_device *dev = crtc->dev;
+	struct drm_encoder *encoder;
 	struct ipu_crtc *ipu_crtc = to_ipu_crtc(crtc);
-	int ret;
 	struct ipu_di_signal_cfg sig_cfg = {};
+	unsigned long encoder_types = 0;
 	u32 out_pixel_fmt;
+	int ret;
 
 	dev_dbg(ipu_crtc->dev, "%s: mode->hdisplay: %d\n", __func__,
 			mode->hdisplay);
@@ -165,6 +167,24 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
 		sig_cfg.Vsync_pol = 1;
 
+	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head)
+		if (encoder->crtc == crtc)
+			encoder_types |= BIT(encoder->encoder_type);
+
+	dev_dbg(ipu_crtc->dev, "%s: attached to encoder types 0x%lx\n",
+		__func__, encoder_types);
+
+	/*
+	 * If we have DAC, TVDAC or LDB, then we need the IPU DI clock
+	 * to be the same as the LDB DI clock.
+	 */
+	if (encoder_types & (BIT(DRM_MODE_ENCODER_DAC) | 
+			     BIT(DRM_MODE_ENCODER_TVDAC) |
+			     BIT(DRM_MODE_ENCODER_LVDS)))
+		sig_cfg.clkflags = IPU_DI_CLKMODE_SYNC | IPU_DI_CLKMODE_EXT;
+	else
+		sig_cfg.clkflags = 0;
+
 	sig_cfg.enable_pol = ENABLE_POL_HIGH;
 	sig_cfg.clk_pol = CLK_POL_NEGEDGE;
 	sig_cfg.width = mode->hdisplay;
@@ -178,7 +198,6 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 	sig_cfg.v_sync_width = mode->vsync_end - mode->vsync_start;
 	sig_cfg.v_end_width = mode->vsync_start - mode->vdisplay;
 	sig_cfg.pixelclock = mode->clock * 1000;
-	sig_cfg.clkflags = ipu_crtc->di_clkflags;
 
 	sig_cfg.v_to_h_sync = 0;
 
@@ -277,7 +296,7 @@ static void ipu_disable_vblank(struct drm_crtc *crtc)
 	ipu_crtc->newfb = NULL;
 }
 
-static int ipu_set_interface_pix_fmt(struct drm_crtc *crtc, u32 encoder_type,
+static int ipu_set_interface_pix_fmt(struct drm_crtc *crtc,
 		u32 pixfmt, int hsync_pin, int vsync_pin)
 {
 	struct ipu_crtc *ipu_crtc = to_ipu_crtc(crtc);
@@ -286,19 +305,6 @@ static int ipu_set_interface_pix_fmt(struct drm_crtc *crtc, u32 encoder_type,
 	ipu_crtc->di_hsync_pin = hsync_pin;
 	ipu_crtc->di_vsync_pin = vsync_pin;
 
-	switch (encoder_type) {
-	case DRM_MODE_ENCODER_DAC:
-	case DRM_MODE_ENCODER_TVDAC:
-	case DRM_MODE_ENCODER_LVDS:
-		ipu_crtc->di_clkflags = IPU_DI_CLKMODE_SYNC |
-			IPU_DI_CLKMODE_EXT;
-		break;
-	case DRM_MODE_ENCODER_TMDS:
-	case DRM_MODE_ENCODER_NONE:
-		ipu_crtc->di_clkflags = 0;
-		break;
-	}
-
 	return 0;
 }
 
-- 
1.8.3.1

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
