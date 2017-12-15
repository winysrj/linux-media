Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:49073 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753279AbdLOLRY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 06:17:24 -0500
Subject: Re: [PATCH] v4l2-dv-timings: add v4l2_hdmi_colorimetry()
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <7651d5f8-5e9c-4bd0-c67e-4e07f8f3295f@xs4all.nl>
CC: Tim Harvey <tharvey@gateworks.com>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <656a5e1b-b81d-d4f9-3383-d441a6b4276b@synopsys.com>
Date: Fri, 15 Dec 2017 11:17:14 +0000
MIME-Version: 1.0
In-Reply-To: <7651d5f8-5e9c-4bd0-c67e-4e07f8f3295f@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 15-12-2017 09:48, Hans Verkuil wrote:
> Add the v4l2_hdmi_colorimetry() function so we have a single function
> that determines the colorspace, YCbCr encoding, quantization range and
> transfer function from the InfoFrame data.

You could also make AVI infoframe optional and return RGB in that
case.

Anyway, I took a quick look at the spec and everything seems ok.

Reviewed-by: Jose Abreu <joabreu@synopsys.com>

Best Regards,
Jose Miguel Abreu

>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> Tim, you can add this patch to your driver patch series and just call it.
> Note that this colorspace information is what the HDMI gives you, if you
> need to convert this than you will need to update this information accordingly
> (e.g. lim to full range, 601 to 709 conversions, etc.) before giving it to
> userspace.
>
> Jose, I'm not sure if you need it in your driver, but this is probably useful
> regardless.
>
> Regards,
>
> 	Hans
> ---
>  drivers/media/v4l2-core/v4l2-dv-timings.c | 141 ++++++++++++++++++++++++++++++
>  include/media/v4l2-dv-timings.h           |  21 +++++
>  2 files changed, 162 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
> index 930f9c53a64e..0182d3d3f807 100644
> --- a/drivers/media/v4l2-core/v4l2-dv-timings.c
> +++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
> @@ -27,6 +27,7 @@
>  #include <linux/v4l2-dv-timings.h>
>  #include <media/v4l2-dv-timings.h>
>  #include <linux/math64.h>
> +#include <linux/hdmi.h>
>
>  MODULE_AUTHOR("Hans Verkuil");
>  MODULE_DESCRIPTION("V4L2 DV Timings Helper Functions");
> @@ -814,3 +815,143 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait)
>  	return aspect;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_calc_aspect_ratio);
> +
> +/** v4l2_hdmi_rx_colorimetry - determine HDMI colorimetry information
> + *	based on various InfoFrames.
> + * @avi - the AVI InfoFrame
> + * @hdmi - the HDMI Vendor InfoFrame, may be NULL
> + * @height - the frame height
> + *
> + * Determines the HDMI colorimetry information, i.e. how the HDMI
> + * pixel color data should be interpreted.
> + *
> + * Note that some of the newer features (DCI-P3, HDR) are not yet
> + * implemented: the hdmi.h header needs to be updated to the HDMI 2.0
> + * and CTA-861-G standards.
> + */
> +struct v4l2_hdmi_colorimetry
> +v4l2_hdmi_rx_colorimetry(const struct hdmi_avi_infoframe *avi,
> +			 const struct hdmi_vendor_infoframe *hdmi,
> +			 unsigned int height)
> +{
> +	struct v4l2_hdmi_colorimetry c = {
> +		V4L2_COLORSPACE_SRGB,
> +		V4L2_YCBCR_ENC_DEFAULT,
> +		V4L2_QUANTIZATION_FULL_RANGE,
> +		V4L2_XFER_FUNC_SRGB
> +	};
> +	bool is_ce = avi->video_code || (hdmi && hdmi->vic);
> +	bool is_sdtv = height <= 576;
> +	bool default_is_lim_range_rgb = avi->video_code > 1;
> +
> +	switch (avi->colorspace) {
> +	case HDMI_COLORSPACE_RGB:
> +		/* RGB pixel encoding */
> +		switch (avi->colorimetry) {
> +		case HDMI_COLORIMETRY_EXTENDED:
> +			switch (avi->extended_colorimetry) {
> +			case HDMI_EXTENDED_COLORIMETRY_ADOBE_RGB:
> +				c.colorspace = V4L2_COLORSPACE_ADOBERGB;
> +				c.xfer_func = V4L2_XFER_FUNC_ADOBERGB;
> +				break;
> +			case HDMI_EXTENDED_COLORIMETRY_BT2020:
> +				c.colorspace = V4L2_COLORSPACE_BT2020;
> +				c.xfer_func = V4L2_XFER_FUNC_709;
> +				break;
> +			default:
> +				break;
> +			}
> +			break;
> +		default:
> +			break;
> +		}
> +		switch (avi->quantization_range) {
> +		case HDMI_QUANTIZATION_RANGE_LIMITED:
> +			c.quantization = V4L2_QUANTIZATION_LIM_RANGE;
> +			break;
> +		case HDMI_QUANTIZATION_RANGE_FULL:
> +			break;
> +		default:
> +			if (default_is_lim_range_rgb)
> +				c.quantization = V4L2_QUANTIZATION_LIM_RANGE;
> +			break;
> +		}
> +		break;
> +
> +	default:
> +		/* YCbCr pixel encoding */
> +		c.quantization = V4L2_QUANTIZATION_LIM_RANGE;
> +		switch (avi->colorimetry) {
> +		case HDMI_COLORIMETRY_NONE:
> +			if (!is_ce)
> +				break;
> +			if (is_sdtv) {
> +				c.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +				c.ycbcr_enc = V4L2_YCBCR_ENC_601;
> +			} else {
> +				c.colorspace = V4L2_COLORSPACE_REC709;
> +				c.ycbcr_enc = V4L2_YCBCR_ENC_709;
> +			}
> +			c.xfer_func = V4L2_XFER_FUNC_709;
> +			break;
> +		case HDMI_COLORIMETRY_ITU_601:
> +			c.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +			c.ycbcr_enc = V4L2_YCBCR_ENC_601;
> +			c.xfer_func = V4L2_XFER_FUNC_709;
> +			break;
> +		case HDMI_COLORIMETRY_ITU_709:
> +			c.colorspace = V4L2_COLORSPACE_REC709;
> +			c.ycbcr_enc = V4L2_YCBCR_ENC_709;
> +			c.xfer_func = V4L2_XFER_FUNC_709;
> +			break;
> +		case HDMI_COLORIMETRY_EXTENDED:
> +			switch (avi->extended_colorimetry) {
> +			case HDMI_EXTENDED_COLORIMETRY_XV_YCC_601:
> +				c.colorspace = V4L2_COLORSPACE_REC709;
> +				c.ycbcr_enc = V4L2_YCBCR_ENC_XV709;
> +				c.xfer_func = V4L2_XFER_FUNC_709;
> +				break;
> +			case HDMI_EXTENDED_COLORIMETRY_XV_YCC_709:
> +				c.colorspace = V4L2_COLORSPACE_REC709;
> +				c.ycbcr_enc = V4L2_YCBCR_ENC_XV601;
> +				c.xfer_func = V4L2_XFER_FUNC_709;
> +				break;
> +			case HDMI_EXTENDED_COLORIMETRY_S_YCC_601:
> +				c.colorspace = V4L2_COLORSPACE_SRGB;
> +				c.ycbcr_enc = V4L2_YCBCR_ENC_601;
> +				c.xfer_func = V4L2_XFER_FUNC_SRGB;
> +				break;
> +			case HDMI_EXTENDED_COLORIMETRY_ADOBE_YCC_601:
> +				c.colorspace = V4L2_COLORSPACE_ADOBERGB;
> +				c.ycbcr_enc = V4L2_YCBCR_ENC_601;
> +				c.xfer_func = V4L2_XFER_FUNC_ADOBERGB;
> +				break;
> +			case HDMI_EXTENDED_COLORIMETRY_BT2020:
> +				c.colorspace = V4L2_COLORSPACE_BT2020;
> +				c.ycbcr_enc = V4L2_YCBCR_ENC_BT2020;
> +				c.xfer_func = V4L2_XFER_FUNC_709;
> +				break;
> +			case HDMI_EXTENDED_COLORIMETRY_BT2020_CONST_LUM:
> +				c.colorspace = V4L2_COLORSPACE_BT2020;
> +				c.ycbcr_enc = V4L2_YCBCR_ENC_BT2020_CONST_LUM;
> +				c.xfer_func = V4L2_XFER_FUNC_709;
> +				break;
> +			default: /* fall back to ITU_709 */
> +				c.colorspace = V4L2_COLORSPACE_REC709;
> +				c.ycbcr_enc = V4L2_YCBCR_ENC_709;
> +				c.xfer_func = V4L2_XFER_FUNC_709;
> +				break;
> +			}
> +			break;
> +		default:
> +			break;
> +		}
> +		/*
> +		 * YCC Quantization Range signaling is more-or-less broken,
> +		 * let's just ignore this.
> +		 */
> +		break;
> +	}
> +	return c;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_hdmi_rx_colorimetry);
> diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
> index 61a18893e004..835aef7f9ad4 100644
> --- a/include/media/v4l2-dv-timings.h
> +++ b/include/media/v4l2-dv-timings.h
> @@ -223,5 +223,26 @@ static inline  bool can_reduce_fps(struct v4l2_bt_timings *bt)
>  	return false;
>  }
>
> +/**
> + * struct v4l2_hdmi_rx_colorimetry - describes the HDMI colorimetry information
> + * @colorspace:		enum v4l2_colorspace, the colorspace
> + * @ycbcr_enc:		enum v4l2_ycbcr_encoding, Y'CbCr encoding
> + * @quantization:	enum v4l2_quantization, colorspace quantization
> + * @xfer_func:		enum v4l2_xfer_func, colorspace transfer function
> + */
> +struct v4l2_hdmi_colorimetry {
> +	enum v4l2_colorspace colorspace;
> +	enum v4l2_ycbcr_encoding ycbcr_enc;
> +	enum v4l2_quantization quantization;
> +	enum v4l2_xfer_func xfer_func;
> +};
> +
> +struct hdmi_avi_infoframe;
> +struct hdmi_vendor_infoframe;
> +
> +struct v4l2_hdmi_colorimetry
> +v4l2_hdmi_rx_colorimetry(const struct hdmi_avi_infoframe *avi,
> +			 const struct hdmi_vendor_infoframe *hdmi,
> +			 unsigned int height);
>
>  #endif
