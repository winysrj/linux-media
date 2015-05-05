Return-path: <linux-media-owner@vger.kernel.org>
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:40689 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760679AbbEEQya (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 12:54:30 -0400
Date: Tue, 5 May 2015 17:54:05 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Rob Clark <robdclark@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Dave Airlie <airlied@redhat.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Gall <tom.gall@linaro.org>
Subject: Re: [RFC] How implement Secure Data Path ?
Message-ID: <20150505175405.2787db4b@lxorguk.ukuu.org.uk>
In-Reply-To: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> First what is Secure Data Path ? SDP is a set of hardware features to garanty
> that some memories regions could only be read and/or write by specific hardware
> IPs. You can imagine it as a kind of memory firewall which grant/revoke
> accesses to memory per devices. Firewall configuration must be done in a trusted
> environment: for ARM architecture we plan to use OP-TEE + a trusted
> application to do that.

It's not just an ARM feature so any basis for this in the core code
should be generic, whether its being enforced by ARM SDP, various Intel
feature sets or even via a hypervisor.

> I have try 2 "hacky" approachs with dma_buf:
> - add a secure field in dma_buf structure and configure firewall in
>   dma_buf_{map/unmap}_attachment() functions.

How is SDP not just another IOMMU. The only oddity here is that it
happens to configure buffers the CPU can't touch and it has a control
mechanism that is designed to cover big media corp type uses where the
threat model is that the system owner is the enemy. Why does anything care
about it being SDP, there are also generic cases this might be a useful
optimisation (eg knowing the buffer isn't CPU touched so you can optimise
cache flushing).

The control mechanism is a device/platform detail as with any IOMMU. It
doesn't matter who configures it or how, providing it happens.

We do presumably need some small core DMA changes - anyone trying to map
such a buffer into CPU space needs to get a warning or error but what
else ?

> >From buffer allocation point of view I also facing a problem because when v4l2
> or drm/kms are exporting buffers by using dma_buf they don't attaching
> themself on it and never call dma_buf_{map/unmap}_attachment(). This is not
> an issue in those framework while it is how dma_buf exporters are
> supposed to work.

Which could be addressed if need be.

So if "SDP" is just another IOMMU feature, just as stuff like IMR is on
some x86 devices, and hypervisor enforced protection is on assorted
platforms why do we need a special way to do it ? Is there anything
actually needed beyond being able to tell the existing DMA code that this
buffer won't be CPU touched and wiring it into the DMA operations for the
platform ?

Alan
