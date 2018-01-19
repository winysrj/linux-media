Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:40060 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755200AbeASPLN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 10:11:13 -0500
Received: by mail-wm0-f46.google.com with SMTP id v123so4181952wmd.5
        for <linux-media@vger.kernel.org>; Fri, 19 Jan 2018 07:11:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5070ebf3-79a9-571e-d56c-cee41b51f191@gmail.com>
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de> <d693cf1b-de3d-5994-5ef0-eeb0e37065a3@web.de>
 <20170827073040.6e96d79a@vento.lan> <e9d87f55-18fc-e57b-f9aa-a41c7f983b34@web.de>
 <20170909181123.392cfbb0@vento.lan> <a44b8eb0-cdd5-aa28-ad30-68db0126b6f6@web.de>
 <20170916125042.78c4abad@recife.lan> <fab215f8-29f3-1857-6f33-c45e78bb5e3c@web.de>
 <7c17c0a1-1c98-1272-8430-4a194b658872@gmail.com> <20171127092408.20de0fe0@vento.lan>
 <e2076533-5c33-f3be-b438-a1616f743a92@gmail.com> <20171202174922.34a6f9b9@vento.lan>
 <ce4f25e6-7d75-2391-d685-35b50a0639bb@web.de> <335e279e-d498-135f-8077-770c77cf353b@gmail.com>
 <5070ebf3-79a9-571e-d56c-cee41b51f191@gmail.com>
From: Jemma Denson <jdenson@gmail.com>
Date: Fri, 19 Jan 2018 15:11:11 +0000
Message-ID: <CAObVMRvxT_=LmO-mJNPRewQq05PqMHpD83m1UBoK+QiBSwqUNw@mail.gmail.com>
Subject: Re: SAA716x DVB driver
To: =?UTF-8?Q?Tycho_L=C3=BCrsen?= <tycholursen@gmail.com>,
        Soeren Moch <smoch@web.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Luis Alves <ljalvs@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tycho,

On 19/01/18 13:59, Tycho L=C3=BCrsen wrote:
> Hi Jemma,
>
> I'm with you: let's get merged at least something!
>
> Did you find  a maintainer for this driver?
> I can do simple stuff like in my fork of Soeren Moch's repo, but thats
> where it ends. I dont have the knowledge needed to maintain a driver.

Not yet, but I can't really say I've been looking - unfortunately real
life got in the way of anything over christmas. I'm not sure I do
either, but it really depends on what's required. From what I can see
from maintaining another driver then as long as the driver is working
there's not a whole lot to do.

>
> I think that your proposal to use a stripped version of Luis Alves
> repo is a no go, since it contains a couple of demod/tuner drivers
> that are not upstreamed yet. That complicates the upstreaming process
> too much, I think.

Oh, I would have stripped it *right* down and removed every card except
my TBS6280. The end result would probably be pretty close to Soeren's at
that point anyway, so I was starting to think like what you've done and
base it on that instead.

> I used a stripped version of Soeren Moch's repo to prove its stability
> instead, adding the drivers I need so I can test it. You can see what
> I did at :
> https://github.com/bas-t/linux-saa716x/commits/for-media-stripped
>
> This has been tested with linux 4.9.77, 4.14.14 and 4.15-rc8.
> Works like a charm for me.
>

Looks like a good start, I'd be tempted to remove all the other cards
though unless you have them available to test with. Keeps the submission
simpler and less to worry about, they can be added back in later if
someone has an itch to scratch (and hardware to test with!).

I do have a few other tbs 716x cards available here at work so might be
able to test some others out, but we're a bit busy at the moment so
would have to be on my own time and there's not much of that available
at the moment either :(


Jemma.
