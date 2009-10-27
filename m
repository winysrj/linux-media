Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39486 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbZJ0QTt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 12:19:49 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KS600JPWLD48W50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Oct 2009 16:19:52 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KS600C9WLD4E8@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Oct 2009 16:19:52 +0000 (GMT)
Date: Tue, 27 Oct 2009 17:17:59 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: V4L2_MEMORY_USERPTR support in videobuf-core
In-reply-to: <20091027103600.109b9afb@pedra.chehab.org>
To: 'Mauro Carvalho Chehab' <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	Tomasz Fujak <t.fujak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <002701ca5721$0cda97b0$268fc710$%osciak@samsung.com>
Content-language: pl
References: <E4D3F24EA6C9E54F817833EAE0D912AC07D2F45C6B@bssrvexch01.BS.local>
 <20091027103600.109b9afb@pedra.chehab.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
thank you for your reply.

On Tuesday, October 27, 2009 1:36 PM
Mauro Carvalho Chehab [mailto:mchehab@infradead.org] wrote:

>> could anybody confirm that there is no full/working support for USERPTR in
>> current videobuf-core? That is the conclusion I came up with after a more
>> thorough investigation.
>>
>> I am currently working to fix that, and will hopefully be posting patches in
>> the coming days/weeks. Is there any other development effort underway related
>> to this problem?
>
> (...)
>The last time I tested the support for userptr at videobuf-core, it were
>working on x86 plataforms. On that time, I used vivi with videobuf-dma-sg
>for such tests (it were before its conversion to use videobuf-vmalloc).
>As support for userptr on videobuf-vmalloc is missing, vivi can't be used
>for such tests anymore (a good contribution would be to add userptr support
>on videobuf-vmalloc).

I might be missing something, but for me the path looks as follows
(sources: kernel, LWN articles, V4L2 API Specification):

1. open, query, format, other stuff, unimportant
2. VIDEOBUF_REQBUFS - pass type and set memory to V4L2_MEMORY_USERPTR only.
3. VIDEOBUF_QUERYBUFS - only for memory-mapped I/O, so not called.
4. VIDEOBUF_QBUF - pass type, memory, userptr and length fields only.

As the API Specification states in section 3.3:
"No buffers are allocated beforehands, consequently they are not indexed and
cannot be queried like mapped buffers with the VIDIOC_QUERYBUF ioctl."

But when one calls QBUF, videobuf_qbuf() uses b->index for all types of memory.
I have found no mention in the API Specs about passing/returning indexes in
USERPTR, quite the contrary, they actually state that indexes are not used
in that mode for neither REQBUFS nor QBUF at all.

Even if that was the case though, would an application be supposed to
arbitrarily choose what index to pass? If so, how would it know what range
is valid? And even if it would, the next check:
(buf->state != VIDEOBUF_NEEDS_INIT && buf_state != VIDEOBUF_IDLE) would most
probably fail anyway.

How to enqueue and handle multiple userptr buffers?

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


