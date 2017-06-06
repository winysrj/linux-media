Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38096 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbdFFWPp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Jun 2017 18:15:45 -0400
Subject: Re: [RFC PATCH] [media] v4l2-subdev: check colorimetry in link
 validate
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1496171288-28656-1-git-send-email-helen.koike@collabora.com>
 <20170531063116.GE1019@valkosipuli.retiisi.org.uk>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
From: Helen Koike <helen.koike@collabora.com>
Message-ID: <847518b4-ad8f-afc3-29b7-7f1b3a16f57e@collabora.com>
Date: Tue, 6 Jun 2017 19:15:34 -0300
MIME-Version: 1.0
In-Reply-To: <20170531063116.GE1019@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,


Thanks for replying

On 2017-05-31 03:31 AM, Sakari Ailus wrote:
> Hi Helen,
>
> On Tue, May 30, 2017 at 04:08:08PM -0300, Helen Koike wrote:
>> colorspace, ycbcr_enc, quantization and xfer_func must match across the
>> link.
>> Check if they match in v4l2_subdev_link_validate_default unless they are
>> set as _DEFAULT.
>>
>> Signed-off-by: Helen Koike <helen.koike@collabora.com>
>>
>> ---
>>
>> Hi,
>>
>> I think we should validate colorimetry as having different colorimetry
>> across a link doesn't make sense.
>> But I am confused about what to do when they are set to _DEFAULT, what
>> do you think?
>
> These fields were added at various points over the course of the past three
> years or so. User space code that was written before that will certainly not
> set anything and I'm not sure many drivers care about these fields nor they
> are relevant for many formats. In practice that means that they are very
> likely zero in many cases.

If they are set to zero then they won't be affected by this patch.

>
> Driver changes will probably be necessary for removing the explicit checks
> for the default value.

At least in the drivers/media tree I couldn't find many drivers that 
implement its own link_validate, there is only 
platform/omap3isp/ispccdc.c and platform/omap3isp/ispresizer.c that 
implements a custom value, but from a quick look it doesn't seems that 
they will be affected.

>
> The same applies to checking the colour space: drivers should enforce using
> the correct colour space before the check can be merged. I might move that
> to a separate patch.

I am not sure if I got what you mean. If driver don't care about 
colourspace then probably it will be set to zero and won't be affected 
by this patch, if colourspace is different across the link then the user 
space must set both ends to the same colourspace.

>
>>
>> Thanks
>> ---
>>  drivers/media/v4l2-core/v4l2-subdev.c | 21 +++++++++++++++++++--
>>  1 file changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
>> index da78497..784ae92 100644
>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
>> @@ -502,10 +502,27 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
>>  				      struct v4l2_subdev_format *source_fmt,
>>  				      struct v4l2_subdev_format *sink_fmt)
>>  {
>> -	/* The width, height and code must match. */
>> +	/* The width, height, code and colorspace must match. */
>>  	if (source_fmt->format.width != sink_fmt->format.width
>>  	    || source_fmt->format.height != sink_fmt->format.height
>> -	    || source_fmt->format.code != sink_fmt->format.code)
>> +	    || source_fmt->format.code != sink_fmt->format.code
>> +	    || source_fmt->format.colorspace != sink_fmt->format.colorspace)
>> +		return -EPIPE;
>> +
>> +	/* Colorimetry must match if they are not set to DEFAULT */
>> +	if (source_fmt->format.ycbcr_enc != V4L2_YCBCR_ENC_DEFAULT
>> +	    && sink_fmt->format.ycbcr_enc != V4L2_YCBCR_ENC_DEFAULT
>> +	    && source_fmt->format.ycbcr_enc != sink_fmt->format.ycbcr_enc)
>> +		return -EPIPE;
>> +
>> +	if (source_fmt->format.quantization != V4L2_QUANTIZATION_DEFAULT
>> +	    && sink_fmt->format.quantization != V4L2_QUANTIZATION_DEFAULT
>> +	    && source_fmt->format.quantization != sink_fmt->format.quantization)
>> +		return -EPIPE;
>> +
>> +	if (source_fmt->format.xfer_func != V4L2_XFER_FUNC_DEFAULT
>> +	    && sink_fmt->format.xfer_func != V4L2_XFER_FUNC_DEFAULT
>> +	    && source_fmt->format.xfer_func != sink_fmt->format.xfer_func)
>>  		return -EPIPE;
>>
>>  	/* The field order must match, or the sink field order must be NONE
>

LN
