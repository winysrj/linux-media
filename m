Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:48755 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbbFWUpn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 16:45:43 -0400
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v3 1/7] rc: rc-ir-raw: Add scancode encoder callback
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Tue, 23 Jun 2015 22:45:42 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: =?UTF-8?Q?Antti_Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	linux-media@vger.kernel.org, James Hogan <james@albanarts.com>
In-Reply-To: <20150618182305.577ba0df@recife.lan>
References: <20150519203851.GC18036@hardeman.nu>
 <CAKv9HNb=qK18mGj9dOdyqEPvABU8b8aAEmGa1s2NULC4g0KX-Q@mail.gmail.com>
 <20150520182901.GB13624@hardeman.nu>
 <CAKv9HNZdsse=ETkKpZWPN8Z+kLA_aNxpvEtr_WFGp5ZpaZ36dg@mail.gmail.com>
 <20150520204557.GB15223@hardeman.nu>
 <CAKv9HNZEQJkCE3b0OcOGg_o59aYiTwLhQ0f=ji1obcJcG7ePwA@mail.gmail.com>
 <32cae92aa099067315d1a13c7302957f@hardeman.nu>
 <CAKv9HNZ_JjCutG-V+77vu2xMEihbRrYJSr4QR+LESSdrM71+yQ@mail.gmail.com>
 <db6f383689a45d2d9b5346c41e48d535@hardeman.nu>
 <CAKv9HNY5jM-i5i420iu_kcfS2ZsnnMjdED59fxkxH5e5mjYe=Q@mail.gmail.com>
 <20150521194034.GB19532@hardeman.nu>
 <CAKv9HNbsCK_1XbYMgO3Monui9JnHc7knJL3yon9FUMJ_MCLppg@mail.gmail.com>
 <5418c2397b8a8dab54bfbcfe9ed3df1d@hardeman.nu>
 <CAKv9HNbGAta3BDSk=xjsviUuqMP7TBGtf4PhdfNn8B7N-Gz_dg@mail.gmail.com>
 <3b967113dc16d6edc8d8dd7df9be8b80@hardeman.nu>
 <20150618182305.577ba0df@recife.lan>
Message-ID: <e50840af0dbb6e43148ae999a9c60da5@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-06-18 23:23, Mauro Carvalho Chehab wrote:
> Em Sun, 14 Jun 2015 01:44:54 +0200
> David Härdeman <david@hardeman.nu> escreveu:
>> If you've followed the development of rc-core during the last few 
>> years
>> it should be pretty clear that Mauro has little to no long-term plan,
>> understanding of the current issues or willingness to fix them. I
>> wouldn't read too much into the fact that the code was merged.
> 
> You completely missed the point.

Of course...

> Adding new drivers and new features
> don't require much time to review, and don't require testing.

But a focus on adding new "features" (some of which further cement bad 
API) is dangerous when the foundations still need work.

> What you're trying to send as "fixes" is actually series of patches 
> that
> change the behavior of the subsystem, with would cause regressions.

Some things can't be fixed without changing some behavior...assuming 
you're not talking about the patches that add a rc-core chardev...that 
is indeed a whole new direction and I can completely take onboard that 
you'd like to see a better RFC discussion with a document describing the 
interface, changes, rationale, etc....and I'd be happy to produce a 
document like that when I have the time (I'm guessing the LinuxTV wiki 
might be a good place).

I have a total of six patches in my queue that are not related to the 
rc-core chardev:

One fixes a uevent bug and should be trivial
One converts rc-core to use an IDA, a cleanup which seems to fix a race 
as well
One removes lirc as a "protocol" and is not an API change as you thought
One prepares the lmedm04 driver for the next two patches
The last two adds protocol info to the EVIOC[GS]KEYCODE_V2 ioctl

The last two patches need the most careful scrutiny, but they are an 
attempt to finally fix a serious issue. I've already indicated that they 
are not 100% backwards compatible, but the corner cases they won't catch 
(can't catch) are pretty extreme. I'd be happy to discuss them further 
if you'd like.

I have no plans to move on to the rc-core chardev discussion before the 
above patches have been dealt with. I don't think it's a good use of 
anyone's time.

> Btw, a lot of the pull requests you've sent over the past years did 
> cause
> regressions.

Yes, trying to change/fix parts of the foundation of the rc-core code 
definitely carries a larger risk of regressions (especially when I don't 
even have the hardware). That's not a good reason to not try though.

> So, I can only review/apply them when I have a bunch of
> spare time to test them. As I don't usually have a bunch of spare time,
> nor we have a sub-maintainer for remote controllers that would have
> time for such tests, they're delayed.

I think we're getting off-topic.

>> Mauro....wake up? I hope you're not planning to push the current code
>> upstream???
> 
> What's there are planned to be sent upstream. If you think that 
> something
> is not mature enough to be applied, please send a patch reverting it,
> with "[PATCH FIXES]" in the subject, clearly explaining why it should 
> be
> reverted for me to analyze. Having Antti/James acks on that would help.

This thread should already provide you with all the information you need 
why the patches should be reverted (including Antii saying the patches 
should be reverted).

The current code includes hilarious "features" like producing different 
results depending on module load order and makes sure we'll be stuck 
with a bad API. Sending them upstream will look quite foolish...

Regards,
David

