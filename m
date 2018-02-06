Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:42008 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752246AbeBFKl7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 05:41:59 -0500
Subject: Re: [PATCH v2 8/8] platform: vivid-cec: use 64-bit arithmetic instead
 of 32-bit
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1517856716.git.gustavo@embeddedor.com>
 <cca3c728f123d714dc8e4ed87510aeb2e2d63db6.1517856716.git.gustavo@embeddedor.com>
 <dc931d9d-8cbd-bbd2-0199-b1846e41f274@xs4all.nl>
 <20180205155419.Horde.WgpJoLkqF8wsBtPMp9n7V8U@gator4166.hostgator.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <238647bc-106d-8dbf-569e-82e7968f887d@xs4all.nl>
Date: Tue, 6 Feb 2018 11:41:54 +0100
MIME-Version: 1.0
In-Reply-To: <20180205155419.Horde.WgpJoLkqF8wsBtPMp9n7V8U@gator4166.hostgator.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/18 22:54, Gustavo A. R. Silva wrote:
> Hi Hans,
> 
> Quoting Hans Verkuil <hverkuil@xs4all.nl>:
> 
>> On 02/05/2018 09:36 PM, Gustavo A. R. Silva wrote:
>>> Add suffix ULL to constant 10 in order to give the compiler complete
>>> information about the proper arithmetic to use. Notice that this
>>> constant is used in a context that expects an expression of type
>>> u64 (64 bits, unsigned).
>>>
>>> The expression len * 10 * CEC_TIM_DATA_BIT_TOTAL is currently being
>>> evaluated using 32-bit arithmetic.
>>>
>>> Also, remove unnecessary parentheses and add a code comment to make it
>>> clear what is the reason of the code change.
>>>
>>> Addresses-Coverity-ID: 1454996
>>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>> ---
>>> Changes in v2:
>>>  - Update subject and changelog to better reflect the proposed code changes.
>>>  - Add suffix ULL to constant instead of casting a variable.
>>>  - Remove unncessary parentheses.
>>
>> unncessary -> unnecessary
>>
> 
> Thanks for this.
> 
>>>  - Add code comment.
>>>
>>>  drivers/media/platform/vivid/vivid-cec.c | 11 +++++++++--
>>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/media/platform/vivid/vivid-cec.c  
>>> b/drivers/media/platform/vivid/vivid-cec.c
>>> index b55d278..614787b 100644
>>> --- a/drivers/media/platform/vivid/vivid-cec.c
>>> +++ b/drivers/media/platform/vivid/vivid-cec.c
>>> @@ -82,8 +82,15 @@ static void vivid_cec_pin_adap_events(struct  
>>> cec_adapter *adap, ktime_t ts,
>>>
>>>  	if (adap == NULL)
>>>  		return;
>>> -	ts = ktime_sub_us(ts, (CEC_TIM_START_BIT_TOTAL +
>>> -			       len * 10 * CEC_TIM_DATA_BIT_TOTAL));
>>> +
>>> +	/*
>>> +	 * Suffix ULL on constant 10 makes the expression
>>> +	 * CEC_TIM_START_BIT_TOTAL + 10ULL * len * CEC_TIM_DATA_BIT_TOTAL
>>> +	 * be evaluated using 64-bit unsigned arithmetic (u64), which
>>> +	 * is what ktime_sub_us expects as second argument.
>>> +	 */
>>
>> That's not really the comment that I was looking for. It still doesn't
>> explain *why* this is needed at all. How about something like this:
>>
> 
> In MHO the reason for the change is simply the discrepancy between the  
> arithmetic expected by
> the function ktime_sub_us and the arithmetic in which the expression  
> is being evaluated. And this
> has nothing to do with any particular tool.

Hmm, you have a point.

OK, I've looked at the other patches in this patch series as well, and
the only thing I would like to see changed is the 'Addresses-Coverity-ID'
line in the patches: patch 4 says:

Addresses-Coverity-ID: 1324146 ("Unintentional integer overflow")

but that's the only one that mentions the specific coverity error.
It would be nice if that can be added to the other patches as well so
we have a record of the actual coverity error.

> 
>> /*
>>  * Add the ULL suffix to the constant 10 to work around a false Coverity
>>  * "Unintentional integer overflow" warning. Coverity isn't smart enough
>>  * to understand that len is always <= 16, so there is no chance of an
>>  * integer overflow.
>>  */
>>
> 
> :P
> 
> In my opinion it is not a good idea to tie the code to a particular tool.
> There are only three appearances of the word 'Coverity' in the whole  
> code base, and, honestly I don't want to add more.
> 
> So I think I will document this issue as a FP in the Coverity platform.

FP?

Regards,

	Hans
