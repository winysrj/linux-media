Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:35171 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751313AbdBMKje (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 05:39:34 -0500
Message-ID: <1486982371.2873.52.camel@pengutronix.de>
Subject: Re: [PATCH v2 2/2] [media] tc358743: extend colorimetry support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Mats Randgaard <matrandg@cisco.com>
Date: Mon, 13 Feb 2017 11:39:31 +0100
In-Reply-To: <aae5aa4d-f407-41eb-b244-41affbdafab5@xs4all.nl>
References: <1486977877-26206-1-git-send-email-p.zabel@pengutronix.de>
         <1486977877-26206-2-git-send-email-p.zabel@pengutronix.de>
         <aae5aa4d-f407-41eb-b244-41affbdafab5@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-02-13 at 11:05 +0100, Hans Verkuil wrote:
[...]
> > @@ -1469,38 +1477,88 @@ static int tc358743_s_stream(struct v4l2_subdev *sd, int enable)
> >  
> >  /* --------------- PAD OPS --------------- */
> >  
> > -static int tc358743_get_fmt(struct v4l2_subdev *sd,
> > -		struct v4l2_subdev_pad_config *cfg,
> > -		struct v4l2_subdev_format *format)
> > +static void tc358743_get_csi_color_space(struct v4l2_subdev *sd,
> > +					 struct v4l2_mbus_framefmt *format)
> >  {
> > -	struct tc358743_state *state = to_state(sd);
> > +	u8 vi_status3 = i2c_rd8(sd, VI_STATUS3);
> >  	u8 vi_rep = i2c_rd8(sd, VI_REP);
> >  
> > -	if (format->pad != 0)
> > -		return -EINVAL;
> > +	switch (vi_status3 & MASK_S_V_COLOR) {
> > +	default:
> > +	case MASK_S_V_COLOR_RGB:
> > +	case MASK_S_V_COLOR_SYCC601:
> > +		format->colorspace = V4L2_COLORSPACE_SRGB;
> > +		format->xfer_func = V4L2_XFER_FUNC_SRGB;
> > +		break;
> > +	case MASK_S_V_COLOR_YCBCR601:
> > +	case MASK_S_V_COLOR_XVYCC601:
> > +		format->colorspace = V4L2_COLORSPACE_SMPTE170M;
> 
> Not correct. XVYCC601 uses the REC709 colorspace. The XVYCC formats
> are only defined for the REC709 colorspace and only differ in the
> YCbCr encoding that they use.

I'll move the XVYCC601 case down to join YCBCR709 and XVYCC709.

> > +		format->xfer_func = V4L2_XFER_FUNC_709;
> > +		break;
> > +	case MASK_S_V_COLOR_YCBCR709:
> > +	case MASK_S_V_COLOR_XVYCC709:
> > +		format->colorspace = V4L2_COLORSPACE_REC709;
> > +		format->xfer_func = V4L2_XFER_FUNC_709;
> > +		break;
> > +	case MASK_S_V_COLOR_ADOBERGB:
> > +	case MASK_S_V_COLOR_ADOBEYCC601:
> > +		format->colorspace = V4L2_COLORSPACE_ADOBERGB;
> > +		format->xfer_func = V4L2_XFER_FUNC_ADOBERGB;
> > +		break;
> > +	}
> >  
> > -	format->format.code = state->mbus_fmt_code;
> > -	format->format.width = state->timings.bt.width;
> > -	format->format.height = state->timings.bt.height;
> > -	format->format.field = V4L2_FIELD_NONE;
> > +	format->ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(format->colorspace);
> >  
> >  	switch (vi_rep & MASK_VOUT_COLOR_SEL) {
> > +	default:
> >  	case MASK_VOUT_COLOR_RGB_FULL:
> > +		format->ycbcr_enc = V4L2_YCBCR_ENC_601;
> > +		format->quantization = V4L2_QUANTIZATION_FULL_RANGE;
> > +		break;
> >  	case MASK_VOUT_COLOR_RGB_LIMITED:
> > -		format->format.colorspace = V4L2_COLORSPACE_SRGB;
> > +		format->ycbcr_enc = V4L2_YCBCR_ENC_601;
> > +		format->quantization = V4L2_QUANTIZATION_LIM_RANGE;
> >  		break;
> >  	case MASK_VOUT_COLOR_601_YCBCR_LIMITED:
> > +		format->ycbcr_enc = V4L2_YCBCR_ENC_601;
> > +		format->quantization = V4L2_QUANTIZATION_LIM_RANGE;
> > +		break;
> >  	case MASK_VOUT_COLOR_601_YCBCR_FULL:
> > -		format->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
> > +		format->ycbcr_enc = V4L2_YCBCR_ENC_XV601;
> 
> This isn't right. Only use V4L2_YCBCR_ENC_XV601 (or XV709) if this is
> signaled in the InfoFrame.
>
> Full Range V4L2_YCBCR_ENC_601 != Full Range V4L2_YCBCR_ENC_XV601.
> 
> XV601 is similar to Limited Range 601, except that it also utilizes
> values 0-15 and 241-255, thus allowing for a wider gamut of colors.

Thanks. With that explanation, I think I should just change this to
V4L2_YCBCR_ENC_601 and limit the VOUT_COLOR_RGB/601/709 selections to
RGB input.

> > +		format->quantization = V4L2_QUANTIZATION_FULL_RANGE;
> >  		break;
> >  	case MASK_VOUT_COLOR_709_YCBCR_FULL:
> > +		format->ycbcr_enc = V4L2_YCBCR_ENC_XV709;
> > +		format->quantization = V4L2_QUANTIZATION_FULL_RANGE;
> > +		break;
> >  	case MASK_VOUT_COLOR_709_YCBCR_LIMITED:
> > -		format->format.colorspace = V4L2_COLORSPACE_REC709;
> > +		format->ycbcr_enc = V4L2_YCBCR_ENC_709;
> > +		format->quantization = V4L2_QUANTIZATION_LIM_RANGE;
> >  		break;
> > -	default:
> > -		format->format.colorspace = 0;
> > +	case MASK_VOUT_COLOR_FULL_TO_LIMITED:
> > +		format->quantization = V4L2_QUANTIZATION_LIM_RANGE;
> > +		break;
> > +	case MASK_VOUT_COLOR_LIMITED_TO_FULL:
> > +		format->quantization = V4L2_QUANTIZATION_FULL_RANGE;
> >  		break;

Then I'll use FULL_TO_LIMITED / LIMITED_TO_FULL to for YUV inputs and
correctly set ycbcr_enc and quantization depending on this and input
colorspace.

[...]
> Except for the noted issues this looks good to me.

Thank you for the review.

regards
Philipp
