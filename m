Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:42018 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbcGGGfy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jul 2016 02:35:54 -0400
Subject: Re: [PATCH v2 1/3] sur40: properly report a single frame rate of 60
 FPS
To: Florian Echtler <floe@butterbrot.org>, linux-media@vger.kernel.org
References: <1464725733-22119-1-git-send-email-floe@butterbrot.org>
 <f5d84d25-eae4-df9b-819b-256565783c35@xs4all.nl>
 <577B5A2B.5060406@butterbrot.org>
 <cfd020d2-5834-11ac-1b1c-cb98aa872354@xs4all.nl> <577CC3FE.5080200@xs4all.nl>
 <577D6F6B.1050207@butterbrot.org>
Cc: linux-input@vger.kernel.org, Martin Kaltenbrunner <modin@yuri.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2e80f101-fdce-f03e-fa0f-fd92673766b3@xs4all.nl>
Date: Thu, 7 Jul 2016 08:35:46 +0200
MIME-Version: 1.0
In-Reply-To: <577D6F6B.1050207@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/06/2016 10:51 PM, Florian Echtler wrote:
> On 06.07.2016 10:40, Hans Verkuil wrote:
>> On 07/05/16 09:06, Hans Verkuil wrote:
>>> On 07/05/2016 08:56 AM, Florian Echtler wrote:
>>>> On 05.07.2016 08:41, Hans Verkuil wrote:
>>>>>
>>>>> Why is s_parm added when you can't change the framerate?
>>>>
>>>> Oh, I thought it's mandatory to always have s_parm if you have g_parm
>>>> (even if it always returns the same values).
>>>>
>>>>> Same questions for the
>>>>> enum_frameintervals function: it doesn't hurt to have it, but if there is only
>>>>> one unchangeable framerate, then it doesn't make much sense.
>>>>
>>>> If you don't have enum_frameintervals, how would you find out about the
>>>> framerate otherwise? Is g_parm itself enough already for all userspace
>>>> tools?
>>>
>>> It should be. The enum_frameintervals function is much newer than g_parm.
>>>
>>> Frankly, I have the same problem with enum_framesizes: it reports only one
>>> size. These two enum ioctls are normally only implemented if there are at
>>> least two choices. If there is no choice, then G_FMT will return the size
>>> and G_PARM the framerate and there is no need to enumerate anything.
>>>
>>> The problem is that the spec is ambiguous as to the requirements if there
>>> is only one choice for size and interval. Are the enum ioctls allowed in
>>> that case? Personally I think there is nothing against that. But should
>>> S_PARM also be allowed even though it can't actually change the frameperiod?
>>>
>>> Don't bother making changes yet, let me think about this for a bit.
>>
>> OK, I came to the conclusion that if enum_frameintervals returns one or
>> more intervals, then s_parm should be present, even if there is only one
>> possible interval.
>>
>> I have updated the compliance utility to check for this.
> 
> AFAICT, the original patch does meet the requirements, then? Or do you
> have any change requests?

Can you run the latest v4l2-compliance test? If that passes, then I'll take
this patch as-is.

Regards,

	Hans
