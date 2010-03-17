Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1487 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab0CQIAR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 04:00:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: Magic in videobuf
Date: Wed, 17 Mar 2010 08:59:50 +0100
Cc: "'Andy Walls'" <awalls@radix.net>,
	"'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
References: <E4D3F24EA6C9E54F817833EAE0D912AC09C7FCA3BF@bssrvexch01.BS.local> <37db8fe3121673cfbdce84e1de5ee844.squirrel@webmail.xs4all.nl> <000d01cac59e$20c1b1f0$624515d0$%osciak@samsung.com>
In-Reply-To: <000d01cac59e$20c1b1f0$624515d0$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003170859.50590.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 17 March 2010 07:50:27 Pawel Osciak wrote:
>>That is my opinion, yes. However, there is one case where this is actually
>>useful. Take for example the function videobuf_to_dma in
>>videobuf-dma-sg.c. This is called by drivers and it makes sense that that
>>function should double-check that the videobuf_buffer is associated with
>>the dma_sg memtype.
>>
>>But calling this 'magic' is a poor choice of name. There is nothing magic
>>about it, in this case it is just an identifier of the memtype. And there
>>may be better ways to do this check anyway.
>>
>>I have not done any analysis, but might be enough to check whether the
>>int_ops field of videobuf_queue equals the sg_ops pointer. If so, then the
>>whole magic handling can go away in this case.
>
>
> Well... I see this discussion is dragging on a bit.
> I will not be touching magics for now then, at least not until we arrive at
> a consensus sometime in the future.

You give up too easily :-)

But I agree that it is probably best to start with checkpatch cleanups.

I did a bit more research. The idea that I had to check the int_ops field
doesn't work at the moment because videobuf_qtype_ops contains a wild variety
of functions: some operate on a queue, some on a buffer. Some get a queue
pointer, but really should have gotten a buffer pointer. Ops like copy_to_user
and copy_stream shouldn't have been in the qtype at all, at least not in the
current form.

Anyway, it would help a lot if the qtype_ops are split into two structs: one
for queues, one for buffers. Each queue or buffer struct then has a pointer
to the ops. And that can be used by the qtype code as a check to detect
whether it is called from the right context.

Frankly, in the long term the queue-specific ops should probably be replaced
by buffer-specific ops anyway since we want to have a lot more flexibility
here and possible have different memory types per buffer (or even plane) on
the same queue.

It is my impression that all the queue-specific ops just walk over the buffers
anyway, so they can easily be replaced by buffer-specific ops and the 'walk over'
part can be moved to the core. So perhaps switching immediately to buffer-only
ops might actually be better than create separate queue and buffer ops.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
