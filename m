Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45172 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbZJ1OHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 10:07:05 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Pawel Osciak <p.osciak@samsung.com>,
	"'Mauro Carvalho Chehab'" <mchehab@infradead.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Date: Wed, 28 Oct 2009 09:06:58 -0500
Subject: RE: V4L2_MEMORY_USERPTR support in videobuf-core
Message-ID: <A69FA2915331DC488A831521EAE36FE401557148D5@dlee06.ent.ti.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC07D2F45C6B@bssrvexch01.BS.local>
 <20091027103600.109b9afb@pedra.chehab.org>
 <002701ca5721$0cda97b0$268fc710$%osciak@samsung.com>
In-Reply-To: <002701ca5721$0cda97b0$268fc710$%osciak@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pawel,

We have been using USERPTR IO in our vpfe capture driver. I also want to
acknowledge the fact that the core layer expects index contrary to API
specs as you have pointed....

>Even if that was the case though, would an application be supposed to
>arbitrarily choose what index to pass? If so, how would it know what range
>is valid? And even if it would, the next check:
>(buf->state != VIDEOBUF_NEEDS_INIT && buf_state != VIDEOBUF_IDLE) would
>most

Why would this fails? The range that we use is based on the count in REQBUF.
This is similar to MMAP case. If for the same index, if you pass different pointer in QBUF, the core calls the buf_release() (which would set the
buffer state back to VIDEOBUF_NEEDS_INIT). So it works fine even if the
user ptr is different for same index.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Pawel Osciak
>Sent: Tuesday, October 27, 2009 12:18 PM
>To: 'Mauro Carvalho Chehab'
>Cc: linux-media@vger.kernel.org; kyungmin.park@samsung.com; Tomasz Fujak;
>Marek Szyprowski
>Subject: RE: V4L2_MEMORY_USERPTR support in videobuf-core
>
>Hi Mauro,
>thank you for your reply.
>
>On Tuesday, October 27, 2009 1:36 PM
>Mauro Carvalho Chehab [mailto:mchehab@infradead.org] wrote:
>
>>> could anybody confirm that there is no full/working support for USERPTR
>in
>>> current videobuf-core? That is the conclusion I came up with after a
>more
>>> thorough investigation.
>>>
>>> I am currently working to fix that, and will hopefully be posting
>patches in
>>> the coming days/weeks. Is there any other development effort underway
>related
>>> to this problem?
>>
>> (...)
>>The last time I tested the support for userptr at videobuf-core, it were
>>working on x86 plataforms. On that time, I used vivi with videobuf-dma-sg
>>for such tests (it were before its conversion to use videobuf-vmalloc).
>>As support for userptr on videobuf-vmalloc is missing, vivi can't be used
>>for such tests anymore (a good contribution would be to add userptr
>support
>>on videobuf-vmalloc).
>
>I might be missing something, but for me the path looks as follows
>(sources: kernel, LWN articles, V4L2 API Specification):
>
>1. open, query, format, other stuff, unimportant
>2. VIDEOBUF_REQBUFS - pass type and set memory to V4L2_MEMORY_USERPTR only.
>3. VIDEOBUF_QUERYBUFS - only for memory-mapped I/O, so not called.
>4. VIDEOBUF_QBUF - pass type, memory, userptr and length fields only.
>
>As the API Specification states in section 3.3:
>"No buffers are allocated beforehands, consequently they are not indexed
>and
>cannot be queried like mapped buffers with the VIDIOC_QUERYBUF ioctl."
>
>But when one calls QBUF, videobuf_qbuf() uses b->index for all types of
>memory.
>I have found no mention in the API Specs about passing/returning indexes in
>USERPTR, quite the contrary, they actually state that indexes are not used
>in that mode for neither REQBUFS nor QBUF at all.
>
>Even if that was the case though, would an application be supposed to
>arbitrarily choose what index to pass? If so, how would it know what range
>is valid? And even if it would, the next check:
>(buf->state != VIDEOBUF_NEEDS_INIT && buf_state != VIDEOBUF_IDLE) would
>most
>probably fail anyway.
>
>How to enqueue and handle multiple userptr buffers?
>
>Best regards
>--
>Pawel Osciak
>Linux Platform Group
>Samsung Poland R&D Center
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

