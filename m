Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:15067 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3JaNSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Oct 2013 09:18:42 -0400
Date: Thu, 31 Oct 2013 11:18:32 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Denis Carikli <denis@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Eric =?UTF-8?B?QsOpbmFyZA==?= <eric@eukrea.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	devicetree@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	driverdev-devel@linuxdriverproject.org,
	David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [Patch v2][ 13/37] staging: imx-drm: Add RGB666 support for
 parallel display
Message-id: <20131031111832.4246128f@samsung.com>
In-reply-to: <1382022155-21954-14-git-send-email-denis@eukrea.com>
References: <1382022155-21954-1-git-send-email-denis@eukrea.com>
 <1382022155-21954-14-git-send-email-denis@eukrea.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Oct 2013 17:02:11 +0200
Denis Carikli <denis@eukrea.com> escreveu:

> Support the RGB666 format on the IPUv3 parallel display.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: devicetree@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: driverdev-devel@linuxdriverproject.org
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: linux-media@vger.kernel.org
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Eric Bénard <eric@eukrea.com>
> Signed-off-by: Denis Carikli <denis@eukrea.com>

It seems better to apply this one together with the other DRM patches via
DRM tree. So:
	Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

> ---
>  .../bindings/staging/imx-drm/fsl-imx-drm.txt       |    2 +-
>  drivers/staging/imx-drm/ipu-v3/ipu-dc.c            |    9 +++++++++
>  drivers/staging/imx-drm/parallel-display.c         |    2 ++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt b/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
> index b876d49..2d24425 100644
> --- a/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
> +++ b/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
> @@ -29,7 +29,7 @@ Required properties:
>  - crtc: the crtc this display is connected to, see below
>  Optional properties:
>  - interface_pix_fmt: How this display is connected to the
> -  crtc. Currently supported types: "rgb24", "rgb565", "bgr666"
> +  crtc. Currently supported types: "rgb24", "rgb565", "bgr666", "rgb666"
>  - edid: verbatim EDID data block describing attached display.
>  - ddc: phandle describing the i2c bus handling the display data
>    channel
> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
> index 21bf1c8..c84ad22 100644
> --- a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
> +++ b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
> @@ -91,6 +91,7 @@ enum ipu_dc_map {
>  	IPU_DC_MAP_RGB565,
>  	IPU_DC_MAP_GBR24, /* TVEv2 */
>  	IPU_DC_MAP_BGR666,
> +	IPU_DC_MAP_RGB666,
>  };
>  
>  struct ipu_dc {
> @@ -152,6 +153,8 @@ static int ipu_pixfmt_to_map(u32 fmt)
>  		return IPU_DC_MAP_GBR24;
>  	case V4L2_PIX_FMT_BGR666:
>  		return IPU_DC_MAP_BGR666;
> +	case V4L2_PIX_FMT_RGB666:
> +		return IPU_DC_MAP_RGB666;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -395,6 +398,12 @@ int ipu_dc_init(struct ipu_soc *ipu, struct device *dev,
>  	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 1, 11, 0xfc); /* green */
>  	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 2, 17, 0xfc); /* red */
>  
> +	/* rgb666 */
> +	ipu_dc_map_clear(priv, IPU_DC_MAP_BGR666);
> +	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 2, 17, 0xfc); /* red */
> +	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 1, 11, 0xfc); /* green */
> +	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 0, 5, 0xfc); /* blue */
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/staging/imx-drm/parallel-display.c b/drivers/staging/imx-drm/parallel-display.c
> index c04b017..1c8f63f 100644
> --- a/drivers/staging/imx-drm/parallel-display.c
> +++ b/drivers/staging/imx-drm/parallel-display.c
> @@ -238,6 +238,8 @@ static int imx_pd_probe(struct platform_device *pdev)
>  			imxpd->interface_pix_fmt = V4L2_PIX_FMT_RGB565;
>  		else if (!strcmp(fmt, "bgr666"))
>  			imxpd->interface_pix_fmt = V4L2_PIX_FMT_BGR666;
> +		else if (!strcmp(fmt, "rgb666"))
> +			imxpd->interface_pix_fmt = V4L2_PIX_FMT_RGB666;
>  	}
>  
>  	imxpd->dev = &pdev->dev;


-- 

Cheers,
Mauro
