Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3341 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1HBIex (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 04:34:53 -0400
Message-ID: <8f4c70b8d38860d2403645fa773d8d42.squirrel@webmail.xs4all.nl>
In-Reply-To: <Pine.LNX.4.64.1108020919290.29918@axis700.grange>
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange>
    <CAMm-=zB3dOJyCy7ZhqiTQkeL2b=Dvtz8geMR8zbHYBCVR6=pEw@mail.gmail.com>
    <201107280856.55731.hverkuil@xs4all.nl>
    <Pine.LNX.4.64.1108020919290.29918@axis700.grange>
Date: Tue, 2 Aug 2011 10:33:47 +0200
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size
 videobuffer management
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Pawel Osciak" <pawel@osciak.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Sakari Ailus" <sakari.ailus@iki.fi>,
	"Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Thu, 28 Jul 2011, Hans Verkuil wrote:
>
>> On Thursday, July 28, 2011 06:11:38 Pawel Osciak wrote:
>> > Hi Guennadi,
>> >
>> > On Wed, Jul 20, 2011 at 01:43, Guennadi Liakhovetski
>> > <g.liakhovetski@gmx.de> wrote:
>> > > A possibility to preallocate and initialise buffers of different
>> sizes
>> > > in V4L2 is required for an efficient implementation of asnapshot
>> mode.
>> > > This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
>> > > VIDIOC_PREPARE_BUF and defines respective data structures.
>> > >
>> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> > > ---
>> > >
>> > <snip>
>> >
>> > This looks nicer, I like how we got rid of destroy and gave up on
>> > making holes, it would've given us a lot of headaches. I'm thinking
>> > about some issues though and also have some comments/questions further
>> > below.
>> >
>> > Already mentioned by others mixing of REQBUFS and CREATE_BUFS.
>> > Personally I'd like to allow mixing, including REQBUFS for non-zero,
>> > because I think it would be easy to do. I think it could work in the
>> > same way as REQBUFS for !=0 works currently (at least in vb2), if we
>> > already have some buffers allocated and they are not in use, we free
>> > them and a new set is allocated. So I guess it could just stay this
>> > way. REQBUFS(0) would of course free everything.
>> >
>> > Passing format to CREATE_BUFS will make vb2 a bit format-aware, as it
>> > would have to pass it forward to the driver somehow. The obvious way
>> > would be just vb2 calling the driver's s_fmt handler, but that won't
>> > work, as you can't pass indexes to s_fmt. So we'd have to implement a
>> > new driver callback for setting formats per index. I guess there is no
>> > way around it, unless we actually take the format struct out of
>> > CREATE_BUFS and somehow do it via S_FMT. The single-planar structure
>> > is full already though, the only way would be to use
>> > v4l2_pix_format_mplane instead with plane count = 1 (or more if
>> > needed).
>>
>> I just got an idea for this: use TRY_FMT. That will do exactly what
>> you want. In fact, perhaps we should remove the format struct from
>> CREATE_BUFS and use __u32 sizes[VIDEO_MAX_PLANES] instead. Let the
>> application call TRY_FMT and initialize the sizes array instead of
>> putting that into vb2. We may need a num_planes field as well. If the
>> sizes are all 0 (or num_planes is 0), then the driver can use the
>> current
>> format, just as it does with REQBUFS.
>>
>> Or am I missing something?
>
> ...After more thinking and looking at the vb2 code, this began to feel
> wrong to me. This introduces an asymmetry, which doesn't necessarily look
> good to me. At present we have the TRY_FMT and S_FMT ioctl()s, which among
> other tasks calculate sizeimage and bytesperline - either per plane or
> total.

Correct.

> Besides we also have the REQBUFS call, that internally calls the
> .queue_setup() queue method. In that method the _driver_ has a chance to
> calculate for the _current format_ the number of planes (again?...) and
> buffer sizes for each plane.

Correct. Usually the driver will update some internal datastructure
whenever S_FMT is called to store the sizeimage/bytesperline etc. so
queue_setup can refer to those values.

> This suggests, that the latter calculation
> can be different from the former.

No, it can't (shouldn't). For USERPTR mode applications always need to
rely on sizeimage anyway, so doing anything different in queue_setup is
something I would consider a driver bug.

> Now you're suggesting to use TRY_FMT to calculate the number of planes and
> per-plane sizeofimage, and then use _only_ this information to set up the
> buffers from the CREATE_BUFS ioctl(). So, are we now claiming, that this
> information alone (per-plane-sizeofimage) should be dufficient to set up
> buffers?

Yes. Again, if it is not sufficient, then USERPTR wouldn't work :-)

> OTOH, Pawel's above question has a simple answer: vb2 is not becoming
> format aware. It just passes the format on to the driver with the
> (modified) .queue_setup() method:
>
> diff --git a/include/media/videobuf2-core.h
> b/include/media/videobuf2-core.h
> index f87472a..f5a7d92 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -210,9 +216,10 @@ struct vb2_buffer {
>   *			the buffer back by calling vb2_buffer_done() function
>   */
>  struct vb2_ops {
> -	int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
> -			   unsigned int *num_planes, unsigned long sizes[],
> -			   void *alloc_ctxs[]);
> +	int (*queue_setup)(struct vb2_queue *q,
> +			 struct v4l2_create_buffers *create,
> +			 unsigned int *num_buffers, unsigned int *num_planes,
> +			 unsigned long sizes[], void *alloc_ctxs[]);
>
>  	void (*wait_prepare)(struct vb2_queue *q);
>  	void (*wait_finish)(struct vb2_queue *q);
>
> (of course, we would first add a new method, migrate all drivers, then
> remove the old one).

One thing I am not sure about is whether the v4l2_memory field should be
passed in per plane. One future extension to multiplanar is to allow a mix
of MMAP and USERPTR planes, but how useful that is is questionable.

Regards,

         Hans

>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>


