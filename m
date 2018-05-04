Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:53021 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbeEDI6E (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 04:58:04 -0400
Received: by mail-wm0-f67.google.com with SMTP id w194so2857863wmf.2
        for <linux-media@vger.kernel.org>; Fri, 04 May 2018 01:58:03 -0700 (PDT)
Date: Fri, 4 May 2018 10:57:59 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH 04/15] dma-fence: Make ->wait callback optional
Message-ID: <20180504085759.GT12521@phenom.ffwll.local>
References: <20180503142603.28513-1-daniel.vetter@ffwll.ch>
 <20180503142603.28513-5-daniel.vetter@ffwll.ch>
 <152542135089.4767.3315686184618150713@mail.alporthouse.com>
 <20180504081722.GQ12521@phenom.ffwll.local>
 <20180504082301.GR12521@phenom.ffwll.local>
 <152542269311.4767.4254637128660397977@mail.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152542269311.4767.4254637128660397977@mail.alporthouse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 04, 2018 at 09:31:33AM +0100, Chris Wilson wrote:
> Quoting Daniel Vetter (2018-05-04 09:23:01)
> > On Fri, May 04, 2018 at 10:17:22AM +0200, Daniel Vetter wrote:
> > > On Fri, May 04, 2018 at 09:09:10AM +0100, Chris Wilson wrote:
> > > > Quoting Daniel Vetter (2018-05-03 15:25:52)
> > > > > Almost everyone uses dma_fence_default_wait.
> > > > > 
> > > > > v2: Also remove the BUG_ON(!ops->wait) (Chris).
> > > > 
> > > > I just don't get the rationale for implicit over explicit.
> > > 
> > > Closer approximation of dwim semantics. There's been tons of patch series
> > > all over drm and related places to get there, once we have a big pile of
> > > implementations and know what the dwim semantics should be. Individually
> > > they're all not much, in aggregate they substantially simplify simple
> > > drivers.
> > 
> > I also think clearer separation between optional optimization hooks and
> > mandatory core parts is useful in itself.
> 
> A new spelling of midlayer ;) I don't see the contradiction with a
> driver saying use the default and simplicity. (I know which one the
> compiler thinks is simpler ;)

If the compiler overhead is real then I guess it would makes to be
explicit. I don't expect that to be a problem though for a blocking
function.

I disagree on this being a midlayer - you can still overwrite everything
you please to. What it does help is people doing less copypasting (and
assorted bugs), at least in the grand scheme of things. And we do have a
_lot_ more random small drivers than just a few years ago. Reducing the
amount of explicit typing just to get default bahaviour has been an
ongoing theme for a few years now, and your objection here is about the
first that this is not a good idea. So I'm somewhat confused.

It's ofc not all that useful when looking only through the i915
perspective, where we overwrite almost everything anyway. But the
ecosystem is a bit bigger than just i915.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
