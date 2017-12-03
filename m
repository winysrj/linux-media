Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:45453 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751856AbdLCK5W (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Dec 2017 05:57:22 -0500
Received: by mail-wr0-f171.google.com with SMTP id h1so14244902wre.12
        for <linux-media@vger.kernel.org>; Sun, 03 Dec 2017 02:57:21 -0800 (PST)
Subject: Re: [GIT PULL] SAA716x DVB driver
To: Soeren Moch <smoch@web.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: =?UTF-8?Q?Tycho_L=c3=bcrsen?= <tycholursen@gmail.com>,
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
 <e2076533-5c33-f3be-b438-a1616f743a92@gmail.com>
 <20171202174922.34a6f9b9@vento.lan>
 <ce4f25e6-7d75-2391-d685-35b50a0639bb@web.de>
From: Jemma Denson <jdenson@gmail.com>
Message-ID: <335e279e-d498-135f-8077-770c77cf353b@gmail.com>
Date: Sun, 3 Dec 2017 10:57:19 +0000
MIME-Version: 1.0
In-Reply-To: <ce4f25e6-7d75-2391-d685-35b50a0639bb@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/17 23:59, Soeren Moch wrote:
> On 02.12.2017 20:49, Mauro Carvalho Chehab wrote:
>> Em Sat, 2 Dec 2017 18:51:16 +0000
>> Jemma Denson <jdenson@gmail.com> escreveu:
>>> Would I be correct in thinking the main blocker to this is the *_ff features
>>> used by the S2-6400 card? There's plenty of other cards using this chipset
>>> that don't need that part.
>>>
>>> Would a solution for now to be a driver with the ff components stripped out,
>>> and then the ff API work can be done later when / if there's any interest?
>> Works for me. In such case (and provided that the driver without *_ff are
>> in good shape), we could merge it under drivers/media (instead of merging
>> it on staging).
> All the entries in the TODO file are not specific for saa716x_ff.

Ah, it's been a few months since I looked at that. I think some of the
things listed I had already identified as problems - checkpatch especially,
and the irq code probably needs a bit more auto-detection.
I'm not sure I've seen how the other issues manifest themselves so I
might need some explanation of that (off list if you prefer)

>>> I guess a problem would be finding a maintainer, I'm happy to put together
>>> a stripped down driver just supporting the TBS card I use (I already have
>>> one I use with dkms), but I'm not sure I have the time or knowledge of this
>>> chipset to be a maintainer.
> There is chipset specific stuff to fix, especially irq handling.

Is this the module parameter kludges or something else?

>> As we're talking more about touching at uAPI, probably it doesn't require
>> chipsed knowledge. Only time and interest on doing it.
>>
>> Please sync with Soeren. Perhaps if you both could help on it, it would
>> make the task easier.
> As I already wrote to different people off-list: I'm happy to support
> more cards with the saa7160 bridge and maintain these in this driver. As
> hobbyist programmer this of course makes no sense to me, if the hardware
> I own (S2-6400) is not supported.
>

Hence my comment about finding a maintainer - I had assumed if the
immediate result didn't support your card you probably wouldn't be willing
to do that.

What I'm trying to do here is get *something* merged, and then once
that work is done any interested parties can add to it. Or at the very
least if some patches are left OOT the constant workload required to
keep that up to date should be reduced significantly because they'll be
far less to look after.

One of the problems though is choosing which fork to use. I *think* there
are 2 - the one you've got which is the original powARman branch and the
one I would be using is the CrazyCat / Luis /  TBS line. There are going 
to be
some differences but hopefully that's all frontend support based and one cut
down to a single frontend would end up a good base to add the rest back
in.

I'm looking at maybe finding time over christmas break.


Jemma
