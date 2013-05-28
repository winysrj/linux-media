Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:26505 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934325Ab3E1Onw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 10:43:52 -0400
From: Inki Dae <inki.dae@samsung.com>
To: 'Daniel Vetter' <daniel@ffwll.ch>
Cc: 'Rob Clark' <robdclark@gmail.com>,
	'Maarten Lankhorst' <maarten.lankhorst@canonical.com>,
	'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'YoungJun Cho' <yj44.cho@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <20130520211304.GV12292@phenom.ffwll.local>
 <20130520213033.GW12292@phenom.ffwll.local>
 <032701ce55f1$3e9ba4b0$bbd2ee10$%dae@samsung.com>
 <20130521074441.GZ12292@phenom.ffwll.local>
 <033a01ce5604$c32bd250$498376f0$%dae@samsung.com>
 <CAKMK7uHtk+A7CDZH3qHt+F3H_fdSsWwt-bEPn-N0919oOE+Jkg@mail.gmail.com>
 <012801ce57ba$a5a87fa0$f0f97ee0$%dae@samsung.com>
 <014501ce5ac6$511a8500$f34f8f00$%dae@samsung.com>
 <CAF6AEGvGv539Ktdeg03n783nD+HofDamcJCLX93rzzKGOCV8_Q@mail.gmail.com>
 <005701ce5b57$667c7d40$337577c0$%dae@samsung.com>
 <20130528103229.GB15743@phenom.ffwll.local>
In-reply-to: <20130528103229.GB15743@phenom.ffwll.local>
Subject: RE: Introduce a new helper framework for buffer synchronization
Date: Tue, 28 May 2013 23:43:50 +0900
Message-id: <00d801ce5bb1$c48f2ea0$4dad8be0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Daniel,

Thank you so much. And so very useful.:) Sorry but could be give me more
comments to the below my comments? There are still things making me
confusing.:(


> -----Original Message-----
> From: Daniel Vetter [mailto:daniel.vetter@ffwll.ch] On Behalf Of Daniel
> Vetter
> Sent: Tuesday, May 28, 2013 7:33 PM
> To: Inki Dae
> Cc: 'Rob Clark'; 'Maarten Lankhorst'; 'Daniel Vetter'; 'linux-fbdev';
> 'YoungJun Cho'; 'Kyungmin Park'; 'myungjoo.ham'; 'DRI mailing list';
> linux-arm-kernel@lists.infradead.org; linux-media@vger.kernel.org
> Subject: Re: Introduce a new helper framework for buffer synchronization
> 
> On Tue, May 28, 2013 at 12:56:57PM +0900, Inki Dae wrote:
> >
> >
> > > -----Original Message-----
> > > From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> > > owner@vger.kernel.org] On Behalf Of Rob Clark
> > > Sent: Tuesday, May 28, 2013 12:48 AM
> > > To: Inki Dae
> > > Cc: Maarten Lankhorst; Daniel Vetter; linux-fbdev; YoungJun Cho;
> Kyungmin
> > > Park; myungjoo.ham; DRI mailing list;
> > linux-arm-kernel@lists.infradead.org;
> > > linux-media@vger.kernel.org
> > > Subject: Re: Introduce a new helper framework for buffer
> synchronization
> > >
> > > On Mon, May 27, 2013 at 6:38 AM, Inki Dae <inki.dae@samsung.com>
wrote:
> > > > Hi all,
> > > >
> > > > I have been removed previous branch and added new one with more
> cleanup.
> > > > This time, the fence helper doesn't include user side interfaces and
> > > cache
> > > > operation relevant codes anymore because not only we are not sure
> that
> > > > coupling those two things, synchronizing caches and buffer access
> > > between
> > > > CPU and CPU, CPU and DMA, and DMA and DMA with fences, in kernel
> side is
> > > a
> > > > good idea yet but also existing codes for user side have problems
> with
> > > badly
> > > > behaved or crashing userspace. So this could be more discussed
later.
> > > >
> > > > The below is a new branch,
> > > >
> > > > https://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-
> > > exynos.git/?h=dma-f
> > > > ence-helper
> > > >
> > > > And fence helper codes,
> > > >
> > > > https://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-
> > > exynos.git/commit/?
> > > > h=dma-fence-helper&id=adcbc0fe7e285ce866e5816e5e21443dcce01005
> > > >
> > > > And example codes for device driver,
> > > >
> > > > https://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-
> > > exynos.git/commit/?
> > > > h=dma-fence-helper&id=d2ce7af23835789602a99d0ccef1f53cdd5caaae
> > > >
> > > > I think the time is not yet ripe for RFC posting: maybe existing dma
> > > fence
> > > > and reservation need more review and addition work. So I'd glad for
> > > somebody
> > > > giving other opinions and advices in advance before RFC posting.
> > >
> > > thoughts from a *really* quick, pre-coffee, first look:
> > > * any sort of helper to simplify single-buffer sort of use-cases (v4l)
> > > probably wouldn't want to bake in assumption that seqno_fence is used.
> > > * I guess g2d is probably not actually a simple use case, since I
> > > expect you can submit blits involving multiple buffers :-P
> >
> > I don't think so. One and more buffers can be used: seqno_fence also has
> > only one buffer. Actually, we have already applied this approach to most
> > devices; multimedia, gpu and display controller. And this approach shows
> > more performance; reduced power consumption against traditional way. And
> g2d
> > example is just to show you how to apply my approach to device driver.
> 
> Note that seqno_fence is an implementation pattern for a certain type of
> direct hw->hw synchronization which uses a shared dma_buf to exchange the
> sync cookie.

I'm afraid that I don't understand hw->hw synchronization. hw->hw
synchronization means that device has a hardware feature which supports
buffer synchronization hardware internally? And what is the sync cookie?

> The dma_buf attached to the seqno_fence has _nothing_ to do
> with the dma_buf the fence actually coordinates access to.
> 
> I think that confusing is a large reason for why Maarten&I don't
> understand what you want to achieve with your fence helpers. Currently
> they're using the seqno_fence, but totally not in a way the seqno_fence
> was meant to be used.
> 
> Note that with the current code there is only a pointer from dma_bufs to
> the fence. The fence itself has _no_ pointer to the dma_buf it syncs. This
> shouldn't be a problem since the fence fastpath for already signalled
> fences is completely barrier&lock free (it's just a load+bit-test), and
> fences are meant to be embedded into whatever dma tracking structure you
> already have, so no overhead there. The only ugly part is the fence
> refcounting, but I don't think we can drop that.

The below is the proposed way,
dma device has to create a fence before accessing a shared buffer, and then
check if there are other dma which are accessing the shared buffer; if exist
then the dma device should be blocked, and then  it sets the fence to
reservation object of the shared buffer. And then the dma begins access to
the shared buffer. And finally, the dma signals its own fence so that other
blocked can be waked up. However, if there was another dma blocked before
signaling then another dma can access invalid fence object after waked up
because the fence object can be released after signaling. So I made another
dma takes a one reference before blocked. And I think origin version also
takes a reference at ticket_commit(). Is there wrong point in proposed way?

> 
> Note that you completely reinvent this part of Maarten's fence patches by
> adding new r/w_complete completions to the reservation object, which
> completely replaces the fence stuff.
> 
> Also note that a list of reservation entries is again meant to be used
> only when submitting the dma to the gpu. With your patches you seem to
> hang onto that list until dma completes.

Yeah, that is for prevent a dma from accessing a shared buffer while the
other is accessing the shared buffer. Maybe this way means software
synchronization. And your saying seems that there is another mechanism for
dealing with such thing. Could you give me more comments for it? is there
really another mechanism?

> This has the ugly side-effect
> that you need to allocate these reservation entries with kmalloc, whereas
> if you just use them in the execbuf ioctl to construct the dma you can
> usually embed it into something else you need already anyway. At least
> i915 and ttm based drivers can work that way.
> 

Maybe there is my misunderstanding but I thought now dma fence and relevant
stubs tend to depend on Desktop world, especially x86 gpu. So I thought we
need a little bit customizing the dma fence for embedded system.

> Furthermore fences are specifically constructed as frankenstein-monsters
> between completion/waitqueues and callbacks. All the different use-cases
> need the different aspects:
> - busy/idle checks and bo retiring need the completion semantics
> - callbacks (in interrupt context) are used for hybrid hw->irq handler->hw
>   sync approaches
> 
> >
> > > * otherwise, you probably don't want to depend on dmabuf, which is why
> > > reservation/fence is split out the way it is..  you want to be able to
> > > use a single reservation/fence mechanism within your driver without
> > > having to care about which buffers are exported to dmabuf's and which
> > > are not.  Creating a dmabuf for every GEM bo is too heavyweight.
> >
> > Right. But I think we should dealt with this separately. Actually, we
> are
> > trying to use reservation for gpu pipe line synchronization such as sgx
> sync
> > object and this approach is used without dmabuf. In order words, some
> device
> > can use only reservation for such pipe line synchronization and at the
> same
> > time, fence helper or similar thing with dmabuf for buffer
> synchronization.
> 
> I think a quick overview of the different pieces would be in order.
> 
> - ww_mutex: This is just the locking primite which allows you to grab
>   multiple mutexes without the need to check for ordering (and so fear
>   deadlocks).

Should ww_mutex be necessarily used for embedded system? I'm not sure that
there are any cases we have to use this feature like x86 gpu. That is also
why I removed ticket stubs from existing reservation framework.

> 
> - fence: This is just a fancy kind of completion with a bit of support for
>   hw->hw completion events.

hw->hw completion event means completion of dma operation? Otherwise,
hardware buffer synchronization feature? If the latter, how fence can be
used for embedded system which has no hardware feature for buffer
synchronization? Actually, that made me confusing at initial work.

> The fences themselve have no tie-in with
>   buffers, ww_mutexes or anything else.
> 
> - reservation: This ties together an object (doesn't need to be a buffer,
>   could be any other gpu resource - see the drm/vmwgfx driver if you want
>   your mind blown) with fences. Note that there's no connection the other
>   way round, i.e. with the current patches you can't see which
>   reservations are using which fences. Also note that other objects than
>   reservations could point at fences, e.g. when the provide
>   shared/exclusive semantics are not good enough for your needs.
> 
>   The ww_mutex in the reservation is simply the (fancy) lock which
>   protects each reservation. The reason we need something fancy is that
>   you need to lock all objects which are synced by the same fence
>   toghether, otherwise you can race and construct deadlocks in the hw->hw
>   sync part of fences.
> 
> - dma_buf integration: This is simply a pointer to the reservation object
>   of the underlying buffer object. We need a pointer here since otherwise
>   you can construct deadlocks between dma_buf objects and native buffer
>   objects.
> 
> The crux is also that dma_buf integration comes last - before you can do
> that you need to have your driver converted over to use
> ww_mutexes/fences/reservations.
> 
> I hope that helps to unconfuse things a bit and help you understand the
> different pieces of the fence/reservation/ww_mutex patches floating
> around.

Thank you again.:) 

Thanks,
Inki Dae

> 
> Cheers, Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch

