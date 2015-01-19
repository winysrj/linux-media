Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44010 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbbASNaX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 08:30:23 -0500
Message-ID: <54BD06EC.4090209@iki.fi>
Date: Mon, 19 Jan 2015 15:30:20 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH 01/22] si2168: define symbol rate limits
References: <1417901696-5517-1-git-send-email-crope@iki.fi> <54BD0573.3020207@xs4all.nl>
In-Reply-To: <54BD0573.3020207@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 01/19/2015 03:24 PM, Hans Verkuil wrote:
> On 12/06/2014 10:34 PM, Antti Palosaari wrote:
>> w_scan complains about missing symbol rate limits:
>> This dvb driver is *buggy*: the symbol rate limits are undefined - please report to linuxtv.org
>>
>> Chip supports 1 to 7.2 MSymbol/s on DVB-C.
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>
> Antti,
>
> Are you planning to make a pull request of this patch series?
>
> It looks good to me, so for this patch series:
>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> BTW, please add a cover letter whenever you post a patch series (git send-email --compose).
> It makes it easier to get an overview of what the patch series is all about.

PULL request is here:
https://patchwork.linuxtv.org/patch/27416/

I could send new one if needed, there is missing branch name (new Git 
version has started blaming it).

Are you applying these pull request now? I was expecting Mauro...

regards
Antti

-- 
http://palosaari.fi/
