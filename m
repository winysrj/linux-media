Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:41487 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751823AbdBJNjk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 08:39:40 -0500
Subject: Re: [PATCH 2/2] [media] tc358743: extend colorimetry support
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <20170208105338.4100-1-p.zabel@pengutronix.de>
 <20170208105338.4100-2-p.zabel@pengutronix.de>
 <51849519-0ed8-e123-3b60-2392c8171cb1@xs4all.nl>
 <1486731993.2309.23.camel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Mats Randgaard <matrandg@cisco.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7fd21a43-7154-0d92-7fdc-7ade3d8b425d@xs4all.nl>
Date: Fri, 10 Feb 2017 14:36:37 +0100
MIME-Version: 1.0
In-Reply-To: <1486731993.2309.23.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/10/17 14:06, Philipp Zabel wrote:
> Hi Hans,
>
> On Fri, 2017-02-10 at 10:42 +0100, Hans Verkuil wrote:
>> Hi Philipp,
>>
>> Here is my review. Please take note of the videodev2.h colorspace patch I
>> posted today, it affects how this patch works since you use V4L2_MAP_QUANTIZATION_DEFAULT.
>
> Thank you for the review.
>
>> On 02/08/2017 11:53 AM, Philipp Zabel wrote:
>>> @@ -1486,16 +1506,40 @@ static int tc358743_get_fmt(struct v4l2_subdev *sd,
>>>
>>>  	switch (vi_rep & MASK_VOUT_COLOR_SEL) {
>>>  	case MASK_VOUT_COLOR_RGB_FULL:
>>> +		format->format.colorspace = V4L2_COLORSPACE_SRGB;
>>> +		format->format.xfer_func = V4L2_XFER_FUNC_SRGB;
>>> +		format->format.ycbcr_enc = V4L2_YCBCR_ENC_601;
>>> +		format->format.quantization = V4L2_QUANTIZATION_FULL_RANGE;
>>> +		break;
>>>  	case MASK_VOUT_COLOR_RGB_LIMITED:
>>>  		format->format.colorspace = V4L2_COLORSPACE_SRGB;
>>> +		format->format.xfer_func = V4L2_XFER_FUNC_SRGB;
>>> +		format->format.ycbcr_enc = V4L2_YCBCR_ENC_601;
>>> +		format->format.quantization = V4L2_QUANTIZATION_LIM_RANGE;
>>>  		break;
>>>  	case MASK_VOUT_COLOR_601_YCBCR_LIMITED:
>>> +		format->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
>>> +		format->format.xfer_func = V4L2_XFER_FUNC_709;
>>> +		format->format.ycbcr_enc = V4L2_YCBCR_ENC_601;
>>> +		format->format.quantization = V4L2_QUANTIZATION_LIM_RANGE;
>>> +		break;
>>>  	case MASK_VOUT_COLOR_601_YCBCR_FULL:
>>>  		format->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
>>> +		format->format.xfer_func = V4L2_XFER_FUNC_709;
>>> +		format->format.ycbcr_enc = V4L2_YCBCR_ENC_XV601;
>>> +		format->format.quantization = V4L2_QUANTIZATION_FULL_RANGE;
>>>  		break;
>>>  	case MASK_VOUT_COLOR_709_YCBCR_FULL:
>>> +		format->format.colorspace = V4L2_COLORSPACE_REC709;
>>> +		format->format.xfer_func = V4L2_XFER_FUNC_709;
>>> +		format->format.ycbcr_enc = V4L2_YCBCR_ENC_XV709;
>>> +		format->format.quantization = V4L2_QUANTIZATION_FULL_RANGE;
>>> +		break;
>>>  	case MASK_VOUT_COLOR_709_YCBCR_LIMITED:
>>>  		format->format.colorspace = V4L2_COLORSPACE_REC709;
>>> +		format->format.xfer_func = V4L2_XFER_FUNC_709;
>>> +		format->format.ycbcr_enc = V4L2_YCBCR_ENC_709;
>>> +		format->format.quantization = V4L2_QUANTIZATION_LIM_RANGE;
>>>  		break;
>>
>> This is wrong (and it is wrong in the original code as well).
>>
>> The colorspace depends on the colorspace information in the AVI InfoFrame, not
>> on what is output. Typically if RGB is received, then that maps to COLORSPACE_SRGB
>> and XFER_FUNC_SRGB. For YCbCr with SMPTE170M it maps to SMPTE170M and XFER_FUNC_709,
>> and REC709 maps to COLORSPACE_REC709 and XFER_FUNC_709.
>
> So colorspace and xfer_func should be set according to the AVI info
> packet, no matter whether the output is RGB or YUV?

Correct. You have no control over that and converting between different
transfer functions and colorimetries requires fancy hardware which
is usually the domain of GPUs and FPGAs and almost never implemented
in standard video receivers. YCbCr encoding and quantization range
can be implemented by a simple 3x3 matrix and a vector offset, so that is
much easier to do.

> I think that information gets parsed into the S_V_COLOR field in the
> VI_STATUS3 register, so I'll use that instead of VOUT_COLOR_SEL.
>
>> The only thing the vout_color_sel modifies are the ycbcr_enc and the quantization
>> range.
>
> Ok.
>
>>>  	default:
>>>  		format->format.colorspace = 0;
>>
>> The driver should never set colorspace to 0.
>
> Ok, I'll fix this.
>
>>> @@ -1512,7 +1556,11 @@ static int tc358743_set_fmt(struct v4l2_subdev *sd,
>>>  	struct tc358743_state *state = to_state(sd);
>>>
>>>  	u32 code = format->format.code; /* is overwritten by get_fmt */
>>> +	enum v4l2_colorspace colorspace = format->format.colorspace;
>>> +	enum v4l2_ycbcr_encoding ycbcr_enc = format->format.ycbcr_enc;
>>> +	enum v4l2_quantization quantization = format->format.quantization;
>>>  	int ret = tc358743_get_fmt(sd, cfg, format);
>>> +	u8 vout_color_sel;
>>>
>>>  	format->format.code = code;
>>>
>>> @@ -1521,16 +1569,78 @@ static int tc358743_set_fmt(struct v4l2_subdev *sd,
>>>
>>>  	switch (code) {
>>>  	case MEDIA_BUS_FMT_RGB888_1X24:
>>> +		colorspace = V4L2_COLORSPACE_SRGB;
>>
>> You can't set the colorspace and/or xfer_func in an HDMI receiver driver. This
>> exclusively depends on the AVI InfoFrame information and you can't change that.
>
> Ok, I'll fix this.
>
>>> +		break;
>>>  	case MEDIA_BUS_FMT_UYVY8_1X16:
>>> +		switch (colorspace) {
>>> +		case V4L2_COLORSPACE_SMPTE170M:
>>> +		case V4L2_COLORSPACE_REC709:
>>> +			break;
>>> +		default:
>>> +			if (format->format.colorspace != V4L2_COLORSPACE_SRGB)
>>> +				colorspace = format->format.colorspace;
>>> +			else
>>> +				colorspace = V4L2_COLORSPACE_SMPTE170M;
>>> +			break;
>>> +		}
>>> +		break;
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	format->format.colorspace = colorspace;
>>> +
>>> +	if (ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
>>> +		ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(colorspace);
>>> +	if (quantization == V4L2_QUANTIZATION_DEFAULT)
>>> +		quantization = V4L2_MAP_QUANTIZATION_DEFAULT(false, colorspace,
>>> +							     ycbcr_enc);
>>
>> That also means that you cannot determine this here, since you won't know the
>> colorspace until you have the InfoFrame information.
>>
>> You should just check the ycbcr_enc and quantization fields: for MEDIA_BUS_FMT_RGB888_1X24
>> you only have to look at the quantization field, for MEDIA_BUS_FMT_UYVY8_1X16
>> both fields need checking.
>
> I assume I should set colorspace and xfer_func according to the detected
> input color space then, same as in get_fmt.

Provided there is a signal, yes.

Otherwise fallback to SRGB.

Regards,

	Hans

