Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34968 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756453AbdEXMVj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 May 2017 08:21:39 -0400
Received: by mail-wm0-f66.google.com with SMTP id g15so27407813wmc.2
        for <linux-media@vger.kernel.org>; Wed, 24 May 2017 05:21:38 -0700 (PDT)
Date: Wed, 24 May 2017 14:21:31 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>,
        Andres Rodriguez <andresx7@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: avoid scheduling on fence
 status query v2
Message-ID: <20170524122131.gea7lcyz2ldhfmal@phenom.ffwll.local>
References: <20170426144620.3560-1-andresx7@gmail.com>
 <92c9bc96-cf60-f246-a82e-47653472521e@vodafone.de>
 <20170427212748.GD2568@joana>
 <CAPM=9twvHHDaVsEOJCazWJeNptMb+pFUroq5jc52Tu4Cvg-T0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPM=9twvHHDaVsEOJCazWJeNptMb+pFUroq5jc52Tu4Cvg-T0g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 24, 2017 at 09:47:49AM +1000, Dave Airlie wrote:
> On 28 April 2017 at 07:27, Gustavo Padovan <gustavo@padovan.org> wrote:
> > 2017-04-26 Christian König <deathsimple@vodafone.de>:
> >
> >> Am 26.04.2017 um 16:46 schrieb Andres Rodriguez:
> >> > When a timeout of zero is specified, the caller is only interested in
> >> > the fence status.
> >> >
> >> > In the current implementation, dma_fence_default_wait will always call
> >> > schedule_timeout() at least once for an unsignaled fence. This adds a
> >> > significant overhead to a fence status query.
> >> >
> >> > Avoid this overhead by returning early if a zero timeout is specified.
> >> >
> >> > v2: move early return after enable_signaling
> >> >
> >> > Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
> >>
> >> Reviewed-by: Christian König <christian.koenig@amd.com>
> >
> > pushed to drm-misc-next. Thanks all.
> 
> I don't see this patch in -rc2, where did it end up going?

Queued for 4.13. Makes imo sense since it's just a performance
improvement, not a clear bugfix. But it's in your drm-next, so if you want
to fast-track you can cherry-pick it over:

commit 03c0c5f6641533f5fc14bf4e76d2304197402552
Author: Andres Rodriguez <andresx7@gmail.com>
Date:   Wed Apr 26 10:46:20 2017 -0400

    dma-buf: avoid scheduling on fence status query v2

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
