Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36253 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbaIDB2D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 21:28:03 -0400
Message-ID: <5407C01D.5090400@iki.fi>
Date: Thu, 04 Sep 2014 04:27:57 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 32/46] [media] e4000: simplify boolean tests
References: <cover.1409775488.git.m.chehab@samsung.com> <86da9d3c8d8ced8d61c8c57b774da2e7f7a2a4ef.1409775488.git.m.chehab@samsung.com> <5407AAA3.1090607@iki.fi> <20140903221215.3843a9e9.m.chehab@samsung.com>
In-Reply-To: <20140903221215.3843a9e9.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/04/2014 04:12 AM, Mauro Carvalho Chehab wrote:
> Em Thu, 04 Sep 2014 02:56:19 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Which is static analyzer you are referring to fix these?
>
> Coccinelle. See: scripts/coccinelle/misc/boolinit.cocci
>
>> Using true/false for boolean datatype sounds OK, but personally I
>> dislike use of negation operator. For my eyes (foo = 0) / (foo == false)
>> is better and I have changed all the time negate operators to equal
>> operators from my drivers.
>
> The usage of the negation operator on such tests is there since
> the beginning of C.

ugh! :(

>
> By being shorter, a reviewer can read it faster and, at least for
> me, it is a non-brain to understand !foo. On the other hand,
> "false" is not part of standard C. So, it takes more time for my
> brain to parse it.

No, it just opposite for me and many others.

>
> Anyway, from my side, the real reasone for using it is not due to
> that. It is that I (and other Kernel developers) run from time to
> time static analyzers like smatch and coccinelle, in order to identify
> real errors. Having a less-polluted log helps to identify the newer
> errors/warnings.

Have you ever looked Documentation/CodingStyle ?
How about that example, from CodingStyle:
int fun(int a)
{
	int result = 0;
	char *buffer = kmalloc(SIZE);

	if (buffer == NULL)
		return -ENOMEM;

	if (condition1) {
		while (loop1) {
			...
		}
		result = 1;
		goto out;
	}
	...
out:
	kfree(buffer);
	return result;
}

As it shows, it is (buffer == NULL) *not* (!buffer). And if you like to 
do it differently then update CodingStyle first! Add clear mention that 
it should be (!buffer) and change given example to match your style. 
Otherwise, I am happy to do as CodingStyle shows!

Antti

>
> Regards,
> Mauro
>>
>> regards
>> Antti
>>
>> On 09/03/2014 11:33 PM, Mauro Carvalho Chehab wrote:
>>> Instead of using if (foo == false), just use
>>> if (!foo).
>>>
>>> That allows a faster mental parsing when analyzing the
>>> code.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>>>
>>> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
>>> index 90d93348f20c..cd9cf643f602 100644
>>> --- a/drivers/media/tuners/e4000.c
>>> +++ b/drivers/media/tuners/e4000.c
>>> @@ -400,7 +400,7 @@ static int e4000_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>>>    	struct e4000 *s = container_of(ctrl->handler, struct e4000, hdl);
>>>    	int ret;
>>>
>>> -	if (s->active == false)
>>> +	if (!s->active)
>>>    		return 0;
>>>
>>>    	switch (ctrl->id) {
>>> @@ -423,7 +423,7 @@ static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
>>>    	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>>>    	int ret;
>>>
>>> -	if (s->active == false)
>>> +	if (!s->active)
>>>    		return 0;
>>>
>>>    	switch (ctrl->id) {
>>>
>>

-- 
http://palosaari.fi/
