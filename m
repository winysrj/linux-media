Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway22.websitewelcome.com ([192.185.47.129]:43914 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751822AbeBEWPJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 17:15:09 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 8CF4D1AAAD
        for <linux-media@vger.kernel.org>; Mon,  5 Feb 2018 15:54:20 -0600 (CST)
Date: Mon, 05 Feb 2018 15:54:19 -0600
Message-ID: <20180205155419.Horde.WgpJoLkqF8wsBtPMp9n7V8U@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] platform: vivid-cec: use 64-bit arithmetic
 instead of 32-bit
References: <cover.1517856716.git.gustavo@embeddedor.com>
 <cca3c728f123d714dc8e4ed87510aeb2e2d63db6.1517856716.git.gustavo@embeddedor.com>
 <dc931d9d-8cbd-bbd2-0199-b1846e41f274@xs4all.nl>
In-Reply-To: <dc931d9d-8cbd-bbd2-0199-b1846e41f274@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Quoting Hans Verkuil <hverkuil@xs4all.nl>:

> On 02/05/2018 09:36 PM, Gustavo A. R. Silva wrote:
>> Add suffix ULL to constant 10 in order to give the compiler complete
>> information about the proper arithmetic to use. Notice that this
>> constant is used in a context that expects an expression of type
>> u64 (64 bits, unsigned).
>>
>> The expression len * 10 * CEC_TIM_DATA_BIT_TOTAL is currently being
>> evaluated using 32-bit arithmetic.
>>
>> Also, remove unnecessary parentheses and add a code comment to make it
>> clear what is the reason of the code change.
>>
>> Addresses-Coverity-ID: 1454996
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>> Changes in v2:
>>  - Update subject and changelog to better reflect the proposed code changes.
>>  - Add suffix ULL to constant instead of casting a variable.
>>  - Remove unncessary parentheses.
>
> unncessary -> unnecessary
>

Thanks for this.

>>  - Add code comment.
>>
>>  drivers/media/platform/vivid/vivid-cec.c | 11 +++++++++--
>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/vivid/vivid-cec.c  
>> b/drivers/media/platform/vivid/vivid-cec.c
>> index b55d278..614787b 100644
>> --- a/drivers/media/platform/vivid/vivid-cec.c
>> +++ b/drivers/media/platform/vivid/vivid-cec.c
>> @@ -82,8 +82,15 @@ static void vivid_cec_pin_adap_events(struct  
>> cec_adapter *adap, ktime_t ts,
>>
>>  	if (adap == NULL)
>>  		return;
>> -	ts = ktime_sub_us(ts, (CEC_TIM_START_BIT_TOTAL +
>> -			       len * 10 * CEC_TIM_DATA_BIT_TOTAL));
>> +
>> +	/*
>> +	 * Suffix ULL on constant 10 makes the expression
>> +	 * CEC_TIM_START_BIT_TOTAL + 10ULL * len * CEC_TIM_DATA_BIT_TOTAL
>> +	 * be evaluated using 64-bit unsigned arithmetic (u64), which
>> +	 * is what ktime_sub_us expects as second argument.
>> +	 */
>
> That's not really the comment that I was looking for. It still doesn't
> explain *why* this is needed at all. How about something like this:
>

In MHO the reason for the change is simply the discrepancy between the  
arithmetic expected by
the function ktime_sub_us and the arithmetic in which the expression  
is being evaluated. And this
has nothing to do with any particular tool.

> /*
>  * Add the ULL suffix to the constant 10 to work around a false Coverity
>  * "Unintentional integer overflow" warning. Coverity isn't smart enough
>  * to understand that len is always <= 16, so there is no chance of an
>  * integer overflow.
>  */
>

:P

In my opinion it is not a good idea to tie the code to a particular tool.
There are only three appearances of the word 'Coverity' in the whole  
code base, and, honestly I don't want to add more.

So I think I will document this issue as a FP in the Coverity platform.

Thanks!
--
Gustavo

> Regards,
>
> 	Hans
>
>> +	ts = ktime_sub_us(ts, CEC_TIM_START_BIT_TOTAL +
>> +			       10ULL * len * CEC_TIM_DATA_BIT_TOTAL);
>>  	cec_queue_pin_cec_event(adap, false, ts);
>>  	ts = ktime_add_us(ts, CEC_TIM_START_BIT_LOW);
>>  	cec_queue_pin_cec_event(adap, true, ts);
>>
