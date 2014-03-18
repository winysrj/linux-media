Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.karo-electronics.de ([81.173.242.67]:49688 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbaCRNFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 09:05:08 -0400
Date: Tue, 18 Mar 2014 14:04:38 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Denis Carikli <denis@eukrea.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, devel@driverdev.osuosl.org,
	Russell King <linux@arm.linux.org.uk>,
	Eric =?UTF-8?B?QsOpbmFyZA==?= <eric@eukrea.com>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 08/12] imx-drm: Use drm_display_mode timings flags.
Message-ID: <20140318140438.7d3fd33a@ipc1.ka-ro>
In-Reply-To: <1394731053-6118-8-git-send-email-denis@eukrea.com>
References: <1394731053-6118-1-git-send-email-denis@eukrea.com>
	<1394731053-6118-8-git-send-email-denis@eukrea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Denis Carikli wrote:
> The previous hardware behaviour was kept if the
> flags are not set.
> 
> Signed-off-by: Denis Carikli <denis@eukrea.com>
> ---
> ChangeLog v10->v11:
> - This patch was splitted-out and adapted from:
>   "Prepare imx-drm for extra display-timings retrival."
> - The display-timings dt specific part was removed.
> - The flags names were changed to use the DRM ones from:
>   "drm: drm_display_mode: add signal polarity flags"
> ---
>  drivers/staging/imx-drm/imx-drm-core.c      |   10 ++++++++++
>  drivers/staging/imx-drm/imx-drm.h           |    6 ++++++
>  drivers/staging/imx-drm/imx-hdmi.c          |    3 +++
>  drivers/staging/imx-drm/imx-ldb.c           |    3 +++
>  drivers/staging/imx-drm/imx-tve.c           |    3 +++
>  drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h |    6 ++++--
>  drivers/staging/imx-drm/ipu-v3/ipu-di.c     |    7 ++++++-
>  drivers/staging/imx-drm/ipuv3-crtc.c        |   21 +++++++++++++++++++--
>  3 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
> index b95cba1..3abeea3 100644
> --- a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
> +++ b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
> @@ -29,9 +29,11 @@ enum ipuv3_type {
>  
>  #define CLK_POL_ACTIVE_LOW	0
>  #define CLK_POL_ACTIVE_HIGH	1
> +#define CLK_POL_PRESERVE	2
>  
>  #define ENABLE_POL_NEGEDGE	0
>  #define ENABLE_POL_POSEDGE	1
> +#define ENABLE_POL_PRESERVE	2
>  
>  /*
>   * Bitfield of Display Interface signal polarities.
> @@ -43,10 +45,10 @@ struct ipu_di_signal_cfg {
>  	unsigned clksel_en:1;
>  	unsigned clkidle_en:1;
>  	unsigned data_pol:1;	/* true = inverted */
> -	unsigned clk_pol:1;
> -	unsigned enable_pol:1;
>  	unsigned Hsync_pol:1;	/* true = active high */
>  	unsigned Vsync_pol:1;
> +	u8 clk_pol;
> +	u8 enable_pol;
>  
>  	u16 width;
>  	u16 height;
> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-di.c b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
> index 53646aa..791080b 100644
> --- a/drivers/staging/imx-drm/ipu-v3/ipu-di.c
> +++ b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
> @@ -597,6 +597,8 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
>  
>  	if (sig->clk_pol == CLK_POL_ACTIVE_HIGH)
>  		di_gen |= DI_GEN_POLARITY_DISP_CLK;
> +	else if (sig->clk_pol == CLK_POL_ACTIVE_LOW)
> +		di_gen &= ~DI_GEN_POLARITY_DISP_CLK;
>  
>  	ipu_di_write(di, di_gen, DI_GENERAL);
>  
> @@ -604,10 +606,13 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
>  		     DI_SYNC_AS_GEN);
>  
>  	reg = ipu_di_read(di, DI_POL);
> -	reg &= ~(DI_POL_DRDY_DATA_POLARITY | DI_POL_DRDY_POLARITY_15);
> +	reg &= ~(DI_POL_DRDY_DATA_POLARITY);
>  
>  	if (sig->enable_pol == ENABLE_POL_POSEDGE)
>  		reg |= DI_POL_DRDY_POLARITY_15;
> +	else if (sig->enable_pol == ENABLE_POL_NEGEDGE)
> +		reg &= ~DI_POL_DRDY_POLARITY_15;
> +
>  	if (sig->data_pol)
>  		reg |= DI_POL_DRDY_DATA_POLARITY;
>  
> diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
> index 8cfeb47..c75034e 100644
> --- a/drivers/staging/imx-drm/ipuv3-crtc.c
> +++ b/drivers/staging/imx-drm/ipuv3-crtc.c
> @@ -157,8 +157,25 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
>  	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
>  		sig_cfg.Vsync_pol = 1;
>  
> -	sig_cfg.enable_pol = ENABLE_POL_POSEDGE;
> -	sig_cfg.clk_pol = CLK_POL_ACTIVE_LOW;
> +	if (mode->pol_flags & DRM_MODE_FLAG_POL_PIXDATA_POSEDGE)
> +		sig_cfg.enable_pol = ENABLE_POL_POSEDGE;
> +	else if (mode->pol_flags & DRM_MODE_FLAG_POL_DE_NEGEDGE)
> +		sig_cfg.enable_pol = ENABLE_POL_NEGEDGE;
> +	else if (mode->pol_flags & DRM_MODE_FLAG_POL_PIXDATA_PRESERVE)
> +		sig_cfg.enable_pol = ENABLE_POL_PRESERVE;
> +	else
> +		sig_cfg.enable_pol = ENABLE_POL_POSEDGE;
> +
> +	if (mode->private_flags & DRM_MODE_FLAG_POL_DE_POSEDGE)
> +		sig_cfg.clk_pol = CLK_POL_ACTIVE_HIGH;
> +	else if (mode->private_flags & DRM_MODE_FLAG_POL_DE_NEGEDGE)
> +		sig_cfg.clk_pol = CLK_POL_ACTIVE_LOW;
> +	else if (mode->private_flags & DRM_MODE_FLAG_POL_DE_PRESERVE)
> +		sig_cfg.clk_pol = CLK_POL_PRESERVE;
> +	else
> +		sig_cfg.clk_pol = CLK_POL_ACTIVE_LOW;
>
This is completely messed up. POL_PIXDATA should obviously define the
clock edge at which the pixel data is sampled and thus should determine
the value of sig_cfg.clk_pol and POL_DE should determine the value of
sig_cfg.enable_pol.



Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
