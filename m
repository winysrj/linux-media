Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4507 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab0KRMqO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 07:46:14 -0500
Message-ID: <c4b21e96adfbf59d9b89cbcce020c25a.squirrel@webmail.xs4all.nl>
In-Reply-To: <1290083190.2070.24.camel@morgan.silverblock.net>
References: <1289983174-2835-1-git-send-email-m.szyprowski@samsung.com>
    <1289983174-2835-2-git-send-email-m.szyprowski@samsung.com>
    <201011181017.39379.hverkuil@xs4all.nl>
    <1290083190.2070.24.camel@morgan.silverblock.net>
Date: Thu, 18 Nov 2010 13:46:02 +0100
Subject: Re: [PATCH 1/7] v4l: add videobuf2 Video for Linux 2 driver
 framework
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Andy Walls" <awalls@md.metrocast.net>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, pawel@osciak.com,
	kyungmin.park@samsung.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> Hi Hans and Marek,
>
> Some meta-comments below... ;)
>
> On Thu, 2010-11-18 at 10:17 +0100, Hans Verkuil wrote:
>> > +#define mem_ops(q, plane) ((q)->alloc_ctx[plane]->mem_ops)
>> > +
>> > +#define call_memop(q, plane, op, args...)				\
>> > +	(((q)->alloc_ctx[plane]->mem_ops->op) ?				\
>> > +		((q)->alloc_ctx[plane]->mem_ops->op(args)) : 0)
>>
>> Why not use mem_ops in the call_memop macro? That would simplify it a
>> bit.
>
> I think you meant
>
> "Why not use the the mem_ops macro in the call_memop macro?"

Yes, that's what I meant.

>
> Asking the user to pass in a mem_ops pointer as an argument to the
> call_memop() macro isn't a simplification, but that's how I first read
> your comment.

<snip>

>> > +
>> > +	if (req->count == 0) {
>> > +		/* Free/release memory for count = 0, but only if unused */
>> > +		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
>> > +			dprintk(1, "reqbufs: memory in use, cannot free\n");
>> > +			ret = -EBUSY;
>> > +			goto end;
>> > +		}
>> > +
>> > +		ret = __vb2_queue_free(q);
>>
>> OK, I have a problem here. How do I detect as an application whether a
>> driver
>> supports MMAP and/or USERPTR?
>>
>> What I am using in qv4l2 (and it doesn't work properly with videobuf) is
>> that
>> I call REQBUFS with count == 0 for MMAP and for USERPTR and I check
>> whether it
>> returns 0 or -EINVAL.
>
>
>> It seems a reasonable test since it doesn't allocate anything. It would
>> be nice
>> if vb2 can check for the memory field here based on what the driver
>> supports.
>>
>> Ideally we should make this an official part of the spec (or have some
>> other
>> mechanism to find out what it supported).
>
> Well it seems to be documented, just not clearly:
>
> First paragraph here:
> http://linuxtv.org/downloads/v4l-dvb-apis/mmap.html
>
> First & second Paragraph here:
> http://linuxtv.org/downloads/v4l-dvb-apis/userp.html
> (which mentions not allocating things.)
>
> And in the description here:
> http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-reqbufs.html

As you said, it is documented, sort of.

> I suppose  adding flags to VIDIOC_QUERYCAP results would remove all the
> hokey algorithmic probing of what the driver should already know.
>  http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-querycap.html
>
> V4L2_CAP_STREAMING            0x04000000
> V4L2_CAP_STREAMING_MMAP       0x08000000
> V4L2_CAP_STREAMING_USER_PTR   0x10000000

I don't think there is any need for yet more cap bits. If I can call
REQBUFS with count of 0 and it returns -EINVAL if the memory is incorrect,
then I'm happy. There is a small complication: the memory check should
happen before the check whether another capture is in progress. Otherwise
I would get back EBUSY and still not know if my requested memory type is
ok or not.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

