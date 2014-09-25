Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:44667 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaIYRss (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 13:48:48 -0400
Message-ID: <542455DB.9080708@googlemail.com>
Date: Thu, 25 Sep 2014 19:50:19 +0200
From: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] em28xx-input: NULL dereference on error
References: <20140925113941.GB3708@mwanda> <542421DF.9060000@googlemail.com> <20140925144911.GK5865@mwanda>
In-Reply-To: <20140925144911.GK5865@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 25.09.2014 um 16:49 schrieb Dan Carpenter:
> On Thu, Sep 25, 2014 at 04:08:31PM +0200, Frank Schäfer wrote:
>>>  	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
>>> +	if (!ir)
>>> +		return -ENOMEM;
>>>  	rc = rc_allocate_device();
>>> -	if (!ir || !rc)
>>> +	if (!rc)
>>>  		goto error;
>>>  
>>>  	/* record handles to ourself */
>> I would prefer to fix it where the actual problem is located.
>> Can you send an updated version that changes the code to do
>>
>> ...
>> error:
>> if (ir)
>>   kfree(ir->i2c_client);
>> ...
>>
>> This makes the code less prone to future error handling changes.
> This kind of bug is called a "One Err Bug" because they are part of
> an anti-pattern of bad error handling where there is only one label.  It
> was ok at the time it was written but it was fragile and broke when the
> code changed.
>
> One Err Bugs are very common kind of bug.  I just reported a similar bug
> this morning.  https://lkml.org/lkml/2014/9/25/91  In that case we freed
> some sysfs files which were not allocated.
>
> My view is that error handling code should not have if statements unless
> there is an if statement in the allocation code.  This is way more
> readable.
>
> Another way that people deal with these kinds of errors if they don't
> like to return directly is they add an "out:" label.
>
> out:
> 	return ret;
>
> I hate "out" labels for how vague the name is but I also hate do-nothing
> gotos generally.  When you're reading the code you assume that the goto
> does something but the name gives you no clue what it does so you have
> to interrupt what you are doing and scroll down to the bottom of the
> function and it doesn't do anything.  It just returns.  By this point
> you have forgotten where you were but it was somewhere reading in the
> middle of the function.
Dan,
I 100% agree with everything you are saying here about lables, error
handling etc.
And your fix is of course 100% valid.

I would have a much better feeling if we add a NULL-pointer check before
the kfree, because it makes things more difficult to break in the future.
I've seen that happen too often.
Anyway, go ahead with your patch. No need to waste more time.

Acked-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Thanks for pointing this out, em28xx can't get enough attention.

Regards,
Frank


