Return-path: <linux-media-owner@vger.kernel.org>
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:46321 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbbEHTTJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 May 2015 15:19:09 -0400
Date: Fri, 8 May 2015 20:18:43 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Thierry Reding <treding@nvidia.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Rob Clark <robdclark@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Gall <tom.gall@linaro.org>
Subject: Re: [RFC] How implement Secure Data Path ?
Message-ID: <20150508201843.3447049b@lxorguk.ukuu.org.uk>
In-Reply-To: <20150508083735.GB15256@phenom.ffwll.local>
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
	<20150505175405.2787db4b@lxorguk.ukuu.org.uk>
	<20150506083552.GF30184@phenom.ffwll.local>
	<20150506091919.GC16325@ulmo.nvidia.com>
	<20150506131532.GC30184@phenom.ffwll.local>
	<20150507132218.GA24541@ulmo.nvidia.com>
	<20150507135212.GD30184@phenom.ffwll.local>
	<20150507174003.2a5b42e6@lxorguk.ukuu.org.uk>
	<20150508083735.GB15256@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> dma-buf user handles are fds, which means anything allocated can be passed
> around nicely already. The question really is whether we'll have one ioctl
> on top of a special dev node or a syscall. I thought that in these cases
> where the dev node is only ever used to allocate the real thing, a syscall
> is the preferred way to go.

So you'd go for

	fd = dmabuf_alloc(blah..., O_whatever) ?

Whichever I guess.. really we want open("/dev/foo/parameters.....") but
we missed that chance a long time ago.

The billion dollar question is how is the resource managed, who owns the
object, who is charged for it, how to does containerise. We really ought
to have a clear answer to that.

> > I guess the same kind of logic as with GEM (except preferably without
> > the DoS security holes) applies as to why its useful to have handles to
> > the DMA buffers.
> 
> We have handles (well file descriptors) to dma-bufs already, I'm a bit
> confused what you mean?

I was agreeing with your argument - with GEM as an example that it works
for the CPU accessing case.

Alan
