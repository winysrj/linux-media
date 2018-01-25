Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:41211 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbeAYRII (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 12:08:08 -0500
Received: by mail-wm0-f48.google.com with SMTP id f71so15949175wmf.0
        for <linux-media@vger.kernel.org>; Thu, 25 Jan 2018 09:08:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d76143d2-5c7d-87ca-3f2f-1a73778b400f@gmail.com>
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de> <d693cf1b-de3d-5994-5ef0-eeb0e37065a3@web.de>
 <20170827073040.6e96d79a@vento.lan> <e9d87f55-18fc-e57b-f9aa-a41c7f983b34@web.de>
 <20170909181123.392cfbb0@vento.lan> <a44b8eb0-cdd5-aa28-ad30-68db0126b6f6@web.de>
 <20170916125042.78c4abad@recife.lan> <fab215f8-29f3-1857-6f33-c45e78bb5e3c@web.de>
 <7c17c0a1-1c98-1272-8430-4a194b658872@gmail.com> <20171127092408.20de0fe0@vento.lan>
 <e2076533-5c33-f3be-b438-a1616f743a92@gmail.com> <20171202174922.34a6f9b9@vento.lan>
 <ce4f25e6-7d75-2391-d685-35b50a0639bb@web.de> <335e279e-d498-135f-8077-770c77cf353b@gmail.com>
 <5070ebf3-79a9-571e-d56c-cee41b51f191@gmail.com> <CAObVMRvxT_=LmO-mJNPRewQq05PqMHpD83m1UBoK+QiBSwqUNw@mail.gmail.com>
 <d76143d2-5c7d-87ca-3f2f-1a73778b400f@gmail.com>
From: Jemma Denson <jdenson@gmail.com>
Date: Thu, 25 Jan 2018 17:08:06 +0000
Message-ID: <CAObVMRtD0+qQzqo8Bp8k+9q=BuZcrFK0JAHYFBs3EO=iL+rW7A@mail.gmail.com>
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

On 20/01/18 15:49, Tycho L=C3=BCrsen wrote:
> Right, but we still need a maintainer. Are you capable/willing to
> volunteer for the job?

If no-one else will then yes I can, but I can't claim to know these devices
inside out. It would really depend on what's required of a maintainer, I'm
struggling to find this documented anywhere.

Cards I can't test with would really need someone to be able to add a
tested-by to verify they work.

>>
>>> I think that your proposal to use a stripped version of Luis Alves
>>> repo is a no go, since it contains a couple of demod/tuner drivers
>>> that are not upstreamed yet. That complicates the upstreaming process
>>> too much, I think.
>> Oh, I would have stripped it *right* down and removed every card except
>> my TBS6280. The end result would probably be pretty close to Soeren's at
>> that point anyway, so I was starting to think like what you've done and
>> base it on that instead.
> If you want, I can strip the driver down a lot more and ad back the
> drivers you need. Just tell me what it is you need.

As above, it's really just a case of making it maintainable. If someone
can step forward and ack for them working then they could be included
but if not then I think it's best dropping them until that happens.


Jemma.
