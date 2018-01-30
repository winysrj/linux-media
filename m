Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.155]:26389 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751434AbeA3L5F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 06:57:05 -0500
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id B7E3E400CE6A5
        for <linux-media@vger.kernel.org>; Tue, 30 Jan 2018 05:57:04 -0600 (CST)
Date: Tue, 30 Jan 2018 05:57:04 -0600
Message-ID: <20180130055704.Horde.TShCAmNQrhFDVoYhY3jkBgi@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] platform: vivid-cec: fix potential integer overflow
 in vivid_cec_pin_adap_events
References: <cover.1517268667.git.gustavo@embeddedor.com>
 <00eea53890802b679c138fc7f68a0f162261d95c.1517268668.git.gustavo@embeddedor.com>
 <2e1afa55-d214-f932-4ba7-2e21f6a2cd3d@xs4all.nl>
 <20180130025141.Horde.h4aoQSwrqdPlpFtSKtB9DuS@gator4166.hostgator.com>
 <43652014-30af-1e4b-c0a9-c23f9633fb2f@xs4all.nl>
 <20180130045545.Horde.1SSKgcFKaDeoUtmczJ8SRH1@gator4166.hostgator.com>
 <3efaaf36-8edb-d899-b89d-902ba1bc63a6@xs4all.nl>
 <20180130054348.Horde.dj9qH83FlLTXD4Y59GxgcMB@gator4166.hostgator.com>
 <9866dd3e-471e-b048-3f9c-21fab4f8b800@xs4all.nl>
In-Reply-To: <9866dd3e-471e-b048-3f9c-21fab4f8b800@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Quoting Hans Verkuil <hverkuil@xs4all.nl>:

> On 01/30/18 12:43, Gustavo A. R. Silva wrote:
>>
>> Quoting Hans Verkuil <hverkuil@xs4all.nl>:
>>
>> [...]
>>
>>>>> What happens if you do: ((u64)CEC_TIM_START_BIT_TOTAL +
>>>>>
>>>>> I think that forces everything else in the expression to be evaluated
>>>>> as u64.
>>>>>
>>>>
>>>> Well, in this case the operator precedence takes place and the
>>>> expression len * 10 * CEC_TIM_DATA_BIT_TOTAL is computed first. So the
>>>> issue remains the same.
>>>>
>>>> I can switch the expressions as follows:
>>>>
>>>> (u64)len * 10 * CEC_TIM_DATA_BIT_TOTAL + CEC_TIM_START_BIT_TOTAL
>>>
>>> What about:
>>>
>>> 10ULL * len * ...
>>>
>>
>> Yeah, I like it.
>>
>>>>
>>>> and avoid the cast in the middle.
>>>>
>>>> What do you think?
>>>
>>> My problem is that (u64)len suggests that there is some problem with len
>>> specifically, which isn't true.
>>>
>>
>> That's a good point. Actually, I think the same applies for the rest
>> of the patch series. Maybe it is a good idea to send a v2 of the whole
>> patchset with that update.
>>
>>>>
>>>>> It definitely needs a comment that this fixes a bogus Coverity report.
>>>>>
>>>>
>>>> I actually added the following line to the message changelog:
>>>> Addresses-Coverity-ID: 1454996 ("Unintentional integer overflow")
>>>
>>> That needs to be in the source, otherwise someone will remove the
>>> cast (or ULL) at some time in the future since it isn't clear why
>>> it is done. And nobody reads commit logs from X years back :-)
>>>
>>
>> You're right. I thought you were talking about the changelog.
>>
>> And unless you think otherwise, I think there is no need for any
>> additional code comment if the update you suggest is applied:
>>
>> len * 10ULL * CEC_TIM_DATA_BIT_TOTAL
>
> I still think I'd like to see a comment. It is still not obvious why
> you would want to use ULL here.
>

OK. That's fine.

> Please use "10ULL * len", it's actually a bit better to have it in
> that order (it's 10 bits per character, so '10 * len' is a more logical
> order).
>

OK. I got it.

Thanks for all the feedback, Hans.
--
Gustavo
