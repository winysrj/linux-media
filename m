Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.155]:46644 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751219AbeA3LTf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 06:19:35 -0500
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 104C140136BBD
        for <linux-media@vger.kernel.org>; Tue, 30 Jan 2018 04:55:46 -0600 (CST)
Date: Tue, 30 Jan 2018 04:55:45 -0600
Message-ID: <20180130045545.Horde.1SSKgcFKaDeoUtmczJ8SRH1@gator4166.hostgator.com>
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
In-Reply-To: <43652014-30af-1e4b-c0a9-c23f9633fb2f@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Quoting Hans Verkuil <hverkuil@xs4all.nl>:

> On 01/30/2018 09:51 AM, Gustavo A. R. Silva wrote:
>> Hi Hans,
>>
>> Quoting Hans Verkuil <hverkuil@xs4all.nl>:
>>
>>> Hi Gustavo,
>>>
>>> On 01/30/2018 01:33 AM, Gustavo A. R. Silva wrote:
>>>> Cast len to const u64 in order to avoid a potential integer
>>>> overflow. This variable is being used in a context that expects
>>>> an expression of type const u64.
>>>>
>>>> Addresses-Coverity-ID: 1454996 ("Unintentional integer overflow")
>>>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>>> ---
>>>>  drivers/media/platform/vivid/vivid-cec.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/media/platform/vivid/vivid-cec.c
>>>> b/drivers/media/platform/vivid/vivid-cec.c
>>>> index b55d278..30240ab 100644
>>>> --- a/drivers/media/platform/vivid/vivid-cec.c
>>>> +++ b/drivers/media/platform/vivid/vivid-cec.c
>>>> @@ -83,7 +83,7 @@ static void vivid_cec_pin_adap_events(struct
>>>> cec_adapter *adap, ktime_t ts,
>>>>  	if (adap == NULL)
>>>>  		return;
>>>>  	ts = ktime_sub_us(ts, (CEC_TIM_START_BIT_TOTAL +
>>>> -			       len * 10 * CEC_TIM_DATA_BIT_TOTAL));
>>>> +			       (const u64)len * 10 * CEC_TIM_DATA_BIT_TOTAL));
>>>
>>> This makes no sense. Certainly the const part is pointless. And given that
>>> len is always <= 16 there definitely is no overflow.
>>>
>>
>> Yeah, I understand your point and I know there is no chance of an
>> overflow in this particular case.
>>
>>> I don't really want this cast in the code.
>>>
>>> Sorry,
>>>
>>
>> I'm working through all the Linux kernel Coverity reports, and I
>> thought of sending a patch for this because IMHO it doesn't hurt to
>> give the compiler complete information about the arithmetic in which
>> an expression is intended to be evaluated.
>>
>> I agree that the _const_ part is a bit odd. What do you think about
>> the cast to u64 alone?
>
> What happens if you do: ((u64)CEC_TIM_START_BIT_TOTAL +
>
> I think that forces everything else in the expression to be evaluated
> as u64.
>

Well, in this case the operator precedence takes place and the  
expression len * 10 * CEC_TIM_DATA_BIT_TOTAL is computed first. So the  
issue remains the same.

I can switch the expressions as follows:

(u64)len * 10 * CEC_TIM_DATA_BIT_TOTAL + CEC_TIM_START_BIT_TOTAL

and avoid the cast in the middle.

What do you think?

> It definitely needs a comment that this fixes a bogus Coverity report.
>

I actually added the following line to the message changelog:
Addresses-Coverity-ID: 1454996 ("Unintentional integer overflow")

Certainly, I've run across multiple false positives as in this case,  
but I have also fixed many actual bugs thanks to the Coverity reports.  
So I think in general it is valuable to take a look into these  
reports, either if they spot actual bugs or promote code correctness.

Thanks
--
Gustavo
