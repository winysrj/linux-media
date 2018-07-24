Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:46701 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388366AbeGXT4T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 15:56:19 -0400
MIME-Version: 1.0
References: <1532381973-11856-1-git-send-email-linux@roeck-us.net>
 <20180724004110.37d0e5dc@coco.lan> <CA+55aFyV=5QNJXn+t_ZDCigGi+HjM6N94DRb_E50_xUsk+VTFA@mail.gmail.com>
 <20180724153923.0f1b9f56@coco.lan>
In-Reply-To: <20180724153923.0f1b9f56@coco.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2018 11:48:19 -0700
Message-ID: <CA+55aFwVVQcbpH=3Qf8hfGhx_Dz-Xp0N+gbAoaFhqLkVD-+WtA@mail.gmail.com>
Subject: Re: [PATCH] media: staging: omap4iss: Include asm/cacheflush.h after
 generic includes
To: mchehab+samsung@kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Staging subsystem List <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 24, 2018 at 11:39 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Works for me. Do you intend to apply it directly?

Yes, I took it and it should be pushed out.

> Yeah, some time ago mailing lists got flooded with some janitorial's
> patchset adding includes (some claiming to be needed on some archs or
> under some random Kconfigs)... Compile-test ended by adding more such
> stuff (for a good reason, IMHO). I wonder if are there a better way to
> handle includes without slowing builds.

It's a nightmare to do by hand, with all the different architectures
having slightly different header file requirements.

The scheduler people did it last year (roughly Feb-2017 timeframe),
and it was painful and involved a lot of build testing. Basically some
<linux/sched.h> was split up into <linux/sched/*.h>

I wouldn't encourage people to do that again without some tooling to
actually look at "what symbols might get defined by header file
collection XYZ, what symbols might I need with any config option" kind
of logic.

But it would be lovely if somebody *could* do tooling like that.

Just having something you can run on C files that says "these headers
are completely unused under all possibly config options and
architectures" might be interesting.

Because right now, most people tend to just copy a big set of headers,
whether they need it or not. And they almost never shrink, but new
ones get added as people add uses.

            Linus
