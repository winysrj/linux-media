Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0062.outbound.protection.outlook.com ([104.47.34.62]:26400
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758836AbeBPRFn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Feb 2018 12:05:43 -0500
Date: Fri, 16 Feb 2018 09:05:31 -0800
From: Hyun Kwon <hyun.kwon@xilinx.com>
To: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        Satish Kumar Nagireddy <SATISHNA@xilinx.com>
Subject: Re: [PATCH v3 8/9] v4l: xilinx: dma: Add scaling and padding factor
 functions
Message-ID: <20180216170531.GB9719@smtp.xilinx.com>
References: <1518676970-19707-1-git-send-email-satishna@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1518676970-19707-1-git-send-email-satishna@xilinx.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Satish,

Thanks for the patch.

On Wed, 2018-02-14 at 22:42:50 -0800, Satish Kumar Nagireddy wrote:
> scaling_factor function returns multiplying factor to calculate
> bytes per component based on color format.
> For eg. scaling factor of YUV420 8 bit format is 1
> so multiplying factor is 1 (8/8)
> scaling factor of YUV420 10 bit format is 1.25 (10/8)
> 
> padding_factor function returns multiplying factor to calculate
> actual width of video according to color format.
> For eg. padding factor of YUV420 8 bit format: 8 bits per 1 component
> no padding bits here, so multiplying factor is 1
> padding factor of YUV422 10 bit format: 32 bits per 3 components
> each component is 10 bit and the factor is 32/30
> 
> Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
> ---
>  drivers/media/platform/xilinx/xilinx-vip.c | 43 ++++++++++++++++++++++++++++++
>  drivers/media/platform/xilinx/xilinx-vip.h |  2 ++
>  2 files changed, 45 insertions(+)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-vip.c b/drivers/media/platform/xilinx/xilinx-vip.c
> index 51b7ef6..7543b75 100644
> --- a/drivers/media/platform/xilinx/xilinx-vip.c
> +++ b/drivers/media/platform/xilinx/xilinx-vip.c
> @@ -94,6 +94,49 @@ const struct xvip_video_format *xvip_get_format_by_fourcc(u32 fourcc)
>  EXPORT_SYMBOL_GPL(xvip_get_format_by_fourcc);
>  
>  /**
> + * xvip_bpl_scaling_factor - Retrieve bpl scaling factor for a 4CC
> + * @fourcc: the format 4CC
> + *
> + * Return: Return numerator and denominator values by address
> + */
> +void xvip_bpl_scaling_factor(u32 fourcc, u32 *numerator, u32 *denominator)
> +{
> +	switch (fourcc) {
> +	case V4L2_PIX_FMT_XV15M:
> +		*numerator = 10;
> +		*denominator = 8;
> +		break;
> +	default:
> +		*numerator   = 1;
> +		*denominator = 1;
> +		break;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(xvip_bpl_scaling_factor);
> +
> +/**
> + * xvip_width_padding_factor - Retrieve width's padding factor for a 4CC
> + * @fourcc: the format 4CC
> + *
> + * Return: Return numerator and denominator values by address
> + */
> +void xvip_width_padding_factor(u32 fourcc, u32 *numerator, u32 *denominator)
> +{
> +	switch (fourcc) {
> +	case V4L2_PIX_FMT_XV15M:
> +		/* 32 bits are required per 30 bits of data */
> +		*numerator = 32;
> +		*denominator = 30;
> +		break;
> +	default:
> +		*numerator   = 1;
> +		*denominator = 1;
> +		break;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(xvip_width_padding_factor);

Could you please take a look at the link below?
https://lists.freedesktop.org/archives/dri-devel/2018-February/165313.html

This approach has been replaced with the macro-pixel concept in DRM patch set.
The set is still on going, but in my opinion that's simpler, ex, as
all needed information can be added to the table. Similar approach may be
useful here.

Thanks,
-hyun

> +
> +/**
>   * xvip_of_get_format - Parse a device tree node and return format information
>   * @node: the device tree node
>   *
> diff --git a/drivers/media/platform/xilinx/xilinx-vip.h b/drivers/media/platform/xilinx/xilinx-vip.h
> index 006dcf77..26fada7 100644
> --- a/drivers/media/platform/xilinx/xilinx-vip.h
> +++ b/drivers/media/platform/xilinx/xilinx-vip.h
> @@ -135,6 +135,8 @@ struct xvip_video_format {
>  const struct xvip_video_format *xvip_get_format_by_code(unsigned int code);
>  const struct xvip_video_format *xvip_get_format_by_fourcc(u32 fourcc);
>  const struct xvip_video_format *xvip_of_get_format(struct device_node *node);
> +void xvip_bpl_scaling_factor(u32 fourcc, u32 *numerator, u32 *denominator);
> +void xvip_width_padding_factor(u32 fourcc, u32 *numerator, u32 *denominator);
>  void xvip_set_format_size(struct v4l2_mbus_framefmt *format,
>  			  const struct v4l2_subdev_format *fmt);
>  int xvip_enum_mbus_code(struct v4l2_subdev *subdev,
> -- 
> 2.7.4
> 
