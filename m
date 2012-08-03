Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38721 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab2HCS0d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 14:26:33 -0400
Received: by yhmm54 with SMTP id m54so1172237yhm.19
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 11:26:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+UdxdawZMeniA-tia3qKARbX_+u2k8PnbhA_FhDKUMv3Q@mail.gmail.com>
References: <1344016352-20302-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+UdxdawZMeniA-tia3qKARbX_+u2k8PnbhA_FhDKUMv3Q@mail.gmail.com>
Date: Fri, 3 Aug 2012 14:26:32 -0400
Message-ID: <CAGoCfiyaO5xhjUCVW5QfeLDoh=a6WE73aiAOXX5ZkOiM=efOfQ@mail.gmail.com>
Subject: Re: [PATCH] em28xx: Fix height setting on non-progressive captures
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 3, 2012 at 2:11 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> On Fri, Aug 3, 2012 at 2:52 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> This was introduced on commit c2a6b54a9:
>> "em28xx: fix: don't do image interlacing on webcams"
>> It is a known bug that has already been reported several times
>> and confirmed by Mauro.
>> Tested by compilation only.
>>
>
> I wonder if it's possible to get an Ack or a Tested-By from any of the
> em28xx owners?

This shouldn't be accepted upstream without testing at least on x86.
I did make such a change to make it work in my ARM tree, but I don't
fully understand the nature of the change and I'm not completely
confident it's correct for x86 (based on my reading of the datasheet
and how the accumulator field is structured in the em28xx chip).
Also, I actually don't have any progressive devices (I've got probably
a dozen em28xx devices, but they are all interlaced capture), which
made me particularly hesitant to submit this patch.

> Also, Devin: you mentioned in an old mail [1] you had some patches for em28xx,
> but you had no time to put them into shape for submission.
>
> If you want to, send then to me (or the full em28xx tree) and I can
> try to submit
> the patches.

Yeah, probably not a bad idea.  I've been sitting on the tree because
they haven't been tested on any other platforms and some of them are
not necessarily generally suitable for the mainline kernel.  And of
course the tree needs to be parsed out into an actual patch series,
and each patch has to be individually validated across multiple
devices to ensure they don't cause breakage (they were tested on an
em2863, but I have no idea if they cause problems on other chips such
as the em2820 or em2880).

All that said, I'm not really sure what the benefit would be in
sending you the tree if you don't actually have any hardware to test
with.  The last thing we need is more crap being sent upstream that is
"compile tested only" since that's where many of the regressions come
from (well meaning people sending completely untested 'cleanup
patches' can cause more harm than good).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
