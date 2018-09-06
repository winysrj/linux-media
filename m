Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:39792 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbeIFMcF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Sep 2018 08:32:05 -0400
Subject: Re: [PATCH v2 3/4] media: imx-pxp: add i.MX Pixel Pipeline driver
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Jacopo Mondi <jacopo@jmondi.org>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
References: <20180905100018.27556-1-p.zabel@pengutronix.de>
 <20180905100018.27556-4-p.zabel@pengutronix.de>
 <b2968b6b-b6ab-dfbe-b51c-5c4e73786039@xs4all.nl>
 <1536153658.4084.7.camel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dbc31612-1686-c115-8618-309355363f27@xs4all.nl>
Date: Thu, 6 Sep 2018 09:57:49 +0200
MIME-Version: 1.0
In-Reply-To: <1536153658.4084.7.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/05/2018 03:20 PM, Philipp Zabel wrote:
> On Wed, 2018-09-05 at 14:50 +0200, Hans Verkuil wrote: 
>>> +static enum v4l2_ycbcr_encoding pxp_default_ycbcr_enc(struct pxp_ctx *ctx)
>>> +{
>>> +	if (ctx->xfer_func)
>>> +		return V4L2_MAP_YCBCR_ENC_DEFAULT(ctx->colorspace);
>>> +	else
>>> +		return V4L2_YCBCR_ENC_DEFAULT;
>>> +}
>>> +
>>> +static enum v4l2_quantization
>>> +pxp_default_quant(struct pxp_ctx *ctx, u32 pixelformat,
>>> +		  enum v4l2_ycbcr_encoding ycbcr_enc)
>>> +{
>>> +	bool is_rgb = !pxp_v4l2_pix_fmt_is_yuv(pixelformat);
>>> +
>>> +	if (ctx->xfer_func)
>>
>> Why check for xfer_func? (same question for the previous function)
> 
> That way if userspace sets
> 	V4L2_XFER_FUNC_DEFAULT
> 	V4L2_YCBCR_ENC_DEFAULT
> 	V4L2_QUANTIZATION_DEFAULT
> on the output queue, it will get
> 	V4L2_XFER_FUNC_DEFAULT
> 	V4L2_YCBCR_ENC_DEFAULT
> 	V4L2_QUANTIZATION_DEFAULT
> on the capture queue.
> 
> If userspace sets xfer_func explicitly, it will get the explicit default
> ycbcr_enc and quantization values.
> 
> I think I did this to make v4l2-compliance at some point, but it could
> be that the explicit output->capture colorimetry copy for RGB->RGB and
> YUV->YUV conversions has me covered now.

This xfer_func test makes no sense. xfer_func is completely ignored by the
driver (other than copying it from output to capture queue) since it can't
make any changes to it anyway.

What you are trying to do in pxp_fixup_colorimetry() is to figure out the
ycbcr_enc and quantization values for the capture queue.

BTW, can you rename pxp_fixup_colorimetry to pxp_fixup_colorimetry_cap or
something? Since it is specifically for the capture queue.

These values depend entirely on the capture queue pixelformat and on the
colorspace and not on the xfer_func value.

So just do:

bool is_rgb = !pxp_v4l2_pix_fmt_is_yuv(dst_fourcc);
*ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(ctx->colorspace);
*quantization = V4L2_MAP_QUANTIZATION_DEFAULT(is_rgb, ctx->colorspace,
					      *ycbcr_enc);

BTW, I just noticed that the V4L2_MAP_QUANTIZATION_DEFAULT macro no longer
uses ycbcr_enc. The comment in videodev2.h should be updated. I can't
change the define as it is used in applications (and we might need to
depend on it again in the future anyway).

If this code will give you v4l2-compliance issues, please let me know.
It shouldn't AFAICT.

Regards,

	Hans
