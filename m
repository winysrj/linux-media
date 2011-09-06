Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab1IFSkw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 14:40:52 -0400
Message-ID: <4E666930.1050605@redhat.com>
Date: Tue, 06 Sep 2011 15:40:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 01/10] alsa_stream: port changes made on xawtv3
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com> <4E663EE2.3050403@redhat.com> <CAGoCfiz9YAHYNJdEAT51fyfLY8RS_TcRpzKzLYCdNFCc3JcbEA@mail.gmail.com>
In-Reply-To: <CAGoCfiz9YAHYNJdEAT51fyfLY8RS_TcRpzKzLYCdNFCc3JcbEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-09-2011 13:24, Devin Heitmueller escreveu:
> On Tue, Sep 6, 2011 at 11:40 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com>  wrote:
>> Hi Devin,
>>
>> Em 06-09-2011 12:29, Mauro Carvalho Chehab escreveu:
>>> There are several issues with the original alsa_stream code that got
>>> fixed on xawtv3, made by me and by Hans de Goede. Basically, the
>>> code were re-written, in order to follow the alsa best practises.
>>>
>>> Backport the changes from xawtv, in order to make it to work on a
>>> wider range of V4L and sound adapters.
>>
>> FYI, just flooded your mailbox with 10 patches for tvtime. ;)
>>
>> I'm wanting to test some things with tvtime on one of my testboxes, but some
>> of my cards weren't working with the alsa streaming, due to a few bugs that
>> were solved on xawtv fork.
>>
>> So, I decided to backport it to tvtime and recompile the Fedora package for it.
>> That's where the other 9 patches come ;)
>>
>> Basically, after applying this series of 10 patches, we can just remove all
>> patches from Fedora, making life easier for distro maintainers (as the same
>> thing is probably true on other distros - at least one of the Fedora patches
>> came from Debian, from the fedora git logs).
>>
>> One important thing for distros is to have a tarball with the latest version
>> hosted on a public site, so I've increased the version to 1.0.3 and I'm
>> thinking on storing a copy of it at linuxtv, just like we do with xawtv3.
>>
>> If you prefer, all patches are also on my tvtime git tree, at:
>>         http://git.linuxtv.org/mchehab/tvtime.git
>>
>> Thanks,
>> Mauro
> 
> Hi Mauro,
> 
> Funny you should send these along today.  Last Friday I was actually
> poking around at the Fedora tvtime repo because I was curious how they
> had dealt with the V4L1 support issue (whether they were using my
> patch removing v4l1 or some variant).

Well, right time then ;)
> 
> I've actually pulled in Fedora patches in the past (as you can see
> from the hg repo),

Yes, I saw it. Nice work!

> and it has always been my intention to do it for
> the other distros as well (e.g. debian/Ubuntu).  So I appreciate your
> having sent these along.

It is a good idea to take a look at them. I looked into their repositories
for the xawtv patches and I found some good stuff there.

> I'll pull these in this week, do some testing to make sure nothing
> serious got broken, and work to spin a 1.0.3 toward the end of the
> week.

Great!
> Given the number of features/changes, and how long it's been
> since the last formal release, I was considering calling it 1.1.0
> instead though.

Seems fine for me.

> I've been thinking for a while that perhaps the project should be
> renamed (or I considered prepending "kl" onto the front resulting in
> it being called "kl-tvtime").  This isn't out of vanity but rather my
> concern that the fork will get confused with the original project (for
> example, I believe Ubuntu actually already calls their modified tree
> tvtime 1.0.3).  I'm open to suggestions in this regards.

IMO, I won't rename it. It is a well-known tool, and it is not a new
version, but somebody's else took over its maintainership. I think
you should touch the readme files in order to point to kl.com and to
the places where the tree will be stored.

Em 06-09-2011 15:19, Hans de Goede escreveu:
> Hi,
<snip>
> I think that what should be done is contact the debian / ubuntu maintainers,
> get any interesting fixes they have which the kl version misses merged,
> and then just declare the kl version as being the new official upstream
> (with the blessing of the debian / ubuntu guys, and if possible also
> with the blessing of the original authors).

Agree. I think Devin already tried to contact vektor about that.

> This would require kl git to be open to others for pushing, or we
> could move the tree to git.linuxtv.org (which I assume may be
> easier then for you to make the necessary changes to give
> others push rights on kl.org).

I like this idea too. From my side, it proved to be very useful to be
able to write on both Fedora and upstream repositories on xawtv3. 

I've made already the Fedora changes for tvtime 1.0.3 (in order to test
it on my test boxes), so being able of adding a new release at both
repos at the same time is a good idea.

Thanks,
Mauro
