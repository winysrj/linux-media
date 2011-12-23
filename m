Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65105 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354Ab1LWPzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Dec 2011 10:55:18 -0500
Received: by wibhm6 with SMTP id hm6so3246138wib.19
        for <linux-media@vger.kernel.org>; Fri, 23 Dec 2011 07:55:17 -0800 (PST)
Message-ID: <4EF4A45E.1070501@gmail.com>
Date: Fri, 23 Dec 2011 16:55:10 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	'javier Martin' <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, s.hauer@pengutronix.de,
	r.schwebel@pengutronix.de, 'Pawel Osciak' <p.osciak@gmail.com>
Subject: Re: MEM2MEM devices: how to handle sequence number?
References: <CACKLOr0H4enuADtWcUkZCS_V92mmLD8K5CgScbGo7w9nbT=-CA@mail.gmail.com> <201112231228.45439.laurent.pinchart@ideasonboard.com> <015401ccc166$ed3c2ab0$c7b48010$%szyprowski@samsung.com> <201112231254.08377.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201112231254.08377.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/23/2011 12:54 PM, Laurent Pinchart wrote:
>>>>> diff --git a/drivers/media/video/videobuf2-core.c
>>>>> b/drivers/media/video/videobuf2-core.c
>>>>> index 1250662..7d8a88b 100644
>>>>> --- a/drivers/media/video/videobuf2-core.c
>>>>> +++ b/drivers/media/video/videobuf2-core.c
>>>>> @@ -1127,6 +1127,7 @@ int vb2_qbuf(struct vb2_queue *q, struct
>>>>> v4l2_buffer *b)
>>>>>
>>>>>           */
>>>>>
>>>>>          list_add_tail(&vb->queued_entry,&q->queued_list);
>>>>>          vb->state = VB2_BUF_STATE_QUEUED;
>>>>>
>>>>> +       vb->v4l2_buf.sequence = b->sequence;
>>>>>
>>>>>          /*
>>>>>
>>>>>           * If already streaming, give the buffer to driver for
>>>>>           processing.
>>>>
>>>> Right, such patch is definitely needed. Please resend it with
>>>> 'signed-off-by' annotation.
>>>
>>> I'm not too sure about that. Isn't the sequence number supposed to be
>>> ignored by drivers on video output devices ? The documentation is a bit
>>> terse on the subject, all it says is
>>>
>>> __u32  sequence     Set by the driver, counting the frames in the
>>> sequence.
>>
>> We can also update the documentation if needed. IMHO copying sequence
>> number in mem2mem case if there is 1:1 relation between the buffers is a
>> good idea.
> 
> My point is that sequence numbers are currently not applicable to video output
> devices, at least according to the documentation. Applications will just set
> them to 0.

Looks like the documentation wasn't updated when the Memory-To-Memory interface
has been introduced.
 
> I think it would be better to have the m2m driver set the sequence number
> internally on the video output node by incrementing an counter, and pass it
> down the pipeline to the video capture node.

It sounds reasonable. Currently the sequence is zeroed at streamon in the
capture drivers. Similar behaviour could be assured by m2m drivers.
In Javier's case it's probably more reliable to check the sequence numbers
contiguity directly at the image source driver's device node.   

Although when m2m driver sets the sequence number internally on a video
output queue it could make sense to have the buffer's sequence number updated
upon return from VIDIOC_QBUF. What do you think ?

This would be needed for the object detection interface if we wanted to 
associate object detection result with a frame sequence number.

As far as the implementation is concerned, m2m and output drivers (with selected
capabilities only?) would have to update buffer sequence number from within
buf_queue vb2 queue op.


--
Regards,
Sylwester
