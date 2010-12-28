Return-path: <mchehab@gaivota>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16466 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0L1RWi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 12:22:38 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=windows-1252
Date: Tue, 28 Dec 2010 18:22:35 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] [media] s5p-fimc: update checking scaling ratio range
In-reply-to: <004301cba631$4094e820$c1beb860$%kim@samsung.com>
To: Hyunwoong Kim <khw0178.kim@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Message-id: <4D1A1CDB.4080409@samsung.com>
References: <1293441471-23257-1-git-send-email-khw0178.kim@samsung.com>
 <4D1870F4.60209@samsung.com> <004301cba631$4094e820$c1beb860$%kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>



On 12/28/2010 02:47 AM, Hyunwoong Kim wrote:
> Sylwester Nawrocki wrote:
> 
>> -----Original Message-----
>> From: linux-samsung-soc-owner@vger.kernel.org [mailto:linux-samsung-soc-
>> owner@vger.kernel.org] On Behalf Of Sylwester Nawrocki
>> Sent: Monday, December 27, 2010 7:57 PM
>> To: Hyunwoong Kim
>> Cc: linux-media@vger.kernel.org; linux-samsung-soc@vger.kernel.org
>> Subject: Re: [PATCH] [media] s5p-fimc: update checking scaling ratio range
>>
>> Hi Hyunwoong,
>>
>> On 12/27/2010 10:17 AM, Hyunwoong Kim wrote:
>>> Horizontal and vertical scaling range are according to the following
>> equations.
>>> If (SRC_Width >= 64 x DST_Width) { Exit(-1);  /* Out of Horizontal scale
>> range}
>>> If (SRC_Height >= 64 x DST_Height) { Exit(-1);  /* Out of Vertical scale
>> range}
> 
> <snip>
> 
>>> -int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f);
>>> +int fimc_check_scaler_ratio(struct v4l2_rect *s, struct v4l2_rect *d,
>> int rot);
>>
>> This function always compares 2 width/height pairs, don't you think it
>> could
>> be better to do something like:
>> int fimc_check_scaler_ratio(int sw, int sh, int dw, int dh, int rot);
>> considering your changed usage?
>> That could let us avoid copying arguments before each function call.
> 
> If we use the 5 parameters as you commented, we can avoid copying arguments.
> However, according to ATPCS(The ARM-THUMB Procedure Call Standard), 
> 4 registers from r0 to r3 is used for function's parameters and return
> value.
> If the number of parameters is more than 4, e.g. 5 parameters.
> Four of the parameters are passed by register from r0 to r3. and the fifth
> parameter is pushed in stack.
> That could affect system performance compared to the case that the number of
> parameter is below 4.
> So, I think it's the better way to use 3 parameters according to ATPCS.

IIRC passing and argument by a pointer rather than by value leaves less
possibilities to the compiler for optimization.
By creating a local copy of the function arguments you most likely passing
them *all* through the stack. I think we should not try to over-optimize
the code, the function is not used in fast paths anyway.
Let's make the code simple and let the compiler do the optimization work
what he is best at.

Thank you
Sylwester

> If you don't agree with my opinion, 
> I will send the second patch after modifying the definition of function as
> you mentioned.
> 
> Thank you for your comment.
> 
>> Otherwise looks good to me.
>>>  int fimc_set_scaler_info(struct fimc_ctx *ctx);
>>>  int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
>>>  int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
>>
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
