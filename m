Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:37866 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1CJKKb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 05:10:31 -0500
Message-ID: <4D78A390.8040500@matrix-vision.de>
Date: Thu, 10 Mar 2011 11:10:24 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 4/4] omap3isp: lane shifter support
References: <1299686863-20701-1-git-send-email-michael.jones@matrix-vision.de> <1299686863-20701-5-git-send-email-michael.jones@matrix-vision.de> <201103100113.25952.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103100113.25952.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

Thanks for the review.  Most of your suggestions didn't warrant
discussion and I will incorporate those changes.  The others are below.

On 03/10/2011 01:13 AM, Laurent Pinchart wrote:
> Hi Michael,
> 
> Thanks for the patch.
> 
> On Wednesday 09 March 2011 17:07:43 Michael Jones wrote:
>> To use the lane shifter, set different pixel formats at each end of
>> the link at the CCDC input.
>>
>> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> 
> [snip]
> 
>> diff --git a/drivers/media/video/omap3-isp/isp.h
>> b/drivers/media/video/omap3-isp/isp.h index 21fa88b..3d13f8b 100644
>> --- a/drivers/media/video/omap3-isp/isp.h
>> +++ b/drivers/media/video/omap3-isp/isp.h
>> @@ -144,8 +144,6 @@ struct isp_reg {
>>   *		ISPCTRL_PAR_BRIDGE_BENDIAN - Big endian
>>   */
>>  struct isp_parallel_platform_data {
>> -	unsigned int width;
>> -	unsigned int data_lane_shift:2;
> 
> I'm afraid you can't remove the data_lane_shift field completely. Board can 
> wire a 8 bits sensor to DATA[9:2] :-/ That needs to be taken into account as 
> well when computing the total shift value.
> 
> Hardware configuration can be done by adding the requested shift value to 
> data_lane_shift for parallel sensors in omap3isp_configure_bridge(), but we 
> also need to take it into account when validating the pipeline.
> 
> I'm not aware of any board requiring data_lane_shift at the moment though, so 
> we could just drop it now and add it back later when needed. This will avoid 
> making this patch more complex.
> 

I'm in favor of leaving it as is for now and adding it back when needed.
 It's a good point, and I do think it should be supported in the long
run, but it'd be nice to not have to worry about it for this patch.  Is
it OK with you to leave 'data_lane_shift' out for now?

>>  	unsigned int clk_pol:1;
>>  	unsigned int bridge:4;
>>  };
> 

[snip]

>>  	/* CCDC_PAD_SINK */
>> diff --git a/drivers/media/video/omap3-isp/ispvideo.c
>> b/drivers/media/video/omap3-isp/ispvideo.c index 3c3b3c4..decc744 100644
>> --- a/drivers/media/video/omap3-isp/ispvideo.c
>> +++ b/drivers/media/video/omap3-isp/ispvideo.c
>> @@ -47,41 +47,59 @@
>>
>>  static struct isp_format_info formats[] = {
> 
> [snip]
> 
>>  	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
>> -	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
>> +	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
> 
> Should this be
> 
>  V4L2_MBUS_FMT_SGRBG10_1X10, 0,
> 
> instead ? DPCM formats are not shiftable. It won't make any difference in 
> practice, as the format is already 8-bit wide, but you state in the flavor 
> field documentation that "=0 if format is not shiftable".

I went back and forth on that since this format is already 8 bits wide
and no non-8-bit format will declare this as its flavor, since it really
is non-shiftable.  Although- now that I explicitly say '=0 if format is
not shiftable', I suppose it does make sense to have flavor=0 here.  I
will change that.

> 
>> +	  V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
> 
> [snip]
> 

[snip]

>> +		if (link_has_shifter) {
>> +			if (!omap3isp_is_shiftable(fmt_source.format.code,
>> +						fmt_sink.format.code)) {
>> +				pr_debug("%s not shiftable.\n", __func__);
> 
> Do we need the pr_debug call ?

No, that was an oversight.

> 
>> +				return -EPIPE;
>> +			}
>> +		} else if (fmt_source.format.code != fmt_sink.format.code)
>> +			return -EPIPE;
>>  	}
>>
>>  	return 0;
> 

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
