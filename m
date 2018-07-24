Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55756 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388402AbeGXTrZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 15:47:25 -0400
Date: Tue, 24 Jul 2018 15:39:23 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Staging subsystem List <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] media: staging: omap4iss: Include asm/cacheflush.h
 after generic includes
Message-ID: <20180724153923.0f1b9f56@coco.lan>
In-Reply-To: <CA+55aFyV=5QNJXn+t_ZDCigGi+HjM6N94DRb_E50_xUsk+VTFA@mail.gmail.com>
References: <1532381973-11856-1-git-send-email-linux@roeck-us.net>
        <20180724004110.37d0e5dc@coco.lan>
        <CA+55aFyV=5QNJXn+t_ZDCigGi+HjM6N94DRb_E50_xUsk+VTFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 24 Jul 2018 10:37:56 -0700
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Mon, Jul 23, 2018 at 8:41 PM Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org> wrote:
> >
> > While I won't be against merging it, IMHO a better fix would be to
> > add the includes asm/cacheflush.h needs inside it, e. g. something
> > like adding:  
> 
> No. The <asm/*> includes really should come after <linux/*>.
> 
> This is a media driver bug, plain and simple.

Works for me. Do you intend to apply it directly? Otherwise I'll
add on my tree - and likely send you during the merge window - this is
just Kconfig random COMPILE_TEST build noise, as this driver
is ARM-only (for an OMAP4 specific IP block). So, probably not worth
sending a pull request just due to that.

> We should strive to avoid adding more header includes, it's one of the
> major causes of kernel build slowdown.

Yeah, some time ago mailing lists got flooded with some janitorial's
patchset adding includes (some claiming to be needed on some archs or
under some random Kconfigs)... Compile-test ended by adding more such
stuff (for a good reason, IMHO). I wonder if are there a better way to
handle includes without slowing builds.

Thanks,
Mauro
