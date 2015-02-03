Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44773 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161089AbbBCUH3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 15:07:29 -0500
Received: by mail-wi0-f174.google.com with SMTP id n3so27194409wiv.1
        for <linux-media@vger.kernel.org>; Tue, 03 Feb 2015 12:07:27 -0800 (PST)
Date: Tue, 3 Feb 2015 21:08:49 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Rob Clark <robdclark@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
	Robin Murphy <robin.murphy@arm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Daniel Vetter <daniel@ffwll.ch>,
	Tomasz Stanislawski <stanislawski.tomasz@googlemail.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [RFCv3 2/2] dma-buf: add helpers for sharing
 attacher constraints with dma-parms
Message-ID: <20150203200849.GY14009@phenom.ffwll.local>
References: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org>
 <3783167.LiVXgA35gN@wuerfel>
 <20150203155404.GV8656@n2100.arm.linux.org.uk>
 <6906596.JU5vQoa1jV@wuerfel>
 <20150203165829.GW8656@n2100.arm.linux.org.uk>
 <CAF6AEGuf6XBe3YOjhtbBcSyqJrkZ7sNMfc83hZdnKsE3P=vSuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGuf6XBe3YOjhtbBcSyqJrkZ7sNMfc83hZdnKsE3P=vSuw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 03, 2015 at 12:35:34PM -0500, Rob Clark wrote:
> On Tue, Feb 3, 2015 at 11:58 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> >
> > Okay, but switching contexts is not something which the DMA API has
> > any knowledge of (so it can't know which context to associate with
> > which mapping.)  While it knows which device, it has no knowledge
> > (nor is there any way for it to gain knowledge) about contexts.
> >
> > My personal view is that extending the DMA API in this way feels quite
> > dirty - it's a violation of the DMA API design, which is to (a) demark
> > the buffer ownership between CPU and DMA agent, and (b) to translate
> > buffer locations into a cookie which device drivers can use to instruct
> > their device to access that memory.  To see why, consider... that you
> > map a buffer to a device in context A, and then you switch to context B,
> > which means the dma_addr_t given previously is no longer valid.  You
> > then try to unmap it... which is normally done using the (now no longer
> > valid) dma_addr_t.
> >
> > It seems to me that to support this at DMA API level, we would need to
> > completely revamp the DMA API, which IMHO isn't going to be nice.  (It
> > would mean that we end up with three APIs - the original PCI DMA API,
> > the existing DMA API, and some new DMA API.)
> >
> > Do we have any views on how common this feature is?
> >
> 
> I can't think of cases outside of GPU's..  if it were more common I'd
> be in favor of teaching dma api about multiple contexts, but right now
> I think that would just amount to forcing a lot of churn on everyone
> else for the benefit of GPU's.
> 
> IMHO it makes more sense for GPU drivers to bypass the dma api if they
> need to.  Plus, sooner or later, someone will discover that with some
> trick or optimization they can get moar fps, but the extra layer of
> abstraction will just be getting in the way.

See my other reply, but all existing full-blown drivers don't bypass the
dma api. Instead it's just a two-level scheme:
1. First level is dma api. Might or might not contain a system iommu.
2. 2nd level is the gpu-private iommu which is also used for per context
address spaces. Thus far all drivers just rolled their own drivers for
this (it's kinda fused to the chips on x86 hw anyway), but it looks like
using the iommu api gives us a somewhat suitable abstraction for code
sharing.

Imo you need both, otherwise we start leaking stuff like cpu cache
flushing all over the place. Looking at i915 (where the dma api assumes
that everything is coherent, which is kinda not the case) that won't be
pretty. And there's still the issue that you might nest a system iommu
and a 2nd level iommu for per-context pagetables (this is real and what's
going on right now on intel hw).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
