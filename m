Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47173 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbbCRPPD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 11:15:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tim Nordell <tim.nordell@logicpd.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: [PATCH 1/3] omap3isp: Defer probing when subdev isn't available
Date: Wed, 18 Mar 2015 17:15:11 +0200
Message-ID: <3275472.GjEQv8ASR0@avalon>
In-Reply-To: <1426015494-16799-2-git-send-email-tim.nordell@logicpd.com>
References: <1426015494-16799-1-git-send-email-tim.nordell@logicpd.com> <1426015494-16799-2-git-send-email-tim.nordell@logicpd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

Thank you for the patch.

The OMAP3 ISP driver is moving to DT, hopefully in time for v4.1. See "[PATCH 
00/15] omap3isp driver DT support" posted to the list on Monday. I'd rather go 
for proper DT support instead of custom deferred probing.

On Tuesday 10 March 2015 14:24:52 Tim Nordell wrote:
> If the subdev isn't available just yet, defer probing of
> the system.  This is useful if the omap3isp comes up before
> the I2C subsystem does.
> 
> Signed-off-by: Tim Nordell <tim.nordell@logicpd.com>
> ---
>  drivers/media/platform/omap3isp/isp.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 51c2129..a361c40 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -1811,7 +1811,7 @@ isp_register_subdev_group(struct isp_device *isp,
>  				"device %s\n", __func__,
>  				board_info->i2c_adapter_id,
>  				board_info->board_info->type);
> -			continue;
> +			return ERR_PTR(-EPROBE_DEFER);
>  		}
> 
>  		subdev = v4l2_i2c_new_subdev_board(&isp->v4l2_dev, adapter,
> @@ -1898,6 +1898,10 @@ static int isp_register_entities(struct isp_device
> *isp) unsigned int i;
> 
>  		sensor = isp_register_subdev_group(isp, subdevs->subdevs);
> +		if (IS_ERR(sensor)) {
> +			ret = PTR_ERR(sensor);
> +			goto done;
> +		}
>  		if (sensor == NULL)
>  			continue;

-- 
Regards,

Laurent Pinchart

