Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37752 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab1HPQR7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 12:17:59 -0400
Received: by qyk38 with SMTP id 38so1483225qyk.19
        for <linux-media@vger.kernel.org>; Tue, 16 Aug 2011 09:17:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1108161458510.13913@axis700.grange>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
 <201108081116.41126.hansverk@cisco.com> <Pine.LNX.4.64.1108151324220.7851@axis700.grange>
 <201108151336.07258.hansverk@cisco.com> <Pine.LNX.4.64.1108151530410.7851@axis700.grange>
 <Pine.LNX.4.64.1108161458510.13913@axis700.grange>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 16 Aug 2011 09:14:33 -0700
Message-ID: <CAMm-=zCJBDzx=tzcnEU4RCS9jkbxDeDPDZsHRL5ZMHcdBMYivA@mail.gmail.com>
Subject: Re: [PATCH 1/6 v4] V4L: add two new ioctl()s for multi-size
 videobuffer management
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hansverk@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tue, Aug 16, 2011 at 06:13, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Mon, 15 Aug 2011, Guennadi Liakhovetski wrote:
>
>> On Mon, 15 Aug 2011, Hans Verkuil wrote:
>>
>> > On Monday, August 15, 2011 13:28:23 Guennadi Liakhovetski wrote:
>> > > Hi Hans
>> > >
>> > > On Mon, 8 Aug 2011, Hans Verkuil wrote:
>
> [snip]
>
>> > > > but I've changed my mind: I think
>> > > > this should use a struct v4l2_format after all.
>>
>> While switching back, I have to change the struct vb2_ops::queue_setup()
>> operation to take a struct v4l2_create_buffers pointer. An earlier version
>> of this patch just added one more parameter to .queue_setup(), which is
>> easier - changes to videobuf2-core.c are smaller, but it is then
>> redundant. We could use the create pointer for both input and output. The
>> video plane configuration in frame format is the same as what is
>> calculated in .queue_setup(), IIUC. So, we could just let the driver fill
>> that one in. This would require then the videobuf2-core.c to parse struct
>> v4l2_format to decide which union member we need, depending on the buffer
>> type. Do we want this or shall drivers duplicate plane sizes in separate
>> .queue_setup() parameters?
>
> Let me explain my question a bit. The current .queue_setup() method is
>
>        int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
>                           unsigned int *num_planes, unsigned int sizes[],
>                           void *alloc_ctxs[]);
>
> To support multiple-size buffers we also have to pass a pointer to struct
> v4l2_create_buffers to this function now. We can either do it like this:
>
>        int (*queue_setup)(struct vb2_queue *q,
>                           struct v4l2_create_buffers *create,
>                           unsigned int *num_buffers,
>                           unsigned int *num_planes, unsigned int sizes[],
>                           void *alloc_ctxs[]);
>
> and let all drivers fill in respective fields in *create, e.g., either do
>
>        create->format.fmt.pix_mp.plane_fmt[i].sizeimage = ...;
>        create->format.fmt.pix_mp.num_planes = ...;
>
> and also duplicate it in method parameters
>
>        *num_planes = create->format.fmt.pix_mp.num_planes;
>        sizes[i] = create->format.fmt.pix_mp.plane_fmt[i].sizeimage;
>
> or with
>
>        create->format.fmt.pix.sizeimage = ...;
>
> for single-plane. Alternatively we make the prototype
>
>        int (*queue_setup)(struct vb2_queue *q,
>                           struct v4l2_create_buffers *create,
>                           unsigned int *num_buffers,
>                           void *alloc_ctxs[]);
>
> then drivers only fill in *create, and the videobuf2-core will have to
> check create->format.type to decide, which of create->format.fmt.* is
> relevant and extract plane sizes from there.


Could we try exploring an alternative idea?
The queue_setup callback was added to decouple formats from vb2 (and
add some asynchronousness). But now we are doing the opposite, adding
format awareness to vb2. Does vb2 really need to know about formats? I
really believe it doesn't. It only needs sizes and counts. Also, we
are actually complicating things I think. The proposal, IIUC, would
look like this:

driver_queue_setup(..., create, num_buffers, [num_planes], ...)
{
    if (create != NULL && create->format != NULL) {
        /* use create->fmt to fill sizes */
    } else if (create != NULL) { /* this assumes we have both format or sizes */
        /* use create->sizes to fill sizes */
    } else {
        /* use currently selected format to fill sizes */
    }
}

driver_s_fmt(format)
{
    /* ... */
    driver_fill_format(&create->fmt);
    /* ... */
}

driver_create_bufs(create)
{
    vb2_create_bufs(create);
}

vb2_create_bufs(create)
{
    driver_queue_setup(..., create, ...);
    vb2_fill_format(&create->fmt); /* note different from
driver_fill_format(), but both needed */
}

vb2_reqbufs(reqbufs)
{
   driver_queue_setup(..., NULL, ...);
}

The queue_setup not only becomes unnecessarily complicated, but I'm
starting to question the convenience of it. And we are teaching vb2
how to interpret format structs, even though vb2 only needs sizes, and
even though the driver has to do it anyway and knows better how.

As for the idea to fill fmt in vb2, even if vb2 was to do it in
create_bufs, some code to parse and fill the format fields would need
to be in the driver anyway, because it still has to support s_fmt and
friends. So adding that code to vb2 would duplicate it, and if the
driver wanted to be non-standard in a way it filled the format fields,
we'd not be allowing that.

My suggestion would be to remove queue_setup callback and instead
modify vb2_reqbufs and vb2_create_bufs to accept sizes and number of
buffers. I think it should simplify things both for drivers and vb2,
would keep vb2 format-unaware and save us some round trips between vb2
and driver:

driver_create_bufs(...) /* optional */
{
    /* use create->fmt (or sizes) */
    ret = vb2_create_bufs(num_buffers, num_planes, buf_sizes,
plane_sizes, alloc_ctxs);
    fill_format(&create->fmt) /* because s_fmt has to do it anyway, so
have a common function for that */
    return ret;
}

driver_reqbufs(...)
{
    /* use current format */
    return vb2_reqbufs(num_buffers, num_planes, buf_sizes,
plane_sizes, alloc_ctxs);
}

And the call to both could easily converge into one in vb2, as the
only difference is that vb2_reqbufs would need to free first, if any
allocated buffers were present:

vb2_reqbufs(num_buffers, num_planes, buf_sizes, plane_sizes, alloc_ctxs)
{
    if (buffers_allocated(num_buffers, num_planes, buf_sizes,
plane_sizes, alloc_ctxs)) {
        free_buffers(...);
    }

    return vb2_create_bufs(num_buffers, num_planes, buf_sizes,
plane_sizes, alloc_ctxs);
}

If the driver didn't want create_bufs, it'd just not implement it.
What do you think?

-- 
Best regards,
Pawel Osciak
