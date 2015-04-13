Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45529 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbbDMUjC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 16:39:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tim Nordell <tim.nordell@logicpd.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: [PATCH] OMAP3 ISP: Support top and bottom fields
Date: Mon, 13 Apr 2015 23:39:28 +0300
Message-ID: <2312602.P25xv5l4XT@avalon>
In-Reply-To: <1426883540-19936-1-git-send-email-tim.nordell@logicpd.com>
References: <1426883540-19936-1-git-send-email-tim.nordell@logicpd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

Thank you for the patch.

On Friday 20 March 2015 15:32:20 Tim Nordell wrote:
> The OMAP3ISP can selectively stream either the top or bottom
> field by setting the start line vertical field to a high value
> for the field that one doesn't want to stream.  The driver
> can switch between these utilizing the vertical start feature
> of the CCDC.
> 
> Additionally, we need to ensure that the FLDMODE bit is set
> when we're doing this as we need to differentiate between
> the two frames.
> 
> Signed-off-by: Tim Nordell <tim.nordell@logicpd.com>
> ---
>  drivers/media/platform/omap3isp/ispccdc.c  | 29 +++++++++++++++++++++++++--
>  drivers/media/platform/omap3isp/ispvideo.c |  4 ++--
>  2 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispccdc.c
> b/drivers/media/platform/omap3isp/ispccdc.c index 882ebde..beb8d96 100644
> --- a/drivers/media/platform/omap3isp/ispccdc.c
> +++ b/drivers/media/platform/omap3isp/ispccdc.c
> @@ -1131,6 +1131,7 @@ static void ccdc_configure(struct isp_ccdc_device
> *ccdc) unsigned int sph;
>  	u32 syn_mode;
>  	u32 ccdc_pattern;
> +	int slv0, slv1;

slv0 and slv1 are positive integers, you can use unsigned int. Could you 
please declare one variable per line to match the coding style of the driver, 
and move them right after the declaration of sph ?

>  	ccdc->bt656 = false;
>  	ccdc->fields = 0;
> @@ -1237,11 +1238,27 @@ static void ccdc_configure(struct isp_ccdc_device
> *ccdc) nph = crop->width - 1;
>  	}
> 
> +	/* Default the start vertical line offset to the crop point */
> +	slv0 = slv1 = crop->top;
> +
> +	/* When streaming just the top or bottom field, enable processing
> +	 * of the field input signal so that SLV1 is processed.
> +	 */

The slv[01] trick below doesn't seem trivial to me, it would make sense to 
document it. How about

/* When capturing only the top or bottom field, enable processing of the
 * field input signal and reject the unneeded field by setting its start
 * line to a value larger than the frame height.
 */

> +	if (ccdc->formats[CCDC_PAD_SINK].field == V4L2_FIELD_ALTERNATE) {
> +		if (format->field == V4L2_FIELD_TOP) {
> +			slv1 = 0x7FFF;

Could you please use lowercase for hex constants ?

> +			syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
> +		} else if (format->field == V4L2_FIELD_BOTTOM) {

Can format->field be equal to V4L2_FIELD_TOP or V4L2_FIELD_BOTTOM if ccdc-
>formats[CCDC_PAD_SINK].field is not equal to V4L2_FIELD_ALTERNATE ? If not 
you can remove the outer condition check.

> +			slv0 = 0x7FFF;
> +			syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
> +		}
> +	}
> +
>  	isp_reg_writel(isp, (sph << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
>  		       (nph << ISPCCDC_HORZ_INFO_NPH_SHIFT),
>  		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
> -	isp_reg_writel(isp, (crop->top << ISPCCDC_VERT_START_SLV0_SHIFT) |
> -		       (crop->top << ISPCCDC_VERT_START_SLV1_SHIFT),
> +	isp_reg_writel(isp, (slv0 << ISPCCDC_VERT_START_SLV0_SHIFT) |
> +		       (slv1 << ISPCCDC_VERT_START_SLV1_SHIFT),
>  		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_START);
>  	isp_reg_writel(isp, (crop->height - 1)
>  			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
> @@ -2064,6 +2081,14 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct
> v4l2_subdev_fh *fh, fmt->height *= 2;
>  		}
> 
> +		/* When input format is interlaced with alternating fields the
> +		 * CCDC can pick out just the top or bottom field.
> +		 */
> +		 if (fmt->field == V4L2_FIELD_ALTERNATE &&
> +		   (field == V4L2_FIELD_TOP ||
> +		    field == V4L2_FIELD_BOTTOM))

You could combine this check with the one right above into something like the 
following (untested).

        /* When the input format is interlaced with alternating fields
         * the CCDC can interleave the fields or selectively capture the
         * top or bottom field.
         */
        if (fmt->field == V4L2_FIELD_ALTERNATE) {
                switch (field) {
                case V4L2_FIELD_INTERLACED_TB:
                case V4L2_FIELD_INTERLACED_BT:
                        fmt->height *= 2;
                        /* Fall-through */
                case V4L2_FIELD_TOP:
                case V4L2_FIELD_BOTTOM:
                        fmt->field = field;
                        break;
                }
        }

(an empty default case might be needed to silence compiler warnings)

> +			fmt->field = field;
> +
>  		break;
> 
>  	case CCDC_PAD_SOURCE_VP:

There's something else that bothers me. If I'm not mistaken, the CCDC will 
generate VD0 and VD1 interrupts for both fields, and the ccdc_has_all_fields() 
logic will wait until both fields have been captured before returning the 
buffer to userspace. This seems to work by chance, and will possibly delay the 
buffer by one field. Shouldn't the function be modified to return true when 
the captured field corresponds to the desired field and false otherwise ?

> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index bbbe55d..e636168 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -797,12 +797,12 @@ isp_video_set_format(struct file *file, void *fh,
> struct v4l2_format *format) /* Fall-through */
>  	case V4L2_FIELD_INTERLACED_TB:
>  	case V4L2_FIELD_INTERLACED_BT:
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
>  		/* Interlaced orders are only supported at the CCDC output. */
>  		if (video != &video->isp->isp_ccdc.video_out)
>  			format->fmt.pix.field = V4L2_FIELD_NONE;
>  		break;
> -	case V4L2_FIELD_TOP:
> -	case V4L2_FIELD_BOTTOM:
>  	case V4L2_FIELD_SEQ_TB:
>  	case V4L2_FIELD_SEQ_BT:
>  	default:

-- 
Regards,

Laurent Pinchart

