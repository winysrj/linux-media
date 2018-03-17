Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51739 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbeCQJdF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Mar 2018 05:33:05 -0400
Subject: Re: [PATCH][RFC] kernel.h: provide array iterator
To: Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        linux-kernel@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Abbott <abbotti@mev.co.uk>
References: <1521108052-26861-1-git-send-email-kieran.bingham@ideasonboard.com>
 <b6af11b9-d697-59ec-6acc-80f0657a3e11@prevas.dk>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <30d9c547-a53b-8c3f-f185-7152bd302c8b@ideasonboard.com>
Date: Sat, 17 Mar 2018 10:32:57 +0100
MIME-Version: 1.0
In-Reply-To: <b6af11b9-d697-59ec-6acc-80f0657a3e11@prevas.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rasmus,

On 16/03/18 16:27, Rasmus Villemoes wrote:
> On 2018-03-15 11:00, Kieran Bingham wrote:
>> Simplify array iteration with a helper to iterate each entry in an array.
>> Utilise the existing ARRAY_SIZE macro to identify the length of the array
>> and pointer arithmetic to process each item as a for loop.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
>> ---
>>  include/linux/kernel.h | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> The use of static arrays to store data is a common use case throughout the
>> kernel. Along with that is the obvious need to iterate that data.
>>
>> In fact there are just shy of 5000 instances of iterating a static array:
>> 	git grep "for .*ARRAY_SIZE" | wc -l
>> 	4943
>>
>> When working on the UVC driver - I found that I needed to split one such
>> iteration into two parts, and at the same time felt that this could be
>> refactored to be cleaner / easier to read. 
> 
> About that, it would be helpful if you first converted to the new
> iterator, so that one can more easily see they are equivalent. And then
> split in two, adding the flush_workqueue call. Or do it the other way
> around. But please don't mix the two in one patch, especially not if
> it's supposed to act as an example of how to use the new helper.
>

My apologies - in the example below I was trying to show the usage and reason
for the macro. This was not meant to be a change to be integrated - the 'example
change' is not how the change will be committed, or included in the patch - but
was added here purely to show the usage / reason for the new macro and promote
the discussion. (So I'll already call that a success)

But that is a good point - the example usage could be much simplified here, and
then included in the commit message.


>> I do however worry that this simple short patch might not be desired or could
>> also be heavily bikeshedded due to it's potential wide spread use (though
>> perhaps that would be a good thing to have more users) ...  but here it is,
>> along with an example usage below which is part of a separate series.
> 
> I think it can be useful, and it does have the must_be_array protection
> built in, so code doesn't silently break if one changes from a
> fixed-size allocation to e.g. a kmalloc-based one. Just don't attempt a
> tree-wide mass conversion, but obviously starting to make use of it when
> refactoring code anyway is fine.

Well it had already been suggested to try to make a coccinelle patch - but I
suspect time and effort required may delay or postpone that currently.

I'll focus on seeing if I can actually get this macro in before expending effort
on a full conversion :-D

I originally anticipated that this would be a 'convert or use as required' style
change.


> And now, the bikeshedding you expected :)

It wouldn't be a discussion without it :D


>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index ce51455e2adf..95d7dae248b7 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -70,6 +70,16 @@
>>   */
>>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>>  
>> +/**
>> + * for_each_array_element - Iterate all items in an array
>> + * @elem: pointer of array type for iteration cursor
> 
> Hm, "pointer of array type" sounds wrong; it's not a "pointer to array".
> But "pointer of array elements' type" is clumsy. Maybe just "@elem:
> iteration cursor" is clear enough.

"@elem: iteration cursor" sounds good to me.

Depending on how the other conversations go here - I will likely make this
change. (I see there was a previous attempt at including a very similar macro)


>> + * @array: array to be iterated
>> + */
>> +#define for_each_array_element(elem, array) \
>> +	for (elem = &(array)[0]; \
>> +	     elem < &(array)[ARRAY_SIZE(array)]; \
>> +	     ++elem)
>> +
> 
> Please parenthesize elem as well.

That's certainly a good point! Thanks :D

> Rasmus

Regards

Kieran Bingham
