Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50011 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2HCSzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 14:55:49 -0400
Received: by ggnl2 with SMTP id l2so1216206ggn.19
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 11:55:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+Vhng3=GUJs5k9fiktkE6mEtDNEzKfP8+zjTSmCCRez8w@mail.gmail.com>
References: <1344016352-20302-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+UdxdawZMeniA-tia3qKARbX_+u2k8PnbhA_FhDKUMv3Q@mail.gmail.com>
	<CAGoCfiyaO5xhjUCVW5QfeLDoh=a6WE73aiAOXX5ZkOiM=efOfQ@mail.gmail.com>
	<CALF0-+Vhng3=GUJs5k9fiktkE6mEtDNEzKfP8+zjTSmCCRez8w@mail.gmail.com>
Date: Fri, 3 Aug 2012 14:55:48 -0400
Message-ID: <CAGoCfizFYYtA2HHE6TO9eW6UF6FaxOhOyrsu6gCRi5kCGCO4zA@mail.gmail.com>
Subject: Re: [PATCH] em28xx: Fix height setting on non-progressive captures
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 3, 2012 at 2:42 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> Wait a minute, unless I completely misunderstood the bug (which is possible),
> I think this patch is straightforward.
>
> By the look of this hunk on commit c2a6b54a:
>
> ---------------------------------8<--------------------------
> diff --git a/drivers/media/video/em28xx/em28xx-core.c
> b/drivers/media/video/em28xx/em28xx-core.c
> index 5b78e19..339fffd 100644
> --- a/drivers/media/video/em28xx/em28xx-core.c
> +++ b/drivers/media/video/em28xx/em28xx-core.c
> @@ -720,7 +720,10 @@ int em28xx_resolution_set(struct em28xx *dev)
>  {
>         int width, height;
>         width = norm_maxw(dev);
> -       height = norm_maxh(dev) >> 1;
> +       height = norm_maxh(dev);
> +
> +       if (!dev->progressive)
> +               height >>= norm_maxh(dev);
>
> --------------------------------->8--------------------------
>
> It seems to me that for non-progressive the height should just be
>
>   height = height / 2 (or height = height >> 1)
>
> as was before, and as my patch is doing. It seems to driver will
> "merge" the interlaced
> frames and so the "expected" height is half the real height.
> I hope I got it right.
>
> That said and no matter how straightforward may be, which I'm not sure,
> I also want the patch to get tested before being accepted.

So my concern here is that I don't actually know what that code does
on x86 (what does height end up being equal to?).  On ARM it results
in height being zero, but on x86 I don't know what it will do (and the
fact that it works on x86 despite the change makes me worry about a
regression being introduced).

In other words, it might be working just out of dumb luck and making
the code behave like it does on ARM may cause problems for devices
other than the one I tested with.

I guess I'm worried that the broken code might be a no-op on x86 and
the height ends up still being 480 (or 576 for PAL), in which case
cutting the size of the accumulator window in half may introduce
problems not being seen before.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
