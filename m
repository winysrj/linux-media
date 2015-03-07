Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35155 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbbCGX1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2015 18:27:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 08/18] omap3isp: Calculate vpclk_div for CSI-2
Date: Sun, 08 Mar 2015 01:27:43 +0200
Message-ID: <4543525.KBGiJ1Clgv@avalon>
In-Reply-To: <1425764475-27691-9-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi> <1425764475-27691-9-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Saturday 07 March 2015 23:41:05 Sakari Ailus wrote:
> The video port clock is l3_ick divided by vpclk_div. This clock must be high
> enough for the external pixel rate. The video port requires two clock
> cycles to process a pixel.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/omap3isp/ispcsi2.c |    8 +++++++-
>  include/media/omap3isp.h                  |    2 --
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispcsi2.c
> b/drivers/media/platform/omap3isp/ispcsi2.c index 14d279d..97cdfeb 100644
> --- a/drivers/media/platform/omap3isp/ispcsi2.c
> +++ b/drivers/media/platform/omap3isp/ispcsi2.c
> @@ -548,6 +548,7 @@ int omap3isp_csi2_reset(struct isp_csi2_device *csi2)
> 
>  static int csi2_configure(struct isp_csi2_device *csi2)
>  {
> +	struct isp_pipeline *pipe = to_isp_pipeline(&csi2->subdev.entity);
>  	const struct isp_bus_cfg *buscfg;
>  	struct isp_device *isp = csi2->isp;
>  	struct isp_csi2_timing_cfg *timing = &csi2->timing[0];
> @@ -570,7 +571,12 @@ static int csi2_configure(struct isp_csi2_device *csi2)
> csi2->frame_skip = 0;
>  	v4l2_subdev_call(sensor, sensor, g_skip_frames, &csi2->frame_skip);
> 
> -	csi2->ctrl.vp_out_ctrl = buscfg->bus.csi2.vpclk_div;
> +	csi2->ctrl.vp_out_ctrl =
> +		clamp_t(unsigned int, pipe->l3_ick / pipe->external_rate - 1,
> +			1, 3);
> +	dev_dbg(isp->dev, "%s: l3_ick %lu, external_rate %u, vp_out_ctrl %u\n",
> +		__func__, pipe->l3_ick,  pipe->external_rate,
> +		csi2->ctrl.vp_out_ctrl);
>  	csi2->ctrl.frame_mode = ISP_CSI2_FRAME_IMMEDIATE;
>  	csi2->ctrl.ecc_enable = buscfg->bus.csi2.crc;
> 
> diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
> index 39e0748..0f0c08b 100644
> --- a/include/media/omap3isp.h
> +++ b/include/media/omap3isp.h
> @@ -129,11 +129,9 @@ struct isp_ccp2_cfg {
>  /**
>   * struct isp_csi2_cfg - CSI2 interface configuration
>   * @crc: Enable the cyclic redundancy check
> - * @vpclk_div: Video port output clock control
>   */
>  struct isp_csi2_cfg {
>  	unsigned crc:1;
> -	unsigned vpclk_div:2;
>  	struct isp_csiphy_lanes_cfg lanecfg;
>  };

-- 
Regards,

Laurent Pinchart

