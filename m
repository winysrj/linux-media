Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:35103 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866Ab1DMU5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 16:57:34 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2.6.39 v2] V4L: videobuf-dma-contig: fix mmap_mapper broken on ARM
Date: Wed, 13 Apr 2011 22:56:39 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jiri Slaby <jslaby@suse.cz>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <201104122306.34909.jkrzyszt@tis.icnet.pl> <201104131252.32011.jkrzyszt@tis.icnet.pl> <20110413183231.GA23631@n2100.arm.linux.org.uk>
In-Reply-To: <20110413183231.GA23631@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Message-Id: <201104132256.40325.jkrzyszt@tis.icnet.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dnia środa 13 kwiecień 2011 o 20:32:31 Russell King - ARM Linux 
napisał(a):
> On Wed, Apr 13, 2011 at 12:52:31PM +0200, Janusz Krzysztofik wrote:
> > Taking into account that I'm just trying to fix a regression, and
> > not invent a new, long term solution: are you able to name an ARM
> > based board which a) is already supported in 2.6.39, b) is (or can
> > be) equipped with a device supported by a V4L driver which uses
> > videobuf- dma-config susbsystem, c) has a bus structure with which
> > virt_to_phys(bus_to_virt(dma_handle)) is not equal dma_handle?
> 
> I have no idea - and why should whether someone can name something
> that may break be a justification to allow something which is
> technically wrong?
> 
> Surely it should be the other way around - if its technically wrong
> and _may_ break something then it shouldn't be allowed.

In theory - of course. In practice - couldn't we now, close to -rc3, 
relax the rules a little bit and stop bothering with something that may 
break in the future if it doesn't break on any board supported so far (I 
hope)?

> > I thought so too, but missed the fact that PowerPC implements it
> > actually, even defining the ARCH_HAS_DMA_MMAP_COHERENT symbol,
> > which ARM doesn't so far.
> 
> So, there's no problem adding that symbol to ARM.

OK, I can provide a patch as soon as dma_mmap_coherent() really works 
for me.

> > > Maybe the video drivers should try to resurect the idea, maybe
> > > only allowing this support for architectures which provide
> > > dma_mmap_coherent().
> > 
> > AFAICT, ARM implementation of dma_mmap_coherent() is not compatible
> > with dma_declare_coherent_memory(), is it? If I'm wrong, please
> > correct me, I'll get back to the idea presented in v1 of the fix.
> 
> 1. dma_declare_coherent_memory() doesn't work on ARM for memory which
> already exists (its not permitted to ioremap() the kernel
> direct-mapped memory due to attribute aliasing issues.)

But you had once inspired
(http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December/034879.html),
then was supporting my attempts towards pushing ioremap() out of this 
function up to the caller 
(http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December/036419.html), 
which would allow for doing sane preallocations via dma_coherent_alloc() 
and caching them back into dma_declare_coherent_memory() at boot time 
for later reuse mempry from that pool as DMA coherent. Now, should my 
attepmts succeded, we would still end up with the following:

> 2. dma_declare_coherent_memory() totally bypasses the DMA allocator,

Would it still, under your terms, if it could accept 
dma_alloc_coherent() obtained cpu addresses, not trying to ioremap() 
them?

> and so dma_mmap_coherent() has no knowledge of how to map the
> memory.

I think it _could_ have a good knowledge if that memory was first 
preallocated with dma_alloc_coherent() at boot time, unless that memory 
was then fetched from that pool in smaller chunks. I think this is the 
reason it didn't work for me when I tried using this method with 
dma_mmap_coherent(). Am I missing something?

> If we had a proper way to map DMA memory into userspace, then we
> wouldn't have these issues as the dma_declare_coherent_memory()
> would already support that.
> 
> And actually, talking about dma_declare_coherent_memory(), you've
> just provided a reason why virt_to_phys(bus_to_virt(dma_handle))
> won't work - dma_declare_coherent_memory() can be used to provide
> on-device memory where the virt/handle may not be mappable with
> bus_to_virt().

While I have no problems to agree with the principles, I can confirm 
that this _hack_ does coexist nicely with dma_declare_coherent_memory(), 
at least on my OMAP1 based board.

It also coexists nicely with your WiP patches I mentioned before and you 
didn't quote here, so I provide the links again:
http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December/036461.html,
http://lists.infradead.org/pipermail/linux-arm-kernel/2011-January/036809.html.

OTOH, dma_mmap_coherent() didn't work for me when I tried using it on 
top of those patches.

This doesn't mean I'm against a dma_mmap_coherent() based solution. I 
just think we can't afford switching to it _now_.

> > Otherwise, I think that switching to dma_mmap_coherent() is not an
> > option for the videobuf-dma-contig subsystem as long as there is no
> > good solution to the problem of dma_alloc_coherent() not
> > guaranteed to succeed with high-order allocations at any time.
> 
> Let me repeat: there is no official API or way to map DMA memory into
> userspace. 

Doesn't dma_mmap_coherent(), already available on 2 architectures, ARM 
and PPC, aim to provide the correct API? From the fact you didn't 
dispute v1 of my patch, which provided a dma_mmap_coherent() based code 
path for architectures supporting it, I would conclude this is a 
solution which might get your support, isn't it?

However, I think that even if it was a _proper_ solution to the problem, 
it couldn't be accepted as a fix during the rc cycle for a simple 
reason: this would break all those boards (ab)using 
dma_declare_coherent_memory().

> Every way people try is a half-hacked up bodge which may
> or may not work for a limited subset of systems.
> 
> Until someone (like you) puts some serious effort into persuading
> *everyone* that this feature is needed, things are just going to
> continue being bodged and fragile.
> 
> All that's happening here is that you're changing one broken way
> which works for one subset with another broken way which works for a
> different subset of systems and architectures.  What actually needs
> to happen is a _proper_ fix for this.

I don't believe you really think it would possible to come out with a 
_proper_ solution to the problem which could still be accepted as a 
_fix_. We are close to -rc3.

If I'm wrong, and you think this can still be fixed properly for this rc 
cycle, please share more of your idea and I'll try to do my best to 
implement it.

Thanks,
Janusz
