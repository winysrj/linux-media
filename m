Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1281 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab0CXHwK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 03:52:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH/RFC 0/2] Fix DQBUF behavior for recoverable streaming errors
Date: Wed, 24 Mar 2010 08:52:34 +0100
Cc: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
References: <1268836190-31051-1-git-send-email-p.osciak@samsung.com> <201003181320.08756.laurent.pinchart@ideasonboard.com> <003d01cac6b0$e4dccda0$ae9668e0$%osciak@samsung.com>
In-Reply-To: <003d01cac6b0$e4dccda0$ae9668e0$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003240852.34962.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 18 March 2010 16:37:18 Pawel Osciak wrote:
> >Laurent Pinchart wrote:
> >On Wednesday 17 March 2010 21:05:19 Hans Verkuil wrote:
> >> On Wednesday 17 March 2010 15:29:48 Pawel Osciak wrote:
> >> > Hello,
> >> >
> >> > during the V4L2 brainstorm meeting in Norway we have concluded that
> >> > streaming error handling in dqbuf is lacking a bit and might result in
> >> > the application losing video buffers.
> >> >
> >> > V4L2 specification states that DQBUF should set errno to EIO in such
> >> > cases:
> >> >
> >> >
> >> > "EIO
> >> >
> >> > VIDIOC_DQBUF failed due to an internal error. Can also indicate temporary
> >> > problems like signal loss. Note the driver might dequeue an (empty)
> >> > buffer despite returning an error, or even stop capturing."
> >> >
> >> > There is a problem with this though. v4l2-ioctl.c code does not copy back
> >> > v4l2_buffer fields to userspace on a failed ioctl invocation, i.e. when
> >> > __video_do_ioctl() does not return 0, it jumps over the copy_to_user()
> >> > code:
> >> >
> >> > /* ... */
> >> > err = __video_do_ioctl(file, cmd, parg);
> >> > /* ... */
> >> > if (err < 0)
> >> >
> >> > 	goto out;
> >> >
> >> > /* ... */
> >> >
> >> > 	if (copy_to_user((void __user *)arg, parg, _IOC_SIZE(cmd)))
> >> >
> >> > 		err = -EFAULT;
> >> >
> >> > /* ... */
> >> > out:
> >> >
> >> >
> >> > This is fine in general, but in the case of DQBUF errors, the v4l2_buffer
> >> > fields are not copied back. Because of that, the application does not
> >> > have any means of discovering on which buffer the operation failed. So
> >> > it cannot reuse that buffer, even despite the fact that the spec allows
> >> > such behavior.
> >> >
> >> >
> >> > This RFC proposes a modification to the DQBUF behavior in cases of
> >> > internal (recoverable) errors to allow recovery from such situations.
> >> >
> >> > We propose a new flag for the v4l2_buffer "flags" field,
> >> > "V4L2_BUF_FLAG_ERROR". There already exists a "V4L2_BUF_FLAG_DONE" flag,
> >> > so to support older applications, the new flag should always be set
> >> > together with it.
> >> >
> >> > Applications unaware of the new flag would simply display a corrupted
> >> > frame, but we believe it is still a better solution than failing
> >> > altogether. Old EIO behavior remains so the change is backwards
> >> > compatible.
> >> >
> >> > I will post relevant V4L2 documentation updates after (if) this change is
> >> > accepted.
> >> >
> >> >
> >> > This series is rebased onto my recent videobuf clean-up and poll behavior
> >> > patches.
> >> >
> >> > The series contains:
> >> > [PATCH 1/2] v4l: Add a new ERROR flag for DQBUF after recoverable
> >> > streaming errors [PATCH 2/2] v4l: videobuf: Add support for
> >> > V4L2_BUF_FLAG_ERROR
> >>
> >> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
> >>
> >> I think this is a very sensible change. After all, DQBUF succeeds, even
> >> though the buffer itself contains errors. But that is not the fault of
> >> DQBUF. It is enough to flag that the buffer does have an error. Without
> >> this you actually loose the buffer completely from the point of view of
> >> the application. And that's really nasty.
> >
> >Especially with the current wording of the spec:
> >
> >"Note the driver might dequeue an (empty) buffer despite returning an error,
> >or even stop capturing."
> >
> >That's pretty bad. Because of video_ioctl2 the application won't know which
> >buffer has been dequeued, if any, and will thus have no way to requeue it.
> >
> >Pavel, could you update the Docbook documentation as well in your patch set ?
> >The behaviour of DQBUF needs to be properly documented.
> 
> 
> Sure. Although I just noticed something. The spec for V4L2_BUF_FLAG_DONE says:
> 
> "When this flag is set, the buffer is currently on the outgoing queue,
> ready to be dequeued from the driver. Drivers set or clear this flag when
> the VIDIOC_QUERYBUF ioctl is called. After calling the VIDIOC_QBUF or
> VIDIOC_DQBUF it is always cleared. Of course a buffer cannot be on both queues
> at the same time, the V4L2_BUF_FLAG_QUEUED and V4L2_BUF_FLAG_DONE flag are
> mutually exclusive. They can be both cleared however, then the buffer is in
> "dequeued" state, in the application domain to say so."
> 
> 
> So according to the spec, "DONE" means done but not yet returned to userspace.
> So it should be cleared during dequeueing. But videobuf actually sets that
> flag in dqbuf. And frankly, it seems more sensible to me.
> 
> Could you confirm that this is how we want it and I should follow the specs?
> If so, I will "fix" videobuf to stop setting that flag.

I think the spec makes sense, actually. But doesn't videobuf clear this already?

On ERROR and DONE videobuf_dqbuf will change the state to IDLE. videobuf_status
then won't set the DONE flag.

So as far as I can tell there is nothing that needs to change here.

Regards,

          Hans

> 
> 
> Best regards
> --
> Pawel Osciak
> Linux Platform Group
> Samsung Poland R&D Center
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
