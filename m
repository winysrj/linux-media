Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39540 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaDOJus (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 05:50:48 -0400
Message-ID: <1397555388.4574.10.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCHv2 4/4] drm: exynos: hdmi: add support for pixel clock
 limitation
From: Lucas Stach <l.stach@pengutronix.de>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, pawel.moll@arm.com,
	b.zolnierkie@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, robh+dt@kernel.org,
	rahul.sharma@samsung.com, m.chehab@samsung.com
Date: Tue, 15 Apr 2014 11:49:48 +0200
In-Reply-To: <1397554040-4037-5-git-send-email-t.stanislaws@samsung.com>
References: <1397554040-4037-1-git-send-email-t.stanislaws@samsung.com>
	 <1397554040-4037-5-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, den 15.04.2014, 11:27 +0200 schrieb Tomasz Stanislawski:
> Adds support for limitation of maximal pixel clock of HDMI
> signal. This feature is needed on boards that contains
> lines or bridges with frequency limitations.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>  .../devicetree/bindings/video/exynos_hdmi.txt      |    4 ++++
>  drivers/gpu/drm/exynos/exynos_hdmi.c               |   12 ++++++++++++
>  include/media/s5p_hdmi.h                           |    1 +
>  3 files changed, 17 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/video/exynos_hdmi.txt b/Documentation/devicetree/bindings/video/exynos_hdmi.txt
> index f9187a2..8718f8d 100644
> --- a/Documentation/devicetree/bindings/video/exynos_hdmi.txt
> +++ b/Documentation/devicetree/bindings/video/exynos_hdmi.txt
> @@ -28,6 +28,10 @@ Required properties:
>  - ddc: phandle to the hdmi ddc node
>  - phy: phandle to the hdmi phy node
>  
> +Optional properties:
> +- max-pixel-clock: used to limit the maximal pixel clock if a board has lines,
> +	connectors or bridges not capable of carring higher frequencies
> +
>  Example:
>  
>  	hdmi {
> diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
> index 2a18f4e..404f1b7 100644
> --- a/drivers/gpu/drm/exynos/exynos_hdmi.c
> +++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
> @@ -195,6 +195,7 @@ struct hdmi_context {
>  	struct hdmi_resources		res;
>  
>  	int				hpd_gpio;
> +	u32				max_pixel_clock;
>  
>  	enum hdmi_type			type;
>  };
> @@ -887,6 +888,9 @@ static int hdmi_mode_valid(struct drm_connector *connector,
>  	if (ret)
>  		return MODE_BAD;
>  
> +	if (mode->clock * 1000 > hdata->max_pixel_clock)
> +		return MODE_BAD;
> +
This should be MODE_CLOCK_HIGH

Regards,
Lucas
-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

