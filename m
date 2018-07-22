Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32791 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730139AbeGVTAV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Jul 2018 15:00:21 -0400
Received: by mail-pg1-f196.google.com with SMTP id r5-v6so10577888pgv.0
        for <linux-media@vger.kernel.org>; Sun, 22 Jul 2018 11:02:51 -0700 (PDT)
Subject: Re: [PATCH 16/16] media: imx: add mem2mem device
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
 <20180622155217.29302-17-p.zabel@pengutronix.de>
 <8b4ea4ab-0500-9daa-e6e1-031e7d7a0517@mentor.com>
 <1531750331.18173.21.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <0d10c8dc-1406-1ba6-f615-d60ae9c20c58@gmail.com>
Date: Sun, 22 Jul 2018 11:02:47 -0700
MIME-Version: 1.0
In-Reply-To: <1531750331.18173.21.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/16/2018 07:12 AM, Philipp Zabel wrote:
> Hi Steve,
>
> On Thu, 2018-07-05 at 15:09 -0700, Steve Longerbeam wrote:
> [...]
> [...]
>>> +		halign = 0;
>>> +		break;
>>> +	}
>>> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
>>> +		/*
>>> +		 * The IC burst reads 8 pixels at a time. Reading beyond the
>>> +		 * end of the line is usually acceptable. Those pixels are
>>> +		 * ignored, unless the IC has to write the scaled line in
>>> +		 * reverse.
>>> +		 */
>>> +		if (!ipu_rot_mode_is_irt(ctx->rot_mode) &&
>>> +		    ctx->rot_mode && IPU_ROT_BIT_HFLIP)
>>> +			walign = 3;
>> This looks wrong. Do you mean:
>>
>> if (ipu_rot_mode_is_irt(ctx->rot_mode) || (ctx->rot_mode & IPU_ROT_BIT_HFLIP))
>>       walign = 3;
>> else
>>       walign = 1;
> The input DMA burst width alignment is only necessary if the lines are
> scanned from right to left (that is, if HF is enabled) in the scaling
> step.

Ok, thanks for the explanation, that makes sense.

> If the rotator is used, the flipping is done in the rotation step
> instead,

Ah, I missed or forgot about that detail in the ref manual,
I reviewed it again and you are right...

>   so the alignment restriction would be on the width of the
> intermediate tile (and thus on the output height). This is already
> covered by the rotator 8x8 pixel block alignment.

so this makes sense too.

>
>> That is, require 8 byte width alignment for IRT or if HFLIP is enabled.
> No, I specifically meant (!IRT && HFLIP).

Right, but there is still a typo:

if (!ipu_rot_mode_is_irt(ctx->rot_mode) && ctx->rot_mode && IPU_ROT_BIT_HFLIP)

should be:

if (!ipu_rot_mode_is_irt(ctx->rot_mode) && (ctx->rot_mode & IPU_ROT_BIT_HFLIP))


>
> The rotator itself doesn't cause any input alignment restrictions, we
> just have to make sure that the intermediate tiles after scaling are 8x8
> aligned.
>
>> Also, why not simply call ipu_image_convert_adjust() in
>> mem2mem_try_fmt()? If there is something missing in the former
>> function, then it should be added there, instead of adding the
>> missing checks in mem2mem_try_fmt().
> ipu_image_convert_adjust tries to adjust both input and output image at
> the same time, here we just have the format of either input or output
> image. Do you suggest to split this function into an input and an output
> version?

See b4362162c0 ("media: imx: mem2mem: Use ipu_image_convert_adjust
in try format")

in my mediatree fork at git@github.com:slongerbeam/mediatree.git.

Let's discuss this further in the v2 patches.

Steve
