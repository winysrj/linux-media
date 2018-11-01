Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48134 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbeKALiG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 07:38:06 -0400
Date: Wed, 31 Oct 2018 23:37:02 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.20-rc1] new experimental media request API
Message-ID: <20181031233702.13a501ea@coco.lan>
In-Reply-To: <CAHk-=wi5wkZtwZQfjVudLtS-Ej9pvaqu6=xM1msoBF8sMuTc_A@mail.gmail.com>
References: <20181030105328.0667ec68@coco.lan>
        <CAHk-=whQKCA18MEi7FT=10c0HVa=kxSyYBJeAQH-C2mA5gBhbg@mail.gmail.com>
        <CAHk-=wi5wkZtwZQfjVudLtS-Ej9pvaqu6=xM1msoBF8sMuTc_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 31 Oct 2018 15:32:03 -0700
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Wed, Oct 31, 2018 at 11:05 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > But pulled,  
> 
> I have no idea how I missed this during the actual test compile after
> the pull (and yes, I'm sure I did one), but after doing a couple of
> more pulls I finally did notice.
> 
> After the media pull I get this warning:
> 
>   ./usr/include/linux/v4l2-controls.h:1105: found __[us]{8,16,32,64}
> type without #include <linux/types.h>
> 
> and sure enough, the recent changes to
> 
>   include/uapi/linux/v4l2-controls.h
> 
> add those new structures use the "__uXY" types without including the
> header to define them.
> 
> It's harmless in the short term and the kernel build itself obviously
> doesn't care apart from the warning, but please fix it.

I also missed this one. Perhaps it depends on gcc version, or is it
a new warning after some changes? I remember there was some patchsets
floating around related to change some warnings.

Anyway, I'll send you a fix for it soon.

Thanks,
Mauro
