Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55906 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1IFQYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 12:24:53 -0400
Received: by bke11 with SMTP id 11so5562185bke.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 09:24:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E663EE2.3050403@redhat.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
	<4E663EE2.3050403@redhat.com>
Date: Tue, 6 Sep 2011 12:24:52 -0400
Message-ID: <CAGoCfiz9YAHYNJdEAT51fyfLY8RS_TcRpzKzLYCdNFCc3JcbEA@mail.gmail.com>
Subject: Re: [PATCH 01/10] alsa_stream: port changes made on xawtv3
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 6, 2011 at 11:40 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi Devin,
>
> Em 06-09-2011 12:29, Mauro Carvalho Chehab escreveu:
>> There are several issues with the original alsa_stream code that got
>> fixed on xawtv3, made by me and by Hans de Goede. Basically, the
>> code were re-written, in order to follow the alsa best practises.
>>
>> Backport the changes from xawtv, in order to make it to work on a
>> wider range of V4L and sound adapters.
>
> FYI, just flooded your mailbox with 10 patches for tvtime. ;)
>
> I'm wanting to test some things with tvtime on one of my testboxes, but some
> of my cards weren't working with the alsa streaming, due to a few bugs that
> were solved on xawtv fork.
>
> So, I decided to backport it to tvtime and recompile the Fedora package for it.
> That's where the other 9 patches come ;)
>
> Basically, after applying this series of 10 patches, we can just remove all
> patches from Fedora, making life easier for distro maintainers (as the same
> thing is probably true on other distros - at least one of the Fedora patches
> came from Debian, from the fedora git logs).
>
> One important thing for distros is to have a tarball with the latest version
> hosted on a public site, so I've increased the version to 1.0.3 and I'm
> thinking on storing a copy of it at linuxtv, just like we do with xawtv3.
>
> If you prefer, all patches are also on my tvtime git tree, at:
>        http://git.linuxtv.org/mchehab/tvtime.git
>
> Thanks,
> Mauro

Hi Mauro,

Funny you should send these along today.  Last Friday I was actually
poking around at the Fedora tvtime repo because I was curious how they
had dealt with the V4L1 support issue (whether they were using my
patch removing v4l1 or some variant).

I've actually pulled in Fedora patches in the past (as you can see
from the hg repo), and it has always been my intention to do it for
the other distros as well (e.g. debian/Ubuntu).  So I appreciate your
having sent these along.

I'll pull these in this week, do some testing to make sure nothing
serious got broken, and work to spin a 1.0.3 toward the end of the
week.  Given the number of features/changes, and how long it's been
since the last formal release, I was considering calling it 1.1.0
instead though.

I've been thinking for a while that perhaps the project should be
renamed (or I considered prepending "kl" onto the front resulting in
it being called "kl-tvtime").  This isn't out of vanity but rather my
concern that the fork will get confused with the original project (for
example, I believe Ubuntu actually already calls their modified tree
tvtime 1.0.3).  I'm open to suggestions in this regards.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
