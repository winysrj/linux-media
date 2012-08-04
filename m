Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:51517 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752220Ab2HDIyH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Aug 2012 04:54:07 -0400
Message-ID: <1344070424.32527.7.camel@tbastian-desktop.localdomain>
Subject: Re: [PATCH] em28xx: Fix height setting on non-progressive captures
From: "llarevo@gmx.net" <llarevo@gmx.net>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Sat, 04 Aug 2012 10:53:44 +0200
In-Reply-To: <CALF0-+XR6Utov445E54Uu++ETc6QrivMK-ZR0TfVLpNAtRbVgQ@mail.gmail.com>
References: <1344016352-20302-1-git-send-email-elezegarcia@gmail.com>
	 <CALF0-+UdxdawZMeniA-tia3qKARbX_+u2k8PnbhA_FhDKUMv3Q@mail.gmail.com>
	 <CAGoCfiyaO5xhjUCVW5QfeLDoh=a6WE73aiAOXX5ZkOiM=efOfQ@mail.gmail.com>
	 <CALF0-+Vhng3=GUJs5k9fiktkE6mEtDNEzKfP8+zjTSmCCRez8w@mail.gmail.com>
	 <CAGoCfizFYYtA2HHE6TO9eW6UF6FaxOhOyrsu6gCRi5kCGCO4zA@mail.gmail.com>
	 <CALF0-+XR6Utov445E54Uu++ETc6QrivMK-ZR0TfVLpNAtRbVgQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> >> Wait a minute, unless I completely misunderstood the bug (which is possible),
> >> I think this patch is straightforward.
> >>
> >> By the look of this hunk on commit c2a6b54a:
> >>
> >> ---------------------------------8<--------------------------
> >> diff --git a/drivers/media/video/em28xx/em28xx-core.c
> >> b/drivers/media/video/em28xx/em28xx-core.c
> >> index 5b78e19..339fffd 100644
> >> --- a/drivers/media/video/em28xx/em28xx-core.c
> >> +++ b/drivers/media/video/em28xx/em28xx-core.c
> >> @@ -720,7 +720,10 @@ int em28xx_resolution_set(struct em28xx *dev)
> >>  {
> >>         int width, height;
> >>         width = norm_maxw(dev);
> >> -       height = norm_maxh(dev) >> 1;
> >> +       height = norm_maxh(dev);
> >> +
> >> +       if (!dev->progressive)
> >> +               height >>= norm_maxh(dev);
> >>
> >> --------------------------------->8--------------------------
> >>
> >> It seems to me that for non-progressive the height should just be
> >>
> >>   height = height / 2 (or height = height >> 1)
> >>
> >> as was before, and as my patch is doing. It seems to driver will
> >> "merge" the interlaced
> >> frames and so the "expected" height is half the real height.
> >> I hope I got it right.
> >>
> >> That said and no matter how straightforward may be, which I'm not sure,
> >> I also want the patch to get tested before being accepted.

I own a Terratec Cinergy XS USB in two flavors:  0ccd:005e and
0ccd:0042. I work with  Fedora F17. If somebody gives me an advice what
code to patch (git or a tarball from
http://linuxtv.org/downloads/drivers/) and what to test, I can make a
try.

Regards
-- 
Felix


