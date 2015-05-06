Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36063 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbbEFIqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2015 04:46:03 -0400
Received: by lbbqq2 with SMTP id qq2so2336212lbb.3
        for <linux-media@vger.kernel.org>; Wed, 06 May 2015 01:46:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150505175405.2787db4b@lxorguk.ukuu.org.uk>
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
	<20150505175405.2787db4b@lxorguk.ukuu.org.uk>
Date: Wed, 6 May 2015 10:46:01 +0200
Message-ID: <CA+M3ks4Mdg0oBSRTTKxYzQO4K5LNk7bS5kop4MPS8WA8XbewwA@mail.gmail.com>
Subject: Re: [RFC] How implement Secure Data Path ?
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-05-05 18:54 GMT+02:00 One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>:
>> First what is Secure Data Path ? SDP is a set of hardware features to garanty
>> that some memories regions could only be read and/or write by specific hardware
>> IPs. You can imagine it as a kind of memory firewall which grant/revoke
>> accesses to memory per devices. Firewall configuration must be done in a trusted
>> environment: for ARM architecture we plan to use OP-TEE + a trusted
>> application to do that.
>
> It's not just an ARM feature so any basis for this in the core code
> should be generic, whether its being enforced by ARM SDP, various Intel
> feature sets or even via a hypervisor.

I agree the core code should be generic, I was just mention OP-TEE to explain on
which context I'm working.

>
>> I have try 2 "hacky" approachs with dma_buf:
>> - add a secure field in dma_buf structure and configure firewall in
>>   dma_buf_{map/unmap}_attachment() functions.
>
> How is SDP not just another IOMMU. The only oddity here is that it
> happens to configure buffers the CPU can't touch and it has a control
> mechanism that is designed to cover big media corp type uses where the
> threat model is that the system owner is the enemy. Why does anything care
> about it being SDP, there are also generic cases this might be a useful
> optimisation (eg knowing the buffer isn't CPU touched so you can optimise
> cache flushing).
>

IOMMU interface doesn't offer API to manage buffer refcounting so you
will ignore
when you will have to stop protect the memory when using dma_buf you know
that the buffer is release when destroy function is called.
It is not only to not allow CPU to access to memory but also to
configure hardware
devices and firewall to be able to access to the memory.

> The control mechanism is a device/platform detail as with any IOMMU. It
> doesn't matter who configures it or how, providing it happens.
>
> We do presumably need some small core DMA changes - anyone trying to map
> such a buffer into CPU space needs to get a warning or error but what
> else ?
>
>> >From buffer allocation point of view I also facing a problem because when v4l2
>> or drm/kms are exporting buffers by using dma_buf they don't attaching
>> themself on it and never call dma_buf_{map/unmap}_attachment(). This is not
>> an issue in those framework while it is how dma_buf exporters are
>> supposed to work.
>
> Which could be addressed if need be.
>
> So if "SDP" is just another IOMMU feature, just as stuff like IMR is on
> some x86 devices, and hypervisor enforced protection is on assorted
> platforms why do we need a special way to do it ? Is there anything
> actually needed beyond being able to tell the existing DMA code that this
> buffer won't be CPU touched and wiring it into the DMA operations for the
> platform ?
>
> Alan



-- 
Benjamin Gaignard

Graphic Working Group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
