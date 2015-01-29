Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33793 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458AbbA2SwL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 13:52:11 -0500
MIME-Version: 1.0
In-Reply-To: <20150129154718.GB26493@n2100.arm.linux.org.uk>
References: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org>
	<1422347154-15258-2-git-send-email-sumit.semwal@linaro.org>
	<20150129143908.GA26493@n2100.arm.linux.org.uk>
	<CAO_48GEOQ1pBwirgEWeVVXW-iOmaC=Xerr2VyYYz9t1QDXgVsw@mail.gmail.com>
	<20150129154718.GB26493@n2100.arm.linux.org.uk>
Date: Thu, 29 Jan 2015 13:52:09 -0500
Message-ID: <CAF6AEGtTmFg66TK_AFkQ-xp7Nd9Evk3nqe6xCBp7K=77OmXTxA@mail.gmail.com>
Subject: Re: [RFCv3 2/2] dma-buf: add helpers for sharing attacher constraints
 with dma-parms
From: Rob Clark <robdclark@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
	Tomasz Stanislawski <stanislawski.tomasz@googlemail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 29, 2015 at 10:47 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Jan 29, 2015 at 09:00:11PM +0530, Sumit Semwal wrote:
>> So, short answer is, it is left to the exporter to decide. The dma-buf
>> framework should not even attempt to decide or enforce any of the
>> above.
>>
>> At each dma_buf_attach(), there's a callback to the exporter, where
>> the exporter can decide, if it intends to handle these kind of cases,
>> on the best way forward.
>>
>> The exporter might, for example, decide to migrate backing storage,
>
> That's a decision which the exporter can not take.  Think about it...
>
> If subsystem Y has mapped the buffer, it could be accessing the buffer's
> backing storage at the same time that subsystem Z tries to attach to the
> buffer.

The *theory* is that Y is map/unmap'ing the buffer around each use, so
there will be some point where things could be migrated and remapped..
in practice, I am not sure that anyone is doing this yet.

Probably it would be reasonable if a more restrictive subsystem tried
to attach after the buffer was already allocated and mapped in a way
that don't meet the new constraints, then -EBUSY.

But from a quick look it seems like there needs to be a slight fixup
to not return 0 if calc_constraints() fails..

> Once the buffer has been exported to another user, the exporter has
> effectively lost control over mediating accesses to that buffer.
>
> All that it can do with the way the dma-buf API is today is to allocate
> a _different_ scatter list pointing at the same backing storage which
> satisfies the segment size and number of segments, etc.
>
> There's also another issue which you haven't addressed.  What if several
> attachments result in lowering max_segment_size and max_segment_count
> such that:
>
>         max_segment_size * max_segment_count < dmabuf->size
>
> but individually, the attachments allow dmabuf->size to be represented
> as a scatterlist?

Quite possibly for some of these edge some of cases, some of the
dma-buf exporters are going to need to get more clever (ie. hand off
different scatterlists to different clients).  Although I think by far
the two common cases will be "I can support anything via an iommu/mmu"
and "I need phys contig".

But that isn't an issue w/ dma-buf itself, so much as it is an issue
w/ drivers.  I guess there would be more interest in fixing up drivers
when actual hw comes along that needs it..

BR,
-R

> If an exporter were to take notice of the max_segment_size and
> max_segment_count, the resulting buffer is basically unrepresentable
> as a scatterlist.
>
>> > Please consider the possible sequences of use (such as the scenario
>> > above) when creating or augmenting an API.
>> >
>>
>> I tried to think of the scenarios I could think of, but If you still
>> feel this approach doesn't help with your concerns, I'll graciously
>> accept advice to improve it.
>
> See the new one above :)
>
> --
> FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
> according to speedtest.net.
