Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:43854 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbbASNPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 08:15:47 -0500
Message-ID: <54BD036D.8020701@xs4all.nl>
Date: Mon, 19 Jan 2015 14:15:25 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>,
	Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] mn88472: make sure the private data struct is nulled
 after free
References: <1417825533-13081-1-git-send-email-benjamin@southpole.se> <1417825533-13081-2-git-send-email-benjamin@southpole.se> <54832EE7.10705@iki.fi> <54834628.50702@southpole.se> <54834CD7.1060709@iki.fi> <54836680.9010404@southpole.se>
In-Reply-To: <54836680.9010404@southpole.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/2014 09:26 PM, Benjamin Larsson wrote:
> On 12/06/2014 07:37 PM, Antti Palosaari wrote:
>>>
>>> I do think it is good practice to set pointers to null generally as that
>>> would have saved me several days of work of whentracking down this bug.
>>> The current dvb framework contain several other cases where pointers are
>>> feed'd but not nulled.
>>
>> There is kzfree() for that, but still I am very unsure should we start 
>> zeroing memory upon release driver has allocated, or just relase it 
>> using kfree.
>>
>> regards
>> Antti 
> 
> Well I guess I am biased as I have spent lots of time finding a bug that 
> probably wouldn't exist if the policy was that drivers always should set 
> their memory to zero before it is free'd.

Just because you zero memory before it is freed doesn't mean it stays zeroed.
As soon as it is freed some other process might take that memory and fill it
up again. So zeroing is pointless and in fact will only *hide* bugs.

The only reason I know of for zeroing memory before freeing is if that memory
contains sensitive information and you want to make sure it is gone from memory.

You can turn on the kmemcheck kernel option when compiling the kernel to test
for accesses to uninitialized memory if you suspect you have a bug in that
area.

Anyway:

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> Maybe we should have a compile 
> time override so that all free calls zeroes the memory before the actual 
> free? Maybe there already is this kind of feature?
> 
> MvH
> Benjamin Larsson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

