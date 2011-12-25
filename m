Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44308 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab1LYVTN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 16:19:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: MEM2MEM devices: how to handle sequence number?
Date: Sun, 25 Dec 2011 22:19:10 +0100
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	"'javier Martin'" <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, s.hauer@pengutronix.de,
	r.schwebel@pengutronix.de, "'Pawel Osciak'" <p.osciak@gmail.com>
References: <CACKLOr0H4enuADtWcUkZCS_V92mmLD8K5CgScbGo7w9nbT=-CA@mail.gmail.com> <201112231254.08377.laurent.pinchart@ideasonboard.com> <4EF4A45E.1070501@gmail.com>
In-Reply-To: <4EF4A45E.1070501@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112252219.11412.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Friday 23 December 2011 16:55:10 Sylwester Nawrocki wrote:
> On 12/23/2011 12:54 PM, Laurent Pinchart wrote:
> >>>>> diff --git a/drivers/media/video/videobuf2-core.c
> >>>>> b/drivers/media/video/videobuf2-core.c
> >>>>> index 1250662..7d8a88b 100644
> >>>>> --- a/drivers/media/video/videobuf2-core.c
> >>>>> +++ b/drivers/media/video/videobuf2-core.c
> >>>>> @@ -1127,6 +1127,7 @@ int vb2_qbuf(struct vb2_queue *q, struct
> >>>>> v4l2_buffer *b)
> >>>>> 
> >>>>>           */
> >>>>>          
> >>>>>          list_add_tail(&vb->queued_entry,&q->queued_list);
> >>>>>          vb->state = VB2_BUF_STATE_QUEUED;
> >>>>> 
> >>>>> +       vb->v4l2_buf.sequence = b->sequence;
> >>>>> 
> >>>>>          /*
> >>>>>          
> >>>>>           * If already streaming, give the buffer to driver for
> >>>>>           processing.
> >>>> 
> >>>> Right, such patch is definitely needed. Please resend it with
> >>>> 'signed-off-by' annotation.
> >>> 
> >>> I'm not too sure about that. Isn't the sequence number supposed to be
> >>> ignored by drivers on video output devices ? The documentation is a bit
> >>> terse on the subject, all it says is
> >>> 
> >>> __u32  sequence     Set by the driver, counting the frames in the
> >>> sequence.
> >> 
> >> We can also update the documentation if needed. IMHO copying sequence
> >> number in mem2mem case if there is 1:1 relation between the buffers is a
> >> good idea.
> > 
> > My point is that sequence numbers are currently not applicable to video
> > output devices, at least according to the documentation. Applications
> > will just set them to 0.
> 
> Looks like the documentation wasn't updated when the Memory-To-Memory
> interface has been introduced.
> 
> > I think it would be better to have the m2m driver set the sequence number
> > internally on the video output node by incrementing an counter, and pass
> > it down the pipeline to the video capture node.
> 
> It sounds reasonable. Currently the sequence is zeroed at streamon in the
> capture drivers. Similar behaviour could be assured by m2m drivers.

I agree.

> In Javier's case it's probably more reliable to check the sequence numbers
> contiguity directly at the image source driver's device node.
> 
> Although when m2m driver sets the sequence number internally on a video
> output queue it could make sense to have the buffer's sequence number
> updated upon return from VIDIOC_QBUF. What do you think ?

Yes, that wouldn't hurt and could provide interesting information. In the 
general video output case it won't matter much, as the sequence numbers will 
be contiguous and won't be used by anything else, but in the mem-to-mem case 
it could let applications synchronize images with the video capture node on 
the mem-to-mem output. However, we can't always assume a 1-to-1 correspondance 
between an input (to the mem-to-mem device) and an output buffer, as more than 
one input buffer could be required to decompress a frame for instance. In that 
case, should the video capture node still report the sequence number used by 
the video output node ? If it does, there will be gaps in the video capture 
sequence numbers.

> This would be needed for the object detection interface if we wanted to
> associate object detection result with a frame sequence number.

Agreed, in that case that would be pretty interesting.

> As far as the implementation is concerned, m2m and output drivers (with
> selected capabilities only?) would have to update buffer sequence number
> from within buf_queue vb2 queue op.

-- 
Regards,

Laurent Pinchart
