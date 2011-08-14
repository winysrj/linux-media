Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56307 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab1HNPuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 11:50:19 -0400
Received: by bke11 with SMTP id 11so2554724bke.19
        for <linux-media@vger.kernel.org>; Sun, 14 Aug 2011 08:50:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313226504.2840.22.camel@gagarin>
References: <CAC3jWv+c1HOqmo0B18Z3vWOwjr=RoPrN7sfR3bqzz4Tw7=fPAQ@mail.gmail.com>
	<1313226504.2840.22.camel@gagarin>
Date: Sun, 14 Aug 2011 17:50:16 +0200
Message-ID: <CAC3jWvLszU4gTSVW0mXUFrhnHCpPWRUqErytF9jXs39sbCJd3Q@mail.gmail.com>
Subject: Re: [mythtv-users] Anyone tested the DVB-T2 dual tuner TBS6280?
From: Harald Gustafsson <hgu1972@gmail.com>
To: Discussion about MythTV <mythtv-users@mythtv.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for sharing your experience.

On Sat, Aug 13, 2011 at 11:08 AM, Lawrence Rust <lvr@softsystem.co.uk> wrote:
> The stock v4l sources supplied are old (from around 2.6.35) and don't
> contain many current fixes.  This isn't a problem per-se unless you
> intend to use the card with another v4l card.  In this case your brand
> new, bug fixed drivers are replaced by TBS's version which may or, as in
> my case, may not work.
I have 2 other older cards that I intend to use it with, but currently
I'm using Ubuntu 10.04 LTS which have a 2.6.32 kernel, so this would
not be a problem, but later when I upgrade to 12.04 LTS and a newer
kernel this will be problematic. Since I can't trust that TBS will
deliver newer drivers.

> I repeatedly mailed TBS support at support@tbsdtv.com to ask how I could
> only install the 6981 driver but never got an answer.  In desperation I
> setup a git tree of 2.6.35 and merged it with the TBS drivers in order
> to separate their changes.  Finally after many hours I have a set of
> patches that I can apply to 2.6.39 that produce a working driver.
Is it possible to mix modules based on different versions of v4l? To
me that looks like it will work as long as the core infrastructure is
the same, but as soon as some common data structure that is used by
the obj files is changed it will break and you might not notice
directly. Just as you say with the IR changes, but also more subtle
changes by adding/removing elements in structures.

> Be warned that if you run a 2.6.38 or later kernel then the IR RC won't
> work because of significant changes to the RC architecture that TBS
> don't like (see http://www.tbsdtv.com/forum/viewtopic.php?f=22&t=929 and
> http://www.tbsdtv.com/forum/viewtopic.php?f=22&t=110&start=90#p2693 )

In the links you refer to the driver author (at least he seems to be
the author) states that he has not upgraded to the latest IR code due
to compatibility issues between the CX23885 and IR.

/Harald
