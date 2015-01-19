Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:43002 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529AbbASNhm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 08:37:42 -0500
Message-ID: <54BD0890.8040606@xs4all.nl>
Date: Mon, 19 Jan 2015 14:37:20 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 01/22] si2168: define symbol rate limits
References: <1417901696-5517-1-git-send-email-crope@iki.fi> <54BD0573.3020207@xs4all.nl> <54BD06EC.4090209@iki.fi>
In-Reply-To: <54BD06EC.4090209@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/19/2015 02:30 PM, Antti Palosaari wrote:
> Moikka!
> 
> On 01/19/2015 03:24 PM, Hans Verkuil wrote:
>> On 12/06/2014 10:34 PM, Antti Palosaari wrote:
>>> w_scan complains about missing symbol rate limits:
>>> This dvb driver is *buggy*: the symbol rate limits are undefined - please report to linuxtv.org
>>>
>>> Chip supports 1 to 7.2 MSymbol/s on DVB-C.
>>>
>>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>>
>> Antti,
>>
>> Are you planning to make a pull request of this patch series?
>>
>> It looks good to me, so for this patch series:
>>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> BTW, please add a cover letter whenever you post a patch series (git send-email --compose).
>> It makes it easier to get an overview of what the patch series is all about.
> 
> PULL request is here:
> https://patchwork.linuxtv.org/patch/27416/
> 
> I could send new one if needed, there is missing branch name (new Git 
> version has started blaming it).

It's probably wise to do that (and rebase at the same time).

> 
> Are you applying these pull request now? I was expecting Mauro...

I'm cleaning up patchwork, and your (very long) patch series were making it
hard to work with patchwork.

Regards,

	Hans

> 
> regards
> Antti
> 

