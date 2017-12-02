Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35342 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbdLBSvU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Dec 2017 13:51:20 -0500
Received: by mail-wm0-f43.google.com with SMTP id f9so8237369wmh.0
        for <linux-media@vger.kernel.org>; Sat, 02 Dec 2017 10:51:20 -0800 (PST)
Subject: Re: [GIT PULL] SAA716x DVB driver
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?UTF-8?Q?Tycho_L=c3=bcrsen?= <tycholursen@gmail.com>
Cc: Soeren Moch <smoch@web.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
 <d693cf1b-de3d-5994-5ef0-eeb0e37065a3@web.de>
 <20170827073040.6e96d79a@vento.lan>
 <e9d87f55-18fc-e57b-f9aa-a41c7f983b34@web.de>
 <20170909181123.392cfbb0@vento.lan>
 <a44b8eb0-cdd5-aa28-ad30-68db0126b6f6@web.de>
 <20170916125042.78c4abad@recife.lan>
 <fab215f8-29f3-1857-6f33-c45e78bb5e3c@web.de>
 <7c17c0a1-1c98-1272-8430-4a194b658872@gmail.com>
 <20171127092408.20de0fe0@vento.lan>
From: Jemma Denson <jdenson@gmail.com>
Message-ID: <e2076533-5c33-f3be-b438-a1616f743a92@gmail.com>
Date: Sat, 2 Dec 2017 18:51:16 +0000
MIME-Version: 1.0
In-Reply-To: <20171127092408.20de0fe0@vento.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 27/11/17 11:24, Mauro Carvalho Chehab wrote:
> Em Fri, 24 Nov 2017 17:28:37 +0100
> Tycho Lürsen <tycholursen@gmail.com> escreveu:
>
>> Hi Mauro,
>>
>> afaik the last communication about submission of this driver was about
>> two months ago.
>>
>> This driver is important to me, because I own several TurboSight cards
>> that are saa716x based. I want to submit a patch that supports my cards.
>> Of course I can only do so when you accept this driver in the first place.
>>
>> Any chance you and Sören agree about how to proceed about this driver
>> anytime soon?
> If we can reach an agreement about what should be done for the driver
> to be promoted from staging some day, I'll merge it. Otherwise,
> it can be kept maintained out of tree. This driver has been maintained
> OOT for a very long time, and it seems that people were happy with
> that, as only at the second half of this year someone is requesting
> to merge it.
>
> So, while I agree that the best is to merge it upstream and
> address the issues that made it OOT for a long time, we shouldn't
> rush it with the risk of doing more harm than good.
>
> Thanks,
> Mauro

Would I be correct in thinking the main blocker to this is the *_ff features
used by the S2-6400 card? There's plenty of other cards using this chipset
that don't need that part.

Would a solution for now to be a driver with the ff components stripped out,
and then the ff API work can be done later when / if there's any interest?

I guess a problem would be finding a maintainer, I'm happy to put together
a stripped down driver just supporting the TBS card I use (I already have
one I use with dkms), but I'm not sure I have the time or knowledge of this
chipset to be a maintainer. Unfortunately my workplace is phasing out
these cards otherwise I'd try and get them to sponsor me rather than do it
on my own time!


Jemma.
