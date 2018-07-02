Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40286 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933574AbeGBIYB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 04:24:01 -0400
Received: by mail-ed1-f66.google.com with SMTP id e19-v6so250996edq.7
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:24:00 -0700 (PDT)
Date: Mon, 2 Jul 2018 10:23:56 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: christian.koenig@amd.com
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/15] dma-fence: Make ->wait callback optional
Message-ID: <20180702082356.GI13978@phenom.ffwll.local>
References: <20180503142603.28513-5-daniel.vetter@ffwll.ch>
 <152542135089.4767.3315686184618150713@mail.alporthouse.com>
 <20180504081722.GQ12521@phenom.ffwll.local>
 <20180504082301.GR12521@phenom.ffwll.local>
 <152542269311.4767.4254637128660397977@mail.alporthouse.com>
 <20180504085759.GT12521@phenom.ffwll.local>
 <152542538170.4767.9925437389288286145@mail.alporthouse.com>
 <CAKMK7uHqdGsRQ60mL0LUmHPYp0zCyv0ni6=uhEpeHsOR3RLBzw@mail.gmail.com>
 <82509ba9-b305-433f-b70c-16ae857d13bc@gmail.com>
 <20180504134759.GA12521@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180504134759.GA12521@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 04, 2018 at 03:47:59PM +0200, Daniel Vetter wrote:
> On Fri, May 04, 2018 at 03:17:08PM +0200, Christian König wrote:
> > Am 04.05.2018 um 11:25 schrieb Daniel Vetter:
> > > On Fri, May 4, 2018 at 11:16 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > > > Quoting Daniel Vetter (2018-05-04 09:57:59)
> > > > > On Fri, May 04, 2018 at 09:31:33AM +0100, Chris Wilson wrote:
> > > > > > Quoting Daniel Vetter (2018-05-04 09:23:01)
> > > > > > > On Fri, May 04, 2018 at 10:17:22AM +0200, Daniel Vetter wrote:
> > > > > > > > On Fri, May 04, 2018 at 09:09:10AM +0100, Chris Wilson wrote:
> > > > > > > > > Quoting Daniel Vetter (2018-05-03 15:25:52)
> > > > > > > > > > Almost everyone uses dma_fence_default_wait.
> > > > > > > > > > 
> > > > > > > > > > v2: Also remove the BUG_ON(!ops->wait) (Chris).
> > > > > > > > > I just don't get the rationale for implicit over explicit.
> > > > > > > > Closer approximation of dwim semantics. There's been tons of patch series
> > > > > > > > all over drm and related places to get there, once we have a big pile of
> > > > > > > > implementations and know what the dwim semantics should be. Individually
> > > > > > > > they're all not much, in aggregate they substantially simplify simple
> > > > > > > > drivers.
> > > > > > > I also think clearer separation between optional optimization hooks and
> > > > > > > mandatory core parts is useful in itself.
> > > > > > A new spelling of midlayer ;) I don't see the contradiction with a
> > > > > > driver saying use the default and simplicity. (I know which one the
> > > > > > compiler thinks is simpler ;)
> > > > > If the compiler overhead is real then I guess it would makes to be
> > > > > explicit. I don't expect that to be a problem though for a blocking
> > > > > function.
> > > > > 
> > > > > I disagree on this being a midlayer - you can still overwrite everything
> > > > > you please to. What it does help is people doing less copypasting (and
> > > > > assorted bugs), at least in the grand scheme of things. And we do have a
> > > > > _lot_ more random small drivers than just a few years ago. Reducing the
> > > > > amount of explicit typing just to get default bahaviour has been an
> > > > > ongoing theme for a few years now, and your objection here is about the
> > > > > first that this is not a good idea. So I'm somewhat confused.
> > > > I'm just saying I don't see any rationale for this patch.
> > > > 
> > > >          "Almost everyone uses dma_fence_default_wait."
> > > > 
> > > > Why change?
> > > > 
> > > > Making it look simpler on the surface, so that you don't have to think
> > > > about things straight away? I understand the appeal, but I do worry
> > > > about it just being an illusion. (Cutting and pasting a line saying
> > > > .wait = default_wait, doesn't feel that onerous, as you likely cut and
> > > > paste the ops anyway, and at the very least you are reminded about some
> > > > of the interactions. You could even have default initializers and/or
> > > > magic macros to hide the cut and paste; maybe a simple_dma_fence [now
> > > > that's a midlayer!] but I haven't looked.)
> > > In really monolithic vtables like drm_driver we do use default
> > > function macros, so you type 1 line, get them all. But dma_fence_ops
> > > is pretty small, and most drivers only implement a few callbacks. Also
> > > note that e.g. the ->release callback already works like that, so this
> > > pattern is there already. I simply extended it to ->wait and
> > > ->enable_signaling. Also note that I leave the EXPORT_SYMBOL in place,
> > > you can still wrap dma_fence_default_wait if you wish to do so.
> > > 
> > > But I just realized that I didn't clean out the optional release
> > > hooks, I guess I should do that too (for the few cases it's not yet
> > > done) and respin.
> > 
> > I kind of agree with Chris here, but also see the practical problem to copy
> > the default function in all the implementations.
> > 
> > We had the same problem in TTM and I also don't really like the result to
> > always have that "if (some_callback) default(); else some_callback();".
> > 
> > Might be that the run time overhead is negligible, but it doesn't feels
> > right from the coding style perspective.
> 
> Hm, maybe I've seen too much bad code, but modeset helpers is choke full
> of exactly that pattern. It's imo also a trade-off. If you have a fairly
> specialized library like ttm that's used by relatively few things, doing
> everything explicitly is probably better. It's also where kms started out
> from.
> 
> But if you have a huge pile of fairly simple drivers, imo the balance
> starts to tip the other way, and a bit of additional logic in the shared
> code to make all the implementations a notch simpler is good. If we
> wouldn't have acquired quite a pile of dma_fence implementations I
> wouldn't have bothered with all this.

So ack/nack on this (i.e. do you retract your original r-b or not)? It's
kinda holding up all the cleanup patches below ...

I went ahead and applied the first three patches of this series meanwhile.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
