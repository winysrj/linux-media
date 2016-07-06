Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33139 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007AbcGFIki (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jul 2016 04:40:38 -0400
Subject: Re: [PATCH v2 1/3] sur40: properly report a single frame rate of 60
 FPS
To: Florian Echtler <floe@butterbrot.org>, linux-media@vger.kernel.org
References: <1464725733-22119-1-git-send-email-floe@butterbrot.org>
 <f5d84d25-eae4-df9b-819b-256565783c35@xs4all.nl>
 <577B5A2B.5060406@butterbrot.org>
 <cfd020d2-5834-11ac-1b1c-cb98aa872354@xs4all.nl>
Cc: linux-input@vger.kernel.org, Martin Kaltenbrunner <modin@yuri.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <577CC3FE.5080200@xs4all.nl>
Date: Wed, 6 Jul 2016 10:40:30 +0200
MIME-Version: 1.0
In-Reply-To: <cfd020d2-5834-11ac-1b1c-cb98aa872354@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/05/16 09:06, Hans Verkuil wrote:
> On 07/05/2016 08:56 AM, Florian Echtler wrote:
>> Hello Hans,
>>
>> On 05.07.2016 08:41, Hans Verkuil wrote:
>>> On 05/31/2016 10:15 PM, Florian Echtler wrote:
>>>> The device hardware is always running at 60 FPS, so report this both via
>>>> PARM_IOCTL and ENUM_FRAMEINTERVALS.
>>>>
>>>> Signed-off-by: Martin Kaltenbrunner <modin@yuri.at>
>>>> Signed-off-by: Florian Echtler <floe@butterbrot.org>
>>>> ---
>>>>  drivers/input/touchscreen/sur40.c | 20 ++++++++++++++++++--
>>>>  1 file changed, 18 insertions(+), 2 deletions(-)
>>>>
>>>> @@ -880,6 +893,9 @@ static const struct v4l2_ioctl_ops sur40_video_ioctl_ops = {
>>>>  	.vidioc_enum_framesizes = sur40_vidioc_enum_framesizes,
>>>>  	.vidioc_enum_frameintervals = sur40_vidioc_enum_frameintervals,
>>>>  
>>>> +	.vidioc_g_parm = sur40_ioctl_parm,
>>>> +	.vidioc_s_parm = sur40_ioctl_parm,
>>>
>>> Why is s_parm added when you can't change the framerate?
>>
>> Oh, I thought it's mandatory to always have s_parm if you have g_parm
>> (even if it always returns the same values).
>>
>>> Same questions for the
>>> enum_frameintervals function: it doesn't hurt to have it, but if there is only
>>> one unchangeable framerate, then it doesn't make much sense.
>>
>> If you don't have enum_frameintervals, how would you find out about the
>> framerate otherwise? Is g_parm itself enough already for all userspace
>> tools?
> 
> It should be. The enum_frameintervals function is much newer than g_parm.
> 
> Frankly, I have the same problem with enum_framesizes: it reports only one
> size. These two enum ioctls are normally only implemented if there are at
> least two choices. If there is no choice, then G_FMT will return the size
> and G_PARM the framerate and there is no need to enumerate anything.
> 
> The problem is that the spec is ambiguous as to the requirements if there
> is only one choice for size and interval. Are the enum ioctls allowed in
> that case? Personally I think there is nothing against that. But should
> S_PARM also be allowed even though it can't actually change the frameperiod?
> 
> Don't bother making changes yet, let me think about this for a bit.

OK, I came to the conclusion that if enum_frameintervals returns one or
more intervals, then s_parm should be present, even if there is only one
possible interval.

I have updated the compliance utility to check for this.

Regards,

	Hans
