Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:36302 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab1HVKGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Aug 2011 06:06:23 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH 1/6 v4] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Mon, 22 Aug 2011 12:06:25 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange> <Pine.LNX.4.64.1108161458510.13913@axis700.grange> <CAMm-=zCJBDzx=tzcnEU4RCS9jkbxDeDPDZsHRL5ZMHcdBMYivA@mail.gmail.com>
In-Reply-To: <CAMm-=zCJBDzx=tzcnEU4RCS9jkbxDeDPDZsHRL5ZMHcdBMYivA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108221206.25308.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for starting this discussion and then disappearing. I've been very
busy lately, so my apologies for that.

On Tuesday, August 16, 2011 18:14:33 Pawel Osciak wrote:
> Hi Guennadi,
> 
> On Tue, Aug 16, 2011 at 06:13, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Mon, 15 Aug 2011, Guennadi Liakhovetski wrote:
> >
> >> On Mon, 15 Aug 2011, Hans Verkuil wrote:
> >>
> >> > On Monday, August 15, 2011 13:28:23 Guennadi Liakhovetski wrote:
> >> > > Hi Hans
> >> > >
> >> > > On Mon, 8 Aug 2011, Hans Verkuil wrote:
> >
> > [snip]
> >
> >> > > > but I've changed my mind: I think
> >> > > > this should use a struct v4l2_format after all.
> >>
> >> While switching back, I have to change the struct vb2_ops::queue_setup()
> >> operation to take a struct v4l2_create_buffers pointer. An earlier 
version
> >> of this patch just added one more parameter to .queue_setup(), which is
> >> easier - changes to videobuf2-core.c are smaller, but it is then
> >> redundant. We could use the create pointer for both input and output. The
> >> video plane configuration in frame format is the same as what is
> >> calculated in .queue_setup(), IIUC. So, we could just let the driver fill
> >> that one in. This would require then the videobuf2-core.c to parse struct
> >> v4l2_format to decide which union member we need, depending on the buffer
> >> type. Do we want this or shall drivers duplicate plane sizes in separate
> >> .queue_setup() parameters?
> >
> > Let me explain my question a bit. The current .queue_setup() method is
> >
> >        int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
> >                           unsigned int *num_planes, unsigned int sizes[],
> >                           void *alloc_ctxs[]);
> >
> > To support multiple-size buffers we also have to pass a pointer to struct
> > v4l2_create_buffers to this function now. We can either do it like this:
> >
> >        int (*queue_setup)(struct vb2_queue *q,
> >                           struct v4l2_create_buffers *create,
> >                           unsigned int *num_buffers,
> >                           unsigned int *num_planes, unsigned int sizes[],
> >                           void *alloc_ctxs[]);
> >
> > and let all drivers fill in respective fields in *create, e.g., either do
> >
> >        create->format.fmt.pix_mp.plane_fmt[i].sizeimage = ...;
> >        create->format.fmt.pix_mp.num_planes = ...;
> >
> > and also duplicate it in method parameters
> >
> >        *num_planes = create->format.fmt.pix_mp.num_planes;
> >        sizes[i] = create->format.fmt.pix_mp.plane_fmt[i].sizeimage;
> >
> > or with
> >
> >        create->format.fmt.pix.sizeimage = ...;
> >
> > for single-plane. Alternatively we make the prototype
> >
> >        int (*queue_setup)(struct vb2_queue *q,
> >                           struct v4l2_create_buffers *create,
> >                           unsigned int *num_buffers,
> >                           void *alloc_ctxs[]);
> >
> > then drivers only fill in *create, and the videobuf2-core will have to
> > check create->format.type to decide, which of create->format.fmt.* is
> > relevant and extract plane sizes from there.
> 
> 
> Could we try exploring an alternative idea?
> The queue_setup callback was added to decouple formats from vb2 (and
> add some asynchronousness). But now we are doing the opposite, adding
> format awareness to vb2. Does vb2 really need to know about formats? I
> really believe it doesn't. It only needs sizes and counts. Also, we
> are actually complicating things I think. The proposal, IIUC, would
> look like this:
> 
> driver_queue_setup(..., create, num_buffers, [num_planes], ...)
> {
>     if (create != NULL && create->format != NULL) {
>         /* use create->fmt to fill sizes */

Right.

>     } else if (create != NULL) { /* this assumes we have both format or 
sizes */
>         /* use create->sizes to fill sizes */

No, create->format should always be set. If the application can fill in the
sizeimage field(s), then there is no need for create->sizes.

>     } else {
>         /* use currently selected format to fill sizes */

Right.

>     }
> }
> 
> driver_s_fmt(format)
> {
>     /* ... */
>     driver_fill_format(&create->fmt);
>     /* ... */
> }

???

> 
> driver_create_bufs(create)
> {
>     vb2_create_bufs(create);
> }
> 
> vb2_create_bufs(create)
> {
>     driver_queue_setup(..., create, ...);
>     vb2_fill_format(&create->fmt); /* note different from
> driver_fill_format(), but both needed */

Huh? Why call vb2_fill_format? vb2 should have no knowledge whatsoever about
formats. The driver needs that information in order to be able to allocate
buffers correctly since that depends on the required format. But vb2 doesn't
need that knowledge.

> }
> 
> vb2_reqbufs(reqbufs)
> {
>    driver_queue_setup(..., NULL, ...);
> }
> 
> The queue_setup not only becomes unnecessarily complicated, but I'm
> starting to question the convenience of it. And we are teaching vb2
> how to interpret format structs, even though vb2 only needs sizes, and
> even though the driver has to do it anyway and knows better how.

No, vb2 just needs to pass the format information from the user to the
driver.

There seems to be some misunderstanding here.

The point of my original suggestion that create_bufs should use v4l2_format
is that the driver needs the format information in order to decide how and
where the buffers have to be allocated. Having the format available is the
only reliable way to do that.

This is already done for REQBUFS since the driver will use the current format
to make these decisions.

One way of simplifying queue_setup is actually to always supply the format.
In the case of REQBUFS the driver might do something like this:

driver_reqbufs(requestbuffers)
{
	struct v4l2_format fmt;
	struct v4l2_create_buffers create;

	vb2_free_bufs(); // reqbufs should free any existing bufs
	if (requestbuffers->count == 0)
		return 0;
	driver_g_fmt(&fmt);	// call the g_fmt ioctl op
	// fill in create
	vb2_create_bufs(create);
}

So vb2 just sees a call requesting to create so many buffers for a particular
format, and it just hands that information over to the driver *without*
parsing it.

And the driver gets the request from vb2 to create X buffers for format F, and
will figure out how to do that and returns the buffer/plane/allocator context
information back to vb2.

Regards,

	Hans

> As for the idea to fill fmt in vb2, even if vb2 was to do it in
> create_bufs, some code to parse and fill the format fields would need
> to be in the driver anyway, because it still has to support s_fmt and
> friends. So adding that code to vb2 would duplicate it, and if the
> driver wanted to be non-standard in a way it filled the format fields,
> we'd not be allowing that.
> 
> My suggestion would be to remove queue_setup callback and instead
> modify vb2_reqbufs and vb2_create_bufs to accept sizes and number of
> buffers. I think it should simplify things both for drivers and vb2,
> would keep vb2 format-unaware and save us some round trips between vb2
> and driver:
> 
> driver_create_bufs(...) /* optional */
> {
>     /* use create->fmt (or sizes) */
>     ret = vb2_create_bufs(num_buffers, num_planes, buf_sizes,
> plane_sizes, alloc_ctxs);
>     fill_format(&create->fmt) /* because s_fmt has to do it anyway, so
> have a common function for that */
>     return ret;
> }
> 
> driver_reqbufs(...)
> {
>     /* use current format */
>     return vb2_reqbufs(num_buffers, num_planes, buf_sizes,
> plane_sizes, alloc_ctxs);
> }
> 
> And the call to both could easily converge into one in vb2, as the
> only difference is that vb2_reqbufs would need to free first, if any
> allocated buffers were present:
> 
> vb2_reqbufs(num_buffers, num_planes, buf_sizes, plane_sizes, alloc_ctxs)
> {
>     if (buffers_allocated(num_buffers, num_planes, buf_sizes,
> plane_sizes, alloc_ctxs)) {
>         free_buffers(...);
>     }
> 
>     return vb2_create_bufs(num_buffers, num_planes, buf_sizes,
> plane_sizes, alloc_ctxs);
> }
> 
> If the driver didn't want create_bufs, it'd just not implement it.
> What do you think?
> 
> -- 
> Best regards,
> Pawel Osciak
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
