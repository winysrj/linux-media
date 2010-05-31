Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:3054 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab0EaDCe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 23:02:34 -0400
Message-ID: <4C0326C6.7020800@linuxtv.org>
Date: Sun, 30 May 2010 23:02:30 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: What ever happened to standardizing signal level?
References: <AANLkTinPCgrLPdtFgEDa76RnEG85GSLVJv0G6z56z3P1@mail.gmail.com>	<1275198741.3213.50.camel@pc07.localdom.local>	<AANLkTilIrG5cwlLv_iAI7E7XX5117qh4AHof80pRRYSs@mail.gmail.com>	<AANLkTin97BxcUYCUvUt_UiXJUUKdbYNoAqFtqX1rf-EE@mail.gmail.com>	<4C02826A.6010207@linuxtv.org> <AANLkTimRDtZiUxJLMI7ftx6e6Ouwe5bqZbElgAgtGgE-@mail.gmail.com>
In-Reply-To: <AANLkTimRDtZiUxJLMI7ftx6e6Ouwe5bqZbElgAgtGgE-@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Markus Rechberger wrote:
> On Sun, May 30, 2010 at 5:21 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>> Markus Rechberger wrote:
>>> Hi,
>>>
>>> A little bit more "ontopic", did anyone get around to read the
>>> signallevel of the tda18721?
>>> I wonder the register does not return any signallevel as indicated in
>>> the specifications.
>>>
>>> Markus
>> There is a "power level" value that can be read from the tda18271 -- I had a
>> patch that enabled reading of this value, for testing purposes, but it
>> wasn't as useful as I had hoped, so I never bothered to merge it.
>>
>> If you'd like to play with it, I pushed up some code last year:
>>
>> http://kernellabs.com/hg/~mkrufky/tda18271-pl/rev/4373874cff29
>>
>> Let me know how this works for you, or if you choose to change it.  I If you
>> find it valuable, we can merge it in somehow.
>>
> 
> hmm.. I somewhat tried the same but the register kept flipping back
> and the powerlevel register returned 0.
> 
> Markus

...I think it only works on the c2 rev silicon.  Not sure about that, 
though.

-Mike

