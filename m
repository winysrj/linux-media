Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51671 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab0HHW1r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Aug 2010 18:27:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lane Brooks <lane@brooks.nu>
Subject: Re: OMAP3 Bridge Problems
Date: Mon, 9 Aug 2010 00:29:03 +0200
Cc: linux-media@vger.kernel.org
References: <4C583538.8060504@gmail.com> <4C5AE19B.50609@brooks.nu> <4C5B08BE.8080709@brooks.nu>
In-Reply-To: <4C5B08BE.8080709@brooks.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008090029.04455.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lane,

Thanks for the patch.

On Thursday 05 August 2010 20:53:50 Lane Brooks wrote:

[snip]

> I was able to get YUV CCDC capture mode working with rather minimal
> effort. Attached is a patch with the initial effort. Can you comment?

When sending patches for review, please send them inline instead of attaching 
them to the mail. It makes the review easier.

> diff --git a/drivers/media/video/isp/ispccdc.c 
b/drivers/media/video/isp/ispccdc.c
> index 90bcc6c..cc91fa1 100644
> --- a/drivers/media/video/isp/ispccdc.c
> +++ b/drivers/media/video/isp/ispccdc.c
> @@ -1563,6 +1563,15 @@ __ccdc_get_format(struct isp_ccdc_device *ccdc, 
struct v4l2_subdev_fh *fh,
>   * @pad: Pad number
>   * @fmt: Format
>   */
> +
> +static enum v4l2_mbus_pixelcode sink_fmts[] = {
> +	V4L2_MBUS_FMT_SGRBG10_1X10,
> +	V4L2_MBUS_FMT_YUYV16_1X16,
> +	V4L2_MBUS_FMT_UYVY16_1X16,
> +	V4L2_MBUS_FMT_YVYU16_1X16,
> +	V4L2_MBUS_FMT_VYUY16_1X16,
> +};
> +
>  static void
>  ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
>  		unsigned int pad, struct v4l2_mbus_framefmt *fmt,

There's a very similar patch that is currently pending in my queue. It adds 
support for other Bayer patterns. Your overall approach is good, but the two 
patches will conflict.

Once the other one will get committed, your patch will become much simpler. I 
thus won't comment on the parts that will disappear then.

> @@ -1719,6 +1736,45 @@ static int ccdc_set_format(struct v4l2_subdev *sd, 
struct v4l2_subdev_fh *fh,
>  
>  	/* Propagate the format from sink to source */
>  	if (pad == CCDC_PAD_SINK) {
> +		u32 syn_mode, ispctrl_val;
> +		struct isp_device *isp = to_isp_device(ccdc);
> +		if (!isp_get(isp))
> +			return -EBUSY;
> +
> +		syn_mode    = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, 
> +					    ISPCCDC_SYN_MODE);
> +		ispctrl_val = isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, 
> +					    ISP_CTRL);
> +		syn_mode    &= ISPCCDC_SYN_MODE_INPMOD_MASK;
> +		ispctrl_val &= ~(ISPCTRL_PAR_BRIDGE_MASK 
> +				 << ISPCTRL_PAR_BRIDGE_SHIFT);
> +		switch(format->code) {

Documentation/CodingStyle requires a space after the switch keyword. Please 
run scripts/checkpatch.pl before submitting patches.

> +		case V4L2_MBUS_FMT_YUYV16_1X16:
> +		case V4L2_MBUS_FMT_UYVY16_1X16:
> +		case V4L2_MBUS_FMT_YVYU16_1X16:
> +		case V4L2_MBUS_FMT_VYUY16_1X16:
> +			syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
> +
> +			/* TODO: In YCBCR16 mode, the bridge has to be
> +			 * enabled, so we enable it here and force it
> +			 * big endian. Whether to do big or little endian
> +			 * should somehow come from the platform data.*/
> +			ispctrl_val |= ISPCTRL_PAR_BRIDGE_BENDIAN 
> +				<< ISPCTRL_PAR_BRIDGE_SHIFT;
> +			break;
> +		default:
> +			syn_mode |= ISPCCDC_SYN_MODE_INPMOD_RAW;
> +			ispctrl_val |= isp->pdata->parallel.bridge
> +				<< ISPCTRL_PAR_BRIDGE_SHIFT;
> +			break;
> +		}
> +		isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, 
> +			       ISPCCDC_SYN_MODE);

Writing to the ISPCCDC_SYN_MODE register should be moved to ccdc_configure(). 
Just move the switch statement there right after the

	format = &ccdc->formats[CCDC_PAD_SINK];

line (without the ispctrl_val settings), it should be enough.

> +		isp_reg_writel(isp, ispctrl_val, OMAP3_ISP_IOMEM_MAIN, 
> +			       ISP_CTRL);

The ISP_CTRL register should be written in isp_select_bridge_input() only. As 
you correctly mention, whether the data is in little endian or big endian 
format should come from platform data, so I think it's fine to force board 
files to set the isp->pdata->parallel.bridge field to the correct value.

> +		isp_put(isp);
> +
> +
>  		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SOURCE_OF, which);
>  		memcpy(format, fmt, sizeof(*format));
>  		ccdc_try_format(ccdc, fh, CCDC_PAD_SOURCE_OF, format, which);
> diff --git a/drivers/media/video/isp/ispreg.h 
b/drivers/media/video/isp/ispreg.h
> index 7efcfaa..4c191af 100644
> --- a/drivers/media/video/isp/ispreg.h
> +++ b/drivers/media/video/isp/ispreg.h
> @@ -732,10 +732,10 @@
>  #define ISPCTRL_PAR_SER_CLK_SEL_MASK		0xFFFFFFFC
>  
>  #define ISPCTRL_PAR_BRIDGE_SHIFT		2
> -#define ISPCTRL_PAR_BRIDGE_DISABLE		(0x0 << 2)
> -#define ISPCTRL_PAR_BRIDGE_LENDIAN		(0x2 << 2)
> -#define ISPCTRL_PAR_BRIDGE_BENDIAN		(0x3 << 2)
> -#define ISPCTRL_PAR_BRIDGE_MASK			(0x3 << 2)
> +#define ISPCTRL_PAR_BRIDGE_DISABLE		0x0
> +#define ISPCTRL_PAR_BRIDGE_LENDIAN		0x2
> +#define ISPCTRL_PAR_BRIDGE_BENDIAN		0x3
> +#define ISPCTRL_PAR_BRIDGE_MASK			0x3

You should remove the shift in isp_select_bridge_input() instead. Could you 
please submit a patch that does just that ? Don't forget to sign it and 
include a meaningful commit message.

-- 
Regards,

Laurent Pinchart
