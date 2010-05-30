Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54949 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab0E3RhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 13:37:13 -0400
Received: by gwaa12 with SMTP id a12so2170985gwa.19
        for <linux-media@vger.kernel.org>; Sun, 30 May 2010 10:37:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C02826A.6010207@linuxtv.org>
References: <AANLkTinPCgrLPdtFgEDa76RnEG85GSLVJv0G6z56z3P1@mail.gmail.com>
	<1275198741.3213.50.camel@pc07.localdom.local>
	<AANLkTilIrG5cwlLv_iAI7E7XX5117qh4AHof80pRRYSs@mail.gmail.com>
	<AANLkTin97BxcUYCUvUt_UiXJUUKdbYNoAqFtqX1rf-EE@mail.gmail.com>
	<4C02826A.6010207@linuxtv.org>
Date: Sun, 30 May 2010 19:29:55 +0200
Message-ID: <AANLkTimRDtZiUxJLMI7ftx6e6Ouwe5bqZbElgAgtGgE-@mail.gmail.com>
Subject: Re: What ever happened to standardizing signal level?
From: Markus Rechberger <mrechberger@gmail.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 30, 2010 at 5:21 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> Markus Rechberger wrote:
>>
>> Hi,
>>
>> A little bit more "ontopic", did anyone get around to read the
>> signallevel of the tda18721?
>> I wonder the register does not return any signallevel as indicated in
>> the specifications.
>>
>> Markus
>
> There is a "power level" value that can be read from the tda18271 -- I had a
> patch that enabled reading of this value, for testing purposes, but it
> wasn't as useful as I had hoped, so I never bothered to merge it.
>
> If you'd like to play with it, I pushed up some code last year:
>
> http://kernellabs.com/hg/~mkrufky/tda18271-pl/rev/4373874cff29
>
> Let me know how this works for you, or if you choose to change it.  I If you
> find it valuable, we can merge it in somehow.
>

hmm.. I somewhat tried the same but the register kept flipping back
and the powerlevel register returned 0.

Markus
