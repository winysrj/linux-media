Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39784 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab0CRPjK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 11:39:10 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KZH0099TI57N3@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 18 Mar 2010 15:39:07 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZH006OKI57QX@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 18 Mar 2010 15:39:07 +0000 (GMT)
Date: Thu, 18 Mar 2010 16:37:18 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH/RFC 0/2] Fix DQBUF behavior for recoverable streaming errors
In-reply-to: <201003181320.08756.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
Message-id: <003d01cac6b0$e4dccda0$ae9668e0$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1268836190-31051-1-git-send-email-p.osciak@samsung.com>
 <201003172105.19708.hverkuil@xs4all.nl>
 <201003181320.08756.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>Laurent Pinchart wrote:
>On Wednesday 17 March 2010 21:05:19 Hans Verkuil wrote:
>> On Wednesday 17 March 2010 15:29:48 Pawel Osciak wrote:
>> > Hello,
>> >
>> > during the V4L2 brainstorm meeting in Norway we have concluded that
>> > streaming error handling in dqbuf is lacking a bit and might result in
>> > the application losing video buffers.
>> >
>> > V4L2 specification states that DQBUF should set errno to EIO in such
>> > cases:
>> >
>> >
>> > "EIO
>> >
>> > VIDIOC_DQBUF failed due to an internal error. Can also indicate temporary
>> > problems like signal loss. Note the driver might dequeue an (empty)
>> > buffer despite returning an error, or even stop capturing."
>> >
>> > There is a problem with this though. v4l2-ioctl.c code does not copy back
>> > v4l2_buffer fields to userspace on a failed ioctl invocation, i.e. when
>> > __video_do_ioctl() does not return 0, it jumps over the copy_to_user()
>> > code:
>> >
>> > /* ... */
>> > err = __video_do_ioctl(file, cmd, parg);
>> > /* ... */
>> > if (err < 0)
>> >
>> > 	goto out;
>> >
>> > /* ... */
>> >
>> > 	if (copy_to_user((void __user *)arg, parg, _IOC_SIZE(cmd)))
>> >
>> > 		err = -EFAULT;
>> >
>> > /* ... */
>> > out:
>> >
>> >
>> > This is fine in general, but in the case of DQBUF errors, the v4l2_buffer
>> > fields are not copied back. Because of that, the application does not
>> > have any means of discovering on which buffer the operation failed. So
>> > it cannot reuse that buffer, even despite the fact that the spec allows
>> > such behavior.
>> >
>> >
>> > This RFC proposes a modification to the DQBUF behavior in cases of
>> > internal (recoverable) errors to allow recovery from such situations.
>> >
>> > We propose a new flag for the v4l2_buffer "flags" field,
>> > "V4L2_BUF_FLAG_ERROR". There already exists a "V4L2_BUF_FLAG_DONE" flag,
>> > so to support older applications, the new flag should always be set
>> > together with it.
>> >
>> > Applications unaware of the new flag would simply display a corrupted
>> > frame, but we believe it is still a better solution than failing
>> > altogether. Old EIO behavior remains so the change is backwards
>> > compatible.
>> >
>> > I will post relevant V4L2 documentation updates after (if) this change is
>> > accepted.
>> >
>> >
>> > This series is rebased onto my recent videobuf clean-up and poll behavior
>> > patches.
>> >
>> > The series contains:
>> > [PATCH 1/2] v4l: Add a new ERROR flag for DQBUF after recoverable
>> > streaming errors [PATCH 2/2] v4l: videobuf: Add support for
>> > V4L2_BUF_FLAG_ERROR
>>
>> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
>>
>> I think this is a very sensible change. After all, DQBUF succeeds, even
>> though the buffer itself contains errors. But that is not the fault of
>> DQBUF. It is enough to flag that the buffer does have an error. Without
>> this you actually loose the buffer completely from the point of view of
>> the application. And that's really nasty.
>
>Especially with the current wording of the spec:
>
>"Note the driver might dequeue an (empty) buffer despite returning an error,
>or even stop capturing."
>
>That's pretty bad. Because of video_ioctl2 the application won't know which
>buffer has been dequeued, if any, and will thus have no way to requeue it.
>
>Pavel, could you update the Docbook documentation as well in your patch set ?
>The behaviour of DQBUF needs to be properly documented.


Sure. Although I just noticed something. The spec for V4L2_BUF_FLAG_DONE says:

"When this flag is set, the buffer is currently on the outgoing queue,
ready to be dequeued from the driver. Drivers set or clear this flag when
the VIDIOC_QUERYBUF ioctl is called. After calling the VIDIOC_QBUF or
VIDIOC_DQBUF it is always cleared. Of course a buffer cannot be on both queues
at the same time, the V4L2_BUF_FLAG_QUEUED and V4L2_BUF_FLAG_DONE flag are
mutually exclusive. They can be both cleared however, then the buffer is in
"dequeued" state, in the application domain to say so."


So according to the spec, "DONE" means done but not yet returned to userspace.
So it should be cleared during dequeueing. But videobuf actually sets that
flag in dqbuf. And frankly, it seems more sensible to me.

Could you confirm that this is how we want it and I should follow the specs?
If so, I will "fix" videobuf to stop setting that flag.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





